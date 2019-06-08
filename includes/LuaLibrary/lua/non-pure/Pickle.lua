--- Register functions for the testing framework.
-- @module Pickle

-- accesspoints for the boilerplate
local php		-- luacheck: ignore
local options	-- luacheck: ignore

-- pure libs
local libUtil = require 'libraryUtil'

-- @var structure for storage of the lib
local pickle = {}

-- @var structure for delayed render styles
local renderStyleNames = nil

-- @var structure for delayed render libs
local renderLibs = {}

-- @var structure for delayed extractor libs
local extractorLibs = {}

-- @var subpage name
local translationSubpage = nil

pickle.bag = require 'picklelib/Bag'
pickle.counter = require 'picklelib/Counter'
pickle.spy = require 'picklelib/engine/Spy'
pickle.frame = require 'picklelib/engine/Frame'
pickle.adapt = require 'picklelib/engine/Adapt'
pickle.double = require 'picklelib/engine/Double'
pickle.renders = require 'picklelib/render/Renders'
pickle.extractors = require 'picklelib/extractor/Extractors'
pickle.translators = require 'picklelib/translator/Translators'

-- Setup framework.
-- This needs a valid environment, for example from getfenv()
-- @tparam table env
-- @treturn table environment
local function setup( env )
	libUtil.checkType( 'setup', 1, env, 'table', false )

	-- create the reports
	local reports = pickle.bag:create()
	--env._reports = reports

	-- register render styles
	for _,v in ipairs( renderLibs ) do
		local style = pickle.renders.registerStyle( v[1] )
		assert( style )
		style:registerType( v[2], require( v[3] ) )
	end

	-- create the extractors
	local extractors = pickle.extractors:create()

	-- register extractor types
	for _,v in ipairs( extractorLibs ) do
		extractors:register( require( v ):create() )
	end

	-- create translators
	local translators = require( 'picklelib/translator/Translators' ):create()

	-- register translation data
	local translationData = nil
	local prefixedText = mw.getCurrentFrame():getTitle()
	if prefixedText then
		pcall( function()
			translationData = mw.loadData( prefixedText .. translationSubpage )
		end )
	end
	for k,v in pairs( translationData or {} ) do
		if not string.match( k, '^@' ) then
			translators:register( k, v )
		end
	end

	-- create adaptations
	local expects = pickle.bag:create()
	local subjects = pickle.bag:create()

	--- Make a test double
	-- This is for mimickin general behavior, and acts like it is a function.
	-- Returns precomputed values or compute them on the fly.
	-- @function stub
	-- @tparam table|string|boolean|number|function ... arguments to be parsed
	-- @treturn function
	env.stub = function( ... )
		return pickle.double:create():setLevel(2):setName('stub'):dispatch( ... ):stub()
	end

	--- Make a carp on the current report.
	-- This is usualy called due to debugging a possible error condition.
	-- Prints a “todo” comment, caller's name and arguments.
	-- @function carp
	-- @tparam nil|string str message to use for todo part of report
	-- @return Spy
	env.carp = function( str )
		libUtil.checkType( 'carp', 1, str, 'string', true )
		str = str or mw.message.new( 'pickle-spies-carp-todo' ):plain()
		return pickle.spy:create():setReports( reports ):doCarp( str )
	end

	--- Make a cluck on the current report.
	-- This is usually called due to debugging a possible error condition.
	-- Prints a “todo” comment, caller's name and arguments, and a stack backtrace.
	-- @function cluck
	-- @tparam nil|string str message to use for todo part of report
	-- @return Spy
	env.cluck = function( str )
		libUtil.checkType( 'cluck', 1, str, 'string', true )
		str = str or mw.message.new( 'pickle-spies-cluck-todo' ):plain()
		return pickle.spy:create():setReports( reports ):doCluck( str )
	end

	--- Make a croak on the current report.
	-- This is usually called due to debugging a possible error condition.
	-- Prints a “skip” comment, caller's name and arguments, and exits.
	-- @function croak
	-- @raise unconditionally
	-- @tparam nil|string str message to use for todo part of report
	-- @tparam[opt=0] nil|number level to report
	env.croak = function( str, level )
		libUtil.checkType( 'croak', 1, str, 'string', true )
		libUtil.checkType( 'croak', 2, level, 'number', true )
		str = str or mw.message.new( 'pickle-spies-croak-skip' ):plain()
		pickle.spy:create():setReports( reports ):doCroak( str )
		error( mw.message.new( 'pickle-spies-croak-exits' ):plain(), level or 0 )
	end

	--- Make a confess(ion) on the current report.
	-- This is usually called due to debugging a possible error condition.
	-- Prints a “skip” comment, caller's name and arguments, a stack backtrace, and exits.
	-- @function confess
	-- @raise unconditionally
	-- @tparam nil|string str message to use for todo part of report
	-- @tparam[opt=0] nil|number level to report
	env.confess = function( str, level )
		libUtil.checkType( 'confess', 1, str, 'string', true )
		libUtil.checkType( 'croak', 2, level, 'number', true )
		str = str or mw.message.new( 'pickle-spies-confess-skip' ):plain()
		pickle.spy:create():setReports( reports ):doConfess( str )
		error( mw.message.new( 'pickle-spies-confess-exits' ):plain(), level or 0 )
	end

	--- Make a skip comment on the current report.
	-- This function will not terminate the current run.
	-- Consider @{Pickle.croak|croak} or @{Pickle.confess|confess}.
	-- @function skip
	-- @tparam nil|string str message to be passed on
	env.skip = function( str )
		libUtil.checkType( 'skip', 1, str, 'string', true )
		reports:top():setSkip( str
			or mw.message.new( 'pickle-report-frame-skip-no-description' ):plain() )
	end

	--- Make a todo comment on the current report.
	-- This function will not terminate the current run.
	-- Consider @{Pickle.carp|carp} or @{Pickle.cluck|cluck}.
	-- @function todo
	-- @tparam nil|string str message to be passed on
	env.todo = function( str )
		libUtil.checkType( 'todo', 1, str, 'string', true )
		reports:top():setTodo( str
			or mw.message.new( 'pickle-report-frame-todo-no-description' ):plain() )
	end

	--- Expect whatever to be compared to the subject.
	-- The expected value is the assumed outcome,
	-- or something that can be transformed into the
	-- assumed outcome.
	-- @function expect
	-- @param ... varargs passed on to Adapt:create
	-- @return Adapt
	env.expect = function( ... )
		local obj = pickle.adapt:create( ... )
			:setReports( reports )
			:setAdaptations( expects )
		return obj
	end

	--- Subject of whatever to be compared to the expected.
	-- The subject is whatever object we want to test,
	-- usually the returned table for a module.
	-- @function subject
	-- @param ... varargs passed on to Adapt:create
	-- @return Adapt
	env.subject = function( ... )
		local obj = pickle.adapt:create( ... )
			:setReports( reports )
			:setSubjects( subjects )
		return obj
	end

	--- Helper to get the named style
	-- @param frame
	-- @treturn string
	local function findStyle( frame )
		if frame.args['style'] then
			return frame.args['style']
		end
		local names ={}
		for _,v in ipairs( renderLibs ) do
			names[v[1]] = true
		end
		for _,v in ipairs( frame.args ) do
			if names[v] then
				return v
			end
		end
		return nil
	end

	--- Helper to get the identified language
	-- @param frame
	-- @treturn string
	local function findLang( frame )
		if frame.args['lang'] then
			return frame.args['lang']
		end
		for _,v in ipairs( frame.args ) do
			if mw.language.isValidCode( v ) then
				return v
			end
		end
		return nil
	end

	--- Describe the test.
	-- This is the outermost of the three levels.
	-- @function describe
	-- @param ... varargs passed on to Frame:dispatch
	-- @return Frame
	env.describe = function( ... )
		local obj = pickle.frame:create()
		obj:setRenders( pickle.renders )
			:setReports( reports )
			:setSubjects( subjects )
			:setExtractors( extractors )
			:setTranslators( translators )
			:dispatch( ... )

		--- Eval the fixtures over previous dispatched strings.
		-- This is extending the `describe` call by injecting `tap` as an method.
		-- The method has two different call forms. First form is the usual one with a single
		-- frame object. This is used if the function is called by "invoke". The second
		-- form use the same "style" and "language" form, but as arguments. This makes
		-- it possible to easilly test it in the console.
		-- @return string
		function obj:tap( ... )
			self:eval()
			assert( reports:top(), 'Pickle: Can not find top')

			local styleName = nil
			local langCode = nil

			if select( '#', ... ) == 1 and type( select( 1, ... ) ) == 'table'  then
				local frame = select( 1, ... )
				styleName = findStyle( frame )
				langCode = findLang( frame )

			elseif select( '#', ... ) > 1 then
				local frame = { args = { style = select( 1, ... ), lang = select( 2, ... ) } }
				styleName = findStyle( frame )
				langCode = findLang( frame )
			end

			styleName = styleName or 'full'
			langCode = langCode or mw.language.getContentLanguage():getCode()

			local style = pickle.renders.style( styleName )
			return reports:top():realize( style, langCode, pickle.counter:create() )
		end

		return obj
	end

	--- Context for the test.
	-- This is usually used for creating some additional context
	-- before the actual testing. An alternate would be to use
	-- 'before' and 'after' functions.
	-- @function context
	-- @param ... varargs passed on to Frame:dispatch
	-- @return Frame
	env.context = function( ... )
		local obj = pickle.frame:create()
			:setReports( reports )
			:setSubjects( subjects )
			:setExtractors( extractors )
			:setTranslators( translators )
			:dispatch( ... )
		return obj
	end

	--- It is the actual test for each metod.
	-- @tparam vararg ... passed on to Frame:create
	-- @treturn self newly created object
	env.it = env.context

	--- Put up a nice banner telling everyone pickle is initialized, and add the instances
	env._reports = reports
	env._renders = pickle.renders
	env._extractors = extractors
	env._translators = translators
	env._PICKLE = true

	return env
