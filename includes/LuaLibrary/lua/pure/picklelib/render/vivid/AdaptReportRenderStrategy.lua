--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/AdaptReportRenderBase'

-- @var class var for lib
local AdaptReportRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function AdaptReportRender:__index( key ) -- luacheck: no self
	return AdaptReportRender[key]
end

-- @var metatable for the class
setmetatable( AdaptReportRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return AdaptReportRender
function AdaptReportRender.create( ... )
	local self = setmetatable( {}, AdaptReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return AdaptReportRender
function AdaptReportRender:_init( ... ) -- luacheck: no unused args
	return self
end

--- Override key construction
-- @param string to be appended to a base string
-- @return string
function AdaptReportRender:key( str )
	return 'pickle-report-adapt-vivid-' ..  Base.key( self, str )
end

--- Override realization of reported data for state
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return html
function AdaptReportRender:realizeState( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-state' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeState( self, src, lang ) )

	return html
end

--- Override realization of reported data for header
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return html
function AdaptReportRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'div' )
		:addClass( 'mw-pickle-header' )
		:node( self:realizeState( src, lang ) )

	if src:hasDescription() then
		html:node( self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:isTodo() then
		local comment = mw.html.create( 'span' )
			:addClass( 'mw-pickle-comment' )
			:wikitext( '# ' )
		if src:isSkip() then
			comment:node( self:realizeSkip( src, lang ) )
		end
		if src:isTodo() then
			comment:node( self:realizeTodo( src, lang ) )
		end
		html:node( comment )
	end

	return html
end

--- Override realization of reported data for line
-- @param any that shall be realized
-- @param string language code used for realization
-- @return html
function AdaptReportRender:realizeLine( param, lang )
	assert( param, 'Failed to provide a parameter' )

	local html = mw.html.create( 'dd' )
		:addClass( 'mw-pickle-line' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:node( Base.realizeLine( self, param, lang ) )

	return html
end

--- Override realization of reported data for body
-- The "body" is a composite.
-- @todo this should probably be realize() as it should contain
-- the header as a "dt".
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return html
function AdaptReportRender:realizeBody( src, lang )
	assert( src, 'Failed to provide a source' )

	if src:numLines() > 0 then
		local html = mw.html.create( 'dl' )
			:addClass( 'mw-pickle-body' )

		if not src:isOk() then
			html:css( 'display', 'none')
		end

		for _,v in ipairs( { src:lines():export() } ) do
			html:node( self:realizeLine( v, lang ) )
		end

		return html
	end

	return '' -- @todo is this right?
end

-- Return the final class
return AdaptReportRender
