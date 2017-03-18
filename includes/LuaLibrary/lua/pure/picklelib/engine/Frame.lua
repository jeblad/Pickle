-- Baseclass for Describe, Context, and It

-- pure libs
local Stack = require 'picklelib/Stack'
-- local util = require 'picklelib/util'

-- @var class var for lib
local Frame = {}

-- non-pure libs
local FrameReport -- luacheck: ignore
local Subject
local Extractors
-- Setup for prod or test
if mw.pickle then
	-- production, structure exist, make access simpler
	FrameReport = mw.pickle.report.frame
	Subject = mw.pickle.subject
	Extractors = mw.pickle.extractors
else
	-- test, structure does not exist, require the libs
	FrameReport = require 'picklelib/report/FrameReport'
	Subject = require 'picklelib/engine/Subject'
	Extractors = require('picklelib/extractor/ExtractorStrategies').create()

	--- Expose report
	function Frame:report() -- luacheck: ignore self
		return FrameReport
	end

	--- Expose subject
	function Frame:subject() -- luacheck: ignore self
		return Subject
	end

	--- Expose extractors
	function Frame:extractors() -- luacheck: ignore self
		return Extractors
	end
end

--- Lookup of missing class members
function Frame:__index( key ) -- luacheck: ignore self
	return Frame[key]
end

-- @var metatable for the class
local mt = {}

--- Get arguments for a class call
function mt:__call( ... ) -- luacheck: ignore
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
		local tname = type( v )..'Type'
		assert( self[tname], 'Failed to find a type handler' )
		self[tname]( self, v )
	end
	return self
end

--- Push a string
function Frame:stringType( ... )
	self._descriptions:push( ... )
end

--- Push a function
function Frame:functionType( ... )
	self._fixtures:push( ... )
end

--- Push a table
function Frame:tableType( ... ) -- luacheck: ignore
	Subject.stack:push( ... )
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
		-- @todo should create a descriptive skip message
		--Report.create(  )
		self._eval = true
		return self
	end

	for _,v in ipairs( self:hasDescriptions()
			and { self._descriptions:export() }
			or { 'has no description' } ) do
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
			local res, data = pcall( w( unpack{ args } ) )
			if res then
				-- @todo should capture content on stack
			else
				-- @todo should create a descriptive error message
			end
			--Report.create(  )
		end
	end
	self._eval = true
	return self
end

-- Return the final class
return Frame
