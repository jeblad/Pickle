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

local function testFrame( name, ... )
	_G._reports:push( require( 'picklelib/report/ReportFrame' ):create() )
	local res1, obj1 = pcall( _G[ name ], ... )
	if not res1 then
		return res1, obj1, 'first pcall'
	end
	local res2, obj2 = pcall( function() obj1:eval() end )
	if not res2 then
		return res2, obj2, 'second pcall'
	end
	local report = _G._reports:top()
	return res1 and res2, report:isOk(), report:isTodo(), report:isSkip()
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
	-- PickleTest[3]
	{
		name = 'table mw.pickle.counter',
		func = testMW,
		args = { 'counter' },
		expect = { 'table' }
	},
	-- PickleTest[4]
	{
		name = 'table mw.pickle.spy',
		func = testMW,
		args = { 'spy' },
		expect = { 'table' }
	},
	-- PickleTest[5]
	{
		name = 'table mw.pickle.frame',
		func = testMW,
		args = { 'frame' },
		expect = { 'table' }
	},
	-- PickleTest[6]
	{
		name = 'table mw.pickle.adapt',
		func = testMW,
		args = { 'adapt' },
		expect = { 'table' }
	},
	-- PickleTest[7]
	{
		name = 'table mw.pickle.double',
		func = testMW,
		args = { 'double' },
		expect = { 'table' }
	},
	-- PickleTest[8]
	{
		name = 'table mw.pickle.renders',
		func = testMW,
		args = { 'renders' },
		expect = { 'table' }
	},
	-- PickleTest[9]
	{
		name = 'table mw.pickle.extractors',
		func = testMW,
		args = { 'extractors' },
		expect = { 'table' }
	},
	-- PickleTest[10]
	{
		name = 'table mw.pickle.translators',
		func = testMW,
		args = { 'translators' },
		expect = { 'table' }
	},

	-- PickleTest[11]
	{
		name = 'table _reports',
		func = testType,
		args = { '_reports' },
		expect = { 'table' }
	},
	-- PickleTest[12]
	{
		name = 'table _renders',
		func = testType,
		args = { '_renders' },
		expect = { 'table' }
	},
	-- PickleTest[13]
	{
		name = 'table _extractors',
		func = testType,
		args = { '_extractors' },
		expect = { 'table' }
	},
	-- PickleTest[14]
	{
		name = 'table _translators',
		func = testType,
		args = { '_translators' },
		expect = { 'table' }
	},
	-- PickleTest[15]
	{
		name = 'boolean _PICKLE',
		func = testType,
		args = { '_PICKLE' },
		expect = { 'boolean' }
	},
	-- PickleTest[16]
	{
		name = 'function todo',
		func = testType,
		args = { 'todo' },
		expect = { 'function' }
	},
	-- PickleTest[17]
	{
		name = 'function skip',
		func = testType,
		args = { 'skip' },
		expect = { 'function' }
	},
	-- PickleTest[18]
	{
		name = 'function xdescribe',
		func = testType,
		args = { 'xdescribe' },
		expect = { 'function' }
	},
	-- PickleTest[19]
	{
		name = 'function xdescribe',
		func = testFrame,
		args = { 'xdescribe' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[20]
	{
		name = 'function xdescribe',
		func = testFrame,
		args = { 'xdescribe', 'This is a test' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[21]
	{
		name = 'function xdescribe',
		func = testFrame,
		args = { 'xdescribe', 'This is a test', function() end },
		expect = { true, true, false, true } -- skip, override eval
	},
	-- PickleTest[22]
	{
		name = 'function xcontext',
		func = testType,
		args = { 'xcontext' },
		expect = { 'function' }
	},
	-- PickleTest[23]
	{
		name = 'function xcontext',
		func = testFrame,
		args = { 'xcontext' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[24]
	{
		name = 'function xcontext',
		func = testFrame,
		args = { 'xcontext', 'This is a test' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[25]
	{
		name = 'function xcontext',
		func = testFrame,
		args = { 'xcontext', 'This is a test', function() end },
		expect = { true, true, false, true } -- skip, override eval
	},
	-- PickleTest[26]
	{
		name = 'function xit',
		func = testType,
		args = { 'xit' },
		expect = { 'function' }
	},
	-- PickleTest[27]
	{
		name = 'function xit',
		func = testFrame,
		args = { 'xit' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[28]
	{
		name = 'function xit',
		func = testFrame,
		args = { 'xit', 'This is a test' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[29]
	{
		name = 'function xit',
		func = testFrame,
		args = { 'xit', 'This is a test', function() end },
		expect = { true, true, false, true } -- skip, override eval
	},
	-- PickleTest[30]
	{
		name = 'function describe',
		func = testType,
		args = { 'describe' },
		expect = { 'function' }
	},
	-- PickleTest[31]
	{
		name = 'function describe',
		func = testFrame,
		args = { 'describe' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[32]
	{
		name = 'function describe',
		func = testFrame,
		args = { 'describe', 'This is a test' },
		expect = { true, true, true, false } -- todo, still no fixture
	},
	-- PickleTest[33]
	{
		name = 'function describe',
		func = testFrame,
		args = { 'describe', 'This is a test', function() end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[33]
	{
		name = 'function describe',
		func = testFrame,
		args = { 'describe', 'This is a test', function() return true end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[34]
	{
		name = 'function context',
		func = testType,
		args = { 'context' },
		expect = { 'function' }
	},
	-- PickleTest[35]
	{
		name = 'function context',
		func = testFrame,
		args = { 'context' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[36]
	{
		name = 'function context',
		func = testFrame,
		args = { 'context', 'This is a test' },
		expect = { true, true, true, false } -- todo, still no fixture
	},
	-- PickleTest[37]
	{
		name = 'function context',
		func = testFrame,
		args = { 'context', 'This is a test', function() end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[38]
	{
		name = 'function context',
		func = testFrame,
		args = { 'context', 'This is a test', function() return true end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[39]
	{
		name = 'function it',
		func = testType,
		args = { 'it' },
		expect = { 'function' }
	},
	-- PickleTest[40]
	{
		name = 'function it',
		func = testFrame,
		args = { 'it' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[41]
	{
		name = 'function it',
		func = testFrame,
		args = { 'it', 'This is a test' },
		expect = { true, true, true, false } -- todo, still no fixture
	},
	-- PickleTest[42]
	{
		name = 'function it',
		func = testFrame,
		args = { 'it', 'This is a test', function() end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[43]
	{
		name = 'function it',
		func = testFrame,
		args = { 'it', 'This is a test', function() return true end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[44]
	{
		name = 'function subject',
		func = testType,
		args = { 'subject' },
		expect = { 'function' }
	},
	-- PickleTest[45]
	{
		name = 'function expect',
		func = testType,
		args = { 'expect' },
		expect = { 'function' }
	},
	-- PickleTest[46]
	{
		name = 'function carp',
		func = testType,
		args = { 'carp' },
		expect = { 'function' }
	},
	-- PickleTest[47]
	{
		name = 'function cluck',
		func = testType,
		args = { 'cluck' },
		expect = { 'function' }
	},
	-- PickleTest[48]
	{
		name = 'function croak',
		func = testType,
		args = { 'croak' },
		expect = { 'function' }
	},
	-- PickleTest[49]
	{
		name = 'function confess',
		func = testType,
		args = { 'confess' },
		expect = { 'function' }
	},
	-- PickleTest[50]
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
	-- PickleTest[51]
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
	-- PickleTest[52]
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
	-- PickleTest[53]
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
	-- PickleTest[54]
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
	-- PickleTest[55]
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
	-- PickleTest[56]
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
	-- PickleTest[57]
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
	-- PickleTest[58]
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
	-- PickleTest[59]
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
