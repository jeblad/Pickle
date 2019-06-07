--- Class for render strategies.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Renders

-- pure libs
local libUtil = require 'libraryUtil'

-- @var class var for lib
local Renders = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Renders:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Renders:__index', 1, key, 'string', false )
	return Renders[key]
end

-- @field class var for styles, holding references to created renders
Renders._styles = {}

--- Convenience function to access a specific named style.
-- @todo Not done: This will try to create the style if it isn't created yet.
-- @raise on wrong arguments
-- @tparam string name  style of rendering
-- @treturn self
function Renders:__call( name ) -- luacheck: no self
	libUtil.checkType( 'Renders:__call', 1, name, 'string', false )
	assert( Renders._styles[name], 'Failed to provide a previously registered style' )
	return Renders._styles[name]
end

--- Create a new instance.
-- Assumption is either to create a new instance from an existing class,
-- or from a previous instance of some kind.
-- @raise on wrong arguments
-- @tparam string name style of rendering
-- @treturn self
function Renders:create( name )
	-- name tested in later call
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( name )
end

--- Initialize a new instance.
-- @raise on wrong arguments
-- @tparam string name style of rendering
-- @treturn self
function Renders:_init( name )
	libUtil.checkType( 'Renders:__name', 1, name, 'string', false )
	self._version = 'TAP version 13'
	self._style = name
	self._types = {}
	return self
end

--- Get the version.
-- This is the TAP-version line.
-- @treturn string
function Renders:realizeVersion() -- luacheck: no unused args
	return self._version
end

--- Convenience function to access a specific named style.
-- This will not create the style if it isn't created yet.
-- @raise on wrong arguments
-- @tparam string name style of rendering
-- @treturn nil|Render
function Renders.style( name ) -- luacheck: no self
	libUtil.checkType( 'Renders:style', 1, name, 'string', false )
	assert( Renders._styles[name], 'Failed to provide a previously registered style' )
	return Renders._styles[name]
end

--- Register named style.
-- This is at class level. It is really a two level strategy, but we're lazy
-- and skip one of the levels.
-- @raise on wrong arguments
-- @tparam string name style of rendering
-- @treturn Render
function Renders.registerStyle( name )
	libUtil.checkType( 'Renders:registerStyle', 1, name, 'string', false )
	if not Renders._styles[name] then
		Renders._styles[name] = Renders:create( name )
	end
	return Renders._styles[name]
end

--- Register a render of given named type.
-- This will typically be "Result" or "Report".
-- @raise on wrong arguments
-- @tparam string name style of rendering
-- @tparam Render lib for the specific kind of rendering
-- @treturn Render
function Renders:registerType( name, lib )
	libUtil.checkType( 'Renders:registerType', 1, name, 'string', false )
	libUtil.checkType( 'Renders:registerType', 2, lib, 'table', false )
	self._types[name] = lib
	return self._types[name]
end

--- Find render of the correct named type.
-- This will typically be "Result" or "Report".
-- @todo check if this has tests
-- @tparam string name style of rendering
-- @treturn Render
function Renders:find( name )
	libUtil.checkType( 'Renders:find', 1, name, 'string', false )
	assert( self._types[name], 'Renderers: find: Failed to provide a type for "' .. name .. '"')
	return self._types[name]
end

-- Return the final class.
return Renders
