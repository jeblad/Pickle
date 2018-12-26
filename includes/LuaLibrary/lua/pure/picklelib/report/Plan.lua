--- Subclass for plans

-- pure libs
local Stack = require 'picklelib/Stack'

-- @var class var for lib
local Plan = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Plan:__index( key ) -- luacheck: no self
	return Plan[key]
end

-- @todo not sure about this
Plan._reports = nil

-- @todo verify if this is actually used
function Plan:__call()
	if not self._reports:empty() then
		self._reports:push( Plan.create() )
	end
	return self._reports:top()
end

--- Create a new instance
-- @param vararg unused
-- @return Plan
function Plan.create( ... )
	local self = setmetatable( {}, Plan )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Plan
function Plan:_init( ... )
	self._type = 'frame-report'
	if select('#',...) > 0 then
		self:constituents():push( ... )
	end
	return self
end

--- Get the type of class
-- All classes has an explicit type name.
-- @return string
function Plan:type()
	return self._type
end

--- Export the constituents as an multivalue return
-- Note that each constituent is not unwrapped.
-- @return list of constituents
function Plan:constituents()
	if not self._constituents then
		self._constituents = Stack.create()
	end
	return self._constituents
end

--- Get the number of constituents
-- @return number of constituents
function Plan:numConstituents()
	return self._constituents and self._constituents:depth() or 0
end

--- Add a constituent
-- @param any part that can be a constituent
-- @return self
function Plan:addConstituent( part )
	assert( part )
	self:constituents():push( part )
	return self
end

--- Add several constituents
-- @param vararg list of parts that can be constituents
-- @return self
function Plan:addConstituents( ... )
	self:constituents():push( ... )
	return self
end

function Plan:hasConstituents()
	return not ( self._constituents and self:constituents():isEmpty() or true )
end

--- Check if the instance state is ok
-- Note that initial state is "not ok".
-- @todo the initial state is not correct
-- @return boolean state
function Plan:isOk()
	local state = true

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			state = state and v:isOk()
		end
	end

	return state
end

--- Check if the instance has any member in skip state
-- This will reject all frame constituents from the analysis.
-- @return boolean that is set if any constituent has a skip note
function Plan:hasSkip()
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

--- Check if the instance has any member in todo state
-- This will reject all frame constituents from the analysis.
-- @return boolean that is set if any constituent has a skip note
function Plan:hasTodo()
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

--- Set the description
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @param string that will be used as the description
-- @return self
function Plan:setDescription( str )
	assert( str )
	self._description = str
	return self
end

--- Get the description
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
-- @return string used as the description
function Plan:getDescription()
	return self._description
end

--- Check if the instance has any description member
-- @return boolean that is set if a description exist
function Plan:hasDescription()
	return not not self._description
end

--- Realize the data by applying a render
-- @param Renders to use while realizing the reports
-- @param string holding the language code
function Plan:realize( renders, lang )
	assert( renders )


	local styles = renders:find( self:type() )
	local out = styles:realizeHeader( self, lang )

	if self._constituents then
		for _,v in ipairs( { self:constituents():export() } ) do
			out = styles:append( out, v:realize( renders, lang ) )
		end
	end

	return out
end

-- Return the final class
return Plan
