-- accesspoints for the bilerplate
local php		-- luacheck: ignore
local options	-- luacheck: ignore

-- @var structure for storage of the lib
local shim = { installed = false }
shim.renderStyles = {}
shim.renderTypes = {}
shim.extractorStrategies = {}

--- Example is an alias for describe
-- This does bootstrapping of the libs in addition to the normal call.
function shim.example( ... )
	local pickle = require 'pickle'
	if not pickle.initialized then
		pickle()
	end
	return pickle:describe( ... )
end

--- Install the module in the global space
function shim.setupInterface( opts )

	-- boilerplate
	shim.setupInterface = nil
	php = mw_interface -- luacheck: globals mw_interface
	mw_interface = nil -- luacheck: globals mw_interface
	options = opts

	-- register main lib
	mw = mw or {}
	mw.pickle = shim
	package.loaded['Pickle'] = shim

	-- bump example one level
	mw.example = shim.example

	-- keep relations for render styles
	for k,v in pairs( opts.renderStyles ) do
		shim.renderStyles[k] = v
	end

	-- keep relations for render types
	for k,v in pairs( opts.renderTypes ) do
		shim.renderTypes[k] = v
	end

	-- keep relations for extractor strategies
	for k,v in pairs( opts.extractorStrategies ) do
		shim.extractorStrategies[k] = v
	end

-- Return the final library
return shim
