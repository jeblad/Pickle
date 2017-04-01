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
-- @param vararg passed on to Adapt.create
-- @return self newly created object
function pickle.describe( ... )
	-- require libs and create an instance
	local expects = require( 'picklelib/Stack' ).create()
	local subjects = require( 'picklelib/Stack' ).create()
	local extractors = require( 'picklelib/extractor/ExtractorStrategies' ).create()

	-- only require libs
	local Spy = require( 'picklelib/engine/Spy' )
	local Adapt = require 'picklelib/engine/Adapt'
	local Frame = require 'picklelib/engine/Frame'

	-- not a real instance of a class
	-- @todo this should probably be reimplemented, it missuses weird behavior in Lua
	local renders = require 'picklelib/render/Renders'

	--Get the environment for installation of our access points
	local ret,env = pcall( function() return getfenv( 4 ) end )
	if not ret then
		env = _G
	end

	-- this is mainly needed for testing purposes
	local reports = require( 'picklelib/Stack' ).create()
	env._reports = reports

	-- register render styles
	for k,v in pairs( mw.pickle._styles ) do
		local style = renders.registerStyle( k )
		for l,w in pairs( mw.pickle._types ) do
			style:registerType( l, require( v .. '/' .. w ) )
		end
	end

	-- register extractor types
	for _,v in ipairs( mw.pickle._extractors ) do
		extractors:register( require( v ).create() )
	end

	--- Expect whatever to be compared to the subject
	-- The expected value is the assumed outcome,
	-- or something that can be transformed into the
	-- assumed outcome.
	-- @param vararg passed on to Adapt.create
	-- @return self newly created object
	env.expect = function( ... )
		local obj = Adapt.create( ... )
			:setReports( reports )
			:setAdaptations( expects )
		return obj
	end

	--- Subject of whatever to be compared to the expected
	-- The subject is whatever object we want to test,
	-- usually the returned table for a module.
	-- @param vararg passed on to Adapt.create
	-- @return self newly created object
	env.subject = function( ... )
		local obj = Adapt.create( ... )
			:setReports( reports )
			:setSubjects( subjects )
		return obj
	end

	-- create the access to other parties
	-- @todo should probably be replaced
	--[[
	function env.expect.other()
		return env.subject -- luacheck: globals Subject
	end
	function env.subject.other()
		return env.expect -- luacheck: globals Expect
	end
]]
	--- Context for the test
	-- This is usually used for creating some additional context
	-- before the actual testing. An alternate would be to use
	-- 'before' and 'after' functions.
	-- @param vararg passed on to Adapt.create
	-- @return self newly created object
	env.context = function( ... )
		local obj = Frame.create()
			:setExtractors( extractors )
			:setReports( reports )
			:setSubjects( subjects )
			:dispatch( ... )
		return obj
	end

	--- It is the actual test for each metod
	-- @param vararg passed on to Adapt.create
	-- @return self newly created object
	env.it = env.context

	--- Carp, warn called due to a possible error condition
	-- Print a message without exiting, with caller's name and arguments.
	-- @param string message to be passed on
	env.carp = function( str )
		local obj = Spy.create():setReports( reports )
		obj:todo( 'todo', 'pickle-spies-carp-todo', str ) -- @todo not sure why this must use 'obj'
		obj:reports():push( obj:report() )
		return obj
	end

	--- Cluck, warn called due to a possible error condition, with a stack backtrace
	-- Print a message without exiting, with caller's name and arguments, and a stack trace.
	-- @param string message to be passed on
	env.cluck = function( str )
		local obj = Spy.create():setReports( reports )
		obj:todo( 'pickle-spies-cluck-todo', str )
		obj:traceback()
		obj:reports():push( obj:report() )
		return obj
	end

	--- Croak, die called due to a possible error condition
	-- Print a message then exits, with caller's name and arguments.
	-- @exception error called unconditionally
	-- @param string message to be passed on
	env.croak = function( str )
		local obj = Spy.create():setReports( reports )
		obj:skip( 'pickle-spies-croak-skip', str )
		obj:reports():push( obj:report() )
		error( mw.message.new( 'pickle-spies-croak-exits' ) )
		return obj
	end

	--- Confess, die called due to a possible error condition, with astack backtrace
	-- Print a message then exits, with caller's name and arguments, and a stack trace.
	-- @exception error called unconditionally
	-- @param string message to be passed on
	env.confess = function( str )
		local obj = Spy.create():setReports( reports )
		obj:skip( 'pickle-spies-confess-skip', str )
		obj:traceback()
		obj:reports():push( obj:report() )
		error( mw.message.new( 'pickle-spies-confess-exits' ) )
		return obj
	end

	-- then do what we should do
	local obj = Frame.create()
		:setRenders( renders )
		:setReports( reports )
		:setSubjects( subjects )
		:setExtractors( extractors )
		:dispatch( ... )

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

	-- create access point
	describe = pickle.describe -- luacheck: globals describe

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
