--- Subclass to do specialization of the extractor strategy class.
-- This is the spesialization to do casting into a nil type
-- @classmod NilExtractor
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
		{ '^nil$', 0, 0 },
		{ '^nil[%s%p]', 0, -1 },
		{ '[%s%p]nil$', 1, 0 },
		{ '[%s%p]nil[%s%p]', 1, -1 } )
	self._type = 'nil'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see ExtractorBase:cast
-- @treturn nil
function Extractor:cast() -- luacheck: ignore self
	return nil
end

--- Get the placeholder for this strategy.
-- @treturn string
function Extractor:placeholder() -- luacheck: ignore self
	return 'nil'
end

-- Return the final class.
return Extractor
