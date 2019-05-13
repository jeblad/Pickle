--- Subclass to do specialization of the extractor strategy class.
-- This is the spesialization to do casting into a string type
-- @classmod JsonExtractor
-- @alias Extractor

-- pure libs
local Base = require 'picklelib/extractor/ExtractorBase'

-- @var class var for lib
local Extractor = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
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
		{ '%b{}', 0, 0 },
		{ '%b[]', 0, 0 } )
	self._type = 'json'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see ExtractorBase:cast
-- @tparam string str used as the extraction source
-- @tparam number start for an inclusive index where extraction starts
-- @tparam number finish for an inclusive index where extraction finishes
-- @treturn JSON
function Extractor:cast( str, start, finish )
	if not finish then
		start, finish = self:find( str, (start or 2) -1 )
	end

	local jsonStr = mw.ustring.sub( str, start, finish )
	assert( jsonStr, 'Failed to identify a substring' )

	local json = mw.text.jsonDecode( jsonStr )
	assert( str, 'Failed to decode assumed json' )

	return json
end

--- Get the placeholder for this strategy
-- @treturn string
function Extractor:placeholder() -- luacheck: no self
	return 'json'
end

-- Return the final class.
return Extractor
