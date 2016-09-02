--- Subclass for report renderer

-- pure libs
local Base = require 'speclib/render/ResultBase'

-- @var class var for lib
local Render = {}

--- Lookup of missing class members
function Render:__index( key )
    return Render[key]
end

-- @var metatable for the class
setmetatable( Render, { __index = Base } )

--- Create a new instance
function Render.create( ... )
    local self = setmetatable( {}, Render )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function Render:_init( ... )
    return self
end

--- Override key construction
function Render:key( str )
    assert( str, 'Failed to provide a string' )
    return 'spec-report-vivid-' .. str
end

--- Override realization of reported data for skip
function Render:realizeSkip( src, lang )
    assert( src, 'Failed to provide a source' )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-skip' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeSkip( self, src, lang ) )

    return html
end

--- Override realization of reported data for todo
function Render:realizeTodo( src, lang )
    assert( src, 'Failed to provide a source' )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-todo' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeTodo( self, src, lang ) )

    return html
end

--- Override realization of reported data for description
function Render:realizeDescription( src, lang )
    assert( src, 'Failed to provide a source' )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-description' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeDescription( self, src, lang ) )

    return html
end

--- Override realization of reported data for state
function Render:realizeState( src, lang )
    assert( src, 'Failed to provide a source' )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-state' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeState( self, src, lang ) )

    return html
end

--- Override realization of reported data for header
function Render:realizeHeader( src, lang )
    assert( src, 'Failed to provide a source' )

    local html = mw.html.create( 'div' )
        :addClass( 'mw-spec-header' )
        :node( self:realizeState( src, lang ) )

    if src:hasDescription() then
        html:node( self:realizeDescription( src, lang ) )
    end

    if src:hasSkip() or src:hasTodo() then
        local comment = mw.html.create( 'span' )
            :addClass( 'mw-spec-comment' )
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
function Render:realizeLine( param, lang )
    assert( param, 'Failed to provide a parameter' )

    local html = mw.html.create( 'dd' )
        :addClass( 'mw-spec-line' )

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
function Render:realizeBody( src, lang )
    assert( src, 'Failed to provide a source' )

    if src:numLines() > 0 then
        local html = mw.html.create( 'dl' )
            :addClass( 'mw-spec-body' )

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
return Render
