--- Subclass for compact report renderer.
-- @classmod AdaptCompactRender
-- @alias AdaptRender

-- pure libs
local Base = require 'picklelib/render/AdaptRender'

-- @var class var for lib
local AdaptRender = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function AdaptRender:__index( key ) -- luacheck: no self
	return AdaptRender[key]
end

-- @var metatable for the class
setmetatable( AdaptRender, { __index = Base } )

--- Create a new instance.
-- @tparam vararg ... unused
-- @return AdaptRender
function AdaptRender.create( ... )
	local self = setmetatable( {}, AdaptRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @return AdaptRender
function AdaptRender:_init( ... ) -- luacheck: no unused args
	return self
end

--- Override realization of reported data for body.
-- @todo is this correct?
-- @tparam Report src that shall be realized
-- @tparam string lang code used for realization
-- @treturn string
function AdaptRender:realizeBody( src, lang )
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
return AdaptRender
