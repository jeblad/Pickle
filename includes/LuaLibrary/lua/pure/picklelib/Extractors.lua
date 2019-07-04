--- Baseclass for extractor strategies.
-- This class follows the pattern from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod Extractors

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'

-- @var class var for lib
local Extractors = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Extractors:__index( key ) -- luacheck: no self
	libUtil.checkType( 'Extractors:__index', 1, key, 'string', false )
	return Extractors[key]
end

-- @field class var for strategies, holding reference to defined extractor strategies
Extractors.strategies = Bag:create()

--- Create a new instance.
-- @tparam vararg ... forwarded to @{Extractor:_init}
-- @treturn self
function Extractors:create( ... )
	local meta = rawget( self, 'create' ) and self or getmetatable( self )
	local new = setmetatable( {}, meta )
	return new:_init( ... )
end

--- Initialize a new instance.
-- @tparam vararg ... list of strategies
-- @treturn self
function Extractors:_init( ... )
	self._strategies = Bag:create()
	for _,v in ipairs( { ... } ) do
		self:register( v )
	end
	return self
end

--- Register a new strategy.
-- @raise on wrong arguments
-- @param strategy to be registered
-- @treturn self
function Extractors:register( strategy )
	libUtil.checkType( 'Extractors:register', 1, strategy, 'table', false )
	self._strategies:push( strategy )
	return self
end

--- Removes all registered extractors.
-- @treturn self
function Extractors:flush()
	self._strategies:flush()
	return self
end

--- The number of registered extractors.
-- @treturn number
function Extractors:num()
	return self._strategies:depth()
end

--- Find a matching extractor.
-- @todo fix pos
-- @raise on wrong arguments
-- @tparam string str used as the extraction source
-- @tparam[opt=1] nil|number pos for an inclusive index where extraction starts
-- @treturn strategy,first,last
function Extractors:find( str, pos )
	-- @todo figure out if it should be valid to not provide a string
	libUtil.checkType( 'Extractors:find', 1, str, 'string', false )
	libUtil.checkType( 'Extractors:find', 2, pos, 'number', true )

	local first = mw.ustring.len( str ) + 1
	local last
	local strategy = nil
	for _,v in ipairs( { self._strategies:export() } ) do
		local start, finish = v:find( str, pos or 1 )
		if start and start<first then
			first = start
			last = finish
			strategy = v
		end
	end

	if strategy then
		return strategy, first, last
	end
	return nil
end

-- Return the final class.
return Extractors
