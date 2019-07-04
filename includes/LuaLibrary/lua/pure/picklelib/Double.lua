--- Class for creating test doubles.
-- For full description see [test doubles](../topics/test-doubles.md.html).
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Double

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'

-- @var class
local Double = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Double:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Double:__index', 1, key, 'string', false )
	return Double[key]
end

--- Get arguments for a functionlike call.
-- @tparam vararg ... pass on to dispatch
-- @treturn self
function Double:__call( ... ) -- luacheck: no self
	local instance = rawget( self, 'create' ) and self:create() or self
	return instance:dispatch( ... )
end

--- Create a new instance.
-- @tparam vararg ... forwarded to `_init()`
-- @treturn self
function Double:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... shifted into the values list
-- @treturn self
function Double:_init( ... )
	self._list = Bag:create()
	self:dispatch( ... )
	return self
end

--- Dispatch arguments
-- @raise on wrong arguments
-- @tparam vararg ... argumnts to be stored for later retrieval
-- @treturn self
function Double:dispatch( ... )
	local idx = 0
	for _,v in ipairs( { ... } ) do
		idx = idx + 1
		libUtil.checkTypeMulti( 'Double:dispatch', idx, v, { 'table', 'boolean', 'number', 'string', 'function' } )
		local tpe = type( v )
		if tpe == 'table' then
			self:add( v )
		elseif tpe == 'boolean' then
			self:add( v )
		elseif tpe == 'number' then
			self:setLevel( v )
		elseif tpe == 'string' then
			self:setName( v )
		elseif tpe == 'function' then
			self:setOnEmpty( v )
		end
	end
	return self
end

--- Set identifying name
-- @raise on wrong arguments
-- @tparam nil|string name used for error reports
-- treturn self
function Double:setName( name )
	libUtil.checkType( 'Double:setLevel', 1, name, 'string', true )
	self._name = name
	return self
end

--- Has set name.
-- treturn boolean
function Double:hasName()
	return not not self._name
end

--- Set stack level.
-- @raise on wrong arguments
-- @tparam nil|number level where to start reporting
-- treturn self
function Double:setLevel( level )
	libUtil.checkType( 'Double:setLevel', 1, level, 'number', true )
	self._level = level
	return self
end

--- Has set level.
-- treturn boolean
function Double:hasLevel()
	return not not self._level
end

--- Set on empty fallback.
-- @raise on wrong arguments
-- @tparam nil|function func fallback to be used in place of precomputed values
-- treturn self
function Double:setOnEmpty( func )
	libUtil.checkType( 'Double:setOnEmpty', 1, func, 'function', true )
	self._onEmpty = func
	return self
end

--- Has set empty fallback.
-- treturn boolean
function Double:hasOnEmpty()
	return not not self._onEmpty
end

--- Is the list of values empty.
-- Note that the internal structure is non-empty even if a nil
-- is shifted into the values list.
-- @treturn boolean whether the internal values list has length zero
function Double:isEmpty()
	return self._list:isEmpty()
end

--- What is the depth of the internal values list.
-- Note that the internal structure has a depth even if a nil
-- is shifted into the values list.
-- @treturn number how deep is the internal structure
function Double:depth()
	return self._list:depth()
end

--- Get the layout of the values list.
-- This method is used for testing to inspect which types of objects exists in the values list.
-- @treturn table description of the internal structure
function Double:layout()
	return self._list:layout()
end

--- Add value(s) to the list of values.
-- @treturn self facilitate chaining
function Double:add( ... )
	self._list:unshift( ... )
	return self
end

--- Remove value from the list of values.
-- @treturn any item that can be put on the internal structure
function Double:remove( num )
	libUtil.checkType( 'Double:pop', 1, num, 'number', true )
	num = num or 1
	return self._list:shift( num )
end

--- Return a stub function for the object.
-- Each call to the returned closure will remove one case of values from the internal structure.
-- @treturn closure
function Double:stub()
	if not self._stub then
		self._stub = function( ... )
			local item = self:remove()
			local itemType = type( item )
			-- precomputed values
			if itemType == 'table' then
				return unpack( item )
			end
			-- conditional redirect
			if itemType == 'boolean' then
				if item == true then
					if not self._onEmpty then
						error( mw.message.new( 'pickle-stub-no-fallback', self._name or 'double' ):plain(), 0 )
					end
					return self._onEmpty( ... )
				end
				error( mw.message.new( 'pickle-stub-no-more-frames', self._name or 'double' ):plain(), 0 )
			end
			-- unconditional redirect
			if self._onEmpty then
				return self._onEmpty( ... )
			end
			-- failed
			error( mw.message.new( 'pickle-stub-no-more-frames', self._name or 'double' ):plain(), 0 )

		end
	end
	return self._stub
end

--- Has set stub function.
-- treturn boolean
function Double:hasStub()
	return not not self._stub
end

--- Export a list of all the contents.
-- @treturn table list of values
function Double:export()
	local t = {}
	for i,v in ipairs( self._bag ) do
		t[i] = v
	end
	return unpack( t )
end

--- Flush all the contents.
-- Note that this clears the internal storage.
-- @treturn table list of values
function Double:flush()
	local t = { self:export() }
	self._bag = {}
	return unpack( t )
end

-- Return the final class.
return Double
