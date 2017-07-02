--- Subclass for frame report renderer

-- pure libs
local Base = require 'picklelib/render/FrameRender'

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
	return self
end

--- Append same type to first
-- @param any to act as the head
-- @param any to act as the tail
-- @return self
function FrameRender:append( head, tail ) -- luacheck: no self
	assert( head )
	assert( tail )
	return head:node( tail )
end

--- Override realization of reported data for state
-- @param Report that shall be realized
-- @param string language code used for realization
-- @param Counter holding the running count
-- @return html
function FrameRender:realizeState( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-state' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeState( self, src, lang, counter ) )

	return html
end

--- Override realization of reported data for skip
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return html
function FrameRender:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-skip' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeSkip( self, src, lang ) )

	return html
end

--- Override realization of reported data for todo
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return html
function FrameRender:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-todo' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeTodo( self, src, lang ) )

	return html
end

--- Override realization of reported data for description
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return html
function FrameRender:realizeDescription( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-description' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeDescription( self, src, lang ) )

	return html
end

--- Realize reported data for header
-- The "header" is a composite.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @param Counter holding the running count
-- @return html
function FrameRender:realizeHeader( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'div' )
		:addClass( 'mw-pickle-header' )

	html:node( self:realizeState( src, lang, counter ) )

	if src:hasDescription() then
		html:node( self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:hasSkip() or src:isTodo() or src:hasTodo() then
		local comment = mw.html.create( 'span' )
			:addClass( 'mw-pickle-comment' )
			:wikitext( ' ' )
		if src:isSkip() or src:hasSkip() then
			comment:node( self:realizeSkip( src, lang ) )
		elseif src:isTodo() or src:hasTodo() then
			comment:node( self:realizeTodo( src, lang ) )
		end
		html:node( comment )
	end

	return html
end

-- Return the final class
return FrameRender
