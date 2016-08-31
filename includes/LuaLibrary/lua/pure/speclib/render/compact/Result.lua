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
    return 'spec-report-compact-' .. str
end

function Render:realizeBody( src, lang )

    if src:isOk() then
        return ''
    end

    local t = {}

    if not src:isOk() then
        for _,v in ipairs( { src:lines() } ) do
            table.insert( t, self:realizeLine( v, lang ) )
        end
    end

    return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end


return Render
