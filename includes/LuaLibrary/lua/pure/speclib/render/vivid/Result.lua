--- Subclass for report renderer

local Base = require 'speclib/render/ResultBase'

local Render = {}
Render.__index = Render

function Render.create( ... )
    local self = setmetatable( {}, Render )
    self:_init( ... )
    return self
end

function Render:_init( ... )
    return self
end

function Render:key( str )
    return 'spec-report-vivid-' .. str
end

function Render:realizeSkip( src, lang )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-skip' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeSkip( self, src, lang ) )

    return html
end

function Render:realizeTodo( src, lang )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-todo' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeTodo( self, src, lang ) )

    return html
end

function Render:realizeDescription( src, lang )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-description' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeDescription( self, src, lang ) )

    return html
end

function Render:realizeState( src, lang )

    local html = mw.html.create( 'span' )
        :addClass( 'mw-spec-state' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:wikitext( Base.realizeState( self, src, lang ) )

    return html
end

function Render:realizeHeader( src, lang )
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

function Render:realizeLine( param, lang )
    local html = mw.html.create( 'dd' )
        :addClass( 'mw-spec-line' )

    if lang then
        html:attr( 'lang', lang )
    end

    html:node( Base.realizeLine( self, param, lang ) )

    return html
end

-- @todo this should probably be realize() as it should contain
-- the header as a dt
function Render:realizeBody( src, lang )

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


return Render
