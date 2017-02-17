--- BaseClass for an extractor strategy
-- This should be a strategy pattern

-- pure libs
local Stack = require 'picklelib/Stack'

-- @var class var for lib
local Extractor = {}

--- Lookup of missing class members
function Extractor:__index( key ) -- luacheck: ignore self
	return Extractor[key]
end

--- Create a new instance
-- This should take a patteren and a function to do casting
function Extractor.create( ... )
	local self = setmetatable( {}, Extractor )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Extractor:_init( ... )
	self._patterns = Stack.create()
	for _,v in ipairs( { ... } ) do
		self._patterns:push( v )
	end
	self._type = 'base'
	return self
end

--- Get the type of the strategy
function Extractor:type()
	return self._type
end

--- Try to find the string for this strategy
-- The goodness of the match is given by the returned position
-- If found it should return a position and the found string
function Extractor:find( str, pos )
	assert( str, 'Failed to provide a string' )
	assert( pos, 'Failed to provide a position' )
	for _,v in ipairs( { self._patterns:export() } ) do
		local start, finish = mw.ustring.find( str, v[1], pos-v[2] )
		if start then
			return start+v[2], finish+v[3]
		end
	end
	return nil
end

--- Cast the string into the correct type for this strategy
function Extractor:cast( str, start, finish ) -- luacheck: ignore
	error('Method should be overridden')
	return nil
end

-- Return the final class
return Extractor
