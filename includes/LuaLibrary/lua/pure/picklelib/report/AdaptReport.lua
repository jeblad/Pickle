--- Subclass for adapt report

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local BaseReport
if mw.pickle then
	-- structure exist, make access simpler
	BaseReport = mw.pickle.report.base
else
	-- structure does not exist, require the libs
	BaseReport = require 'picklelib/report/BaseReport'
end

-- @var class var for lib
local AdaptReport = {}

--- Lookup of missing class members
function AdaptReport:__index( key ) -- luacheck: ignore self
	return AdaptReport[key]
end

-- @var metatable for the class
setmetatable( AdaptReport, { __index = BaseReport } )

--- Create a new instance
function AdaptReport.create( ... )
	local self = setmetatable( {}, AdaptReport )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function AdaptReport:_init( ... )
	BaseReport._init( self )
	self._description = false
	self._lines = Stack.create()
	self._state = false
	self._lang = false
	self._lines:push( ... )
	self._type = 'adapt-report'
	return self
end

--- Export the lines as an multivalue return
-- Note that each line is not unwrapped.
function AdaptReport:lines()
	return self._lines:export()
end

--- Get the number of lines
function AdaptReport:numLines()
	local t = { self._lines:export() }
	return #t
end

--- Add a line
-- Note that all arguments will be wrapped up in a table before saving.
function AdaptReport:addLine( ... )
	self._lines:push( { ... } )
	return self
end

--- Set the state as not ok
-- Note that initial state is not ok.
function AdaptReport:notOk()
	self._state = false
	return self
end

--- Set the state as ok
-- Note that initial state is not ok.
function AdaptReport:ok()
	self._state = true
	return self
end

--- Check if the instance state is ok
-- Note that initial state is not ok.
function AdaptReport:isOk()
	return self._state
end

--- Realize the data by applying a render
function AdaptReport:realize( renders, lang )
	assert( renders, 'Failed to provide renders' )
	return ''
		.. renders:realizeHeader( self, lang )
		.. renders:realizeBody( self, lang )
end

-- Return the final class
return AdaptReport
