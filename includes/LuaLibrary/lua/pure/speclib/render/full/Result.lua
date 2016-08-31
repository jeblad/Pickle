--- Subclass for report renderer

local Base = require 'speclib/render/ResultBase'

local Render = {}
Render.__index = Render

setmetatable( Render, { __index = Base } )

function Render.create( ... )
    local self = setmetatable( {}, Render )
    self:_init( ... )
    return self
end

function Render:_init( ... )
    return self
end

function Render:key( str )
    return 'spec-report-full-' .. str
end

return Render
