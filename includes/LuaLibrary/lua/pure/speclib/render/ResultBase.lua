--- Baseclass for report renderer

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
    error('Method should be overridden')
    return nil
end

function Render:realizeSkip( src, lang )

    if not src:hasSkip() then
        return ''
    end

    local realization = ''
    local inner = mw.message.new( src:getSkip() )

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

function Render:realizeTodo( src, lang )

    if not src:hasTodo() then
        return ''
    end

    local realization = src:getTodo()
    local outer = mw.message.new( self:key( 'wrap-todo' ), realization )

    if lang then
        outer:inLanguage( lang )
    end

    if outer:isDisabled() then
        return realization
    end

    return outer:plain()
end

function Render:realizeDescription( src, lang )

    if not src:hasDescription() then
        return ''
    end

    local realization = src:getDescription()
    local outer = mw.message.new( self:key( 'wrap-description' ), realization )

    if lang then
        outer:inLanguage( lang )
    end

    if outer:isDisabled() then
        return realization
    end

    return outer:plain()
end

function Render:realizeState( src, lang )

    local msg = mw.message.new( src:isOk() and self:key( 'is-ok' ) or self:key( 'is-not-ok' ) )

    if lang then
        msg:inLanguage( lang )
    end

    if msg:isDisabled() then
        return ''
    end

    return msg:plain()
end

function Render:realizeHeader( src, lang )
    local t = { self:realizeState( src, lang ) }

    if src:hasDescription() then
        table.insert( t, self:realizeDescription( src, lang ) )
    end

    if src:hasSkip() or src:hasTodo() then
        table.insert( t, '# ' )
        table.insert( t, self:realizeSkip( src, lang ) )
        table.insert( t, self:realizeTodo( src, lang ) )
    end

    return table.concat( t, '' )
end

function Render:realizeLine( param, lang )

    local realization = ''
    local inner = mw.message.new( unpack( param ) )

    if lang then
        inner:inLanguage( lang )
    end

    if not inner:isDisabled() then
        realization = inner:plain()
    end

    local outer = mw.message.new( self:key( 'wrap-line' ), realization )

    if lang then
        outer:inLanguage( lang )
    end

    if outer:isDisabled() then
        return realization
    end

    return outer:plain()
end

function Render:realizeBody( src, lang )

    local t = {}

    for _,v in ipairs( { src:lines() } ) do
        table.insert( t, self:realizeLine( v, lang ) )
    end

    return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end


return Render
