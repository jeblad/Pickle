--- Subclass for plan renderer

-- pure libs
local Base = require 'picklelib/render/PlanRenderBase'

-- @var class var for lib
local PlanRender = {}

--- Lookup of missing class members
function PlanRender:__index( key )
    return PlanRender[key]
end

-- @var metatable for the class
setmetatable( PlanRender, { __index = Base } )

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
    assert( str, 'Failed to provide a string' )
    return 'pickle-report-plan-full-compact-' .. str
end

-- Return the final class
return PlanRender
