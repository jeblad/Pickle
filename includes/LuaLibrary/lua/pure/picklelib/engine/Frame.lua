--- Baseclass for Describe, Context, and It.
-- @classmod Frame

-- pure libs
local libUtil = require 'libraryUtil'
local Stack = require 'picklelib/Stack'
local ReportAdapt = require 'picklelib/report/ReportAdapt'
local ReportFrame = require 'picklelib/report/ReportFrame'

-- @var class var for lib
local Frame = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Frame:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Frame:__index', 1, key, 'string', false )
	return Frame[key]
end

-- @var metatable for the class
local mt = { types = {} }

--- Get arguments for a class call.
-- @todo Verify if this ever get called
-- @local
-- @tparam vararg ... pass on to dispatch
-- @treturn self -ish
function mt:__call( ... ) -- luacheck: no self
	local obj = Frame.create()
	obj:dispatch( ... )
	if obj:isDone() then
		return nil, 'Failed, got a done instance'
	end
	if obj:hasFixtures( obj ) then
		obj:eval()
	end
	return obj
end

--- Get arguments for a instance call.
-- @tparam vararg ... pass on to dispatch
-- @treturn self
function Frame:__call( ... )
	self:dispatch( ... )
	if self:isDone() then
		return nil, 'Failed, got a done instance. Is it run repeatedly in the debug console?'
	end
	if self:hasFixtures() then
		self:eval()
	end
	return self
end

setmetatable( Frame, mt )

--- Create a new instance.
-- @tparam vararg ... list to be dispatched
-- @return Frame
function Frame.create( ... )
	local self = setmetatable( {}, Frame )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... list to be dispatched (unused)
-- @return Frame
function Frame:_init()
	self._descriptions = Stack:create()
	self._fixtures = Stack:create()
	self._done = false
	return self
end

--- Dispach on type.
-- @tparam vararg ... list to dispatch
-- @treturn self
function Frame:dispatch( ... )
	for _,v in ipairs( { ... } ) do
		local tname = type( v )
		if not mt.types[tname] then
			return nil, 'Failed to find a type handler'
		end
		mt.types[tname]( self, v )
	end
	return self
end

mt.types = {

	--- Push a string.
	-- @local
	-- @function Frame.types:string
	-- @tparam table self place to store value
	-- @tparam string val that should be stored
	['string'] = function( self, val )
		self._descriptions:push( val )
	end,

	--- Push a function.
	-- @local
	-- @function Frame.types:function
	-- @tparam table self place to store value
	-- @tparam function func that should be stored
	['function'] = function( self, func )
		self._fixtures:push( func )
	end,

	--- Push a table.
	-- @local
	-- @function Frame.types:table
	-- @tparam table self place to store value
	-- @tparam table tbl that should be stored
	['table'] = function( self, tbl )
		self._subjects:push( tbl )
	end,

}

--- Check if the frame has descriptions.
-- @treturn boolean
function Frame:hasDescriptions()
	return not self._descriptions:isEmpty()
end

--- Check number of descriptions.
-- @treturn number
function Frame:numDescriptions()
	return self._descriptions:depth()
end

--- Check if the frame has fixtures.
-- @treturn boolean
function Frame:hasFixtures()
	return not self._fixtures:isEmpty()
end

--- Check number of fixtures.
-- @treturn number
function Frame:numFixtures()
	return self._fixtures:depth()
end

--- Check if the instance is evaluated.
-- @treturn boolean
function Frame:isDone()
	return self._done
end

--- Get descriptions.
-- @return list of descriptions
function Frame:descriptions()
	return self._descriptions:export()
end

--- Set the reference to the subjects collection.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Frame:setSubjects( obj )
	libUtil.checkType( 'Frame:setSubjects', 1, obj, 'table', false )
	self._subjects = obj
	return self
end

--- Expose reference to subjects.
-- @return list of subjects
function Frame:subjects()
	return self._subjects
