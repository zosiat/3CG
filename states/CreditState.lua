-- author: Zosia Trela
-- 5/30/25
-- CMPM 121
-- states/CreditState.lua

local CreditsState = {}

function CreditsState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CreditsState:enter()
    -- TODO: load credits text, background, etc.
end

function CreditsState:update(dt)
    -- TODO: scroll credits or add animations
end

function CreditsState:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(32))

    love.graphics.printf("YOU WIN", 0, 50, love.graphics.getWidth(), "center")

    love.graphics.printf("CREDITS", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Audio Effects from Kenney Assets", 0, 150, love.graphics.getWidth(), "center")
    love.graphics.printf("Press Enter to Return", 0, 300, love.graphics.getWidth(), "center")
end


function CreditsState:keypressed(key)
    if key == 'return' or key == 'enter' then
        gStateMachine:change('title')
    end
end

return function()
    return CreditsState:new()
end
