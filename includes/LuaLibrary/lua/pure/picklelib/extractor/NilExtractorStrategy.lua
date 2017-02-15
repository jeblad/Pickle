--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a nil type

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
        { '^nil$', 0, 0 },
        { '^nil[%s%p]', 0, -1 },
        { '[%s%p]nil$', 1, 0 },
        { '[%s%p]nil[%s%p]', 1, -1 } )
    self._type = 'nil'
    return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
function Extractor:cast( str, start, finish )
    return nil
end

-- Return the final class
return Extractor
