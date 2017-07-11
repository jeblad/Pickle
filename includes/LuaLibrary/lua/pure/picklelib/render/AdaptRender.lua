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
function AdaptRender:key( str )
	Base._init( self, str )
	return 'pickle-report-adapt-' .. str
end

--- Realize reported data for state
-- @param Report that shall be realized
-- @param string language code used for realization
-- @param Counter holding the running count
-- @return string
function AdaptRender:realizeState( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	return self:realizeClarification( src:isOk() and 'is-ok' or 'is-not-ok', lang, counter )
end

--- Realize reported data for header
-- The "header" is a composite.
-- @param Report that shall be realized
-- @param string language code used for realization
-- @param Counter holding the running count
-- @return string
function AdaptRender:realizeHeader( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang, counter ) }
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
function AdaptRender:realizeLine( param, lang ) -- luacheck: no self
	assert( param, 'Failed to provide a parameter' )

	local line = mw.message.new( unpack( param ) )

	if lang then
		line:inLanguage( lang )
	end

	if line:isDisabled() then
		return ''
	end

	return mw.text.encode( line:plain() )
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
