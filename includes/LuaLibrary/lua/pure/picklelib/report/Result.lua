--- Subclass for results

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
local Result = {}

--- Lookup of missing class members
function Result:__index( key ) -- luacheck: ignore self
	return Result[key]
end

-- @var metatable for the class
setmetatable( Result, { __index = Constituent } )

--- Create a new instance
function Result.create( ... )
	local self = setmetatable( {}, Result )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function Result:_init( ... )
	Constituent._init( self )
	self._state = false
	self._lines = Stack.create()
	self._lines:push( ... )
	self._type = 'result'
	return self
end

--- Export the lines as an multivalue return
-- Note that each line is not unwrapped.
function Result:lines()
	return self._lines:export()
end

--- Get the number of lines
function Result:numLines()
	local t = { self._lines:export() }
	return #t
end

--- Add a line
-- Note that all arguments will be wrapped up in a table before saving.
function Result:addLine( ... )
	self._lines:push( { ... } )
	return self
end

--- Set the state as not ok
-- Note that initial state is not ok.
function Result:notOk()
	self._state = false
	return self
end

--- Set the state as ok
-- Note that initial state is not ok.
function Result:ok()
	self._state = true
	return self
end

--- Check if the instance state is ok
-- Note that initial state is not ok.
function Result:isOk()
	return self._state
end

--- Realize the data by applying a render
function Result:realize( renders, lang )
	assert( renders, 'Failed to provide renders' )
	return ''
		.. renders:realizeHeader( self, lang )
		.. renders:realizeBody( self, lang )
end

-- Return the final class
return Result
