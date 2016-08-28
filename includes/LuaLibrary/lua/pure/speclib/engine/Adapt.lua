--- Baseclass for Expect and Subject
-- This holds nearly all the common stuff.

local Report = require 'speclib/report/Result'
local Stack = require 'speclib/Stack'
local util = require 'speclib/util'

local Adapt = {}
--Adapt.__index = Adapt
function Adapt:__index( key )
    return Adapt[key]
end

local function buildName( str )
	return str:gsub("([A-Z])", function(str) return '-'..string.lower(str) end )
end

function Adapt.create( ... )
    local self = setmetatable( {}, Adapt )
    self:_init( ... )
    return self
end

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

function Adapt:temporal()
    if type( self._temporal ) == 'table' then
        return unpack( self._temporal )
    end
    return self._temporal
end

function Adapt:report()
    if not self._report then
        self._report = Report.create()
    end
    return self._report
end

function Adapt:eval()
    -- local tmp = self._subject or subjects:top()
    local tmp = self._temporal
    for _,v in ipairs( { self._processes:export() } ) do
        tmp = { v( unpack( tmp ) ) }
    end
    return unpack( tmp )
end

function makePickProcess( name, idx )
    local g = function( ... )
        local t = { ... }
        return t[idx]
    end
    local f = function( self )
        self:report():addLine( 'spec-adapt-process-'..name )
        self:addProcess( g )
        return self
    end
    return f
end

local picks = { first = 1, second = 2, third = 3, fourth = 4,
    fifth = 5, sixth = 6, seventh = 7, eight = 8,
    ninth = 9, tenth = 10, eleventh = 11, twelfth = 12
}

for name,val in pairs( picks ) do
    assert( not Adapt[alias], alias )
    Adapt[name] = makePickProcess( name, val )
end

function makeGeneralProcess( name, func )
    local f = function( self )
        self:report():addLine( 'spec-adapt-process-'..buildName( name ) )
        self:addProcess( func )
        return self
    end
    return f
end

local general = {
    asType = {
        function( val )
            return type( val )
        end,
        { 'type' } },
    asUpper = {
        function( str )
            return string.upper( str )
        end,
        { 'upper', 'asUC', 'uc' } },
    asLower = {
        function( str )
            return string.lower( str )
        end,
        { 'lower', 'asLC', 'lc' } },
    asUpperFirst = {
        function( str )
            return string.upper( string.sub( str, 1, 1 ) )..string.sub( str, 2 )
        end,
        { 'upperfirst', 'asUCFirst', 'asUCfirst', 'ucfirst' } },
    asLowerFirst = {
        function( str )
            return string.lower( string.sub( str, 1, 1 ) )..string.sub( str, 2 )
        end,
        { 'lowerfirst', 'asLCFirst', 'asLCfirst', 'lcfirst' } },
    asReverse = {
        function( str )
            return string.reverse( str )
        end,
        { 'reverse' } },
    asUUpper = {
        function( str )
            return mw.ustring.upper( str )
        end,
        { 'uupper', 'asUUC', 'uuc' } },
    asULower = {
        function( str )
            return mw.ustring.lower( str )
        end,
        { 'ulower', 'asULC', 'ulc' } },
    asUUpperFirst = {
        function( str )
            return mw.ustring.upper( mw.ustring.sub( str, 1, 1 ) )..mw.ustring.sub( str, 2 )
        end,
        { 'uupperfirst', 'asUUCFirst', 'asUUCfirst', 'uucfirst' } },
    asULowerFirst = {
        function( str )
            return mw.ustring.lower( mw.ustring.sub( str, 1, 1 ) )..mw.ustring.sub( str, 2 )
        end,
        { 'ulowerfirst', 'asULCFirst', 'asULCfirst', 'ulcfirst' } },
    asUNFC = {
        function( str )
            return mw.ustring.toNFC( str )
        end,
        { 'unfc', 'uNFC', 'nfc' } },
    asUNFD = {
        function( str )
            return mw.ustring.toNFD( str )
        end,
        { 'unfd', 'uNFD', 'nfd' } },
    asNumber = {
        function( str )
            return tonumber( str )
        end,
        { 'number', 'asNum', 'num' } },
    asString = {
        function( num )
            return tostring( num )
        end,
        { 'string', 'asStr', 'str' } },
    asFloor = {
        function( num )
            return math.floor( num )
        end,
        { 'floor' } },
    asCeil = {
        function( num )
            return math.ceil( num )
        end,
        { 'ceil' } },
    asRound = {
        function( num )
            return num % 1 >= 0.5 and math.ceil( num ) or math.floor( num )
        end,
        { 'round' } },
    asInteger = {
        function( num )
            return num < 0 and math.ceil( num ) or math.floor( num )
        end,
        { 'integer', 'asInt', 'int' } },
    asFraction = {
        function( num )
            return num - ( num < 0 and math.ceil( num ) or math.floor( num ) )
        end,
        { 'fraction', 'asFrac', 'frac' } },
}

for name,lst in pairs( general ) do
    local func = lst[1]
    Adapt[name] = makeGeneralProcess( name, func )
    for _,alias in ipairs( lst[2] ) do
        assert( not Adapt[alias], alias )
        Adapt[alias] = Adapt[name]
    end
end

function Adapt:setOther( func )
    assert( type( func ) == 'function' )
    self._other = func
end

function Adapt:other()
    if self._other then
        return self._other()
    end
    return nil
end

function Adapt:reorder( ... )
    return ...
end

function makeConditionProcess( name, func, other )
    local f = function( self )
        local report = self:report()
        self:report():addLine( 'spec-adapt-condition-'..buildName( name ) )
        self:report():addLine( mw.dumpObject({ self:reorder( self:eval(), other or self:other() ) }) )
        local final = func( self:reorder( self:eval(), other or self:other() ) )
        if final then
            report:ok()
        end
        -- @todo add handover
        return report
    end
    return f
end

local conditions = {
    toBeEqual = {
        function ( a, b )
			return a == b
		end,
        { 'equal', 'isEqual', 'ifEqual' } },
    toBeBooleanEqual = {
        function ( a, b )
			return ( not not a ) == ( not not b )
		end,
        { 'booleanequal', 'isBooleanEqual', 'ifBooleanEqual' } },
    toBeStrictEqual = {
        function ( a, b )
			return a == b and type( a ) == type( b )
		end,
        { 'strictequal', 'isStrictEqual', 'ifStrictEqual' } },
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
    toBeDeepEqual = {
        function ( a, b )
			return util.deepEqual( b, a )
		end,
        { 'deepequal', 'isDeepEqual', 'ifDeepEqual' } },
    toBeContained = {
        function ( a, b )
			return util.contains( b, a )
		end,
        { 'contained', 'isContained', 'ifContained' } },
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
    toBeMatch = {
		function ( a, b )
			return string.match( b, a ) or false
		end,
        { 'match', 'isMatch', 'ifMatch' } },
    toBeUMatch = {
		function ( a, b )
			return mw.ustring.match( b, a ) or false
		end,
        { 'umatch', 'isUMatch', 'ifUMatch' } },
}

for name,lst in pairs( conditions ) do
    local func = lst[1]
    Adapt[name] = makeConditionProcess( name, func ) -- @todo define other
    for _,alias in ipairs( lst[2] ) do
        assert( not Adapt[alias], alias )
        Adapt[alias] = Adapt[name]
    end
end

return Adapt
