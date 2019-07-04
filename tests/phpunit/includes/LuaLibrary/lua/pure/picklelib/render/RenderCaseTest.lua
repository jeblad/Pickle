--- Tests for the report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/RenderCase'
assert( lib )

local name = 'reportRender'

local fix = require 'picklelib/report/ReportCase'
assert( fix )

local counter = require 'picklelib/Counter'
assert( counter )

local function makeTest( ... )
	return lib:create( ... )
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
	local p = fix:create()
	if bool then
		p:ok()
	else
		p:notOk()
	end
	return makeTest():realizeState( p, 'qqx', counter:create() )
end

local function testSkip( ... )
	local p = fix:create():setSkip( ... )
	return makeTest():realizeSkip( p, 'qqx' )
end

local function testTodo( ... )
	local p = fix:create():setTodo( ... )
	return makeTest():realizeTodo( p, 'qqx' )
end

local function testDescription( ... )
	local p = fix:create():setDescription( ... )
	return makeTest():realizeDescription( p, 'qqx' )
end

local function testHeaderSkip( ... )
	local p = fix:create():setDescription( 'testing' ):setSkip( ... ):notOk()
	return makeTest():realizeHeader( p, 'qqx', counter:create() )
end

local function testHeaderTodo( ... )
	local p = fix:create():setDescription( 'testing' ):setTodo( ... ):ok()
	return makeTest():realizeHeader( p, 'qqx', counter:create() )
end
--[[
local function testBody()
	local p = fix:create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' )
	return makeTest():realizeBody( p, 'qqx' )
end
]]
local tests = {
	-- RenderCaseTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- RenderCaseTest[2]
	{
		name = name .. ':create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- RenderCaseTest[3]
	{
		name = name .. ':create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- RenderCaseTest[4]
	{
		name = name .. ':create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- RenderCaseTest[5]
	{
		name = name .. ':clarification ("skip", "qqx")',
		func = testClarification,
		args = { "is-skip", 'qqx' },
		expect = { 'skip (parentheses: (pickle-report-case-is-skip-keyword))' }
	},
	-- RenderCaseTest[6]
	{
		name = name .. ':clarification ("skip", "nb")',
		func = testClarification,
		-- scary, it uses a language code, but only the clarification should be translated
		args = { "is-skip", 'nb' },
		expect = { "skip (<replacement>)" }
	},
	-- RenderCaseTest[7]
	{
		name = name .. ':clarification ("todo", "qqx")',
		func = testClarification,
		args = { "is-todo", 'qqx' },
		expect = { 'todo (parentheses: (pickle-report-case-is-todo-keyword))' }
	},
	-- RenderCaseTest[8]
	{
		name = name .. ':clarification ("todo", "nb")',
		func = testClarification,
		-- scary, it uses a language code, but only the clarification should be translated
		args = { "is-todo", 'nb' },
		expect = { "todo (<replacement>)" }
	},
	-- RenderCaseTest[9]
	{
		name = name .. ':state ()',
		func = testState,
		args = { false },
		expect = { 'not ok 0 (parentheses: (pickle-report-case-is-not-ok-keyword))' }
	},
	-- RenderCaseTest[10]
	{
		name = name .. ':state ()',
		func = testState,
		args = { true },
		expect = { 'ok 0 (parentheses: (pickle-report-case-is-ok-keyword))' }
	},
	-- RenderCaseTest[11]
	{
		name = name .. ':skip ()',
		func = testSkip,
		args = { 'foo' },
		expect = { 'skip (parentheses: (pickle-report-case-is-skip-keyword)) foo' }
	},
	-- RenderCaseTest[12]
	{
		name = name .. ':todo ()',
		func = testTodo,
		args = { 'bar' },
		expect = { 'todo (parentheses: (pickle-report-case-is-todo-keyword)) bar' }
	},
	-- RenderCaseTest[13]
	{
		name = name .. ':description ()',
		func = testDescription,
		args = { 'baz' },
		expect = { 'baz' }
	},
	-- RenderCaseTest[14]
	{
		name = name .. ':header ()',
		func = testHeaderSkip,
		args = { 'baz' },
		expect = { 'not ok 0 (parentheses: (pickle-report-case-is-not-ok-keyword))'
		.. ' testing # skip (parentheses: (pickle-report-case-is-skip-keyword)) baz' }
	},
	-- RenderCaseTest[15]
	{
		name = name .. ':header ()',
		func = testHeaderTodo,
		args = { 'baz' },
		expect = { 'ok 0 (parentheses: (pickle-report-case-is-ok-keyword))'
		.. ' testing # todo (parentheses: (pickle-report-case-is-todo-keyword)) baz' }
	},
	--[[
	-- RenderCaseTest[16]
	{
		name = name .. ':body ()',
		func = testBody,
		expect = { "\n"
			.. '(foo)' .. "\n"
			.. '(bar)' .. "\n"
			.. '(baz)' }
	},
	]]
}

return testframework.getTestProvider( tests )
