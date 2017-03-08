--- Subclass for plans

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local Constituent
if mw.pickle then
	-- structure exist, make access simpler
	Constituent = mw.pickle.constituent
else
	-- structure does not exist, require the libs
	Constituent = require 'picklelib/report/Constituent'
end

-- @var class var for lib
local FramePlan = {}

--- Lookup of missing class members
function FramePlan:__index( key ) -- luacheck: ignore self
	return FramePlan[key]
end

-- @todo not sure about this
FramePlan._plans = nil

function FramePlan:__call()
	if not self._plans:empty() then
		self._plans:push( FramePlan.create() )
	end
	return self._plans:top()
end

-- @var metatable for the class
setmetatable( FramePlan, { __index = Constituent } )

--- Create a new instance
function FramePlan.create( ... )
	local self = setmetatable( {}, FramePlan )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function FramePlan:_init( ... )
	Constituent._init( self, ... )
	self._constituents = Stack.create()
	self._type = 'frame-plan'
	return self
end

--- Add a constituent
function FramePlan:addConstituent( part )
	assert( part, 'Failed to provide a constituent' )
	self._constituents:push( part )
	return self
end

--- Export the constituents as an multivalue return
-- Note that each constituent is not unwrapped.
function FramePlan:constituents()
	return self._constituents:export()
end

--- Realize the data by applying a render
function FramePlan:realize( renders, lang )
	assert( renders, 'Failed to provide renders' )
	local out = renders:find( self:type() ):realizeHeader( self, lang )
	for _,v in ipairs( self:constituents() ) do
		out = out .. v:realize( renders, lang )
	end
	return out
end

-- Return the final class
return FramePlan
