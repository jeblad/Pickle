--- Tests for the Double module.


local testframework = require 'Module:TestFramework'

local function makeDouble( ... )
	local double = require 'picklelib/Double'
	assert( double )
	return double:create( ... )
end

local function testExists()
	return type( makeDouble() )
end

local function testCreate( ... )
	return type( makeDouble( ... ) )
end

local function testIsEmpty( ... )
	return makeDouble( ... ):isEmpty()
end

local function testDepth( ... )
	return makeDouble( ... ):depth()
end

local function testLayout( ... )
	return makeDouble( ... ):layout()
end

local function testName( name )
	return makeDouble():setName( name ):hasName()
end

local function testLevel( level )
	return makeDouble():setLevel( level ):hasLevel()
end

local function testOnEmpty( func )
	return makeDouble():setOnEmpty( func ):hasOnEmpty()
end

local function testAdd( ... )
	local obj = makeDouble()
	obj:add( ... )
	return obj:layout()
end

local function testRemove( num, ... )
	local obj = makeDouble( ... )
	return obj:remove( num )
end

local function testClosure( func, ... )
	local obj = makeDouble( ... )
	obj:setOnEmpty( func )
	local stub = obj:stub()
	local t = {}
	for i=1,1+select( '#', ... ) do
		local res,values = pcall( function() return { stub() } end )
		table.insert( t, { res, values } )
	end
	return unpack( t )
end

local tests = {
	{ -- 1
		name = 'double exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{ -- 2
		name = 'double:create (no value)',
		func = testCreate,
		type = 'ToString',
		args = { },
		expect = { 'table' }
	},
	{ -- 3
		name = 'double:create (nil value)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{ -- 4
		name = 'double:create (true value)',
		func = testCreate,
		type = 'ToString',
		args = { true },
		expect = { 'table' }
	},
	{ -- 5
		name = 'double:create (false value)',
		func = testCreate,
		type = 'ToString',
		args = { false },
		expect = { 'table' }
	},
	{ -- 6
		name = 'double:create (number value)',
		func = testCreate,
		type = 'ToString',
		args = { { 1 } },
		expect = { 'table' }
	},
	{ -- 7
		name = 'double:isEmpty (no value)',
		func = testIsEmpty,
		args = { },
		expect = { true }
	},
	{ -- 8
		name = 'double:isEmpty (nil value)',
		func = testIsEmpty,
		args = { nil },
		expect = { true }
	},
	{ -- 9
		name = 'double:isEmpty (true value)',
		func = testIsEmpty,
		args = { true },
		expect = { false }
	},
	{ -- 10
		name = 'double:isEmpty (false value)',
		func = testIsEmpty,
		args = { false },
		expect = { false }
	},
	{ -- 11
		name = 'double:isEmpty (single value)',
		func = testIsEmpty,
		args = { { 1 } },
		expect = { false }
	},
	{ -- 12
		name = 'double:isEmpty (multiple value)',
		func = testIsEmpty,
		args = { { 1 }, { 2 }, { 3 } },
		expect = { false }
	},
	{ -- 13
		name = 'double:depth (no value)',
		func = testDepth,
		args = { },
		expect = { 0 }
	},
	{ -- 14
		name = 'double:depth (nil value)',
		func = testDepth,
		args = { nil },
		expect = { 0 }
	},
	{ -- 15
		name = 'double:depth (true value)',
		func = testDepth,
		args = { true },
		expect = { 1 }
	},
	{ -- 16
		name = 'double:depth (false value)',
		func = testDepth,
		args = { false },
		expect = { 1 }
	},
	{ -- 17
		name = 'double:depth (single value)',
		func = testDepth,
		args = { { 1 } },
		expect = { 1 }
	},
	{ -- 18
		name = 'double:depth (multiple value)',
		func = testDepth,
		args = { { 1 }, { 2 }, { 3 } },
		expect = { 3 }
	},
	{ -- 19
		name = 'double:layout (various values)',
		func = testLayout,
		args = { false, { 1 }, true },
		expect = { { 'boolean', 'table', 'boolean' } }
	},
	{ -- 20
		name = 'double:name (nil)',
		func = testName,
		args = { nil },
		expect = { false }
	},
	{ -- 21
		name = 'double:name (string)',
		func = testName,
		args = { 'foo' },
		expect = { true }
	},
	{ -- 22
		name = 'double:level (nil)',
		func = testLevel,
		args = { nil },
		expect = { false }
	},
	{ -- 23
		name = 'double:level (number)',
		func = testLevel,
		args = { 42 },
		expect = { true }
	},
	{ -- 24
		name = 'double:onEmpty (nil)',
		func = testOnEmpty,
		args = { nil },
		expect = { false }
	},
	{ -- 25
		name = 'double:onEmpty (func)',
		func = testOnEmpty,
		args = { function() end },
		expect = { true }
	},
	{ -- 26
		name = 'double:add (no value)',
		func = testAdd,
		args = { nil },
		expect = { { nil } }
	},
	{ -- 27
		name = 'double:add (single value)',
		func = testAdd,
		args = { 'foo' },
		expect = { { 'string' } }
	},
	{ -- 28
		name = 'double:add (multiple value)',
		func = testAdd,
		args = { 'bar', { 42 } },
		expect = { { 'table', 'string' } }
	},
	{ -- 29
		name = 'double:add (multiple value)',
		func = testAdd,
		args = { 'baz', { 42 }, true },
		expect = { { 'boolean', 'table', 'string' } }
	},
	{ -- 30
		name = 'double:remove (multiple value)',
		func = testRemove,
		args = { nil, { 1 }, { 2 }, { 3 } },
		expect = { { 1 } }
	},
	{ -- 31
		name = 'double:remove (multiple value)',
		func = testRemove,
		args = { 1, { 1 }, { 2 }, { 3 } },
		expect = { { 1 } }
	},
	{ -- 32
		name = 'double:remove (multiple value)',
		func = testRemove,
		args = { 2, { 1 }, { 2 }, { 3 } },
		expect = { { 1 }, { 2 } }
	},
	{ -- 33
		name = 'double:stub (multiple value)',
		func = testClosure,
		args = { nil, { 1 }, { 2 }, { 3 } },
		expect = {
			{ true, { 1 } },
			{ true, { 2 } },
			{ true, { 3 } },
			{ false, 'double: no more precomputed values' }
		}
	},
	{ -- 34
		name = 'double:stub (multiple value)',
		func = testClosure,
		args = { nil, { 1 }, { 2 }, nil },
		expect = {
			{ true, { 1 } },
			{ true, { 2 } },
			{ false, 'double: no more precomputed values' }
		}
	},
	{ -- 35
		name = 'double:stub (multiple value)',
		func = testClosure,
		args = { nil, { 1 }, nil, { 3 } },
		expect = {
			{ true, { 1 } },
			{ false, 'double: no more precomputed values' },
			{ false, 'double: no more precomputed values' }, -- counting error
			{ false, 'double: no more precomputed values' }  -- counting error
		}
	},
}

return testframework.getTestProvider( tests )
