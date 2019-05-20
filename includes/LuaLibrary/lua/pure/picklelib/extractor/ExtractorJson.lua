--- Subclass to do specialization of the extractor strategy class.
-- This is the spesialization to do casting into a string type
-- @classmod ExtractorJson
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
		{ '%b{}', 0, 0 },
		{ '%b[]', 0, 0 } )
	self._type = 'json'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see Extractor:cast
-- @tparam string str used as the extraction source
-- @tparam number start for an inclusive index where extraction starts
-- @tparam number finish for an inclusive index where extraction finishes
-- @treturn JSON
function Subclass:cast( str, start, finish )
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
function Subclass:placeholder() -- luacheck: no self
	return 'json'
end

-- Return the final class.
return Subclass