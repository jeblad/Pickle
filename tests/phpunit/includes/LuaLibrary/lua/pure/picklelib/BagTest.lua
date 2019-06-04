--- Tests for the bag module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local function makeBag( ... )
	local bag = require 'picklelib/Bag'
	assert( bag )
	return bag:create( ... )
end

local function testExists()
	return type( makeBag() )
end

local function testCreate( ... )
	return type( makeBag( ... ) )
end

local function testIsEmpty( ... )
	return makeBag( ... ):isEmpty()
end

local function testDepth( ... )
	return makeBag( ... ):depth()
end

local function testLayout( ... )
	return makeBag( ... ):layout()
end

local function testBottom( ... )
	return makeBag( ... ):bottom()
end

local function testTop( ... )
	return makeBag( ... ):top()
end

local function testPush( ... )
	local test = makeBag():push( ... )
	return test:top()
end

local function testUnshift( ... )
	local test = makeBag():unshift( ... )
	return test:top()
end

local function testPop( num, ... )
	return makeBag( ... ):pop( num )
end

local function testShift( num, ... )
	return makeBag( ... ):shift( num )
end

local function testPushPop( num, ... )
	return makeBag():push( ... ):pop( num )
end

local function testUnshiftShift( num, ... )
	return makeBag():unshift( ... ):shift( num )
end

local function testDrop( num, ... )
	return makeBag( ... ):drop( num ):export()
end

local function testGet( idx, ... )
	return makeBag( ... ):get( idx ) -- :export()
end

local function testExport( ... )
	local test = makeBag( ... )
	return { test:export() }, test:top()
end

local function testFlush( ... )
	local test = makeBag( ... )
	return { test:flush() }, test:top()
end

