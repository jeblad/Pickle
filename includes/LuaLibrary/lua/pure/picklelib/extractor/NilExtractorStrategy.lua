--- Subclass to do specialization of the extractor strategy class.
-- This is the spesialization to do casting into a nil type
-- @classmod NilExtractorStrategy
-- @alias Extractor

-- pure libs
local Base = require 'picklelib/extractor/ExtractorStrategyBase'

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
-- There are no safeguards for erroneous casts
-- @tparam string str used as the extraction source
-- @tparam number start for an inclusive index where extraction starts
-- @tparam number finish for an inclusive index where extraction finishes
-- @treturn nil
function Extractor:cast( str, start, finish ) -- luacheck: ignore
	return nil
end

--- Get the placeholder for this strategy.
-- @raise Unconditional unless overridden
-- @treturn string
function Extractor:placeholder( str, start, finish ) -- luacheck: ignore
	return 'nil'
end

-- Return the final class.
return Extractor
