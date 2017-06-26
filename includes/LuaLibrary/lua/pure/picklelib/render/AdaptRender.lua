--- Baseclass for report renderer

-- non-pure libs
local Base = require 'picklelib/render/RenderBase'

-- @var class var for lib
local AdaptRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function AdaptRender:__index( key ) -- luacheck: no self
	return AdaptRender[key]
end

-- @var metatable for the class
setmetatable( AdaptRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return AdaptRender
function AdaptRender.create( ... )
	local self = setmetatable( {}, AdaptRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return AdaptRender
function AdaptRender:_init( ... ) -- luacheck: no unused args
	Base._init( self, ... )
	return self
end

--- Override key construction
-- @param string to be appended to a base string
-- @return string
function AdaptRender:key( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return 'pickle-report-adapt-' .. keep
end

--- Realize reported data for state
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function AdaptRender:realizeState( src, lang )
	assert( src, 'Failed to provide a source' )

	local orig = mw.message.new(
		src:isOk() and self:key( 'is-ok-original' ) or self:key( 'is-not-ok-original' ) )

	-- previous is always in English, so no lang statement here
	-- it should neither be disabled, so don't bother testing for that

	local trans = mw.message.new(
		src:isOk() and self:key( 'is-ok-translated' ) or self:key( 'is-not-ok-translated' ) )

	if lang then
		trans:inLanguage( lang )
	end

	local msg = trans:isDisabled()
		and mw.message.new( self:key( 'wrap-untranslated' ), orig:plain() )
		or mw.message.new( self:key( 'wrap-translated' ), orig:plain(), trans:plain() )

	if lang then
		msg:inLanguage( lang )
	end

	if msg:isDisabled() then
		return ''
	end

	return msg:plain()
end

--- Realize reported data for header
-- The "header" is a composite.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function AdaptRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang ) }
--[[
	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end
]]
	if src:isSkip() or src:isTodo() then
		table.insert( t, '# ' )
		table.insert( t, self:realizeSkip( src, lang ) )
		table.insert( t, self:realizeTodo( src, lang ) )
	end

	return table.concat( t, '' )
end

--- Realize reported data for a line
-- @param any that shall be realized
-- @param string language code used for realization
-- @return string
function AdaptRender:realizeLine( param, lang )
	assert( param, 'Failed to provide a parameter' )

	local realization = ''
	local inner = mw.message.new( unpack( param ) )

	if lang then
		inner:inLanguage( lang )
	end

	if not inner:isDisabled() then
		realization = inner:plain()
	end

	realization = mw.text.encode( realization )

	local outer = mw.message.new( self:key( 'wrap-line' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for body
-- The "body" is a composite.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function AdaptRender:realizeBody( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = {}

	for _,v in ipairs( { src:lines():export() } ) do
		table.insert( t, self:realizeLine( v, lang ) )
	end

	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class
return AdaptRender
