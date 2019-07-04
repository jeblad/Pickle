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
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Spy:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Spy:__index', 1, key, 'string', false )
	return Spy[key]
end

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

--- Set the todo to a string.
-- @raise on wrong arguments
-- @tparam string str alternate free form
-- @treturn self
function Spy:setTodo( str )
	libUtil.checkType( 'Spy:todo', 1, str, 'string', false )
	self:report():setTodo( str )
	return self
end

--- Set the skip to a string.
-- @raise on wrong arguments
-- @tparam string str alternate free form
-- @treturn self
function Spy:setSkip( str )
	libUtil.checkType( 'Spy:skip', 1, str, 'string', false )
	self:report():setSkip( str )
	return self
end

--- Convenience method doCarp.
-- Called to investigate a possible error condition.
-- Make a report without exiting, add a todo, with caller's name and arguments.
-- @function carp
-- @param str message to be passed on
-- @return Report
function Spy:doCarp( str )
	local obj = self:report():setTodo( str )
	self:reports():push( obj )
	return self
end

--- Convenience method doCluck.
-- Called to investigate a possible error condition, with a stack backtrace.
-- Make a report without exiting, add a todo, with caller's name and arguments, and a stack trace.
-- @function carp
-- @param str message to be passed on
-- @return Spy
function Spy:doCluck( str, ... )
	local obj = self:report():setTodo( str )
	self:traceback( ... )
	self:reports():push( obj )
	return self
end

--- Convenience method doCroak.
-- Called to investigate a possible error condition.
-- Make a report without exiting, add a skip, with caller's name and arguments.
-- @function carp
-- @param str message to be passed on
-- @return Report
function Spy:doCroak( str )
	local obj = self:report():setSkip( str )
	self:reports():push( obj )
	return self
end

--- Convenience method doConfess.
-- Called to investigate a possible error condition, with a stack backtrace.
-- Make a report without exiting, add a skip, with caller's name and arguments, and a stack trace.
-- @function carp
-- @param str message to be passed on
-- @return Report
function Spy:doConfess( str, ... )
	local obj = self:report():setSkip( str )
	self:traceback( ... )
	self:reports():push( obj )
	return self
end

-- Return the final lib
return Spy
