--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a false boolean type

-- pure libs
local Base = require 'picklelib/extractor/ExtractorStrategyBase'

-- @var class var for lib
local Extractor = {}
function Extractor:__index( key ) -- luacheck: ignore self
	return Extractor[key]
end

-- @var metatable for the class
setmetatable( Extractor, { __index = Base } )

--- Create a new instance
function Extractor.create()
	local self = setmetatable( {}, Extractor )
	self:_init()
	return self
end

--- Initialize a new instance
function Extractor:_init()
	Base._init( self,
		{ '^false$', 0, 0 },
		{ '^false[%s%p]', 0, -1 },
		{ '[%s%p]false$', 1, 0 },
		{ '[%s%p]false[%s%p]', 1, -1 } )
	self._type = 'false'
	return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
function Extractor:cast( str, start, finish ) -- luacheck: ignore
	return false
end

-- Return the final class
return Extractor
