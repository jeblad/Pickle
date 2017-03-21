--- Baseclass for reports

-- @var class var for lib
local Report = {}

--- Lookup of missing class members
function Report:__index( key ) -- luacheck: no self
	return Report[key]
end

--- Create a new instance
function Report.create( ... )
	local self = setmetatable( {}, Report )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Report:_init( ... ) -- luacheck: no unused args
	self._type = 'base-report'
	return self
end

function Report:realize( renders, lang ) -- luacheck: ignore
	return ''
end

function Report:type()
	return self._type
end

-- Return the final class
return Report
