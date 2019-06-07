--- Register functions for the testing framework.
-- @module Pickle

-- accesspoints for the boilerplate
local php		-- luacheck: ignore
local options	-- luacheck: ignore

-- pure libs
local libUtil = require 'libraryUtil'
local Counter = require 'picklelib/Counter'
local Bag = require 'picklelib/Bag'

-- @var structure for storage of the lib
local pickle = {}

-- @var structure for delayed render styles
local renderStyleNames = nil

-- @var structure for delayed render libs
local renderLibs = {}

-- @var structure for delayed extractor libs
local extractorLibs = {}

pickle.double = require 'picklelib/engine/Double'
pickle.renders = require 'picklelib/render/Renders'
pickle.extractors = require 'picklelib/extractor/Extractors'

-- Register doubles.
-- This needs a valid environment, for example from getfenv()
-- @raise on wrong arguments
-- @tparam table env for the environment
local function registerDoubles( env )
	libUtil.checkType( 'Pickle:registerDoubles', 1, env, 'table', false )

	--- Test double for mimickin general behavior.
	-- Returns precomputed values or compute them on the fly.
	-- @function stub
	-- @tparam table|string|boolean|number|function ... arguments to be parsed
	-- @treturn function
	env.stub = function( ... )
		return pickle.double:create():setLevel(2):setName('stub'):dispatch( ... ):stub()
	end
end

--- Register spies.
-- This needs a valid environment, for example from getfenv()
-- @raise on wrong arguments
-- @tparam table env for the environment
-- @tparam Reports reports ref to objects holding set of reports
local function registerSpies( env, reports )
	libUtil.checkType( 'Pickle:registerSpies', 1, env, 'table', false )
	libUtil.checkType( 'Pickle:registerSpies', 2, reports, 'table', false )

	-- require libs
	local Spy = require 'picklelib/engine/Spy'

	--- Carp, warn called due to a possible error condition.
	-- Print a message without exiting, with caller's name and arguments.
	-- @function carp
	-- @tparam nil|string str message to use for todo part of report
	-- @return Spy
	env.carp = function( str )
		libUtil.checkType( 'carp', 1, str, 'string', true )
		str = str or mw.message.new( 'pickle-spies-carp-todo' ):plain()
		return Spy:create():setReports( reports ):doCarp( str )
	end

	--- Cluck, warn called due to a possible error condition, with a stack backtrace.
	-- Print a message without exiting, with caller's name and arguments, and a stack trace.
	-- @function cluck
	-- @tparam nil|string str message to use for todo part of report
	-- @return Spy
	env.cluck = function( str )
		libUtil.checkType( 'cluck', 1, str, 'string', true )
		str = str or mw.message.new( 'pickle-spies-cluck-todo' ):plain()
		return Spy:create():setReports( reports ):doCluck( str )
	end

	--- Croak, die called due to a possible error condition.
	-- Print a message then exits, with caller's name and arguments.
	-- @function croak
	-- @raise unconditionally
	-- @tparam nil|string str message to use for todo part of report
	-- @tparam[opt=0] nil|number level to report
	env.croak = function( str, level )
		libUtil.checkType( 'croak', 1, str, 'string', true )
		libUtil.checkType( 'croak', 2, level, 'number', true )
		str = str or mw.message.new( 'pickle-spies-croak-skip' ):plain()
		Spy:create():setReports( reports ):doCroak( str )
		error( mw.message.new( 'pickle-spies-croak-exits' ):plain(), level or 0 )
	end

	--- Confess, die called due to a possible error condition, with a stack backtrace.
	-- Print a message without exiting, with caller's name and arguments, and a stack trace.
	-- @function confess
	-- @raise unconditionally
	-- @tparam nil|string str message to use for todo part of report
	-- @tparam[opt=0] nil|number level to report
	env.confess = function( str, level )
		libUtil.checkType( 'confess', 1, str, 'string', true )
		libUtil.checkType( 'croak', 2, level, 'number', true )
		str = str or mw.message.new( 'pickle-spies-confess-skip' ):plain()
		Spy:create():setReports( reports ):doConfess( str )
		error( mw.message.new( 'pickle-spies-confess-exits' ):plain(), level or 0 )
	end
end

--- Register comments.
-- This needs a valid environment, for example from getfenv()
-- @raise on wrong arguments
-- @tparam table env for the environment
-- @tparam Reports reports ref to objects holding set of reports
local function registerComments( env, reports )
	libUtil.checkType( 'Pickle:registerComments', 1, env, 'table', false )
	libUtil.checkType( 'Pickle:registerComments', 2, reports, 'table', false )

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
-- @raise on wrong arguments
-- @tparam table env for the environment
-- @return Bag of reports
local function registerReports( env )
	libUtil.checkType( 'Pickle:registerComments', 1, env, 'table', false )

	-- require libs
	local reports = Bag:create()
	env._reports = reports

	return reports
