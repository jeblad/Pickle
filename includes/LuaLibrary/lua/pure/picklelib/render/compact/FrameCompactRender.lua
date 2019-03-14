--- Subclass for frame report renderer.
-- @classmod FrameCompactRender
-- @alias FrameRender

-- pure libs
local Base = require 'picklelib/render/FrameRender'

-- @var class var for lib
local FrameRender = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function FrameRender:__index( key ) -- luacheck: no self
	return FrameRender[key]
end

-- @var metatable for the class
setmetatable( FrameRender, { __index = Base } )

--- Create a new instance.
-- @tparam vararg ... unused
-- @return self
function FrameRender.create( ... )
	local self = setmetatable( {}, FrameRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @return self
function FrameRender:_init( ... ) -- luacheck: no unused args
	return self
end

-- Return the final class.
return FrameRender
