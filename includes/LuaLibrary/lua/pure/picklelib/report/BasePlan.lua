--- Baseclass for plans

-- @var class var for lib
local Plan = {}

--- Lookup of missing class members
function Plan:__index( key ) -- luacheck: ignore self
	return Plan[key]
end

--- Create a new instance
function Plan.create( ... )
	local self = setmetatable( {}, Plan )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Plan:_init( ... ) -- luacheck: ignore
	self._type = 'base-plan'
	return self
end

function Plan:realize( renders, lang ) -- luacheck: ignore
	return ''
end

function Plan:type()
	return self._type
end

-- Return the final class
return Plan
