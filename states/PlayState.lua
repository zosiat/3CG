-- author: Zosia Trela
-- PlayState.lua
-- 5/30/25
-- CMPM 121

local Card = require 'src/Card'
local VisualCard = require 'src/VisualCard'

local PlayState = {}

function PlayState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local Deck = require 'src/Deck'

function PlayState:enter()
    self.timer = 0
    self.turn = 1

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    self.submitButton = {
        x = screenW - 120,
        y = screenH - 50,
        width = 100,
        height = 40,
        text = "Submit"
    }

    self.deck = Deck:new()
    self.deck:shuffle()
    self.deck:drawToHand(3)

    self.handVisuals = self.deck:getVisualHand(love.graphics.getHeight() - 200)
end

function PlayState:update(dt)
    -- placeholder update logic
    self.timer = self.timer + dt
end

function PlayState:draw()
    -- large font for title and turn text
    love.graphics.setFont(Fonts.large)
    love.graphics.printf("Welcome to Trial by Card!", 0, 100, love.graphics.getWidth(), "center")

    local turnText = "Turn: " .. self.turn
    local textWidth = Fonts.large:getWidth(turnText)
    love.graphics.printf(turnText, love.graphics.getWidth() - textWidth - 10, 10, textWidth, "left")

    -- draw card with small font
    if self.testCardVis then
        love.graphics.setFont(Fonts.small) -- switch to small font
        self.testCardVis:draw()
    end

    -- large font again for button
    love.graphics.setFont(Fonts.large)
    local b = self.submitButton
    love.graphics.setColor(0.2, 0.6, 0.8)
    love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(b.text, b.x, b.y + 12, b.width, "center")
    
    -- draw cards in hand
    love.graphics.setFont(Fonts.small)
    for _, cardVis in ipairs(self.handVisuals) do
        cardVis:draw()
    end

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
