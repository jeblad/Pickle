--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a number type

-- pure libs
local Base = require 'speclib/extractor/ExtractorStrategyBase'

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
        { '^[-+]?%d+%.%d+$', 0, 0 },
        { '^[-+]?%d+%.%d+[%s%p]', 0, -1 },
        { '[%s%p][-+]?%d+%.%d+$', 1, 0 },
        { '[%s%p][-+]?%d+%.%d+[%s%p]', 1, -1 },
        { '^[-+]?%d+$', 0, 0 },
        { '^[-+]?%d+[%s%p]', 0, -1 },
        { '[%s%p][-+]?%d+$', 1, 0 },
        { '[%s%p][-+]?%d+[%s%p]', 1, -1 } )
    self._type = 'number'
    return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
function Extractor:cast( str, start, finish )
    if not finish then
        start, finish = self:find( str, (start or 1) )
    end
    return tonumber( mw.ustring.sub( str, start, finish ) )
end

-- Return the final class
return Extractor
