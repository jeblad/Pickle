--- Tests for the frame module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local extractors = require 'picklelib/extractor/ExtractorStrategies'
local Frame = require 'picklelib/engine/Frame'
local subjects = require 'picklelib/Stack'
local reports = require 'picklelib/Stack'
local name = 'frame'
local class = 'Frame'

local function makeFrame( ... )
	return Frame.create( ... )
		:setSubjects( subjects.create() )
		:setReports( reports.create() )
		:setExtractors( extractors.create() )
end

local function testExists()
	return type( Frame )
end

local function testCreate( ... )
	return type( makeFrame( ... ) )
end

local function testClassCall( ... )
	local t = Frame( ... )
	return t:descriptions()
end

local function testClassCallStrings()
	local t = Frame 'foo' 'bar' 'baz'
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
		obj:extractors():register( require( v ).create() )
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

local tests = {
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = class .. '.call (single value type)',
		func = testClassCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = class .. '.call (multiple value type)',
		func = testClassCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{
		name = class .. '.call (multiple strings)',
		func = testClassCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.call (single value type)',
		func = testInstanceCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = name .. '.call (multiple value type)',
		func = testInstanceCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{
		name = name .. '.call (multiple strings)',
		func = testInstanceCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.dispatch (no value)',
		func = testDispatch,
		args = { },
		expect = { 0, 0, 0 }
	},
	{
		name = name .. '.dispatch (single string)',
		func = testDispatch,
		args = { 'foo' },
		expect = { 1, 0, 0 }
	},
	{
		name = name .. '.dispatch (multiple string)',
		func = testDispatch,
		args = { 'foo', 'bar', 'baz' },
		expect = { 3, 0, 0 }
	},
	{
		name = name .. '.dispatch (single function)',
		func = testDispatch,
		args = { function() return 'foo' end },
		expect = { 0, 1, 0 }
	},
	{
		name = name .. '.dispatch (multiple functions)',
		func = testDispatch,
		args = {
			function() return 'foo' end,
			function() return 'bar' end,
			function() return 'baz' end
		},
		expect = { 0, 3, 0 }
	},
	{
		name = name .. '.dispatch (single table)',
		func = testDispatch,
		args = { { 'foo' } },
		expect = { 0, 0, 1 }
	},
	{
		name = name .. '.dispatch (multiple tables)',
		func = testDispatch,
		args = {
			{ 'foo' },
			{ 'bar' },
			{ 'baz' }
		},
		expect = { 0, 0, 3 }
	},
	{
		name = name .. '.dispatch (string, function, table)',
		func = testDispatch,
		args = {
			'foo',
			function() return 'bar' end,
			{ 'baz' }
		},
		expect = { 1, 1, 1 }
	},
	{
		name = name .. '.eval (no string, no fixtures)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			}
		},
		expect = {
			'pickle-frame-no-fixtures'
		}
	},
	{
		name = name .. '.eval (single string, no fixtures)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			'foo "bar" baz'
		},
		expect = {
			'pickle-frame-no-fixtures'
		}
	},
	{
		name = name .. '.eval (multiple string, no fixtures)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			'foo "bar" baz',
			'ping 42 pong'
		},
		expect = {
			'pickle-frame-no-fixtures'
		}
	},
	{
		name = name .. '.eval (no string, fixture with assertion)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			function() assert( false, 'go zip' ) end
		},
		expect = {
			'pickle-frame-no-description',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{
		name = name .. '.eval (single string, fixture with assertion)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			function() assert( false, 'go zip' ) end
		},
		'foo "bar" baz',
		expect = {
			'pickle-frame-no-description',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{
		name = name .. '.eval (multiple string, fixture with assertion)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
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
	{
		name = name .. '.eval (no string, empty fixture)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			function() end
		},
		expect = {
			'pickle-frame-no-description',
			'pickle-frame-no-tests'
		}
	},
	{
		name = name .. '.eval (single string, empty fixture)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			'foo "bar" baz',
			function() end
		},
		expect = {
			'foo "bar" baz',
			'pickle-frame-no-tests'
		}
	},
	{
		name = name .. '.eval (multiple string, empty fixture)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
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
	{
		name = name .. '.eval (no string, fixture with error)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			function() error( 'this is borken' ) end
		},
		expect = {
			'pickle-frame-no-description',
			'pickle-adapt-catched-exception',
			{}
		}
	},
	{
		name = name .. '.eval (single string, fixture with error)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
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
	{
		name = name .. '.eval (multiple string, fixture with error)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
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
	{
		name = name .. '.evalSubject (no string, fixture push subject)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			-- pass as subject through return value
			function(...) return ... end
		},
		expect = {
			'pickle-frame-no-description',
			'pickle-frame-no-tests',
			'pickle-adapt-catched-return',
			{}
		}
	},
	{
		name = name .. '.evalSubject (single string, fixture push subject)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
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
	{
		name = name .. '.evalSubject (multiple string, fixture push subject)',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
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
}

return testframework.getTestProvider( tests )
