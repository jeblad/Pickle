--- Baseclass for constituents

-- @var class var for lib
local Constituent = {}

--- Lookup of missing class members
function Constituent:__index( key ) -- luacheck: ignore self
	return Constituent[key]
end

--- Create a new instance
function Constituent.create( ... )
	local self = setmetatable( {}, Constituent )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Constituent:_init( ... ) -- luacheck: ignore
	self._lang = false
	self._type = 'constituent'
	return self
end

function Constituent:realize( renders, lang ) -- luacheck: ignore
	return ''
end

function Constituent:type()
	return self._type
end

-- Return the final class
return Constituent
