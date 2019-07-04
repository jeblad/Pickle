--- Tests for the report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/RenderAdaptCompact'
assert( lib )

local name = 'resultRender'

local fix = require 'picklelib/report/ReportAdapt'
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

local function testBodyOk()
	local p = fix:create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):ok()
	return makeTest():realizeBody( p, 'qqx' )
end

local function testBodyNotOk()
	local p = fix:create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):notOk()
	return makeTest():realizeBody( p, 'qqx' )
end

local tests = {
	-- RenderAdaptCompactTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- RenderAdaptCompactTest[2]
	{
		name = name .. ':create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- RenderAdaptCompactTest[3]
	{
		name = name .. ':create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- RenderAdaptCompactTest[4]
	{
		name = name .. ':create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- RenderAdaptCompactTest[5]
	{
		name = name .. ':key ()',
		func = testKey,
		args = { 'foo' },
		expect = { 'pickle-report-adapt-foo' }
	},
	-- RenderAdaptCompactTest[6]
	{
		name = name .. ':body ok ()',
		func = testBodyOk,
		expect = { '' }
	},
	-- RenderAdaptCompactTest[7]
	{
		name = name .. ':body not ok ()',
		func = testBodyNotOk,
		expect = { "\n"
			.. '(foo)' .. "\n"
			.. '(bar)' .. "\n"
			.. '(baz)' }
	},
}

return testframework.getTestProvider( tests )
