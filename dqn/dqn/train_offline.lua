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

cmd:option('-verbose', 0,
           'the higher the level, the more information is printed to screen')
cmd:option('-threads', 1, 'number of BLAS threads')
cmd:option('-gpu', -1, 'gpu flag')

cmd:text()

local opt = cmd:parse(arg)

--- General setup.
game_env, game_actions, agent, opt = setup(opt) -- game_env, game_actions, agent, opt

--[[ CAUTION !!!!! ]]
local agent_file_name = "TRAINED_agent.t7"
loaded_agent = torch.load(agent_file_name)
for k, v in ipairs(loaded_agent) do
  agent[k] = v
end
loaded_agent = nil
collectgarbage()

print()
print()
print("########################################")
print()
print("agent loaded from " .. agent_file_name)
print()
print("########################################")
print()
print()
--]]

-- override print to always flush the output
local old_print = print
local print = function(...)
    old_print(...)
    io.flush()
end

local start_time = sys.clock()
local v_history = {}
local qmax_history = {}
local td_history = {}
local step = 0

-- START

transitions_file_name = "DQN3_0_1__ROBOT_EXPE_2015-8-10-14-47-28.t7"
transitions_table = torch.load(transitions_file_name)

agent.transitions.numEntries = transitions_table.numEntries
agent.transitions.s = transitions_table.s
agent.transitions.a = transitions_table.a
agent.transitions.r = transitions_table.r

print()

local expe_timer = torch.Timer()
local last_loop_time = 0

local n_steps = 28000 -- 16h
for step = 1, n_steps do
  local current_time = expe_timer:time().real
  local loop_time = (current_time - last_loop_time) * 1000
  last_loop_time = current_time
  step_message = "time: " .. string.format("%d", current_time) .. "s loop time: " .. string.format("%.3fms", loop_time) .. " step: " .. step .. "/" .. n_steps .. " "
  agent:learn()
  print(step_message)

  if step % 1000 == 0 then
    local weights = {}
    for i_layer = 1, 11 do
      if agent.network:get(i_layer).weight then weights[i_layer] = agent.network:get(i_layer).weight
      else weights[i_layer] = "none" end
    end
    torch.save("TRAINED_" .. transitions_file_name, agent)
  end
end

print()

local weights = {}
for i_layer = 1, 11 do
  if agent.network:get(i_layer).weight then weights[i_layer] = agent.network:get(i_layer).weight
  else weights[i_layer] = "none"
  end
end
torch.save("TRAINED_" .. transitions_file_name, agent)

print()
print("FINISHED!")
print("... houra")


