--- Baseclass for constituents

-- @var class var for lib
local Constituent = {}

--- Lookup of missing class members
function Constituent:__index( key )
    return Constituent[key]
end

--- Create a new instance
function Constituent.create( ... )
    local self = setmetatable( {}, Constituent )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function Constituent:_init( ... )
    self._type = 'Constituent'
    return self
end

function Constituent:realize( renders, lang )
    return ''
end

function Constituent:type()
    return self._type
end

-- Return the final class
return Constituent
