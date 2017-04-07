--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a true boolean type

-- pure libs
local Base = require 'picklelib/extractor/ExtractorStrategyBase'

-- @var class var for lib
local Extractor = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Extractor:__index( key ) -- luacheck: no self
	return Extractor[key]
end

-- @var metatable for the class
setmetatable( Extractor, { __index = Base } )

--- Create a new instance
-- @return self
function Extractor.create()
	local self = setmetatable( {}, Extractor )
	self:_init()
	return self
end

--- Initialize a new instance
-- @private
-- @return self
function Extractor:_init()
	Base._init( self,
		{ '^true$', 0, 0 },
		{ '^true[%s%p]', 0, -1 },
		{ '[%s%p]true$', 1, 0 },
		{ '[%s%p]true[%s%p]', 1, -1 } )
	self._type = 'true'
	return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
-- @param string used as the extraction source
-- @param number for an inclusive index where extraction starts
-- @param number for an inclusive index where extraction finishes
-- @return boolean true
function Extractor:cast( str, start, finish ) -- luacheck: ignore
	return true
end

--- Get the placeholder for this strategy
-- @exception Unconditional unless overridden
-- @return string
function Extractor:placeholder() -- luacheck: ignore
	return 'boolean'
end

-- Return the final class
return Extractor
