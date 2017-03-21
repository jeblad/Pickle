-- Baseclass for Describe, Context, and It

-- pure libs
local Stack = require 'picklelib/Stack'
-- local util = require 'picklelib/util'

-- @var class var for lib
local Frame = {}

-- non-pure libs
local AdaptReport -- luacheck: ignore
local FrameReport -- luacheck: ignore
local Subject
local Extractors
local Reports
-- Setup for prod or test
if mw.pickle then
	-- production, structure exist, make access simpler
	AdaptReport = mw.pickle.report.adapt
	FrameReport = mw.pickle.report.frame
	Subject = mw.pickle.subject
	Extractors = mw.pickle.extractors
	Reports = mw.pickle.reports
else
	-- test, structure does not exist, require the libs
	AdaptReport = require 'picklelib/report/AdaptReport'
	FrameReport = require 'picklelib/report/FrameReport'
	Subject = require 'picklelib/engine/Subject'
	Extractors = require('picklelib/extractor/ExtractorStrategies').create()
	Reports = require('picklelib/Stack').create()

	--- Expose report
	function Frame:report() -- luacheck: no self
		return FrameReport
	end

	--- Expose subject
	function Frame:subject() -- luacheck: no self
		return Subject
	end

	--- Expose extractors
	function Frame:extractors() -- luacheck: no self
		return Extractors
	end

	--- Expose reports
	function Frame:reports() -- luacheck: no self
		return Reports
	end
end

--- Lookup of missing class members
function Frame:__index( key ) -- luacheck: no self
	return Frame[key]
end

-- @var metatable for the class
local mt = { types = {} }

--- Get arguments for a class call
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
function Frame.create( ... )
	local self = setmetatable( {}, Frame )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Frame:_init( ... )
	self._descriptions = Stack.create()
	self._fixtures = Stack.create()
	self._depth = Subject.stack:depth()
	self._done = false
	self:dispatch( ... )
	return self
end

--- Dispach on type
function Frame:dispatch( ... )
	for _,v in ipairs( { ... } ) do
		local tname = type( v )
		assert( mt.types[tname], 'Failed to find a type handler' )
		mt.types[tname]( self, v )
	end
	return self
end

--- Push a string
mt.types[ 'string' ] = function( this, str )
	this._descriptions:push( str )
end

--- Push a function
mt.types[ 'function' ] = function( this, func )
	this._fixtures:push( func )
end

--- Push a table
mt.types[ 'table' ] = function( _, tbl )
	Subject.stack:push( tbl )
end

--- Check if the frame has descriptions
function Frame:hasDescriptions()
	return not self._descriptions:isEmpty()
end

--- Check number of descriptions
function Frame:numDescriptions()
	return self._descriptions:depth()
end

--- Check if the frame has fixtures
function Frame:hasFixtures()
	return not self._fixtures:isEmpty()
end

--- Check number of fixtures
function Frame:numFixtures()
	return self._fixtures:depth()
end

--- Check if the instance is evaluated
function Frame:isDone()
	return self._done
end

--- Get descriptions
function Frame:descriptions()
	return self._descriptions:export()
end

--- Get number of additional subjects
function Frame:numSubjects()
	return Subject.stack:depth() - self._depth
end

--- Eval the fixtures
function Frame:eval() -- luacheck: ignore
	if not self:hasFixtures() then
		Reports:push( FrameReport.create():setSkip( 'pickle-frame-no-fixtures' ) )
		self._eval = true
		return self
	end

	for _,v in ipairs( self:hasDescriptions()
			and { self._descriptions:export() }
			or { 'pickle-frame-no-description' } ) do
		local pos = 1
		local args = {}

		repeat
			local strategy, first, last = Extractors:find( v, pos )
			if strategy then
				table.insert( args, strategy:cast( v, first, last ) )
				pos = 1 + last
			end
		until( not strategy )

		for _,w in ipairs( { self._fixtures:export() } ) do
			local depth = Reports:depth()
			local t = { pcall( w, unpack{ args } ) }
			if ( not t[1] ) and (not not t[2]) then
				Reports:push( AdaptReport.create():setSkip( 'pickle-adapt-catched-exception' ) )
			end
			local report = FrameReport.create():setDescription( v )
			local added = Reports:depth() - depth
			if added == 0 then
				report:setSkip( 'pickle-frame-no-tests' )
			end
			report:addConstituents( Reports:pop( added ) )
			if t[1] and type( t[2] ) == 'table' then
				local tmp = AdaptReport.create():setTodo( 'pickle-adapt-catched-return' )
				for _,u in ipairs( t[2] or {} ) do
					tmp:addLine( mw.dumpObject( u ) )
				end
				report:addConstituent( tmp )
			end
			Reports:push( report )
		end
	end
	self._eval = true
	return self
end

-- Return the final class
return Frame
