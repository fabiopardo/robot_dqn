--[[
Copyright (c) 2014 Google Inc.

See LICENSE file for full terms of limited license.
]]

require "os"

local tm = os.date("*t")

if not dqn then
    require "initenv"
end

local cmd = torch.CmdLine()
cmd:text()
cmd:text('Train Agent in Environment:')
cmd:text()
cmd:text('Options:')

cmd:option('-framework', '', 'name of training framework')
cmd:option('-env', '', 'name of environment to use')
cmd:option('-game_path', '', 'path to environment file (ROM)')
cmd:option('-env_params', '', 'string of environment parameters')
cmd:option('-pool_frms', '',
           'string of frame pooling parameters (e.g.: size=2,type="max")')
cmd:option('-actrep', 1, 'how many times to repeat action')

cmd:option('-name', '', 'filename used for saving network and training history')
cmd:option('-network', '', 'reload pretrained network')
cmd:option('-agent', '', 'name of agent file to use')
cmd:option('-agent_params', '', 'string of agent parameters')
cmd:option('-seed', 1, 'fixed input seed for repeatable experiments')
cmd:option('-saveNetworkParams', false,
           'saves the agent network in a separate file')
cmd:option('-prog_freq', 5*10^3, 'frequency of progress output')
cmd:option('-save_freq', 5*10^4, 'the model is saved every save_freq steps')
cmd:option('-eval_freq', 10^4, 'frequency of greedy evaluation')
cmd:option('-save_versions', 0, '')

cmd:option('-steps', 10^5, 'number of training steps to perform')
cmd:option('-eval_steps', 10^5, 'number of evaluation steps')

cmd:option('-verbose', 2,
           'the higher the level, the more information is printed to screen')
cmd:option('-threads', 1, 'number of BLAS threads')
cmd:option('-gpu', -1, 'gpu flag')

cmd:text()

local opt = cmd:parse(arg)

--- General setup.
--[[local]] game_env, game_actions, agent, opt = setup(opt)

-- override print to always flush the output
local old_print = print
local print = function(...)
    old_print(...)
    io.flush()
end

require "image"

function show_screen_reward(screen, reward)
  --win = image.display({image=screen, win=win}) -- display screen
  if reward ~= 0 then print("reward: " .. reward) end
end

local learn_start = agent.learn_start
local start_time = sys.clock()
local v_history = {}
local qmax_history = {}
local td_history = {}
local step = 0

local n_chanels = 3
local nothing = 0
local action_index = 0
local action = nothing
local rewards_history = {}

local previous_action = nil
local previous_state = nil

local filename = opt.name .. "_" .. tm.year .. "-" .. tm.month .. "-" .. tm.day .. "-" ..
                                    tm.hour .. "-" .. tm.min   .. "-" .. tm.sec

print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print("\n>>> starting the experiment")
print(opt.steps .. " steps are planned\n")

game_env:act(action)                                                            -- ACT      (initial)

local expe_timer = torch.Timer()
local last_loop_time = 0

