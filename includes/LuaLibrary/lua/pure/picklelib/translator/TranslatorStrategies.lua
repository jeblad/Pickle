--- Class for extractor strategies
-- This should be a strategy pattern

-- @var class var for lib
local Translators = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Translators:__index( key ) -- luacheck: no self
	return Translators[key]
end

--- Create a new instance
-- @param vararg list of strategies
-- @return self
function Translators.create( ... )
	local self = setmetatable( {}, Translators )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg list of strategies
-- @return self
function Translators:_init()
	self._strategies = {}
	return self
end

--- Register a new strategy
-- @param strategy to be registered
-- @return self
function Translators:register( str, strategy )
	self._strategies[ str ] = strategy
	return self
end

--- Removes all registered translators
-- @return self
function Translators:flush()
	self._strategies = {}
	return self
end

--- Find a matching extractor
-- @exception On missing source
-- @param string used as the key for a translator
-- @return strategy, first, last
function Translators:find( str )
	assert( str )

	return self._strategies[ str ]
end

-- Return the final class
return Translators
