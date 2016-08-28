local php
--local Stack = require 'speclib/Stack'
local Expect = require 'speclib/engine/Expect'
local Subject = require 'speclib/engine/Subject'
--local Renders = require 'speclib/render/Renders'
--local Plan = require 'speclib/report/Plan'

--function Expect.other() return Subject end
--function Subject.other() return Expect end
--Subject.other = Expect

local export = {
    subject = Subject,
    expect = Expect
}

local spec = {
    subject = Subject,
    expect = Expect
}

function spec.report( frame )
    local style = frame.args[1]
    return 'ping! '..style
    --return Plan():realize( Renders( style ) )
end

--- install the module in the global space
function spec.setupInterface()
    -- boilerplate
    php = mw_interface
    mw_interface = nil

    -- register lib in mw global
    mw = mw or {}
    mw.spec = spec
    package.loaded['mw.spec'] = spec

    -- set up additional access points
    for k,v in pairs( export ) do
        if not mw[k] then
            mw[k] = v
            package.loaded['mw.'..k] = v
        end
    end
end

return spec
