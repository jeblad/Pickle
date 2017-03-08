--- Subclass for adapt plan

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local Constituent
if mw.pickle then
	-- structure exist, make access simpler
	Constituent = mw.pickle.constituent
else
	-- structure does not exist, require the libs
	Constituent = require 'picklelib/report/Constituent'
end

-- @var class var for lib
local AdaptPlan = {}

--- Lookup of missing class members
function AdaptPlan:__index( key ) -- luacheck: ignore self
	return AdaptPlan[key]
end

-- @var metatable for the class
setmetatable( AdaptPlan, { __index = Constituent } )

--- Create a new instance
function AdaptPlan.create( ... )
	local self = setmetatable( {}, AdaptPlan )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function AdaptPlan:_init( ... )
	Constituent._init( self )
	self._description = false
	self._lines = Stack.create()
	self._state = false
	self._skip = false
	self._todo = false
	self._lang = false
	self._lines:push( ... )
	self._type = 'adapt-plan'
	return self
end

--- Export the lines as an multivalue return
-- Note that each line is not unwrapped.
function AdaptPlan:lines()
	return self._lines:export()
end

--- Get the number of lines
function AdaptPlan:numLines()
	local t = { self._lines:export() }
	return #t
end

--- Add a line
-- Note that all arguments will be wrapped up in a table before saving.
function AdaptPlan:addLine( ... )
	self._lines:push( { ... } )
	return self
end

--- Set the state as not ok
-- Note that initial state is not ok.
function AdaptPlan:notOk()
	self._state = false
	return self
end

--- Set the state as ok
-- Note that initial state is not ok.
function AdaptPlan:ok()
	self._state = true
	return self
end

--- Check if the instance state is ok
-- Note that initial state is not ok.
function AdaptPlan:isOk()
	return self._state
end

--- Set the description
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
function AdaptPlan:setDescription( str )
	assert( str, 'Failed to provide a description' )
	self._description = str
	return self
end

--- Get the description
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
function AdaptPlan:getDescription()
	return self._description
end

--- Check if the instance has any description member
function AdaptPlan:hasDescription()
	return not not self._description
end

--- Set the skip
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
function AdaptPlan:setSkip( ... )
	local t = { ... }
	assert( #t >= 1, 'Failed to provide a skip' )
	self._skip = t
	return self
end

--- Get the skip
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
function AdaptPlan:getSkip()
	return unpack( self._skip )
end

--- Check if the instance has any skip member
function AdaptPlan:hasSkip()
	return not not self._skip
end

--- Set the todo
-- This is an accessor to set the member.
function AdaptPlan:setTodo( str )
	assert( str, 'Failed to provide a todo' )
	self._todo = str
	return self
end

--- Get the todo
-- This is an accessor to get the member.
function AdaptPlan:getTodo()
	return self._todo
end

--- Check if the instance has any todo member
function AdaptPlan:hasTodo()
	return not not self._todo
end

--- Realize the data by applying a render
function AdaptPlan:realize( renders, lang )
	assert( renders, 'Failed to provide renders' )
	return ''
		.. renders:realizeHeader( self, lang )
		.. renders:realizeBody( self, lang )
end

-- Return the final class
return AdaptPlan
