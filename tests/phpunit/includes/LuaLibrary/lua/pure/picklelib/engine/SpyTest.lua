--- Tests for the Spy module
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

--_G.describe()
local Spy = require 'picklelib/engine/Spy'

local function testTracebackFirst( pattern, ... )
	local first,_ = Spy:traceback( ... )
	return string.match( first, pattern )
end

local function testTracebackRest( pattern, idx, ... )
	local _,rest = Spy:traceback( ... )
	return string.match( rest[ idx ], pattern )
end

-- @todo lots of failing stuff here
local tests = {
	{
		name = 'tracebacFirstk()',
		func = testTracebackFirst,
		args = { "([%a%s]*)" },
		expect = { 'stack traceback' }
	},
	{
		name = 'tracebacFirstk()',
		func = testTracebackFirst,
		args = { "([%a%s]*)", 'foo bar baz' },
		expect = { 'foo bar baz' }
	},
	{
		name = 'tracebackRest()',
		func = testTracebackRest,
		args = { "/(%a+).lua.*'(.-)'", 1 },
		expect = { 'Spy', 'traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTracebackRest,
		args = { "([%a%s]*)", 1, 'foo bar baz' },
		expect = { 'stack traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTracebackRest,
		args = { "/(%a+).lua.*'(.-)'", 2, 'foo bar baz' },
		expect = { 'Spy', 'traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTracebackRest,
		args = { "function[^%a]+Module[^%a]+(%a+)", 3, 'foo bar baz' },
		expect = { 'SpyTest' }
	},
	{
		name = 'tracebackRest()',
		func = testTracebackRest,
		args = { "([%a%s]*)", 1, 'foo bar baz', 2 },
		expect = { 'stack traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTracebackRest,
		args = { "function[^%a]+Module[^%a]+(%a+)", 2, 'foo bar baz', 2 },
		expect = { 'SpyTest' }
	},
}

--return testframework.getTestProvider( tests )
