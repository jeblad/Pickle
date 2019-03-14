--- Subclass for full report renderer.
-- @classmod AdaptRender
-- @alias AdaptRender

-- pure libs
local Base = require 'picklelib/render/AdaptRender'

-- @var class var for lib
local AdaptRender = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function AdaptRender:__index( key ) -- luacheck: no self
	return AdaptRender[key]
end

-- @var metatable for the class
setmetatable( AdaptRender, { __index = Base } )

--- Create a new instance.
-- @tparam vararg ... unused
-- @treturn self
function AdaptRender.create( ... )
	local self = setmetatable( {}, AdaptRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @treturn self
function AdaptRender:_init( ... ) -- luacheck: no unused args
	return self
end

-- Return the final class.
return AdaptRender
