--- Stack for managing values.
-- @classmod Stack

-- @var class for the lib
local Stack = {}

--- Lookup of missing class members.
-- @param key string used for lookup of member
-- @return any
function Stack:__index( key ) -- luacheck: no self
	return Stack[key]
end

--- Create a new instance.
-- @param ... varargs pushed on the stack
-- @treturn self
function Stack.create( ... )
	local self = setmetatable( {}, Stack )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @param ... varargs pushed on the stack
-- @treturn self
function Stack:_init( ... )
	self._stack = {}
	self:push( ... )
	return self
end

--- Is the stack empty.
-- Note that the internal structure is non-empty even if a nil
-- is pushed on the stack.
-- @return boolean saying whether the internal structure has length zero
function Stack:isEmpty()
	return #self._stack == 0
end

--- What is the depth of the internal structure.
-- Note that the internal structure has a depth even if a nil
-- is pushed on the stack.
-- @return number saying how deep the internal structure is
function Stack:depth()
	return #self._stack
end

--- Get the layout of the stack.
-- This method is used for testing to inspect which types of objects
function Stack:layout()
	local t = {}
	for i,v in ipairs( self._stack ) do
		t[i] = type( v )
	end
	return t
end

--- Get a reference to the bottommost item in the stack.
-- The bottommost item can also be described as the first item.
-- This method leaves the item on the stack.
-- @alias first
-- @return any item that can be put on the stack
function Stack:bottom()
	return self._stack[1]
end
Stack.first = Stack.bottom

--- Get a reference to the topmost item in the stack.
-- The topmost item can also be described as the last item.
-- This method leaves the item on the stack.
-- @alias last
-- @return any item that can be put on the stack
function Stack:top()
	return self._stack[#self._stack]
end
Stack.last = Stack.top

--- Push a value on the stack.
-- @treturn self so chaing is unbroken
function Stack:push( ... )
	for _,v in ipairs( { ... } ) do
		table.insert( self._stack, v )
	end
	return self
end

--- Pop the last value of the stack.
-- Note that this will remove the last (topmost) value.
-- @param num items to drop
-- @return any item that can be put on the stack
function Stack:pop( num )
	local t = {}

	for i=1,(num or 1) do
		t[(num or 1) - i + 1] = table.remove( self._stack )
	end

	return unpack( t )
end

--- Drop the last n values of the stack.
-- Note that this will remove the last (topmost) values.
-- @param num of items to drop
-- @treturn self so chaing is unbroken
function Stack:drop( num )
	for _=1,(num or 1) do
		table.remove( self._stack )
	end

	return self
end

--- Get the indexed entry.
-- Accessing this will not change stored values.
-- @param num entry number, negative numbers count backwards
-- @return stored value
function Stack:get( num )
	assert( num ~= 0 )
	if num < 0 then
		-- n is negative, and add 1 to hit the end point
		return self._stack[#self._stack + num + 1]
	end
	-- note n is positive
	return self._stack[num]
end

--- Export a list of all the contents.
-- @return list of values
function Stack:export()
	local t = {}

	for i,v in ipairs( self._stack ) do
		t[i] = v
	end

	return unpack( t )
end

--- Flush all the contents.
-- Note that this clears the internal storage.
-- @return list of values
function Stack:flush()
	local t = { self:export() }

	self._stack = {}

	return unpack( t )
end

-- Return the final class.
return Stack
