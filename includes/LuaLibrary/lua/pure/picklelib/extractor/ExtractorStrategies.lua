--- Baseclass for extractor strategies
-- This should be a strategy pattern

-- pure libs
local Stack = require 'picklelib/Stack'

local Extractors = {}
function Extractors:__index( key ) -- luacheck: ignore self
	return Extractors[key]
end

-- @var class var for strategies, holding reference to defined extractor strategies
Extractors.strategies = Stack.create()

---
-- This should take a patteren and a function to do casting
function Extractors.create( ... )
	local self = setmetatable( {}, Extractors )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Extractors:_init( ... )
	self._strategies = Stack.create()
	for _,v in ipairs( { ... } ) do
		self:register( v )
	end
	return self
end

function Extractors:register( strategy )
	self._strategies:push( strategy )
	return self
end

function Extractors:find( str, pos )
	--assert( str, 'Failed to provide a string' )
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

-- Return the final class
return Extractors
