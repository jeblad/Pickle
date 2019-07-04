--- Module for HelloWorld.
-- Example module to familiarize yourself with the system.
-- Purpose of this module is to provide a basic module for testing.
-- @module HelloWorld
local HelloWorld = {}

--- Merge text fragments 
-- This will interact with the method arguments.
-- @tparam string ... text fragments
-- @treturn string|nil
-- @return string error message
function HelloWorld.merge( ... )
	for i,v in ipairs( { ... } ) do
		if type( v ) ~= 'string' then
			return nil, "Made a boo-boo!"
		end
	end
	return table.concat( { ... }, ' ' )
end

--- Outer hello function.
-- This will interact with the case stack. Without additional tools
-- to create a mock for the case instance it is better left alone.
-- @param case instance
-- @return string
function HelloWorld.hello( case )
	local text, err = HelloWorld._hello( unpack( case.args ) )
	return text or err
end

return HelloWorld