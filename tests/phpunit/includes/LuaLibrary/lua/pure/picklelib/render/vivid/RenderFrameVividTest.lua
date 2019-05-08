--- Tests for the report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/vivid/RenderFrameVivid'
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

local function testHeaderOk()
	local adapt = require 'picklelib/report/AdaptReport'.create():ok()
	local p = fix.create():addConstituent( adapt )
	return tostring( makeTest():realizeHeader( p, 'qqx' ) )
end

local function testHeaderNotOk()
	local adapt = require 'picklelib/report/AdaptReport'.create():notOk()
	local p = fix.create():addConstituent( adapt )
	return tostring( makeTest():realizeHeader( p, 'qqx' ) )
end

local tests = {
	-- RenderFrameVividTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- RenderFrameVividTest[2]
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- RenderFrameVividTest[3]
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- RenderFrameVividTest[4]
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- RenderFrameVividTest[5]
	{
		name = name .. '.key ()',
		func = testKey,
		args = { 'foo' },
		expect = { 'pickle-report-frame-foo' }
	},
	--[[
	-- RenderFrameVividTest[]
	{
		name = name .. '.state ()',
		func = testState,
		args = { false },
		expect = { '<span class="mw-pickle-state" lang="qqx">'
			.. 'not ok (parentheses: (pickle-report-frame-is-not-ok-keyword))'
			.. '</span>' }
	},
	-- RenderFrameVividTest[]
	{
		name = name .. '.state ()',
		func = testState,
		args = { true },
		expect = { '<span class="mw-pickle-state" lang="qqx">'
			.. 'ok (parentheses: (pickle-report-frame-is-ok-translated))'
			.. '</span>' }
	},
	]]
	-- RenderFrameVividTest[6]
	{
		name = name .. '.skip ()',
		func = testSkip,
		args = { 'foo' },
		expect = { '<span class="mw-pickle-skip" lang="qqx">'
			.. 'skip (parentheses: (pickle-report-frame-is-skip-keyword)) foo'
			.. '</span>' }
	},
	-- RenderFrameVividTest[7]
	{
		name = name .. '.todo ()',
		func = testTodo,
		args = { 'bar' },
		expect = { '<span class="mw-pickle-todo" lang="qqx">'
			.. 'todo (parentheses: (pickle-report-frame-is-todo-keyword)) bar'
			.. '</span>' }
	},
	-- RenderFrameVividTest[8]
	{
		name = name .. '.description ()',
		func = testDescription,
		args = { 'baz' },
		expect = { '<span class="mw-pickle-description" lang="qqx">'
			.. 'baz'
			.. '</span>' }
	},
	-- RenderFrameVividTest[9]
	{
		name = name .. '.header skip ()',
		func = testHeaderSkip,
		args = { 'baz' },
		expect = { '<div class="mw-pickle-header">'
			.. '<span class="mw-pickle-state" lang="qqx">'
			.. 'ok (parentheses: (pickle-report-frame-is-ok-keyword))'
			.. '</span>'
			.. '<span class="mw-pickle-description" lang="qqx">'
			.. 'testing'
			.. '</span>'
			.. '<span class="mw-pickle-comment">'
			.. ' '
			.. '<span class="mw-pickle-skip" lang="qqx">'
			.. 'skip (parentheses: (pickle-report-frame-is-skip-keyword)) baz'
			.. '</span>'
			.. '</span>'
			.. '</div>' }
	},
	-- RenderFrameVividTest[10]
	{
		name = name .. '.header todo ()',
		func = testHeaderTodo,
		args = { 'baz' },
		expect = { '<div class="mw-pickle-header">'
			.. '<span class="mw-pickle-state" lang="qqx">'
			.. 'ok (parentheses: (pickle-report-frame-is-ok-keyword))'
			.. '</span>'
			.. '<span class="mw-pickle-description" lang="qqx">'
			.. 'testing'
			.. '</span>'
			.. '<span class="mw-pickle-comment">'
			.. ' '
			.. '<span class="mw-pickle-todo" lang="qqx">'
			.. 'todo (parentheses: (pickle-report-frame-is-todo-keyword)) baz'
			.. '</span>'
			.. '</span>'
			.. '</div>' }
	},
	-- RenderFrameVividTest[11]
	{
		name = name .. '.header ok ()',
		func = testHeaderOk,
		expect = { '<div class=\"mw-pickle-header\">'
			.. '<span class=\"mw-pickle-state\" lang=\"qqx\">'
			.. 'ok (parentheses: (pickle-report-frame-is-ok-keyword))'
			.. '</span>'
			.. '</div>' }
	},
	-- RenderFrameVividTest[12]
	{
		name = name .. '.header not ok ()',
		func = testHeaderNotOk,
		expect = { '<div class=\"mw-pickle-header\">'
			.. '<span class=\"mw-pickle-state\" lang=\"qqx\">'
			.. 'not ok (parentheses: (pickle-report-frame-is-not-ok-keyword))'
			.. '</span>'
			.. '</div>' }
	},
}

return testframework.getTestProvider( tests )
