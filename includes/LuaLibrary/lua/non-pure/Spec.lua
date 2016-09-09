-- accesspoints for the bilerplate
local php
local options

-- @var structure for storage of the lib
local spec = {}

-- spec.util = require 'speclib/util'
-- spec.stack = require 'speclib/Stack'
spec.adapt = require 'speclib/engine/Adapt'
spec.expect = require 'speclib/engine/Expect'
spec.subject = require 'speclib/engine/Subject'
spec.constituent = require 'speclib/report/Constituent'
spec.renders = require 'speclib/render/Renders'
spec.frame = require 'speclib/engine/Frame'
--local Plan = require 'speclib/report/Plan'
--[[
    for k,v in pairs( util ) do
    if not spec[k] then
        spec[k] = v
    end
end
--]]

-- require libs and create an instance
spec.extractors = require( 'speclib/extractor/ExtractorStrategies' ).create()

local export = {
    subject = spec.subject,
    expect = spec.expect
}

-- create the access to othe other parties
function spec.expect.other() return Subject end
function spec.subject.other() return Expect end

function spec.report( frame )
    local style = frame.args[1]
    return 'ping! '..style
    --return Plan():realize( Renders( style ) )
end

--- install the module in the global space
function spec.setupInterface( opts )

    -- boilerplate
    spec.setupInterface = nil
    php = mw_interface
    mw_interface = nil
	options = opts

    -- register main lib
    mw = mw or {}
    mw.spec = spec
    package.loaded['mw.spec'] = spec

    -- register render styles
    for k,v in pairs( opts.renderStyles ) do
        local style = spec.renders:registerStyle( k )
        for l,w in pairs( opts.renderTypes ) do
            style:registerType( l, require( v .. '/' .. w ) )
        end
    end

    -- register extractor types
    for _,v in ipairs( opts.extractorStrategies ) do
        local style = spec.extractors:register( require( v ).create() )
    end


    -- set up additional access points
    for k,v in pairs( export ) do
        if not mw[k] then
            mw[k] = v
            --package.loaded['mw.'..k] = v
        end
    end
end

-- Return the final library
return spec
