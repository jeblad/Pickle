--- Counter for a continuous incrementing number.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Counter

-- pure libs
local libUtil = require 'libraryUtil'

-- @var class for the lib
local Counter = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Counter:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Counter:__index', 1, key, 'string', false )
	return Counter[key]
end

--- Call on instance.
-- Update value, but return the old value.
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number num increment value
-- @treturn number previous value
function Counter:__call( num ) -- luacheck: no self
	libUtil.checkType( 'Counter:__call', 1, num, 'number', true )
	local prev = self:num() or 0
	self._num = prev + (num or 1)
	return prev
end

--- Create a new instance.
-- @raise on wrong arguments
-- @tparam[opt=0] nil|number num initial value
-- @treturn self
function Counter:create( num )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( num )
end

--- Initialize a new instance.
-- @raise on wrong arguments
-- @tparam[opt=0] nil|number num initial value
-- @treturn self
function Counter:_init( num )
	libUtil.checkType( 'Counter:_init', 1, num, 'number', true )
	self._num = num or 0
	return self
end

--- Is the running count initialized.
-- @treturn boolean has the internal structure been initialized
function Counter:isInitialized()
	return not not self._num
end

--- The current value.
-- @treturn number current value
function Counter:num()
	return self._num
end

--- Increment the value.
-- This method will always increment in positive direction.
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number num increment value
-- @treturn number incremented value
function Counter:inc( num )
	libUtil.checkType( 'Counter:inc', 1, num, 'number', true )
	self._num = self._num + math.abs( num or 1 )
	return self._num
end

--- Decrement the value.
-- This method will always decrement in negative direction.
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number num decrement value
-- @treturn number incremented value
function Counter:dec( num )
	libUtil.checkType( 'Counter:dec', 1, num, 'number', true )
	self._num = self._num - math.abs(num or 1)
	return self._num
end

-- Return the final class.
return Counter
