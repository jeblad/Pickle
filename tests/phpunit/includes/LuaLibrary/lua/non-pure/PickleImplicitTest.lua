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

local function testExtract( str )
	local t = {}
	local pos = 1

	repeat
		local strategy, first, last = _G._extractors:find( str, pos )
		if strategy then
			local part = mw.ustring.sub( str, first, last )
			table.insert( t, {
				strategy:placeholder(),
				type( strategy:cast( part ) ),
				strategy:cast( part ),
				first,
				last } )
			pos = last + 1
		end
	until( not strategy )

	return unpack( t )
end

local function testComment( name, ... )
	_G._reports:push( require( 'picklelib/report/ReportCase' ):create() )
	local res,_ = pcall( _G[ name ], ... )
	local report = _G._reports:pop()
	return res, report:getTodo(), report:getSkip()
end

local function testSpy( name, ... )
	local res,err = pcall( _G[ name ], ... )
	return res, not( res ) and err or 'none', _G._reports:top():getTodo() or _G._reports:top():getSkip()
end

local function testCase( name, ... )
	_G._reports:push( require( 'picklelib/report/ReportCase' ):create() )
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
		name = 'table mw.pickle.case',
		func = testMW,
		args = { 'case' },
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
		func = testCase,
		args = { 'xdescribe' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[20]
	{
		name = 'function xdescribe',
		func = testCase,
		args = { 'xdescribe', 'This is a test' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[21]
	{
		name = 'function xdescribe',
		func = testCase,
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
		func = testCase,
		args = { 'xcontext' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[24]
	{
		name = 'function xcontext',
		func = testCase,
		args = { 'xcontext', 'This is a test' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[25]
	{
		name = 'function xcontext',
		func = testCase,
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
		func = testCase,
		args = { 'xit' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[28]
	{
		name = 'function xit',
		func = testCase,
		args = { 'xit', 'This is a test' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[29]
	{
		name = 'function xit',
		func = testCase,
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
		func = testCase,
		args = { 'describe' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[32]
	{
		name = 'function describe',
		func = testCase,
		args = { 'describe', 'This is a test' },
		expect = { true, true, true, false } -- todo, still no fixture
	},
	-- PickleTest[33]
	{
		name = 'function describe',
		func = testCase,
		args = { 'describe', 'This is a test', function() end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[34]
	{
		name = 'function describe',
		func = testCase,
		args = { 'describe', 'This is a test', function() return true end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[35]
	{
		name = 'function context',
		func = testType,
		args = { 'context' },
		expect = { 'function' }
	},
	-- PickleTest[36]
	{
		name = 'function context',
		func = testCase,
		args = { 'context' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[37]
	{
		name = 'function context',
		func = testCase,
		args = { 'context', 'This is a test' },
		expect = { true, true, true, false } -- todo, still no fixture
	},
	-- PickleTest[38]
	{
		name = 'function context',
		func = testCase,
		args = { 'context', 'This is a test', function() end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[39]
	{
		name = 'function context',
		func = testCase,
		args = { 'context', 'This is a test', function() return true end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[40]
	{
		name = 'function it',
		func = testType,
		args = { 'it' },
		expect = { 'function' }
	},
	-- PickleTest[41]
	{
		name = 'function it',
		func = testCase,
		args = { 'it' },
		expect = { true, true, true, false } -- todo, no fixture
	},
	-- PickleTest[42]
	{
		name = 'function it',
		func = testCase,
		args = { 'it', 'This is a test' },
		expect = { true, true, true, false } -- todo, still no fixture
	},
	-- PickleTest[43]
	{
		name = 'function it',
		func = testCase,
		args = { 'it', 'This is a test', function() end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[44]
	{
		name = 'function it',
		func = testCase,
		args = { 'it', 'This is a test', function() return true end },
		expect = { true, true, true, false } -- todo, no assertions
	},
	-- PickleTest[45]
	{
		name = 'function subject',
		func = testType,
		args = { 'subject' },
		expect = { 'function' }
	},
	-- PickleTest[46]
	{
		name = 'function expect',
		func = testType,
		args = { 'expect' },
		expect = { 'function' }
	},
	-- PickleTest[47]
	{
		name = 'function carp',
		func = testType,
		args = { 'carp' },
		expect = { 'function' }
	},
	-- PickleTest[48]
	{
		name = 'function cluck',
		func = testType,
		args = { 'cluck' },
		expect = { 'function' }
	},
	-- PickleTest[49]
	{
		name = 'function croak',
		func = testType,
		args = { 'croak' },
		expect = { 'function' }
	},
	-- PickleTest[50]
	{
		name = 'function confess',
		func = testType,
		args = { 'confess' },
		expect = { 'function' }
	},
	-- PickleTest[51]
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
	-- PickleTest[52]
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
	-- PickleTest[53]
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
	-- PickleTest[54]
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
	-- PickleTest[55]
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
	-- PickleTest[56]
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
	-- PickleTest[57]
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
	-- PickleTest[58]
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
	-- PickleTest[59]
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
	-- PickleTest[60]
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
	-- PickleTest[61]
	{
		name = 'extractor ( nil )',
		func = testExtract,
		args = { 'nil foo Nil bar NIL' },
		expect = {
			{ '[nil]', 'nil', nil, 1, 3 },
			{ '[nil]', 'nil', nil, 9, 11 },
			{ '[nil]', 'nil', nil, 17, 19 },
		}
	},
	-- PickleTest[62]
	{
		name = 'extractor ( false )',
		func = testExtract,
		args = { 'false foo False bar FALSE' },
		expect = {
			{ '[false]', 'boolean', false, 1, 5 },
			{ '[false]', 'boolean', false, 11, 15 },
			{ '[false]', 'boolean', false, 21, 25 },
		}
	},
	-- PickleTest[63]
	{
		name = 'extractor ( true )',
		func = testExtract,
		args = { 'true foo True bar TRUE' },
		expect = {
			{ '[true]', 'boolean', true, 1, 4 },
			{ '[true]', 'boolean', true, 10, 13 },
			{ '[true]', 'boolean', true, 19, 22 },
		}
	},
	-- PickleTest[64]
	{
		name = 'extractor ( number )',
		func = testExtract,
		args = { '3.14 foo 42 bar -42 baz -3.14' },
		expect = {
			{ '[number]', 'number', 3.14, 1, 4 },
			{ '[number]', 'number', 42, 10, 11 },
			{ '[number]', 'number', -42, 17, 19 },
			{ '[number]', 'number', -3.14, 25, 29 },
		}
	},
	-- PickleTest[65]
	{
		name = 'extractor ( string )',
		func = testExtract,
		args = { '"ping" foo "pong" bar "zong"' },
		expect = {
			{ '[string]', 'string', "ping", 1, 6 },
			{ '[string]', 'string', "pong", 12, 17 },
			{ '[string]', 'string', "zong", 23, 28 },
		}
	},
	-- PickleTest[66]
	{
		name = 'extractor ( json )',
		func = testExtract,
		args = { '{"ping":1} foo ["pong"] bar {"zong":2}' },
		expect = {
			{ '[json]', 'table', {["ping"]=1}, 1, 10 },
			{ '[json]', 'table', {"pong"}, 16, 23 },
			{ '[json]', 'table', {["zong"]=2}, 29, 38 },
		}
	},
	-- PickleTest[67]
	{
		name = 'extractor ( composite )',
		func = testExtract,
		args = { 'true foo -42 bar false baz nil fup "ping" fap ["pong"]' },
		expect = {
			{ '[true]', 'boolean', true, 1, 4 },
			{ '[number]', 'number', -42, 10, 12 },
			{ '[false]', 'boolean', false, 18, 22 },
			{ '[nil]', 'nil', nil, 28, 30 },
			{ '[string]', 'string', "ping", 36, 41 },
			{ '[json]', 'table', {"pong"}, 47, 54 },
		}
	},
}

return testframework.getTestProvider( tests )
