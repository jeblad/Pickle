local Expect = require 'speclib/engine/Expect'
local Subject = require 'speclib/engine/Subject'
local Renders = require 'speclib/render/Renders'
local Plan = require 'speclib/report/Plan'

Expect.other = Subject
Subject.other = Expect

local specs = {
    subject = Subject,
    expect = Expect
}

function specs.report( frame )
    local style = frame.args[1]
    return style
    --return Plan():realize( Renders( style ) )
end

--- metatable for the export
local mt = {}

--- install the module in the global space
function mt:__call()
    for k,v in pairs( self ) do
        if string.match( k, '[^A-Z]') then
            assert( not _G[k], k )
            _G[k] = v
        end
    end
    return self
end

setmetatable( specs, mt )

return specs
