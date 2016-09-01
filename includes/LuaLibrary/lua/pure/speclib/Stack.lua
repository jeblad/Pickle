local Stack = {}
Stack.__index = Stack
--[[
function Stack:__index( key )
    return Stack[key]
end
]]
function Stack.create( ... )
    local self = setmetatable( {}, Stack )
    self:_init( ... )
    return self
end

function Stack:_init( ... )
    self._stack = {}
    self:push( ... )
    return self
end

function Stack:isEmpty()
    return #self._stack == 0
end

function Stack:depth()
    return #self._stack
end

function Stack:layout()
    local t = {}
    for i,v in ipairs( self._stack ) do
        t[i] = type( v )
    end
    return t
end

function Stack:bottom()
    return self._stack[1]
end

function Stack:top()
    return self._stack[#self._stack]
end

function Stack:push( ... )
    for _,v in ipairs( { ... } ) do
        table.insert( self._stack, v )
    end
    return self
end

function Stack:pop()
    table.remove( self._stack )
    return self
end

function Stack:export()
    local t = {}

    for i,v in ipairs( self._stack ) do
        t[i] = v
    end

    return unpack( t )
end

function Stack:flush()
    local t = { self:export() }

    self._stack = {}

    return unpack( t )
end

return Stack
