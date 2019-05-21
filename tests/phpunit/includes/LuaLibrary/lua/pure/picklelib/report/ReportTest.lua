--- Tests for the base report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/report/Report'
assert( lib )

local name = 'base'
local class = 'report'

local function makeTest( ... )
	return lib:create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testRealize( ... )
	return makeTest( ... ):realize()
end

local function testType( ... )
	return makeTest( ... ):type()
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

local function testIsSkip( str )
	local test = makeTest()
	if str then
		test:setSkip( str )
	end
	return test:isSkip()
end

local function testIsTodo( str )
	local test = makeTest()
	if str then
		test:setTodo( str )
	end
	return test:isTodo()
end

local function testGetSetSkip( str )
	local test = makeTest()
	if str then
		test:setSkip( str )
	end
	return test:getSkip()
end

local function testGetSetTodo( str )
	local test = makeTest()
	if str then
		test:setTodo( str )
	end
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
		name = name .. ':create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = name .. ':create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = name .. ':create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = name .. ':realize (nil)',
		func = testRealize,
		args = { nil },
		expect = { '' }
	},
	{
		name = name .. ':type ()',
		func = testType,
		expect = { class }
	},
	{
		name = name .. ':notOk (single value)',
		func = testState,
		args = { false },
		expect = { false }
	},
	{
		name = name .. ':ok (single value)',
		func = testState,
		args = { true },
		expect = { true }
	},
	{
		name = name .. ':isSkip ()',
		func = testIsSkip,
		args = {},
		expect = { false }
	},
	{
		name = name .. ':isSkip ()',
		func = testIsSkip,
		args = { 'ping' },
		expect = { true }
	},
	{
		name = name .. ':isTodo ()',
		func = testIsTodo,
		args = {},
		expect = { false }
	},
	{
		name = name .. ':isTodo ()',
		func = testIsTodo,
		args = { 'pong' },
		expect = { true }
	},
	{
		name = name .. ':skip ()',
		func = testGetSetSkip,
		args = {},
		expect = { false }
	},
	{
		name = name .. ':skip ()',
		func = testGetSetSkip,
		args = { 'foo' },
		expect = { 'foo' }
	},
	{
		name = name .. ':todo ()',
		func = testGetSetTodo,
		args = {},
		expect = { false }
	},
	{
		name = name .. ':todo ()',
		func = testGetSetTodo,
		args = { 'bar' },
		expect = { 'bar' }
	},
}

return testframework.getTestProvider( tests )
