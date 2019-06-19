--- Baseclass for reports.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Report
-- @alias Baseclass

-- pure libs
local libUtil = require 'libraryUtil'

-- @var base class
local Baseclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Baseclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Report:__index', 1, key, 'string', false )
	return Baseclass[key]
end

--- Create a new instance.
-- Assumption is either to create a new instance from an existing class,
-- or from a previous instance of some kind.
-- @tparam vararg ... forwarded to `_init()`
-- @treturn self
function Baseclass:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... unused
-- @treturn self
function Baseclass:_init( ... ) -- luacheck: no unused args
	self._skip = false
	self._todo = false
	self._state = true
	self._type = 'report'
	return self
end

--- Set the state unconditionally as "not ok"".
-- Note that initial state is not ok.
-- @treturn self
function Baseclass:notOk()
	self._state = false
	return self
end

--- Set the state unconditionally as "ok"".
-- Note that initial state is not ok.
-- @treturn self
function Baseclass:ok()
	self._state = true
	return self
end

--- Check if the instance state is "ok"".
-- Note that initial state is not ok.
-- @treturn boolean the existing state
function Baseclass:isOk()
	return not not self._state
end

--- Set the skip.
-- This is an accessor to set the member.
-- @raise on wrong arguments
-- @tparam[opt=''] nil|string|table arg that will be used as the skip note
-- @treturn self
function Baseclass:setSkip( arg )
	libUtil.checkTypeMulti( 'Report:setSkip', 1, arg, {'nil', 'string', 'table'} )
	self._skip = arg
	return self
end

--- Get the skip.
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @treturn string the skip note
function Baseclass:getSkip()
	return self._skip
end

--- Check if the instance is itself in a skip state.
-- @treturn boolean does the skip note exist
function Baseclass:isSkip()
	return not not self._skip
end

--- Set the todo.
-- This is an accessor to set the member.
-- @raise on wrong arguments
-- @tparam[opt=''] nil|string|table arg that will be used as the todo note
-- @treturn self
function Baseclass:setTodo( arg )
	libUtil.checkTypeMulti( 'Report:setSkip', 1, arg, {'nil', 'string', 'table'} )
	self._todo = arg
	return self
end

--- Get the todo.
-- This is an accessor to get the member.
-- @treturn string the todo note
function Baseclass:getTodo()
	return self._todo
end

--- Check if the instance is itself in a todo state.
-- @treturn boolean does the todo note exist
function Baseclass:isTodo()
	return not not self._todo
end

--- Realize the data by applying a render.
-- @tparam Renders renders to use while realizing the Baseclasss (unused)
-- @tparam nil|string lang holding the language code (unused)
-- @tparam nil|Counter counter holding the running count (unused)
-- @treturn string
function Baseclass:realize() -- luacheck: no self
	-- @todo this should probably return an error
	-- error('Method should be overridden')
	return ''
end

--- Get the type of report.
-- All reports has an explicit type name.
-- @treturn string
function Baseclass:type()
	return self._type
end

-- Return the final class.
return Baseclass
