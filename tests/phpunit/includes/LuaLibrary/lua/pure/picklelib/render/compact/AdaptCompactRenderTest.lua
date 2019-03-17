--- Tests for the report module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/compact/AdaptCompactRender'
assert( lib )

local name = 'resultRender'

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

local function testKey( ... )
	return makeTest():key( ... )
end

local function testBodyOk( ... ) -- luacheck: ignore
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):ok()
	return makeTest():realizeBody( p, 'qqx' )
end

local function testBodyNotOk( ... ) -- luacheck: ignore
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):notOk()
	return makeTest():realizeBody( p, 'qqx' )
end

local tests = {
	-- AdaptCompactRenderTest[1]
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- AdaptCompactRenderTest[2]
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	-- AdaptCompactRenderTest[3]
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	-- AdaptCompactRenderTest[4]
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	-- AdaptCompactRenderTest[5]
	{
		name = name .. '.key ()',
		func = testKey,
		args = { 'foo' },
		expect = { 'pickle-report-adapt-foo' }
	},
	-- AdaptCompactRenderTest[6]
	{
		name = name .. '.body ok ()',
		func = testBodyOk,
		expect = { '' }
	},
	-- AdaptCompactRenderTest[7]
	{
		name = name .. '.body not ok ()',
		func = testBodyNotOk,
		expect = { "\n"
			.. '(foo)' .. "\n"
			.. '(bar)' .. "\n"
			.. '(baz)' }
	},
}

return testframework.getTestProvider( tests )
