--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/full/FrameReportRenderStrategy'
local name = 'resultRender'

local fix = require 'picklelib/report/FrameReport'

local function makeTest( ... )
	return lib.create( ... )
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
		name = name .. '.key ()',
		func = testKey,
		args = { 'foo' },
		expect = { 'pickle-report-frame-foo' }
	},
	{
		name = name .. '.header ok ()',
		func = testHeaderOk,
		expect = { '(pickle-report-frame-wrap-translated: ok, (pickle-report-frame-is-ok-translated))' }
	},
	{
		name = name .. '.header not ok ()',
		func = testHeaderNotOk,
		expect = { '(pickle-report-frame-wrap-translated: not ok, (pickle-report-frame-is-not-ok-translated))' }
	},
}

return testframework.getTestProvider( tests )
