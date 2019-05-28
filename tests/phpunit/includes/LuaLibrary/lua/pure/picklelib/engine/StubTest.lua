--- Tests for the Spy module.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local function makeStub( ... )
	local stub = require 'picklelib/engine/Stub'
	assert( stub )
	return stub( ... )
end

local function testExists()
	return type( makeStub() )
end

local function testPlayback( ... )
	local stubb = makeStub( ... )
	local t = {}
	-- force the loop to be one more than the number of frames
	for _=1,1+select( '#', ... ) do
		local r,v = pcall( function() return { stubb() } end )
		table.insert( t, r and v or 'raise' )
	end
	return unpack( t )
end

local tests = {
	{ -- 1
		name = 'stub exists',
		func = testExists,
		type = 'ToString',
		expect = { 'function' }
	},
	{
		name = 'Stub.call (no frame)',
		func = testPlayback,
		args = { },
		expect = { 'raise' }
	},
	{
		name = 'Stub.call (single frame)',
		func = testPlayback,
		args = { {'a'} },
		expect = { { 'a' }, 'raise' }
	},
	{
		name = 'Stub.call (dual frame)',
		func = testPlayback,
		args = { { 'a' }, { 'b' } },
		expect = { { 'a' }, { 'b' }, 'raise' }
	},
}

return testframework.getTestProvider( tests )
