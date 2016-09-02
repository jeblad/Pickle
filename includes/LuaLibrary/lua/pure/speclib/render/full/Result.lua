--- Subclass for report renderer

-- pure libs
local Base = require 'speclib/render/ResultBase'

-- @var class var for lib
local Render = {}

--- Lookup of missing class members
function Render:__index( key )
    return Render[key]
end

-- @var metatable for the class
setmetatable( Render, { __index = Base } )

--- Create a new instance
function Render.create( ... )
    local self = setmetatable( {}, Render )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function Render:_init( ... )
    return self
end

--- Override key construction
function Render:key( str )
    assert( str, 'Failed to provide a string' )
    return 'spec-report-full-' .. str
end

-- Return the final class
return Render