end

--- Set the reference to the reports collection.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Frame:setReports( obj )
	libUtil.checkType( 'Frame:setReports', 1, obj, 'table', false )
	self._reports = obj
	return self
end

--- Expose reference to reports.
-- @return list of reports
function Frame:reports()
	return self._reports
end

--- Set the reference to the extractors.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Frame:setExtractors( obj )
	libUtil.checkType( 'Frame:setExtractors', 1, obj, 'table', false )
	self._extractors = obj
	return self
end

--- Expose reference to extractors.
-- @return list of extractors
function Frame:extractors()
	return self._extractors
end

--- Set the reference to the translators.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Frame:setTranslators( obj )
	libUtil.checkType( 'Frame:setTranslators', 1, obj, 'table', false )
	self._translators = obj
	return self
end

--- Expose reference to translators.
-- @return list of translators
function Frame:translators()
	return self._translators
end

--- Set the reference to the renders.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Frame:setRenders( obj )
	libUtil.checkType( 'Frame:setRenders', 1, obj, 'table', false )
	self._renders = obj
	return self
end

--- Expose reference to renders.
-- @return list of renders
function Frame:renders()
	return self._renders
end

--- Eval a single fixture.
-- @raise on wrong arguments
-- @tparam string description
-- @tparam function fixture
-- @tparam table environment
-- @param ...
function Frame:evalFixture( description, fixture, environment, ... )
	libUtil.checkType( 'Frame:evalFixture', 1, description, 'string', false )
	libUtil.checkType( 'Frame:evalFixture', 2, fixture, 'function', false )
	libUtil.checkType( 'Frame:evalFixture', 3, environment, 'table', false )

	local depth = self:reports():depth()
	local t= { pcall( mw.pickle._implicit and setfenv( fixture, environment ) or fixture, ... ) }
	if ( not t[1] ) and (not not t[2]) then
		self:reports()
			:push( ReportAdapt:create():setSkip( 'pickle-adapt-catched-exception' ) )
	end
	local report = ReportFrame:create():setDescription( description )
	local added = self:reports():depth() - depth
	if added == 0 then
		report:setTodo( 'pickle-frame-no-tests' )
	end
	report:addConstituents( self:reports():pop( added ) )
	if t[1] and type( t[2] ) == 'table' then
		local tmp = ReportAdapt:create():setTodo( 'pickle-adapt-catched-return' )
		for _,u in ipairs( t[2] or {} ) do
			tmp:addLine( mw.dumpObject( u ) )
		end
		report:addConstituent( tmp )
	end
	self:reports():push( report )
end

--- Eval the fixtures over previous dispatched strings.
-- @treturn self
function Frame:eval()
	if not self:hasFixtures() then
		self:reports()
			:push( ReportFrame:create():setTodo( 'pickle-frame-no-fixtures' ) )
		return self
	end
	local env = mw.pickle._implicit and getfenv(1) or _G

	for _,v in ipairs( self:hasDescriptions()
			and { self:descriptions() }
			or { '' } ) do
		local pos = 1
		local args = {}
		local keyFrags = {}
		local descFrags = {}

		repeat
			local strategy, first, last = self:extractors():find( v, pos )
			if strategy then
				-- table.insert( keyFrags, v:sub( first, last ) )
				-- table.insert( descFrags, v:sub( first, last ) )
				table.insert( args, strategy:cast( v, first, last ) )
				-- table.insert( keyFrags, strategy:placeholder() )
				pos = 1 + last
			else
				-- table.insert( keyFrags, v:sub( pos ) )
				-- table.insert( descFrags, v:sub( pos ) )
			end
		until( not strategy )


		for _,w in ipairs( { self._fixtures:export() } ) do
			self:evalFixture( v, w, env, unpack{ args } )
		end
	end
	self._done = true
	return self
end

-- Return the final class.
return Frame
