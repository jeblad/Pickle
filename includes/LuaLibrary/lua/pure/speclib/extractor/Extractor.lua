--- Baseclass for extractor
-- This should be a strategy pattern

-- @var class var for lib
local Extractor = {}

--- Lookup of missing class members
function Extractor:__index( key )
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
function Extractor:_init( pattern, cast )
    self._pattern = pattern
    self._cast = cast
    return self
end

--- Try to find the strategy
-- The goodness of the match is given by the returned position
-- If found it should return a position and the found string
function Extractor:find( str, pos )
    assert( str, 'Failed to provide a string' )
    assert( pos, 'Failed to provide a position' )
    return mw.ustring.find( str, self._pattern, start )
end

--- Cast a string into the correct type for this strategy
-- There are no safeguards for erroneous casts
function Extractor:cast( str )
    assert( str, 'Failed to provide a string' )
    return self._cast( str )
end
