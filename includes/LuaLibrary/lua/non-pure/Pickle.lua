-- accesspoints for the bilerplate
local php		-- luacheck: ignore
local options	-- luacheck: ignore

-- @var structure for storage of the lib
local pickle = {}

-- pickle.util = require 'picklelib/util'
-- pickle.stack = require 'picklelib/Stack'
pickle.adapt = require 'picklelib/engine/Adapt'
pickle.expect = require 'picklelib/engine/Expect'
pickle.subject = require 'picklelib/engine/Subject'
pickle.constituent = require 'picklelib/report/Constituent'
pickle.renders = require 'picklelib/render/Renders'
pickle.frame = require 'picklelib/engine/Frame'
--local Plan = require 'picklelib/report/Plan'
--[[
	for k,v in pairs( util ) do
	if not pickle[k] then
		pickle[k] = v
	end
end
--]]

-- require libs and create an instance
pickle.extractors = require( 'picklelib/extractor/ExtractorStrategies' ).create()

local export = {
	subject = pickle.subject,
	expect = pickle.expect
}

-- create the access to other parties
function pickle.expect.other()
	return Subject -- luacheck: globals Subject
end
function pickle.subject.other()
	return Expect -- luacheck: globals Expect
end

function pickle.report( frame )
	local style = frame.args[1]
	return 'ping! '..style
	--return Plan():realize( Renders( style ) )
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
	package.loaded['mw.pickle'] = pickle

	-- register render styles
	for k,v in pairs( opts.renderStyles ) do
		local style = pickle.renders:registerStyle( k )
		for l,w in pairs( opts.renderTypes ) do
			style:registerType( l, require( v .. '/' .. w ) )
		end
	end

	-- register extractor types
	for _,v in ipairs( opts.extractorStrategies ) do
		pickle.extractors:register( require( v ).create() )
	end


	-- set up additional access points
	for k,v in pairs( export ) do
		if not mw[k] then
			mw[k] = v
			--package.loaded['mw.'..k] = v
		end
	end
end

-- Return the final library
return pickle
