--- Final class for vivid report renderer.
-- This class follows the pattern from [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderAdaptVivid
-- @alias Subclass

-- pure libs
local Super = require 'picklelib/render/RenderAdapt'

-- @var final class
local Subclass = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see RenderAdapt:create
-- @tparam vararg ... forwarded to @{RenderAdapt:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... forwarded to @{RenderAdapt:_init|superclass init method}
-- @return self
function Subclass:_init( ... )
	Super._init( self, ... )
	self._type = self._type .. '-vivid'
	return self
end

--- Override realization of reported data for state.
-- @tparam Report src that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @tparam[opt=nil] Counter counter holding the running count
-- @treturn html
function Subclass:realizeState( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-state' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeState( self, src, lang, counter ) )

	return html
end

--- Override realization of reported data for header.
-- @tparam Report src that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @tparam[opt=nil] Counter counter holding the running count
-- @treturn html
function Subclass:realizeHeader( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'div' )
		:addClass( 'mw-pickle-header' )
		:node( self:realizeState( src, lang, counter ) )

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

--- Override realization of reported data for line.
-- @tparam any param that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @return html
function Subclass:realizeLine( param, lang )
	assert( param, 'Failed to provide a parameter' )

	local html = mw.html.create( 'dd' )
		:addClass( 'mw-pickle-line' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:node( Super.realizeLine( self, param, lang ) )

	return html
end

--- Override realization of reported data for body.
-- The "body" is a composite.
-- @todo this should probably be realize() as it should contain
-- the header as a "dt".
-- @tparam Report src that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @treturn html
function Subclass:realizeBody( src, lang )
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

-- Return the final class.
return Subclass
