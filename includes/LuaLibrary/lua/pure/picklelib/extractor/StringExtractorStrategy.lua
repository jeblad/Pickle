--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a string type

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
		{ '%b""', 1, -1 } )
	self._type = 'string'
	return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
-- @param string used as the extraction source
-- @param number for an inclusive index where extraction starts
-- @param number for an inclusive index where extraction finishes
-- @return string
function Extractor:cast( str, start, finish )
	if not finish then
		start, finish = self:find( str, (start or 2) -1 )
	end

	return mw.ustring.sub( str, start, finish )
end

-- Return the final class
return Extractor
