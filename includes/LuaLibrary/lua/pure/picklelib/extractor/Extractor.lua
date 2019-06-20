--- BaseClass for an extractor strategy.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Extractor
-- @alias Baseclass

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'

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
	self._patterns = Bag:create()
	for _,v in ipairs( { ... } ) do
		self._patterns:push( v )
	end
	return self
end

---Set type
-- @tparam string str to be used as type
-- @treturn self
function Baseclass:setType( str )
	libUtil.checkType( 'Extractor:addKeyword', 1, str, 'string', false )
	assert( not self._type )

	self._type = mw.ustring.lower( str )

	return self
end

--- Has type
-- @treturn boolean
function Baseclass:hasType()
	return not not self._type
end

--- Get the type of the strategy.
-- All extractor strategies have an explicit type name.
-- @treturn string
function Baseclass:getType()
	return self._type or '<unknown>'
end

--- Set keyword
-- Transform a single keyword to a registered set of patterns.
-- @tparam string str to be used for keywords
-- @tparam[generate=true] boolean generate associated patterns 
-- @treturn self
function Baseclass:setKeyword( str, generate )
	libUtil.checkType( 'Extractor:addKeyword', 1, str, 'string', false )
	libUtil.checkType( 'Extractor:addKeyword', 2, generate, 'boolean', true )
	--assert( not self._keyword )

	self._keyword = mw.ustring.lower( str )

	if ( type( generate ) == 'nil' ) or generate then
		local pattern = mw.ustring.gsub( str, '(%a)', function( s )
			return mw.ustring.format( '[%s%s]', mw.ustring.lower( s ), mw.ustring.upper( s ) )
		end )

		self._patterns:push( { mw.ustring.format( '^%s$', pattern), 0, 0 } )
		self._patterns:push( { mw.ustring.format( '^%s[%%s%%p]', pattern), 0, -1 } )
		self._patterns:push( { mw.ustring.format( '[%%s%%p]%s$', pattern), 1, 0 } )
		self._patterns:push( { mw.ustring.format( '[%%s%%p]%s[%%s%%p]', pattern), 1, -1 } )
	end

	return self
end

--- Has keyword
-- @treturn boolean
function Baseclass:hasKeyword()
	return not not self._keyword
end

--- Get keyword
--@treturn mw.ustring
function Baseclass:getKeyword()
	return self._keyword
end

--- Num patterns
--@treturn number
function Baseclass:numPatterns()
	return self._patterns:depth()
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
-- @treturn nil
function Baseclass:cast() -- luacheck: no self
	error('Method should be overridden')
	return nil
end

--- Get the placeholder for this strategy.
-- @treturn string
function Baseclass:placeholder() -- luacheck: no self
	return mw.ustring.format( '[%s]', self:getType() )
end

-- Return the final class.
return Baseclass
