-- accesspoints for the bilerplate
local php		-- luacheck: ignore
local options	-- luacheck: ignore

-- @var structure for storage of the lib
local bootstrap = {}

---
function bootstrap.example( ... )
--_G.bar = 'baz'
	local pickle = require 'pickle'()
	return pickle.describe( ... )
end

--- install the module in the global space
function bootstrap.setupInterface( opts )
	-- keep otions for later
	bootstrap.options = {
		renderStyles = {},
		renderTypes = {},
		extractorStrategies = {}
	}
	for k,v in pairs( opts.renderStyles ) do
		bootstrap.options.renderStyles[k] = v
	end
	for k,v in pairs( opts.renderTypes ) do
		bootstrap.options.renderTypes[k] = v
	end
	for k,v in pairs( opts.extractorStrategies ) do
		bootstrap.options.extractorStrategies[k] = v
	end

	-- boilerplate
	bootstrap.setupInterface = nil
	php = mw_interface -- luacheck: globals mw_interface
	mw_interface = nil -- luacheck: globals mw_interface

	-- register main lib
	mw = mw or {}
	mw.bootstrap = bootstrap
	mw.example = bootstrap.example
	package.loaded['bootstrap'] = bootstrap

end

-- Return the final library
return bootstrap
