--- Subclass for results

local Constituent = require 'speclib/report/Constituent'
local Stack = require 'speclib/Stack'

local Result = {}
Result.__index = Result

setmetatable( Result, { __index = Constituent } )

function Result.create( ... )
    local self = setmetatable( {}, Result )
    self:_init( ... )
    return self
end

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

function Result:lines()
    return self._lines:export()
end

function Result:numLines()
    local t = { self._lines:export() }
    return #t
end

function Result:addLine( ... )
    self._lines:push( { ... } )
    return self
end

function Result:notOk()
    self._state = false
    return self
end

function Result:ok()
    self._state = true
    return self
end

function Result:isOk()
    return self._state
end

function Result:setDescription( ... )
    self._description = { ... }
    return self
end

function Result:getDescription()
    return self._description
end

function Result:hasDescription()
    return not not self._description
end

function Result:setSkip( ... )
    self._skip = { ... }
    return self
end

function Result:getSkip()
    return unpack( self._skip )
end

function Result:hasSkip()
    return not not self._skip
end

function Result:setTodo( str )
    self._todo = str
    return self
end

function Result:getTodo()
    return self._todo
end

function Result:hasTodo()
    return not not self._todo
end

function Result:realize( renders, lang )
    return '' .. render:realizeHeader( self, lang ) .. render:realizeBody( self, lang )
end

return Result
