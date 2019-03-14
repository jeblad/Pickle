--- Tests for the subject module.
-- This testset is only run when the Pickle extension is set up for implicit style.
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

if not _G.describe then
	return testframework.getTestProvider( {} )
end

_G.describe()

local function testExists()
	return type( mw.pickle )
end

local function testType( name ) -- luacheck: ignore
	local _type = type( _G[ name ] )
	return _type
end

local function testComment( name, ... )
	_G._reports:push( require( 'picklelib/report/FrameReport' ).create() )
	local res,_ = pcall( _G[ name ], ... )
	local report = _G._reports:pop()
	return res, report:getTodo(), report:getSkip()
end

local function testSpy( name, ... )
	local res,_ = pcall( _G[ name ], ... )
	return res, _G._reports:top():getTodo(), _G._reports:top():getSkip()
end

local function testSpyLines( name, idx, pattern, ... )
	local res,_ = pcall( _G[ name ], ... )
	local lines = {_G._reports:top():lines():export()} -- @note this is unpacked, but ends up as a table
	return res, string.match( lines[ idx ][1], pattern ) -- @todo lines are added separately
end

local tests = {
	-- PickleTest[1]
	{
		name = 'pickle exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	-- PickleTest[2]
	{
		name = 'table mw.describe',
		func = testType,
		args = { 'describe' },
		expect = { 'function' }
	},
	-- PickleTest[3]
	{
		name = 'table mw.context',
		func = testType,
		args = { 'context' },
		expect = { 'function' }
	},
	-- PickleTest[4]
	{
		name = 'table mw.it',
		func = testType,
		args = { 'it' },
		expect = { 'function' }
	},
	-- PickleTest[5]
	{
		name = 'table mw.subject',
		func = testType,
		args = { 'subject' },
		expect = { 'function' }
	},
	-- PickleTest[6]
	{
		name = 'table mw.expect',
		func = testType,
		args = { 'expect' },
		expect = { 'function' }
	},
	-- PickleTest[7]
	{
		name = 'table mw.carp',
		func = testType,
		args = { 'carp' },
		expect = { 'function' }
	},
	-- PickleTest[8]
	{
		name = 'table mw.carp',
		func = testType,
		args = { 'cluck' },
		expect = { 'function' }
	},
	-- PickleTest[9]
	{
		name = 'table mw.carp',
		func = testType,
		args = { 'confess' },
		expect = { 'function' }
	},
	-- PickleTest[10]
	{
		name = 'table mw.carp',
		func = testType,
		args = { 'croak' },
		expect = { 'function' }
	},
	-- PickleTest[11]
	{
		name = 'comment todo ()',
		func = testComment,
		args = { 'todo', 'foo bar baz' },
		expect = {
			true,
			'foo bar baz',
			false
		}
	},
	-- PickleTest[12]
	{
		name = 'comment skip ()',
		func = testComment,
		args = { 'skip', 'foo bar baz' },
		expect = {
			true,
			false,
			'foo bar baz'
		}
	},
	-- PickleTest[13]
	{
		name = 'carp todo ()',
		func = testSpy,
		args = { 'carp', 'foo bar baz' },
		expect = {
			true,
			'pickle-spies-carp-todo', -- @todo should this be 'foo bar baz'?
			false
		}
	},
	-- PickleTest[14]
	{
		name = 'cluck todo ()',
		func = testSpy,
		args = { 'cluck', 'foo bar baz' },
		expect = {
			true,
			'foo bar baz',
			false
		}
	},
	-- PickleTest[15]
	{
		name = 'croak()',
		func = testSpy,
		args = { 'croak', 'foo bar baz' },
		expect = {
			false,
			false,
			"foo bar baz"
		}
	},
	-- PickleTest[16]
	{
		name = 'confess()',
		func = testSpy,
		args = { 'confess', 'foo bar baz' },
		expect = {
			false,
			false,
			"foo bar baz"
		}
	},
	-- PickleTest[17]
	{
		name = 'lines (cluck)',
		func = testSpyLines,
		args = { 'cluck', 2, "/(%a+).lua.*'(.-)'" },
		expect = { true, 'Spy', 'traceback' }
	},
	-- PickleTest[18]
	{
		name = 'lines (confess)',
		func = testSpyLines,
		args = { 'confess', 2, "/(%a+).lua.*'(.-)'" },
		expect = { false, 'Spy', 'traceback' }
	},
}

return testframework.getTestProvider( tests )
