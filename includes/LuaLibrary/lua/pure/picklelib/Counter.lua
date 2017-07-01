-- Class for the running count

-- @var class for the lib
local Counter = {}

--- Lookup of missing class members
function Counter:__index( key ) -- luacheck: no self
	return Counter[key]
end

--- Call on instance
function Counter:__call() -- luacheck: no self
	local prev = self:num() or 0
	self:inc()
	return prev
end

--- Create a new instance
function Counter.create( num )
	local self = setmetatable( {}, Counter )
	self:_init( num )
	return self
end

--- Initialize a new instance
function Counter:_init( num )
	self._num = num or false
	return self
end

--- Is the running count initialized
-- @return boolean saying whether the internal structure has been initialized
function Counter:isInitialized()
	return not not self._num
end

--- The current value
-- @return int current value
function Counter:num()
	return self._num
end

--- Increment the value
-- @return int incremented value
function Counter:inc()
	if not self._num then
		self._num = 0
	end
	self._num = 1 + self._num
	return self._num
end

-- Return the final class
return Counter
