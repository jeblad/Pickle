--- Intermediate class for report renderer.
-- @classmod AdaptRender
-- @alias Render

-- non-pure libs
local Super = require 'picklelib/render/RenderBase'

-- @var class var for lib
local Render = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Render:__index( key ) -- luacheck: no self
	return Render[key]
end

-- @var metatable for the class
setmetatable( Render, { __index = Super } )

--- Create a new instance.
-- @see RenderBase:create
-- @tparam vararg ... unused
-- @treturn AdaptRender|any
function Render:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @return self
function Render:_init( ... ) -- luacheck: no unused args
	Super._init( self, ... )
	return self
end

--- Override key construction.
-- @tparam string str to be appended to a base string
-- @treturn string
function Render:key( str )
	Super._init( self, str )
	return 'pickle-report-adapt-' .. str
end

--- Realize reported data for state.
-- @tparam Report src that shall be realized
-- @tparam string lang code used for realization
-- @tparam Counter counter holding the running count
-- @treturn string
function Render:realizeState( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	return self:realizeClarification( src:isOk() and 'is-ok' or 'is-not-ok', lang, counter )
end

--- Realize reported data for header.
-- The "header" is a composite.
-- @tparam Report src that shall be realized
-- @tparam string lang code used for realization
-- @tparam Counter counter holding the running count
-- @treturn string
function Render:realizeHeader( src, lang, counter )
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

--- Realize reported data for a line.
-- @tparam any param that shall be realized
-- @tparam string lang code used for realization
-- @treturn string
function Render:realizeLine( param, lang ) -- luacheck: no self
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

--- Realize reported data for body.
-- The "body" is a composite.
-- @tparam Report src that shall be realized
-- @tparam string lang code used for realization
-- @treturn string
function Render:realizeBody( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = {}

	for _,v in ipairs( { src:lines():export() } ) do
		table.insert( t, self:realizeLine( v, lang ) )
	end

	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class.
return Render
