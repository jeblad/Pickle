--- Subclass for reports.
-- This class follows the pattern with inheritance from
-- [Lua classes](../topics/lua-classes.md.html).
-- @classmod ReportCase
-- @alias Subclass

-- pure libs
local libUtil = require 'libraryUtil'
local Bag = require 'picklelib/Bag'

-- @var super class
local Super = require 'picklelib/report/Report'

-- @var intermediate class
local Subclass = {}

--- Lookup of missing class members.
-- @raise on wrong arguments
-- @tparam string key lookup of member
-- @return any
function Subclass:__index( key ) -- luacheck: no self
	libUtil.checkType( 'ReportCase:__index', 1, key, 'string', false )
	return Subclass[key]
end

-- @todo not sure about this
Subclass._reports = nil

-- @todo verify if this is actually used
function Subclass:__call()
	if not self._reports:empty() then
		self._reports:push( Subclass.create() )
	end
	return self._reports:top()
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
-- @tparam vararg ... pushed to constituents
-- @treturn self
function Subclass:_init( ... )
	Super._init( self )
	self._type = self._type .. '-case'
	if select('#',...) then
		self:constituents():push( ... )
	end
	return self
end

--- Set name of case.
-- @tparam string|message name
-- @treturn self
function Subclass:setName( name )
	self._name = name
	return self
end

--- Check if the report has name.
-- @treturn boolean
function Subclass:hasName()
	return not not self._name
end

--- Get the name of report.
-- @treturn string|message
function Subclass:getName()
	return self._name
end

--- Export the constituents as an multivalue return.
-- Note that each constituent is not unwrapped.
-- @return list of constituents
function Subclass:constituents()
	if not self._constituents then
		self._constituents = Bag:create()
	end
	return self._constituents
end

--- Get the number of constituents.
-- @return number of constituents
function Subclass:numConstituents()
	return self._constituents and self._constituents:depth() or 0
end

--- Add a constituent.
-- Note: there are no checking of arguments!
-- @tparam any part that can be a constituent
-- @treturn self
function Subclass:addConstituent( part )
	self:constituents():push( part )
	return self
end

--- Add several constituents.
-- Note: there are no checking of arguments!
-- @tparam vararg ... list of parts that can be constituents
-- @treturn self
function Subclass:addConstituents( ... )
	self:constituents():push( ... )
	return self
end

function Subclass:hasConstituents()
	return not ( self._constituents and self:constituents():isEmpty() or true )
end

--- Check if the instance state is ok.
-- Note that initial state is "not ok".
-- @todo the initial state is not correct
-- @treturn boolean state
function Subclass:isOk()
	local state = self._state

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			state = state and v:isOk()
		end
	end

	return state
end

--- Check if the instance has any member in skip state.
-- This will reject all case constituents from the analysis.
-- @treturn boolean that is set if any constituent has a skip note
function Subclass:hasSkip()
	local tmp = false

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			if self:type() ~= v:type() then
				tmp = tmp or v:isSkip()
			end
		end
	end

	return tmp
end

--- Check if the instance has any member in todo state.
-- This will reject all case constituents from the analysis.
-- @treturn boolean that is set if any constituent has a skip note
function Subclass:hasTodo()
	local tmp = false

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			if self:type() ~= v:type() then
				tmp = tmp or v:isTodo()
			end
		end
	end

	return tmp
end

--- Set the description.
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @raise on wrong arguments
-- @tparam[opt=''] nil|string str that will be used as the description
-- @treturn self
function Subclass:setDescription( str )
	libUtil.checkType( 'ReportCase:setDescription', 1, str, 'string', true )
	self._description = str or ''
	return self
end

--- Get the description.
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @treturn string used as the description
function Subclass:getDescription()
	return self._description
end

--- Check if the instance has any description member.
-- @treturn boolean that is set if a description exist
function Subclass:hasDescription()
	return not not self._description
end

--- Realize the data by applying a render.
-- @tparam Renders renders to use while realizing the reports
-- @tparam nil|string lang holding the language code
-- @tparam nil|Counter counter holding the running count
-- @treturn string
function Subclass:realize( renders, lang, counter )
	libUtil.checkType( 'ReportCase:realize', 1, renders, 'table', false )
	libUtil.checkType( 'ReportCase:realize', 2, lang, 'string', true )
	libUtil.checkType( 'ReportCase:realize', 3, counter, 'table', true )

	local styles = renders:find( self:type() )
	local init = counter and not counter:isInitialized()
	local out = styles:realizeHeader( self, lang, counter )

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			out = styles:append( out, v:realize( renders, lang, counter ) )
		end
	end

	if init then
		out = renders:realizeVersion( self, lang, counter ) .. "\n"
			.. '1..' .. tostring( counter:num() ) .. "\n"
			.. tostring( out )
	end

	return out
end

-- Return the final class.
return Subclass
