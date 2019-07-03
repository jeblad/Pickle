--- Intermediate class for report renderer.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderAdapt
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
	libUtil.checkType( 'RenderAdapt:__index', 1, key, 'string', false )
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
	self._type = self._type .. '-adapt'
	return self
end

--- Override key construction.
-- @raise on wrong arguments
-- @tparam string str to be appended to a base string
-- @treturn string
function Subclass:key( str )
	return 'pickle-report-adapt-' .. self:cleanKey( str )
end

--- Realize reported data for state.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @tparam nil|Counter counter holding the running count
-- @treturn string
function Subclass:realizeState( src, lang, counter )
	libUtil.checkType( 'RenderAdapt:realizeState', 1, src, 'table', false )
	-- lang tested in later call
	-- counter tested in later call

	return self:realizeClarification( src:isOk() and 'is-ok' or 'is-not-ok', lang, counter )
end

--- Realize reported data for header.
-- The "header" is a composite.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @tparam nil|Counter counter holding the running count
-- @treturn string
function Subclass:realizeHeader( src, lang, counter )
	-- src tested in later call
	-- lang tested in later call
	-- counter tested in later call

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
-- @raise on wrong arguments
-- @tparam any param that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn string
function Subclass:realizeLine( param, lang ) -- luacheck: no self
	libUtil.checkType( 'RenderAdapt:realizeLine', 1, param, 'table', false )
	libUtil.checkType( 'RenderAdapt:realizeLine', 2, lang, 'string', true )

	local line = mw.message.new( unpack( param ) )

	if lang then
		line:inLanguage( lang )
	end

	if line:isDisabled() then
		return ''
	end

	return line:plain()
end

--- Realize reported data for body.
-- The "body" is a composite.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam nil|string lang code used for realization
-- @treturn string
function Subclass:realizeBody( src, lang )
	libUtil.checkType( 'RenderAdapt:realizeBody', 1, src, 'table', false )
	libUtil.checkType( 'RenderAdapt:realizeBody', 2, lang, 'string', true )

	local t = {}

	for _,v in ipairs( { src:lines():export() } ) do
		table.insert( t, self:realizeLine( v, lang ) )
	end

	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class.
return Subclass
