--- Subclass for frame report renderer

-- pure libs
local Base = require 'picklelib/render/FrameReportRenderBase'

-- @var class var for lib
local FrameReportRender = {}

--- Lookup of missing class members
function FrameReportRender:__index( key ) -- luacheck: ignore self
	return FrameReportRender[key]
end

-- @var metatable for the class
setmetatable( FrameReportRender, { __index = Base } )

--- Create a new instance
function FrameReportRender.create( ... )
	local self = setmetatable( {}, FrameReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function FrameReportRender:_init( ... ) -- luacheck: ignore
	return self
end

--- Override key construction
function FrameReportRender:key( str ) -- luacheck: ignore self
	assert( str, 'Failed to provide a string' )
	return 'pickle-report-plan-compact-' .. str
end

-- Return the final class
return FrameReportRender
