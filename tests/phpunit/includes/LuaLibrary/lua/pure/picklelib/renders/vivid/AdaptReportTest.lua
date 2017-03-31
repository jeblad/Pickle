--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/vivid/AdaptReportRenderStrategy'
local name = 'resultRender'

local fix = require 'picklelib/report/AdaptReport'

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

local function testBodyOk( ... ) -- luacheck: ignore
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):ok()
	return tostring( makeTest():realizeBody( p, 'qqx' ) )
end

local function testBodyNotOk( ... ) -- luacheck: ignore
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):notOk()
	return tostring( makeTest():realizeBody( p, 'qqx' ) )
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
		expect = { 'pickle-report-adapt-foo' }
	},
	{
		name = name .. '.body ()',
		func = testBodyOk,
		expect = { '<dl class="mw-pickle-body">'
			.. '<dd class="mw-pickle-line" lang="qqx">(pickle-report-adapt-wrap-line: (foo))</dd>'
			.. '<dd class="mw-pickle-line" lang="qqx">(pickle-report-adapt-wrap-line: (bar))</dd>'
			.. '<dd class="mw-pickle-line" lang="qqx">(pickle-report-adapt-wrap-line: (baz))</dd>'
			.. '</dl>' }
	},
	{
		name = name .. '.body ()',
		func = testBodyNotOk,
		expect = { '<dl class="mw-pickle-body" style="display:none">'
			.. '<dd class="mw-pickle-line" lang="qqx">(pickle-report-adapt-wrap-line: (foo))</dd>'
			.. '<dd class="mw-pickle-line" lang="qqx">(pickle-report-adapt-wrap-line: (bar))</dd>'
			.. '<dd class="mw-pickle-line" lang="qqx">(pickle-report-adapt-wrap-line: (baz))</dd>'
			.. '</dl>' }
	},
}

return testframework.getTestProvider( tests )
