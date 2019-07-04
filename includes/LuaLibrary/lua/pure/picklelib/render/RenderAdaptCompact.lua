--- Final class for compact report renderer.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderAdaptCompact
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
	libUtil.checkType( 'RenderAdaptCompact:__index', 1, key, 'string', false )
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
	self._type = self._type .. '-compact'
	return self
end

--- Override realization of reported data for body.
-- @todo is this correct?
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn string
function Subclass:realizeBody( src, lang )
	libUtil.checkType( 'RenderAdaptCompact:realizeBody', 1, src, 'table', false )
	libUtil.checkType( 'RenderAdaptCompact:realizeBody', 2, lang, 'string', true )

	if src:isOk() then
		return ''
	end

	local t = {}

	if not src:isOk() then
		for _,v in ipairs( { src:lines():export() } ) do
			table.insert( t, self:realizeLine( v, lang ) )
		end
	end

	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class.
return Subclass
