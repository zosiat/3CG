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

function VisualCard:isClicked(mx, my)
    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
end

function VisualCard:drawCardBack(x, y, label)
    -- card back rectangle
    love.graphics.setColor(0.2, 0.2, 0.5) -- dark blue-ish back
    love.graphics.rectangle("fill", x, y, 120, 160, 6, 6)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, 120, 160, 6, 6)

    -- draw deck label (e.g. "AI", "Player")
    love.graphics.setFont(Fonts.small)
    love.graphics.printf(label, x, y + 65, 120, "center")
end

return VisualCard
