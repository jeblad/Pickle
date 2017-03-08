--- Baseclass for plan renderer

-- @var class var for lib
local PlanRender = {}

--- Lookup of missing class members
function PlanRender:__index( key ) -- luacheck: ignore self
	return PlanRender[key]
end

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
function PlanRender:key( str ) -- luacheck: ignore
	error('Method should be overridden')
	return nil
end

--- Realize reported data for skip
-- The "skip" is a message identified by a key.
function PlanRender:realizeSkip( src, lang )
	assert( src, 'Failed to provide a source' )

	if not src:hasSkip() then
		return ''
	end

	local realization = ''
	local inner = mw.message.new( src:getSkip() )

	if lang then
		inner:inLanguage( lang )
	end

	if not inner:isDisabled() then
		realization = inner:plain()
	end

	local outer = mw.message.new( self:key( 'wrap-skip' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for todo
-- The "todo" is a text string.
function PlanRender:realizeTodo( src, lang )
	assert( src, 'Failed to provide a source' )

	if not src:hasTodo() then
		return ''
	end

	local realization = mw.text.encode( src:getTodo() )
	local outer = mw.message.new( self:key( 'wrap-todo' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for description
-- The "description" is a text string.
function PlanRender:realizeDescription( src, lang )
	assert( src, 'Failed to provide a source' )

	if not src:hasDescription() then
		return ''
	end

	local realization = mw.text.encode( src:getDescription() )
	local outer = mw.message.new( self:key( 'wrap-description' ), realization )

	if lang then
		outer:inLanguage( lang )
	end

	if outer:isDisabled() then
		return realization
	end

	return outer:plain()
end

--- Realize reported data for header
-- The "header" is a composite.
function PlanRender:realizeHeader( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = { self:realizeState( src, lang ) }

	if src:hasDescription() then
		table.insert( t, self:realizeDescription( src, lang ) )
	end

	if src:hasSkip() or src:hasTodo() then
		table.insert( t, '# ' )
		table.insert( t, self:realizeSkip( src, lang ) )
		table.insert( t, self:realizeTodo( src, lang ) )
	end

	return table.concat( t, '' )
end

--- Realize reported data for body
-- The "body" is a composite.
function PlanRender:realizeBody( src, lang )
	assert( src, 'Failed to provide a source' )

	local t = {}

	for _,v in ipairs( { src:constituents() } ) do
		table.insert( t, self:realize( v, lang ) )
	end

	return #t == 0 and '' or ( "\n"  .. table.concat( t, "\n" ) )
end

-- Return the final class
return PlanRender
