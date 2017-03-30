-- Baseclass for Describe, Context, and It

-- pure libs
local Stack = require 'picklelib/Stack'
local AdaptReport = require 'picklelib/report/AdaptReport' -- luacheck: ignore
local FrameReport = require 'picklelib/report/FrameReport' -- luacheck: ignore

-- @var class var for lib
local Frame = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Frame:__index( key ) -- luacheck: no self
	return Frame[key]
end

-- @var metatable for the class
local mt = { types = {} }

--- Get arguments for a class call
-- @param vararg pass on to dispatch
-- @return self -ish
function mt:__call( ... ) -- luacheck: no self
	local obj = Frame.create()
	obj:dispatch( ... )
	assert( not obj:isDone(), 'Failed, got a done instance' )
	if obj:hasFixtures( obj ) then
		obj:eval()
	end
	return obj
end

--- Get arguments for a instance call
-- @param vararg pass on to dispatch
-- @return self
function Frame:__call( ... )
	self:dispatch( ... )
	assert( not self:isDone(), 'Failed, got a done instance' )
	if self:hasFixtures() then
		self:eval()
	end
	return self
end

setmetatable( Frame, mt )

--- Create a new instance
-- @param vararg list to be dispatched
-- @return Frame
function Frame.create( ... )
	local self = setmetatable( {}, Frame )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg list to be dispatched
-- @return Frame
function Frame:_init( ... ) -- luacheck: ignore
	self._descriptions = Stack.create()
	self._fixtures = Stack.create()
	self._done = false
	return self
end

--- Dispach on type
-- @param vararg list to dispatch
-- @return self
function Frame:dispatch( ... )
	for _,v in ipairs( { ... } ) do
		local tname = type( v )
		assert( mt.types[tname], 'Failed to find a type handler' )
		mt.types[tname]( self, v )
	end
	return self
end

--- Push a string
-- @param this place to store value
-- @param string value that should be stored
mt.types[ 'string' ] = function( this, val )
	this._descriptions:push( val )
end

--- Push a function
-- @param this place to store value
-- @param function value that should be stored
mt.types[ 'function' ] = function( this, val )
	this._fixtures:push( val )
end

--- Push a table
-- @param this place to store value
-- @param table value that should be stored
mt.types[ 'table' ] = function( this, val )
	this._subjects:push( val )
end

--- Check if the frame has descriptions
-- @return boolean
function Frame:hasDescriptions()
	return not self._descriptions:isEmpty()
end

--- Check number of descriptions
-- @return number
function Frame:numDescriptions()
	return self._descriptions:depth()
end

--- Check if the frame has fixtures
-- @return boolean
function Frame:hasFixtures()
	return not self._fixtures:isEmpty()
end

--- Check number of fixtures
-- @return number
function Frame:numFixtures()
	return self._fixtures:depth()
end

--- Check if the instance is evaluated
-- @return boolean
function Frame:isDone()
	return self._done
end

--- Get descriptions
-- @return list of descriptions
function Frame:descriptions()
	return self._descriptions:export()
end

--- Set the reference to the subjects collection
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Frame:setSubjects( obj )
	assert( type( obj ) == 'table' )
	self._subjects = obj
	return self
end

--- Expose reference to subjects
function Frame:subjects()
	return self._subjects
end

--- Set the reference to the reports collection
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Frame:setReports( obj )
	assert( type( obj ) == 'table' )
	self._reports = obj
	return self
end

--- Expose reference to reports
function Frame:reports()
	return self._reports
end

--- Set the reference to the extractors
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Frame:setExtractors( obj )
	assert( type( obj ) == 'table' )
	self._extractors = obj
	return self
end

--- Expose reference to extractors
function Frame:extractors()
	return self._extractors
end

--- Set the reference to the renders
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Frame:setRenders( obj )
	assert( type( obj ) == 'table' )
	self._renders = obj
	return self
end

--- Expose reference to renders
function Frame:renders()
	return self._renders
end

--- Eval the fixtures over previous dispatched strings
-- @return self
function Frame:eval() -- luacheck: ignore
	if not self:hasFixtures() then
		self:reports():push( FrameReport.create():setSkip( 'pickle-frame-no-fixtures' ) )
		self._eval = true
		return self
	end

	for _,v in ipairs( self:hasDescriptions()
			and { self:descriptions() }
			or { 'pickle-frame-no-description' } ) do
		local pos = 1
		local args = {}

		repeat
			local strategy, first, last = self:extractors():find( v, pos )
			if strategy then
				table.insert( args, strategy:cast( v, first, last ) )
				pos = 1 + last
			end
		until( not strategy )

		for _,w in ipairs( { self._fixtures:export() } ) do
			local depth = self:reports():depth()
			local t = { pcall( w, unpack{ args } ) }
			if ( not t[1] ) and (not not t[2]) then
				self:reports():push( AdaptReport.create():setSkip( 'pickle-adapt-catched-exception' ) )
			end
			local report = FrameReport.create():setDescription( v )
			local added = self:reports():depth() - depth
			if added == 0 then
				report:setSkip( 'pickle-frame-no-tests' )
			end
			report:addConstituents( self:reports():pop( added ) )
			if t[1] and type( t[2] ) == 'table' then
				local tmp = AdaptReport.create():setTodo( 'pickle-adapt-catched-return' )
				for _,u in ipairs( t[2] or {} ) do
					tmp:addLine( mw.dumpObject( u ) )
				end
				report:addConstituent( tmp )
			end
			self:reports():push( report )
		end
	end
	self._eval = true
	return self
end

-- Return the final class
return Frame
