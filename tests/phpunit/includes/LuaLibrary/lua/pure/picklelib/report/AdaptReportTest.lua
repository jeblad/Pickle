--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/report/AdaptReport'
local name = 'result'
local class = 'adapt-report'

local function makeTest( ... )
	return lib.create( ... )
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
	return {test:lines()}, test:numLines()
end

local function testState( state )
	local test = makeTest()
	if state then
		test:ok()
	else
		test:notOk()
	end
	return test:isOk()
end

local function testSkip( bool )
	local test = makeTest()
	if bool then
		test:setSkip('foo-bar')
	end
	return test:hasSkip()
end

local function testTodo( bool )
	local test = makeTest()
	if bool then
		test:setTodo('baz')
	end
	return test:hasTodo()
end

local function testAddLine( ... )
	local test = makeTest():addLine( ... )
	return test:lines()
end

local function testGetSetDescription( ... )
	local test = makeTest():setDescription( ... )
	return test:getDescription()
end

local function testGetSetSkip( ... )
	local test = makeTest():setSkip( ... )
	return test:getSkip()
end

local function testGetSetTodo( ... )
	local test = makeTest():setTodo( ... )
	return test:getTodo()
end

local tests = {
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = name .. '.type ()',
		func = testType,
		expect = { class }
	},
	{
		name = name .. '.lines (nil value)',
		func = testLines,
		args = { nil, 0 },
		expect = { {}, 0 }
	},
	{
		name = name .. '.lines (single value)',
		func = testLines,
		args = { 'a' },
		expect = { { 'a' }, 1 }
	},
	{
		name = name .. '.lines (multiple value)',
		func = testLines,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' }, 3 }
	},
	{
		name = name .. '.addLine (nil value)',
		func = testAddLine,
		args = { nil },
		expect = {{}}
	},
	{
		name = name .. '.addLine (single value)',
		func = testAddLine,
		args = { 'a' },
		expect = { { 'a' } }
	},
	{
		name = name .. '.addLine (multiple value)',
		func = testAddLine,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
	{
		name = name .. '.notOk (single value)',
		func = testState,
		args = { false },
		expect = { false }
	},
	{
		name = name .. '.ok (single value)',
		func = testState,
		args = { true },
		expect = { true }
	},
	{
		name = name .. '.skip ()',
		func = testSkip,
		args = { false },
		expect = { false }
	},
	{
		name = name .. '.skip ()',
		func = testSkip,
		args = { true },
		expect = { true }
	},
	{
		name = name .. '.todo ()',
		func = testTodo,
		args = { false },
		expect = { false }
	},
	{
		name = name .. '.todo ()',
		func = testTodo,
		args = { true },
		expect = { true }
	},
	{
		name = name .. '.skip ()',
		func = testGetSetSkip,
		args = { 'foo' },
		expect = { 'foo' }
	},
	{
		name = name .. '.todo ()',
		func = testGetSetTodo,
		args = { 'bar' },
		expect = { 'bar' }
	},
	{
		name = name .. '.description ()',
		func = testGetSetDescription,
		args = { 'baz' },
		expect = { 'baz' }
	},
}

return testframework.getTestProvider( tests )
