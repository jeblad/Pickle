--- Subclass to do specialization of the extractor strategy class.
-- This is the spesialization to do casting into a true boolean type
-- @classmod TrueExtractor
-- @alias Extractor

-- pure libs
local Base = require 'picklelib/extractor/ExtractorBase'

-- @var class var for lib
local Extractor = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Extractor:__index( key ) -- luacheck: no self
	return Extractor[key]
end

-- @var metatable for the class
setmetatable( Extractor, { __index = Base } )

--- Create a new instance.
-- @treturn self
function Extractor.create()
	local self = setmetatable( {}, Extractor )
	self:_init()
	return self
end

--- Initialize a new instance.
-- @local
-- @treturn self
function Extractor:_init()
	Base._init( self,
		{ '^true$', 0, 0 },
		{ '^true[%s%p]', 0, -1 },
		{ '[%s%p]true$', 1, 0 },
		{ '[%s%p]true[%s%p]', 1, -1 } )
	self._type = 'true'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see ExtractorBase:cast
-- @treturn boolean true
function Extractor:cast() -- luacheck: no self
	return true
end

--- Get the placeholder for this strategy.
-- @treturn string
function Extractor:placeholder() -- luacheck: no self
	return 'boolean'
end

-- Return the final class.
return Extractor
