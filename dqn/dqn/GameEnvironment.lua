require 'paths'
local ffi = require 'ffi'
require 'torch'
require 'image'

-- Reads the whole content of the specified file.
local function readContent(path)
  local file = io.open(path)
  local content = file:read("*a")
  file:close()
  return content
end

local gameEnv = torch.class('robot_expe.GameEnvironment')

function gameEnv:__init(args)
  -- We let the RobotMind look like a C struct.
  ffi.cdef("typedef struct RobotMind RobotMind;")
  ffi.cdef(readContent(paths.thisfile("/home/fabio/catkin_ws/src/robot_expe/src/robot_mind_wrap.inl")))
  local lib = ffi.load("/home/fabio/catkin_ws/devel/lib/librobot_expe/robot_mind_wrap.so")

  -- Defining the metatable for RobotMind userdata.
  local mt = {}
  mt.__index = mt
  mt.get_images = lib.robot_mind_get_images
  mt.get_reward = lib.robot_mind_get_reward
  mt.act = lib.robot_mind_act

  ffi.metatype("RobotMind", mt)

  self.camera_width = args.camera_width
  self.camera_height = args.camera_height
  local nb_images = 1
  self.robot_interface = ffi.gc(lib.robot_mind_new(nb_images), lib.robot_mind_gc)

  return self
end

--[[
function gameEnv:getState()
  -- grab the screen again only if the state has been updated in the meantime
  self._state.observation = self._state.observation or self._screen:grab():clone()
  self._state.observation:copy(self._screen:grab())

  return self._state.observation, self._state.reward
end
--]]

-- Function plays one random action in the game and returns game state.
function gameEnv:_randomStep()
  return self:_step(self._actions[torch.random(#self._actions)])
end


local n_bytes_pixel = 3

function gameEnv:process_images(images)
  images:resize(self.camera_height, self.camera_width, n_bytes_pixel)
  images = images:transpose(1, 3)
  images = images:transpose(2, 3)
  local tmp = images[{1,{},{}}]:clone()
  images[{1,{},{}}] = images[{3,{},{}}]
  images[{3,{},{}}] = tmp
  return images
end

--[[
function gameEnv:step(action)
  self.robot_interface:act(action)
  -- TODO wait?
  os.execute("sleep 0.5")
  local images = torch.ByteTensor(self.camera_width * self.camera_height * n_bytes_pixel);
  self.robot_interface:get_images(torch.data(images))
  images = self:process_images(images)
  local reward = self.robot_interface:get_reward()
  return images, reward
end
--]]

function gameEnv:observe(reward, state)
  local screen = torch.ByteTensor(self.camera_width * self.camera_height * n_bytes_pixel);
  self.robot_interface:get_images(torch.data(screen))
  local state = self:process_images(screen)
  local reward = self.robot_interface:get_reward()

  return reward, state
end

function gameEnv:act(action)
  self.robot_interface:act(action)
end

-- Function returns a table with valid actions in the current game.
function gameEnv:getActions()
  return {1, 2, 3, 4}; -- TODO
end

