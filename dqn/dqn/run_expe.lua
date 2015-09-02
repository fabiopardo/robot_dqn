-- parse arguments

require 'torch'

display_available = (arg[-1] == 'qlua')

local cmd = torch.CmdLine()

cmd:option('-expe_mode', 'train', 'experiment mode')
cmd:option('-load_transitions', '', 'load transitions from file')
cmd:option('-save_transitions', '', 'save transitions in file')
cmd:option('-save_network', '', 'save network in file')
--cmd:option('-save_agent', '', 'save agent in file')
cmd:option('-saveNetworkParams', false, 'saves the agent network in a separate file')
cmd:option('-network', 'convnet_atari3', 'reload pretrained network')
cmd:option('-n_replay', 3, 'Number of points to replay per learning step')
cmd:option('-sleep', -1, 'Time to sleep when not learning')

cmd:option('-agent', 'NeuralQLearner', 'name of agent implementation file to use')
cmd:option('-framework', 'robot_expe', 'environment framework') -- original value: 'alewrap'

--cmd:option('-env', '', 'name of environment to use')
--cmd:option('-game_path', '', 'path to environment file (ROM)')

--cmd:option('-update_freq', 4, 'TODO')
cmd:option('-discount', 0.99, 'TODO')
cmd:option('-seed', 1, 'fixed input seed for repeatable experiments')
cmd:option('-minibatch_size', 32, 'TOTO') -- original value:32
cmd:option('-bufferSize', 64, 'TOTO')
cmd:option('-learn_start', 1, 'TOTO') -- TODO allow learning even without full buffer
cmd:option('-pool_frms_type', 'max', 'TODO')
cmd:option('-pool_frms_size', 2, 'TODO')
cmd:option('-initial_priority', 'false', 'TODO')
cmd:option('-replay_memory', 500000, 'TODO') -- original value: 1000000
--cmd:option('-actrep', 1, 'how many times to repeat action')

cmd:option('-ep', 1, 'TODO')
cmd:option('-eps_end', 0.1, 'TODO')
cmd:option('-eps_endt', 500000, 'TODO')

cmd:option('-lr', 0.00025, 'TODO') -- original value: 0.00025
cmd:option('-agent_type', 'DQN3_0_1', 'TODO')
cmd:option('-preproc', 'net_preproc_robot_expe', 'TODO')
cmd:option('-name', 'DQN_EXPE', 'prefix filename used for saving network and training history')
--cmd:option('-state_dim', 7056, 'TODO')
cmd:option('-camera_width', 320, 'TODO')
cmd:option('-camera_height', 240, 'TODO')
cmd:option('-images_width', 64, 'TODO')
cmd:option('-images_height', 48, 'TODO')
cmd:option('-ncols', 1, 'TODO')
cmd:option('-hist_len', 1, 'TODO')
cmd:option('-rescale_r', 1, 'TODO')
cmd:option('-valid_size', 500, 'TODO')
cmd:option('-clip_delta', 1, 'TODO')
cmd:option('-min_reward', -1, 'TODO')
cmd:option('-max_reward', 1, 'TODO')
-- cmd:option('target_q', 10000, 'TODO')
cmd:option('-steps', 50000000, 'number of steps to perform')
--cmd:option('-eval_freq', 2500, 'frequency of greedy evaluation') -- original value: 250000
--cmd:option('-eval_steps', 1250, 'number of evaluation steps') -- original value: 125000
--cmd:option('-prog_freq', 1000, 'frequency of progress output') -- original value: 5000
cmd:option('-save_freq', 1000, 'the model is saved every save_freq steps') -- original value: 125000
cmd:option('-gpu', -1, 'gpu flag') -- original value: -1
cmd:option('-verbose', 0, 'the higher the level, the more information is printed to screen')
cmd:option('-threads', 4, 'number of BLAS threads')
cmd:option('-save_versions', 0, 'TODO')

cmd:option('-tensorType', 'torch.FloatTensor', 'TODO')

local opt = cmd:parse(arg)

cmd:log('log', opt) -- log file

-- override print to always flush the output

local old_print = print
local print = function(...)
    old_print(...)
    io.flush()
end

-- start the experiment

print()

if not dqn then require "initenv" end

game_env, agent = setup(opt) -- removed 'local' to have access to them after
local game_actions = opt.actions -- TODO check

-- TODO do following checks and stop modifying opt before setup

if opt.expe_mode == 'no_learning' then
  print('MODE: MOVING RANDOMLY WITHOUT LEARNING')
  assert(opt.sleep ~= -1, 'no_learning mode requires a sleeping time')
  opt.learn_start = -1

elseif opt.expe_mode == 'no_environment' then
  print('MODE: LEARNING WITHOUT ENVIRONMENT')
  assert(opt.load_transitions ~= '', 'no_environment mode requires a transitions file')
  print('loading transitions_file ' .. opt.load_transitions)
  local transitions = torch.load(opt.load_transitions)
  for k, v in pairs(transitions) do
    agent.transitions[k] = v
  end
  transitions = nil
  collectgarbage()
  print(agent.transitions.numEntries .. " transitions loaded")
