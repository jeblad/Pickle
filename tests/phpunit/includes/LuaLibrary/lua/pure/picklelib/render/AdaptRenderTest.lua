--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/AdaptRender'
assert( lib )

local name = 'reportRender'

local fix = require 'picklelib/report/AdaptReport'
assert( fix )

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testState( bool )
	local p = fix.create()
	if bool then
		p:ok()
	else
		p:notOk()
	end
	return makeTest():realizeState( p, 'qqx' )
end

local function testHeader( ... ) -- luacheck: ignore
	local p = fix.create():ok()
	return makeTest():realizeHeader( p, 'qqx' )
end

local function testBody( ... ) -- luacheck: ignore
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' )
	return makeTest():realizeBody( p, 'qqx' )
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
		name = name .. '.state ()',
		func = testState,
		args = { false },
		expect = { '(pickle-report-adapt-wrap-translated:'
		.. ' not ok, (pickle-report-adapt-is-not-ok-translated))' }
	},
	{
		name = name .. '.state ()',
		func = testState,
		args = { true },
		expect = { '(pickle-report-adapt-wrap-translated:'
		.. ' ok, (pickle-report-adapt-is-ok-translated))' }
	},
	{
		name = name .. '.header ()',
		func = testHeader,
		args = { 'baz' },
		--[[
		expect = { '(pickle-report-adapt-is-ok)'
			.. '(pickle-report-adapt-wrap-description: testing)'
			.. '# (pickle-report-adapt-wrap-todo: baz)' }
		]]
		expect = { '(pickle-report-adapt-wrap-translated:'
		.. ' ok, (pickle-report-adapt-is-ok-translated))' }
	},
	{
		name = name .. '.body ()',
		func = testBody,
		expect = { "\n"
			.. '(pickle-report-adapt-wrap-line: (foo))' .. "\n"
			.. '(pickle-report-adapt-wrap-line: (bar))' .. "\n"
			.. '(pickle-report-adapt-wrap-line: (baz))' }
	},
}

return testframework.getTestProvider( tests )
