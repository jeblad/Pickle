--- Subclass to do specialization of the extractor strategy class.
-- This is the spesialization to do casting into a true boolean type
-- @classmod ExtractorTrue
-- @alias Subclass

-- pure libs
local Super = require 'picklelib/extractor/Extractor'

-- @var class var for lib
local Subclass = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
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
-- @local
-- @treturn self
function Subclass:_init()
	Super._init( self,
		{ '^true$', 0, 0 },
		{ '^true[%s%p]', 0, -1 },
		{ '[%s%p]true$', 1, 0 },
		{ '[%s%p]true[%s%p]', 1, -1 } )
	self._type = 'true'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see Extractor:cast
-- @treturn boolean true
function Subclass:cast() -- luacheck: no self
	return true
end

--- Get the placeholder for this strategy.
-- @treturn string
function Subclass:placeholder() -- luacheck: no self
	return 'boolean'
end

-- Return the final class.
return Subclass
