--- Baseclass for Expect and Subject

-- pure libs
local Stack = require 'picklelib/Stack'
local util = require 'picklelib/util'
local AdaptReport = require 'picklelib/report/AdaptReport' -- @todo might be skipped

-- @var class var for lib
local Adapt = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Adapt:__index( key ) -- luacheck: no self
	return Adapt[key]
end

--- Create a new instance
-- @param vararg set to temporal
-- @return self
function Adapt.create( ... )
	local self = setmetatable( {}, Adapt )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg set to temporal
-- @return self
function Adapt:_init( ... )
	local t = { ... }
	self._processes = Stack.create()
	self._report = nil
	self._temporal = t
	self._other = nil
	self._reorder = function( ... ) return ... end
	return self
end

function Adapt:addProcess( func )
	assert( type( func ) == 'function' )
	self._processes:push( func )
	return self
end

--- Set the reference to the reports collection
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Adapt:setReports( obj )
	assert( type( obj ) == 'table' )
	self._reports = obj
	return self
end

--- Expose reference to reports
function Adapt:reports()
	if not self._reports then
		self._reports = Stack.create()
	end
	return self._reports
end

--- Get the temporal
-- Will not return a table unless it is packed in a table itself.
-- @return {list|any}
function Adapt:temporal()
	if type( self._temporal ) == 'table' then
		return unpack( self._temporal )
	end
	return self._temporal
end

--- Get the report
-- If no report is set, then a new one is created.
-- @return AdaptReport
function Adapt:report()
	if not self._report then
		self._report = AdaptReport.create()
	end
	return self._report
end

--- Evaluate the registered processes with temporal as arguments
-- @return list of any
function Adapt:eval()
	-- local tmp = self._subject or subjects:top()
	local tmp = self._temporal
	for _,v in ipairs( { self._processes:export() } ) do
		tmp = { v( unpack( tmp ) ) }
	end
	return unpack( tmp )
end

--- Make a delayed process for the pick functions
-- This is a private function that will create a function with a closure.
-- It will create an additional delayed function for the provided definition.
-- @private
-- @param string name of the constructed created method
-- @param number index of the extracted item
-- @return function
local function _makePickProcess( name, idx )
	local g = function( ... )
		local t = { ... }
		return t[idx]
	end
	local f = function( self )
		self:report():addLine( 'pickle-adapt-process-'..name )
		self:addProcess( g )
		return self
	end
	return f
end

-- @var table of definitions for the pick functions
-- Format is ''name'' = ''index''
local picks = {
	--- Make a pick process for first item
	first = 1,

	--- Make a pick process for second item
	second = 2,

	--- Make a pick process for third item
	third = 3,

	--- Make a pick process for fourth item
	fourth = 4,

	--- Make a pick process for fifth item
	fifth = 5,

	--- Make a pick process for sixth item
	sixth = 6,

	--- Make a pick process for seventh item
	seventh = 7,

	--- Make a pick process for eight item
	eight = 8,

	--- Make a pick process for ninth item
	ninth = 9,

	--- Make a pick process for tenth item
	tenth = 10,

	--- Make a pick process for eleventh item
	eleventh = 11,

	--- Make a pick process for twelfth item
	twelfth = 12
}

-- loop over the pick definitions and create the functions
for name,val in pairs( picks ) do
	assert( not Adapt[name], name )
	Adapt[name] = _makePickProcess( name, val )
end

--- Make a delayed process for the general functions
-- This is a private function that will create a function with a closure.
-- The delayed function comes from the provided definition.
-- @private
-- @param string name of the constructed created method
-- @param function to adjust the process
-- @return function
local function _makeGeneralProcess( name, func )
	local f = function( self )
		self:report():addLine( 'pickle-adapt-process-'..util.buildName( name ) )
		self:addProcess( func )
		return self
	end
	return f
end

