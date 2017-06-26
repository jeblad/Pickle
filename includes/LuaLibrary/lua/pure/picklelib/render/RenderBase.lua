--- Baseclass for renders

-- @var class var for lib
local Render = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Render:__index( key ) -- luacheck: no self
	return Render[key]
end

--- Create a new instance
-- @param vararg unused
-- @return Render
function Render.create( ... )
	local self = setmetatable( {}, Render )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Render
function Render:_init( ... ) -- luacheck: no unused args
	self._type = 'base-render'
	return self
end

--- Override key construction
-- Sole purpose of this is to do assertions, and the provided key is never be used.
-- @param string to be appended to a base string
-- @return string
function Render:key( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return 'pickle-report-base-' .. keep
end

-- Return the final class
return Render
