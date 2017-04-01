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
-- @param string used for lookup of member
-- @return any
function FrameReportRender:__index( key ) -- luacheck: no self
	return FrameReportRender[key]
end

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
function FrameReportRender:key( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return 'pickle-report-frame-' ..  keep
end

--- Append same type to first
-- @param any to act as the head
-- @param any to act as the tail
-- @return self
function FrameReportRender:append( head, tail ) -- luacheck: no self
	assert( head )
	assert( tail )
	return head .. ' ' .. tail
end

--- Realize reported data for state
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
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
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameReportRender:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	if not ( src:isSkip() or src:hasSkip() ) then
		return ''
	end

	local realization = ''
	local inner = src:getSkip()
		and mw.message.newRawMessage( src:getSkip() )
		or mw.message.new( 'pickle-test-text-skip-no-description' )

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
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameReportRender:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	if not ( src:isTodo() or src:hasTodo() ) then
		return ''
	end

	local realization = ''
	local inner = src:getTodo()
		and mw.message.newRawMessage( src:getTodo() )
		or mw.message.new( 'pickle-test-text-todo-no-description' )

	if lang then
		inner:inLanguage( lang )
	end

	if not inner:isDisabled() then
		realization = inner:plain()
	end

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
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
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
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameReportRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang ) }
	--local t = {  }

	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:hasSkip() or src:isTodo() or src:hasTodo() then
		if src:isSkip() or src:hasSkip() then
			table.insert( t, self:realizeSkip( src, lang ) )
		end
		if src:isTodo() or src:hasTodo() then
			table.insert( t, self:realizeTodo( src, lang ) )
		end
	end

	return table.concat( t, ' ' )
end

--- Realize reported data for body
-- The "body" is a composite.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameReportRender:realizeBody( src, lang ) -- luacheck: ignore self lang
	assert( src, 'Failed to provide a source' )

	local t = {}

--[[
	for _,v in ipairs( { src:constituents():export() } ) do
		table.insert( t, self:realize( v, lang ) )
	end
]]
	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class
return FrameReportRender
