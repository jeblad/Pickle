--- Baseclass for Spy.
-- @classmod Spy

-- pure libs
local Stack = require 'picklelib/Stack'
local AdaptReport = require 'picklelib/report/AdaptReport'

-- @var lib var
local Spy = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Spy:__index( key ) -- luacheck: no self
	return Spy[key]
end

--- Create a new instance.
-- @tparam vararg ... set to temporal (unused)
-- @treturn self
function Spy.create()
	local self = setmetatable( {}, Spy )
	return self
end

--- Set the reference to the report.
-- This keeps a reference, the object is not cloned.
-- @tparam table obj that somehow maintain a collection
-- @treturn self
function Spy:setReport( obj )
	assert( type( obj ) == 'table' )
	self._report = obj
	return self
end

--- Expose reference to report.
-- @return Report
function Spy:report()
	if not self._report then
		self._report = AdaptReport.create()
	end
	return self._report
end

--- Set the reference to the reports collection.
-- This keeps a reference, the object is not cloned.
-- @tparam table obj that somehow maintain a collection
-- @treturn self
function Spy:setReports( obj )
	assert( type( obj ) == 'table' )
	self._reports = obj
	return self
end

--- Expose reference to reports.
-- @return Reports
function Spy:reports()
	if not self._reports then
		self._reports = Stack.create()
	end
	return self._reports
end

--- Traceback function calls.
-- This is a reformatted version.
-- @tparam vararg ... passed to debug.traceback
-- @treturn self
function Spy:traceback( ... )

	local first, rest = string.match( debug.traceback( ... ), "^([^\n]+)\n(.*)$" )

	self:report():addLine( first )

	for v in string.gmatch( rest, "([^\n]+)" ) do
		self:report():addLine( string.match( v, "^\t*([^\n]+)" ) )
	end

	return self
end

--- Short report.
-- @tparam string key used to identify a message
-- @tparam string str alternate free form
-- @treturn Report
function Spy:todo( key, str )
	return self:report():setTodo( str or mw.message.new( key ):plain() )
end

--- Long report.
-- @tparam string key used to identify a message
-- @tparam string str alternate free form
-- @treturn Report
function Spy:skip( key, str )
	return self:report():setSkip( str or mw.message.new( key ):plain() )
end

-- Return the final lib
return Spy
