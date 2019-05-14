--- BaseClass for an translator strategy.
-- This should be a strategy pattern.
-- @classmod Translator

-- @var class var for lib
local Translator = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function Translator:__index( key ) -- luacheck: no self
	return Translator[key]
end

--- Create a new instance.
-- @tparam vararg ... list of patterns
-- @treturn self
function Translator:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... list of patterns
-- @treturn self
function Translator:_init( ... )
	--self._patterns = Stack:create()
	for _,v in ipairs( { ... } ) do
		self._patterns:push( v )
	end
	self._type = 'translator'
	return self
end

--- Get the type of the strategy.
-- All translator strategies have an explicit type name.
-- @treturn string
function Translator:type()
	return self._type
end

--- Try to find the string for this strategy.
-- The goodness of the match is given by the returned position.
-- If found it should return a position and the found string.
-- @todo Should have another name to avoid confusion
-- @tparam string str the extraction source
-- @tparam number pos of the inclusive index where extraction starts
-- @treturn nil|number,number
function Translator:find( str, pos )
	assert( str, 'Failed to provide a string' )
	assert( pos, 'Failed to provide a position' )
	for _,v in ipairs( { self._patterns:export() } ) do
		local start, finish = mw.ustring.find( str, v[1], pos-v[2] )
		if start then
			return start+v[2], finish+v[3]
		end
	end
	return nil
end

--- Cast the string into the correct type for this strategy.
-- @raise Unconditional unless overridden
-- @tparam string str the extraction source (unused)
-- @tparam number start of the inclusive index where extraction starts (unused)
-- @tparam number finish of the inclusive index where extraction finishes (unused)
-- @treturn nil
function Translator:cast() -- luacheck: no self
	error('Method should be overridden')
	return nil
end

--- Get the placeholder for this strategy.
-- @raise Unconditional unless overridden
-- @treturn string
function Translator:placeholder() -- luacheck: no self
	return nil
end

-- Return the final class.
return Translator
