--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/render/full/ResultRenderStrategy'
local name = 'resultRender'
local class = 'ResultRender'

local fix = require 'picklelib/report/Result'

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

local function testBodyOk( ... )
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):ok()
	return makeTest():realizeBody( p, 'qqx' )
end

local function testBodyNotOk( ... )
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' ):notOk()
	return makeTest():realizeBody( p, 'qqx' )
end

local tests = {
	{ name = name .. ' exists', func = testExists, type='ToString',
	  expect = { 'table' }
	},
	{ name = name .. '.create (nil value type)', func = testCreate, type='ToString',
	  args = { nil },
	  expect = { 'table' }
	},
	{ name = name .. '.create (single value type)', func = testCreate, type='ToString',
	  args = { 'a' },
	  expect = { 'table' }
	},
	{ name = name .. '.create (multiple value type)', func = testCreate, type='ToString',
	  args = { 'a', 'b', 'c' },
	  expect = { 'table' }
	},
	{ name = name .. '.key ()', func = testKey,
	  args = { 'foo' },
	  expect = { 'pickle-report-result-full-foo' }
	},
	{ name = name .. '.body ()', func = testBodyOk,
	  expect = { "\n"
			.. '(pickle-report-result-full-wrap-line: (foo))' .. "\n"
			.. '(pickle-report-result-full-wrap-line: (bar))' .. "\n"
			.. '(pickle-report-result-full-wrap-line: (baz))' }
	},
	{ name = name .. '.body ()', func = testBodyNotOk,
	  expect = { "\n"
			.. '(pickle-report-result-full-wrap-line: (foo))' .. "\n"
			.. '(pickle-report-result-full-wrap-line: (bar))' .. "\n"
			.. '(pickle-report-result-full-wrap-line: (baz))' }
	},
}

return testframework.getTestProvider( tests )
