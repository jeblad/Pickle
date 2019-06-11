--- Subclass to do specialization of the extractor strategy class.
-- This spesialization do casting into a true boolean type.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod ExtractorTrue
-- @alias Subclass

-- pure libs
local libUtil = require 'libraryUtil'
local Super = require 'picklelib/extractor/Extractor'

-- @var class var for lib
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'ExtractorTrue:__index', 1, key, 'string', false )
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @tparam vararg ... forwarded to @{Extractor:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self or Subclass, ... )
end

--- Initialize a new instance.
-- @treturn self
function Subclass:_init()
	Super._init( self,
		{ '^[tT]rue$', 0, 0 },
		{ '^[tT]rue[%s%p]', 0, -1 },
		{ '[%s%p][tT]rue$', 1, 0 },
		{ '[%s%p][tT]rue[%s%p]', 1, -1 },
		{ '^TRUE$', 0, 0 },
		{ '^TRUE[%s%p]', 0, -1 },
		{ '[%s%p]TRUE$', 1, 0 },
		{ '[%s%p]TRUE[%s%p]', 1, -1 } )
	self._type = 'true'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see Extractor:cast
-- @raise on wrong arguments
-- @tparam string str used as the extraction source
-- @treturn boolean true
function Subclass:cast( str ) -- luacheck: no self
	assert( str == "true" or str == "True" or str == "TRUE", 'Failed to cast assumed “true”' )
	return true
end

--- Get the placeholder for this strategy.
-- @treturn string
function Subclass:placeholder() -- luacheck: no self
	return 'boolean'
end

-- Return the final class.
return Subclass
