--- Subclass to do specialization of the extractor strategy class.
-- This spesialization do casting into a string type.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod ExtractorJson
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
	libUtil.checkType( 'ExtractorJson:__index', 1, key, 'string', false )
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
		{ '%b{}', 0, 0 },
		{ '%b[]', 0, 0 } )
	self._type = 'json'
	return self
end

--- Cast the string into the correct type for this strategy.
-- There are no safeguards for erroneous casts.
-- @see Extractor:cast
-- @raise on wrong arguments
-- @tparam string str used as the extraction source
-- @tparam number start for an inclusive index where extraction starts
-- @tparam number finish for an inclusive index where extraction finishes
-- @treturn JSON
function Subclass:cast( str, start, finish )
	libUtil.checkType( 'ExtractorJson:cast', 1, str, 'string', false )
	libUtil.checkType( 'ExtractorJson:cast', 2, start, 'number', false )
	libUtil.checkType( 'ExtractorJson:cast', 3, finish, 'number', false )

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
