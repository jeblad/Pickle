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
		{ '^nil$', 0, 0 },
		{ '^nil[%s%p]', 0, -1 },
		{ '[%s%p]nil$', 1, 0 },
		{ '[%s%p]nil[%s%p]', 1, -1 } )
	self._type = 'nil'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see Extractor:cast
-- @treturn nil
function Subclass:cast() -- luacheck: no self
	return nil
end

--- Get the placeholder for this strategy.
-- @treturn string
function Subclass:placeholder() -- luacheck: no self
	return 'nil'
end

-- Return the final class.
return Subclass
