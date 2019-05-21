--- Tests for the report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/RenderAdapt'
assert( lib )

local name = 'reportRender'

local fix = require 'picklelib/report/ReportAdapt'
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

local function testHeader()
	local p = fix:create():ok()
	return makeTest():realizeHeader( p, 'qqx', counter:create() )
end

local function testBody()
	local p = fix:create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' )
	return makeTest():realizeBody( p, 'qqx' )
end

local tests = {
	-- RenderAdaptTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- RenderAdaptTest[2]
	{
		name = name .. ':create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- RenderAdaptTest[3]
	{
		name = name .. ':create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- RenderAdaptTest[4]
	{
		name = name .. ':create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- RenderAdaptTest[5]
	{
		name = name .. ':clarification ("skip", "qqx")',
		func = testClarification,
		args = { "is-skip", 'qqx' },
		expect = {'skip (parentheses: (pickle-report-adapt-is-skip-keyword))' }
	},
	-- RenderAdaptTest[6]
	{
		name = name .. ':clarification ("skip", "nb")',
		func = testClarification,
		-- scary, it uses a language code, but only the clarification should be translated
		args = { "is-skip", 'nb' },
		expect = { "skip (<replacement>)" }
	},
	-- RenderAdaptTest[7]
	{
		name = name .. ':clarification ("todo", "qqx")',
		func = testClarification,
		args = { "is-todo", 'qqx' },
		expect = { 'todo (parentheses: (pickle-report-adapt-is-todo-keyword))' }
	},
	-- RenderAdaptTest[8]
	{
		name = name .. ':clarification ("todo", "nb")',
		func = testClarification,
		-- scary, it uses a language code, but only the clarification should be translated
		args = { "is-todo", 'nb' },
		expect = { "todo (<replacement>)" }
	},
	-- RenderAdaptTest[9]
	{
		name = name .. ':state ()',
		func = testState,
		args = { false },
		expect = { 'not ok 0 (parentheses: (pickle-report-adapt-is-not-ok-keyword))' }
	},
	-- RenderAdaptTest[10]
	{
		name = name .. ':state ()',
		func = testState,
		args = { true },
		expect = { 'ok 0 (parentheses: (pickle-report-adapt-is-ok-keyword))' }
	},
	-- RenderAdaptTest[11]
	{
		name = name .. ':header ()',
		func = testHeader,
		args = { 'baz' },
		expect = { 'ok 0 (parentheses: (pickle-report-adapt-is-ok-keyword))' }
	},
	-- RenderAdaptTest[12]
	{
		name = name .. ':body ()',
		func = testBody,
		expect = { "\n"
			.. '(foo)' .. "\n"
			.. '(bar)' .. "\n"
			.. '(baz)' }
	},
}

return testframework.getTestProvider( tests )
