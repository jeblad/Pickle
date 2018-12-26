--- Subclass for tidings

-- @var class var for lib
local Tiding = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Tiding:__index( key ) -- luacheck: no self
	return Tiding[key]
end

-- @todo not sure about this
Tiding._reports = nil

-- @todo verify if this is actually used
function Tiding:__call()
	if not self._reports:empty() then
		self._reports:push( Tiding.create() )
	end
	return self._reports:top()
end

--- Create a new instance
-- @param vararg unused
-- @return Tiding
function Tiding.create( ... )
	local self = setmetatable( {}, Tiding )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Tiding
function Tiding:_init( ... ) -- luacheck: ignore
	self._skip = false
	self._todo = false
	self._type = 'tiding-report'
	return self
end

--- Check if the instance has any skip or todo
-- Note that initial state is "not ok".
-- @todo the initial state is not correct
-- @return boolean state
function Tiding:hasComment()
	return self:isSkip() or self:isTodo()
end

--- Set the skip
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @param {message|phrase} that will be used as the skip note
-- @return self
function Tiding:setSkip( str )
	assert( str )
	self._skip = str
	return self
end

--- Get the skip
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @return string used as the skip note
function Tiding:getSkip()
	return self._skip
end

--- Check if the instance is itself in a skip state
-- @return boolean that is set if a skip note exist
function Tiding:isSkip()
	return not not self._skip
end

--- Set the todo
-- This is an accessor to set the member.
-- @param {message|phrase} that will be used as the todo note
-- @return self
function Tiding:setTodo( str )
	assert( str )
	self._todo = str
	return self
end

--- Get the todo
-- This is an accessor to get the member.
-- @return string used as the todo note
function Tiding:getTodo()
	return self._todo
end

--- Check if the instance is itself in a todo state
-- @return boolean that is set if a skip note exist
function Tiding:isTodo()
	return not not self._todo
end

--- Realize the data by applying a render
-- @todo fix this
-- @param Renders to use while realizing the reports
-- @param string holding the language code
function Tiding:realize( renders, lang )
	assert( renders )


	local styles = renders:find( self:type() )
	local out = styles:realizeHeader( self, lang )

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			out = styles:append( out, v:realize( renders, lang ) )
		end
	end

	return out
end

-- Return the final class
return Tiding
