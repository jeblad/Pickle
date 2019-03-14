--- Tests for the base report module.
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/RenderBase'
assert( lib )

local name = 'base'
local class = 'base-render'

local counter = require 'picklelib/Counter'
assert( counter )

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
	return makeTest():realizeClarification( keyPart, 'qqx' )
end

--[[
local function testComment( keyPart )
	local p = require('picklelib/report/ReportBase').create()
	return makeTest():realizeComment( p, keyPart )
end
]]

local tests = {
	-- RenderBaseTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- RenderBaseTest[2]
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- RenderBaseTest[3]
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- RenderBaseTest[4]
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- RenderBaseTest[5]
	{
		name = name .. '.type ()',
		func = testType,
		expect = { class }
	},
	-- RenderBaseTest[6]
	{
		name = name .. '.key ("foo-bar")',
		func = testKey,
		args = { "foo-bar" },
		expect = { "pickle-report-base-foo-bar" }
	},
	-- RenderBaseTest[7]
	{
		name = name .. '.clarification ("skip")',
		func = testClarification,
		args = { "skip" },
		expect = { '⧼pickle-report-base-skip-keyword⧽'
		.. ' (parentheses: (pickle-report-base-skip-keyword))' }
	},
	-- RenderBaseTest[8]
	{
		name = name .. '.clarification ("todo")',
		func = testClarification,
		args = { "todo" },
		expect = { '⧼pickle-report-base-todo-keyword⧽'
		.. ' (parentheses: (pickle-report-base-todo-keyword))' }
	},
	--[[
	-- RenderBaseTest[9]
	{
		name = name .. '.comment ("foobar")',
		func = testComment,
		args = { "foobar" },
		expect = { "⧼pickle-report-base-wrap-untranslated⧽" }
	},
	]]
}

return testframework.getTestProvider( tests )
