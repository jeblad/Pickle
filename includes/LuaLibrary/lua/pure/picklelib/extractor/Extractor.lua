--- BaseClass for an extractor strategy.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Extractor
-- @alias Baseclass

-- pure libs
local libUtil = require 'libraryUtil'
local Stack = require 'picklelib/Stack'

-- @var class
local Baseclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Baseclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Extractor:__index', 1, key, 'string', false )
	return Baseclass[key]
end

--- Create a new instance.
-- @tparam vararg ... forwarded to @{Extractor:_init}
-- @treturn self
function Baseclass:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... list of patterns
-- @treturn self
function Baseclass:_init( ... )
	self._patterns = Stack:create()
	for _,v in ipairs( { ... } ) do
		self._patterns:push( v )
	end
	self._type = 'base'
	return self
end

--- Get the type of the strategy.
-- All extractor strategies have an explicit type name.
-- @treturn string
function Baseclass:type()
	return self._type
end

--- Try to find the string for this strategy.
-- The goodness of the match is given by the returned position.
-- If found it should return a position and the found string.
-- @raise on wrong arguments
-- @todo Should have another name to avoid confusion
-- @tparam string str used as the extraction source
-- @tparam number pos for an inclusive index where extraction starts
-- @treturn nil|number,number
function Baseclass:find( str, pos )
	libUtil.checkType( 'Extractor:find', 1, str, 'string', false )
	libUtil.checkType( 'Extractor:find', 2, pos, 'number', false )

	for _,v in ipairs( { self._patterns:export() } ) do
		local start, finish = mw.ustring.find( str, v[1], pos-v[2] )
		if start then
			return start+v[2], finish+v[3]
		end
	end
	return nil
end

--- Cast the string into the correct type for this strategy.
-- @raise Unconditional error unless overridden
-- @tparam string str used as the extraction source (unused)
-- @tparam number start for an inclusive index where extraction starts (unused)
-- @tparam number finish for an inclusive index where extraction finishes (unused)
-- @treturn nil
function Baseclass:cast() -- luacheck: no self
	error('Method should be overridden')
	return nil
end

--- Get the placeholder for this strategy.
-- @raise Unconditional error unless overridden
-- @treturn string
function Baseclass:placeholder() -- luacheck: no self
	error('Method should be overridden')
	return nil
end

-- Return the final class.
return Baseclass
