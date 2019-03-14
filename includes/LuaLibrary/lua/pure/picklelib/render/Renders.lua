-- Class for render strategies
-- @classmod Renders

-- @var class var for lib
local Renders = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function Renders:__index( key ) -- luacheck: no self
	return Renders[key]
end

-- @var class var for styles, holding references to created renders
Renders._styles = {}

--- Convenience function to access a specific named style.
-- This will try to create the style if it isn't created yet.
-- @tparam string name  style of rendering
-- @treturn Render
function Renders:__call( name ) -- luacheck: no self
	assert( name, 'Renders: __call: Failed to provide a name' )
	assert( Renders._styles[name], 'Failed to provide a previously registered style' )
	return Renders._styles[name]
end

--- Initialize a new instance.
-- @local
-- @tparam string name style of rendering
-- @treturn self
function Renders:_init( name )
	assert( name, 'Renders: _init: Failed to provide a name' )
	self._version = 'TAP version 13'
	self._style = name
	self._types = {}
	return self
end

--- Create a new instance.
-- @tparam string name style of rendering
-- @treturn self
function Renders.create( name )
	local self = setmetatable( {}, Renders )
	self:_init( name )
	return self
end

--- Get the version.
-- This is the TAP-version line.
-- @treturn string
function Renders:realizeVersion() -- luacheck: no unused args
	return self._version
end

--- Convenience function to access a specific named style.
-- This will try to create the style if it isn't created yet.
-- @tparam string name style of rendering
-- @treturn nil|Render
function Renders.style( name ) -- luacheck: no self
	assert( name, 'Renders: style: Failed to provide a name' )
	assert( Renders._styles[name], 'Failed to provide a previously registered style' )
	return Renders._styles[name]
end

--- Register named style.
-- This is at class level. It is really a two level strategy, but we're lazy
-- and skip one of the levels.
-- @tparam string name style of rendering
-- @treturn nil|Render
function Renders.registerStyle( name )
	if not Renders._styles[name] then
		Renders._styles[name] = Renders.create( name )
	end
	return Renders._styles[name]
end

--- Register a render of given named type.
-- This will typically be "Result" or "Report".
-- @tparam string name style of rendering
-- @tparam Render lib for the specific kind of rendering
-- @treturn nil|Render
function Renders:registerType( name, lib )
	assert( name, 'Renders: registerType: Failed to provide a name' )
	self._types[name] = lib
	return self._types[name]
end

--- Find render of the correct named type.
-- This will typically be "Result" or "Report".
-- @todo check if this has tests
-- @tparam string name style of rendering
-- @treturn nil|Render
function Renders:find( name )
	assert( name, 'Renders: find: Failed to provide a name' )
	assert( self._types[name], 'Renderers: find: Failed to provide a previously registered type for "' .. name .. '"')
	return self._types[name]
end

-- Return the final class.
return Renders
