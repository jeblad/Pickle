--- Baseclass for reports

-- @var class var for lib
local Report = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Report:__index( key ) -- luacheck: no self
	return Report[key]
end

--- Create a new instance
-- @param vararg unused
-- @return Report
function Report.create( ... )
	local self = setmetatable( {}, Report )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Report
function Report:_init( ... ) -- luacheck: no unused args
	self._type = 'base-report'
	return self
end

--- Realize the data by applying a render
-- @param Renders to use while realizing the reports
-- @param string holding the language code
function Report:realize( renders, lang ) -- luacheck: ignore
	-- @todo this should probably return an error
	-- error('Method should be overridden')
	return ''
end

--- Get the type of report
-- All reports has an explicit type name.
-- @return string
function Report:type()
	return self._type
end

-- Return the final class
return Report
