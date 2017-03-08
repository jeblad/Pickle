--- Baseclass for frame plan renderer

--[[
-- Wrong place, should be in Frame
-- non-pure libs
local Extractors
if mw.pickle then
	-- structure exist, make access simpler
	Extractors = mw.pickle.extractors
else
	-- structure does not exist, require the libs
	Extractors = require 'picklelib/engine/ExtractorStrategies'
end
--]]

-- @var class var for lib
local FramePlanRender = {}

--- Lookup of missing class members
function FramePlanRender:__index( key ) -- luacheck: ignore self
	return FramePlanRender[key]
end

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
function FramePlanRender:key( str ) -- luacheck: ignore
	error('Method should be overridden')
	return nil
end

--- Realize reported data for header
-- The "header" is a composite.
function FramePlanRender:realizeHeader( src, lang ) -- luacheck: ignore self lang
	assert( src, 'Failed to provide a source' )

	--local t = { self:realizeState( src, lang ) }
	local t = {  }
--[[
	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end

	if src:hasSkip() or src:hasTodo() then
		table.insert( t, '# ' )
		table.insert( t, self:realizeSkip( src, lang ) )
		table.insert( t, self:realizeTodo( src, lang ) )
	end
--]]
	return table.concat( t, '' )
end

-- Return the final class
return FramePlanRender
