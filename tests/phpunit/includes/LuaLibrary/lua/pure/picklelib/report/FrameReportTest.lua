--- Tests for the plan module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/report/FrameReport'
assert( lib )

local name = 'frame'
local class = 'frame-report'

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

local function testConstituent( con )
	local p = makeTest():addConstituent( con )
	return { p:constituents():export() }
end

local function testConstituents( ... )
	local p = makeTest():addConstituents( ... )
	return { p:constituents():export() }
end

local function testHasSkip( ... )
	local test = makeTest()
	local adapt = require 'picklelib/report/AdaptReport'
	local t = { ... }
	for _,v in ipairs( t ) do
		test:addConstituent( adapt.create():setSkip( v ) )
	end
	return test:hasSkip()
end

local function testHasTodo( ... )
	local test = makeTest()
	local adapt = require 'picklelib/report/AdaptReport'
	local t = { ... }
	for _,v in ipairs( t ) do
		test:addConstituent( adapt.create():setSkip( v ) )
	end
	return test:hasTodo()
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
		name = name .. ':addConstituent (single value type)',
		func = testConstituent,
		args = { 'foo' },
		expect = { { 'foo' } }
	},
	{
		name = name .. ':addConstituents (multiple value type)',
		func = testConstituents,
		args = { 'foo', 'bar', 'baz' },
		expect = { { 'foo', 'bar', 'baz' } }
	},
	{
		name = name .. '.hasSkip ()',
		func = testHasSkip,
		args = {},
		expect = { false }
	},
	{
		name = name .. '.hasSkip ()',
		func = testHasSkip,
		args = { 'test' },
		expect = { true }
	},
	{
		name = name .. '.hasTodo ()',
		func = testHasTodo,
		args = {},
		expect = { false }
	},
	{
		name = name .. '.hasTodo ()',
		func = testHasTodo,
		args = { 'ping' },
		expect = { false }
	},
}

return testframework.getTestProvider( tests )
