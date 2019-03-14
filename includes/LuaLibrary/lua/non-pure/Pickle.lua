--- Register functions for the testing framework.
-- @module Pickle

-- accesspoints for the boilerplate
local php		-- luacheck: ignore
local options	-- luacheck: ignore

-- @var structure for storage of the lib
local pickle = {
	_types = {},		-- holds type methods
	_styles = {},		-- holds style methods
	_extractors = {},	-- holds extractor methods
}

--- Register spies.
-- This needs a valid environment, for example from getfenv()
-- @param env table for the environment
-- @param reports ref to objects holding set of reports
local function registerSpies( env, reports )
	assert( env )

	-- require libs
	local Spy = require 'picklelib/engine/Spy'

	--- Carp, warn called due to a possible error condition.
	-- Print a message without exiting, with caller's name and arguments.
	-- @function carp
	-- @param str message to be passed on
	-- @return Spy
	env.carp = function( str )
		local obj = Spy.create():setReports( reports )
		obj:todo( 'todo', 'pickle-spies-carp-todo', str ) -- @todo not sure why this must use 'obj'
		obj:reports():push( obj:report() )
		return obj
	end

	--- Cluck, warn called due to a possible error condition, with a stack backtrace.
	-- Print a message without exiting, with caller's name and arguments, and a stack trace.
	-- @function cluck
	-- @param str message to be passed on
	-- @return Spy
	env.cluck = function( str )
		local obj = Spy.create():setReports( reports )
		obj:todo( 'pickle-spies-cluck-todo', str )
		obj:traceback()
		obj:reports():push( obj:report() )
		return obj
	end

	--- Croak, die called due to a possible error condition.
	-- Print a message then exits, with caller's name and arguments.
	-- @function croak
	-- @raise error called unconditionally
	-- @param str message to be passed on
	-- @return Spy
	env.croak = function( str )
		local obj = Spy.create():setReports( reports )
		obj:skip( 'pickle-spies-croak-skip', str )
		obj:reports():push( obj:report() )
		error( mw.message.new( 'pickle-spies-croak-exits' ) )
		return obj
	end

	--- Confess, die called due to a possible error condition, with a stack backtrace.
	-- Print a message then exits, with caller's name and arguments, and a stack trace.
	-- @function confess
	-- @raise error called unconditionally
	-- @param str message to be passed on
	-- @return Spy
	env.confess = function( str )
		local obj = Spy.create():setReports( reports )
		obj:skip( 'pickle-spies-confess-skip', str )
		obj:traceback()
		obj:reports():push( obj:report() )
		error( mw.message.new( 'pickle-spies-confess-exits' ) )
		return obj
	end
end

--- Register comments.
-- This needs a valid environment, for example from getfenv()
-- @param env table for the environment
-- @param reports ref to objects holding set of reports
local function registerComments( env, reports )
	assert( env )

	--- skip, comment on the current reports.
	-- This will not terminate current run.
	-- @function skip
	-- @param str message to be passed on
	env.skip = function( str )
		reports:top():setSkip( str
			or mw.message.new( 'pickle-report-frame-skip-no-description' ):plain() )
	end

	--- todo, comment on the current reports.
	-- @function todo
	-- @param str message to be passed on
	env.todo = function( str )
		reports:top():setTodo( str
			or mw.message.new( 'pickle-report-frame-todo-no-description' ):plain() )
	end
end

--- Register reports.
-- This needs a valid environment, for example from getfenv()
-- @param env table for the environment
-- @return Stack of reports
local function registerReports( env )
	assert( env )

	-- require libs
	local reports = require( 'picklelib/Stack' ).create()
	env._reports = reports

	return reports
end

--- Register renders.
-- This needs a valid environment, for example from getfenv()
-- @param env table for the environment
-- @return Renders
local function registerRenders( env )
	assert( env )

	-- require libs
	local renders = require 'picklelib/render/Renders'

	-- register render styles
	for k,v in pairs( mw.pickle._styles ) do
		local style = renders.registerStyle( k )
		for l,w in pairs( mw.pickle._types ) do
			local lib = mw.pickle._renderPrefix
				.. k .. mw.pickle._renderInfix
				.. w .. v .. mw.pickle._renderPostfix
			style:registerType( l, require( lib ) )
		end
	end

	return renders
end

--- Register extractors.
-- @return ExtractorStrategies
local function registerExtractors()

	-- require libs
	local extractors = require( 'picklelib/extractor/ExtractorStrategies' ).create()

	-- register extractor types
	for _,v in ipairs( mw.pickle._extractors ) do
		extractors:register( require( v ).create() )
	end

	return extractors
end

--- Register translators.
-- @param subpage name of page
-- @return TranslatorStrategies
local function registerTranslators( subpage )
	assert( subpage )

	-- require libs
	local translators = require( 'picklelib/translator/TranslatorStrategies' ).create()

	-- register translation data
	local translationData = {}
	local prefixedText = mw.getCurrentFrame():getTitle()
	if prefixedText then
		pcall( function()
			translationData = mw.loadData( prefixedText .. subpage )
		end )
	end

	for k,v in pairs( translationData ) do
		translators:register( k, v )
	end

	return translators
end

