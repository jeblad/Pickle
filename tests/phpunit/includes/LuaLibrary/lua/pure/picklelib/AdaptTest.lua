--- Tests for the adapt module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local Adapt = require 'picklelib/Adapt'
assert( Adapt )
local reports = require 'picklelib/Bag'
assert( reports )
local adaptations = require 'picklelib/Bag'
assert( adaptations )

local function makeAdapt( ... )
	return Adapt:create( ... ):setReports( reports:create() ):setAdaptations( adaptations:create() )
end

local function testExists()
	return type( Adapt )
end

local function testCreate( ... )
	return type( makeAdapt( ... ) )
end

local function testEval( ... )
	return makeAdapt( ... ):addProcess(function( ... ) return ... end):eval()
end

local function testReports( ... )
	local obj = makeAdapt()
	local t = { ... }
	for _,v in ipairs( t ) do
		obj:reports():push( v )
	end
	return { obj:reports():export() }
end

local function testProcess( name, ... )
	local test = makeAdapt( ... )
		test[name]( test )
		local final = test:eval()
		return final, test:report():numLines()
end

local function testAdaptations( ... )
	local obj = makeAdapt()
	local t = { ... }
	for _,v in ipairs( t ) do
		obj:adaptations():push( v )
	end
	return { obj:adaptations():export() }
end

local function testDoubleCall( ... )
	Adapt( 'foo' )
	local obj = Adapt( ... )
	obj:adaptations():flush()
	return obj:temporal()
end

local function makePickTest( name, idx )
	local fix = { name = 'adapt.'..name..' (single string)', func = testProcess,
		args = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l' },
		expect = {}
	}
	table.insert( fix.expect, fix.args[idx] )
	table.insert( fix.expect, 1 )
	table.insert( fix.args, 1, name )
	return fix
end

local function makeGeneralTest( name, src, dst )
	local fix = { name = 'adapt.'..name..' (single string)', func = testProcess,
		args = { src },
		expect = { dst }
	}
	table.insert( fix.expect, 1 )
	table.insert( fix.args, 1, name )
	return fix
end

local function testCondition( name, src, otr, res )
	local test = makeAdapt( src )
		test:setOther( function() return otr end )
		local final = test[name]( test )
		local rep = { final:isOk(), test:report():numLines() }
		-- @todo remove additional stuff
		if res ~= final:isOk() then
			table.insert( rep, final )
		end
		return unpack( rep )
end

local function makeConditionTest( name, src, otr, res )
	local fix = { name = 'adapt.'..name..' (single string)', func = testCondition,
		args = { src, otr, res },
		expect = { res }
	}
	table.insert( fix.expect, 2 )
	table.insert( fix.args, 1, name )
	return fix
end