end

--[[
if opt.save_agent == '' then
  require 'os'
  local tm = os.date('*t')
  opt.save_agent = "../data/agent_" .. tm.year .. "-" .. tm.month .. "-" .. tm.day .. "-" ..
                   tm.hour .. "-" .. tm.min   .. "-" .. tm.sec .. '.t7'
end
--]]

local expe_timer = torch.Timer()
local last_loop_time = 0

local reward
local state
local action = 0 -- nothing
local previous_action = nil
local previous_state = nil

-- main loop

print()
print("let's go!")
print()

if game_env then
  game_env:act(action)    -- ACT initial
end

for step = 1, opt.steps do
  local current_time = expe_timer:time().real
  local loop_time = (current_time - last_loop_time) * 1000
  last_loop_time = current_time
  step_message = step .. "/" .. opt.steps .. " time: " .. string.format("%d", current_time) ..
                 "s loop time: " .. string.format("%.3fms", loop_time) .. " step: " .. " "

  -- OBSERVING

  if game_env then
    reward, state = game_env:observe()    -- OBSERVE  r_t-1, s_t
    if reward ~= 0 then
      print("$$$ reward " .. reward .. " (step " .. step .. ")")
    end

    state = agent:preprocess(state)

    if display_available then
      local img = state:clone():reshape(agent.images_height, agent.images_width)
      win_camera = image.display({image=image.scale(img, agent.images_width * 5, agent.images_height * 5, "simple"), min=0, max=1, win=win_camera, legend="camera"})
    end
  end

  -- SAVING

  if game_env then
    agent:save_transitions(previous_state, previous_action, reward, false)        -- SAVE     s_t-1, a_t-1, r_t-1
    if display_available and step > 2 then agent.transitions:explore_transitions() end
  end

  -- ACTING

  if game_env then
    if opt.learn_start > 0 then
      action = game_actions[agent:choose_action(state)]                           -- CHOOSE   a_t
    else
      -- TODO not limited to 4 actions
      local tmp_action
      local valid_action = false
      while not valid_action do
        tmp_action = torch.random(1, agent.n_actions)
        if action == 1 then valid_action = (tmp_action ~= 2)
        elseif action == 2 then valid_action = (tmp_action ~= 1)
        elseif action == 3 then valid_action = (tmp_action ~= 4)
        elseif action == 4 then valid_action = (tmp_action ~= 3)
        else valid_action = true end
      end
      action = tmp_action
    end

    game_env:act(action)                                                        -- ACT      a_t
  end

  -- LEARNING

  if opt.learn_start > 0 and agent.transitions.numEntries >= opt.bufferSize + opt.learn_start then
    if agent.transitions.numEntries == opt.bufferSize + opt.learn_start then
      print(">>> start learning")
    end

    agent:learn()

  elseif opt.sleep > 0 then
    print("forced to sleep...")
    os.execute("sleep " .. opt.sleep)
  end

  -- STUFF

  if game_env then
    previous_state = state:clone()                                              -- s_t -> s_t-1
    previous_action = action                                                    -- a_t -> a_t-1
  end

  print(step_message)

  if step % opt.save_freq == 0 then
    if opt.learn_start > 0 and opt.save_network ~= '' then
      local weight = {}
      local bias = {}
      for i_layer = 1, 11 do
        if agent.network:get(i_layer).weight then
          weight[i_layer] = agent.network:get(i_layer).weight
          bias[i_layer] = agent.network:get(i_layer).bias
        end
      end
      print(">>> saving network in " .. opt.save_network)
      torch.save(opt.save_network, {weight = weight, bias = bias})
    end
    if opt.save_transitions ~= '' then
      print(">>> saving transitions in " .. opt.save_transitions)
      torch.save(opt.save_transitions, {s = agent.transitions.s,
                                        a = agent.transitions.a,
                                        r = agent.transitions.r,
                                        numEntries = agent.transitions.numEntries})
    end
  end
end

if opt.learn_start > 0 and opt.save_network ~= '' then
  local weight = {}
  local bias = {}
  for i_layer = 1, 11 do
    if agent.network:get(i_layer).weight then
      weight[i_layer] = agent.network:get(i_layer).weight
      bias[i_layer] = agent.network:get(i_layer).bias
    end
  end
  print(">>> saving network in " .. opt.save_network)
  torch.save(opt.save_network, {weight = weight, bias = bias})
end
if opt.save_transitions ~= '' then
  print(">>> saving transitions in " .. opt.save_transitions)
  torch.save(opt.save_transitions, {s = agent.transitions.s,
                                    a = agent.transitions.a,
                                    r = agent.transitions.r,
                                    numEntries = agent.transitions.numEntries})
end

print()
print("...finished")
print("HOURA!")

