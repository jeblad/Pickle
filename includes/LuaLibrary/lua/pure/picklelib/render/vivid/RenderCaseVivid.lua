--- Final class for case report renderer.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderCaseVivid
-- @alias Subclass

-- pure libs
local libUtil = require 'libraryUtil'

-- @var super class
local Super = require 'picklelib/render/RenderCase'

-- @var final class
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'RenderCaseVivid:__index', 1, key, 'string', false )
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see RenderCase:create
-- @tparam vararg ... forwarded to @{RenderCase:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @tparam vararg ... forwarded to @{RenderCase:_init|superclass init method}
-- @return self
function Subclass:_init( ... )
	Super._init( self, ... )
	self._type = self._type .. '-vivid'
	return self
end

--- Append same type to first.
-- @raise on wrong arguments
-- @tparam any head to act as the head
-- @tparam any tail to act as the tail
-- @treturn self
function Subclass:append( head, tail ) -- luacheck: no self
	libUtil.checkType( 'RenderCaseVivid:append', 1, head, 'table', false )
	libUtil.checkType( 'RenderCaseVivid:append', 2, tail, 'string', false )
	head:node( tail )
	return self
end

--- Override realization of reported data for state.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @tparam nil|Counter counter holding the running count
-- @treturn html
function Subclass:realizeState( src, lang, counter )
	-- src tested in later call
	libUtil.checkType( 'RenderCaseVivid:realizeState', 2, lang, 'string', true )
	-- counter tested in later call

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-state' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeState( self, src, lang, counter ) )

	return html
end

--- Override realization of reported data for skip.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn html
function Subclass:realizeSkip( src, lang )
	-- src tested in later call
	-- lang tested in later call
	-- counter tested in later call

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-skip' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeSkip( self, src, lang ) )

	return html
end

--- Override realization of reported data for todo.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn html
function Subclass:realizeTodo( src, lang )
	-- src tested in later call
	-- lang tested in later call
	-- counter tested in later call

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-todo' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeTodo( self, src, lang ) )

	return html
end

--- Override realization of reported data for description.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn html
function Subclass:realizeDescription( src, lang )
	-- src tested in later call
	-- lang tested in later call
	-- counter tested in later call

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-description' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeDescription( self, src, lang ) )

	return html
end

--- Override realization of reported data for name.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn html
function Subclass:realizeName( src, lang )
	-- src tested in later call
	-- lang tested in later call
	-- counter tested in later call

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-name' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Super.realizeName( self, src, lang ) )

	return html
end

--- Realize reported data for header.
-- The "header" is a composite.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @tparam nil|Counter counter holding the running count
-- @treturn html
function Subclass:realizeHeader( src, lang, counter )
	libUtil.checkType( 'RenderCaseVivid:realizeHeader', 1, src, 'table', false )
	-- lang tested in later call
	-- counter tested in later call

	local html = mw.html.create( 'div' )
		:addClass( 'mw-pickle-header' )

	html:node( self:realizeState( src, lang, counter ) )

	if src:hasName() then
		html:node( self:realizeName( src, lang ) )
	end

	if src:hasDescription() then
		html:node( self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:hasSkip() or src:isTodo() or src:hasTodo() then
		local comment = mw.html.create( 'div' )
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
