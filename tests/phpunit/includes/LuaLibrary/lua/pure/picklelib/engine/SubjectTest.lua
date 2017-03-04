--- Tests for the subject module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local Subject = require 'picklelib/engine/Subject'

local function makeSubject( ... )
	return Subject.create( ... )
end

local function testExists()
	return type( Subject )
end

local function testCreate( ... )
	return type( makeSubject( ... ) )
end

local function testStack( ... )
	local t = { ... }
	for _,v in ipairs( t ) do
		Subject.stack:push( v )
	end
	return { Subject.stack:export() }
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
		name = 'subject.stack (multiple value)',
		func = testStack,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
	{
		name = 'subject.call (nil value)',
		func = testDoubleCall,
		args = {},
		expect = { { 'foo' } }
	},
	{
		name = 'subject.call (single value)',
		func = testDoubleCall,
		args = { 'a' },
		expect = { { 'a' } }
	},
	{
		name = 'subject.call (multiple value)',
		func = testDoubleCall,
		args = { 'a', 'b', 'c' },
		expect = { { 'a', 'b', 'c' } }
	},
}

return testframework.getTestProvider( tests )
