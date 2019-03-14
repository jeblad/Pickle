--- Baseclass for extractor strategies.
-- This should be a strategy pattern
-- @classmod ExtractorStrategies
-- @alias Extractors

-- pure libs
local Stack = require 'picklelib/Stack'

-- @var class var for lib
local Extractors = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Extractors:__index( key ) -- luacheck: no self
	return Extractors[key]
end

-- @var class var for strategies, holding reference to defined extractor strategies
Extractors.strategies = Stack.create()

--- Create a new instance.
-- @tparam vararg ... list of strategies
-- @treturn self
function Extractors.create( ... )
	local self = setmetatable( {}, Extractors )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... list of strategies
-- @treturn self
function Extractors:_init( ... )
	self._strategies = Stack.create()
	for _,v in ipairs( { ... } ) do
		self:register( v )
	end
	return self
end

--- Register a new strategy.
-- @param strategy to be registered
-- @treturn self
function Extractors:register( strategy )
	self._strategies:push( strategy )
	return self
end

--- Removes all registered extractors.
-- @treturn self
function Extractors:flush()
	self._strategies:flush()
	return self
end

--- The number of registered extractors.
-- @treturn number
function Extractors:num()
	return self._strategies:depth()
end

--- Find a matching extractor.
-- @todo fix pos
-- @raise On missing source
-- @tparam string str used as the extraction source
-- @tparam number pos for an inclusive index where extraction starts
-- @treturn strategy,first,last
function Extractors:find( str, pos )
	-- @todo figure out if it should be valid to not provide a string
	assert( str, 'Failed to provide a string' )
	local first = mw.ustring.len( str ) + 1
	local last
	local strategy = nil
	for _,v in ipairs( { self._strategies:export() } ) do
		local start, finish = v:find( str, pos or 1 )
		if start and start<first then
			first = start
			last = finish
			strategy = v
		end
	end

	if strategy then
		return strategy, first, last
	end
	return nil
end

-- Return the final class.
return Extractors
