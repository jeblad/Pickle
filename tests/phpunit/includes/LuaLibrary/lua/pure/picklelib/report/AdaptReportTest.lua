--- Tests for the report module.
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/report/AdaptReport'
assert( lib )

local name = 'adapt'
local class = 'adapt-report'

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

local function testLines( ... )
	local test = makeTest( ... )
	return { test:lines():export() }, test:numLines()
end

local function testAddLine( ... )
	local test = makeTest():addLine( ... )
	return test:lines():export()
end

local function testGetLine( idx, ... )
	return makeTest( ... ):getLine( idx )
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
		expect = { class }
	},
	{
		name = name .. '.lines (nil value)',
		func = testLines,
		args = { nil, 0 },
		expect = { {}, 0 }
	},
	{
		name = name .. '.lines (single value)',
		func = testLines,
		args = { 'a' },
		expect = { { 'a' }, 1 }
	},
	{
		name = name .. '.lines (multiple value)',
		func = testLines,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, 3 }
	},
	{
		name = name .. '.addLine (nil value)',
		func = testAddLine,
		args = { nil },
		expect = {{}}
	},
	{
		name = name .. '.addLine (single value)',
		func = testAddLine,
		args = { 'a' },
		expect = { { 'a' } }
	},
	{
		name = name .. '.addLine (multiple value)',
		func = testAddLine,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
	{
		name = name .. '.getLine (nil value)',
		func = testGetLine,
		args = { 1, nil, 0 },
		expect = { }
	},
	{
		name = name .. '.getLine (single value)',
		func = testGetLine,
		args = { 1, 'a' },
		expect = { 'a' }
	},
	{
		name = name .. '.getLine (multiple value)',
		func = testGetLine,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'b' }
	},
}

return testframework.getTestProvider( tests )
