--- Tests for the subject module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local specs = require 'specs'

local function testExists()
	return type( specs )
end

local function testSubjectExists()
	return type( specs.subject )
end

local function testExpectExists()
	return type( specs.expect )
end

local function testCall( ... )
    specs()
	return type( subject ), type( expect )
end

local tests = {
  { name = 'specs exists', func = testExists, type='ToString',
    expect = { 'table' }
  },
  { name = 'subject exists', func = testSubjectExists, type='ToString',
    expect = { 'table' }
  },
  { name = 'expect exists', func = testExpectExists, type='ToString',
    expect = { 'table' }
  },
  { name = 'specs.call', func = testCall,
    args = {  },
    expect = { 'table', 'table' }
  },
}

return testframework.getTestProvider( tests )
