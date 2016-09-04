--- Baseclass for report renderer

-- @var class var for lib
local ResultRender = {}

--- Lookup of missing class members
function ResultRender:__index( key )
    return ResultRender[key]
end

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
    error('Method should be overridden')
    return nil
end

--- Realize reported data for skip
-- The "skip" is a message identified by a key.
function ResultRender:realizeSkip( src, lang )
    assert( src, 'Failed to provide a source' )

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

--- Realize reported data for todo
-- The "todo" is a text string.
function ResultRender:realizeTodo( src, lang )
    assert( src, 'Failed to provide a source' )

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

--- Realize reported data for description
-- The "description" is a text string.
function ResultRender:realizeDescription( src, lang )
    assert( src, 'Failed to provide a source' )

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

--- Realize reported data for state
function ResultRender:realizeState( src, lang )
    assert( src, 'Failed to provide a source' )

    local msg = mw.message.new( src:isOk() and self:key( 'is-ok' ) or self:key( 'is-not-ok' ) )

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
function ResultRender:realizeHeader( src, lang )
    assert( src, 'Failed to provide a source' )

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

--- Realize reported data for a line
function ResultRender:realizeLine( param, lang )
    assert( param, 'Failed to provide a parameter' )

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

--- Realize reported data for body
-- The "body" is a composite.
function ResultRender:realizeBody( src, lang )
    assert( src, 'Failed to provide a source' )

    local t = {}

    for _,v in ipairs( { src:lines() } ) do
        table.insert( t, self:realizeLine( v, lang ) )
    end

    return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class
return ResultRender
