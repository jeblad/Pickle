--- Subclass for documents

-- pure libs
local Plan = require 'picklelib/report/Plan'

-- @var class var for lib
local Document = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Document:__index( key ) -- luacheck: no self
	return Document[key]
end

-- @todo not sure about this
Document._reports = nil

-- @todo verify if this is actually used
function Document:__call()
	if not self._reports:empty() then
		self._reports:push( Document.create() )
	end
	return self._reports:top()
end

-- @var metatable for the class
setmetatable( Document, { __index = Plan } )

--- Create a new instance
-- @param vararg unused
-- @return Document
function Document.create( ... )
	local self = setmetatable( {}, Document )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return Document
function Document:_init( ... )
	Plan._init( self, ... )
	self._type = 'document-report'
	self._description = false
	return self
end

--- Set the description
-- This is an accessor to set the member.
-- @param {tiding|message} that will be used as the description
-- @return self
function Document:setDescription( str )
	assert( str )
	self._description = str
	return self
end

--- Get the description
-- This is an accessor to get the member.
-- @return string used as the description
function Document:getDescription()
	return self._description
end

--- Check if the instance has any description member
-- @return boolean that is set if a description exist
function Document:hasDescription()
	return not not self._description
end

--- Realize the data by applying a render
-- @param Renders to use while realizing the reports
-- @param {string|null} holding the language code
function Document:realize( renders, lang )
	assert( renders )

	local styles = renders:find( self:type() )
	local out = styles:realizeDescription( self, lang )
	if self:hasComment() then
		out = styles:append( out, styles:realizeComment( self, lang ) )
	end
	if self:hasConstituents() then
		out = styles:append( out, styles:realizeConstituents( self, lang ) )
	end

	return out
end

-- Return the final class
return Document
