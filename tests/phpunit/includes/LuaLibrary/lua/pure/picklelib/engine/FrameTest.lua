--- Tests for the frame module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/engine/Frame'
local name = 'frame'
local class = 'Frame'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testClassCall( ... )
	local t = lib( ... )
	return t:descriptions()
end

local function testClassCallStrings()
	local t = lib 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testInstanceCall( ... )
	local obj = makeTest()
	local t = obj( ... )
	return t:descriptions()
end

local function testInstanceCallStrings()
	local obj = makeTest()
	local t = obj 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testStringType( ... )
	local obj = makeTest()
	obj:stringType( ... )
	return obj:descriptions()
end

local function testFunctionType( ... )
	local obj = makeTest()
	obj:functionType( ... )
	return obj:hasFixtures()
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
		name = class .. '.call (single value type)',
		func = testClassCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = class .. '.call (multiple value type)',
		func = testClassCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{
		name = class .. '.call (multiple strings)',
		func = testClassCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.call (single value type)',
		func = testInstanceCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = name .. '.call (multiple value type)',
		func = testInstanceCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{
		name = name .. '.call (multiple strings)',
		func = testInstanceCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.stringType (single string)',
		func = testStringType,
		args = { 'foo' },
		expect = { 'foo' }
	},
	{
		name = name .. '.stringType (multiple string)',
		func = testStringType,
		args = { 'foo', 'bar', 'baz' },
		expect = { 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.functionType (single function)',
		func = testFunctionType,
		args = { function() return 'foo' end },
		expect = { true }
	},
	{
		name = name .. '.functionType (no function)',
		func = testFunctionType,
		args = {},
		expect = { false }
	},
}

return testframework.getTestProvider( tests )
