--- Tests for the subject module.
-- This testset is only run when the Pickle extension is set up for implicit style.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

--if not _G.describe then
--	return testframework.getTestProvider( {} )
--end

mw.pickle()

local function testExists()
	return type( mw.pickle )
end

local function testType( name )
	return type( _G[ name ] )
end

local function testMW( name )
	return type( _G.mw.pickle[ name ] )
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
		name = 'table mw.pickle.bag',
		func = testMW,
		args = { 'bag' },
		expect = { 'table' }
	},
	{
		name = 'table mw.pickle.counter',
		func = testMW,
		args = { 'counter' },
		expect = { 'table' }
	},
	-- PickleTest[3]
	{
		name = 'table mw.pickle.spy',
		func = testMW,
		args = { 'spy' },
		expect = { 'table' }
	},
	-- PickleTest[4]
	{
		name = 'table mw.pickle.frame',
		func = testMW,
		args = { 'frame' },
		expect = { 'table' }
	},
	-- PickleTest[5]
	{
		name = 'table mw.pickle.adapt',
		func = testMW,
		args = { 'adapt' },
		expect = { 'table' }
	},
	-- PickleTest[6]
	{
		name = 'table mw.pickle.double',
		func = testMW,
		args = { 'double' },
		expect = { 'table' }
	},
	-- PickleTest[7]
	{
		name = 'table mw.pickle.renders',
		func = testMW,
		args = { 'renders' },
		expect = { 'table' }
	},
	-- PickleTest[8]
	{
		name = 'table mw.pickle.extractors',
		func = testMW,
		args = { 'extractors' },
		expect = { 'table' }
	},
	-- PickleTest[9]
	{
		name = 'table mw.pickle.translators',
		func = testMW,
		args = { 'translators' },
		expect = { 'table' }
	},

	-- PickleTest[10]
	{
		name = 'table _reports',
		func = testType,
		args = { '_reports' },
		expect = { 'table' }
	},
	-- PickleTest[11]
	{
		name = 'table _renders',
		func = testType,
		args = { '_renders' },
		expect = { 'table' }
	},
	-- PickleTest[12]
	{
		name = 'table _extractors',
		func = testType,
		args = { '_extractors' },
		expect = { 'table' }
	},
	-- PickleTest[13]
	{
		name = 'table _translators',
		func = testType,
		args = { '_translators' },
		expect = { 'table' }
	},
	-- PickleTest[14]
	{
		name = 'boolean _PICKLE',
		func = testType,
		args = { '_PICKLE' },
		expect = { 'boolean' }
	},
	-- PickleTest[15]
	{
		name = 'function todo',
		func = testType,
		args = { 'todo' },
		expect = { 'function' }
	},
	-- PickleTest[16]
	{
		name = 'function skip',
		func = testType,
		args = { 'skip' },
		expect = { 'function' }
	},
	-- PickleTest[17]
	{
		name = 'function describe',
		func = testType,
		args = { 'describe' },
		expect = { 'function' }
	},
	-- PickleTest[18]
	{
		name = 'function context',
		func = testType,
		args = { 'context' },
		expect = { 'function' }
	},
	-- PickleTest[19]
	{
		name = 'function it',
		func = testType,
		args = { 'it' },
		expect = { 'function' }
	},
	-- PickleTest[20]
	{
		name = 'function subject',
		func = testType,
		args = { 'subject' },
		expect = { 'function' }
	},
	-- PickleTest[21]
	{
		name = 'function expect',
		func = testType,
		args = { 'expect' },
		expect = { 'function' }
	},
	-- PickleTest[22]
	{
		name = 'function carp',
		func = testType,
		args = { 'carp' },
		expect = { 'function' }
	},
	-- PickleTest[23]
	{
		name = 'function cluck',
		func = testType,
		args = { 'cluck' },
		expect = { 'function' }
	},
	-- PickleTest[24]
	{
		name = 'function croak',
		func = testType,
		args = { 'croak' },
		expect = { 'function' }
	},
	-- PickleTest[25]
	{
		name = 'function confess',
		func = testType,
		args = { 'confess' },
		expect = { 'function' }
	},
	-- PickleTest[26]
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
	-- PickleTest[27]
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
	-- PickleTest[28]
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
	-- PickleTest[29]
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
	-- PickleTest[30]
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
	-- PickleTest[31]
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
	-- PickleTest[32]
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
	-- PickleTest[33]
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
	-- PickleTest[34]
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
	-- PickleTest[35]
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
