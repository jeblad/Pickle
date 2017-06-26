--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/AdaptRender'

-- @var class var for lib
local AdaptRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function AdaptRender:__index( key ) -- luacheck: no self
	return AdaptRender[key]
end

-- @var metatable for the class
setmetatable( AdaptRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return AdaptRender
function AdaptRender.create( ... )
	local self = setmetatable( {}, AdaptRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return AdaptRender
function AdaptRender:_init( ... ) -- luacheck: no unused args
	return self
end

-- Return the final class
return AdaptRender
