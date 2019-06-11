--- Subclass to do specialization of the extractor strategy class.
-- This spesialization do casting into a nil type.
-- This class follows the pattern with inheritance from
-- [Lua classes
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod ExtractorNil
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
	libUtil.checkType( 'ExtractorNil:__index', 1, key, 'string', false )
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
		{ '^[nN]il$', 0, 0 },
		{ '^[nN]il[%s%p]', 0, -1 },
		{ '[%s%p][nN]il$', 1, 0 },
		{ '[%s%p][nN]il[%s%p]', 1, -1 },
		{ '^NIL$', 0, 0 },
		{ '^NIL[%s%p]', 0, -1 },
		{ '[%s%p]NIL$', 1, 0 },
		{ '[%s%p]NIL[%s%p]', 1, -1 },
		{ '^[nN]ull$', 0, 0 },
		{ '^[nN]ull[%s%p]', 0, -1 },
		{ '[%s%p][nN]ull$', 1, 0 },
		{ '[%s%p][nN]ull[%s%p]', 1, -1 },
		{ '^NULL$', 0, 0 },
		{ '^NULL[%s%p]', 0, -1 },
		{ '[%s%p]NULL$', 1, 0 },
		{ '[%s%p]NULL[%s%p]', 1, -1 } )
	self._type = 'nil'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see Extractor:cast
-- @raise on wrong arguments
-- @tparam string str used as the extraction source
-- @treturn nil
function Subclass:cast( str ) -- luacheck: no self
	assert( str == "nil" or str == "Nil" or str == "NIL"
		or str == "null" or str == "Null" or str == "NULL",
		'Failed to cast assumed “nil”' )
	return nil
end

--- Get the placeholder for this strategy.
-- @treturn string
function Subclass:placeholder() -- luacheck: no self
	return '[nil]'
end

-- Return the final class.
return Subclass
