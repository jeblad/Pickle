--- Baseclass for Spy.
-- This class follows the pattern with from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Spy

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'
local ReportAdapt = require 'picklelib/report/ReportAdapt'

-- @var lib var
local Spy = {}

--- Lookup of missing class members.
-- @field class index
Spy.__index = Spy

--- Create a new instance.
-- Assumption is either to create a new instance from an existing class,
-- or from a previous instance of some kind.
-- @treturn self
function Spy:create()
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	return setmetatable( {}, meta )
end

--- Set the reference to the report.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj that somehow maintain a collection
-- @treturn self
function Spy:setReport( obj )
	libUtil.checkType( 'Spy:setReport', 1, obj, 'table', false )
	self._report = obj
	return self
end

--- Expose reference to report.
-- @return Report
function Spy:report()
	if not self._report then
		self._report = ReportAdapt:create()
	end
	return self._report
end

--- Set the reference to the reports collection.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj that somehow maintain a collection
-- @treturn self
function Spy:setReports( obj )
	libUtil.checkType( 'Spy:setReport', 1, obj, 'table', false )
	self._reports = obj
	return self
end

--- Expose reference to reports.
-- @return Reports
function Spy:reports()
	if not self._reports then
		self._reports = Bag:create()
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
-- @raise on wrong arguments
-- @tparam string key used to identify a message
-- @tparam nil|string str alternate free form
-- @treturn Report
function Spy:todo( key, str )
	libUtil.checkType( 'Spy:todo', 1, key, 'string', false )
	libUtil.checkType( 'Spy:todo', 2, str, 'string', true )
	return self:report():setTodo( str or mw.message.new( key ):plain() )
end

--- Long report.
-- @raise on wrong arguments
-- @tparam string key used to identify a message
-- @tparam nil|string str alternate free form
-- @treturn Report
function Spy:skip( key, str )
	libUtil.checkType( 'Spy:todo', 1, key, 'string', false )
	libUtil.checkType( 'Spy:todo', 2, str, 'string', true )
	return self:report():setSkip( str or mw.message.new( key ):plain() )
end

-- Return the final lib
return Spy
