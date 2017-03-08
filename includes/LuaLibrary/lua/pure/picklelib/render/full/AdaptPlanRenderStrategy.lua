--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/AdaptPlanRenderBase'

-- @var class var for lib
local AdaptPlanRender = {}

--- Lookup of missing class members
function AdaptPlanRender:__index( key ) -- luacheck: ignore self
	return AdaptPlanRender[key]
end

-- @var metatable for the class
setmetatable( AdaptPlanRender, { __index = Base } )

--- Create a new instance
function AdaptPlanRender.create( ... )
	local self = setmetatable( {}, AdaptPlanRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function AdaptPlanRender:_init( ... ) -- luacheck: ignore
	return self
end

--- Override key construction
function AdaptPlanRender:key( str ) -- luacheck: ignore self
	assert( str, 'Failed to provide a string' )
	return 'pickle-report-result-full-' .. str
end

-- Return the final class
return AdaptPlanRender
