--- Final class for frame report renderer.
-- @classmod FrameCompactRender
-- @alias Render

-- pure libs
local Super = require 'picklelib/render/FrameRender'

-- @var class var for lib
local Render = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Render:__index( key ) -- luacheck: no self
	return Render[key]
end

-- @var metatable for the class
setmetatable( Render, { __index = Super } )

--- Create a new instance.
-- @see RenderBase:create
-- @tparam vararg ... unused
-- @treturn FrameCompactRender|any
function Render:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @return self
function Render:_init( ... ) -- luacheck: no unused args
	return self
end

-- Return the final class.
return Render
