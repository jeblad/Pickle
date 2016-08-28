local Renders = {}
Renders.__index = Renders

Renders._styles = {}

function Renders:__call( style )
    if not Renders._styles[style] then
        Renders._styles[style] = Renders.create( style )
    end
    return Renders._styles[style]
end

function Renders.create( style )
    local self = setmetatable( {}, Renders )
    self:_init( style )
    return self
end

function Renders:_init( style )
    self._style = style
    self._types = {}
    self._types.document = require( 'speclib/render/' .. style .. 'document' )
    self._types.doclet = require( 'speclib/render/' .. style .. 'document' )
    self._types.report = require( 'speclib/render/' .. style .. 'report' )
end

function Renders:find( type )
    return self._types[type]
end

return Renders
