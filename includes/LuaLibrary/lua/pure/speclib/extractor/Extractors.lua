--- Baseclass for extractors
-- This should be a strategy pattern

local Extractors = {}
function Extractors:__index( key )
    return Extractors[key]
end

---
-- This should take a patteren and a function to do casting
function Extractors.create( ... )
    local self = setmetatable( {}, Extractor )
    self:_init( ... )
    return self
end

function Extractor:_init( pattern, cast )
    self._pattern = pattern
    self._cast = cast
    return self
end

function Extractors.find( str, start )
    assert( str, 'Failed to provide a string' )
    if not mw.extractors.strategies then
    --
    end

    return mw.ustring.find( str, self._pattern, num )
end
