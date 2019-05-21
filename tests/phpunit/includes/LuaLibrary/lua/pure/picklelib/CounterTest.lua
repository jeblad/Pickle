--- Tests for the counter module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local function makeCounter( ... )
	local counter = require 'picklelib/Counter'
	assert( counter )
	return counter:create( ... )
end

local function testExists()
	return type( makeCounter() )
end

local function testCreate( ... )
	return type( makeCounter( ... ) )
end

local function testIncSequence( len, init, num )
	local count = makeCounter( init )
	local seq = {}
	for _=1,len,1 do
		table.insert( seq, count:inc( num ) )
	end
	return seq
end

local function testDecSequence( len, init, num )
	local count = makeCounter( init )
	local seq = {}
	for _=1,len,1 do
		table.insert( seq, count:dec( num ) )
	end
	return seq
end

local function testCallSequence( len, init, num )
	local count = makeCounter( init )
	local seq = {}
	for _=1,len,1 do
		table.insert( seq, count( num ) )
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
		name = 'counter:create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = 'counter:create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = 'counter:create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = 'counter.inc-sequence (5)',
		func = testIncSequence,
		args = { 5 },
		expect = { { 1, 2, 3, 4, 5 } }
	},
	{
		name = 'counter.inc-sequence (5, 1)',
		func = testIncSequence,
		args = { 5, 1 },
		expect = { { 2, 3, 4, 5, 6 } }
	},
	{
		name = 'counter.inc-sequence (5, 1, 2)',
		func = testIncSequence,
		args = { 5, 1, 2 },
		expect = { { 3, 5, 7, 9, 11 } }
	},
	{
		name = 'counter.dec-sequence (5)',
		func = testDecSequence,
		args = { 5 },
		expect = { { -1, -2, -3, -4, -5 } }
	},
	{
		name = 'counter.dec-sequence (5, 1)',
		func = testDecSequence,
		args = { 5, -1 },
		expect = { { -2, -3, -4, -5, -6 } }
	},
	{
		name = 'counter.dec-sequence (5, 1, 2)',
		func = testDecSequence,
		args = { 5, -1, 2 },
		expect = { { -3, -5, -7, -9, -11 } }
	},
	{
		name = 'counter.dec-sequence (5, 1, -2)',
		func = testDecSequence,
		args = { 5, -1, -2 },
		expect = { { -3, -5, -7, -9, -11 } }
	},
	{
		name = 'counter.call-sequence (5)',
		func = testCallSequence,
		args = { 5 },
		expect = { { 0, 1, 2, 3, 4 } }
	},
	{
		name = 'counter.call-sequence (5, 1)',
		func = testCallSequence,
		args = { 5, 1 },
		expect = { { 1, 2, 3, 4, 5 } }
	},
	{
		name = 'counter.call-sequence (5, 1, 2)',
		func = testCallSequence,
		args = { 5, 1, 2 },
		expect = { { 1, 3, 5, 7, 9 } }
	},
	{
		name = 'counter.call-sequence (5, 1, -2)',
		func = testCallSequence,
		args = { 5, 1, -2 },
		expect = { { 1, -1, -3, -5, -7 } }
	},
}

return testframework.getTestProvider( tests )
