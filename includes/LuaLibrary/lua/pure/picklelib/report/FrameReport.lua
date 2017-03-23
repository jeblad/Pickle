--- Subclass for reports

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local BaseReport
if mw.pickle then
	-- structure exist, make access simpler
	BaseReport = mw.pickle.report.base
else
	-- structure does not exist, require the libs
	BaseReport = require 'picklelib/report/BaseReport'
end

-- @var class var for lib
local FrameReport = {}

--- Lookup of missing class members
-- @param string used for lookup of member
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
setmetatable( FrameReport, { __index = BaseReport } )

--- Create a new instance
-- @param vararg unused
-- @return FrameReport
function FrameReport.create( ... )
	local self = setmetatable( {}, FrameReport )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return FrameReport
function FrameReport:_init( ... )
	BaseReport._init( self, ... )
	self._constituents = Stack.create()
	self._skip = false
	self._todo = false
	self._type = 'frame-report'
	return self
end

--- Add a constituent
-- @param any part that can be a constituent
-- @return self
function FrameReport:addConstituent( part )
	assert( part, 'Failed to provide a constituent' )
	self._constituents:push( part )
	return self
end

--- Add several constituents
-- @param vararg list of parts that can be constituents
-- @return self
function FrameReport:addConstituents( ... )
	self._constituents:push( ... )
	return self
end

--- Export the constituents as an multivalue return
-- Note that each constituent is not unwrapped.
-- @return list of constituents
function FrameReport:constituents()
	return self._constituents:export()
end

--- Check if the instance state is ok
-- Note that initial state is "not ok".
-- @todo the initial state is not correct
-- @return boolean state
function FrameReport:isOk()
	local state = true
	for _,v in ipairs( { self._constituents:export() } ) do
		state = state and v:isOk()
	end
	return state
end

--- Set the skip
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @param string that will be used as the skip note
-- @return self
function FrameReport:setSkip( str )
	assert( str, 'Failed to provide a skip' )
	self._skip = str
	return self
end

--- Get the skip
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @return string used as the skip note
function FrameReport:getSkip()
	return self._skip
end

--- Check if the instance is itself in a skip state
-- @return boolean that is set if a skip note exist
function FrameReport:isSkip()
	return not not self._skip
end

--- Check if the instance has any member in skip state
-- This will reject all frame constituents from the analysis.
-- @return boolean that is set if any constituent has a skip note
function FrameReport:hasSkip()
	local tmp = false
	for _,v in ipairs( { self._constituents:export() } ) do
		if self:type() ~= v:type() then
			tmp = tmp or v:isSkip()
		end
	end
	return tmp
end

--- Set the todo
-- This is an accessor to set the member.
-- @param string that will be used as the todo note
-- @return self
function FrameReport:setTodo( str )
	assert( str, 'Failed to provide a todo' )
	self._todo = str
	return self
end

--- Get the todo
-- This is an accessor to get the member.
-- @return string used as the todo note
function FrameReport:getTodo()
	return self._todo
end

--- Check if the instance is itself in a todo state
-- @return boolean that is set if a skip note exist
function FrameReport:isTodo()
	return not not self._todo
end

--- Check if the instance has any member in todo state
-- This will reject all frame constituents from the analysis.
-- @return boolean that is set if any constituent has a skip note
function FrameReport:hasTodo()
	local tmp = false
	for _,v in ipairs( { self._constituents:export() } ) do
		if self:type() ~= v:type() then
			tmp = tmp or v:isTodo()
		end
	end
	return tmp
end

--- Set the description
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @param string that will be used as the description
-- @return self
function FrameReport:setDescription( str )
	assert( str, 'Failed to provide a description' )
	self._description = str
	return self
end

--- Get the description
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @return string used as the description
function FrameReport:getDescription()
	return self._description
end

--- Check if the instance has any description member
-- @return boolean that is set if a description exist
function FrameReport:hasDescription()
	return not not self._description
end

--- Realize the data by applying a render
-- @param Renders to use while realizing the reports
-- @param string holding the language code
function FrameReport:realize( renders, lang )
	assert( renders, 'Failed to provide renders' )
	local out = renders:find( self:type() ):realizeHeader( self, lang )
	for _,v in ipairs( self:constituents() ) do
		out = out .. v:realize( renders, lang )
	end
	return out
end

-- Return the final class
return FrameReport
