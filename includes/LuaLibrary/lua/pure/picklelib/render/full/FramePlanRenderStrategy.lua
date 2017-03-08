--- Subclass for frame plan renderer

-- pure libs
local Base = require 'picklelib/render/FramePlanRenderBase'

-- @var class var for lib
local FramePlanRender = {}

--- Lookup of missing class members
function FramePlanRender:__index( key ) -- luacheck: ignore self
	return FramePlanRender[key]
end

-- @var metatable for the class
setmetatable( FramePlanRender, { __index = Base } )

--- Create a new instance
function FramePlanRender.create( ... )
	local self = setmetatable( {}, FramePlanRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function FramePlanRender:_init( ... ) -- luacheck: ignore
	return self
end

--- Override key construction
function FramePlanRender:key( str ) -- luacheck: ignore self
	assert( str, 'Failed to provide a string' )
	return 'pickle-report-plan-full-compact-' .. str
end

-- Return the final class
return FramePlanRender
