--- Baseclass for report renderer
-- luacheck: globals mw

-- @var class var for lib
local AdaptReportRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function AdaptReportRender:__index( key ) -- luacheck: no self
	return AdaptReportRender[key]
end

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
function AdaptReportRender:key( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return keep
end

--- Realize reported data for state
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function AdaptReportRender:realizeState( src, lang )
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
-- @param Report that shall be realized
-- @param string language code used for realization
-- @return string
function AdaptReportRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang ) }

	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end

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
function AdaptReportRender:realizeLine( param, lang )
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
function AdaptReportRender:realizeBody( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = {}

	for _,v in ipairs( { src:lines():export() } ) do
		table.insert( t, self:realizeLine( v, lang ) )
	end

	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class
return AdaptReportRender