end

-- @var metatable for the library
local mt = { types = {} }

--- Install the library.
-- This install all dependencies and changes the environment
-- @function mw.pickle.__call
-- @param env table for the environment
-- @treturn self
function mt:__call() -- luacheck: no self
	-- Get the environment for installation of our access points
	-- This is necessary for testing.
	local ret,env = pcall( function() return getfenv( 4 ) end )
	if not ret then
		env = _G
	end
	setup( env )
end

setmetatable( pickle, mt )

--- install the module in the global space.
function pickle.setupInterface( opts )

	-- boilerplate
	pickle.setupInterface = nil
	php = mw_interface
	mw_interface = nil
	options = opts -- @todo move data from this more methodically

	-- register main lib
	mw = mw or {}
	mw.pickle = pickle
	package.loaded['mw.Pickle'] = pickle
	pickle._implicit = opts.setup == 'implicit'

	-- keep subpage name for later
	translationSubpage = opts.translationSubpage

	-- keep render libs for later
	for k,v in pairs( opts.renderStyles ) do
		for l,w in pairs( opts.renderTypes ) do
			local lib = opts.renderPrefix .. k .. opts.renderInfix .. w .. v .. opts.renderPostfix
			table.insert( renderLibs, { k, l, lib } )
		end
	end

	-- keep extractors for later
	for i,v in ipairs( opts.extractors ) do
		table.insert( extractorLibs, v )
	end

end

-- Return the final library
return pickle
