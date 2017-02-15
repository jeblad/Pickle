--- Subclass to do specialization of the Adapt class
-- This is the spesialization to register access to subjects

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local Adapt
if mw.pickle then
    -- structure exist, make access simpler
    Adapt = mw.pickle.adapt
else
    -- structure does not exist, require the libs
    Adapt = require 'picklelib/engine/Adapt'
end

-- @var class var for lib
local Subject = {}

--- Lookup of missing class members
function Subject:__index( key )
    return Subject[key]
end

-- @var metatable for the class
local mt = { __index = Adapt }

--- Get a clone or create a new instance
function mt:__call( ... )
    local t = { ... }
    Subject.stack:push( #t == 0 and Subject.stack:top() or Subject.create( t ) )
    return Subject.stack:top()
end

setmetatable( Subject, mt )

-- @var class var for stack, holding a references to defined subjects
Subject.stack = Stack.create()

-- @var class var for other, holding a reference to the expects
Subject.other = nil

--- Create a new instance
function Subject.create( ... )
    local self = setmetatable( {}, Subject )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function Subject:_init( ... )
    Adapt._init( self, ... )
    if Subject.other ~= nil then
        self._other = Subject.other
    end
    self._reorder = function( a, b ) return b, a end
    return self
end

-- Return the final class
return Subject
