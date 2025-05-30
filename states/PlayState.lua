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
    self.turn = 1

    -- button position and size (bottom right corner)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    self.submitButton = {
        x = screenW - 120,   -- 120 px from right edge
        y = screenH - 50,    -- 50 px from bottom edge
        width = 100,
        height = 40,
        text = "Submit"
    }

    self.testCard = Card.getByName("Zeus") or { name = "Unknown", cost = 0, power = 0, text = "Missing" }
end

function PlayState:update(dt)
    -- placeholder update logic
    self.timer = self.timer + dt
end

function PlayState:draw()
    love.graphics.printf("Welcome to Trial by Card!", 0, 100, love.graphics.getWidth(), "center")
    
    -- display turn in top right corner
    local turnText = "Turn: " .. self.turn
    local textWidth = love.graphics.getFont():getWidth(turnText)
    love.graphics.printf(turnText, love.graphics.getWidth() - textWidth - 10, 10, textWidth, "left")

    -- draw card info
    love.graphics.printf("Card Name: " .. self.testCard.name, 0, 300, love.graphics.getWidth(), "center")
    love.graphics.printf("Cost: " .. self.testCard.cost .. " | Power: " .. self.testCard.power, 0, 330, love.graphics.getWidth(), "center")
    love.graphics.printf("Effect: " .. self.testCard.text, 0, 360, love.graphics.getWidth(), "center")
    
    -- draw submit button
    local b = self.submitButton
    love.graphics.setColor(0.2, 0.6, 0.8) -- button color (blueish)
    love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
    love.graphics.setColor(1, 1, 1) -- white text
    love.graphics.printf(b.text, b.x, b.y + 12, b.width, "center")

end

function PlayState:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function PlayState:mousepressed(x, y, button)
    if button == 1 then
        local b = self.submitButton
        if x >= b.x and x <= b.x + b.width and y >= b.y and y <= b.y + b.height then
            self.turn = self.turn + 1
            print("Turn incremented! Current turn: " .. self.turn)
        end
    end
end

return function()
    return PlayState:new()
end
