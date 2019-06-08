--- Base class for Expect and Subject.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Adapt

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'
local util = require 'picklelib/util'
local ReportAdapt = require 'picklelib/report/ReportAdapt' -- @todo might be skipped

-- @var class var for lib
local Adapt = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Adapt:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Adapt:__index', 1, key, 'string', false )
	return Adapt[key]
end

-- @var metatable for the class
local mt = {}

--- Get a clone or create a new instance.
-- @function Adapt:__call
-- @tparam vararg ... conditionally passed to create
-- @treturn self
function mt:__call( ... )
	self:adaptations():push( select( '#', ... ) == 0
		and self:adaptations():top()
		or Adapt:create( ... ) )
	return self:adaptations():top()
end

setmetatable( Adapt, mt )

--- Create a new instance.
-- Assumption is either to create a new instance from an existing class,
-- or from a previous instance of some kind.
-- @tparam vararg ... set to temporal
-- @treturn self
function Adapt:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... set to temporal
-- @treturn self
function Adapt:_init( ... )
	local t = { ... }
	self._processes = Bag:create()
	self._report = nil
	self._temporal = t
	self._other = nil
	self._reorder = function( ... ) return ... end
	return self
end

-- @raise on wrong arguments
function Adapt:addProcess( func )
	libUtil.checkType( 'Adapt:addProcess', 1, func, 'function', false )
	self._processes:push( func )
	return self
end

--- Set the reference to the adaptations collection.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj that somehow maintain a collection
-- @treturn self
function Adapt:setAdaptations( obj )
	libUtil.checkType( 'Adapt:setAdaptations', 1, obj, 'table', false )
	self._adaptations = obj
	return self
end

--- Expose reference to adaptations.
-- If no report is set, then a new one is created.
-- @return list of adaptations
function Adapt:adaptations()
	if not self._adaptations then
		self._adaptations = Bag:create()
	end
	return self._adaptations
end

--- Set the reference to the reports collection.
-- This keeps a reference, the object is not cloned.
-- @raise on wrong arguments
-- @tparam table obj that somehow maintain a collection
-- @treturn self
function Adapt:setReports( obj )
	libUtil.checkType( 'Adapt:setReports', 1, obj, 'table', false )
	self._reports = obj
	return self
end

--- Expose reference to reports.
-- If no report is set, then a new one is created.
-- @return list of reports
function Adapt:reports()
	if not self._reports then
		self._reports = Bag:create()
	end
	return self._reports
end

--- Get the temporal.
-- Will not return a table unless it is packed in a table itself.
-- @return list|any
function Adapt:temporal()
	if type( self._temporal ) == 'table' then
		return unpack( self._temporal )
	end
	return self._temporal
end

--- Get the report.
-- If no report is set, then a new one is created.
-- @return ReportAdapt
function Adapt:report()
	if not self._report then
		self._report = ReportAdapt:create()
	end
	return self._report
end

--- Evaluate the registered processes with temporal as arguments.
-- @return list of any
function Adapt:eval()
	-- local tmp = self._subject or subjects:top()
	local tmp = self._temporal
	for _,v in ipairs( { self._processes:export() } ) do
		tmp = { v( unpack( tmp ) ) }
	end
	return unpack( tmp )
end

--- Make a delayed process for the pick functions.
-- This is a private function that will create a function with a closure.
-- It will create an additional delayed function for the provided definition.
-- @local
-- @delayed
-- @raise on wrong arguments
-- @tparam string name of the constructed created method
-- @tparam number idx of the extracted item
-- @treturn function
local function _makePickProcess( name, idx )
	libUtil.checkType( '_makePickProcess', 1, name, 'string', false )
	libUtil.checkType( '_makePickProcess', 2, idx, 'number', false )
	local g = function( ... )
		local t = { ... }
		return t[idx]
	end
	local f = function( self )
		self:report()
			:addLine( 'pickle-adapt-process-'..name )
		self:addProcess( g )
		return self
	end
	return f
end

