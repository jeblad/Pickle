--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/AdaptRenderBase'

-- @var class var for lib
local AdaptReportRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function AdaptReportRender:__index( key ) -- luacheck: no self
	return AdaptReportRender[key]
end

-- @var metatable for the class
setmetatable( AdaptReportRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return AdaptReportRender
function AdaptReportRender.create( ... )
	local self = setmetatable( {}, AdaptReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return AdaptReportRender
function AdaptReportRender:_init( ... ) -- luacheck: no unused args
	return self
end

-- Return the final class
return AdaptReportRender
