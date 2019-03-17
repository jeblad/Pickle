--- Tests for the report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/full/FrameFullRender'
assert( lib )

local name = 'resultRender'

local fix = require 'picklelib/report/FrameReport'
assert( fix )

local function makeTest( ... )
	return lib:create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testKey( ... )
	return makeTest():key( ... )
end

local function testHeaderOk( ... ) -- luacheck: ignore
	local adapt = require 'picklelib/report/AdaptReport'.create():ok()
	local p = fix.create():addConstituent( adapt )
	return makeTest():realizeHeader( p, 'qqx' )
end

local function testHeaderNotOk( ... ) -- luacheck: ignore
	local adapt = require 'picklelib/report/AdaptReport'.create():notOk()
	local p = fix.create():addConstituent( adapt )
	return makeTest():realizeHeader( p, 'qqx' )
end

local tests = {
	-- FrameFullRenderTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- FrameFullRenderTest[2]
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- FrameFullRenderTest[3]
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- FrameFullRenderTest[4]
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- FrameFullRenderTest[5]
	{
		name = name .. '.key ()',
		func = testKey,
		args = { 'foo' },
		expect = { 'pickle-report-frame-foo' }
	},
	-- FrameFullRenderTest[6]
	{
		name = name .. '.header ok ()',
		func = testHeaderOk,
		expect = { 'ok (parentheses: (pickle-report-frame-is-ok-keyword))' }
	},
	-- FrameFullRenderTest[7]
	{
		name = name .. '.header not ok ()',
		func = testHeaderNotOk,
		expect = { 'not ok (parentheses: (pickle-report-frame-is-not-ok-keyword))' }
	},
}

return testframework.getTestProvider( tests )