while step < opt.steps do
    local current_time = expe_timer:time().real
    local loop_time = (current_time - last_loop_time) * 1000
    last_loop_time = current_time
    step_message = "time: " .. string.format("%d", current_time) .. "s loop time: " .. string.format("%.3fms", loop_time) .. " step: " .. step .. "/" .. opt.steps .. " "

    local this_time = sys.clock()
    --if previous_time then print("loop time:", this_time - previous_time) end
    previous_time = this_time

    step = step + 1

    reward, state = game_env:observe()                                          -- OBSERVE  r_t-1, s_t
    state = agent:preprocess(state)--:float()


    local img = state:clone():reshape(agent.images_height, agent.images_width)
    win_camera = image.display({image=image.scale(img, agent.images_width * 5, agent.images_height * 5, "simple"), min=0, max=1, win=win_camera, legend="camera"})

    --[[
    local img = state:clone():reshape(agent.images_height, agent.images_width)
    local screen = torch.Tensor(3, agent.images_height, agent.images_width)
    screen[{{1},{},{}}]:copy(img)
    if not previous_img then previous_img = img:clone() end
    screen[{{2},{},{}}]:copy(previous_img)
    screen[{{3}, {}, {}}]:fill(1)
    win_camera = image.display({image=image.scale(screen, 320, 240, "simple"), min=0, max=1, win=win_camera, legend="camera"})
    previous_img:copy(img)
    --[[ ]]--

    action = game_actions[agent:choose_action(state)]                           -- CHOOSE   a_t

    game_env:act(action)                                                        -- ACT      a_t
    agent:save_transitions(previous_state, previous_action, reward, false)      -- SAVE     s_t-1, a_t-1, r_t-1

    --if step > 2 then agent.transitions:explore_transitions() end
    
    if step >= learn_start then                                                 -- LEARN
      if step == learn_start then print(">>> start learning") end
      agent:learn()
    else
      print("forced to sleep...")
      os.execute("sleep " .. 0.300)
    end

    previous_state = state:clone()                                              -- s_t -> s_t-1
    previous_action = action                                                    -- a_t -> a_t-1

    if reward ~= 0 then
      rewards_history[step] = reward
      print("$$$ reward " .. reward .. " (step " .. step .. ")")
    end

    if step % opt.prog_freq == 0 then
        print("\n>>> agent reporting step " .. step)
        --assert(step==agent.numSteps, 'trainer step: ' .. step .. ' & agent.numSteps: ' .. agent.numSteps)
        agent:report()
        collectgarbage()
    end

    --if step%1000 == 0 then collectgarbage() end
    --[[
    agent:compute_validation_statistics()
    if agent.v_avg then
        v_history[ind] = agent.v_avg
        td_history[ind] = agent.tderr_avg
        qmax_history[ind] = agent.q_max
    end
    print("V", v_history[ind], "TD error", td_history[ind], "Qmax", qmax_history[ind])

    reward_history[ind] = total_reward
    reward_counts[ind] = nrewards

    time_history[ind+1] = sys.clock() - start_time

    local time_dif = time_history[ind+1] - time_history[ind]

    local training_rate = opt.actrep*opt.eval_freq/time_dif

    print(string.format(
        '\nSteps: %d (frames: %d), reward: %.2f, epsilon: %.2f, lr: %G, ' ..
        'training time: %ds, training rate: %dfps, testing time: %ds, ' ..
        'testing rate: %dfps,  num. rewards: %d',
        step, step*opt.actrep, total_reward, agent.ep, agent.lr, time_dif,
        training_rate, eval_time, opt.actrep*opt.eval_steps/eval_time, nrewards))
    --]]
    
    --- everything is saved in a .t7 file every save_freq steps or at the final step
    if step % opt.save_freq == 0 or step == opt.steps then
        local s, a, r, s2, term = agent.valid_s, agent.valid_a, agent.valid_r,
            agent.valid_s2, agent.valid_term
        agent.valid_s, agent.valid_a, agent.valid_r, agent.valid_s2,
            agent.valid_term = nil, nil, nil, nil, nil, nil, nil
        local w, dw, g, g2, delta, delta2, deltas, tmp = agent.w, agent.dw,
            agent.g, agent.g2, agent.delta, agent.delta2, agent.deltas, agent.tmp
        agent.w, agent.dw, agent.g, agent.g2, agent.delta, agent.delta2,
            agent.deltas, agent.tmp = nil, nil, nil, nil, nil, nil, nil, nil

        if opt.save_versions > 0 then
            filename = filename .. "_" .. math.floor(step / opt.save_versions)
        end
        filename = filename
        print("\n>>> saving everything in " .. filename .. ".t7")
        torch.save(filename .. ".t7", {agent = agent,
                                model = agent.network,
                                rewards_history = rewards_history,
                                v_history = v_history,
                                td_history = td_history,
                                qmax_history = qmax_history,
                                arguments=opt})
        if opt.saveNetworkParams then
            local nets = {network=w:clone():float()}
            torch.save(filename..'.params.t7', nets, 'ascii')
        end
        agent.valid_s, agent.valid_a, agent.valid_r, agent.valid_s2,
            agent.valid_term = s, a, r, s2, term
        agent.w, agent.dw, agent.g, agent.g2, agent.delta, agent.delta2,
            agent.deltas, agent.tmp = w, dw, g, g2, delta, delta2, deltas, tmp
        print('Saved:', filename .. '.t7')
        io.flush()
        collectgarbage()
    end
    
    print(step_message)
end

