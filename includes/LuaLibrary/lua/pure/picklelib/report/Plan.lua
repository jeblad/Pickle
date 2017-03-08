--- Subclass for plans

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local Constituent
if mw.pickle then
	-- structure exist, this is production, make access simpler
	Constituent = mw.pickle.constituent
else
	-- structure does not exist, this is test, require the libs
	Constituent = require 'picklelib/report/Constituent'
end

-- @var class var for lib
local Plan = {}

--- Lookup of missing class members
function Plan:__index( key ) -- luacheck: ignore self
	return Plan[key]
end

-- @var metatable for the class
local mt = { __index = Constituent }

--- Get a clone or create a new instance
function mt:__call( ... ) -- luacheck: ignore
	local t = { ... }
	if not Plan.stack then
		Plan.stack = Stack.create()
	end
	Plan.stack:push( #t == 0 and Plan.stack:top() or Plan.create( ... ) )
	return Plan.stack:top()
end

-- @var metatable for the class
setmetatable( Plan, mt )

--- Create a new instance
function Plan.create( ... )
	local self = setmetatable( {}, Plan )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Plan:_init( ... )
	Constituent._init( self, ... )
	self._constituents = Stack.create()
	self._description = false
	self._skip = false
	self._todo = false
	self._type = 'plan'
	return self
end

--- Add a constituent
function Plan:addConstituent( part )
	assert( part, 'Failed to provide a constituent' )
	self._constituents:push( part )
	return self
end

--- Export the constituents as an multivalue return
-- Note that each constituent is not unwrapped.
function Plan:constituents()
	return self._constituents:export()
end

--- Set the description
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
function Plan:setDescription( str )
	assert( str, 'Failed to provide a description' )
	self._description = str
	return self
end

--- Get the description
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
function Plan:getDescription()
	return self._description
end

--- Check if the instance has any description member
function Plan:hasDescription()
	return not not self._description
end

--- Set the skip
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
function Plan:setSkip( ... )
	local t = { ... }
	assert( #t >= 1, 'Failed to provide a skip' )
	self._skip = t
	return self
end

--- Get the skip
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
function Plan:getSkip()
	return unpack( self._skip )
end

--- Check if the instance has any skip member
function Plan:hasSkip()
	return not not self._skip
end

--- Set the todo
-- This is an accessor to set the member.
function Plan:setTodo( str )
	assert( str, 'Failed to provide a todo' )
	self._todo = str
	return self
end

--- Get the todo
-- This is an accessor to get the member.
function Plan:getTodo()
	return self._todo
end

--- Check if the instance has any todo member
function Plan:hasTodo()
	return not not self._todo
end

--- Realize the data by applying a render
function Plan:realize( renders, lang )
	assert( renders, 'Failed to provide renders' )
	local out = renders:find( self:type() ):realizeHeader( self, lang )
	for _,v in ipairs( self:constituents() ) do
		out = out .. v:realize( renders, lang )
	end
	return out
end

-- Return the final class
return Plan
