--- Tests for the nil extractor module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/extractor/NilExtractorStrategy'
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
		type ='ToString',
		expect = { 'table' }
	},
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type ='ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type ='ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type ='ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = name .. '.type ()',
		func = testType,
		expect = { 'nil' }
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
		args = { 'nil' },
		expect = { 1, 3 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'nil bar baz' },
		expect = { 1, 3 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo nil baz' },
		expect = { 5, 7 }
	},
	{
		name = name .. '.find (matched)',
		func = testFind,
		args = { 'foo bar nil' },
		expect = { 9, 11 }
	},
	{
		name = name .. '.cast (empty)',
		func = testCast,
		expect = { nil }
	},
	{
		name = name .. '.placeholder ()',
		func = testPlaceholder,
		args = {},
		expect = { 'nil' }
	},
}

return testframework.getTestProvider( tests )
