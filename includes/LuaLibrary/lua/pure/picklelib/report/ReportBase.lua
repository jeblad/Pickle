--- Baseclass for reports

-- @var class var for lib
local Report = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Report:__index( key ) -- luacheck: no self
	return Report[key]
end

--- Create a new instance
-- @param vararg unused
-- @return Report
function Report.create( ... )
	local self = setmetatable( {}, Report )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Report
function Report:_init( ... ) -- luacheck: no unused args
	self._skip = false
	self._todo = false
	self._state = true
	self._type = 'base-report'
	return self
end

--- Set the state unconditionally as "not ok""
-- Note that initial state is not ok.
-- @return self
function Report:notOk()
	self._state = false
	return self
end

--- Set the state unconditionally as "ok""
-- Note that initial state is not ok.
-- @return self
function Report:ok()
	self._state = true
	return self
end

--- Check if the instance state is "ok""
-- Note that initial state is not ok.
-- @return boolean that is set if state is "ok"
function Report:isOk()
	return self._state
end

--- Set the skip
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @param string that will be used as the skip note
-- @return self
function Report:setSkip( str )
	assert( str, 'Failed to provide a skip' )
	self._skip = str
	return self
end

--- Get the skip
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @return string used as the skip note
function Report:getSkip()
	return self._skip
end

--- Check if the instance is itself in a skip state
-- @return boolean that is set if a skip note exist
function Report:isSkip()
	return not not self._skip
end

--- Set the todo
-- This is an accessor to set the member.
-- @param string that will be used as the todo note
-- @return self
function Report:setTodo( str )
	assert( str, 'Failed to provide a todo' )
	self._todo = str
	return self
end

--- Get the todo
-- This is an accessor to get the member.
-- @return string used as the todo note
function Report:getTodo()
	return self._todo
end

--- Check if the instance is itself in a todo state
-- @return boolean that is set if a skip note exist
function Report:isTodo()
	return not not self._todo
end

--- Realize the data by applying a render
-- @param Renders to use while realizing the reports
-- @param string holding the language code
function Report:realize( renders, lang ) -- luacheck: ignore
	-- @todo this should probably return an error
	-- error('Method should be overridden')
	return ''
end

--- Get the type of report
-- All reports has an explicit type name.
-- @return string
function Report:type()
	return self._type
end

-- Return the final class
return Report
