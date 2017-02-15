--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/ResultRenderBase'

-- @var class var for lib
local ResultRender = {}

--- Lookup of missing class members
function ResultRender:__index( key )
    return ResultRender[key]
end

-- @var metatable for the class
setmetatable( ResultRender, { __index = Base } )

--- Create a new instance
function ResultRender.create( ... )
    local self = setmetatable( {}, ResultRender )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function ResultRender:_init( ... )
    return self
end

--- Override key construction
function ResultRender:key( str )
    assert( str, 'Failed to provide a string' )
    return 'pickle-report-result-compact-' .. str
end

--- Override realization of reported data for body
function ResultRender:realizeBody( src, lang )
    assert( src, 'Failed to provide a source' )

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

-- Return the final class
return ResultRender
