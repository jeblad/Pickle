--- Subclass for results

-- pure libs
local Stack = require 'speclib/Stack'

-- non-pure libs
local Constituent
if mw.spec then
    -- structure exist, make access simpler
    Constituent = mw.spec.constituent
else
    -- structure does not exist, require the libs
    Constituent = require 'speclib/report/Constituent'
end

-- @var class var for lib
local Result = {}

--- Lookup of missing class members
function Result:__index( key )
    return Result[key]
end

-- @var metatable for the class
setmetatable( Result, { __index = Constituent } )

--- Create a new instance
function Result.create( ... )
    local self = setmetatable( {}, Result )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function Result:_init( ... )
    Constituent._init( self )
    self._description = false
    self._lines = Stack.create()
    self._state = false
    self._skip = false
    self._todo = false
    self._lang = false
    self._lines:push( ... )
    self._type = 'Result'
    return self
end

--- Export the lines as an multivalue return
-- Note that each line is not unwrapped.
function Result:lines()
    return self._lines:export()
end

--- Get the number of lines
function Result:numLines()
    local t = { self._lines:export() }
    return #t
end

--- Add a line
-- Note that all arguments will be wrapped up in a table before saving.
function Result:addLine( ... )
    self._lines:push( { ... } )
    return self
end

--- Set the state as not ok
-- Note that initial state is not ok.
function Result:notOk()
    self._state = false
    return self
end

--- Set the state as ok
-- Note that initial state is not ok.
function Result:ok()
    self._state = true
    return self
end

--- Check if the instance state is ok
-- Note that initial state is not ok.
function Result:isOk()
    return self._state
end

--- Set the description
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
function Result:setDescription( str )
    assert( str, 'Failed to provide a description' )
    self._description = str
    return self
end

--- Get the description
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
function Result:getDescription()
    return self._description
end

--- Check if the instance has any description member
function Result:hasDescription()
    return not not self._description
end

--- Set the skip
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
function Result:setSkip( ... )
    local t = { ... }
    assert( #t >= 1, 'Failed to provide a skip' )
    self._skip = t
    return self
end

--- Get the skip
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
function Result:getSkip()
    return unpack( self._skip )
end

--- Check if the instance has any skip member
function Result:hasSkip()
    return not not self._skip
end

--- Set the todo
-- This is an accessor to set the member.
function Result:setTodo( str )
    assert( str, 'Failed to provide a todo' )
    self._todo = str
    return self
end

--- Get the todo
-- This is an accessor to get the member.
function Result:getTodo()
    return self._todo
end

--- Check if the instance has any todo member
function Result:hasTodo()
    return not not self._todo
end

--- Realize the data by applying a render
function Result:realize( renders, lang )
    assert( renders, 'Failed to provide renders' )
    return ''
        .. renders:realizeHeader( self, lang )
        .. renders:realizeBody( self, lang )
end

-- Return the final class
return Result
