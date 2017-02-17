--- Tests for the stack module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local stack = require 'picklelib/Stack'

local function makeStack( ... )
	return stack.create( ... )
end

local function testExists()
	return type( stack )
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
	local test = makeStack( ... ):pop()
	return test:top()
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
	{ name = 'stack exists', func = testExists, type='ToString',
		expect = { 'table' }
	},
	{ name = 'stack.create (nil value type)', func = testCreate, type='ToString',
		args = { nil },
		expect = { 'table' }
	},
	{ name = 'stack.create (single value type)', func = testCreate, type='ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{ name = 'stack.create (multiple value type)', func = testCreate, type='ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{ name = 'stack.isEmpty (nil value)', func = testIsEmpty,
		args = { nil },
		expect = { true }
	},
	{ name = 'stack.isEmpty (string value)', func = testIsEmpty,
		args = { '' },
		expect = { false }
	},
	{ name = 'stack.depth (nil value)', func = testDepth,
		args = { nil },
		expect = { 0 }
	},
	{ name = 'stack.depth (string value)', func = testDepth,
		args = { '' },
		expect = { 1 }
	},
	{ name = 'stack.depth (3x string values)', func = testDepth,
		args = { 'foo', 'bar', 'baz' },
		expect = { 3 }
	},
	{ name = 'stack.layout (various values)', func = testLayout,
		args = { 'foo', {'bar'}, 'baz', 42 },
		expect = { { 'string', 'table', 'string', 'number' } }
	},
	{ name = 'stack.bottom (3x string values)', func = testBottom,
		args = { 'foo', 'bar', 'baz' },
		expect = { 'foo' }
	},
	{ name = 'stack.top (nil value)', func = testTop,
		args = { nil },
		expect = {}
	},
	{ name = 'stack.top (single value)', func = testTop,
		args = { 'a' },
		expect = { 'a' }
	},
	{ name = 'stack.top (multiple value)', func = testTop,
		args = { 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{ name = 'stack.push (nil value)', func = testPush,
		args = { nil },
		expect = { nil }
	},
	{ name = 'stack.push (single value)', func = testPush,
		args = { 'a' },
		expect = { 'a' }
	},
	{ name = 'stack.push (multiple value)', func = testPush,
		args = { 'a', 'b', 'c' },
		expect = { 'c' }
	},
	{ name = 'stack.pop (nil value)', func = testPop,
		args = { nil, 'extra' },
		expect = { nil }
	},
	{ name = 'stack.pop (single value)', func = testPop,
		args = { 'a', 'extra' },
		expect = { 'a' }
	},
	{ name = 'stack.pop (multiple value)', func = testPop,
		args = { 'a', 'b', 'c', 'extra' },
		expect = { 'c' }
	},
	{ name = 'stack.export (nil value)', func = testExport,
		args = { nil },
		expect = { {}, nil }
	},
	{ name = 'stack.export (single value)', func = testExport,
		args = { 'a' },
		expect = { { 'a' }, 'a' }
	},
	{ name = 'stack.export (multiple value)', func = testExport,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, 'c' }
	},
	{ name = 'stack.flush (nil value)', func = testFlush,
		args = { nil },
		expect = { {}, nil }
	},
	{ name = 'stack.flush (single value)', func = testFlush,
		args = { 'a' },
		expect = { { 'a' }, nil }
	},
	{ name = 'stack.flush (multiple value)', func = testFlush,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, nil }
	},
}

return testframework.getTestProvider( tests )
