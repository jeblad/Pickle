--- Subclass to do specialization of the Adapt class
-- This is the spesialization to register access to expectations

local Adapt = require 'speclib/engine/Adapt'
local Stack = require 'speclib/Stack'

local Expect = {}
--Expect.__index = Expect
function Expect:__index( key )
    return Expect[key]
end

local mt = { __index = Adapt }

function mt:__call( ... )
    local t = { ... }
    Expect.stack:push( #t == 0 and Expect.stack:top() or Expect.create( ... ) )
    return Expect.stack:top()
end

setmetatable( Expect, mt )

-- @var stack holding the references to defined Expects
Expect.stack = Stack.create()

Expect.other = nil

function Expect.create( ... )
    local self = setmetatable( {}, Expect )
    self:_init( ... )
    return self
end

function Expect:_init( ... )
    Adapt._init( self, ... )
    if Expect.other ~= nil then
        self._other = Expect.other
    end
    return self
end

return Expect
