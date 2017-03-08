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
function FrameReport:__index( key ) -- luacheck: ignore self
	return FrameReport[key]
end

-- @todo not sure about this
FrameReport._reports = nil

function FrameReport:__call()
	if not self._reports:empty() then
		self._reports:push( FrameReport.create() )
	end
	return self._reports:top()
end

-- @var metatable for the class
setmetatable( FrameReport, { __index = BaseReport } )

--- Create a new instance
function FrameReport.create( ... )
	local self = setmetatable( {}, FrameReport )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function FrameReport:_init( ... )
	BaseReport._init( self, ... )
	self._constituents = Stack.create()
	self._type = 'frame-report'
	return self
end

--- Add a constituent
function FrameReport:addConstituent( part )
	assert( part, 'Failed to provide a constituent' )
	self._constituents:push( part )
	return self
end

--- Export the constituents as an multivalue return
-- Note that each constituent is not unwrapped.
function FrameReport:constituents()
	return self._constituents:export()
end

--- Realize the data by applying a render
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
