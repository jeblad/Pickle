--- Tests for the subject module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local Subject = require 'picklelib/engine/Subject'
local subjects = require 'picklelib/Stack'

local function makeSubject( ... )
	return Subject.create( ... ):setSubjects( subjects.create() )
end

local function testExists()
	return type( Subject )
end

local function testCreate( ... )
	return type( makeSubject( ... ) )
end

local function testSubjects( ... )
	local obj = makeSubject()
	local t = { ... }
	for _,v in ipairs( t ) do
		obj:subjects():push( v )
	end
	return { obj:subjects():export() }
end

local function testDoubleCall( ... )
	Subject( 'foo' )
	local subj = Subject( ... )
	Subject.stack:flush()
	return subj:temporal()
end

local tests = {
	{
		name = 'subject exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'subject.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = 'subject.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = 'subject.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = 'subject.subjects (multiple value)',
		func = testSubjects,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
	{
		name = 'subject.call (nil value)',
		func = testDoubleCall,
		args = {},
		expect = { 'foo' }
	},
	{
		name = 'subject.call (single value)',
		func = testDoubleCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = 'subject.call (multiple value)',
		func = testDoubleCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
}

return testframework.getTestProvider( tests )
