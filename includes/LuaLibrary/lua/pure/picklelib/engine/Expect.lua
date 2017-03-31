--- Subclass to do specialization of the Adapt class
-- This is the spesialization to register access to expectations

-- pure libs
local Stack = require 'picklelib/Stack'
local Adapt = require 'picklelib/engine/Adapt'

-- @var class var for lib
local Expect = {}

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
	self:expects():push( select( '#', ... ) == 0 and self:expects():top() or Expect.create( ... ) )
	return self:expects():top()
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

--- Set the reference to the expects collection
-- This keeps a reference, the object is not cloned.
-- @param table that somehow maintain a collection
function Expect:setExpects( obj )
	assert( type( obj ) == 'table' )
	self._expects = obj
	return self
end

--- Expose reference to expects
-- If no report is set, then a new one is created.
-- @return list of expectations
function Expect:expects()
	if not self._expects then
		self._expects = Stack.create()
	end
	return self._expects
end

-- Return the final class
return Expect
