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
	self._onCast = function()
		error( 'The on-cast handler must be overridden' )
	end
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

--- Add pattern
-- Register a single pattern.
-- @tparam string str to be used for pattern
-- @tparam number initial offset
-- @tparam number final offset
-- @treturn self
function Baseclass:addPattern( str, initial, final )
	libUtil.checkType( 'Extractor:addPattern', 1, str, 'string', false )
	libUtil.checkType( 'Extractor:addPattern', 2, initial, 'number', false )
	libUtil.checkType( 'Extractor:addPattern', 3, final, 'number', false )

	self._patterns:push( { str, initial, final } )

	return self
end
--- Add keyword
-- Transform a single keyword to a registered set of patterns.
-- @tparam string str to be used for keywords
-- @treturn self
function Baseclass:addKeyword( str )
	libUtil.checkType( 'Extractor:addKeyword', 1, str, 'string', false )

	local pattern = mw.ustring.gsub( str, '(%a)', function( s )
		return mw.ustring.format( '[%s%s]', mw.ustring.lower( s ), mw.ustring.upper( s ) )
	end )

	self._patterns:push( { mw.ustring.format( '^%s$', pattern), 0, 0 } )
	self._patterns:push( { mw.ustring.format( '^%s[%%s%%p]', pattern), 0, -1 } )
	self._patterns:push( { mw.ustring.format( '[%%s%%p]%s$', pattern), 1, 0 } )
	self._patterns:push( { mw.ustring.format( '[%%s%%p]%s[%%s%%p]', pattern), 1, -1 } )

	return self
end

--- Add delimiters
-- Transform a pair of delimiters to a registered set of patterns.
-- @tparam string first delimiter
-- @tparam string second delimiter
-- @tparam[opt=false] nil|boolean exclude delimiters
-- @treturn self
function Baseclass:addDelimiters( first, second, exclude )
	libUtil.checkType( 'Extractor:setDelimiters', 1, first, 'string', false )
	libUtil.checkType( 'Extractor:setDelimiters', 2, second, 'string', false )
	libUtil.checkType( 'Extractor:setDelimiters', 3, exclude, 'boolean', true )

	self._patterns:push( {
		mw.ustring.format( '%%b%s%s', first, second ),
		(exclude and mw.ustring.len( first ) or 0),
		(exclude and -mw.ustring.len( second ) or 0) } )

	return self
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

	local first, last = false, false
	for _,v in ipairs( { self._patterns:export() } ) do
		--local start, finish = mw.ustring.find( str, v[1], pos-v[2] )
		local start, finish = mw.ustring.find( str, v[1], pos )
		if start then
			if not( first ) or start+v[2] < first then
				first = start+v[2]
				last = finish+v[3]
			end
		end
	end

	if not( first ) or not( last ) then
		return nil
	end

	return first, last
end

--- Set the on-cast method.
-- @tparam function func
-- @treturn self
function Baseclass:onCast( func )
	self._onCast = func
	return self
end

--- Cast the string into the correct type for this strategy.
-- @raise Unconditional error unless handler exist
-- @tparam string str used as the extraction source (unused)
-- @treturn any
function Baseclass:cast( str ) -- luacheck: no self
	libUtil.checkType( 'Extractor:cast', 1, str, 'string', false )
	return self._onCast( str )
end

--- Get the placeholder for this strategy.
-- @treturn string
function Baseclass:placeholder() -- luacheck: no self
	return mw.ustring.format( '[%s]', self:getType() )
end

-- Return the final class.
return Baseclass
