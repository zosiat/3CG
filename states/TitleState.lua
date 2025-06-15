-- author: Zosia Trela
-- 5/30/25
-- CMPM 121
-- states/TitleState.lua

local TitleState = {}

function TitleState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TitleState:enter()
    -- TODO: setup music, background, etc. if needed
end

function TitleState:update(dt)
    -- TODO: animations
end

function TitleState:draw()
    love.graphics.printf("TRIAL BY CARD", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("How to Play:", 0, 300, love.graphics.getWidth(), "center")
    love.graphics.printf("Cards have power, mana cost and abilities. Your mana increases each turn. You can place the cards in your hand in any of the three locations on the board to try and win them. If the power of your placed cards is greater than your opponents, you win the turn. ", 0, 400, love.graphics.getWidth(), "center")
    love.graphics.printf("Press Enter to Begin", 0, 600, love.graphics.getWidth(), "center")
end

function TitleState:keypressed(key)
    if key == 'return' or key == 'enter' then
        gStateMachine:change('play')
    end
end

return function()
    return TitleState:new()
end
