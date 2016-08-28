--- Subclass for plans

local Constituent = require 'speclib/report/Constituent'
local Stack = require 'speclib/Stack'

local Plan = {}
Plan.__index = Plan

-- @todo not sure about this
Plan._plans = nil

function Plan:__call()
    if not self._plans:empty() then
        self._plans:push( Plan.create() )
    end
    return self._plans:top()
end

setmetatable( Plan, { __index = Constituent } )

function Plan.create( ... )
    local self = setmetatable( {}, Plan )
    self:_init( ... )
    return self
end

function Plan:_init( ... )
    Constituent._init( self, ... )
    self._constituents = Stack.create()
    self._type = 'Plan'
    return self
end

function Plan:addConstituent( part )
    assert( part, 'Failed to provide a constituent' )
    self._constituents:push( part )
    return self
end

function Plan:constituents()
    return self._constituents:export()
end

function Plan:realize( renders, lang )
    assert( part, 'Failed to provide renders' )
    local out = renders:find( self:type() ):realizeHeader( self, lang )
    for _,v in ipairs( self:constituents() ) do
        out = out .. v:realize( renders, lang )
    end
    return out
end

return Plan