--- Baseclass for renders.
-- This class follows the pattern from [Lua classes](../topics/lua-classes.md.html).
-- @classmod RenderBase
-- @alias Render

-- @var base class
local Render = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Render:__index( key ) -- luacheck: no self
	return Render[key]
end

--- Create a new instance.
-- Assumption is either to create a new instance from an existing class,
-- or from a previous instance of some kind.
-- @tparam vararg ... forwarded to `_init()`
-- @treturn self
function Render:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	new:_init( ... )
	return new
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @return self
function Render:_init( ... ) -- luacheck: no unused args
	self._type = 'base-render'
	return self
end

--- Clean key.
-- Sole purpose of this is to do assertions and un-tainting.
-- @tparam string str to be appended to a base string
-- @treturn string
function Render:cleanKey( str ) -- luacheck: no self
	assert( str, 'Failed to provide a string' )
	local keep = string.match( str, '^[-%a]+$' )
	assert( keep, 'Failed to find a valid string' )
	return keep
end


--- Override key construction.
-- Sole purpose of this is to do assertions, and the provided key is never be used.
-- @tparam string str to be appended to a base string
-- @treturn string
function Render:key( str )
	return 'pickle-report-base-' .. self:cleanKey( str )
end

--- Get the type of report.
-- All reports has an explicit type name.
-- @treturn string
function Render:type()
	return self._type
end

--- Append same type to first.
-- The base version only concatenates strings.
-- @tparam any head to act as the head
-- @tparam any tail to act as the tail
-- @return any
function Render:append( head, tail ) -- luacheck: no self
	assert( head )
	assert( tail )
	return head .. ' ' .. tail
end

--- Realize clarification.
-- @tparam string keyPart of a message key
-- @tparam[opt] string lang code
-- @tparam[optchain] Counter counter holding the running count
-- @treturn string
function Render:realizeClarification( keyPart, lang, counter )
	assert( keyPart, 'Failed to provide a key part' )

	local keyword = mw.message.new( self:key( keyPart .. '-keyword' ) )
		:inLanguage( 'en' )
		:plain()

	local msg = keyword .. ( counter and ( ' ' .. counter() ) or '' )

	if lang ~= 'en' then
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
-- @tparam Report src that shall be realized
-- @tparam string keyPart of a message key
-- @tparam[opt] string lang code
-- @treturn string
function Render:realizeComment( src, keyPart, lang )
	assert( src, 'Failed to provide a source' )

	local ucfKeyPart = string.upper( string.sub( keyPart, 1, 1 ) )..string.sub( keyPart, 2 )
	if not ( src['is'..ucfKeyPart]( src ) or src['has'..ucfKeyPart]( src ) ) then
		return ''
	end

	local str = src['get'..ucfKeyPart]( src )

	local desc = (not str)
		and mw.message.new( 'pickle-report-frame-' .. keyPart .. '-no-description' )
		or ( string.find( str, '^pickle-[-a-z]+$' )
			and mw.message.new( str )
			or mw.message.newRawMessage( str ) )

	if lang then
		desc:inLanguage( lang )
	end

	local clar = self:realizeClarification( 'is-' .. keyPart, lang )
	local msg = clar .. ( desc:isDisabled() and '' or ( ' ' .. desc:plain() ) )

	return msg
end

-- Return the final class.
return Render
