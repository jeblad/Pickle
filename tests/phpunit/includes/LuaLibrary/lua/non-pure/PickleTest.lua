--- Tests for the subject module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local pickles = require 'pickles'

local function testExists()
	return type( pickles )
end

local function testSubjectExists()
	return type( pickles.subject )
end

local function testExpectExists()
	return type( pickles.expect )
end

local function testCall( ... ) -- luacheck: ignore
	pickles()
	return type( subject ), type( expect ) -- luacheck: globals subject expect
end

local tests = {
	{ name = 'pickles exists', func = testExists, type='ToString',
		expect = { 'table' }
	},
	{ name = 'subject exists', func = testSubjectExists, type='ToString',
		expect = { 'table' }
	},
	{ name = 'expect exists', func = testExpectExists, type='ToString',
		expect = { 'table' }
	},
	{ name = 'pickles.call', func = testCall,
		args = { },
		expect = { 'table', 'table' }
	},
}

return testframework.getTestProvider( tests )
