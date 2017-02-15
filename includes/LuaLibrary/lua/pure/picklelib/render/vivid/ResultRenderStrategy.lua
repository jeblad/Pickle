--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/ResultRenderBase'

-- @var class var for lib
local ResultRender = {}

--- Lookup of missing class members
function ResultRender:__index( key )
    return ResultRender[key]
end

-- @var metatable for the class
setmetatable( ResultRender, { __index = Base } )

--- Create a new instance
function ResultRender.create( ... )
    local self = setmetatable( {}, ResultRender )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function ResultRender:_init( ... )
    return self
end

--- Override key construction
function ResultRender:key( str )
    assert( str, 'Failed to provide a string' )
    return 'pickle-report-result-vivid-' .. str
end

--- Override realization of reported data for skip
function ResultRender:realizeSkip( src, lang )
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
function ResultRender:realizeTodo( src, lang )
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
function ResultRender:realizeDescription( src, lang )
    assert( src, 'Failed to provide a source' )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-pickle-description' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeDescription( self, src, lang ) )

    return html
end

--- Override realization of reported data for state
function ResultRender:realizeState( src, lang )
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
function ResultRender:realizeHeader( src, lang )
    assert( src, 'Failed to provide a source' )

    local html = mw.html.create( 'div' )
        :addClass( 'mw-pickle-header' )
        :node( self:realizeState( src, lang ) )

    if src:hasDescription() then
        html:node( self:realizeDescription( src, lang ) )
    end

    if src:hasSkip() or src:hasTodo() then
        local comment = mw.html.create( 'span' )
            :addClass( 'mw-pickle-comment' )
            :wikitext( '# ' )
        if src:hasSkip() then
            comment:node( self:realizeSkip( src, lang ) )
        end
        if src:hasTodo() then
            comment:node( self:realizeTodo( src, lang ) )
        end
        html:node( comment )
    end

    return html
end

--- Override realization of reported data for line
function ResultRender:realizeLine( param, lang )
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
function ResultRender:realizeBody( src, lang )
    assert( src, 'Failed to provide a source' )

    if src:numLines() > 0 then
        local html = mw.html.create( 'dl' )
            :addClass( 'mw-pickle-body' )

        if not src:isOk() then
            html:css( 'display', 'none')
        end

        for _,v in ipairs( { src:lines() } ) do
            html:node( self:realizeLine( v, lang ) )
        end

        return html
    end

    return ''
end

-- Return the final class
return ResultRender
