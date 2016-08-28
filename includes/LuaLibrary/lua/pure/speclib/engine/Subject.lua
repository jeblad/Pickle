--- Subclass to do specialization of the Adapt class
-- This is the spesialization to register access to expectations

local Adapt = require 'speclib/engine/Adapt'
local Stack = require 'speclib/Stack'

local Subject = {}
--Subject.__index = Subject
function Subject:__index( key )
    return Subject[key]
end

local mt = { __index = Adapt }

function mt:__call( ... )
    local t = { ... }
    Subject.stack:push( #t == 0 and Subject.stack:top() or Subject.create( t ) )
    return Subject.stack:top()
end

setmetatable( Subject, mt )

-- @var stack holding the references to defined subjects
Subject.stack = Stack.create()

Subject.other = nil

function Subject.create( ... )
    local self = setmetatable( {}, Subject )
    self:_init( ... )
    return self
end

function Subject:_init( ... )
    Adapt._init( self, ... )
    if Subject.other ~= nil then
        self._other = Subject.other
    end
    self._reorder = function( a, b ) return b, a end
    return self
end

return Subject
