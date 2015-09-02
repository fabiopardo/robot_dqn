require "torch"
require "image"
require "nn"

dataset = torch.load("data/dataset_2015-7-28-21-44-29.t7")
dataset[#dataset] = nil
--print(#dataset)

local width = 320
local height = 240

local width_sub = 320
local height_sub = 80

local width_scale = width_sub / 2 -- 160
local height_scale = height_sub / 2 -- 40

local n_actions = 4

for i = 1, #dataset do
  data = dataset[i]
  imgs = data[1]
  imgs = imgs:chunk(3, 2)

  img1 = image.rgb2y(imgs[1]:sub(1, 3,
                                 1 + (height - height_sub) / 2, height - (height - height_sub) / 2,
                                 1 + (width - width_sub) / 2, width - (width - width_sub) / 2
                                )):double()
  img1 = image.scale(img1, width_scale, height_scale)
  img1:add(-img1:mean())
  img1:div(img1:std())

  if i == 1 then image.display({image=img1, win=win1}) end

  img2 = image.rgb2y(imgs[3]:sub(1, 3,
                                 1 + (height - height_sub) / 2, height - (height - height_sub) / 2,
                                 1 + (width - width_sub) / 2, width - (width - width_sub) / 2
                                )):double()
  img2 = image.scale(img2, width_scale, height_scale)
  img2:add(-img2:mean())
  img2:div(img2:std())

  --win1 = image.display({image=img1, win=win1})
  --win2 = image.display({image=img2, win=win2})

  action = data[2]

  input = img1:resize(width_scale * height_scale + n_actions)
  actions = torch.zeros(n_actions)
  assert(action >= 1 and action <= n_actions)
  actions[action] = 1
  for j = 1, n_actions do
    input[width_scale * height_scale + j] = actions[j]
  end
  --if (i == #dataset) then print(input) end
  output = img2:resize(width_scale * height_scale)
  dataset[i] = { input, output }
end

function dataset:size() return #dataset end

--SpatialConvolutionMap
model = nn.Sequential()
--model:add(nn.Reshape(....))
n_inputs = width_scale * height_scale + n_actions
n_outputs = width_scale * height_scale
n_hiddens1 = width_scale * height_scale
n_hiddens2 = width_scale * height_scale

model:add(nn.Linear(n_inputs, n_hiddens1))
model:add(nn.Tanh())
model:add(nn.Linear(n_hiddens1, n_hiddens2))
model:add(nn.Tanh())
model:add(nn.Linear(n_hiddens2, n_outputs))

criterion = nn.MSECriterion()
trainer = nn.StochasticGradient(model, criterion)
trainer.learningRate = 0.05
trainer.learningRateDecay = 0
trainer.maxIteration = 30
trainer.shuffleIndices = true
trainer.verbose = true
trainer.verbose = true

--trainer:train(dataset)

