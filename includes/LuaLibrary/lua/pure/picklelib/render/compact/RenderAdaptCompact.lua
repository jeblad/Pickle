--- Final class for compact report renderer.
-- This class follows the pattern from [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderAdaptCompact
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
	self._type = 'render-adapt-compact'
	return self
end

--- Override realization of reported data for body.
-- @todo is this correct?
-- @tparam Report src that shall be realized
-- @tparam[opt] string lang code used for realization
-- @treturn string
function Subclass:realizeBody( src, lang )
	assert( src, 'Failed to provide a source' )

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
