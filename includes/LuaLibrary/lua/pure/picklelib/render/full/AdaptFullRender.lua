--- Final class for full report renderer.
-- This class follows the pattern from [Lua classes](../topics/lua-classes.md.html).
-- @classmod AdaptFullRender
-- @alias Render

-- pure libs
local Super = require 'picklelib/render/AdaptRender'

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
-- @tparam vararg ... forwarded to @{AdaptRender:create}
-- @treturn self
function Render:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... forwarded to @{AdaptRender:_init}
-- @return self
function Render:_init( ... )
	Super._init( self, ... )
	self._type = 'adapt-full-render'
	return self
end

-- Return the final class.
return Render
