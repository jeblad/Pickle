--- BaseClass for an translator strategy
-- This should be a strategy pattern

-- @var class var for lib
local Translator = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Translator:__index( key ) -- luacheck: no self
	return Translator[key]
end

--- Create a new instance
-- @param vararg list of patterns
-- @return self
function Translator.create( ... )
	local self = setmetatable( {}, Translator )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg list of patterns
-- @return self
function Translator:_init( ... )
	--self._patterns = Stack.create()
	for _,v in ipairs( { ... } ) do
		self._patterns:push( v )
	end
	self._type = 'base'
	return self
end

--- Get the type of the strategy
-- All translator strategies have an explicit type name.
-- @return string
function Translator:type()
	return self._type
end

--- Try to find the string for this strategy
-- The goodness of the match is given by the returned position.
-- If found it should return a position and the found string.
-- @todo Should have another name to avoid confusion
-- @param string used as the extraction source
-- @param number for an inclusive index where extraction starts
-- @return {nil|number, number}
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

--- Cast the string into the correct type for this strategy
-- @exception Unconditional unless overridden
-- @param string used as the extraction source
-- @param number for an inclusive index where extraction starts
-- @param number for an inclusive index where extraction finishes
-- @return nil
function Translator:cast( str, start, finish ) -- luacheck: ignore
	error('Method should be overridden')
	return nil
end

--- Get the placeholder for this strategy
-- @exception Unconditional unless overridden
-- @return string
function Translator:placeholder() -- luacheck: ignore
	return nil
end

-- Return the final class
return Translator
