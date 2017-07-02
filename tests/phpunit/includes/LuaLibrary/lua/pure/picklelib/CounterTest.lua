--- Tests for the counter module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local counter = require 'picklelib/Counter'
assert( counter )

local function makeCounter( ... )
	return counter.create( ... )
end

local function testExists()
	return type( counter )
end

local function testCreate( ... )
	return type( makeCounter( ... ) )
end

local function testSequence( len )
	local count = makeCounter()
	local seq = {}
	for _=1,len,1 do
		table.insert( seq, count:inc() )
		table.insert( seq, count:num() )
	end
	return seq
end

local tests = {
	{
		name = 'counter exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'counter.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = 'counter.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = 'counter.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = 'counter.sequence (5)',
		func = testSequence,
		args = { 5 },
		expect = { { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5 } }
	},
}

return testframework.getTestProvider( tests )
