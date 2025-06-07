-- grabber.lua
-- Handles drag-and-drop behavior for cards

local Grabber = {}
Grabber.__index = Grabber

function Grabber:new()
    local o = {
        heldCard = nil,
        offsetX = 0,
        offsetY = 0
    }
    setmetatable(o, self)
    return o
end

function Grabber:update()
    if self.heldCard then
        local mx, my = love.mouse.getPosition()
        self.heldCard.x = mx - self.offsetX
        self.heldCard.y = my - self.offsetY
    end
end

function Grabber:mousepressed(x, y, handVisuals)
    for _, card in ipairs(handVisuals) do
        if card:isClicked(x, y) then
            self.heldCard = card
            self.offsetX = x - card.x
            self.offsetY = y - card.y
            return card
        end
    end
    return nil
end

function Grabber:mousereleased(x, y)
    print("Grabber: releasing") -- debug

    if self.heldCard then
        self.heldCard.state = 0
        self.heldCard = nil
    end
end

return Grabber