end

--- Register renders.
-- @return Renders
local function registerRenders( env )	-- require libs
	libUtil.checkType( 'Pickle:registerRenders', 1, env, 'table', false )

	local renders = require 'picklelib/render/Renders'

	-- register render styles
	for _,v in ipairs( renderLibs ) do
		local style = renders.registerStyle( v[1] )
		assert( style )
		style:registerType( v[2], require( v[3] ) )
	end

	--- Renders, the access .
	-- Print a message without exiting, with caller's name and arguments.
	-- @function carp
	-- @tparam nil|string str message to use for todo part of report
	-- @return Spy
	env.renders = function( ... )
		return renders( ... )
	end

	return renders
end

--- Register extractors.
-- @return Extractors
local function registerExtractors()

	-- require libs
	local extractors = mw.pickle.extractors:create()

	-- register extractor types
	for _,v in ipairs( extractorLibs ) do
		extractors:register( require( v ):create() )
	end

	return extractors
end

--- Register translators.
-- @raise on wrong arguments
-- @tparam string subpage name of page
-- @return TranslatorStrategies
local function registerTranslators( subpage )
	libUtil.checkType( 'Pickle:registerTranslators', 1, subpage, 'string', false )

	-- require libs
	local translators = require( 'picklelib/translator/Translators' ):create()

	-- register translation data
	local translationData = nil
	local prefixedText = mw.getCurrentFrame():getTitle()
	if prefixedText then
		pcall( function()
			translationData = mw.loadData( prefixedText .. subpage )
		end )
	end

	for k,v in pairs( translationData or {} ) do
		if not string.match( k, '^@' ) then
			translators:register( k, v )
		end
	end

	return translators
end

--- Register adaptations.
-- @tparam table env for the environment
-- @tparam Reports reports ref to objects holding set of reports
local function registerAdaptations( env, reports )
	libUtil.checkType( 'Pickle:registerAdaptations', 1, env, 'table', false )
	libUtil.checkType( 'Pickle:registerAdaptations', 2, reports, 'table', false )

	-- require libs
	local Adapt = require 'picklelib/engine/Adapt'
	local expects = Bag:create()
	local subjects = Bag:create()

	--- Expect whatever to be compared to the subject.
	-- The expected value is the assumed outcome,
	-- or something that can be transformed into the
	-- assumed outcome.
	-- @function expect
	-- @param ... varargs passed on to Adapt:create
	-- @return Adapt
	env.expect = function( ... )
		local obj = Adapt:create( ... )
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
		local obj = Adapt:create( ... )
			:setReports( reports )
			:setSubjects( subjects )
		return obj
	end

	return expects, subjects
end

--- Helper to get the named style
-- @param frame
-- @treturn string
local function findStyle( frame )
	if frame.args['style'] then
		return frame.args['style']
	end
	for _,v in ipairs( frame.args ) do
		if renderStyleNames[v] then
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

-- @var metatable for the library
local mt = { types = {} }

--- Install the library.
-- This install all dependencies and changes the environment
-- @function mw.pickle.__call
-- @param env table for the environment
-- @treturn self
function mt:__call() -- luacheck: no self
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
		local obj = Frame:create()
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

	registerDoubles( env )
	registerSpies( env, reports )
	registerComments( env, reports )

	-- then do what we should do
	local obj = Frame:create()
		:setRenders( renders )
		:setReports( reports )
		:setSubjects( subjects )
		:setExtractors( extractors )
		:setTranslators( translators )
		:dispatch( ... )

	--- Eval the fixtures over previous dispatched strings.
	-- This has two different call forms. The first is the usual form with a single
	-- frame object. This is used if the function is called by "invoke". The other
	-- form use the same "style" and "language" form, but as arguments. This makes
	-- it possible to easilly test it in the console.
	-- @return string
	--function obj.tap( name )
	function obj:tap( ... )
		self:eval()

		if self:reports() then
			return nil, 'Pickle: Can not find reports'
		end

		if self:reports():top() then
			return nil, 'Pickle: Can not find top'
		end

		if self:renders() then
			return nil, 'Pickle: Can not find renders'
		end

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

		local style = self:renders().style( styleName )
		return self:reports():top():realize( style, langCode, Counter:create() )
	end

	return obj
end

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

	if pickle._implicit then
		-- use 'describe' as access point
		describe = pickle.implicitDescribe -- luacheck: globals describe
	end

	-- keep subpage name for later, newer mind requiring anything now
	pickle._translationSubpage = opts.translationSubpage

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
