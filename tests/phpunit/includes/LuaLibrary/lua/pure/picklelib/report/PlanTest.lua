--- Tests for the plan module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/report/Plan'
local name = 'plan'
local class = 'plan'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

--[[
local function testRender( ... )
	return makeTest( ... ):render()
end
--]]

local function testType( ... )
	return makeTest( ... ):type()
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

local function testConstituents( ... )
	local p = makeTest()
	local t = { ... }
	for _,v in ipairs( t ) do
		p:addConstituent( v )
	end
	return { p:constituents() }
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
	--[[
	{
		name = name .. '.render (nil)',
		func = testRender,
		args = { nil },
		expect = { '' }
	},
	--]]
	{
		name = name .. '.type ()',
		func = testType,
		expect = { class }
	},
	{
		name = name .. ':addConstituent (multiple value type)',
		func = testConstituents,
		args = { 'foo', 'bar', 'baz' },
		expect = { { 'foo', 'bar', 'baz' } }
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
