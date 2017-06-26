--- Tests for the base report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/RenderBase'
assert( lib )

local name = 'base'
local class = 'base-render'

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

local function testKey( ... )
	return makeTest():key(...)
end

local function testClarification( keyPart )
	return makeTest():realizeClarification( keyPart )
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
		name = name .. '.key ("foo-bar")',
		func = testKey,
		args = { "foo-bar" },
		expect = { "pickle-report-base-foo-bar" }
	},
	{
		name = name .. '.clarification ("skip")',
		func = testClarification,
		args = { "skip" },
		expect = { "⧼pickle-report-base-wrap-untranslated⧽" }
	},
	{
		name = name .. '.clarification ("todo")',
		func = testClarification,
		args = { "todo" },
		expect = { "⧼pickle-report-base-wrap-untranslated⧽" }
	},
}

return testframework.getTestProvider( tests )
