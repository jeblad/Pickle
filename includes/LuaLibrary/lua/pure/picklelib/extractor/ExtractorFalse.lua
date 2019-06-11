--- Subclass to do specialization of the extractor strategy class.
-- This spesialization do casting into a false boolean type.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod ExtractorFalse
-- @alias Subclass

-- pure base class
local libUtil = require 'libraryUtil'
local Super = require 'picklelib/extractor/Extractor'

-- @var class var for lib
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'ExtractorFalse:__index', 1, key, 'string', false )
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
		{ '^[fF]alse$', 0, 0 },
		{ '^[fF]alse[%s%p]', 0, -1 },
		{ '[%s%p][fF]alse$', 1, 0 },
		{ '[%s%p][fF]alse[%s%p]', 1, -1 },
		{ '^FALSE$', 0, 0 },
		{ '^FALSE[%s%p]', 0, -1 },
		{ '[%s%p]FALSE$', 1, 0 },
		{ '[%s%p]FALSE[%s%p]', 1, -1 } )
	self._type = 'false'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see Extractor:cast
-- @raise on wrong arguments
-- @tparam string str used as the extraction source
-- @treturn boolean false
function Subclass:cast( str ) -- luacheck: no self
	assert( str == "false" or str == "False" or str == "FALSE", 'Failed to cast assumed “false”' )
	return false
end

--- Get the placeholder for this strategy.
-- @treturn string
function Subclass:placeholder() -- luacheck: no self
	return '[boolean]'
end

-- Return the final class.
return Subclass
