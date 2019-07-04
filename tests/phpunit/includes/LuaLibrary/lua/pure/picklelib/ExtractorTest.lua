--- Tests for the base extractor module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local name = 'extractor'

local function makeTest( ... )
	local lib = require 'picklelib/Extractor'
	assert( lib )
	return lib:create( ... )
end

local function testExists()
	return type( makeTest() )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testType( ... )
	return makeTest( ... ):getType()
end

local function testFind( str, ... )
	return makeTest( ... ):find( str, 1 )
end

local function testCast()
	local val, err = pcall( function() makeTest():cast() end )
	return val, string.match( err, 'Method should be overridden' )
end

local function testPlaceholder( str )
	local obj = makeTest()
	if str then
		obj:setType( str )
	end
	return obj:placeholder()
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
	{ -- 3
		name = name .. ':create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{ -- 4
		name = name .. ':create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{ -- 5
		name = name .. ':type ()',
		func = testType,
		expect = { '<unknown>' }
	},
	{ -- 6
		name = name .. ':find (not matched)',
		func = testFind,
		args = { 'foo bar baz', { 'test', 0, 0 } },
		expect = {}
	},
	{ -- 7
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo bar baz', { '^foo', 0, 0 } },
		expect = { 1, 3 }
	},
	{ -- 8
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo bar baz', { 'bar', 0, 0 } },
		expect = { 5, 7 }
	},
	{ -- 9
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo bar baz', { 'baz$', 0, 0 } },
		expect = { 9, 11 }
	},
	{ -- 10
		name = name .. ':cast ()',
		func = testCast,
		args = {},
		expect = { false }
	},
	{ -- 11
		name = name .. ':placeholder ()',
		func = testPlaceholder,
		args = {},
		expect = { '[<unknown>]' }
	},
	{ -- 12
		name = name .. ':placeholder ( string )',
		func = testPlaceholder,
		args = { 'foobar' },
		expect = { '[foobar]' }
	},
}

return testframework.getTestProvider( tests )
