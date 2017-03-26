-- @var lib var
local Spies = {}

-- non-pure libs
local AdaptReport
local Reports
if mw.pickle then
	-- structure exist, make access simpler
	AdaptReport = mw.pickle.report.adapt
	Reports = mw.pickle.reports
else
	-- structure does not exist, require the libs
	AdaptReport = require 'picklelib/report/AdaptReport'
	Reports = require('picklelib/Stack').create()

	--- Expose reports
	function Spies.reports()
		return Reports
	end
end

--- Traceback function calls
-- This is a reformatted version.
-- @param vararg passed to debug.traceback
-- @return string, table
function Spies.traceback( report, ... )

	local first, rest = string.match( debug.traceback( ... ), "^([^\n]+)\n(.*)$" )

	report:addLine( first )

	for v in string.gmatch( rest, "([^\n]+)" ) do
		report:addLine( string.match( v, "^\t*([^\n]+)" ) )
	end

	return report
end

--- Short report
-- @param string key used to identify a message
-- @param string alternate free form
-- @return Report
function Spies.todo( key, str )
	return AdaptReport.create():setTodo( str or mw.message.new( key ):plain() )
end

--- Long report
-- @param string key used to identify a message
-- @param string alternate free form
-- @return Report
function Spies.skip( key, str )
	return AdaptReport.create():setSkikp( str or mw.message.new( key ):plain() )
end

-- Return the final lib
return Spies
