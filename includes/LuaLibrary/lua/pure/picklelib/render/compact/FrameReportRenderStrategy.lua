--- Subclass for frame report renderer

-- pure libs
local Base = require 'picklelib/render/FrameReportRenderBase'

-- @var class var for lib
local FrameReportRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function FrameReportRender:__index( key ) -- luacheck: no self
	return FrameReportRender[key]
end

-- @var metatable for the class
setmetatable( FrameReportRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return FrameReportRender
function FrameReportRender.create( ... )
	local self = setmetatable( {}, FrameReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return FrameReportRender
function FrameReportRender:_init( ... ) -- luacheck: no unused args
	return self
end

--- Override key construction
-- @param string to be appended to a base string
-- @return string
function FrameReportRender:key( str )
	return 'pickle-report-frame-compact-' ..  Base.key( self, str )
end

-- Return the final class
return FrameReportRender
