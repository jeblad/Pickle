--- Tests for the plan module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'speclib/report/Plan'
local name = 'plan'
local class = 'plan'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testRender( ... )
	return makeTest( ... ):render()
end

local function testType( ... )
	return makeTest( ... ):type()
end

local function testConstituents( ... )
    local p = makeTest()
    local t = { ... }
    for _,v in ipairs( t ) do
        p:addConstituent( v )
    end
	return { p:constituents() }
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
    --[[
	{ name = name .. '.render (nil)', func = testRender,
	  args = { nil },
	  expect = { '' }
	},
    --]]
	{ name = name .. '.type ()', func = testType,
	  expect = { class }
	},
	{ name = name .. ':addConstituent (multiple value type)', func = testConstituents,
	  args = { 'foo', 'bar', 'baz' },
	  expect = { { 'foo', 'bar', 'baz' } }
	},
}

return testframework.getTestProvider( tests )
