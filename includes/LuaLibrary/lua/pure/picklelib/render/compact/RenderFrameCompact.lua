--- Final class for frame report renderer.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderFrameCompact
-- @alias Subclass

-- pure libs
local libUtil = require 'libraryUtil'

-- @var super class
local Super = require 'picklelib/render/RenderFrame'

-- @var final class
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'RenderFrameCompact:__index', 1, key, 'string', false )
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see RenderFrame:create
-- @tparam vararg ... forwarded to @{RenderFrame:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @tparam vararg ... forwarded to @{RenderFrame:_init|superclass init method}
-- @return self
function Subclass:_init( ... )
	Super._init( self, ... )
	self._type = self._type .. '-compact'
	return self
end

-- Return the final class.
return Subclass
