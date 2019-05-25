--- Tests for the stack module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local function makeStack( ... )
	local stack = require 'picklelib/Stack'
	assert( stack )
	return stack:create( ... )
end

local function testExists()
	return type( makeStack() )
end

local function testCreate( ... )
	return type( makeStack( ... ) )
end

local function testIsEmpty( ... )
	return makeStack( ... ):isEmpty()
end

local function testDepth( ... )
	return makeStack( ... ):depth()
end

local function testLayout( ... )
	return makeStack( ... ):layout()
end

local function testBottom( ... )
	return makeStack( ... ):bottom()
end

local function testTop( ... )
	return makeStack( ... ):top()
end

local function testPush( ... )
	local test = makeStack():push( ... )
	return test:top()
end

local function testPop( ... )
	return makeStack( ... ):pop()
end

local function testPop2( ... )
	return makeStack( ... ):pop(2)
end

local function testDrop( ... )
	return makeStack( ... ):drop():export()
end

local function testDrop2( ... )
	return makeStack( ... ):drop(2):export()
end

local function testGet( idx, ... )
	return makeStack( ... ):get( idx ) -- :export()
end

local function testExport( ... )
	local test = makeStack( ... )
	return { test:export() }, test:top()
end

local function testFlush( ... )
	local test = makeStack( ... )
	return { test:flush() }, test:top()
end

local tests = {
	{
		name = 'stack exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'stack:create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = 'stack:create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = 'stack:create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = 'stack.isEmpty (nil value)',
		func = testIsEmpty,
		args = { nil },
		expect = { true }
	},
	{
		name = 'stack.isEmpty (string value)',
		func = testIsEmpty,
		args = { '' },
		expect = { false }
	},
	{
		name = 'stack.depth (nil value)',
		func = testDepth,
		args = { nil },
		expect = { 0 }
	},
	{
		name = 'stack.depth (string value)',
		func = testDepth,
		args = { '' },
		expect = { 1 }
	},
	{
		name = 'stack.depth (3x string values)',
		func = testDepth,
		args = { 'foo', 'bar', 'baz' },
		expect = { 3 }
	},
	{
		name = 'stack.layout (various values)',
		func = testLayout,
		args = { 'foo', {'bar'}, 'baz', 42 },
		expect = { { 'string', 'table', 'string', 'number' } }
	},
	{
		name = 'stack.bottom (3x string values)',
		func = testBottom,
		args = { 'foo', 'bar', 'baz' },
		expect = { 'foo' }
	},
	{
		name = 'stack.top (nil value)',
		func = testTop,
		args = { nil },
		expect = {}
	},
	{
		name = 'stack.top (single value)',
		func = testTop,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = 'stack.top (multiple value)',
		func = testTop,
		args = { 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{
		name = 'stack.push (nil value)',
		func = testPush,
		args = { nil },
		expect = { nil }
	},
	{
		name = 'stack.push (single value)',
		func = testPush,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = 'stack.push (multiple value)',
		func = testPush,
		args = { 'a', 'b' },
		expect = { 'b' }
	},
	{
		name = 'stack.push (multiple value)',
		func = testPush,
		args = { 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{
		name = 'stack.pop (nil value)',
		func = testPop,
		args = { nil },
		expect = { nil }
	},
	{
		name = 'stack.pop (single value)',
		func = testPop,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = 'stack.pop (multiple value)',
		func = testPop,
		args = { 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{
		name = 'stack.pop2 (nil value)',
		func = testPop2,
		args = { nil },
		expect = { nil }
	},
	{
		name = 'stack.pop2 (single value)',
		func = testPop2,
		args = { 'a' },
		expect = { nil, 'a' }
	},
	{
		name = 'stack.pop2 (dual value)',
		func = testPop2,
		args = { 'a', 'b' },
		expect = { 'a', 'b' }
	},
	{
		name = 'stack.pop2 (multiple value)',
		func = testPop2,
		args = { 'a', 'b', 'c' },
		expect = { 'b', 'c' }
	},
	{
		name = 'stack.drop (nil value)',
		func = testDrop,
		args = { nil },
		expect = { nil }
	},
	{
		name = 'stack.drop (single value)',
		func = testDrop,
		args = { 'a' },
		expect = { nil }
	},
	{
		name = 'stack.drop (multiple value)',
		func = testDrop,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b' }
	},
	{
		name = 'stack.drop2 (nil value)',
		func = testDrop2,
		args = { nil },
		expect = { nil }
	},
	{
		name = 'stack.drop2 (single value)',
		func = testDrop2,
		args = { 'a' },
		expect = { nil }
	},
	{
		name = 'stack.drop2 (multiple value)',
		func = testDrop2,
		args = { 'a', 'b', 'c' },
		expect = { 'a' }
	},
	{
		name = 'stack.get (nil value)',
		func = testGet,
		args = { 1, nil },
		expect = { nil }
	},
	{
		name = 'stack.get (single value)',
		func = testGet,
		args = { 1, 'a' },
		expect = { 'a' }
	},
	{
		name = 'stack.get (single value)',
		func = testGet,
		args = { -1, 'a' },
		expect = { 'a' }
	},
	{
		name = 'stack.get (multiple value)',
		func = testGet,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'b' }
	},
	{
		name = 'stack.get (multiple value)',
		func = testGet,
		args = { -2, 'a', 'b', 'c' },
		expect = { 'b' }
	},
	{
		name = 'stack.export (nil value)',
		func = testExport,
		args = { nil },
		expect = { {}, nil }
	},
	{
		name = 'stack.export (single value)',
		func = testExport,
		args = { 'a' },
		expect = { { 'a' }, 'a' }
	},
	{
		name = 'stack.export (multiple value)',
		func = testExport,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, 'c' }
	},
	{
		name = 'stack.flush (nil value)',
		func = testFlush,
		args = { nil },
		expect = { {}, nil }
	},
	{
		name = 'stack.flush (single value)',
		func = testFlush,
		args = { 'a' },
		expect = { { 'a' }, nil }
	},
	{
		name = 'stack.flush (multiple value)',
		func = testFlush,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, nil }
	},
}

return testframework.getTestProvider( tests )
