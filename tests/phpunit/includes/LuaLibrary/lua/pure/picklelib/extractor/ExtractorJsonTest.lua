--- Tests for the json extractor module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local name = 'extractor'

local function makeTest( ... )
	local lib = require 'picklelib/extractor/ExtractorJson'
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
		expect = { 'json' }
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
		args = { '{}' },
		expect = { 1, 2 }
	},
	{ -- 8
		name = name .. ':find (matched)',
		func = testFind,
		args = { '[]' },
		expect = { 1, 2 }
	},
	{ -- 9
		name = name .. ':find (matched)',
		func = testFind,
		args = { '["test"] bar baz' },
		expect = { 1, 8 }
	},
	{ -- 10
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo ["test"] baz' },
		expect = { 5, 12 }
	},
	{ -- 11
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo bar ["test"]' },
		expect = { 9, 16 }
	},
	{ -- 12
		name = name .. ':find (matched)',
		func = testFind,
		args = { 'foo {"test":["ping","pong"],"test2":42} baz' },
		expect = { 5, 39 }
	},
	{ -- 13
		name = name .. ':cast (json)',
		func = testCast,
		args = { '["test"]', 9, 16 },
		expect = { {"test"} }
	},
	{ -- 14
		name = name .. ':cast (json)',
		func = testCast,
		args = { '{"test":["ping","pong"],"test2":42}', 5, 39 },
		expect = { { ["test"] = { "ping", "pong" }, ["test2"] = 42 } }
	},
	{ -- 15
		name = name .. ':placeholder ()',
		func = testPlaceholder,
		args = {},
		expect = { '[json]' }
	},
}

return testframework.getTestProvider( tests )
