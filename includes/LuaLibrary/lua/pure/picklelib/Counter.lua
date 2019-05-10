--- Counter for a continuous incrementing number.
-- @classmod Counter

-- @var class for the lib
local Counter = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function Counter:__index( key ) -- luacheck: no self
	return Counter[key]
end

--- Call on instance.
-- Update value, but return the old value.
-- @tparam[opt] number num increment value
-- @treturn number previous value
function Counter:__call( num ) -- luacheck: no self
	local prev = self:num() or 0
	self._num = prev + (num or 1)
	return prev
end

--- Create a new instance.
-- @tparam[opt] number num initial value
-- @treturn self
function Counter:create( num )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( num )
end

--- Initialize a new instance.
-- @local
-- @tparam[opt] number num initial value
-- @treturn self
function Counter:_init( num )
	self._num = num or false
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
-- @tparam[opt] number num increment value
-- @treturn number incremented value
function Counter:inc( num )
	if not self._num then
		self._num = 0
	end
	self._num = self._num + math.abs( num or 1 )
	return self._num
end

--- Decrement the value.
-- This method will always decrement in negative direction.
-- @tparam[opt] number num decrement value
-- @treturn number incremented value
function Counter:dec( num )
	if not self._num then
		self._num = 0
	end
	self._num = self._num - math.abs(num or 1)
	return self._num
end

-- Return the final class.
return Counter
