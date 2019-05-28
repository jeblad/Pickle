--- Closure for creating stub functions.
-- The full description of how to use the stub function can be found in
-- [test fakes](../topics/test-fakes.md.html).
-- @module Stub

local Bag = require 'picklelib/Bag'

-- @var Table holding the modules exported members
local Stub = {}

-- @var metatable for the class
local mt = {}

--- Create a new stub.
-- @function Stubt:__call
-- @tparam vararg ... passed on to created closure
-- @treturn closure
function mt:__call( ... ) -- luacheck: no self
	local bag = Bag:create():shift( ... )

	local anon = function()
		assert( not bag:isEmpty(), 'Stub:anon; no more frames')
		return unpack( bag:unshift() )
	end

	return anon
end

setmetatable( Stub, mt )

return Stub