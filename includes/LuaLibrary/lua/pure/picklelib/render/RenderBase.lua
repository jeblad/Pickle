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

-- Return the final class
return Render
