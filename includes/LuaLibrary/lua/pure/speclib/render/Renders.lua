-- Class for render strategies

-- @var class var for lib
local Renders = {}

--- Lookup of missing class members
function Renders:__index( key )
    return Renders[key]
end

-- @var class var for styles, holding references to created renders
Renders._styles = {}

--- Convenience function to access a specific style
-- This will try to create the style if it isn't created yet.'
function Renders:__call( style )
    if not Renders._styles[style] then
        Renders._styles[style] = Renders.create( style )
    end
    return Renders._styles[style]
end

--- Create a new instance
function Renders.create( style )
    local self = setmetatable( {}, Renders )
    self:_init( style )
    return self
end

--- Initialize a new instance
function Renders:_init( style )
    self._style = style
    self._types = {}
    self._types.document = require( 'speclib/render/' .. style .. 'document' )
    self._types.doclet = require( 'speclib/render/' .. style .. 'document' )
    self._types.report = require( 'speclib/render/' .. style .. 'report' )
end

--- Find render of the correct type
-- This will typically be "Result" or "Plan".
function Renders:find( type )
    assert( type, 'Failed to provide a type' )
    return self._types[type]
end

-- Return the final class
return Renders
