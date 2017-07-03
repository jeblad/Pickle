--- Baseclass for renders

-- @var class var for lib
local Render = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Render:__index( key ) -- luacheck: no self
	return Render[key]
end

--- Create a new instance
-- @param vararg unused
-- @return Render
function Render.create( ... )
	local self = setmetatable( {}, Render )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Render
function Render:_init( ... ) -- luacheck: no unused args
	self._type = 'base-render'
	return self
end

--- Override key construction
-- Sole purpose of this is to do assertions, and the provided key is never be used.
-- @param string to be appended to a base string
-- @return string
function Render:key( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return 'pickle-report-base-' .. keep
end

--- Get the type of report
-- All reports has an explicit type name.
-- @return string
function Render:type()
	return self._type
end

--- Append same type to first
-- This should probably always be string types. The base version only concatenates strinsg.
-- @param any to act as the head
-- @param any to act as the tail
-- @return any
function Render:append( head, tail ) -- luacheck: no self
	assert( head )
	assert( tail )
	return head .. ' ' .. tail
end

--- Realize clarification
-- @param string part of a message key
-- @param string optional language code
-- @return string
function Render:realizeClarification( keyPart, lang, counter )
	assert( keyPart, 'Failed to provide a key part' )

	local orig
	if counter then
		orig = mw.message.new( self:key( keyPart .. '-original-num' ), counter() )
	else
		orig = mw.message.new( self:key( keyPart .. '-original' ) )
	end
	orig:inLanguage( 'en' )

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
function Render:realizeComment( src, keyPart, lang )
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
		and mw.message.new( self:key( 'wrap-no-comment' ), clar )
		or mw.message.new( self:key( 'wrap-comment' ), clar, desc:plain() )

	if lang then
		msg:inLanguage( lang )
	end

	return msg:plain()
end

-- Return the final class
return Render
