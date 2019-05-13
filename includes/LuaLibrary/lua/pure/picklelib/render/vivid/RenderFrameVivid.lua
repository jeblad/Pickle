--- Final class for frame report renderer.
-- This class follows the pattern from [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderFrameVivid
-- @alias Subclass

-- pure libs
local Super = require 'picklelib/render/RenderFrame'

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
-- @see RenderFrame:create
-- @tparam vararg ... forwarded to @{RenderFrame:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... forwarded to @{RenderFrame:_init|superclass init method}
-- @return self
function Subclass:_init( ... )
	Super._init( self, ... )
	self._type = 'render-frame-vivid'
	return self
end

--- Append same type to first.
-- @tparam any head to act as the head
-- @tparam any tail to act as the tail
-- @treturn self
function Subclass:append( head, tail ) -- luacheck: no self
	assert( head )
	assert( tail )
	head:node( tail )
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

--- Override realization of reported data for skip.
-- @tparam Report src that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @treturn html
function Subclass:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-skip' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeSkip( self, src, lang ) )

	return html
end

--- Override realization of reported data for todo.
-- @tparam Report src that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @treturn html
function Subclass:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-todo' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeTodo( self, src, lang ) )

	return html
end

--- Override realization of reported data for description.
-- @tparam Report src that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @treturn html
function Subclass:realizeDescription( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-description' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeDescription( self, src, lang ) )

	return html
end

--- Realize reported data for header.
-- The "header" is a composite.
-- @tparam Report src that shall be realized
-- @tparam[opt=nil] string lang code used for realization
-- @tparam[opt=nil] Counter counter holding the running count
-- @treturn html
function Subclass:realizeHeader( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'div' )
		:addClass( 'mw-pickle-header' )

	html:node( self:realizeState( src, lang, counter ) )

	if src:hasDescription() then
		html:node( self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:hasSkip() or src:isTodo() or src:hasTodo() then
		local comment = mw.html.create( 'span' )
			:addClass( 'mw-pickle-comment' )
			:wikitext( ' ' )
		if src:isSkip() or src:hasSkip() then
			comment:node( self:realizeSkip( src, lang ) )
		elseif src:isTodo() or src:hasTodo() then
			comment:node( self:realizeTodo( src, lang ) )
		end
		html:node( comment )
	end

	return html
end

-- Return the final class.
return Subclass
