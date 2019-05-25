--- Final class for full report renderer.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderAdaptFull
-- @alias Subclass

-- pure libs
local libUtil = require 'libraryUtil'

-- @var super class
local Super = require 'picklelib/render/RenderAdapt'

-- @var final class
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'RenderAdaptFull:__index', 1, key, 'string', false )
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see RenderAdapt:create
-- @tparam vararg ... forwarded to @{RenderAdapt:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @tparam vararg ... forwarded to @{RenderAdapt:_init|superclass init method}
-- @return self
function Subclass:_init( ... )
	Super._init( self, ... )
	self._type = self._type .. '-full'
	return self
end

-- Return the final class.
return Subclass
