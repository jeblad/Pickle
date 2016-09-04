--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a true boolean type

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
        { '^true$', 0, 0 },
        { '^true[%s%p]', 0, -1 },
        { '[%s%p]true$', 1, 0 },
        { '[%s%p]true[%s%p]', 1, -1 } )
    self._type = 'true'
    return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
function Extractor:cast( str, start, finish )
    return true
end

-- Return the final class
return Extractor
