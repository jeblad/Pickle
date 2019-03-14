--- Subclass for adapt report.
-- @classmod AdaptReport

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local Base = require 'picklelib/report/ReportBase'

-- @var class var for lib
local AdaptReport = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function AdaptReport:__index( key ) -- luacheck: no self
	return AdaptReport[key]
end

-- @var metatable for the class
setmetatable( AdaptReport, { __index = Base } )

--- Create a new instance.
-- @tparam vararg ... pushed to lines
-- @treturn self
function AdaptReport.create( ... )
	local self = setmetatable( {}, AdaptReport )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... pushed to lines
-- @treturn self
function AdaptReport:_init( ... )
	Base._init( self )
	self._description = false
	self._state = false
	self._lang = false -- @todo is this correct?
	self._type = 'adapt-report'
	if select('#',...) then
		self:lines():push( ... )
	end
	return self
end

--- Export the lines as an multivalue return.
-- Note that each line is not unwrapped.
-- @return list of lines
function AdaptReport:lines()
	if not self._lines then
		self._lines = Stack.create()
	end
	return self._lines
end

--- Get the number of lines.
-- @return number of lines
function AdaptReport:numLines()
	return self._lines and self._lines:depth() or 0
end

--- Add a line.
-- @todo sometimes a block of lines must be added
-- Note that all arguments will be wrapped up in a table before saving.
-- @tparam vararg ... that can be a line
-- @treturn self
function AdaptReport:addLine( ... )
	self:lines():push( { ... } )
	return self
end

--- Get a line.
-- Note that all parts will be returned wrapped up in a table.
-- @tparam number idx line number
-- @treturn table containing list of parts
function AdaptReport:getLine( idx )
	return self:lines():get( idx )
end

--- Realize the data by applying a render.
-- @tparam Renders renders to use while realizing the reports
-- @tparam string lang holding the language code
-- @tparam Counter counter holding the running count
-- @treturn string
function AdaptReport:realize( renders, lang, counter )
	assert( renders, 'Failed to provide renders' )
	return ''
		.. (renders.realizeHeader and renders:realizeHeader( self, lang, counter ) or '')
		.. (renders.realizeBody and renders:realizeBody( self, lang, counter ) or '')
end

-- Return the final class.
return AdaptReport
