--- Final class for compact report renderer.
-- @classmod AdaptCompactRender
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
-- @tparam vararg ... unused
-- @treturn AdaptCompactRender|any
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

--- Override realization of reported data for body.
-- @todo is this correct?
-- @tparam Report src that shall be realized
-- @tparam string lang code used for realization
-- @treturn string
function Render:realizeBody( src, lang )
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
return Render
