--- Subclass for reports.
-- @classmod FrameReport

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local Base = require 'picklelib/report/ReportBase'

-- @var class var for lib
local FrameReport = {}

--- Lookup of missing class members.
-- @tparam string key lookup of member
-- @return any
function FrameReport:__index( key ) -- luacheck: no self
	return FrameReport[key]
end

-- @todo not sure about this
FrameReport._reports = nil

-- @todo verify if this is actually used
function FrameReport:__call()
	if not self._reports:empty() then
		self._reports:push( FrameReport.create() )
	end
	return self._reports:top()
end

-- @var metatable for the class
setmetatable( FrameReport, { __index = Base } )

--- Create a new instance.
-- @tparam vararg ... unused
-- @treturn self
function FrameReport.create( ... )
	local self = setmetatable( {}, FrameReport )
	self:_init( ... )
	return self
end

--- Initialize a new instance.
-- @local
-- @tparam vararg ... unused
-- @treturn FrameReport
function FrameReport:_init( ... )
	Base._init( self, ... )
	self._type = 'frame-report'
	if select('#',...) then
		self:constituents():push( ... )
	end
	return self
end

--- Export the constituents as an multivalue return.
-- Note that each constituent is not unwrapped.
-- @return list of constituents
function FrameReport:constituents()
	if not self._constituents then
		self._constituents = Stack.create()
	end
	return self._constituents
end

--- Get the number of constituents.
-- @return number of constituents
function FrameReport:numConstituents()
	return self._constituents and self._constituents:depth() or 0
end

--- Add a constituent.
-- @tparam any part that can be a constituent
-- @treturn self
function FrameReport:addConstituent( part )
	assert( part, 'Failed to provide a constituent' )
	self:constituents():push( part )
	return self
end

--- Add several constituents.
-- @tparam vararg ... list of parts that can be constituents
-- @treturn self
function FrameReport:addConstituents( ... )
	self:constituents():push( ... )
	return self
end

function FrameReport:hasConstituents()
	return not ( self._constituents and self:constituents():isEmpty() or true )
end

--- Check if the instance state is ok.
-- Note that initial state is "not ok".
-- @todo the initial state is not correct
-- @treturn boolean state
function FrameReport:isOk()
	local state = self._state

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			state = state and v:isOk()
		end
	end

	return state
end

--- Check if the instance has any member in skip state.
-- This will reject all frame constituents from the analysis.
-- @treturn boolean that is set if any constituent has a skip note
function FrameReport:hasSkip()
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
-- This will reject all frame constituents from the analysis.
-- @treturn boolean that is set if any constituent has a skip note
function FrameReport:hasTodo()
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
-- @tparam string str that will be used as the description
-- @treturn self
function FrameReport:setDescription( str )
	assert( str, 'Failed to provide a description' )
	self._description = str
	return self
end

--- Get the description.
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @treturn string used as the description
function FrameReport:getDescription()
	return self._description
end

--- Check if the instance has any description member.
-- @treturn boolean that is set if a description exist
function FrameReport:hasDescription()
	return not not self._description
end

--- Realize the data by applying a render.
-- @tparam Renders renders to use while realizing the reports
-- @tparam string lang holding the language code
-- @tparam Counter counter holding the running count
-- @return out
function FrameReport:realize( renders, lang, counter )
	assert( renders, 'Failed to provide renders' )

	local styles = renders:find( self:type() )
	local init = counter and not counter:isInitialized()
	local out = styles:realizeHeader( self, lang, counter )

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			out = styles:append( out, v:realize( renders, lang, counter ) )
		end
	end

	if true or init then
		out = renders:realizeVersion( self, lang, counter ) .. "\n"
			.. '1..' .. counter:num() .. "\n"
			.. out
	end

	return out
end

-- Return the final class.
return FrameReport
