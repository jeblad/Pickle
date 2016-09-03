--- Baseclass for extractor strategies
-- This should be a strategy pattern

local ExtractorStrategies = {}
function ExtractorStrategies:__index( key )
    return ExtractorStrategies[key]
end

-- @var class var for strategies, holding reference to defined extractor strategies
ExtractorStrategies.strategies = Stack.create()

---
-- This should take a patteren and a function to do casting
function ExtractorStrategies.create( ... )
    local self = setmetatable( {}, Extractor )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function ExtractorStrategies:_init( ... )
    return self
end

function ExtractorStrategies.find( str, pos )
    assert( str, 'Failed to provide a string' )
    local first, strategy = mw.ustring.len( str ) + 1, nil
    for _,v in ipairs( mw.extractors.strategies:export() ) do
        local start, finish = v:find( str, pos )
        if start<first then
            strategy = v
        end
    end

    return strategy
end

-- Return the final class
return ExtractorStrategies
