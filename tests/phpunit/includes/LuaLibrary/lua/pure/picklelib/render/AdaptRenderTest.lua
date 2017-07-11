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

local function testClarification( keyPart, lang )
	local str = makeTest():realizeClarification( keyPart, lang )
	if lang ~= 'qqx' then
		str = mw.ustring.gsub( str, '%(.-%)', '(<replacement>)' )
	end
	return str
end

local function testState( bool )
	local p = fix.create()
	if bool then
		p:ok()
	else
		p:notOk()
	end
	return makeTest():realizeState( p, 'qqx', counter.create() )
end

local function testHeader( ... ) -- luacheck: ignore
	local p = fix.create():ok()
	return makeTest():realizeHeader( p, 'qqx', counter.create() )
end

local function testBody( ... ) -- luacheck: ignore
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' )
	return makeTest():realizeBody( p, 'qqx' )
end

local tests = {
	-- AdaptRenderTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- AdaptRenderTest[2]
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- AdaptRenderTest[3]
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- AdaptRenderTest[4]
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- AdaptRenderTest[5]
	{
		name = name .. '.clarification ("skip", "qqx")',
		func = testClarification,
		args = { "is-skip", 'qqx' },
		expect = {'skip (parentheses: (pickle-report-adapt-is-skip-keyword))' }
	},
	-- AdaptRenderTest[6]
	{
		name = name .. '.clarification ("skip", "nb")',
		func = testClarification,
		-- scary, it uses a language code, but only the clarification should be translated
		args = { "is-skip", 'nb' },
		expect = { "skip (<replacement>)" }
	},
	-- AdaptRenderTest[7]
	{
		name = name .. '.clarification ("todo", "qqx")',
		func = testClarification,
		args = { "is-todo", 'qqx' },
		expect = { 'todo (parentheses: (pickle-report-adapt-is-todo-keyword))' }
	},
	-- AdaptRenderTest[8]
	{
		name = name .. '.clarification ("todo", "nb")',
		func = testClarification,
		-- scary, it uses a language code, but only the clarification should be translated
		args = { "is-todo", 'nb' },
		expect = { "todo (<replacement>)" }
	},
	-- AdaptRenderTest[9]
	{
		name = name .. '.state ()',
		func = testState,
		args = { false },
		expect = { 'not ok 0 (parentheses: (pickle-report-adapt-is-not-ok-keyword))' }
	},
	-- AdaptRenderTest[10]
	{
		name = name .. '.state ()',
		func = testState,
		args = { true },
		expect = { 'ok 0 (parentheses: (pickle-report-adapt-is-ok-keyword))' }
	},
	-- AdaptRenderTest[11]
	{
		name = name .. '.header ()',
		func = testHeader,
		args = { 'baz' },
		--[[
		expect = { '(pickle-report-adapt-is-ok)'
			.. '(pickle-report-adapt-wrap-comment: testing)'
			.. '# (pickle-report-adapt-wrap-todo: baz)' }
		]]
		expect = { 'ok 0 (parentheses: (pickle-report-adapt-is-ok-keyword))' }
	},
	-- AdaptRenderTest[12]
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
