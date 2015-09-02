--[[
Copyright (c) 2014 Google Inc.

See LICENSE file for full terms of limited license.
]]

if not dqn then
    require 'initenv'
end

local nql = torch.class('dqn.NeuralQLearner')


function nql:__init(args)
    self.images_width   = args.images_width
    self.images_height  = args.images_height
    self.state_dim      = args.state_dim -- State dimensionality.
    self.actions        = args.actions
    self.n_actions      = #self.actions
    self.verbose        = args.verbose
    self.best           = args.best

    --- epsilon annealing
    self.ep_start   = args.ep or 1
    self.ep         = self.ep_start -- Exploration probability.
    self.ep_end     = args.ep_end or self.ep
    self.ep_endt    = args.ep_endt or 1000000

    ---- learning rate annealing
    self.lr_start       = args.lr or 0.01 --Learning rate.
    self.lr             = self.lr_start
    self.lr_end         = args.lr_end or self.lr
    self.lr_endt        = args.lr_endt or 1000000
    self.wc             = args.wc or 0  -- L2 weight cost.
    self.minibatch_size = args.minibatch_size or 1
    self.valid_size     = args.valid_size or 500

    --- Q-learning parameters
    self.discount       = args.discount or 0.99 --Discount factor.
    self.update_freq    = args.update_freq or 1
    -- Number of points to replay per learning step.
    self.n_replay       = args.n_replay or 1
    -- Number of steps after which learning starts.
    self.learn_start    = args.learn_start or 0
     -- Size of the transition table.
    self.replay_memory  = args.replay_memory or 1000000
    self.hist_len       = args.hist_len or 1
    self.rescale_r      = args.rescale_r
    self.max_reward     = args.max_reward
    self.min_reward     = args.min_reward
    self.clip_delta     = args.clip_delta
    self.target_q       = args.target_q
    self.bestq          = 0

    self.gpu            = args.gpu

    self.ncols          = args.ncols or 1  -- number of color channels in input
    self.input_dims     = args.input_dims or {self.hist_len*self.ncols, self.images_width, self.images_height} -- TODO or width, height?
    self.preproc        = args.preproc  -- name of preprocessing network
    self.histType       = args.histType or "linear"  -- history type to use
    self.histSpacing    = args.histSpacing or 1
    self.nonTermProb    = args.nonTermProb or 1
    self.bufferSize     = args.bufferSize or 512

    self.transition_params = args.transition_params or {}

    self.network    = args.network or self:createNetwork()

    -- check whether there is a network file
    local network_function
    if not (type(self.network) == 'string') then
        error("The type of the network provided in NeuralQLearner" ..
              " is not a string!")
    end

    local msg, err = pcall(require, self.network)
    if not msg then
        -- try to load saved agent
        local err_msg, exp = pcall(torch.load, self.network)
        if not err_msg then
            error("Could not find network file ")
        end
        if self.best and exp.best_model then
            self.network = exp.best_model
        else
            self.network = exp.model
        end
    else
        print('Creating Agent Network from ' .. self.network)
        self.network = err
        self.network = self:network()
    end

    if self.gpu and self.gpu >= 0 then
        self.network:cuda()
    else
        self.network:float()
    end

    -- Load preprocessing network.
    if not (type(self.preproc == 'string')) then
        error('The preprocessing is not a string')
    end
    msg, err = pcall(require, self.preproc)
    if not msg then
        error("Error loading preprocessing net")
    end
    self.preproc = err
    self.preproc = self:preproc()
    self.preproc:float()

    if self.gpu and self.gpu >= 0 then
        self.network:cuda()
        self.tensor_type = torch.CudaTensor
    else
        self.network:float()
        self.tensor_type = torch.FloatTensor
    end

    -- Create transition table.
    ---- assuming the transition table always gets floating point input
    ---- (Foat or Cuda tensors) and always returns one of the two, as required
    ---- internally it always uses ByteTensors for states, scaling and
    ---- converting accordingly
    local transition_args = {
        images_width   = self.images_width,
        images_height  = self.images_height,
        minibatch_size = self.minibatch_size,
        stateDim = self.state_dim, numActions = self.n_actions,
        histLen = self.hist_len, gpu = self.gpu,
        maxSize = self.replay_memory, histType = self.histType,
        histSpacing = self.histSpacing, nonTermProb = self.nonTermProb,
        bufferSize = self.bufferSize
    }

    self.transitions = dqn.TransitionTable(transition_args)

    self.numSteps = 0 -- Number of perceived states.
    self.lastState = nil
    self.lastAction = nil
    self.v_avg = 0 -- V running average.
    self.tderr_avg = 0 -- TD error running average.

    self.q_max = 1
    self.r_max = 1

    self.w, self.dw = self.network:getParameters()
    self.dw:zero()

    self.deltas = self.dw:clone():fill(0)

    self.tmp= self.dw:clone():fill(0)
    self.g  = self.dw:clone():fill(0)
    self.g2 = self.dw:clone():fill(0)

    if self.target_q then
        self.target_network = self.network:clone()
    end
