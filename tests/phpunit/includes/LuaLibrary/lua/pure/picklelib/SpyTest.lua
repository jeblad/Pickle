--- Tests for the Spy module.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local function makeSpy( ... )
	local spy = require 'picklelib/Spy'
	assert( spy )
	--local reports = require 'picklelib/Bag'
	--assert( reports )
	return spy:create( ... ) -- :setReports( reports:create() )
end

local function testExists()
	return type( makeSpy() )
end

local function testTraceback( pattern, idx, ... )
	local line = makeSpy():traceback( ... ):report():getLine( idx )
	return string.match( unpack( line ), pattern )
end

local function testTodo( str )
	local obj = makeSpy():setTodo( str )
	return obj:report():getTodo()
end

local function testSkip( str )
	local obj = makeSpy():setSkip( str )
	return obj:report():getSkip()
end

local function testCarp( str )
	local obj = makeSpy():doCarp( str )
	return obj:report():getTodo(),
		obj:report():getSkip(),
		obj:report():isEmpty()
end

local function testCluck( str, idx1, idx2 )
	local obj = makeSpy():doCluck( str )
	return obj:report():getTodo(),
		obj:report():getSkip(),
		obj:report():isEmpty(),
		obj:report():getLine( idx1 ),
		obj:report():getLine( idx2 )
end

local function testCroak( str )
	local obj = makeSpy():doCroak( str )
	return obj:report():getTodo(),
		obj:report():getSkip(),
		obj:report():isEmpty()
end

local function testConfess( str, idx1, idx2 )
	local obj = makeSpy():doConfess( str )
	return obj:report():getTodo(),
		obj:report():getSkip(),
		obj:report():isEmpty(),
		obj:report():getLine( idx1 ),
		obj:report():getLine( idx2 )
end


-- @todo lots of failing stuff here
local tests = {
	{ -- 1
		name = 'spy exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{ -- 2
		name = 'tracebackFirst()',
		func = testTraceback,
		args = { "([%a%s]*)", -1 },
		expect = { 'stack traceback' }
	},
	{ -- 3
		name = 'tracebacFirstk()',
		func = testTraceback,
		args = { "([%a%s]*)", -1, 'foo bar baz' },
		expect = { 'foo bar baz' }
	},
	{ -- 4
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "/(%a+).lua.*'(.-)'", -2 },
		expect = { 'Spy', 'traceback' }
	},
	{ -- 5
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "([%a%s]*)", -2, 'foo bar baz' },
		expect = { 'stack traceback' }
	},
	{ -- 6
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "/(%a+).lua.*'(.-)'", -3, 'foo bar baz' },
		expect = { 'Spy', 'traceback' }
	},
	{ -- 7
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "function[^%a]+Module[^%a]+(%a+)", -3, 'foo bar baz', 2 },
		expect = { 'SpyTest' }
	},
	{ -- 8
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "([%a%s]*)", -2, 'foo bar baz', 2 },
		expect = { 'stack traceback' }
	},
	{ -- 9
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "function[^%a]+Module[^%a]+(%a+)", -3, 'foo bar baz', 2 },
		expect = { 'SpyTest' }
	},
	{ -- 10
		name = 'testTodo()',
		func = testTodo,
		args = { 'foo' },
		expect = { 'foo' }
	},
	{ -- 11
		name = 'testSkip()',
		func = testSkip,
		args = { 'foo' },
		expect = { 'foo' }
	},
	{ -- 13
		name = 'testCarp()',
		func = testCarp,
		args = { 'foo' },
		expect = {
			'foo',
			false,
			true
		}
	},
	{ -- 14
		name = 'testCluck()',
		func = testCluck,
		args = { 'foo', -1, 1 },
		expect = {
			'foo',
			false,
			false,
			{ "stack traceback:", },
			{ "[C]: ?", },
		}
	},
	{ -- 15
		name = 'testCroak()',
		func = testCroak,
		args = { 'foo' },
		expect = {
			false,
			'foo',
			true
		}
	},
	{ -- 16
		name = 'testConfess()',
		func = testConfess,
		args = { 'foo', -1, 1 },
		expect = {
			false,
			'foo',
			false,
			{ "stack traceback:", },
			{ "[C]: ?", },
		}
	},
}

return testframework.getTestProvider( tests )
