--- Baseclass for Describe, Context, and It.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Case

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'
local ReportAdapt = require 'picklelib/report/ReportAdapt'
local ReportCase = require 'picklelib/report/ReportCase'
local Translator = require 'picklelib/Translator'

-- @var class var for lib
local Case = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Case:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Case:__index', 1, key, 'string', false )
	return Case[key]
end

-- @var metatable for the class
local mt = { types = {} }

--- Get arguments for a class call.
-- @todo Verify if this ever get called
-- @todo Verify whether Case.__index creates problems with this metamethod
-- @local
-- @tparam vararg ... pass on to dispatch
-- @treturn self -ish
function mt:__call( ... ) -- luacheck: no self
	local obj = Case:create()
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
function Case:__call( ... )
	self:dispatch( ... )
	if self:isDone() then
		return nil, 'Failed, got a done instance. Is it run repeatedly in the debug console?'
	end
	if self:hasFixtures() then
		self:eval()
	end
	return self
end

setmetatable( Case, mt )

--- Create a new instance.
-- @tparam vararg ... list to be dispatched
-- @return Case
function Case:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... list to be dispatched (unused)
-- @return Case
function Case:_init()
	self._descriptions = Bag:create()
	self._fixtures = Bag:create()
	self._done = false
	self._type = 'case'
	self._name = '<unknown>'
	return self
end

--- Dispach on type.
-- @tparam vararg ... list to dispatch
-- @treturn self
function Case:dispatch( ... )
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
	-- @function Case.types:string
	-- @tparam table self place to store value
	-- @tparam string val that should be stored
	['string'] = function( self, val )
		self._descriptions:push( val )
	end,

	--- Push a function.
	-- @local
	-- @function Case.types:function
	-- @tparam table self place to store value
	-- @tparam function func that should be stored
	['function'] = function( self, func )
		self._fixtures:push( func )
	end,

	--- Push a table.
	-- @local
	-- @function Case.types:table
	-- @tparam table self place to store value
	-- @tparam table tbl that should be stored
	['table'] = function( self, tbl )
		self._subjects:push( tbl )
	end,

}

--- Get the type of case
-- All frames has an explicit type name.
-- @treturn string
function Case:type()
	return self._type
end

--- Set key for name of case.
-- @tparam string key part of a message
-- @treturn self
function Case:setName( key )
	self._name = key
	return self
end

--- Check if the case has name.
-- @treturn boolean
function Case:hasName()
	return not not self._name
end

--- Get the name as key for case.
-- All frames may have an explicit name.
-- @treturn string
function Case:getName()
	return self._name or '<unset>'
end

--- Check if the case has descriptions.
-- @treturn boolean
function Case:hasDescriptions()
	return not self._descriptions:isEmpty()
end

--- Check number of descriptions.
-- @treturn number
function Case:numDescriptions()
	return self._descriptions:depth()
end

--- Check if the case has fixtures.
-- @treturn boolean
function Case:hasFixtures()
	return not self._fixtures:isEmpty()
end

--- Check number of fixtures.
-- @treturn number
function Case:numFixtures()
	return self._fixtures:depth()
end

--- Check if the instance is evaluated.
-- @treturn boolean
function Case:isDone()
	return self._done
end

--- Get descriptions.
-- @return list of descriptions
function Case:descriptions()
	return self._descriptions:export()
end

--- Set the reference to the subjects collection.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Case:setSubjects( obj )
	libUtil.checkType( 'Case:setSubjects', 1, obj, 'table', false )
	self._subjects = obj
	return self
end

--- Expose reference to subjects.
-- @return list of subjects
function Case:subjects()
	return self._subjects
end

--- Set the reference to the reports collection.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Case:setReports( obj )
	libUtil.checkType( 'Case:setReports', 1, obj, 'table', false )
	self._reports = obj
	return self
end

--- Expose reference to reports.
-- @return list of reports
function Case:reports()
	return self._reports
