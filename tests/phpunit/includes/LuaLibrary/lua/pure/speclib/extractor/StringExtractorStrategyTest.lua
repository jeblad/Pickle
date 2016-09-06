--- Tests for the string extractor module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'speclib/extractor/StringExtractorStrategy'
local name = 'extractor'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testType( ... )
	return makeTest( ... ):type()
end

local function testFind( str, ... )
	return makeTest( ... ):find( str, 1 )
end

local function testCast( ... )
	return makeTest():cast( ... )
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
  { name = name .. '.type ()', func = testType,
    expect = { 'string' }
  },
  { name = name .. '.find (not matched)', func = testFind,
    args = { 'foo bar baz' },
    expect = {}
  },
  { name = name .. '.find (matched)', func = testFind,
    args = { '"test"' },
    expect = { 2, 5 }
  },
  { name = name .. '.find (matched)', func = testFind,
    args = { '"test" bar baz' },
    expect = { 2, 5 }
  },
  { name = name .. '.find (matched)', func = testFind,
    args = { 'foo "test" baz' },
    expect = { 6, 9 }
  },
  { name = name .. '.find (matched)', func = testFind,
    args = { 'foo bar "test"' },
    expect = { 10, 13 }
  },
  { name = name .. '.cast (empty)', func = testCast,
    args = { 'foo bar "test"', 10, 13 },
    expect = { "test" }
  },
}

return testframework.getTestProvider( tests )
