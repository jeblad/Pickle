--- Baseclass for renders.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Render
-- @alias Baseclass

-- pure libs
local libUtil = require 'libraryUtil'

-- @var base class
local Baseclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Baseclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Render:__index', 1, key, 'string', false )
	return Baseclass[key]
end

--- Create a new instance.
-- Assumption is either to create a new instance from an existing class,
-- or from a previous instance of some kind.
-- @tparam vararg ... forwarded to `_init()`
-- @treturn self
function Baseclass:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... unused
-- @return self
function Baseclass:_init( ... ) -- luacheck: no unused args
	self._type = 'render'
	return self
end

--- Clean key.
-- Sole purpose of this is to do assertions and un-tainting.
-- @raise on wrong arguments
-- @tparam string str to be appended to a base string
-- @treturn string
function Baseclass:cleanKey( str ) -- luacheck: no self
	libUtil.checkType( 'Render:cleanKey', 1, str, 'string', false )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return keep
end


--- Override key construction.
-- Sole purpose of this is to do assertions, and the provided key is never be used.
-- @raise on wrong arguments
-- @tparam string str to be appended to a base string
-- @treturn string
function Baseclass:key( str )
	return 'pickle-report-base-' .. self:cleanKey( str )
end

--- Get the type of report.
-- All reports has an explicit type name.
-- @treturn string
function Baseclass:type()
	return self._type
end

--- Append same type to first.
-- The base version only concatenates strings.
-- @raise on wrong arguments
-- @tparam any head to act as the head
-- @tparam any tail to act as the tail
-- @return any
function Baseclass:append( head, tail ) -- luacheck: no self
	libUtil.checkType( 'Render:append', 1, head, 'string', false )
	libUtil.checkType( 'Render:append', 2, tail, 'string', false )
	return head .. ' ' .. tail
end

--- Realize clarification.
-- @raise on wrong arguments
-- @tparam string keyPart of a message key
-- @tparam nil|string lang code
-- @tparam nil|Counter counter holding the running count
-- @treturn string
function Baseclass:realizeClarification( keyPart, lang, counter )
	libUtil.checkType( 'Render:realizeClarification', 1, keyPart, 'string', false )
	libUtil.checkType( 'Render:realizeClarification', 2, lang, 'string', true )
	libUtil.checkType( 'Render:realizeClarification', 3, counter, 'table', true )

	local keyword = mw.message.new( self:key( keyPart .. '-keyword' ) )
		:inLanguage( 'en' )
		:plain()

	local msg = keyword .. ( counter and ( ' ' .. counter() ) or '' )

	if lang and lang ~= 'en' then
		local translated = mw.message.new( self:key( keyPart .. '-keyword' ) )
			:inLanguage( lang )
		if not translated:isDisabled() then
			local str = translated:plain()
			if keyword ~= str then
				msg = msg .. ' ' .. mw.message.new( 'parentheses', str )
					:inLanguage( lang )
					:plain()
			end
		end
	end

	return msg
end

--- Realize comment.
-- @raise on wrong arguments
-- @tparam Report src that shall be realized
-- @tparam string keyPart of a message key
-- @tparam nil|string lang code
-- @treturn string
function Baseclass:realizeComment( src, keyPart, lang )
	libUtil.checkType( 'Render:realizeComment', 1, src, 'table', false )
	libUtil.checkType( 'Render:realizeComment', 2, keyPart, 'string', false )
	libUtil.checkType( 'Render:realizeComment', 3, lang, 'string', true )

	local ucfKeyPart = string.upper( string.sub( keyPart, 1, 1 ) )..string.sub( keyPart, 2 )
	if not ( ( src['is'..ucfKeyPart] and src['is'..ucfKeyPart]( src ) )
		or ( src['has'..ucfKeyPart] and src['has'..ucfKeyPart]( src ) ) ) then
		return ''
	end

	local str = src['get'..ucfKeyPart]( src )

	local comment = false

	if type( str ) == 'nil' then
		comment = mw.message.new( 'pickle-report-case-' .. keyPart .. '-no-description' )
	elseif type( str ) == 'string' then
		comment = mw.message.newRawMessage( str )
	end

	local clar = self:realizeClarification( 'is-' .. keyPart, lang )

	if not comment then
		return clar
	end

	if lang then
		comment:inLanguage( lang )
	end

	return clar .. ( comment:isDisabled() and '' or ( ' ' .. comment:plain() ) )
end

-- Return the final class.
return Baseclass
