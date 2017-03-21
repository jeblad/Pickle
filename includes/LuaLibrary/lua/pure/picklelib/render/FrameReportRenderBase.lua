--- Baseclass for frame report renderer

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
local FrameReportRender = {}

--- Lookup of missing class members
function FrameReportRender:__index( key ) -- luacheck: no self
	return FrameReportRender[key]
end

--- Create a new instance
function FrameReportRender.create( ... )
	local self = setmetatable( {}, FrameReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function FrameReportRender:_init( ... ) -- luacheck: no unused args
	return self
end

--- Override key construction
function FrameReportRender:key( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return keep
end

--- Realize reported data for state
function FrameReportRender:realizeState( src, lang )
	assert( src, 'Failed to provide a source' )

	local msg = mw.message.new( src:isOk() and self:key( 'is-ok' ) or self:key( 'is-not-ok' ) )

	if lang then
		msg:inLanguage( lang )
	end

	if msg:isDisabled() then
		return ''
	end

	return msg:plain()
end

--- Realize reported data for skip
-- The "skip" is a message identified by a key.
function FrameReportRender:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	if not ( src:isSkip() or src:hasSkip() ) then
		return ''
	end

	local realization = ''
	local inner = mw.message.new( src:getSkip() )

	if lang then
		inner:inLanguage( lang )
	end

	if not inner:isDisabled() then
		realization = inner:plain()
	end

	local outer = mw.message.new( self:key( 'wrap-skip' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for todo
-- The "todo" is a text string.
function FrameReportRender:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	if not ( src:isTodo() or src:hasTodo() ) then
		return ''
	end

	local realization = mw.text.encode( src:getTodo() )
	local outer = mw.message.new( self:key( 'wrap-todo' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for description
-- The "description" is a text string.
function FrameReportRender:realizeDescription( src, lang )
	assert( src, 'Failed to provide a source' )

	if not src:hasDescription() then
		return ''
	end

	local realization = mw.text.encode( src:getDescription() )
	local outer = mw.message.new( self:key( 'wrap-description' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for header
-- The "header" is a composite.
function FrameReportRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang ) }
	--local t = {  }

	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:hasSkip() or src:isTodo() or src:hasTodo() then
		table.insert( t, '# ' )
		if src:isSkip() or src:hasSkip() then
			table.insert( t, self:realizeSkip( src, lang ) )
		end
		if src:isTodo() or src:hasTodo() then
			table.insert( t, self:realizeTodo( src, lang ) )
		end
	end

	return table.concat( t, '' )
end

--- Realize reported data for body
-- The "body" is a composite.
function FrameReportRender:realizeBody( src, lang ) -- luacheck: ignore self lang
	assert( src, 'Failed to provide a source' )

	local t = {}

--[[
	for _,v in ipairs( { src:constituents() } ) do
		table.insert( t, self:realize( v, lang ) )
	end
]]
	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class
return FrameReportRender