end


function nql:reset(state)
    if not state then
        return
    end
    self.best_network = state.best_network
    self.network = state.model
    self.w, self.dw = self.network:getParameters()
    self.dw:zero()
    self.numSteps = 0
    print("RESET STATE SUCCESFULLY")
end


function nql:preprocess(rawstate)
    if self.preproc then
        assert(rawstate:max() <= 255, "Raw state values must be in [0, 255]") -- TODO: remove for time optim
        return self.preproc:forward(rawstate:float()):clone():reshape(self.state_dim):div(255)
    end

    return rawstate
end


-- tensor does not contain nan values
function no_nan(x)
  if x == nil then return true end
  local nan_indices = x:ne(x)
  local sum = nan_indices:sum()
  if sum ~= 0 then
    print("nan indices:")
    print(nan_indices)
    return false
  else
    return true
  end
end

-- value not nan
function not_nan(x) return x == x end

-- TODO move
local i_tmp = 0
local mean_delta_hist_size = 1000
mean_delta_hist = torch.zeros(mean_delta_hist_size)
require('gnuplot')

function nql:getQUpdate(args)
    -- TODO remove
    target_q_net = self.network

    local s, a, r, s2, term, delta
    local q, q2, q2_max

    s = args.s
    a = args.a
    r = args.r
    s2 = args.s2
    term = args.term
    -- The order of calls to forward is a bit odd in order
    -- to avoid unnecessary calls (we only need 2).

    -- delta = r + (1-terminal) * gamma * max_a Q(s2, a) - Q(s, a)
    term = term:clone():float():mul(-1):add(1)

    -- TODO remove
    --[[
    assert(no_nan(s), "Contains nan values")
    assert(no_nan(a), "Contains nan values")
    assert(no_nan(r), "Contains nan values")
    assert(no_nan(s2), "Contains nan values")
    assert(no_nan(term), "Contains nan values")
    --]]

    -- TODO remove
    --[[
    for i = 1, 11 do
      if not no_nan(target_q_net:get(i).weight) then
        print("weights " .. i .. ":")
        print(target_q_net:get(i).weight)
        assert(false, "module " .. i .. " weights contain nan values")
      end
    end
    --]]

    -- TODO remove
    --[[
    assert(s2:max() <= 1, "State values must be in [0, 1] but " .. s2:max() .. " found") -- TODO: remove
    --]]

    -- Compute max_a Q(s_2, a).
    q2_max = target_q_net:forward(s2):float():max(2)

    -- TODO remove
    --[[
    for i = 1, 11 do
      if not no_nan(target_q_net:get(i).weight) then
        print("weights " .. i .. ":")
        print(target_q_net:get(i).weight)
        assert(false, "module " .. i .. " weights contain nan values")
      end
    end
    --]]

    -- TODO remove
    --[[
    if not no_nan(q2_max) then
        print("q2_max:")
        print(q2_max)
        assert(false, "q2_max contains nan values")
    end
    --]]

    -- Compute q2 = (1-terminal) * gamma * max_a Q(s2, a)
    q2 = q2_max:clone():mul(self.discount):cmul(term)

    -- TODO remove
    --[[
    if not no_nan(q2) then
        print("q2:")
        print(q2)
        assert(false, "q2 contains nan values")
    end
    --]]

    delta = r:clone():float()
    if self.rescale_r then delta:div(self.r_max) end
    delta:add(q2)

    -- TODO remove
    --[[
    if not no_nan(delta) then
        print("delta:")
        print(delta)
        assert(false, "delta contains nan values")
    end
    --]]

    -- q = Q(s,a)

    -- TODO remove
    --[[
    assert(s:max() <= 1, "State values must be in [0, 1]")
    --]]

    local q_all = self.network:forward(s):float()

    -- TODO remove
    --[[
    if not no_nan(q_all) then
        print("q_all:")
        print(q_all)
        assert(false, "q_all contains nan values")
    end
    --]]

    q = torch.FloatTensor(q_all:size(1))
    for i=1,q_all:size(1) do
        q[i] = q_all[i][a[i]]
    end

    -- TODO remove
    --[[
    if not no_nan(q) then
        print("q:")
        print(q)
        assert(false, "q contains nan values")
    end
    --]]

    delta:add(-1, q)

    -- TODO remove
    --[[
    if not not_nan(delta_mean) then
        print("delta_mean:")
        print(delta_mean)
        assert(false, "delta_mean contains nan values")
    end
    --]]

    --[[
    local plot_freq = 10 --10
    if i_tmp % plot_freq == 0 then
      mean_delta_hist[1 + ((self.numSteps / plot_freq - 1) % mean_delta_hist_size)] = delta_mean
      gnuplot.plot(mean_delta_hist)
    end
    --[[ ]]

    if self.clip_delta then
        delta[delta:ge(self.clip_delta)] = self.clip_delta
        delta[delta:le(-self.clip_delta)] = -self.clip_delta
    end

    local targets = torch.zeros(self.minibatch_size, self.n_actions):float()
    for i=1,math.min(self.minibatch_size,a:size(1)) do
        targets[i][a[i]] = delta[i]
    end
    
    -- TODO remove
    --[[
    if not not_nan(delta_mean) then
        print("delta_mean:")
        print(delta_mean)
        assert(false, "delta_mean contains nan values")
    end
    --]]

    if self.gpu >= 0 then targets = targets:cuda() end
    
    local delta_mean = delta:mean()
    step_message = step_message .. string.format("delta mean: %.5f", delta_mean) .. " "

    return targets, delta, q2_max
end


function nql:qLearnMinibatch(s, a, r, s2, term)
    -- Perform a minibatch Q-learning update:
    -- w += alpha * (r + gamma max Q(s2,a2) - Q(s,a)) * dQ(s,a)/dw

    --[[
    --if i_tmp % 10 == 0 then
      local screen_height = self.images_height * 2
      local screen_width = self.images_width * 2
      local screen = torch.Tensor(self.minibatch_size, 3, screen_height, screen_width)
      for i = 1, self.minibatch_size do
        screen[{{i}, {1},{},{}}] = image.scale(s[i]:clone():reshape(self.images_height, self.images_width), screen_width, screen_height, "simple")
        screen[{{i}, {2},{},{}}] = image.scale(s2[i]:clone():reshape(self.images_height, self.images_width), screen_width, screen_height, "simple")
        screen[{{i}, {3}, {}, {}}]:fill(1)
        if a[i] == 1 then screen[{{i}, {3},{screen_height/4,screen_height/2},{screen_width/2-3,screen_width/2+3}}]:fill(0)
        elseif a[i] == 2 then screen[{{i}, {3},{screen_height/2,3*screen_height/4},{screen_width/2-3,screen_width/2+3}}]:fill(0)
        elseif a[i] == 3 then screen[{{i}, {3},{screen_height/2-3,screen_height/2+3},{screen_width/4,screen_width/2}}]:fill(0)
        elseif a[i] == 4 then screen[{{i}, {3},{screen_height/2-3,screen_height/2+3},{screen_width/2,3*screen_width/4}}]:fill(0) end
        if r[i] ~= 0 then screen[{{i}, {3},{},{}}]:mul(-1):add(1) end
      end
      win_transitions = image.display{image=screen, min=0, max=1, win=win_transitions, legend="transitions"}
    --end
    --]]
    i_tmp = i_tmp + 1

    local targets, delta, q2_max = self:getQUpdate{s=s, a=a, r=r, s2=s2, term=term, update_qmax=true}

    -- zero gradients of parameters
    self.dw:zero()

    -- get new gradient
    self.network:backward(s, targets) -- dw changes, never call getParameters, to keep dw connected!

    -- add weight cost to gradient
    self.dw:add(-self.wc, self.w) -- wc: L2 weight cost 0 --> dw = 0

    -- compute linearly annealed learning rate
    local t = math.max(0, self.numSteps - self.learn_start)
    self.lr = (self.lr_start - self.lr_end) * (self.lr_endt - t)/self.lr_endt + self.lr_end
    self.lr = math.max(self.lr, self.lr_end)
    step_message = step_message .. "lr: " .. self.lr .. " "

    -- use gradients
    self.g:mul(0.95):add(0.05, self.dw)
    self.tmp:cmul(self.dw, self.dw)
    self.g2:mul(0.95):add(0.05, self.tmp)
    self.tmp:cmul(self.g, self.g)
    self.tmp:mul(-1)
    self.tmp:add(self.g2)
    self.tmp:add(0.01)
    self.tmp:sqrt()

    -- accumulate update
    self.deltas:mul(0):addcdiv(self.lr, self.dw, self.tmp)
    self.w:add(self.deltas)

    step_message = step_message .. "deltas_mean: " .. string.format("%.8f", self.deltas:mean()) .. " w_mean: " .. string.format("%.8f", self.w:mean()) .. " "

    --print(-self.wc, self.w:mean(), self.dw:mean(), self.tmp:mean(), self.deltas:mean(), self.w:mean())
end


function nql:sample_validation_data()
    local s, a, r, s2, term = self.transitions:sample(self.valid_size)
    self.valid_s    = s:clone()
    self.valid_a    = a:clone()
    self.valid_r    = r:clone()
    self.valid_s2   = s2:clone()
    self.valid_term = term:clone()
end


function nql:compute_validation_statistics()
    local targets, delta, q2_max = self:getQUpdate{s=self.valid_s,
        a=self.valid_a, r=self.valid_r, s2=self.valid_s2, term=self.valid_term}

    self.v_avg = self.q_max * q2_max:mean()
    print("compute v_avg", self.q_max, q2_max:mean(), self.v_avg)
    self.tderr_avg = delta:clone():abs():mean()
end


--[[
local win1
function nql:perceive(reward, rawstate, terminal, testing, testing_ep)
    -- Preprocess state
    local state = self:preprocess(rawstate):float()                                                   -- DONE
    win1 = image.display({image=state:clone():reshape(self.images_height,
                          self.images_width), min=0, max=255, win=win1, legend="state"})

    if self.max_reward then                                                                           -- DONE
        reward = math.min(reward, self.max_reward)                                                    -- DONE
    end
    if self.min_reward then
        reward = math.max(reward, self.min_reward)                                                    -- DONE
    end
    if self.rescale_r then
        self.r_max = math.max(self.r_max, reward)                                                     -- DONE
    end

    self.transitions:add_recent_state(state, terminal)                                                -- DONE

    local currentFullState = self.transitions:get_recent()                                            -- DONE

    --Store transition s, a, r, s'
    if self.lastState and not testing then
        self.transitions:add(self.lastState, self.lastAction, reward, self.lastTerminal, priority)    -- DONE
    end

    if self.numSteps == self.learn_start+1 and not testing then
        self:sample_validation_data()                                                                     -- ????
    end

    local curState = self.transitions:get_recent()                                                    -- DONE
    curState = curState:resize(1, unpack(self.input_dims))                                            -- DONE

    -- Select action
    local actionIndex = 1                                                                             -- DONE
    if not terminal then                                                                              -- DONE
        actionIndex = self:eGreedy(curState, testing_ep)                                              -- DONE
    end

    self.transitions:add_recent_action(actionIndex)                                                   -- DONE

    --Do some Q-learning updates
    if self.numSteps > self.learn_start and not testing and                                           -- DONE
        self.numSteps % self.update_freq == 0 then                                                    -- DONE
        print("performing a Q-Learning update")                                                       -- DONE
        for i = 1, self.n_replay do                                                                   -- DONE
            self:qLearnMinibatch()                                                                    -- DONE
        end
    end

    if not testing then
        self.numSteps = self.numSteps + 1
    end

    self.lastState = state:clone()                                                                    -- DONE
    self.lastAction = actionIndex                                                                     -- DONE
    self.lastTerminal = terminal                                                                      -- DONE

    if self.target_q and self.numSteps % self.target_q == 1 then
        self.target_network = self.network:clone()                                                    -- DONE
    end

    if not terminal then
        return actionIndex                                                                            -- DONE
    else
        return 0
    end
end
--]]


function nql:choose_action(state, testing_ep)
  local img = state:clone():reshape(agent.images_height, agent.images_width)
  choose_camera = image.display({image=image.scale(img, agent.images_width * 5, agent.images_height * 5, "simple"), min=0, max=1, win=choose_camera, legend="choose_action"})

  --self.transitions:add_recent_state(state, false)
  local curState = state:clone() --self.transitions:get_recent()
  curState = curState:resize(1, unpack(self.input_dims))

  local actionIndex = self:eGreedy(curState, testing_ep)
  --self.transitions:add_recent_action(actionIndex, false)

  return actionIndex
end


function nql:eGreedy(state, testing_ep)
    --
    local q = self.network:forward(state):float():squeeze()
    local layer_output = self.network:get(2).output[1]

    layer_win = image.display{image=layer_output, win=layer_win, legend="layer_output"}
    step_message = step_message .. "modules mean: { "
    for i = 1, 11 do
      step_message = step_message .. string.format("%.3f", self.network:get(i).output:mean()) .. " "
    end
    step_message = step_message .. "} "
    --

    step_message = step_message .. "q: { "
    for i = 1, (#q)[1] do
        step_message = step_message .. string.format("%+.3f", q[i]) .. " "
    end
    step_message = step_message .. "} "

    -- determine epsilon
    self.ep = testing_ep or math.max(0.01, 0.9 - self.numSteps/100000) --(self.ep_end + math.max(0, (self.ep_start - self.ep_end) * (self.ep_endt - math.max(0, self.numSteps - self.learn_start))/self.ep_endt))
    -- Epsilon greedy
    step_message = step_message .. "epsilon: " .. string.format("%.3f", self.ep) .. " "
    if torch.uniform() < self.ep then
        local action_index = torch.random(1, self.n_actions)
        step_message = step_message .. "random action: " .. action_index .. " "
        return action_index
    else
        local action_index = self:greedy(state)
        step_message = step_message .. "greedy action: " .. action_index .. " "
        return action_index
    end
end


function nql:greedy(state)
    -- Turn single state into minibatch.  Needed for convolutional nets.
    if state:dim() == 2 then
        assert(false, 'Input must be at least 3D')
        state = state:resize(1, state:size(1), state:size(2))
    end

    if self.gpu >= 0 then
        state = state:cuda()
    end

    assert(state:max() <= 1, "State values must be in [0, 1]")
    local q = self.network:forward(state):float():squeeze()

    local maxq = q[1]
    local besta = {1}

    -- Evaluate all other actions (with random tie-breaking)
    for a = 2, self.n_actions do
        if q[a] > maxq then
            besta = { a }
            maxq = q[a]
        elseif q[a] == maxq then
            besta[#besta+1] = a
        end
    end
    self.bestq = maxq

    local r = torch.random(1, #besta)

    return besta[r]
end


function nql:save_transitions(previous_state, previous_action, reward, terminal)
    if self.max_reward then reward = math.min(reward, self.max_reward) end
    if self.min_reward then reward = math.max(reward, self.min_reward) end
    if self.rescale_r then self.r_max = math.max(self.r_max, reward) end

    --local currentFullState = self.transitions:get_recent()

    -- Store s, a, r, t
    if previous_state and previous_action then
        self.transitions:add(previous_state, previous_action, reward, terminal)
    else
        print("first transition")
    end

    --[[
    self.lastState = state:clone()
    self.lastAction = actionIndex
    self.lastTerminal = terminal
    --]]
end


function nql:learn()
    self.numSteps = self.numSteps + 1

    assert(self.transitions:size() > self.minibatch_size)

    local s, a, r, s2, term = self.transitions:sample(self.minibatch_size)
    step_message = step_message .. "n_r: " .. r:sum() .. " "

    --Do some Q-learning updates
    --if self.numSteps > self.learn_start and self.numSteps % self.update_freq == 0 then -- TODO: what?
    local step_message_pre_size = #step_message

    for i = 1, self.n_replay do
      local space = " "
      if i > 1 then
        print(step_message)
        step_message = space:rep(step_message_pre_size)
      end

      self:qLearnMinibatch(s, a, r, s2, term)
    end

    --if self.target_q and self.numSteps % self.target_q == 1 then -- TODO
       self.target_network = self.network --self.network:clone()
    --end
end


function nql:createNetwork()
    local n_hid = 128
    local mlp = nn.Sequential()
    mlp:add(nn.Reshape(self.hist_len*self.ncols*self.state_dim))
    mlp:add(nn.Linear(self.hist_len*self.ncols*self.state_dim, n_hid))
    mlp:add(nn.Rectifier())
    mlp:add(nn.Linear(n_hid, n_hid))
    mlp:add(nn.Rectifier())
    mlp:add(nn.Linear(n_hid, self.n_actions))

    return mlp
end


function nql:_loadNet()
    local net = self.network
    if self.gpu then
        net:cuda()
    else
        net:float()
    end
    return net
end


function nql:init(arg)
    self.actions = arg.actions
    self.n_actions = #self.actions
    self.network = self:_loadNet()
    -- Generate targets.
    self.transitions:empty()
end


function nql:report()
    print(get_weight_norms(self.network))
    print(get_grad_norms(self.network))
end
