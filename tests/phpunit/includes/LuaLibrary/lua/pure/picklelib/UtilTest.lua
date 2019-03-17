--- Tests for the util module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local util = require 'picklelib/util'
assert( util )

local function testExists()
	return type( util )
end

local function testCount( ... )
	return util.count( ... )
end

local function testSize( ... )
	return util.size( ... )
end

local function testDeepEqual( ... )
	return util.deepEqual( ... )
end

local function testContains( ... )
	return util.contains( ... )
end

local tests = {
	{
		name = 'util exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'util.count (nil value type)',
		func = testCount,
		args = { {} },
		expect = { 0 }
	},
	{
		name = 'util.count (single value type)',
		func = testCount,
		args = { { 'a' } },
		expect = { 1 }
	},
	{
		name = 'util.count (multiple value type)',
		func = testCount,
		args = { { 'a', { 'b', 'c' } } },
		expect = { 2 }
	},
	{
		name = 'util.count (multiple value type)',
		func = testCount,
		args = { { 'a', 'b', 'c' } },
		expect = { 3 }
	},
	{
		name = 'util.size (nil value type)',
		func = testSize,
		args = { nil },
		expect = { 0 }
	},
	{
		name = 'util.size (single value type)',
		func = testSize,
		args = { { 'a' } },
		expect = { 1 }
	},
	{
		name = 'util.size (single table value type 1)',
		func = testSize,
		args = { { 'a', 'b', 'c' } },
		expect = { 3 }
	},
	{
		name = 'util.deepEqual (double set of table values)',
		func = testDeepEqual,
		args = { { 'a', { 'b' }, 'c' }, { 'a', 'b', 'c' } },
		expect = { false }
	},
	{
		name = 'util.deepEqual (double set of table values)',
		func = testDeepEqual,
		args = { { 'a', { 'b' }, 'c' }, { 'a', { 'b' }, 'c' } },
		expect = { true }
	},
	{
		name = 'util.contains (double set of table values)',
		func = testContains,
		args = { { 'a', { 'b' }, 'c' }, { 'a' } },
		expect = { false }
	},
	{
		name = 'util.contains (double set of table values)',
		func = testContains,
		args = { { 'a', { 'b' }, 'c' }, 'c' },
		expect = { 3 }
	},
	{
		name = 'util.contains (double set of table values)',
		func = testContains,
		args = { { 'a', { 'b' }, 'c' }, { 'b' } },
		expect = { 2 }
	},
}

return testframework.getTestProvider( tests )
