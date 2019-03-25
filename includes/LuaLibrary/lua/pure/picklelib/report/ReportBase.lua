--- Baseclass for reports.
-- @classmod ReportBase
-- @alias Report

-- @var class var for lib
local Report = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function Report:__index( key ) -- luacheck: no self
	return Report[key]
end

--- Create a new instance.
-- @tparam vararg ... unused
-- @treturn self
function Report.create( ... )
	local self = setmetatable( {}, Report )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @treturn self
function Report:_init( ... ) -- luacheck: no unused args
	self._skip = false
	self._todo = false
	self._state = true
	self._type = 'base-report'
	return self
end

--- Set the state unconditionally as "not ok"".
-- Note that initial state is not ok.
-- @treturn self
function Report:notOk()
	self._state = false
	return self
end

--- Set the state unconditionally as "ok"".
-- Note that initial state is not ok.
-- @treturn self
function Report:ok()
	self._state = true
	return self
end

--- Check if the instance state is "ok"".
-- Note that initial state is not ok.
-- @return boolean that is set if state is "ok"
function Report:isOk()
	return self._state
end

--- Set the skip.
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @tparam string str that will be used as the skip note
-- @treturn self
function Report:setSkip( str )
	assert( str, 'Failed to provide a skip' )
	self._skip = str
	return self
end

--- Get the skip.
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @treturn string used as the skip note
function Report:getSkip()
	return self._skip
end

--- Check if the instance is itself in a skip state.
-- @treturn boolean that is set if a skip note exist
function Report:isSkip()
	return not not self._skip
end

--- Set the todo.
-- This is an accessor to set the member.
-- @tparam string str that will be used as the todo note
-- @treturn self
function Report:setTodo( str )
	assert( str, 'Failed to provide a todo' )
	self._todo = str
	return self
end

--- Get the todo.
-- This is an accessor to get the member.
-- @treturn string used as the todo note
function Report:getTodo()
	return self._todo
end

--- Check if the instance is itself in a todo state.
-- @treturn boolean that is set if a skip note exist
function Report:isTodo()
	return not not self._todo
end

--- Realize the data by applying a render.
-- @tparam Renders renders to use while realizing the reports (unused)
-- @tparam string lang holding the language code (unused)
-- @tparam Counter counter holding the running count (unused)
-- @treturn string
function Report:realize() -- luacheck: no self
	-- @todo this should probably return an error
	-- error('Method should be overridden')
	return ''
end

--- Get the type of report.
-- All reports has an explicit type name.
-- @treturn string
function Report:type()
	return self._type
end

-- Return the final class.
return Report
