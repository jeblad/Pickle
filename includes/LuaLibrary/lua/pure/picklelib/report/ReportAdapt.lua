--- Subclass for adapt report.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod ReportAdapt
-- @alias Subclass

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'

-- @var base class
local Super = require 'picklelib/report/Report'

-- @var intermediate class
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'ReportAdapt:__index', 1, key, 'string', false )
	return Subclass[key]
end

-- @var metatable for the class
setmetatable( Subclass, { __index = Super } )

--- Create a new instance.
-- @see Report:create
-- @tparam vararg ... forwarded to @{Report:create|superclass create method}
-- @treturn self
function Subclass:create( ... )
	return Super.create( self or Subclass, ... )
end

--- Initialize a new instance.
-- @tparam vararg ... pushed to lines
-- @treturn self
function Subclass:_init( ... )
	Super._init( self )
	self._description = false
	self._state = false
	self._lang = false -- @todo is this correct?
	self._type = self._type .. '-adapt'
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
		self._lines = Bag:create()
	end
	return self._lines
end

--- Get the number of lines.
-- @treturn number of lines
function Subclass:numLines()
	return self._lines and self._lines:depth() or 0
end

--- Is the report empty?
-- @treturn boolean whether the report is empty
function Subclass:isEmpty()
	return self._lines:isEmpty()
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
-- @raise on wrong arguments
-- @tparam[opt=1] nil|number idx line number
-- @treturn table containing list of parts
function Subclass:getLine( idx )
	libUtil.checkType( 'ReportAdapt:getLine', 1, idx, 'number', true )
	return self:lines():get( idx or 1 )
end

--- Realize the data by applying a render.
-- @tparam Renders renders to use while realizing the reports
-- @tparam nil|string lang holding the language code
-- @tparam nil|Counter counter holding the running count
-- @treturn string
function Subclass:realize( renders, lang, counter )
	libUtil.checkType( 'ReportAdapt:realize', 1, renders, 'table', false )
	libUtil.checkType( 'ReportAdapt:realize', 2, lang, 'string', true )
	libUtil.checkType( 'ReportAdapt:realize', 3, counter, 'table', true )
	return ''
		.. (renders.realizeHeader and renders:realizeHeader( self, lang, counter ) or '')
		.. (renders.realizeBody and renders:realizeBody( self, lang, counter ) or '')
end

-- Return the final class.
return Subclass
