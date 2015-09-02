width = 160
height = 40

data = dataset[10]
input = data[1]:sub(1, height * width)
image.display(input:reshape(1, height, width))

output = data[2]
image.display(output:reshape(1, height, width))

pred = model:forward(data[1])
image.display(pred:reshape(1, height, width))

trainer.maxIteration = 1

for i = 1, 90 do
  trainer:train(dataset)
  pred = model:forward(data[1])
  image.display(pred:reshape(1, height, width))
end