local tests = {
	{ -- 1
		name = 'bag exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{ -- 2
		name = 'bag:create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{ -- 3
		name = 'bag:create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{ -- 4
		name = 'bag:create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{ -- 5
		name = 'bag.isEmpty (nil value)',
		func = testIsEmpty,
		args = { nil },
		expect = { true }
	},
	{ -- 6
		name = 'bag.isEmpty (string value)',
		func = testIsEmpty,
		args = { '' },
		expect = { false }
	},
	{ -- 7
		name = 'bag.depth (nil value)',
		func = testDepth,
		args = { nil },
		expect = { 0 }
	},
	{ -- 8
		name = 'bag.depth (string value)',
		func = testDepth,
		args = { '' },
		expect = { 1 }
	},
	{ -- 9
		name = 'bag.depth (3x string values)',
		func = testDepth,
		args = { 'foo', 'bar', 'baz' },
		expect = { 3 }
	},
	{ -- 10
		name = 'bag.layout (various values)',
		func = testLayout,
		args = { 'foo', {'bar'}, 'baz', 42 },
		expect = { { 'string', 'table', 'string', 'number' } }
	},
	{ -- 11
		name = 'bag.bottom (3x string values)',
		func = testBottom,
		args = { 'foo', 'bar', 'baz' },
		expect = { 'foo' }
	},
	{ -- 12
		name = 'bag.top (nil value)',
		func = testTop,
		args = { nil },
		expect = {}
	},
	{ -- 13
		name = 'bag.top (single value)',
		func = testTop,
		args = { 'a' },
		expect = { 'a' }
	},
	{ -- 14
		name = 'bag.top (multiple value)',
		func = testTop,
		args = { 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{ -- 15
		name = 'bag.push (nil value)',
		func = testPush,
		args = { nil },
		expect = { nil }
	},
	{ -- 16
		name = 'bag.push (single value)',
		func = testPush,
		args = { 'a' },
		expect = { 'a' }
	},
	{ -- 17
		name = 'bag.push (multiple value)',
		func = testPush,
		args = { 'a', 'b' },
		expect = { 'b' }
	},
	{ -- 18
		name = 'bag.push (multiple value)',
		func = testPush,
		args = { 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{ -- 19
		name = 'bag.unshift (nil value)',
		func = testUnshift,
		args = { nil },
		expect = { nil }
	},
	{ -- 20
		name = 'bag.unshift (single value)',
		func = testUnshift,
		args = { 'a' },
		expect = { 'a' }
	},
	{ -- 21
		name = 'bag.unshift (multiple value)',
		func = testUnshift,
		args = { 'a', 'b' },
		expect = { 'a' }
	},
	{ -- 22
		name = 'bag.unshift (multiple value)',
		func = testUnshift,
		args = { 'a', 'b', 'c' },
		expect = { 'a' }
	},
	{ -- 23
		name = 'bag.pop (nil, nil value)',
		func = testPop,
		args = { nil, nil },
		expect = { nil }
	},
	{ -- 24
		name = 'bag.pop (nil, single value)',
		func = testPop,
		args = { nil, 'a' },
		expect = { 'a' }
	},
	{ -- 25
		name = 'bag.pop (nil, dual value)',
		func = testPop,
		args = { nil, 'a', 'b' },
		expect = { 'b' }
	},
	{ -- 26
		name = 'bag.pop (nil, multiple value)',
		func = testPop,
		args = { nil, 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{ --27
		name = 'bag.pop (2, nil value)',
		func = testPop,
		args = { 2, nil },
		expect = { nil }
	},
	{ -- 28
		name = 'bag.pop (2, single value)',
		func = testPop,
		args = { 2, 'a' },
		expect = { nil, 'a' }
	},
	{ -- 29
		name = 'bag.pop (2, dual value)',
		func = testPop,
		args = { 2, 'a', 'b' },
		expect = { 'a', 'b' }
	},
	{ -- 30
		name = 'bag.pop (2, multiple value)',
		func = testPop,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'b', 'c' }
	},
	{ --31
		name = 'bag.push-pop (2, nil value)',
		func = testPushPop,
		args = { 2, nil },
		expect = { nil }
	},
	{ -- 32
		name = 'bag.push-pop (2, single value)',
		func = testPushPop,
		args = { 2, 'a' },
		expect = { nil, 'a' }
	},
	{ -- 33
		name = 'bag.push-pop (2, dual value)',
		func = testPushPop,
		args = { 2, 'a', 'b' },
		expect = { 'a', 'b' }
	},
	{ -- 34
		name = 'bag.push-pop (2, multiple value)',
		func = testPushPop,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'b', 'c' }
	},
	{ -- 35
		name = 'bag.shift (nil, nil value)',
		func = testShift,
		args = { nil, nil },
		expect = { nil }
	},
	{ -- 36
		name = 'bag.shift (nil, single value)',
		func = testShift,
		args = { nil, 'a' },
		expect = { 'a' }
	},
	{ -- 37
		name = 'bag.shift (nil, dual value)',
		func = testShift,
		args = { nil, 'a', 'b' },
		expect = { 'b' }
	},
	{ -- 38
		name = 'bag.shift (nil, multiple value)',
		func = testShift,
		args = { nil, 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{ -- 39
		name = 'bag.shift (2, nil value)',
		func = testShift,
		args = { 2, nil },
		expect = { nil }
	},
	{ -- 40
		name = 'bag.shift (2, single value)',
		func = testShift,
		args = { 2, 'a' },
		expect = { 'a' }
	},
	{ -- 41
		name = 'bag.shift (2, dual value)',
		func = testShift,
		args = { 2, 'a', 'b' },
		expect = { 'b', 'a' }
	},
	{ -- 42
		name = 'bag.shift (2, multiple value)',
		func = testShift,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'c', 'b' }
	},
	{ --43
		name = 'bag.unshift-shift (2, nil value)',
		func = testUnshiftShift,
		args = { 2, nil },
		expect = { nil }
	},
	{ -- 44
		name = 'bag.unshift-shift (2, single value)',
		func = testUnshiftShift,
		args = { 2, 'a' },
		expect = { 'a' }
	},
	{ -- 45
		name = 'bag.unshift-shift (2, dual value)',
		func = testUnshiftShift,
		args = { 2, 'a', 'b' },
		expect = { 'a', 'b' }
	},
	{ -- 46
		name = 'bag.unshift-shift (2, multiple value)',
		func = testUnshiftShift,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'a', 'b' }
	},
	{ -- 47
		name = 'bag.drop (nil value)',
		func = testDrop,
		args = { nil, nil },
		expect = { nil }
	},
	{ -- 48
		name = 'bag.drop (single value)',
		func = testDrop,
		args = { nil, 'a' },
		expect = { nil }
	},
	{ -- 49
		name = 'bag.drop (multiple value)',
		func = testDrop,
		args = { nil, 'a', 'b', 'c' },
		expect = { 'a', 'b' }
	},
	{ -- 50
		name = 'bag.drop2 (nil value)',
		func = testDrop,
		args = { 2, nil },
		expect = { nil }
	},
	{ -- 51
		name = 'bag.drop2 (single value)',
		func = testDrop,
		args = { 2, 'a' },
		expect = { nil }
	},
	{ -- 52
		name = 'bag.drop2 (multiple value)',
		func = testDrop,
		args = { 2, 'a', 'b', 'c' },
		expect = { 'a' }
	},
	{ -- 53
		name = 'bag.get (nil value)',
		func = testGet,
		args = { 1, nil },
		expect = { nil }
	},
	{ -- 54
		name = 'bag.get (single value)',
		func = testGet,
		args = { 1, 'a' },
		expect = { 'a' }
	},
	{ -- 55
		name = 'bag.get (single value, negative index)',
		func = testGet,
		args = { -1, 'a' },
		expect = { 'a' }
	},
	{ -- 56
		name = 'bag.get (multiple value)',
		func = testGet,
		args = { 2, 'a', 'b', 'c', 'd' },
		expect = { 'c' }
	},
	{ -- 57
		name = 'bag.get (multiple value, negative index)',
		func = testGet,
		args = { -2, 'a', 'b', 'c', 'd' },
		expect = { 'b' }
	},
	{ -- 58
		name = 'bag.export (nil value)',
		func = testExport,
		args = { nil },
		expect = { {}, nil }
	},
	{ -- 38
		name = 'bag.export (single value)',
		func = testExport,
		args = { 'a' },
		expect = { { 'a' }, 'a' }
	},
	{ -- 39
		name = 'bag.export (multiple value)',
		func = testExport,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, 'c' }
	},
	{ -- 40
		name = 'bag.flush (nil value)',
		func = testFlush,
		args = { nil },
		expect = { {}, nil }
	},
	{ -- 41
		name = 'bag.flush (single value)',
		func = testFlush,
		args = { 'a' },
		expect = { { 'a' }, nil }
	},
	{ -- 42
		name = 'bag.flush (multiple value)',
		func = testFlush,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, nil }
	},
}

return testframework.getTestProvider( tests )
