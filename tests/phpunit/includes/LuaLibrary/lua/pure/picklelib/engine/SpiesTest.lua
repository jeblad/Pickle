--- Tests for the spies module
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local Spies = require 'picklelib/engine/Spies'

local function testTracebackFirst( pattern, ... )
	local first,_ = Spies.traceback( ... )
	return string.match( first, pattern )
end

local function testTracebackRest( pattern, idx, ... )
	local _,rest = Spies.traceback( ... )
	return string.match( rest[ idx ], pattern )
end

local function testCarpTodo( ... )
	Spies.carp( ... )
	return Spies.reports():top():getTodo()
end

local function testCluckLines( pattern, idx, ... )
	Spies.cluck( ... )
	local lines = Spies.reports():top():lines() -- @note this is unpacked, but ends up as a table
	return string.match( lines[ idx ], pattern )
end

local function testCluckTodo( ... )
	Spies.cluck( ... )
	return Spies.reports():top():getTodo()
end

local function testConfessTodo( ... )
	pcall( Spies.confess, ... )
	return Spies.reports():top():getSkip()
end

local function testCroakLines( pattern, idx, ... )
	pcall( Spies.croak, ... )
	local lines = Spies.reports():top():lines() -- @note this is unpacked, but ends up as a table
	return string.match( lines[ idx ], pattern )
end

local function testCroakTodo( ... )
	pcall( Spies.croak, ... )
	return Spies.reports():top():getSkip()
end

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
		expect = { 'Spies', 'traceback' }
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
		expect = { 'Spies', 'traceback' }
	},
	{
		name = 'tracebackRest()',
		func = testTracebackRest,
		args = { "function[^%a]+Module[^%a]+(%a+)", 3, 'foo bar baz' },
		expect = { 'SpiesTest' }
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
		expect = { 'SpiesTest' }
	},
	{
		name = 'carp todo ()',
		func = testCarpTodo,
		args = { 'foo bar baz' },
		expect = { 'foo bar baz' }
	},
	{
		name = 'cluck lines ()',
		func = testCluckLines,
		args = { "/(%a+).lua.*'(.-)'", 1 },
		expect = { 'Spies', 'traceback' }
	},
	{
		name = 'cluck todo ()',
		func = testCluckTodo,
		args = { 'foo bar baz' },
		expect = { 'foo bar baz' }
	},
	{
		name = 'confess todo ()',
		func = testConfessTodo,
		args = { 'foo bar baz' },
		expect = { 'foo bar baz' }
	},
	{
		name = 'croak lines ()',
		func = testCroakLines,
		args = { "/(%a+).lua.*'(.-)'", 1 },
		expect = { 'Spies', 'traceback' }
	},
	{
		name = 'croak todo ()',
		func = testCroakTodo,
		args = { 'foo bar baz' },
		expect = { 'foo bar baz' }
	},
}

return testframework.getTestProvider( tests )
