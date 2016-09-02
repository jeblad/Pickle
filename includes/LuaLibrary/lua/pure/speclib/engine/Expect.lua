--- Subclass to do specialization of the Adapt class
-- This is the spesialization to register access to expectations

-- pure libs
local Stack = require 'speclib/Stack'

-- non-pure libs
local Adapt
if mw.spec then
    -- structure exist, make access simpler
    Adapt = mw.spec.adapt
else
    -- structure does not exist, require the libs
    Adapt = require 'speclib/engine/Adapt'
end

-- @var class var for lib
local Expect = {}
function Expect:__index( key )
    return Expect[key]
end

-- @var metatable for the class
local mt = { __index = Adapt }

--- Get a clone or create a new instance
function mt:__call( ... )
    local t = { ... }
    Expect.stack:push( #t == 0 and Expect.stack:top() or Expect.create( ... ) )
    return Expect.stack:top()
end

setmetatable( Expect, mt )

-- @var class var for stack, holding references to defined expects
Expect.stack = Stack.create()

-- @var class var for other, holding a reference to the subjects
Expect.other = nil

--- Create a new instance
function Expect.create( ... )
    local self = setmetatable( {}, Expect )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function Expect:_init( ... )
    Adapt._init( self, ... )
    if Expect.other ~= nil then
        self._other = Expect.other
    end
    return self
end

-- Return the final class
return Expect
