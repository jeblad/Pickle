--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/FrameRender'
assert( lib )

local name = 'reportRender'

local fix = require 'picklelib/report/FrameReport'
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

local function testSkip( ... )
	local p = fix.create():setSkip( ... )
	return makeTest():realizeSkip( p, 'qqx' )
end

local function testTodo( ... )
	local p = fix.create():setTodo( ... )
	return makeTest():realizeTodo( p, 'qqx' )
end

local function testDescription( ... )
	local p = fix.create():setDescription( ... )
	return makeTest():realizeDescription( p, 'qqx' )
end

local function testHeaderSkip( ... ) -- luacheck: ignore
	local p = fix.create():setDescription( 'testing' ):setSkip( ... ):notOk()
	return makeTest():realizeHeader( p, 'qqx' )
end

local function testHeaderTodo( ... ) -- luacheck: ignore
	local p = fix.create():setDescription( 'testing' ):setTodo( ... ):ok()
	return makeTest():realizeHeader( p, 'qqx' )
end
--[[
local function testBody( ... ) -- luacheck: ignore
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' )
	return makeTest():realizeBody( p, 'qqx' )
end
]]
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
		expect = { '(pickle-report-frame-wrap-translated:'
		.. ' not ok, (pickle-report-frame-is-not-ok-translated))' }
	},
	{
		name = name .. '.state ()',
		func = testState,
		args = { true },
		expect = { '(pickle-report-frame-wrap-translated:'
		.. ' ok, (pickle-report-frame-is-ok-translated))' }
	},
	{
		name = name .. '.skip ()',
		func = testSkip,
		args = { 'foo' },
		expect = { '(pickle-report-frame-wrap-description:'
		.. ' (pickle-report-frame-wrap-translated:'
		.. ' skip, (pickle-report-frame-is-skip-translated)), foo)' }
	},
	{
		name = name .. '.todo ()',
		func = testTodo,
		args = { 'bar' },
		expect = { '(pickle-report-frame-wrap-description:'
		.. ' (pickle-report-frame-wrap-translated:'
		.. ' todo, (pickle-report-frame-is-todo-translated)), bar)' }
	},
	{
		name = name .. '.description ()',
		func = testDescription,
		args = { 'baz' },
		expect = { '(pickle-report-frame-wrap-description: baz)' }
	},
	{
		name = name .. '.header ()',
		func = testHeaderSkip,
		args = { 'baz' },
		expect = { '(pickle-report-frame-wrap-translated:'
		.. ' not ok, (pickle-report-frame-is-not-ok-translated))'
		.. ' (pickle-report-frame-wrap-description: testing)'
		.. ' (pickle-report-frame-wrap-description:'
		.. ' (pickle-report-frame-wrap-translated:'
		.. ' skip, (pickle-report-frame-is-skip-translated)), baz)' }
	},
	{
		name = name .. '.header ()',
		func = testHeaderTodo,
		args = { 'baz' },
		expect = { '(pickle-report-frame-wrap-translated:'
		.. ' ok, (pickle-report-frame-is-ok-translated))'
		.. ' (pickle-report-frame-wrap-description: testing)'
		.. ' (pickle-report-frame-wrap-description:'
		.. ' (pickle-report-frame-wrap-translated:'
		.. ' todo, (pickle-report-frame-is-todo-translated)), baz)' }
	},
	--[[
	{
		name = name .. '.body ()',
		func = testBody,
		expect = { "\n"
			.. '(pickle-report-frame-wrap-line: (foo))' .. "\n"
			.. '(pickle-report-frame-wrap-line: (bar))' .. "\n"
			.. '(pickle-report-frame-wrap-line: (baz))' }
	},
	]]
}

return testframework.getTestProvider( tests )
