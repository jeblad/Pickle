--- BaseClass for an extractor strategy.
-- This should be a strategy pattern
-- @classmod ExtractorBase
-- @alias Extractor

-- pure libs
local Stack = require 'picklelib/Stack'

-- @var class var for lib
local Extractor = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function Extractor:__index( key ) -- luacheck: no self
	return Extractor[key]
end

--- Create a new instance.
-- @tparam vararg ... list of patterns
-- @treturn self
function Extractor.create( ... )
	local self = setmetatable( {}, Extractor )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... list of patterns
-- @treturn self
function Extractor:_init( ... )
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
function Extractor:type()
	return self._type
end

--- Try to find the string for this strategy.
-- The goodness of the match is given by the returned position.
-- If found it should return a position and the found string.
-- @todo Should have another name to avoid confusion
-- @tparam string str used as the extraction source
-- @tparam number pos for an inclusive index where extraction starts
-- @treturn nil|number,number
function Extractor:find( str, pos )
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
-- @raise Unconditional error unless overridden
-- @tparam string str used as the extraction source (unused)
-- @tparam number start for an inclusive index where extraction starts (unused)
-- @tparam number finish for an inclusive index where extraction finishes (unused)
-- @treturn nil
function Extractor:cast() -- luacheck: no self
	error('Method should be overridden')
	return nil
end

--- Get the placeholder for this strategy.
-- @raise Unconditional error unless overridden
-- @treturn string
function Extractor:placeholder() -- luacheck: no self
	error('Method should be overridden')
	return nil
end

-- Return the final class.
return Extractor
