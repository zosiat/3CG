-- author: Zosia Trela
-- VisualCard.lua
-- 6/4/25

local VisualCard = {}
VisualCard.__index = VisualCard

-- constructor
function VisualCard:new(data, x, y)
    local o = {
        name = data.name or "Unknown",
        cost = data.cost or 0,
        power = data.power or 0,
        text = data.text or "",
        x = x or 0,
        y = y or 0,
        width = 120,
        height = 160
    }
    setmetatable(o, self)
    return o
end

-- draw the card
function VisualCard:draw()
    -- draw white background
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 6, 6)

    -- draw black outline
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 6, 6)

    -- draw card text
    love.graphics.setColor(0, 0, 0)

    love.graphics.printf(self.name, self.x + 5, self.y + 5, self.width - 10, "center")
    love.graphics.printf("Cost: " .. self.cost, self.x + 5, self.y + 30, self.width - 10, "left")
    love.graphics.printf("Power: " .. self.power, self.x + 5, self.y + 50, self.width - 10, "left")
    love.graphics.printf(self.text, self.x + 5, self.y + 80, self.width - 10, "left")
end

return VisualCard
