--- Class for an extractor strategy
-- This should be a strategy pattern

-- @var class var for lib
local ExtractorStrategy = {}

--- Lookup of missing class members
function ExtractorStrategy:__index( key )
    return ExtractorStrategy[key]
end

--- Create a new instance
-- This should take a patteren and a function to do casting
function ExtractorStrategy.create( ... )
    local self = setmetatable( {}, ExtractorStrategy )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function ExtractorStrategy:_init( pattern, cast )
    self._pattern = pattern
    self._cast = cast
    return self
end

--- Try to find the strategy
-- The goodness of the match is given by the returned position
-- If found it should return a position and the found string
function ExtractorStrategy:find( str, pos )
    assert( str, 'Failed to provide a string' )
    assert( pos, 'Failed to provide a position' )
    return mw.ustring.find( str, self._pattern, start )
end

--- Cast a string into the correct type for this strategy
-- There are no safeguards for erroneous casts
function ExtractorStrategy:cast( str )
    assert( str, 'Failed to provide a string' )
    return self._cast( str )
end

-- Return the final class
return ExtractorStrategy
