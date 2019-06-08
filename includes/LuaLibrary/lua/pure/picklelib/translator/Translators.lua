--- Class for extractor strategies.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Translators

-- pure libs
local libUtil = require 'libraryUtil'

-- @var class var for lib
local Translators = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Translators:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Translators:__index', 1, key, 'string', false )
	return Translators[key]
end

--- Create a new instance.
-- @tparam vararg ... list of strategies
-- @treturn self
function Translators:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... list of packaged strategies
-- @treturn self
function Translators:_init( ... )
	self._strategies = {}
	for _,v in ipairs( { ... } ) do
		self:register( v[1], v[2] )
	end
	return self
end

--- Register a new strategy.
-- @tparam string key lookup of translator
-- @tparam Translator strategy to be registered
-- @treturn self
function Translators:register( key, strategy )
	self._strategies[ key ] = strategy
	return self
end

--- Removes all registered translators.
-- @treturn self
function Translators:flush()
	self._strategies = {}
	return self
end

--- Find a matching extractor.
-- @raise On missing source
-- @tparam string key lookup of translator
-- @treturn Translator,number,number strategy,first,last
function Translators:find( key )
	assert( key )

	return self._strategies[ key ]
end

-- Return the final class.
return Translators
