--- Baseclass for constituents

local Constituent = {}
Constituent.__index = Constituent

function Constituent.create( ... )
    local self = setmetatable( {}, Constituent )
    self:_init( ... )
    return self
end

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

return Constituent
