--- Library for loading of Pickle with additional libs

-- @var access point for the lib
local pickle = mw.pickle or {}
pickle.report = {}
pickle.initialized = false

-- require libs and if necessary create an instance
pickle.adapt = require 'picklelib/engine/Adapt'
pickle.expect = require 'picklelib/engine/Expect'
pickle.subject = require 'picklelib/engine/Subject'
pickle.report.base = require 'picklelib/report/BaseReport'
pickle.report.adapt = require 'picklelib/report/AdaptReport'
pickle.report.frame = require 'picklelib/report/FrameReport'
pickle.renders = require 'picklelib/render/Renders'
pickle.frame = require 'picklelib/engine/Frame'
pickle.spies = require 'picklelib/engine/Spies'
pickle.extractors = require( 'picklelib/extractor/ExtractorStrategies' ).create()
pickle.reports = require( 'picklelib/Stack' ).create()

--
local export = {
	describe = pickle.frame,
	context = pickle.frame,
	it = pickle.frame,
	subject = pickle.subject,
	expect = pickle.expect,
	carp = pickle.spies.carp,
	cluck = pickle.spies.cluck,
	confess = pickle.spies.confess,
	croak = pickle.spies.croak
}

-- adjust the access to other for expect
function pickle.expect.other()
	return pickle.subject -- luacheck: globals Subject
end

-- adjust the access to other for subject
function pickle.subject.other()
	return pickle.expect -- luacheck: globals Expect
end

--- metatable for the export
local mt = {}

--- install the module in the global space
function mt:__call( lang )
	if lang then
		self.lang = lang
	end

	-- register render styles
	for k,v in pairs( pickle.renderStyles ) do
		local style = pickle.renders:registerStyle( k )
		for l,w in pairs( pickle.renderTypes ) do
			style:registerType( l, require( v .. '/' .. w ) )
		end
	end

	-- register extractor types
	for _,v in ipairs( pickle.extractorStrategies ) do
		pickle.extractors:register( require( v ).create() )
	end

	for k,v in pairs( export ) do
		if string.match( k, '[^A-Z]') then
			assert( not _G[k], k )
			_G[k] = v
		end
	end

	pickle.initialized = true
	return self
end

setmetatable( pickle, mt )

return pickle
