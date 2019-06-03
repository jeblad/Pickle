--- Tests for the report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/report/ReportAdapt'
assert( lib )

local name = 'adapt'
local class = 'report-adapt'

local function makeTest( ... )
	return lib:create( ... )
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
	return { test:lines():export() }, test:isEmpty(), test:numLines()
end

local function testAddLine( ... )
	local test = makeTest():addLine( ... )
	return test:lines():export()
end

local function testGetLine( idx, ... )
	return makeTest( ... ):getLine( idx )
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
		expect = { class }
	},
	{ -- 6
		name = name .. ':lines (nil value)',
		func = testLines,
		args = { nil, 0 },
		expect = { {}, true, 0 }
	},
	{ -- 7
		name = name .. ':lines (single value)',
		func = testLines,
		args = { 'a' },
		expect = { { 'a' }, false, 1 }
	},
	{ -- 8
		name = name .. ':lines (multiple value)',
		func = testLines,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, false, 3 }
	},
	{ -- 9
		name = name .. ':addLine (nil value)',
		func = testAddLine,
		args = { nil },
		expect = {{}}
	},
	{ -- 10
		name = name .. ':addLine (single value)',
		func = testAddLine,
		args = { 'a' },
		expect = { { 'a' } }
	},
	{ -- 11
		name = name .. ':addLine (multiple value)',
		func = testAddLine,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
	{ -- 12
		name = name .. ':getLine (nil value)',
		func = testGetLine,
		args = { 1, nil, 0 },
		expect = { }
	},
	{ -- 13
		name = name .. ':getLine (single value)',
		func = testGetLine,
		args = { 1, 'a' },
		expect = { 'a' }
	},
	{ -- 14
		name = name .. ':getLine (multiple value)',
		func = testGetLine,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'b' }
	},
}

return testframework.getTestProvider( tests )
