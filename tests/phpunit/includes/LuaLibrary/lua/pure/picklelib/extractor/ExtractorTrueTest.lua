--- Tests for the boolean true extractor module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local name = 'extractor'

local function makeTest( ... )
	local lib = require 'picklelib/extractor/ExtractorTrue'
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
		expect = { 'true' }
	},
	{ -- 6
		name = name .. ':find (not matched)',
		func = testFind,
		args = { 'foo bar baz' },
		expect = {}
	},
	{ -- 7
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'true' },
		expect = { 1, 4 }
	},
	{ -- 8
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'true bar baz' },
		expect = { 1, 4 }
	},
	{ -- 9
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo true baz' },
		expect = { 5, 8 }
	},
	{ -- 10
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo bar true' },
		expect = { 9, 12 }
	},
	{ -- 11
		name = name .. ':cast (singlevalue)',
		func = testCast,
		args = { 'true' },
		expect = { true }
	},
	{ -- 12
		name = name .. ':cast (singlevalue)',
		func = testCast,
		args = { 'True' },
		expect = { true }
	},
	{ -- 13
		name = name .. ':placeholder ()',
		func = testPlaceholder,
		args = {},
		expect = { '[boolean]' }
	},
}

return testframework.getTestProvider( tests )
