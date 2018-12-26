--- Subclass for phrases

-- @var class var for lib
local Phrase = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Phrase:__index( key ) -- luacheck: no self
	return Phrase[key]
end

--- Create a new instance
-- @param vararg unused
-- @return Phrase
function Phrase.create( ... )
	local self = setmetatable( {}, Phrase )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Phrase
function Phrase:_init( ... ) -- luacheck: ignore
	self._phrase = false
	self._todo = false
	self._type = 'Phrase-report'
	--local key = '' -- @todo
	return self
end

--- Set the key
-- This is an accessor to set the member.
-- @param string that will be used as the key
-- @return self
function Phrase:setKey( key )
	assert( key )

	self._key = key
	return self
end

--- Get the key
-- This is an accessor to get the member.
-- @return string used as the key
function Phrase:getKey()
	return self._key
end

--- Set the phrase
-- This is an accessor to set the member.
-- @param string that will be used as the phrase
-- @return self
function Phrase:setPhrase( phrase )
	assert( phrase )

	self._phrase = phrase
	return self
end

--- Get the phrase
-- This is an accessor to get the member.
-- @return string used as the phrase
function Phrase:getPhrase()
	return self._phrase
end

--- Check if the instance is itself in a string state
-- @return boolean that is set if a note exist
function Phrase:isPhrase()
	return not not self._phrase
end

--- Realize the data by applying a render
-- @todo fix this
-- @param Renders to use while realizing the reports
-- @param string holding the language code
function Phrase:realize( renders, lang )
	assert( renders )


	local styles = renders:find( self:type() )
	local out = styles:realizeHeader( self, lang )

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			out = styles:append( out, v:realize( renders, lang ) )
		end
	end

	return out
end

-- Return the final class
return Phrase
