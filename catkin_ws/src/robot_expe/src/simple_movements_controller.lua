require 'paths'
local ffi = require 'ffi'
--require 'os'
require 'torch'
require 'image'

-- Reads the whole content of the specified file.
local function readContent(path)
    local file = io.open(path)
    local content = file:read("*a")
    file:close()
    return content
end

-- Appends all srcList values to the destList.
local function appendAll(destList, srcList)
    for _, val in ipairs(srcList) do
        table.insert(destList, val)
    end
end

-- We let the RobotMind look like a C struct.
ffi.cdef("typedef struct RobotMind RobotMind;")
ffi.cdef(readContent(paths.thisfile("robot_mind_wrap.inl")))
local lib = ffi.load("/home/fabio/catkin_ws/devel/lib/librobot_expe/robot_mind_wrap.so") --package.searchpath('librobot_mind_wrap', package.cpath))

-- Defining the metatable for RobotMind userdata.
local mt = {}
mt.__index = mt
mt.get_images = lib.robot_mind_get_images
mt.act = lib.robot_mind_act

ffi.metatype("RobotMind", mt)

robot_mind = ffi.gc(lib.robot_mind_new(3), lib.robot_mind_gc)

local width = 320         -- 2 * 2 * 2 * 2 * 2 * 2 * 5
local height = 240        -- 2 * 2 * 2 * 2 * 3 * 5
local n_bytes_pixel = 3
local n_images_state = 4

local images_width=100
local images_height=80

---[[
package.path = package.path .. ";/home/fabio/robot_DQN/dqn/?.lua"
preproc = require("net_preproc_robot_expe")
preproc = preproc({hist_len=n_images_state, images_height=images_height, images_width=images_width})
preproc:float()
--]]

robot_mind:act(0)

--local dataset = {}

require "socket" -- temp
while true do
  print("action?")
  local action = io.read()
  local start_time = socket.gettime()*1000
  if action == 'e' or action == '' then break end
  if (action == '8') then action = 1
  elseif (action == '5') then action = 2
  elseif (action == '4') then action = 3
  elseif (action == '6') then action = 4
  else action = 0 end
  robot_mind:act(action)
  
  os.execute("sleep 0.2")
  local obs = torch.ByteTensor(width * height * n_bytes_pixel * n_images_state);
  robot_mind:get_images(torch.data(obs))

  ---[[
  --local img = obs:chunk(n_images_state)
  --obs = img[1]
  --print(#obs)
  --]]
  --obs = obs:sub(1, width * height * n_bytes_pixel)
  obs:resize(height * n_images_state, width, n_bytes_pixel)
  obs = obs:transpose(1, 3)
  obs = obs:transpose(2, 3)
  local img = torch.ByteTensor(obs:size())
  img[{1,{},{}}] = obs[{3,{},{}}]
  img[{2,{},{}}] = obs[{2,{},{}}]
  img[{3,{},{}}] = obs[{1,{},{}}]
  --print(#img)

  local x = img:float()
  win1 = image.display({image=x, win=win1, legend="original"})
  win2 = image.display({image=image.rgb2y(x:clone()), win=win2, min=0, max=255, legend="luminance"})
  win3 = image.display({image=preproc:forward(x:clone()), win=win3, min=0, max=255, legend="preproc"})

  bob = preproc:forward(x:clone())
  --print(bob:min(), bob:max())

  --[[
  win3 = image.display({image=image.rgb2yuv(x:clone())[2], win=win3, legend="U"})
  win4 = image.display({image=image.rgb2yuv(x:clone())[3], win=win4, legend="V"})
  win5 = image.display({image=image.rgb2hsv(x:clone())[1], win=win5, legend="H"})
  win6 = image.display({image=image.rgb2hsv(x:clone())[2], win=win6, legend="S"})
  win7 = image.display({image=image.rgb2hsv(x:clone())[3], win=win7, legend="V"})

  win9 = image.display({image=image.rgb2yuv(x:clone()), win=win9, legend="YUV"})
  win10 = image.display({image=image.rgb2hsv(x:clone()), win=win10, legend="HSV"})
  --]]

  print("time: " ..  socket.gettime()*1000 - start_time .. " ms")

  --dataset[#dataset+1] = { img, action }
  --print("dataset size: " .. #dataset)
end

--[[
local tm = os.date("*t")
local filename = "data/dataset_" .. tm.year .. "-" .. tm.month .. "-" .. tm.day .. "-" ..
                                    tm.hour .. "-" .. tm.min   .. "-" .. tm.sec .. ".t7"
torch.save(filename, dataset)
print("dataset stored in " .. filename)
--]]

print("use Ctrl + C again or close the windows")