end

--- Set the reference to the extractors.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Case:setExtractors( obj )
	libUtil.checkType( 'Case:setExtractors', 1, obj, 'table', false )
	self._extractors = obj
	return self
end

--- Expose reference to extractors.
-- @return list of extractors
function Case:extractors()
	return self._extractors
end

--- Set the reference to the translators.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Case:setTranslators( obj )
	libUtil.checkType( 'Case:setTranslators', 1, obj, 'table', false )
	self._translators = obj
	return self
end

--- Expose reference to translators.
-- @return list of translators
function Case:translators()
	return self._translators
end

--- Set the reference to the renders.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj somehow maintain a collection
-- @treturn self
function Case:setRenders( obj )
	libUtil.checkType( 'Case:setRenders', 1, obj, 'table', false )
	self._renders = obj
	return self
end

--- Expose reference to renders.
-- @return list of renders
function Case:renders()
	return self._renders
end

--- Eval a single fixture.
-- @raise on wrong arguments
-- @tparam string description
-- @tparam function fixture
-- @tparam table environment
-- @param ...
function Case:evalFixture( description, fixture, environment, ... )
	libUtil.checkType( 'Case:evalFixture', 1, description, 'string', false )
	libUtil.checkType( 'Case:evalFixture', 2, fixture, 'function', false )
	libUtil.checkType( 'Case:evalFixture', 3, environment, 'table', false )

	local depth = self:reports():depth()
	local t= { pcall( mw.pickle._IMPLICIT and setfenv( fixture, environment ) or fixture, ... ) }
	if ( not t[1] ) and (not not t[2]) then
		local msg = mw.message.new( 'pickle-adapt-catched-exception' )
		self:reports():push( ReportAdapt:create():setSkip( msg ) )
	end
	local report = ReportCase:create():setDescription( description )
	if self:hasName() then
		report:setName( self:getName() )
	end
	local added = self:reports():depth() - depth
	assert( added >= 0, 'Case:evalFixture; depth less than zero ')
	if added == 0 then
		local msg = mw.message.new( 'pickle-case-no-tests' )
		report:setTodo( msg )
	end
	report:addConstituents( self:reports():pop( added ) )
	if t[1] and type( t[2] ) == 'table' then
		local msg = mw.message.new( 'pickle-adapt-catched-return' )
		local tmp = ReportAdapt:create():setTodo( msg )
		for _,u in ipairs( t[2] or {} ) do
			tmp:addLine( mw.dumpObject( u ) )
		end
		report:addConstituent( tmp )
	end
	self:reports():push( report )
end

--- Eval the fixtures over previous dispatched strings.
-- @treturn self
function Case:eval()
	if not self:hasFixtures() then
		local msg = mw.message.new( 'pickle-case-no-fixtures' )
		self:reports():push( ReportCase:create():setTodo( msg ) )
		return self
	end
	local env = mw.pickle._IMPLICIT and getfenv(1) or _G

	for _,v in ipairs( self:hasDescriptions()
			and { self:descriptions() }
			or { '' } ) do
		local pos = 1
		local args = {}
		local translator = Translator:create()

		repeat
			local strategy, first, last = self._extractors:find( v, pos )
			if strategy then
				table.insert( args, strategy:cast( mw.ustring.sub( v, first, last ) ) )
				translator:addPart( mw.ustring.sub( v, pos, first ) )
				translator:addPlaceholder( strategy:placeholder() )
				pos = 1 + last
			else
				translator:addPart( mw.ustring.sub( v, pos ) )
			end
		until( not strategy )

		local key = translator:getKey()
		if not self._translators:find( key ) then
			self._translators:register( key, translator )
		end

		for _,w in ipairs( { self._fixtures:export() } ) do
			self:evalFixture( v, w, env, unpack{ args } )
		end
	end
	self._done = true
	return self
end

-- Return the final class.
return Case
