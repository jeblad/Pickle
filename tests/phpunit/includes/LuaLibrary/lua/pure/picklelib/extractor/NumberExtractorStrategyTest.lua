--- Tests for the number extractor module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/extractor/NumberExtractorStrategy'
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
		expect = { 'number' }
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
		args = { '42' },
		expect = { 1, 2 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { '-42.5' },
		expect = { 1, 5 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { '42 bar baz' },
		expect = { 1, 2 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { '-42.5 bar baz' },
		expect = { 1, 5 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo 42 baz' },
		expect = { 5, 6 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo -42.5 baz' },
		expect = { 5, 9 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo bar 42' },
		expect = { 9, 10 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo bar -42.5' },
		expect = { 9, 13 }
	},
	{
		name = name .. '.cast (empty)',
		func = testCast,
		args = { 'foo bar 42', 9, 10 },
		expect = { 42 }
	},
	{
		name = name .. '.placeholder ()',
		func = testPlaceholder,
		args = {},
		expect = { 'number' }
	},
}

return testframework.getTestProvider( tests )
