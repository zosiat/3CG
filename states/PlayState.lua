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
    
    -- for locations and card slots
    self.board = {
        {
            playerSlots = {nil, nil, nil, nil},
            aiSlots = {nil, nil, nil, nil}
        },
        {
            playerSlots = {nil, nil, nil, nil},
            aiSlots = {nil, nil, nil, nil}
        },
        {
            playerSlots = {nil, nil, nil, nil},
            aiSlots = {nil, nil, nil, nil}
        }
    }
    
    -- initialize board with 3 locations
    self.board = {}
    for i = 1, 3 do
        self.board[i] = {
            playerSlots = { nil, nil, nil, nil },
            aiSlots = { nil, nil, nil, nil },
            color = self:getLocationColor(i)
        }
    end

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
    self.deck:populate(13)
    self.deck:shuffle()
    self.deck:drawToHand(3)


    self.handVisuals = self.deck:getVisualHand(love.graphics.getHeight() - 200)
    
    -- ai deck setup
    self.aiDeck = Deck:new()
    self.aiDeck:populate(13)
    self.aiDeck:shuffle()
    
    self.aiDeck:drawToHand(3)
    self.aiHandVisuals = self.aiDeck:getVisualHand(100)

end

function PlayState:update(dt)
    -- placeholder update logic
    self.timer = self.timer + dt
end

function PlayState:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local locationWidth = screenWidth / 3
    -- slots are the same size as cards
    local slotWidth = 120
    local slotHeight = 160
    local slotSpacing = 10

    -- draw title
    love.graphics.setFont(Fonts.large)
    love.graphics.printf("Welcome to Trial by Card!", 0, 100, screenWidth, "center")

    -- draw board locations (slots + cards)
    for i, location in ipairs(self.board) do
        local xOffset = (i - 1) * locationWidth + (locationWidth - (slotWidth * 4 + slotSpacing * 3)) / 2
        love.graphics.setColor(location.color)

        -- AI slots
        for j = 1, 4 do
            local x = xOffset + (j - 1) * (slotWidth + slotSpacing)
            local y = 400
            love.graphics.rectangle("line", x, y, slotWidth, slotHeight)
            if location.aiSlots[j] then
                location.aiSlots[j]:draw(x, y)
            end
        end

        -- Player slots
        for j = 1, 4 do
            local x = xOffset + (j - 1) * (slotWidth + slotSpacing)
            local y = screenHeight - 500
            love.graphics.rectangle("line", x, y, slotWidth, slotHeight)
            if location.playerSlots[j] then
                location.playerSlots[j]:draw(x, y)
            end
        end
    end

    -- draw submit button
    local b = self.submitButton
    love.graphics.setFont(Fonts.large)
    love.graphics.setColor(0.2, 0.6, 0.8)
    love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(b.text, b.x, b.y + 12, b.width, "center")

    -- draw hand cards
    love.graphics.setFont(Fonts.small)
    for _, cardVis in ipairs(self.handVisuals) do
        cardVis:draw()
    end

    -- draw AI hand (optional — can remove if it feels cluttered)
    for _, card in ipairs(self.aiHandVisuals) do
        card:draw()
    end

    -- draw turn counter
    local turnText = "Turn: " .. self.turn
    local textWidth = Fonts.large:getWidth(turnText)
    love.graphics.setFont(Fonts.large)
    love.graphics.printf(turnText, screenWidth - textWidth - 10, 10, textWidth, "left")
end

function PlayState:checkSlotSelection(x, y)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local locationWidth = screenWidth / 3
    local slotHeight = 100
    local slotWidth = 70
    local slotSpacing = 10

    for i, location in ipairs(self.board) do
        local xOffset = (i - 1) * locationWidth + (locationWidth - (slotWidth * 4 + slotSpacing * 3)) / 2
        for j = 1, 4 do
            local slotX = xOffset + (j - 1) * (slotWidth + slotSpacing)
            local slotY = screenHeight - 200
            if x >= slotX and x <= slotX + slotWidth and y >= slotY and y <= slotY + slotHeight then
                if not location.playerSlots[j] and self.selectedCard then
                    location.playerSlots[j] = self.selectedCard
                    -- Remove the card from hand
                    for k, card in ipairs(self.handVisuals) do
                        if card == self.selectedCard then
                            table.remove(self.handVisuals, k)
                            break
                        end
                    end
                    self.selectedCard = nil
                    return
                end
            end
        end
    end
end

-- helper function for color coded locations
function PlayState:getLocationColor(index)
    local colors = {
        {1, 0.4, 0.4}, -- red-ish
        {0.4, 1, 0.4}, -- green-ish
        {0.4, 0.4, 1}  -- blue-ish
    }
    return colors[index] or {1, 1, 1}
end

-- helper function for card placement
function PlayState:tryPlaceCardInSlot(x, y)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local locationWidth = screenWidth / 3
    local slotWidth = 70
    local slotHeight = 100
    local slotSpacing = 10

    for locIndex, location in ipairs(self.board) do
        local xOffset = (locIndex - 1) * locationWidth + (locationWidth - (slotWidth * 4 + slotSpacing * 3)) / 2

        for slotIndex = 1, 4 do
            local slotX = xOffset + (slotIndex - 1) * (slotWidth + slotSpacing)
            local slotY = screenHeight - 200

            if x >= slotX and x <= slotX + slotWidth and y >= slotY and y <= slotY + slotHeight then
                if not location.playerSlots[slotIndex] then
                    location.playerSlots[slotIndex] = self.selectedCard

                    -- remove the visual card from hand
                    for i, card in ipairs(self.handVisuals) do
                        if card == self.selectedCard then
                            table.remove(self.handVisuals, i)
                            break
                        end
                    end

                    return true -- successfully placed
                end
            end
        end
    end

    return false -- no slot was selected
end


function PlayState:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function PlayState:mousepressed(x, y, button)
    if button ~= 1 then return end

    -- if a card in hand was clicked
    for i, card in ipairs(self.handVisuals) do
        if card:isClicked(x, y) then
            self.selectedCard = card
            return -- stop checking once a card is selected
        end
    end

    -- place the selected card into a board slot
    if self.selectedCard then
        if self:tryPlaceCardInSlot(x, y) then
            self.selectedCard = nil -- clear selection after placement
            return
        end
    end

    -- if the Submit button was clicked
    local b = self.submitButton
    if x >= b.x and x <= b.x + b.width and y >= b.y and y <= b.y + b.height then
        self.turn = self.turn + 1
        print("Turn incremented! Current turn: " .. self.turn)
    end
end


return function()
    return PlayState:new()
end
