--- Subclass for adapt report.
-- This class follows the pattern from [Lua classes](../topics/lua-classes.md.html).
-- @classmod ReportAdapt
-- @alias Subclass

-- pure libs
local Stack = require 'picklelib/Stack'

-- @var base class
local Super = require 'picklelib/report/Report'

-- @var intermediate class
local Subclass = {}

--- Lookup of missing class members.
-- @tparam string key used for lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see Report:create
-- @tparam vararg ... forwarded to @{Report:create}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self, ... )
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... pushed to lines
-- @treturn self
function Subclass:_init( ... )
	Super._init( self )
	self._description = false
	self._state = false
	self._lang = false -- @todo is this correct?
	self._type = 'report-adapt'
	if select('#',...) then
		self:lines():push( ... )
	end
	return self
end

--- Export the lines as an multivalue return.
-- Note that each line is not unwrapped.
-- @treturn table list of lines
function Subclass:lines()
	if not self._lines then
		self._lines = Stack.create()
	end
	return self._lines
end

--- Get the number of lines.
-- @treturn number of lines
function Subclass:numLines()
	return self._lines and self._lines:depth() or 0
end

--- Add a line.
-- @todo sometimes a block of lines must be added
-- Note that all arguments will be wrapped up in a table before saving.
-- @tparam vararg ... that can be a line
-- @treturn self
function Subclass:addLine( ... )
	self:lines():push( { ... } )
	return self
end

--- Get a line.
-- Note that all parts will be returned wrapped up in a table.
-- @tparam number idx line number
-- @treturn table containing list of parts
function Subclass:getLine( idx )
	return self:lines():get( idx )
end

--- Realize the data by applying a render.
-- @tparam Renders renders to use while realizing the reports
-- @tparam[opt] string lang holding the language code
-- @tparam[optchain] Counter counter holding the running count
-- @treturn string
function Subclass:realize( renders, lang, counter )
	assert( renders, 'Failed to provide renders' )
	return ''
		.. (renders.realizeHeader and renders:realizeHeader( self, lang, counter ) or '')
		.. (renders.realizeBody and renders:realizeBody( self, lang, counter ) or '')
end

-- Return the final class.
return Subclass
