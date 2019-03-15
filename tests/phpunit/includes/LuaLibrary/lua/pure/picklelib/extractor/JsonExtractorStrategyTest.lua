--- Tests for the json extractor module.
-- This is a preliminary solution.
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/extractor/JsonExtractorStrategy'
assert( lib )
local name = 'extractor'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testType( ... )
	return makeTest( ... ):type()
end

local function testFind( str, ... )
	return makeTest( ... ):find( str, 1 )
end

local function testCast( ... )
	return makeTest():cast( ... )
end

local function testPlaceholder()
	return makeTest():placeholder()
end

local tests = {
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = name .. '.type ()',
		func = testType,
		expect = { 'json' }
	},
	{
		name = name .. '.find (not matched)',
		func = testFind,
		args = { 'foo bar baz' },
		expect = {}
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { '{}' },
		expect = { 1, 2 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { '[]' },
		expect = { 1, 2 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { '["test"] bar baz' },
		expect = { 1, 8 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo ["test"] baz' },
		expect = { 5, 12 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo bar ["test"]' },
		expect = { 9, 16 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo {"test":["ping","pong"],"test2":42} baz' },
		expect = { 5, 39 }
	},
	{
		name = name .. '.cast (empty)',
		func = testCast,
		args = { 'foo bar ["test"]', 9, 16 },
		expect = { {"test"} }
	},
	{
		name = name .. '.cast (empty)',
		func = testCast,
		args = { 'foo {"test":["ping","pong"],"test2":42} baz', 5, 39 },
		expect = { { ["test"] = { "ping", "pong" }, ["test2"] = 42 } }
	},
	{
		name = name .. '.placeholder ()',
		func = testPlaceholder,
		args = {},
		expect = { 'json' }
	},
}

return testframework.getTestProvider( tests )
