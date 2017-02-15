--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a string type

-- pure libs
local Base = require 'picklelib/extractor/ExtractorStrategyBase'

-- @var class var for lib
local Extractor = {}
function Extractor:__index( key )
    return Extractor[key]
end

-- @var metatable for the class
setmetatable( Extractor, { __index = Base } )

--- Create a new instance
function Extractor.create()
    local self = setmetatable( {}, Extractor )
    self:_init()
    return self
end

--- Initialize a new instance
function Extractor:_init()
    Base._init( self,
        { '%b{}', 0, 0 },
        { '%b[]', 0, 0 } )
    self._type = 'json'
    return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
function Extractor:cast( str, start, finish )
    if not finish then
        start, finish = self:find( str, (start or 2) -1 )
    end

    local jsonStr = mw.ustring.sub( str, start, finish )
    assert( jsonStr, 'Failed to identify a substring' )

    local json = mw.text.jsonDecode( jsonStr )
    assert( str, 'Failed to decode assumed json' )

    return json
end

-- Return the final class
return Extractor
