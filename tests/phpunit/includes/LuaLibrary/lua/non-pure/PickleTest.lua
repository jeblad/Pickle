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

local function testMWFunc( nme ) -- luacheck: ignore
	return type( mw[ nme ] )
end

local tests = {
	{
		name = 'pickles exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'subject exists',
		func = testSubjectExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'expect exists',
		func = testExpectExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'pickles.call',
		func = testCall,
		args = { },
		expect = { 'table', 'table' }
	},
	--[[
	{
		name = 'table mw.describe',
		func = testMWFunc,
		args = { 'describe' },
		expect = { 'table' }
	},
	{
		name = 'table mw.context',
		func = testMWFunc,
		args = { 'context' },
		expect = { 'table' }
	},
	{
		name = 'table mw.it',
		func = testMWFunc,
		args = { 'it' },
		expect = { 'table' }
	},
	{
		name = 'table mw.subject',
		func = testMWFunc,
		args = { 'subject' },
		expect = { 'table' }
	},
	{
		name = 'table mw.expect',
		func = testMWFunc,
		args = { 'expect' },
		expect = { 'table' }
	},
	{
		name = 'table mw.carp',
		func = testMWFunc,
		args = { 'carp' },
		expect = { 'function' }
	},
	{
		name = 'table mw.carp',
		func = testMWFunc,
		args = { 'cluck' },
		expect = { 'function' }
	},
	{
		name = 'table mw.carp',
		func = testMWFunc,
		args = { 'confess' },
		expect = { 'function' }
	},
	{
		name = 'table mw.carp',
		func = testMWFunc,
		args = { 'croak' },
		expect = { 'function' }
	},
	]]
}

return testframework.getTestProvider( tests )
