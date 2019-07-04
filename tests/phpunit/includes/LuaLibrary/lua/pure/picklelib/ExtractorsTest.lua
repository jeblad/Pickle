--- Tests for the extractor strategies module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local name = 'extractor'

local function makeTest( ... )
	local lib = require 'picklelib/Extractors'
	assert( lib )
	return lib:create( ... )
end

local function testExists()
	return type( makeTest() )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testNumFlush( ... )
	local obj = makeTest( ... )
	local t = { obj:num() }
	obj:flush()
	table.insert( t, obj:num() )
	return unpack( t )
end

local function testFind( str, ... )
	local t = { makeTest( ... ):find( str, 1 ) }
	local obj = table.remove( t, 1 )
	table.insert( t, obj:getType() )
	return unpack( t )
end

local tests = {
	{ -- 1
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{ -- 2
		name = name .. ':create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{ -- 8
		name = name .. ':num-flush (no value)',
		func = testNumFlush,
		args = {},
		expect = { 0, 0 }
	},
	{ -- 9
		name = name .. ':num-flush (single value)',
		func = testNumFlush,
		args = { { 'foo' } },
		expect = { 1, 0 }
	},
	{ -- 10
		name = name .. ':num-flush (multiple value)',
		func = testNumFlush,
		args = { { 'foo' }, { 'bar' }, { 'baz' } },
		expect = { 3, 0 }
	},
}

return testframework.getTestProvider( tests )
