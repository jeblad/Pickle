--- Baseclass for Spy

-- pure libs
local Stack = require 'picklelib/Stack'
local AdaptReport = require 'picklelib/report/AdaptReport'

-- @var lib var
local Spy = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Spy:__index( key ) -- luacheck: no self
	return Spy[key]
end

--- Create a new instance
-- @param vararg set to temporal
-- @return self
function Spy.create( ... ) -- luacheck: ignore
	local self = setmetatable( {}, Spy )
	return self
end

--- Set the reference to the report
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Spy:setReport( obj )
	assert( type( obj ) == 'table' )
	self._report = obj
	return self
end

--- Expose reference to report
function Spy:report()
	if not self._report then
		self._report = AdaptReport.create()
	end
	return self._report
end

--- Set the reference to the reports collection
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Spy:setReports( obj )
	assert( type( obj ) == 'table' )
	self._reports = obj
	return self
end

--- Expose reference to reports
function Spy:reports()
	if not self._reports then
		self._reports = Stack.create()
	end
	return self._reports
end

--- Traceback function calls
-- This is a reformatted version.
-- @param vararg passed to debug.traceback
-- @return string, table
function Spy:traceback( ... )

	local first, rest = string.match( debug.traceback( ... ), "^([^\n]+)\n(.*)$" )

	self:report():addLine( first )

	for v in string.gmatch( rest, "([^\n]+)" ) do
		self:report():addLine( string.match( v, "^\t*([^\n]+)" ) )
	end

	return self
end

--- Short report
-- @param string key used to identify a message
-- @param string alternate free form
-- @return Report
function Spy:todo( key, str )

	return self:report():setTodo( str or mw.message.new( key ):plain() )
end

--- Long report
-- @param string key used to identify a message
-- @param string alternate free form
-- @return Report
function Spy:skip( key, str )

	return self:report():setSkip( str or mw.message.new( key ):plain() )
end

-- Return the final lib
return Spy
