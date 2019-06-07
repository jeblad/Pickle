--- Bag for managing values.
-- The semantics of a bag is to pop the oldest entry pushed into the bag.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Bag

-- pure libs
local libUtil = require 'libraryUtil'

-- @var class
local Bag = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Bag:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Bag:__index', 1, key, 'string', false )
	return Bag[key]
end

--- Create a new instance.
-- @tparam vararg ... forwarded to `_init()`
-- @treturn self
function Bag:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... pushed on the bag
-- @treturn self
function Bag:_init( ... )
	self._bag = {}
	for _,v in ipairs( { ... } ) do
		table.insert( self._bag, v )
	end
	return self
end

--- Is the bag empty.
-- Note that the internal structure is non-empty even if a nil
-- is pushed on the bag.
-- @treturn boolean whether the internal structure has length zero
function Bag:isEmpty()
	return #self._bag == 0
end

--- What is the depth of the internal structure.
-- Note that the internal structure has a depth even if a nil
-- is pushed on the bag.
-- @treturn number how deep is the internal structure
function Bag:depth()
	return #self._bag
end

--- Get the layout of the bag.
-- This method is used for testing to inspect which types of objects exists in the bag.
-- @treturn table description of the bag
function Bag:layout()
	local t = {}
	for i,v in ipairs( self._bag ) do
		t[i] = type( v )
	end
	return t
end

--- Get a reference to the bottommost item in the bag.
-- The bottommost item can also be described as the first item to be handled.
-- This method leaves the item on the bag.
-- @nick first
-- @treturn any item that can be put on the bag
function Bag:bottom()
	return self._bag[1]
end
Bag.first = Bag.bottom

--- Get a reference to the topmost item in the bag.
-- The topmost item can also be described as the last item to be handled.
-- This method leaves the item on the bag.
-- @nick last
-- @treturn any item that can be put on the bag
function Bag:top()
	return self._bag[#self._bag]
end
Bag.last = Bag.top

--- Push a value on the bag.
-- This is stack-like semantics.
-- @treturn self facilitate chaining
function Bag:push( ... )
	for _,v in ipairs( { ... } ) do
		table.insert( self._bag, v )
	end
	return self
end

--- Unshift a value into the bag.
-- This is queue-like semantics.
-- @treturn self facilitate chaining
function Bag:unshift( ... )
	for _,v in ipairs( { ... } ) do
		table.insert( self._bag, 1, v )
	end
	return self
end

--- Pop the last num values pushed on the bag.
-- This is stack-like semantics.
-- Note that this will remove the last pushed (topmost) value.
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number num items to drop
-- @treturn any item that can be put on the bag
function Bag:pop( num )
	libUtil.checkType( 'Bag:pop', 1, num, 'number', true )
	num = num or 1
	assert( num >= 0, 'Bag:pop; num less than zero')
	if num == 0 then
		return
	end
	local t = {}
	for i=1,num do
		t[num - i + 1] = table.remove( self._bag )
	end
	return unpack( t )
end

--- Shift the first num values unshifted into the bag.
-- This is queue-like semantics.
-- Note that this will remove the first unshifted (topmost) value.
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number num items to drop
-- @treturn any item that can be put on the bag
function Bag:shift( num )
	libUtil.checkType( 'Bag:shift', 1, num, 'number', true )
	num = num or 1
	assert( num >= 0, 'Bag:shift; num less than zero')
	if num == 0 then
		return
	end
	local t = {}
	for i=1,num do
		t[i] = table.remove( self._bag )
	end
	return unpack( t )
end

--- Drop the topmost num values of the Bag.
-- Note that this will remove the topmost values.
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number num items to drop
-- @treturn self facilitate chaining
function Bag:drop( num )
	libUtil.checkType( 'Bag:drop', 1, num, 'number', true )
	num = num or 1
	assert( num >= 0, 'Bag:drop; num less than zero')
	if num == 0 then
		return self
	end
	for _=1,num do
		table.remove( self._bag )
	end
	return self
end

--- Get the indexed entry.
-- Accessing this will not change stored values.
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number idx entry from top, negative count from bottom
-- @treturn any item that can be put in the bag
function Bag:get( idx )
	libUtil.checkType( 'Bag:get', 1, idx, 'number', true )
	idx = idx or 1
	assert( idx ~= 0, 'Bag:get, idx equal to zero')
	idx = (idx > 0) and (#self._bag - idx + 1) or math.abs( idx )
	return self._bag[idx]
end

--- Export a list of all the contents.
-- @treturn table list of values
function Bag:export()
	local t = {}
	for i,v in ipairs( self._bag ) do
		t[i] = v
	end
	return unpack( t )
end

--- Flush all the contents.
-- Note that this clears the internal storage.
-- @treturn table list of values
function Bag:flush()
	local t = { self:export() }
	self._bag = {}
	return unpack( t )
end

-- Return the final class.
return Bag
