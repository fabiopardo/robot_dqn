--[[
Copyright (c) 2014 Google Inc.

See LICENSE file for full terms of limited license.
]]

require "nn"
require "image"

local scale = torch.class('nn.Scale', 'nn.Module')


function scale:__init(height, width)
    self.height = height
    self.width = width
end

--local win3 = nil
function scale:forward(x)
    --win1 = image.display({image=x, win=win1})

    local x = x
    if x:dim() > 3 then
        x = x[1]
    end

    x = image.rgb2y(x) -- image.rgb2hsv(x)[1]

    --win2 = image.display({image=x, win=win2})

    x = image.scale(x, self.width, self.height, 'bilinear')

    --local img = x:clone():reshape(self.height, self.width)
    --win3 = image.display({image=x, win=win3, min=0, max=255})

    return x
end

function scale:updateOutput(input)
    return self:forward(input)
end

function scale:float()
end
