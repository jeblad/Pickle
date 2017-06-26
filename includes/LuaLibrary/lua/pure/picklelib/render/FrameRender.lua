--- Baseclass for frame report renderer

-- non-pure libs
local Base = require 'picklelib/render/RenderBase'

-- @var class var for lib
local FrameRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function FrameRender:__index( key ) -- luacheck: no self
	return FrameRender[key]
end

-- @var metatable for the class
setmetatable( FrameRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return FrameRender
function FrameRender.create( ... )
	local self = setmetatable( {}, FrameRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return FrameRender
function FrameRender:_init( ... ) -- luacheck: no unused args
	Base._init( self, ... )
	return self
end

--- Override key construction
-- @param string to be appended to a base string
-- @return string
function FrameRender:key( str )
	Base._init( self, str )
	return 'pickle-report-frame-' .. str
end

--- Append same type to first
-- @param any to act as the head
-- @param any to act as the tail
-- @return self
function FrameRender:append( head, tail ) -- luacheck: no self
	assert( head )
	assert( tail )
	return head .. ' ' .. tail
end

--- Realize clarification
-- @param string part of a message key
-- @param string optional language code
-- @return string
function FrameRender:realizeClarification( keyPart, lang )
	assert( keyPart, 'Failed to provide a key part' )

	local orig = mw.message.new( self:key( keyPart .. '-original' ) )
	local trans = mw.message.new( self:key( keyPart .. '-translated' ) )

	if lang then
		trans:inLanguage( lang )
	end

	local msg = trans:isDisabled()
		and mw.message.new( self:key( 'wrap-untranslated' ), orig:plain() )
		or mw.message.new( self:key( 'wrap-translated' ), orig:plain(), trans:plain() )

	if lang then
		msg:inLanguage( lang )
	end

	return msg:plain()
end

--- Realize comment
-- @param Report that shall be realized
-- @param string part of a message key
-- @param string optional language code
-- @return string
function FrameRender:realizeComment( src, keyPart, lang )
	assert( src, 'Failed to provide a source' )

	local ucfKeyPart = string.upper( string.sub( keyPart, 1, 1 ) )..string.sub( keyPart, 2 )
	if not ( src['is'..ucfKeyPart]( src ) or src['has'..ucfKeyPart]( src ) ) then
		return ''
	end

	local get = src['get'..ucfKeyPart]
	local desc = get( src )
		and mw.message.newRawMessage( get( src ) )
		or mw.message.new( 'pickle-report-frame-' .. keyPart .. '-no-description' )

	if lang then
		desc:inLanguage( lang )
	end

	local clar = self:realizeClarification( 'is-' .. keyPart, lang )

	local msg = desc:isDisabled()
		and mw.message.new( self:key( 'wrap-no-description' ), clar )
		or mw.message.new( self:key( 'wrap-description' ), clar, desc:plain() )

	if lang then
		msg:inLanguage( lang )
	end

	return msg:plain()
end

--- Realize reported data for state
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameRender:realizeState( src, lang )
	assert( src, 'Failed to provide a source' )

	return self:realizeClarification( src:isOk() and 'is-ok' or 'is-not-ok', lang )
end

--- Realize reported data for skip
-- The "skip" is a message identified by a key.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameRender:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	return self:realizeComment( src, 'skip', lang )
end

--- Realize reported data for todo
-- The "todo" is a text string.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameRender:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	return self:realizeComment( src, 'todo', lang )
end

--- Realize reported data for description
-- The "description" is a text string.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function FrameRender:realizeDescription( src, lang )
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
function FrameRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang ) }

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
function FrameRender:realizeBody( src, lang ) -- luacheck: ignore self lang
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
return FrameRender
