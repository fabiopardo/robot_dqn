require "image"
require "Scale"

local function create_network(args)
    -- Y (luminance)
    return nn.Scale(args.images_height, args.images_width, true)
end

return create_network

