--- Final class for full report renderer.
-- This class follows the pattern from [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderAdaptFull
-- @alias Subclass

-- pure libs
local Super = require 'picklelib/render/RenderAdapt'

-- @var class var for lib
local Subclass = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see RenderAdapt:create
-- @tparam vararg ... forwarded to @{RenderAdapt:create}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... forwarded to @{RenderAdapt:_init}
-- @return self
function Subclass:_init( ... )
	Super._init( self, ... )
	self._type = 'render-adapt-full'
	return self
end

-- Return the final class.
return Subclass
