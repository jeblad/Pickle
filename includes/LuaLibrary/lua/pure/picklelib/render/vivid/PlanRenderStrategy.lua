--- Subclass for plan renderer

-- pure libs
local Base = require 'picklelib/render/PlanRenderBase'

-- @var class var for lib
local PlanRender = {}

--- Lookup of missing class members
function PlanRender:__index( key ) -- luacheck: ignore self
	return PlanRender[key]
end

-- @var metatable for the class
setmetatable( PlanRender, { __index = Base } )

--- Create a new instance
function PlanRender.create( ... )
	local self = setmetatable( {}, PlanRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
function PlanRender:_init( ... ) -- luacheck: ignore
	return self
end

--- Override key construction
function PlanRender:key( str ) -- luacheck: ignore self
	assert( str, 'Failed to provide a string' )
	return 'pickle-report-plan-vivid-' .. str
end

--- Override realization of reported data for skip
function PlanRender:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-skip' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeSkip( self, src, lang ) )

	return html
end

--- Override realization of reported data for todo
function PlanRender:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-todo' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeTodo( self, src, lang ) )

	return html
end

--- Override realization of reported data for description
function PlanRender:realizeDescription( src, lang )
	assert( src, 'Failed to provide a source' )

	local html = mw.html.create( 'span' )
		:addClass( 'mw-pickle-description' )

	if lang then
		html:attr( 'lang', lang )
	end

	html:wikitext( Base.realizeDescription( self, src, lang ) )

	return html
end

-- Return the final class
return PlanRender
