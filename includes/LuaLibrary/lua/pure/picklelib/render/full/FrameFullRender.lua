--- Subclass for frame report renderer

-- pure libs
local Base = require 'picklelib/render/FrameRenderBase'

-- @var class var for lib
local FrameRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function FrameRender:__index( key ) -- luacheck: no self
	return FrameRender[key]
end

-- @var metatable for the class
setmetatable( FrameRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return FrameRender
function FrameRender.create( ... )
	local self = setmetatable( {}, FrameRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return FrameRender
function FrameRender:_init( ... ) -- luacheck: no unused args
	return self
end

-- Return the final class
return FrameRender