-- @var table of definitions for the pick functions
-- Format is `name = index`
local picks = {
	--- Make a pick for first item.
	-- @pick
	-- @function Adapt:first
	first = 1,

	--- Make a pick for second item.
	-- @pick
	-- @function Adapt:second
	second = 2,

	--- Make a pick for third item.
	-- @pick
	-- @function Adapt:third
	third = 3,

	--- Make a pick for fourth item.
	-- @pick
	-- @function Adapt:fourth
	fourth = 4,

	--- Make a pick for fifth item.
	-- @pick
	-- @function Adapt:fifth
	fifth = 5,

	--- Make a pick for sixth item.
	-- @pick
	-- @function Adapt:sixth
	sixth = 6,

	--- Make a pick for seventh item.
	-- @pick
	-- @function Adapt:seventh
	seventh = 7,

	--- Make a pick for eight item.
	-- @pick
	-- @function Adapt:eight
	eight = 8,

	--- Make a pick for ninth item.
	-- @pick
	-- @function Adapt:ninth
	ninth = 9,

	--- Make a pick for tenth item.
	-- @pick
	-- @function Adapt:tenth
	tenth = 10,

	--- Make a pick for eleventh item.
	-- @pick
	-- @function Adapt:eleventh
	eleventh = 11,

	--- Make a pick for twelfth item.
	-- @pick
	-- @function Adapt:twelfth
	twelfth = 12
}

-- loop over the pick definitions and create the functions
for name,val in pairs( picks ) do
	assert( not Adapt[name], name )
	Adapt[name] = _makePickProcess( name, val )
end

--- Make a delayed process for the transform functions.
-- This is a private function that will create a function with a closure.
-- The delayed function comes from the provided definition.
-- @raise on wrong arguments
-- @local
-- @delayed
-- @tparam string name of the constructed created method
-- @tparam function func to adjust the process
-- @treturn function
local function _makeTransformProcess( name, func )
	libUtil.checkType( '_makeTransformProcess', 1, name, 'string', false )
	libUtil.checkType( '_makeTransformProcess', 2, func, 'function', false )
	local f = function( self )
		self:report()
			:addLine( 'pickle-adapt-process-'..util.buildName( name ) )
		self:addProcess( func )
		return self
	end
	return f
end

