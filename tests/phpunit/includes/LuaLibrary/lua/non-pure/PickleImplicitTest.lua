--- Tests for the subject module.
-- This testset is only run when the Pickle extension is set up for implicit style.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

if not _G.describe then
	return testframework.getTestProvider( {} )
end

_G.describe()

local function testExists()
	return type( mw.pickle )
end

local function testType( name )
	local _type = type( _G[ name ] )
	return _type
end

local function testComment( name, ... )
	_G._reports:push( require( 'picklelib/report/ReportFrame' ):create() )
	local res,_ = pcall( _G[ name ], ... )
	local report = _G._reports:pop()
	return res, report:getTodo(), report:getSkip()
end

local function testSpy( name, ... )
	local res,err = pcall( _G[ name ], ... )
	return res, not( res ) and err or 'none', _G._reports:top():getTodo() or _G._reports:top():getSkip()
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
		name = 'table mw.cluck',
		func = testType,
		args = { 'cluck' },
		expect = { 'function' }
	},
	-- PickleTest[9]
	{
		name = 'table mw.croak',
		func = testType,
		args = { 'croak' },
		expect = { 'function' }
	},
	-- PickleTest[10]
	{
		name = 'table mw.confess',
		func = testType,
		args = { 'confess' },
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
		name = 'carp ( nil )',
		func = testSpy,
		args = { 'carp', nil },
		expect = {
			true,
			'none',
			'Function “carp” called' -- @todo should this be 'pickle-spies-carp-todo'?
		}
	},
	-- PickleTest[14]
	{
		name = 'carp ( string )',
		func = testSpy,
		args = { 'carp', 'foo bar baz' },
		expect = {
			true,
			'none',
			'foo bar baz'
		}
	},
	-- PickleTest[15]
	{
		name = 'cluck ( nil )',
		func = testSpy,
		args = { 'cluck', nil },
		expect = {
			true,
			'none',
			'Function “cluck” called' -- @todo should this be 'pickle-spies-cluck-todo'?
		}
	},
	-- PickleTest[16]
	{
		name = 'cluck ( string )',
		func = testSpy,
		args = { 'cluck', 'foo bar baz' },
		expect = {
			true,
			'none',
			'foo bar baz'
		}
	},
	-- PickleTest[17]
	{
		name = 'croak ( nil )',
		func = testSpy,
		args = { 'croak', nil },
		expect = {
			false,
			'Function “croak” exits', -- @todo should this be 'pickle-spies-croak-skip'?
			'Function “croak” called'
		}
	},
	-- PickleTest[18]
	{
		name = 'croak ( string )',
		func = testSpy,
		args = { 'croak', 'foo bar baz' },
		expect = {
			false,
			'Function “croak” exits',
			'foo bar baz'
		}
	},
	-- PickleTest[19]
	{
		name = 'confess ( nil )',
		func = testSpy,
		args = { 'confess', nil },
		expect = {
			false,
			'Function “confess” exits', -- @todo should this be 'pickle-spies-confess-skip'?
			'Function “confess” called'
		}
	},
	-- PickleTest[20]
	{
		name = 'confess ( string )',
		func = testSpy,
		args = { 'confess', 'foo bar baz' },
		expect = {
			false,
			'Function “confess” exits',
			'foo bar baz'
		}
	},
}

return testframework.getTestProvider( tests )
