--- Tests for the Spy module.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

--_G.describe()
local Spy = require 'picklelib/engine/Spy'
assert( Spy )

local function testTraceback( pattern, idx, ... )
	local line = Spy:traceback( ... ):report():getLine( idx )
	return string.match( unpack( line ), pattern )
end

-- @todo lots of failing stuff here
local tests = {
	{
		name = 'tracebackFirst()',
		func = testTraceback,
		args = { "([%a%s]*)", 1 },
		expect = { 'stack traceback' }
	},
	{
		name = 'tracebacFirstk()',
		func = testTraceback,
		args = { "([%a%s]*)", 1, 'foo bar baz' },
		expect = { 'foo bar baz' }
	},
	{
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "/(%a+).lua.*'(.-)'", 2 },
		expect = { 'Spy', 'traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "([%a%s]*)", 2, 'foo bar baz' },
		expect = { 'stack traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "/(%a+).lua.*'(.-)'", 3, 'foo bar baz' },
		expect = { 'Spy', 'traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "function[^%a]+Module[^%a]+(%a+)", 3, 'foo bar baz', 2 },
		expect = { 'SpyTest' }
	},
	{
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "([%a%s]*)", 2, 'foo bar baz', 2 },
		expect = { 'stack traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTraceback,
		args = { "function[^%a]+Module[^%a]+(%a+)", 3, 'foo bar baz', 2 },
		expect = { 'SpyTest' }
	},
}

return testframework.getTestProvider( tests )