--- Register adaptations.
-- @param env table for the environment
-- @param reports ref to objects holding set of reports
local function registerAdaptations( env, reports )
	assert( env )

	-- require libs
	local Adapt = require 'picklelib/engine/Adapt'
	local expects = require( 'picklelib/Stack' ).create()
	local subjects = require( 'picklelib/Stack' ).create()

	--- Expect whatever to be compared to the subject.
	-- The expected value is the assumed outcome,
	-- or something that can be transformed into the
	-- assumed outcome.
	-- @function expect
	-- @param ... varargs passed on to Adapt.create
	-- @return Adapt
	env.expect = function( ... )
		local obj = Adapt.create( ... )
			:setReports( reports )
			:setAdaptations( expects )
		return obj
	end

	--- Subject of whatever to be compared to the expected.
	-- The subject is whatever object we want to test,
	-- usually the returned table for a module.
	-- @function subject
	-- @param ... varargs passed on to Adapt.create
	-- @return Adapt
	env.subject = function( ... )
		local obj = Adapt.create( ... )
			:setReports( reports )
			:setSubjects( subjects )
		return obj
	end

	return expects, subjects
end

-- @var metatable for the library
local mt = { types = {} }

--- Install the library.
-- This install all dependencies and changes the environment
-- @function mw.pickle.__call
-- @param env table for the environment
-- @treturn self
function mt:__call( env ) -- luacheck: ignore
	-- @todo
end

setmetatable( pickle, mt )

--- Describe the test.
-- This act as an alias for the normal describe,
-- which is not available.
-- This does implicitt setup.
-- @param ... varargs passed on to Frame:dispatch
-- @treturn self newly created object
function pickle.implicitDescribe( ... )

	-- only require libs
	local Frame = require 'picklelib/engine/Frame'
	local counter = require 'picklelib/Counter'

	-- Get the environment for installation of our access points
	-- This is necessary for testing.
	local ret,env = pcall( function() return getfenv( 4 ) end )
	if not ret then
		env = _G
	end

	local reports = registerReports( env )
	local renders = registerRenders( env )
	local extractors = registerExtractors()
	local translators = registerTranslators( mw.pickle._translationSubpage )	-- luacheck: ignore
	local expects, subjects = registerAdaptations( env, reports )	-- luacheck: ignore

	--- Context for the test.
	-- This is usually used for creating some additional context
	-- before the actual testing. An alternate would be to use
	-- 'before' and 'after' functions.
	-- @function context
	-- @param ... varargs passed on to Frame:dispatch
	-- @return Frame
	env.context = function( ... )
		local obj = Frame.create()
			:setExtractors( extractors )
			:setReports( reports )
			:setSubjects( subjects )
			:dispatch( ... )
		return obj
	end

	--- It is the actual test for each metod.
	-- @tparam vararg ... passed on to Adapt.create
	-- @treturn self newly created object
	env.it = env.context

	registerSpies( env, reports )
	registerComments( env, reports )

	-- then do what we should do
	local obj = Frame.create()
		:setRenders( renders )
		:setReports( reports )
		:setSubjects( subjects )
		:setExtractors( extractors )
		:dispatch( ... )

	--- Eval the fixtures over previous dispatched strings.
	-- This has two different call forms. The first is the usual form with a single
	-- frame object. This is used if the function is called by "invoke". The other
	-- form use the same "style" and "language" form, but as arguments. This makes
	-- it possible to easilly test it in the console.
	-- @return string
	--function obj.tap( name )
	function obj.tap( ... )
		obj:eval()
		assert(obj:reports(), 'Frame: tap: reports')
		assert(obj:reports():top(), 'Frame: tap: top')
		assert(obj:renders(), 'Frame: tap: renders')

		local styleName = 'full'
		local langCode = mw.language.getContentLanguage():getCode()

		if select( '#', ... ) == 1 and type( select( 1, ... ) ) == 'table'  then
			local frame = select( 1, ... )

			if frame.args['style'] then
				styleName = frame.args['style']
			else
				for _,v in ipairs( frame.args ) do
					if pickle._styles[v] then
						styleName = v
						break
					end
				end
			end

			if frame.args['lang'] then
				langCode = frame.args['lang']
			else
				for _,v in ipairs( frame.args ) do
					if mw.language.isValidCode( v ) then
						langCode = v
						break
					end
				end
			end

		elseif select( '#', ... ) > 0 then
			if select( '#', ... ) >= 1 and pickle._styles[select( 1, ... )] then
				styleName = select( 1, ... )
			end
			if select( '#', ... ) >= 2 and mw.language.isValidCode( select( 2, ... ) ) then
				langCode = select( 2, ... )
			end
		end

		local style = obj:renders().style( styleName )
		return obj:reports():top():realize( style, langCode, counter.create() )
	end

	return obj
end

--- install the module in the global space.
function pickle.setupInterface( opts )

	-- boilerplate
	pickle.setupInterface = nil
	php = mw_interface -- luacheck: globals mw_interface
	mw_interface = nil -- luacheck: globals mw_interface
	options = opts -- @todo move data from this more methodically

	-- register main lib
	mw = mw or {}
	mw.pickle = pickle
	package.loaded['mw.Pickle'] = pickle
	pickle._implicit = opts.setup == 'implicit'

	if pickle._implicit then
		-- use 'describe' as access point
		describe = pickle.implicitDescribe -- luacheck: globals describe
	end

	-- keep subpage name for later, newer mind requiring anything now
	pickle._translationSubpage = opts.translationSubpage

	-- keep affix for later
	pickle._renderPrefix = opts.renderPrefix
	pickle._renderInfix = opts.renderInfix
	pickle._renderPostfix = opts.renderPostfix;

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
