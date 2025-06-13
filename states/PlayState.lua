-- author: Zosia Trela
-- PlayState.lua
-- 5/30/25
-- CMPM 121

local Card = require 'src/Card'
local VisualCard = require 'src/VisualCard'
local Grabber = require 'src/Grabber'
local Deck = require 'src/Deck'
local TurnManager = require "src.TurnManager"

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
    self.mana = self.turn -- start mana equals current turn
    self.points = 0;
    
    self.grabber = Grabber:new()
    
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
    for i = 1, 3 do
        self.board[i] = {
            playerSlots = { nil, nil, nil, nil },
            aiSlots = { nil, nil, nil, nil },
            color = self:getLocationColor(i)
        }
    end
    
    --audio assets
    self.cardGrabSound = love.audio.newSource("assets/kenney_interface-sounds/Audio/select_004.ogg", "static")
        self.cardDropSound = love.audio.newSource("assets/kenney_interface-sounds/Audio/drop_003.ogg", "static")
        self.SubmitSound = love.audio.newSource("assets/kenney_interface-sounds/Audio/click_001.ogg", "static")



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
    
    -- draw all hand cards except selectedCard
    for _, card in ipairs(self.handVisuals) do
        if card ~= self.selectedCard then
            card:draw()
        end
    end

    -- draw dragged card last
    if self.selectedCard then
        self.selectedCard:draw()
    end

end

-- TODO: Fix snapping mechanic
function PlayState:trySnapToPlayerSlot(card)
    for _, lane in ipairs(self.board) do
        for _, slot in ipairs(lane.playerSlots) do
            if not slot.card then
                -- Snap if card is close enough
                local dx = (card.x + card.width / 2) - (slot.x + card.width / 2)
                local dy = (card.y + card.height / 2) - (slot.y + card.height / 2)
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < 80 then -- SNAP RANGE
                    card.x = slot.x
                    card.y = slot.y
                    slot.card = card
                    return true
                end
            end
        end
    end
    return false
end

function PlayState:update(dt)
    -- placeholder update logic
    self.timer = self.timer + dt
    
    local mx, my = love.mouse.getPosition()
    if self.grabber then
        self.grabber:update(mx, my)
    end
end

function PlayState:draw()
  
    if self.grabber.heldCard then
      self.grabber.heldCard:draw()
    end
--      -- draw title
--    love.graphics.setFont(Fonts.large)
--    love.graphics.printf("Welcome to Trial by Card!", 0, 100, screenWidth, "center")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local locationWidth = screenWidth / 3
    -- slots are the same size as cards
    local slotWidth = 120
    local slotHeight = 160
    local slotSpacing = 10

    -- draw turn counter
    local turnText = "Turn: " .. self.turn
    local textWidth = Fonts.large:getWidth(turnText)
    love.graphics.setFont(Fonts.large)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(turnText, screenWidth - textWidth - 20, 20)
    
    -- draw mana counter
    local manaText = "Mana: " .. self.mana
    local manaTextWidth = Fonts.large:getWidth(manaText)
    love.graphics.setFont(Fonts.large)
    love.graphics.setColor(0.4, 0.8, 1) -- Light blue for mana
    love.graphics.print(manaText, screenWidth - manaTextWidth - 20, 60)
    
    -- draw player points
    local pointsText = "Points: " .. self.points
    local pointsTextWidth = Fonts.large:getWidth(manaText)
    love.graphics.setFont(Fonts.large)
    love.graphics.setColor(0.2, 0.6, 0.2) 
    love.graphics.print(pointsText, screenWidth - pointsTextWidth - 20, 100)
    
    -- draw AI deck pile (top-left)
    VisualCard:drawCardBack(20, 20, "AI")
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(#self.aiDeck.cards .. " left", 25, 190)

    -- draw Player deck pile (bottom-right)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    VisualCard:drawCardBack(screenWidth - 300, screenHeight - 180, "You")
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(#self.deck.cards .. " left", screenWidth - 300, screenHeight - 200)

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
    love.graphics.setColor(0.2, 0.6, 0.2)
    love.graphics.rectangle("fill", b.x, b.y, b.width, b.height, 8, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(b.text, b.x, b.y + 10, b.width, "center")

    -- draw hand cards
    love.graphics.setFont(Fonts.small)
    for _, cardVis in ipairs(self.handVisuals) do
        cardVis:draw()
    end

    -- draw AI hand (optional — can remove if it feels cluttered)
    for _, card in ipairs(self.aiHandVisuals) do
        card:draw()
    end
    
    if self.selectedCard then
      self.selectedCard:draw()
    end
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
    for laneIndex, lane in ipairs(self.board) do
        for slotIndex, slot in ipairs(lane.playerSlots) do
            if not slot.card then
              local cx = self.grabber.heldCard.x + self.grabber.heldCard.width / 2
              local cy = self.grabber.heldCard.y + self.grabber.heldCard.height / 2

              if cx >= slot.x and cx <= slot.x + 120 and
                 cy >= slot.y and cy <= slot.y + 160 then
              end

                -- place the card
                slot.card = self.grabber.heldCard

                -- store location index on the card (optional, useful for logic later)
                self.grabber.heldCard.lane = laneIndex
                self.grabber.heldCard.slot = slotIndex

                -- debug
                print("Card placed at lane:", laneIndex, "slot:", slotIndex)
                print("Card name:", slot.card.name)

                return true
            end
        end
    end
    return false
end

function PlayState:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function PlayState:mousepressed(x, y, button)
    if button ~= 1 then return end

    -- try to pick up a card (only if there's enough mana)
    self.selectedCard = self.grabber:mousepressed(x, y, self.handVisuals, self.mana)

    if self.selectedCard then

        local placed = self:tryPlaceCardInSlot(x, y)
        
        self.cardGrabSound:stop()
        self.cardGrabSound:play()

        if placed then
            -- only subtract mana if cost is valid
            if self.selectedCard.cost and self.mana >= self.selectedCard.cost then
                self.mana = self.mana - self.selectedCard.cost
            end

            self.grabber:mousereleased(x, y)
            self.selectedCard = nil
            return
        end
    end

    -- check submit button
    local b = self.submitButton
    if x >= b.x and x <= b.x + b.width and y >= b.y and y <= b.y + b.height then
        self.SubmitSound:stop()
        self.SubmitSound:play()
        TurnManager:endTurn(self)
    end
end


function PlayState:mousereleased(x, y, button)
    if button ~= 1 then
      return end

    if self.grabber.heldCard and self:tryPlaceCardInSlot(x, y) then
        self.handVisuals = self:removeCard(self.handVisuals, self.grabber.heldCard)
        self.selectedCard = nil
        self.cardDropSound:stop()
        self.cardDropSound:play()
    end
    self.grabber:mousereleased(x, y)
end

function PlayState:removeCard(list, cardToRemove)
    local newList = {}
    for _, c in ipairs(list) do
        if c ~= cardToRemove then
            table.insert(newList, c)
        end
    end
    return newList
end

function PlayState:mousemoved(x, y, dx, dy)
    self.grabber:mousemoved(x, y)
end

return function()
    return PlayState:new()
end