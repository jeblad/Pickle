--- Intermediate class for case report renderer.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderCase
-- @alias Subclass

-- pure libs
local libUtil = require 'libraryUtil'

-- @var super class
local Super = require 'picklelib/render/Render'

-- @var intermediate class
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'RenderCase:__index', 1, key, 'string', false )
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see Render:create
-- @tparam vararg ... forwarded to @{Render:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @tparam vararg ... forwarded to @{Render:_init|superclass init method}
-- @return self
function Subclass:_init( ... )
	Super._init( self, ... )
	self._type = self._type .. '-case'
	return self
end

--- Override key construction.
-- @tparam string str to be appended to a base string
-- @treturn string
function Subclass:key( str )
	return 'pickle-report-case-' .. self:cleanKey( str )
end

--- Realize reported data for state.
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @tparam nil|Counter counter holding the running count
-- @treturn string
function Subclass:realizeState( src, lang, counter )
	assert( src, 'Failed to provide a source' )

	return self:realizeClarification( src:isOk() and 'is-ok' or 'is-not-ok', lang, counter )
end

--- Realize reported data for skip.
-- The "skip" is a message identified by a key.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn string
function Subclass:realizeSkip( src, lang )
	-- src tested in later call
	-- lang tested in later call

	return self:realizeComment( src, 'skip', lang )
end

--- Realize reported data for todo.
-- The "todo" is a text string.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn string
function Subclass:realizeTodo( src, lang )
	-- src tested in later call
	-- lang tested in later call

	return self:realizeComment( src, 'todo', lang )
end

--- Realize reported data for description.
-- The "description" is a text string.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization (unused)
-- @treturn string
function Subclass:realizeDescription( src, lang ) -- luacheck: no unused args
	libUtil.checkType( 'RenderCase:realizeDescription', 1, src, 'table', false )

	if not src:hasDescription() then
		return ''
	end

	return src:getDescription()
end

--- Realize reported data for name.
-- The "name" is a text string.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization (unused)
-- @treturn string
function Subclass:realizeName( src, lang ) -- luacheck: no unused args
	libUtil.checkType( 'RenderCase:realizeName', 1, src, 'table', false )

	if not src:hasName() then
		return ''
	end

	return self:realizeClarification( src:getName(), lang )
end

--- Realize reported data for header.
-- The "header" is a composite.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @tparam nil|Counter counter holding the running count
-- @treturn string
function Subclass:realizeHeader( src, lang, counter )
	libUtil.checkType( 'RenderCase:realizeHeader', 1, src, 'table', false )
	-- lang tested in later call
	-- counter tested in later call

	local t = { self:realizeState( src, lang, counter ) }

	if src:hasName() then
		table.insert( t, self:realizeName( src, lang ) )
	end

	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end

	if src:isSkip() or src:hasSkip() or src:isTodo() or src:hasTodo() then
		table.insert( t, '#' )
	end

	if src:isSkip() or src:hasSkip() then
		table.insert( t, self:realizeSkip( src, lang ) )
	end

	if src:isTodo() or src:hasTodo() then
		table.insert( t, self:realizeTodo( src, lang ) )
	end

	return table.concat( t, ' ' )
end

--- Realize reported data for body.
-- The "body" is a composite.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization (unused)
-- @treturn string
function Subclass:realizeBody( src, lang ) -- luacheck: ignore self lang
	libUtil.checkType( 'RenderCase:realizeBody', 1, src, 'table', false )

	local t = {}

--[[
	for _,v in ipairs( { src:constituents():export() } ) do
		table.insert( t, self:realize( v, lang ) )
	end
]]
	return #t == 0 and '' or ( "\n" .. table.concat( t, "\n" ) )
end

-- Return the final class.
return Subclass
