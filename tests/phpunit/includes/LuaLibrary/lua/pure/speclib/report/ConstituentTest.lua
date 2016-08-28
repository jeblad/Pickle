--- Tests for the constituent module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local constituent = require 'speclib/report/Constituent'

local function makeConstituent( ... )
	return constituent.create( ... )
end

local function testExists()
	return type( constituent )
end

local function testCreate( ... )
	return type( makeConstituent( ... ) )
end

local function testRealize( ... )
	return makeConstituent( ... ):realize()
end

local function testType( ... )
	return makeConstituent( ... ):type()
end

local tests = {
	{ name = 'constituent exists', func = testExists, type='ToString',
	  expect = { 'table' }
	},
	{ name = 'constituent.create (nil value type)', func = testCreate, type='ToString',
	  args = { nil },
	  expect = { 'table' }
	},
	{ name = 'constituent.create (single value type)', func = testCreate, type='ToString',
	  args = { 'a' },
	  expect = { 'table' }
	},
	{ name = 'constituent.create (multiple value type)', func = testCreate, type='ToString',
	  args = { 'a', 'b', 'c' },
	  expect = { 'table' }
	},
	{ name = 'constituent.realize (nil)', func = testRealize,
	  args = { nil },
	  expect = { '' }
	},
	{ name = 'constituent.type ()', func = testType,
	  expect = { 'Constituent' }
	},
}

return testframework.getTestProvider( tests )