local tests = {
	{ -- 1
		name = 'adapt exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{ -- 2
		name = 'adapt:create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{ -- 3
		name = 'adapt:create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{ -- 4
		name = 'adapt:create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{ -- 5
		name = 'adapt.adaptations (multiple value)',
		func = testAdaptations,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
	{ -- 6
		name = 'adapt.call (nil value)',
		func = testDoubleCall,
		args = {},
		expect = { 'foo' }
	},
	{ -- 7
		name = 'adapt.call (single value)',
		func = testDoubleCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{ -- 8
		name = 'adapt.call (multiple value)',
		func = testDoubleCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{ -- 9
		name = 'adapt.stack (multiple value)',
		func = testReports,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
	{ -- 10
		name = 'adapt.eval (single string)',
		func = testEval,
		args = { 'a' },
		expect = { 'a' }
	},
	{ -- 11
		name = 'adapt.eval (single table)',
		func = testEval,
		args = { { 'a' } },
		expect = { { 'a' } }
	},
	makePickTest( 'first', 1 ), -- 12
	makePickTest( 'second', 2 ),
	makePickTest( 'third', 3 ),
	makePickTest( 'fourth', 4 ),
	makePickTest( 'fifth', 5 ),
	makePickTest( 'sixth', 6 ),
	makePickTest( 'seventh', 7 ),
	makePickTest( 'eight', 8 ),
	makePickTest( 'ninth', 9 ),
	makePickTest( 'tenth', 10 ),
	makePickTest( 'eleventh', 11 ),
	makePickTest( 'twelfth', 12 ),
	makeGeneralTest( 'asType', nil, 'nil' ),
	makeGeneralTest( 'asType', false, 'boolean' ),
	makeGeneralTest( 'asType', true, 'boolean' ),
	makeGeneralTest( 'asType', 42, 'number' ),
	makeGeneralTest( 'asType', 'foo', 'string' ),
	makeGeneralTest( 'asType', {}, 'table' ),
	makeGeneralTest( 'asUpper', 'aAaA', 'AAAA' ),
	makeGeneralTest( 'asLower', 'AaAa', 'aaaa' ),
	makeGeneralTest( 'asUpperFirst', 'aAaA', 'AAaA' ),
	makeGeneralTest( 'asLowerFirst', 'AaAa', 'aaAa' ),
	makeGeneralTest( 'asReverse', 'ABC', 'CBA' ),
	makeGeneralTest( 'asUUpper', 'åÅåÅ', 'ÅÅÅÅ' ),
	makeGeneralTest( 'asULower', 'ÅåÅå', 'åååå' ),
	makeGeneralTest( 'asUUpperFirst', 'åÅåÅ', 'ÅÅåÅ' ),
	makeGeneralTest( 'asULowerFirst', 'ÅåÅå', 'ååÅå' ),
	makeGeneralTest( 'asUNFC', mw.ustring.char( 065, 768 ), mw.ustring.char( 192 ) ), -- Á
	makeGeneralTest( 'asUNFD', mw.ustring.char( 192 ), mw.ustring.char( 065, 768 ) ),
	makeGeneralTest( 'asNumber', '42', 42 ),
	makeGeneralTest( 'asString', 42, '42' ),
	makeGeneralTest( 'asFloor', 1.9, 1 ),
	makeGeneralTest( 'asFloor', 2.0, 2 ),
	makeGeneralTest( 'asCeil', 2.0, 2 ),
	makeGeneralTest( 'asCeil', 2.1, 3 ),
	makeGeneralTest( 'asRound', 2.4, 2 ),
	makeGeneralTest( 'asRound', 2.5, 3 ),
	makeGeneralTest( 'asInteger', 1.1, 1 ),
	makeGeneralTest( 'asInteger', -1.1, -1 ),
	makeGeneralTest( 'asFraction', 1.1, 0.1 ),
	makeGeneralTest( 'asFraction', -1.1, -0.1 ),
	makeConditionTest( 'toBeEqual', false, true, false ),
	makeConditionTest( 'toBeEqual', false, false, true ),
	makeConditionTest( 'toBeEqual', true, true, true ),
	makeConditionTest( 'toBeEqual', 42, 42, true ),
	makeConditionTest( 'toBeEqual', 'foo', 'foo', true ),
	makeConditionTest( 'toBeBooleanEqual', false, true, false ),
	makeConditionTest( 'toBeBooleanEqual', true, true, true ),
	makeConditionTest( 'toBeBooleanEqual', 42, true, true ),
	makeConditionTest( 'toBeBooleanEqual', 'true', true, true ),
	makeConditionTest( 'toBeStrictEqual', 41, 42.0, false ),
	makeConditionTest( 'toBeStrictEqual', 42, 42.0, true ), -- this is a subtype and should fail
	makeConditionTest( 'toBeSame', 41, 42, false ),
	makeConditionTest( 'toBeSame', 42, 42, true ),
	makeConditionTest( 'toBeSame', '42', 42, true ),
	makeConditionTest( 'toBeSame', 42, '42', true ),
	makeConditionTest( 'toBeDeepEqual', {}, {}, true ),
	makeConditionTest( 'toBeDeepEqual', { false }, { true }, false ),
	makeConditionTest( 'toBeDeepEqual', { true }, { true}, true ),
	makeConditionTest( 'toBeDeepEqual', { { 'a' } }, { { 'a' } }, true ),
	makeConditionTest( 'toBeDeepEqual', { { 'a' } }, { { { 'a' } } }, false ),
	makeConditionTest( 'toBeDeepEqual', { { 'a' } }, { { 'a' }, 'b' }, false ),
	makeConditionTest( 'toBeContained', { { { 'a' } } }, { { 'a' }, { { 'a' } } }, false ),
	makeConditionTest( 'toBeContained', { { { 'a' } } }, { { 'a' }, { { { 'a' } } } }, true ),
	makeConditionTest( 'toBeContained', { { { 'a' } } }, { { 'a' }, { { { { 'a' } } } } }, false ),
	makeConditionTest( 'toBeLesserThan', 1, 2, true ),
	makeConditionTest( 'toBeLesserThan', 1, 1, false ),
	makeConditionTest( 'toBeLesserThan', 1, 0, false ),
	makeConditionTest( 'toBeGreaterThan', 1, 2, false ),
	makeConditionTest( 'toBeGreaterThan', 1, 1, false ),
	makeConditionTest( 'toBeGreaterThan', 1, 0, true ),
	makeConditionTest( 'toBeLesserOrEqual', 1, 2, true ),
	makeConditionTest( 'toBeLesserOrEqual', 1, 1, true ),
	makeConditionTest( 'toBeLesserOrEqual', 1, 0, false ),
	makeConditionTest( 'toBeGreaterOrEqual', 1, 2, false ),
	makeConditionTest( 'toBeGreaterOrEqual', 1, 1, true ),
	makeConditionTest( 'toBeGreaterOrEqual', 1, 0, true ),
	makeConditionTest( 'toBeMatch', 'bar', 'foo test baz', false ),
	makeConditionTest( 'toBeMatch', 'test', 'foo test baz', true ),
	makeConditionTest( 'toBeUMatch', 'bar', 'foo æøå baz', false ),
	makeConditionTest( 'toBeUMatch', '[æøå]test', 'foo æøåtest baz', true ),
}

return testframework.getTestProvider( tests )
