-- author: Zosia Trela
-- PlayState.lua
-- 5/30/25
-- CMPM 121

local Card = require 'src/Card'

local PlayState = {}

function PlayState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlayState:enter()
    self.timer = 0

    -- try to load Zeus
    self.testCard = Card.getByName("Zeus") or { name = "Unknown", cost = 0, power = 0, text = "Missing" }
end

function PlayState:update(dt)
    -- placeholder update logic
    self.timer = self.timer + dt
end

function PlayState:draw()
    love.graphics.printf("Welcome to Trial by Card!", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("This is the Play State", 0, 150, love.graphics.getWidth(), "center")
    love.graphics.printf("Timer: " .. string.format("%.2f", self.timer), 0, 200, love.graphics.getWidth(), "center")

    -- draw card info
    love.graphics.printf("Card Name: " .. self.testCard.name, 0, 300, love.graphics.getWidth(), "center")
    love.graphics.printf("Cost: " .. self.testCard.cost .. " | Power: " .. self.testCard.power, 0, 330, love.graphics.getWidth(), "center")
    love.graphics.printf("Effect: " .. self.testCard.text, 0, 360, love.graphics.getWidth(), "center")
end

function PlayState:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

return function()
    return PlayState:new()
end