-- @var table of definitions for the transform functions
-- Format is ''name'' = { ''function'', { ''aliases, ... }
local general = {
	--- Make a transform process to get the argument type
	asType = {
		function( val )
			return type( val )
		end,
		{ 'type' } },

	--- Make a transform process to get the string as upper case
	asUpper = {
		function( str )
			return string.upper( str )
		end,
		{ 'upper', 'asUC', 'uc' } },

	--- Make a transform process to get the string as lower case
	asLower = {
		function( str )
			return string.lower( str )
		end,
		{ 'lower', 'asLC', 'lc' } },

	--- Make a transform process to get the string with first char as upper case
	asUpperFirst = {
		function( str )
			return string.upper( string.sub( str, 1, 1 ) )..string.sub( str, 2 )
		end,
		{ 'upperfirst', 'asUCFirst', 'asUCfirst', 'ucfirst' } },

	--- Make a transform process to get the string with first char as lower case
	asLowerFirst = {
		function( str )
			return string.lower( string.sub( str, 1, 1 ) )..string.sub( str, 2 )
		end,
		{ 'lowerfirst', 'asLCFirst', 'asLCfirst', 'lcfirst' } },

	--- Make a transform process to get the string reversed
	asReverse = {
		function( str )
			return string.reverse( str )
		end,
		{ 'reverse' } },

	--- Make a transform process to get the Unicode string as upper case
	asUUpper = {
		function( str )
			return mw.ustring.upper( str )
		end,
		{ 'uupper', 'asUUC', 'uuc' } },

	--- Make a transform process to get the Unicode string as lower case
	asULower = {
		function( str )
			return mw.ustring.lower( str )
		end,
		{ 'ulower', 'asULC', 'ulc' } },

	--- Make a transform process to get the Unicode string with first code point as upper case
	asUUpperFirst = {
		function( str )
			return mw.ustring.upper( mw.ustring.sub( str, 1, 1 ) )..mw.ustring.sub( str, 2 )
		end,
		{ 'uupperfirst', 'asUUCFirst', 'asUUCfirst', 'uucfirst' } },

	--- Make a transform process to get the Unicode string with first code point as lower case
	asULowerFirst = {
		function( str )
			return mw.ustring.lower( mw.ustring.sub( str, 1, 1 ) )..mw.ustring.sub( str, 2 )
		end,
		{ 'ulowerfirst', 'asULCFirst', 'asULCfirst', 'ulcfirst' } },

	--- Make a transform process to get the Unicode string as Normalized Form "C"
	asUNFC = {
		function( str )
			return mw.ustring.toNFC( str )
		end,
		{ 'unfc', 'uNFC', 'nfc' } },

	--- Make a transform process to get the Unicode string as Normalized Form "D"
	asUNFD = {
		function( str )
			return mw.ustring.toNFD( str )
		end,
		{ 'unfd', 'uNFD', 'nfd' } },

	--- Make a transform process to get the string as number
	asNumber = {
		function( str )
			return tonumber( str )
		end,
		{ 'number', 'asNum', 'num' } },

	--- Make a transform process to get the number as string
	asString = {
		function( num )
			return tostring( num )
		end,
		{ 'string', 'asStr', 'str' } },

	--- Make a transform process to get the next lower number
	asFloor = {
		function( num )
			return math.floor( num )
		end,
		{ 'floor' } },

	--- Make a transform process to get the next higher number
	asCeil = {
		function( num )
			return math.ceil( num )
		end,
		{ 'ceil' } },

	--- Make a transform process to get the rounded number
	asRound = {
		function( num )
			return num % 1 >= 0.5 and math.ceil( num ) or math.floor( num )
		end,
		{ 'round' } },

	--- Make a transform process to get the integer part of the number
	asInteger = {
		function( num )
			return num < 0 and math.ceil( num ) or math.floor( num )
		end,
		{ 'integer', 'asInt', 'int' } },

	--- Make a transform process to get the fraction part of the number
	asFraction = {
		function( num )
			return num - ( num < 0 and math.ceil( num ) or math.floor( num ) )
		end,
		{ 'fraction', 'asFrac', 'frac' } },
}

-- loop over the general definitions and create the functions
for name,lst in pairs( general ) do
	local func = lst[1]
	Adapt[name] = _makeGeneralProcess( name, func )
	for _,alias in ipairs( lst[2] ) do
		assert( not Adapt[alias], alias )
		Adapt[alias] = Adapt[name]
	end
end

--- Set the accessor for the other party
-- For a subject the other part will be the expect, and for expect it will
-- be the subject.
-- @param function that points to the other party in a comparation
function Adapt:setOther( func )
	assert( type( func ) == 'function' )
	self._other = func
end

--- Get the other part
-- Note that this is the real other part, and not a previously set accessor.
function Adapt:other()
	if self._other then
		return self._other()
	end
	return nil
end

--- Reorder the pair of parties involved in the condition
-- This can be overridden in subclasses.
-- Standard version which does an identity operation, that is it does not reorder arguments.
-- @param vararg
-- @return list
function Adapt:reorder( ... ) -- luacheck: no self
	return ...
end

--- Make a delayed process for the condition functions
-- This is a private function that will create a function with a closure.
-- The delayed function comes from the provided definition.
-- @private
-- @param string name of the constructed created method
-- @param function to adjust the process
-- @param boolean to swap the comparation
-- @return function
local function _makeConditionProcess( name, func, other )
	local f = function( self )
		local report = self:report()
		self:report():addLine( 'pickle-adapt-condition-'..util.buildName( name ) )
		self:report():addLine( mw.dumpObject({ self:reorder( self:eval(), other or self:other() ) }) )
		local final = func( self:reorder( self:eval(), other or self:other() ) )
		if final then
			report:ok()
		end
		-- @todo add handover
		self:reports():push( report )
		return report
	end
	return f
end

-- @var table of definitions for the comparator functions
-- Format is ''name'' = { ''function'', { ''aliases, ... }
local conditions = {
	--- Make a comparison process to check equality
	toBeEqual = {
		function ( a, b )
			return a == b
		end,
		{ 'equal', 'isEqual', 'ifEqual' } },

	--- Make a comparison process to check boolean equality
	toBeBooleanEqual = {
		function ( a, b )
			return ( not not a ) == ( not not b )
		end,
		{ 'booleanequal', 'isBooleanEqual', 'ifBooleanEqual' } },

	--- Make a comparison process to check strict equality
	toBeStrictEqual = {
		function ( a, b )
			return a == b and type( a ) == type( b )
		end,
		{ 'strictequal', 'isStrictEqual', 'ifStrictEqual' } },

	--- Make a comparison process to check similarity
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

	--- Make a comparison process to check deep equality
	toBeDeepEqual = {
		function ( a, b )
			return util.deepEqual( b, a )
		end,
		{ 'deepequal', 'isDeepEqual', 'ifDeepEqual' } },

	--- Make a comparison process to check if first is contained in second
	toBeContained = {
		function ( a, b )
			return util.contains( b, a )
		end,
		{ 'contained', 'isContained', 'ifContained' } },

	--- Make a comparison process to check if first is strict lesser than second
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

	--- Make a comparison process to check if first is strict greater than second
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

	--- Make a comparison process to check if first is lesser or equal than second
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

	--- Make a comparison process to check if first is strict greater or equal than second
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

	--- Make a comparison process to check if first is a match in second
	toBeMatch = {
		function ( a, b )
			return string.match( b, a ) or false
		end,
		{ 'match', 'isMatch', 'ifMatch' } },

	--- Make a comparison process to check if first is an Unicode match in second
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

-- Return the final class
return Adapt
