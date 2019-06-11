--- Tests for the frame module.
-- This is a preliminary solution.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local extractors = require 'picklelib/extractor/Extractors'
assert( extractors )
local translators = require 'picklelib/translator/Translators'
assert( extractors )
local subjects = require 'picklelib/Bag'
assert( subjects )
local reports = require 'picklelib/Bag'
assert( reports )

local name = 'frame'
local class = 'Frame'

local function makeFrame( ... )
	local Frame = require 'picklelib/engine/Frame'
	assert( Frame )

	return Frame:create( ... )
		:setSubjects( subjects:create() )
		:setReports( reports:create() )
		:setExtractors( extractors:create() )
		:setTranslators( translators:create() )
end

local function testExists()
	return type( makeFrame() )
end

local function testCreate( ... )
	return type( makeFrame( ... ) )
end

local function testClassCall( ... )
	local t = makeFrame()( ... )
	return t:descriptions()
end

local function testClassCallStrings()
	local t = makeFrame() 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testInstanceCall( ... )
	local obj = makeFrame()
	local t = obj( ... )
	return t:descriptions()
end

local function testInstanceCallStrings()
	local obj = makeFrame()
	local t = obj 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testDispatch( ... )
	local obj = makeFrame()
	obj:dispatch( ... )
	return obj:numDescriptions(), obj:numFixtures(), obj:subjects():depth()
end

local function testEval( libs, ... )
	local obj = makeFrame( ... )
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
		if v:isSkip() or v:isTodo() then
			table.insert( result, v:getSkip() or v:getTodo() )
		end
		if not not v['constituents'] then
			for _,w in ipairs( { v:constituents():export() } ) do
				table.insert( result, w:getSkip() or w:getTodo() or 'empty' )
				table.insert( result, { w:lines():export() } )
			end
		end
	end
	obj:extractors():flush()
	return unpack( result )
end

local function testRef( ref, ... )
	local obj = makeFrame()
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
	{ -- 19
		name = name .. ':eval (no string, no fixtures)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			}
		},
		expect = {
			'pickle-frame-no-fixtures'
		}
	},
	{ -- 20
		name = name .. ':eval (single string, no fixtures)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz'
		},
		expect = {
			'pickle-frame-no-fixtures'
		}
	},
	{ -- 21
		name = name .. ':eval (multiple string, no fixtures)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz',
			'ping 42 pong'
		},
		expect = {
			'pickle-frame-no-fixtures'
		}
	},
	{ -- 22
		name = name .. ':eval (no string, fixture with assertion)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			function() assert( false, 'go zip' ) end
		},
		expect = {
			'',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{ -- 23
		name = name .. ':eval (single string, fixture with assertion)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			function() assert( false, 'go zip' ) end
		},
		'foo "bar" baz',
		expect = {
			'',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{ -- 24
		name = name .. ':eval (multiple string, fixture with assertion)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz',
			'ping 42 pong',
			function() assert( false, 'go zip' ) end
		},
		expect = {
			'foo "bar" baz',
			'pickle-adapt-catched-exception',
			{},
			'ping 42 pong',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{ -- 25
		name = name .. ':eval (no string, empty fixture)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			function() end
		},
		expect = {
			'',
			'pickle-frame-no-tests'
		}
	},
	{ -- 26
		name = name .. ':eval (single string, empty fixture)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz',
			function() end
		},
		expect = {
			'foo "bar" baz',
			'pickle-frame-no-tests'
		}
	},
	{ -- 27
		name = name .. ':eval (multiple string, empty fixture)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz',
			'ping 42 pong',
			function() end
		},
		expect = {
			'foo "bar" baz',
			'pickle-frame-no-tests',
			'ping 42 pong',
			'pickle-frame-no-tests'
		}
	},
	{ -- 28
		name = name .. ':eval (no string, fixture with error)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			function() error( 'this is borken' ) end
		},
		expect = {
			'',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{ -- 29
		name = name .. ':eval (single string, fixture with error)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz',
			function() error( 'this is borken' ) end
		},
		expect = {
			'foo "bar" baz',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{ -- 30
		name = name .. ':eval (multiple string, fixture with error)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			"foo \"bar\" baz",
			'ping 42 pong',
			function() error( 'this is borken' ) end
		},
		expect = {
			'foo "bar" baz',
			'pickle-adapt-catched-exception',
			{},
			'ping 42 pong',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{ -- 31
		name = name .. ':evalSubject (no string, fixture push subject)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			-- pass as subject through return value
			function(...) return ... end
		},
		expect = {
			'',
			'pickle-frame-no-tests',
			'pickle-adapt-catched-return',
			{}
		}
	},
	{ -- 32
		name = name .. ':evalSubject (single string, fixture push subject)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz',
			-- pass as subject through return value
			function(...) return ... end
		},
		expect = {
			'foo "bar" baz',
			'pickle-frame-no-tests',
			'pickle-adapt-catched-return',
			{ { '"bar"' } }
		}
	},
	{ -- 33
		name = name .. ':evalSubject (multiple string, fixture push subject)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/ExtractorString",
				"picklelib/extractor/ExtractorNumber"
			},
			'foo "bar" baz',
			'ping 42 pong',
			-- pass as subject through return value
			function(...) return ... end
		},
		expect = {
			'foo "bar" baz',
			'pickle-frame-no-tests',
			'pickle-adapt-catched-return',
			{ { '"bar"' } },
			'ping 42 pong',
			'pickle-frame-no-tests',
			'pickle-adapt-catched-return',
			{ { '42' } },
		}
	},
--	{
--		name = name .. ':evalSubject (multiple string, fixture push subject)',
--	}
}

return testframework.getTestProvider( tests )
