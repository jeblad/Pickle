--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/AdaptReportRenderBase'

-- @var class var for lib
local AdaptReportRender = {}

--- Lookup of missing class members
function AdaptReportRender:__index( key ) -- luacheck: no self
	return AdaptReportRender[key]
end

-- @var metatable for the class
setmetatable( AdaptReportRender, { __index = Base } )

--- Create a new instance
function AdaptReportRender.create( ... )
	local self = setmetatable( {}, AdaptReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function AdaptReportRender:_init( ... ) -- luacheck: no unused args
	return self
end

--- Override key construction
function AdaptReportRender:key( str )
	return 'pickle-report-adapt-full-' ..  Base.key( self, str )
end

-- Return the final class
return AdaptReportRender
