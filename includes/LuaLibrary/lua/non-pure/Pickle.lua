-- accesspoints for the bilerplate
local php		-- luacheck: ignore
local options	-- luacheck: ignore

-- @var structure for storage of the lib
local pickle = {}
pickle._types = {}
pickle._styles = {}
pickle._extractors = {}

--- Describe the test
-- This act as an alias for the normal describe,
-- which is not available.
-- This does implicitt setup.
-- @param vararg passed on to expect.create
-- @return self newly created object
function pickle.describe( ... )
	-- require libs and create an instance
	local reports = require( 'picklelib/Stack' ).create()
	local expects = require( 'picklelib/Stack' ).create()
	local subjects = require( 'picklelib/Stack' ).create()
	local extractors = require( 'picklelib/extractor/ExtractorStrategies' ).create()

	-- only require libs
	local Expect = require 'picklelib/engine/Expect'
	local Subject = require 'picklelib/engine/Subject'
	local Frame = require 'picklelib/engine/Frame'
	local Spies = require 'picklelib/engine/Spies'
	local renders  = require 'picklelib/render/Renders'

	-- register render styles
	for k,v in pairs( mw.pickle._styles ) do
		local style = pickle.renders:registerStyle( k )
		for l,w in pairs( mw.pickle._types ) do
			style:registerType( l, require( v .. '/' .. w ) )
		end
	end

	-- register extractor types
	for _,v in ipairs( mw.pickle._extractors ) do
		extractors:register( require( v ).create() )
	end

	-- create the access to other parties
	-- @todo should probably be replaced
	function Expect.other()
		return Subject -- luacheck: globals Subject
	end
	function Subject.other()
		return Expect -- luacheck: globals Expect
	end

	--- Expect whatever to be compared to the subject
	-- The expected value is the assumed outcome,
	-- or something that can be transformed into the
	-- assumed outcome.
	-- @param vararg passed on to expect.create
	-- @return self newly created object
	function _G.expect( ... )
		local obj = Expect.create( ... )
			:setReports( reports )
			:setExpects( expects )
		return obj
	end

	--- Subject of whatever to be compared to the expected
	-- The subject is whatever object we want to test,
	-- usually the returned table for a module.
	-- @param vararg passed on to expect.create
	-- @return self newly created object
	function _G.subject( ... )
		local obj = Subject.create( ... )
			:setReports( reports )
			:setSubjects( subjects )
		return obj
	end

	--- Context for the test
	-- This is usually used for creating some additional context
	-- before the actual testing. An alternate would be to use
	-- 'before' and 'after' functions.
	-- @param vararg passed on to expect.create
	-- @return self newly created object
	function _G.context( ... )
		local obj = Frame.create( ... )
			:setExtractors( extractors )
			:setReports( reports )
			:setSubjects( subjects )
		return obj
	end

	--- It is the actual test for each metod
	-- @param vararg passed on to expect.create
	-- @return self newly created object
	_G['it'] = _G['context']

	--- Carp, warn called due to a possible error condition
	-- Print a message without exiting, with caller's name and arguments.
	-- @param string message to be passed on
	function _G.carp( str )
		local report = Spies.todo( 'todo', 'pickle-spies-carp-todo', str )
		reports:push( report )
	end

	--- Cluck, warn called due to a possible error condition, with a stack backtrace
	-- Print a message without exiting, with caller's name and arguments, and a stack trace.
	-- @param string message to be passed on
	function Spies.cluck( str )
		local report = Spies.todo( 'pickle-spies-cluck-todo', str )
		Spies.traceback( report )
		reports:push( report )
	end

	--- Croak, die called due to a possible error condition
	-- Print a message then exits, with caller's name and arguments.
	-- @exception error called unconditionally
	-- @param string message to be passed on
	function Spies.croak( str )
		local report = Spies.skip( 'pickle-spies-croak-skip', str )
		reports:push( report )
		error( mw.message.new( 'pickle-spies-croak-exits' ) )
	end

	--- Confess, die called due to a possible error condition, with astack backtrace
	-- Print a message then exits, with caller's name and arguments, and a stack trace.
	-- @exception error called unconditionally
	-- @param string message to be passed on
	function Spies.confess( str )
		local report = Spies.skip( 'pickle-spies-confess-skip', str )
		Spies.traceback( report )
		reports:push( report )
		error( mw.message.new( 'pickle-spies-confess-exits' ) )
	end

	-- then do what we should do
	local obj = Frame.create( ... )
		:setRenders( renders )
		:setReports( reports )
		:setSubjects( subjects )

	return obj
end

--- install the module in the global space
function pickle.setupInterface( opts )

	-- boilerplate
	pickle.setupInterface = nil
	php = mw_interface -- luacheck: globals mw_interface
	mw_interface = nil -- luacheck: globals mw_interface
	options = opts

	-- register main lib
	mw = mw or {}
	mw.pickle = pickle
	package.loaded['mw.Pickle'] = pickle

	-- keep render styles for later, newer mind requiring them now
	for k,v in pairs( opts.renderStyles ) do
		pickle._styles[k] = v
	end

	-- keep render types for later, newer mind requiring them now
	for k,v in pairs( opts.renderTypes ) do
		pickle._types[k] = v
	end

	-- keep extractors for later, newer mind requiring them now
	for i,v in ipairs( opts.extractorStrategies ) do
		pickle._extractors[i] = v
	end

end

-- Return the final library
return pickle
