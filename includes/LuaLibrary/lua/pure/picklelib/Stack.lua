--- Stack for managing values.
-- The semantics of a stack is to pop the last entry to be pushed on the stack.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Stack

-- pure libs
local libUtil = require 'libraryUtil'

-- @var class
local Stack = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Stack:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Stack:__index', 1, key, 'string', false )
	return Stack[key]
end

--- Create a new instance.
-- @tparam vararg ... forwarded to `_init()`
-- @treturn self
function Stack:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... pushed on the stack
-- @treturn self
function Stack:_init( ... )
	self._stack = {}
	self:push( ... )
	return self
end

--- Is the stack empty.
-- Note that the internal structure is non-empty even if a nil
-- is pushed on the stack.
-- @treturn boolean whether the internal structure has length zero
function Stack:isEmpty()
	return #self._stack == 0
end

--- What is the depth of the internal structure.
-- Note that the internal structure has a depth even if a nil
-- is pushed on the stack.
-- @treturn number how deep is the internal structure
function Stack:depth()
	return #self._stack
end

--- Get the layout of the stack.
-- This method is used for testing to inspect which types of objects exists in the stack.
-- @treturn table description of the stack
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
-- @nick first
-- @treturn any item that can be put on the stack
function Stack:bottom()
	return self._stack[1]
end
Stack.first = Stack.bottom -- first item to be pushed

--- Get a reference to the topmost item in the stack.
-- The topmost item can also be described as the last item.
-- This method leaves the item on the stack.
-- @nick last
-- @treturn any item that can be put on the stack
function Stack:top()
	return self._stack[#self._stack]
end
Stack.last = Stack.top -- last item to be pushed

--- Push a value on the stack.
-- @treturn self facilitate chaining
function Stack:push( ... )
	for _,v in ipairs( { ... } ) do
		table.insert( self._stack, v )
	end
	return self
end
Stack.shift = Stack.push

--- Pop the last value of the stack.
-- Note that this will remove the last (topmost) value.
-- @tparam[opt=1] number num items to drop
-- @treturn any item that can be put on the stack
function Stack:pop( num )
	local t = {}
	for i=1,math.abs(num or 1) do
		t[(num or 1) - i + 1] = table.remove( self._stack )
	end
	return unpack( t )
end
Stack.unshift = Stack.pop

--- Drop the last n values of the stack.
-- Note that this will remove the last (topmost) values.
-- @tparam[opt=1] number num items to drop
-- @treturn self facilitate chaining
function Stack:drop( num )
	for _=1,math.abs(num or 1) do
		table.remove( self._stack )
	end
	return self
end

--- Get the indexed entry.
-- Accessing this will not change stored values.
-- @tparam[opt=1] number num entry, negative numbers count backwards
-- @treturn any item that can be put on the stack
function Stack:get( num )
	return self._stack[math.abs(num or 1)]
end

--- Export a list of all the contents.
-- @treturn table list of values
function Stack:export()
	local t = {}
	for i,v in ipairs( self._stack ) do
		t[i] = v
	end
	return unpack( t )
end

--- Flush all the contents.
-- Note that this clears the internal storage.
-- @treturn table list of values
function Stack:flush()
	local t = { self:export() }
	self._stack = {}
	return unpack( t )
end

-- Return the final class.
return Stack