-- @var table of definitions for the transform functions
-- Format is ''name'' = { ''function'', { ''aliases, ... }
local transform = {
	--- Make a transform to get the argument type.
	-- @transform
	-- @function Adapt:asType
	-- @nick Adapt:type
	asType = {
		function( val )
			return type( val )
		end,
		{ 'type' } },

	--- Make a transform to get the string as upper case.
	-- @transform
	-- @function Adapt:asUpper
	-- @nick Adapt:upper
	-- @nick Adapt:asUC
	-- @nick Adapt:uc
	asUpper = {
		function( str )
			return string.upper( str )
		end,
		{ 'upper', 'asUC', 'uc' } },

	--- Make a transform to get the string as lower case.
	-- @transform
	-- @function Adapt:asLower
	-- @nick Adapt:lower
	-- @nick Adapt:asLC
	-- @nick Adapt:lc
	asLower = {
		function( str )
			return string.lower( str )
		end,
		{ 'lower', 'asLC', 'lc' } },

	--- Make a transform to get the string with first char as upper case.
	-- @transform
	-- @function Adapt:asUpperFirst
	-- @nick Adapt:upperfirst
	-- @nick Adapt:asUCFirst
	-- @nick Adapt:asUCfirst
	-- @nick Adapt:ucfirst
	asUpperFirst = {
		function( str )
			return string.upper( string.sub( str, 1, 1 ) )..string.sub( str, 2 )
		end,
		{ 'upperfirst', 'asUCFirst', 'asUCfirst', 'ucfirst' } },

	--- Make a transform to get the string with first char as lower case.
	-- @transform
	-- @function Adapt:asLowerFirst
	-- @nick Adapt:lowerfirst
	-- @nick Adapt:asLCFirst
	-- @nick Adapt:asLCfirst
	-- @nick Adapt:lcfirst
	asLowerFirst = {
		function( str )
			return string.lower( string.sub( str, 1, 1 ) )..string.sub( str, 2 )
		end,
		{ 'lowerfirst', 'asLCFirst', 'asLCfirst', 'lcfirst' } },

	--- Make a transform to get the string reversed.
	-- @transform
	-- @function Adapt:asReverse
	-- @nick Adapt:reverse
	asReverse = {
		function( str )
			return string.reverse( str )
		end,
		{ 'reverse' } },

	--- Make a transform to get the ustring as upper case.
	-- @transform
	-- @function Adapt:asUUpper
	-- @nick Adapt:uupper
	-- @nick Adapt:asUUC
	-- @nick Adapt:uuc
	asUUpper = {
		function( str )
			return mw.ustring.upper( str )
		end,
		{ 'uupper', 'asUUC', 'uuc' } },

	--- Make a transform to get the ustring as lower case.
	-- @transform
	-- @function Adapt:asULower
	-- @nick Adapt:ulower
	-- @nick Adapt:asULC
	-- @nick Adapt:ulc
	asULower = {
		function( str )
			return mw.ustring.lower( str )
		end,
		{ 'ulower', 'asULC', 'ulc' } },

	--- Make a transform to get the ustring with first code point as upper case.
	-- @transform
	-- @function Adapt:asUUpperFirst
	-- @nick Adapt:uupperfirst
	-- @nick Adapt:asUUCFirst
	-- @nick Adapt:asUUCfirst
	-- @nick Adapt:uucfirst
	asUUpperFirst = {
		function( str )
			return mw.ustring.upper( mw.ustring.sub( str, 1, 1 ) )..mw.ustring.sub( str, 2 )
		end,
		{ 'uupperfirst', 'asUUCFirst', 'asUUCfirst', 'uucfirst' } },

	--- Make a transform to get the ustring with first code point as lower case.
	-- @transform
	-- @function Adapt:asULowerFirst
	-- @nick Adapt:ulowerfirst
	-- @nick Adapt:asULCFirst
	-- @nick Adapt:asULCfirst
	-- @nick Adapt:ulcfirst
	asULowerFirst = {
		function( str )
			return mw.ustring.lower( mw.ustring.sub( str, 1, 1 ) )..mw.ustring.sub( str, 2 )
		end,
		{ 'ulowerfirst', 'asULCFirst', 'asULCfirst', 'ulcfirst' } },

	--- Make a transform to get the ustring as Normalized Form "C".
	-- @transform
	-- @function Adapt:asUNFC
	-- @nick Adapt:unfc
	-- @nick Adapt:uNFC
	-- @nick Adapt:nfc
	asUNFC = {
		function( str )
			return mw.ustring.toNFC( str )
		end,
		{ 'unfc', 'uNFC', 'nfc' } },

	--- Make a transform to get the ustring as Normalized Form "D".
	-- @transform
	-- @function Adapt:asUNFD
	-- @nick Adapt:unfd
	-- @nick Adapt:uNFD
	-- @nick Adapt:nfd
	asUNFD = {
		function( str )
			return mw.ustring.toNFD( str )
		end,
		{ 'unfd', 'uNFD', 'nfd' } },

	--- Make a transform to get the string as number.
	-- @transform
	-- @function Adapt:asNumber
	-- @nick Adapt:number
	-- @nick Adapt:asNum
	-- @nick Adapt:num
	asNumber = {
		function( str )
			return tonumber( str )
		end,
		{ 'number', 'asNum', 'num' } },

	--- Make a transform to get the number as string.
	-- @transform
	-- @function Adapt:asString
	-- @nick Adapt:string
	-- @nick Adapt:asStr
	-- @nick Adapt:str
	asString = {
		function( num )
			return tostring( num )
		end,
		{ 'string', 'asStr', 'str' } },

	--- Make a transform to get the next lower number.
	-- @transform
	-- @function Adapt:asFloor
	-- @nick Adapt:floor
	asFloor = {
		function( num )
			return math.floor( num )
		end,
		{ 'floor' } },

	--- Make a transform to get the next higher number.
	-- @transform
	-- @function Adapt:asCeil
	-- @nick Adapt:ceil
	asCeil = {
		function( num )
			return math.ceil( num )
		end,
		{ 'ceil' } },

	--- Make a transform to get the rounded number.
	-- @transform
	-- @function Adapt:asRound
	-- @nick Adapt:round
	asRound = {
		function( num )
			return num % 1 >= 0.5 and math.ceil( num ) or math.floor( num )
		end,
		{ 'round' } },

	--- Make a transform to get the integer part of the number.
	-- @transform
	-- @function Adapt:asInteger
	-- @nick Adapt:integer
	-- @nick Adapt:asInt
	-- @nick Adapt:int
	asInteger = {
		function( num )
			return num < 0 and math.ceil( num ) or math.floor( num )
		end,
		{ 'integer', 'asInt', 'int' } },

	--- Make a transform to get the fraction part of the number.
	-- @transform
	-- @function Adapt:asFraction
	-- @nick Adapt:fraction
	-- @nick Adapt:asFrac
	-- @nick Adapt:frac
	asFraction = {
		function( num )
			return num - ( num < 0 and math.ceil( num ) or math.floor( num ) )
		end,
		{ 'fraction', 'asFrac', 'frac' } },
}

-- loop over the transform definitions and create the functions
for name,lst in pairs( transform ) do
	local func = lst[1]
	Adapt[name] = _makeTransformProcess( name, func )
	for _,alias in ipairs( lst[2] ) do
		assert( not Adapt[alias], alias )
		Adapt[alias] = Adapt[name]
	end
end

--- Set the accessor for the other party.
-- For a subject the other part will be the expect, and for expect it will
-- be the subject.
-- @raise on wrong arguments
-- @tparam function func that points to the other party in a comparation
-- @treturn self
function Adapt:setOther( func )
	libUtil.checkType( 'Adapt:setOther', 1, func, 'function', false )
	self._other = func
	return self
end

--- Get the other part.
-- Note that this is the real other part, and not a previously set accessor.
-- @treturn nil,Adapt
function Adapt:other()
	if self._other then
		return self._other()
	end
	return nil
end

--- Reorder the pair of parties involved in the condition.
-- This can be overridden in subclasses.
-- Standard version which does an identity operation, that is it does not reorder arguments.
-- @tparam vararg ...
-- @return list
function Adapt:reorder( ... ) -- luacheck: no self
	return ...
end

--- Make a delayed process for the condition functions.
-- This is a private function that will create a function with a closure.
-- The delayed function comes from the provided definition.
-- @raise on wrong arguments
-- @local
-- @delayed
-- @tparam string name of the constructed created method
-- @tparam function func to adjust the process
-- @tparam nil|boolean other to swap the comparation
-- @treturn function
local function _makeConditionProcess( name, func, other )
	libUtil.checkType( '_makeConditionProcess', 1, name, 'string', false )
	libUtil.checkType( '_makeConditionProcess', 2, func, 'function', false )
		libUtil.checkType( '_makeConditionProcess', 3, other, 'boolean', true )
	local f = function( self )
		local report = self:report()
		self:report()
			:addLine( 'pickle-adapt-condition-'..util.buildName( name ) )
		self:report()
			:addLine( mw.dumpObject({ self:reorder( self:eval(), other or self:other() ) }) )
		local final = func( self:reorder( self:eval(), other or self:other() ) )
		if final then
			report:ok()
		end
		-- @todo add handover
		self:reports()
			:push( report )
		return report
	end
	return f
end

-- @var table of definitions for the comparator functions
-- Format is ''name'' = { ''function'', { ''aliases, ... }
local conditions = {
	--- Make a comparison to check equality.
	-- @condition
	-- @function toBeEqual
	-- @nick Adapt:equal
	-- @nick Adapt:isEqual
	-- @nick Adapt:ifEqual
	toBeEqual = {
		function ( a, b )
			return a == b
		end,
		{ 'equal', 'isEqual', 'ifEqual' } },

	--- Make a comparison to check boolean equality.
	-- @condition
	-- @function toBeBooleanEqual
	-- @nick Adapt:booleanequal
	-- @nick Adapt:isBooleanEqual
	-- @nick Adapt:ifBooleanEqual
	toBeBooleanEqual = {
		function ( a, b )
			return ( not not a ) == ( not not b )
		end,
		{ 'booleanequal', 'isBooleanEqual', 'ifBooleanEqual' } },

	--- Make a comparison to check strict equality.
	-- @condition
	-- @function toBeStrictEqual
	-- @nick Adapt:strictequal
	-- @nick Adapt:isStrictEqual
	-- @nick Adapt:ifStrictEqual
	toBeStrictEqual = {
		function ( a, b )
			return a == b and type( a ) == type( b )
		end,
		{ 'strictequal', 'isStrictEqual', 'ifStrictEqual' } },

	--- Make a comparison to check similarity.
	-- @condition
	-- @function toBeSame
	-- @nick Adapt:same
	-- @nick Adapt:isSame
	-- @nick Adapt:ifSame
	toBeSame = {
		function ( a, b )
			if ( type( a ) == type( b ) ) then
				return a == b
			elseif type( a ) == 'string' and type( b ) == 'number' then
				return a == tostring( b )
			elseif type( a ) == 'number' and type( b ) == 'string' then
				return a == tonumber( b )
			else
				return a == b
			end
		end,
		{ 'same', 'isSame', 'ifSame' } },

	--- Make a comparison to check deep equality.
	-- @condition
	-- @function toBeDeepEqual
	-- @nick Adapt:deepequal
	-- @nick Adapt:isDeepEqual
	-- @nick Adapt:ifDeepEqual
	toBeDeepEqual = {
		function ( a, b )
			return util.deepEqual( b, a )
		end,
		{ 'deepequal', 'isDeepEqual', 'ifDeepEqual' } },

	--- Make a comparison to check if first is contained in second.
	-- @condition
	-- @function toBeContained
	-- @nick Adapt:contained
	-- @nick Adapt:isContained
	-- @nick Adapt:ifContained
	toBeContained = {
		function ( a, b )
			return util.contains( b, a )
		end,
		{ 'contained', 'isContained', 'ifContained' } },

	--- Make a comparison to check if first is strict lesser than second.
	-- @condition
	-- @function toBeLesserThan
	-- @nick Adapt:lesser
	-- @nick Adapt:lt
	-- @nick Adapt:toBeLesser
	-- @nick Adapt:toBeLT
	-- @nick Adapt:isLesser
	-- @nick Adapt:isLT
	-- @nick Adapt:ifLesser
	-- @nick Adapt:ifLt
	toBeLesserThan = {
		function ( a, b )
			return a < b
		end,
		{
			'lesser', 'lt',
			'toBeLesser', 'toBeLT',
			'isLesser', 'isLT',
			'ifLesser', 'ifLT' }
		},

	--- Make a comparison to check if first is strict greater than second.
	-- @condition
	-- @function toBeGreaterThan
	toBeGreaterThan = {
		function ( a, b )
			return a > b
		end,
		{
			'greater', 'gt',
			'toBeGreater', 'toBeGT',
			'isGreater', 'isGT',
			'ifGreater', 'ifGT' }
		},

	--- Make a comparison to check if first is lesser or equal than second.
	-- @condition
	-- @function toBeLesserOrEqual
	toBeLesserOrEqual = {
		function ( a, b )
			return a <= b
		end,
		{
			'lesserOrEqual', 'le',
			'toBeLE',
			'isLesserOrEqual', 'isLE',
			'ifLesserOrEqual', 'ifLE' }
		},

	--- Make a comparison to check if first is strict greater or equal than second.
	-- @condition
	-- @function toBeGreaterOrEqual
	toBeGreaterOrEqual = {
		function ( a, b )
			return a >= b
		end,
		{
			'greaterOrEqual', 'ge',
			'toBeGE',
			'isGreaterOrEqual', 'isGE',
			'ifGreaterOrEqual', 'ifGE' }
		},

	--- Make a comparison to check if first is a match in second.
	-- @condition
	-- @function toBeMatch
	toBeMatch = {
		function ( a, b )
			return string.match( b, a ) or false
		end,
		{ 'match', 'isMatch', 'ifMatch' } },

	--- Make a comparison to check if first is an Unicode match in second.
	-- @condition
	-- @function toBeUMatch
	toBeUMatch = {
		function ( a, b )
			return mw.ustring.match( b, a ) or false
		end,
		{ 'umatch', 'isUMatch', 'ifUMatch' } },
}

-- loop over the condition definitions and create the functions
for name,lst in pairs( conditions ) do
	local func = lst[1]
	Adapt[name] = _makeConditionProcess( name, func ) -- @todo define other
	for _,alias in ipairs( lst[2] ) do
		assert( not Adapt[alias], alias )
		Adapt[alias] = Adapt[name]
	end
end

-- Return the final class.
return Adapt
