--- Baseclass for plan renderer

--[[
-- Wrong place, should be in Frame
-- non-pure libs
local Extractors
if mw.pickle then
    -- structure exist, make access simpler
    Extractors = mw.pickle.extractors
else
    -- structure does not exist, require the libs
    Extractors = require 'picklelib/engine/ExtractorStrategies'
end
--]]

-- @var class var for lib
local PlanRender = {}

--- Lookup of missing class members
function PlanRender:__index( key )
    return PlanRender[key]
end

--- Create a new instance
function PlanRender.create( ... )
    local self = setmetatable( {}, PlanRender )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function PlanRender:_init( ... )
    return self
end

--- Override key construction
function PlanRender:key( str )
    error('Method should be overridden')
    return nil
end

--- Realize reported data for header
-- The "header" is a composite.
function PlanRender:realizeHeader( src, lang )
    assert( src, 'Failed to provide a source' )

    --local t = { self:realizeState( src, lang ) }
    local t = {  }
--[[
    if src:hasDescription() then
        table.insert( t, self:realizeDescription( src, lang ) )
    end

    if src:hasSkip() or src:hasTodo() then
        table.insert( t, '# ' )
        table.insert( t, self:realizeSkip( src, lang ) )
        table.insert( t, self:realizeTodo( src, lang ) )
    end
--]]
    return table.concat( t, '' )
end

-- Return the final class
return PlanRender
