--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/vivid/FrameReportRenderStrategy'
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
--[[
local function testState( bool )
	local p = fix.create()
	if bool then
		p:ok()
	else
		p:notOk()
	end
	return tostring( makeTest():realizeState( p, 'qqx' ) )
end
]]
local function testSkip( ... )
	local p = fix.create():setSkip( ... )
	return tostring( makeTest():realizeSkip( p, 'qqx' ) )
end

local function testTodo( ... )
	local p = fix.create():setTodo( ... )
	return tostring( makeTest():realizeTodo( p, 'qqx' ) )
end

local function testDescription( ... )
	local p = fix.create():setDescription( ... )
	return tostring( makeTest():realizeDescription( p, 'qqx' ) )
end

local function testHeaderSkip( ... )
	local p = fix.create():setDescription( 'testing' ):setSkip( ... )
	return tostring( makeTest():realizeHeader( p, 'qqx' ) )
end

local function testHeaderTodo( ... )
	local p = fix.create():setDescription( 'testing' ):setTodo( ... )
	return tostring( makeTest():realizeHeader( p, 'qqx' ) )
end

local function testHeaderOk( ... ) -- luacheck: ignore
	local adapt = require 'picklelib/report/AdaptReport'.create():ok()
	local p = fix.create():addConstituent( adapt )
	return tostring( makeTest():realizeHeader( p, 'qqx' ) )
end

local function testHeaderNotOk( ... ) -- luacheck: ignore
	local adapt = require 'picklelib/report/AdaptReport'.create():notOk()
	local p = fix.create():addConstituent( adapt )
	return tostring( makeTest():realizeHeader( p, 'qqx' ) )
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
	--[[
	{
		name = name .. '.state ()',
		func = testState,
		args = { false },
		expect = { '<span class="mw-pickle-state" lang="qqx">'
			.. '(pickle-report-frame-is-not-ok)'
			.. '</span>' }
	},
	{
		name = name .. '.state ()',
		func = testState,
		args = { true },
		expect = { '<span class="mw-pickle-state" lang="qqx">'
			.. '(pickle-report-frame-is-ok)'
			.. '</span>' }
	},
	]]
	{
		name = name .. '.skip ()',
		func = testSkip,
		args = { 'foo' },
		expect = { '<span class="mw-pickle-skip" lang="qqx">'
			.. '(pickle-report-frame-wrap-skip: foo)'
			.. '</span>' }
	},
	{
		name = name .. '.todo ()',
		func = testTodo,
		args = { 'bar' },
		expect = { '<span class="mw-pickle-todo" lang="qqx">'
			.. '(pickle-report-frame-wrap-todo: bar)'
			.. '</span>' }
	},
	{
		name = name .. '.description ()',
		func = testDescription,
		args = { 'baz' },
		expect = { '<span class="mw-pickle-description" lang="qqx">'
			.. '(pickle-report-frame-wrap-description: baz)'
			.. '</span>' }
	},
	{
		name = name .. '.header skip ()',
		func = testHeaderSkip,
		args = { 'baz' },
		expect = { '<div class="mw-pickle-header">'
			.. '<span class="mw-pickle-state" lang="qqx">'
			.. '(pickle-report-frame-is-ok)'
			.. '</span>'
			.. '<span class="mw-pickle-description" lang="qqx">'
			.. '(pickle-report-frame-wrap-description: testing)'
			.. '</span>'
			.. '<span class="mw-pickle-comment">'
			.. ' '
			.. '<span class="mw-pickle-skip" lang="qqx">'
			.. '(pickle-report-frame-wrap-skip: baz)'
			.. '</span>'
			.. '</span>'
			.. '</div>' }
	},
	{
		name = name .. '.header todo ()',
		func = testHeaderTodo,
		args = { 'baz' },
		expect = { '<div class="mw-pickle-header">'
			.. '<span class="mw-pickle-state" lang="qqx">'
			.. '(pickle-report-frame-is-ok)'
			.. '</span>'
			.. '<span class="mw-pickle-description" lang="qqx">'
			.. '(pickle-report-frame-wrap-description: testing)'
			.. '</span>'
			.. '<span class="mw-pickle-comment">'
			.. ' '
			.. '<span class="mw-pickle-todo" lang="qqx">'
			.. '(pickle-report-frame-wrap-todo: baz)'
			.. '</span>'
			.. '</span>'
			.. '</div>' }
	},
	{
		name = name .. '.header ok ()',
		func = testHeaderOk,
		expect = { '<div class=\"mw-pickle-header\">'
			.. '<span class=\"mw-pickle-state\" lang=\"qqx\">'
			.. '(pickle-report-frame-is-ok)'
			.. '</span>'
			.. '</div>' }
	},
	{
		name = name .. '.header not ok ()',
		func = testHeaderNotOk,
		expect = { '<div class=\"mw-pickle-header\">'
			.. '<span class=\"mw-pickle-state\" lang=\"qqx\">'
			.. '(pickle-report-frame-is-not-ok)'
			.. '</span>'
			.. '</div>' }
	},
}

return testframework.getTestProvider( tests )
