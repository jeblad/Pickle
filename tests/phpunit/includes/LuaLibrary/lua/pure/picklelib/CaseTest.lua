--- Tests for the case module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local extractors = require 'picklelib/Extractors'
assert( extractors )
local translators = require 'picklelib/Translators'
assert( extractors )
local subjects = require 'picklelib/Bag'
assert( subjects )
local reports = require 'picklelib/Bag'
assert( reports )

local name = 'case'
local class = 'Case'

local function makeCase( ... )
	local Case = require 'picklelib/Case'
	assert( Case )

	return Case:create( ... )
		:setSubjects( subjects:create() )
		:setReports( reports:create() )
		:setExtractors( extractors:create() )
		:setTranslators( translators:create() )
end

local function testExists()
	return type( makeCase() )
end

local function testCreate( ... )
	return type( makeCase( ... ) )
end

local function testClassCall( ... )
	local t = makeCase()( ... )
	return t:descriptions()
end

local function testClassCallStrings()
	local t = makeCase() 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testInstanceCall( ... )
	local obj = makeCase()
	local t = obj( ... )
	return t:descriptions()
end

local function testInstanceCallStrings()
	local obj = makeCase()
	local t = obj 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testDispatch( ... )
	local obj = makeCase()
	obj:dispatch( ... )
	return obj:numDescriptions(), obj:numFixtures(), obj:subjects():depth()
end

local function testEval( libs, ... )
	local obj = makeCase( ... )
	for _,v in ipairs( libs ) do
--		assert( v )
		obj:extractors():register( require( v ):create() )
	end
	local result = {}
	obj:dispatch( ... )
	obj:eval()
	for _,v in ipairs( { obj:reports():export() } ) do
		assert( v )
		if v:hasDescription() then
			table.insert( result, v:getDescription() )
		end
		local msg1 = v:getSkip() or v:getTodo()
		msg1 = ( type( msg1 ) == 'table' ) and msg1 or mw.message.newRawMessage( msg1 or '<empty>' )
		table.insert( result, msg1:inLanguage('qqx'):plain() )
		if not not v['constituents'] then
			for _,w in ipairs( { v:constituents():export() } ) do
				local msg2 = w:getSkip() or w:getTodo()
				msg2 = ( type( msg2 ) == 'table' ) and msg2 or mw.message.newRawMessage( msg2 or '<empty>' )
				table.insert( result, msg2:inLanguage('qqx'):plain() )
				table.insert( result, { w:lines():export() } )
			end
		end
	end
	obj:extractors():flush()
	return unpack( result )
end

local function testRef( ref, ... )
	local obj = makeCase()
	obj[ 'set' .. string.upper( string.sub( ref, 1, 1 ) ) .. string.sub( ref, 2 ) ]( obj, ... )
	return obj[ref]( obj )
end

local tests = {
	{ -- 1
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{ -- 2
		name = name .. ':create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{ -- 3
		name = name .. ':create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{ -- 4
		name = name .. ':create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{ -- 5
		name = class .. ':call (single value type)',
		func = testClassCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{ -- 6
		name = class .. ':call (multiple value type)',
		func = testClassCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{ -- 7
		name = class .. ':call (multiple strings)',
		func = testClassCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{ -- 8
		name = name .. ':call (single value type)',
		func = testInstanceCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{ -- 9
		name = name .. ':call (multiple value type)',
		func = testInstanceCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{ -- 10
		name = name .. ':call (multiple strings)',
		func = testInstanceCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{ -- 11
		name = name .. ':dispatch (no value)',
		func = testDispatch,
		args = { },
		expect = { 0, 0, 0 }
	},
	{ -- 12
		name = name .. ':dispatch (single string)',
		func = testDispatch,
		args = { 'foo' },
		expect = { 1, 0, 0 }
	},
	{ -- 13
		name = name .. ':dispatch (multiple string)',
		func = testDispatch,
		args = { 'foo', 'bar', 'baz' },
		expect = { 3, 0, 0 }
	},
	{ -- 14
		name = name .. ':dispatch (single function)',
		func = testDispatch,
		args = { function() return 'foo' end },
		expect = { 0, 1, 0 }
	},
	{ -- 15
		name = name .. ':dispatch (multiple functions)',
		func = testDispatch,
		args = {
			function() return 'foo' end,
			function() return 'bar' end,
			function() return 'baz' end
		},
		expect = { 0, 3, 0 }
	},
	{ -- 16
		name = name .. ':dispatch (single table)',
		func = testDispatch,
		args = { { 'foo' } },
		expect = { 0, 0, 1 }
	},
	{ -- 17
		name = name .. ':dispatch (multiple tables)',
		func = testDispatch,
		args = {
			{ 'foo' },
			{ 'bar' },
			{ 'baz' }
		},
		expect = { 0, 0, 3 }
	},
	{ -- 18
		name = name .. ':dispatch (string, function, table)',
		func = testDispatch,
		args = {
			'foo',
			function() return 'bar' end,
			{ 'baz' }
		},
		expect = { 1, 1, 1 }
	},
}

return testframework.getTestProvider( tests )
