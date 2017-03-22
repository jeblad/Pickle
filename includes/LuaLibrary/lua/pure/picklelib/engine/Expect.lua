--- Subclass to do specialization of the Adapt class
-- This is the spesialization to register access to expectations

-- pure libs
local Stack = require 'picklelib/Stack'

-- @var class var for lib
local Expect = {}

-- non-pure libs
local Adapt
if mw.pickle then
	-- structure exist, make access simpler
	Adapt = mw.pickle.adapt
else
	-- structure does not exist, require the libs
	Adapt = require 'picklelib/engine/Adapt'
end

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Expect:__index( key ) -- luacheck: no self
	return Expect[key]
end

-- @var metatable for the class
local mt = { __index = Adapt }

--- Get a clone or create a new instance
-- @param vararg conditionally passed to create
-- @return self
function mt:__call( ... ) -- luacheck: ignore
	local t = { ... }
	Expect.stack:push( #t == 0 and Expect.stack:top() or Expect.create( ... ) )
	return Expect.stack:top()
end

setmetatable( Expect, mt )

-- @var class var for stack, holding references to defined expects
Expect.stack = Stack.create()

-- @var class var for other, holding a reference to the subjects
Expect.other = nil

--- Create a new instance
-- @param vararg set to temporal
-- @return self
function Expect.create( ... )
	local self = setmetatable( {}, Expect )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg set to temporal
-- @return self
function Expect:_init( ... )
	Adapt._init( self, ... )
	if Expect.other ~= nil then
		self._other = Expect.other
	end
	return self
end

-- Return the final class
return Expect
