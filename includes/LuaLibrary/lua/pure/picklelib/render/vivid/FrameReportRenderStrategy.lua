--- Subclass for frame report renderer

-- pure libs
local Base = require 'picklelib/render/FrameReportRenderBase'

-- @var class var for lib
local FrameReportRender = {}

--- Lookup of missing class members
function FrameReportRender:__index( key ) -- luacheck: ignore self
	return FrameReportRender[key]
end

-- @var metatable for the class
setmetatable( FrameReportRender, { __index = Base } )

--- Create a new instance
function FrameReportRender.create( ... )
	local self = setmetatable( {}, FrameReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function FrameReportRender:_init( ... ) -- luacheck: ignore
	return self
end

--- Override key construction
function FrameReportRender:key( str ) -- luacheck: ignore self
	assert( str, 'Failed to provide a string' )
	return 'pickle-report-frame-vivid-' .. str
end

--- Override realization of reported data for state
function FrameReportRender:realizeState( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-state' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeState( self, src, lang ) )

	return html
end

--- Override realization of reported data for skip
function FrameReportRender:realizeSkip( src, lang )
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
function FrameReportRender:realizeTodo( src, lang )
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
function FrameReportRender:realizeDescription( src, lang )
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
function FrameReportRender:realizeHeader( src, lang ) -- luacheck: ignore self lang
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'div' )
		:addClass( 'mw-pickle-header' )

	html:node( self:realizeState( src, lang ) )

	if src:hasDescription() then
		html:node( self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:hasSkip() or src:isTodo() or src:hasTodo() then
		local comment = mw.html.create( 'span' )
			:addClass( 'mw-pickle-comment' )
			:wikitext( '# ' )
		if src:isSkip() or src:hasSkip() then
			comment:node( self:realizeSkip( src, lang ) )
		end
		if src:isTodo() or src:hasTodo() then
			comment:node( self:realizeTodo( src, lang ) )
		end
		html:node( comment )
	end

	return html
end

-- Return the final class
return FrameReportRender
