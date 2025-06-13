-- author: Zosia Trela
-- Deck.lua
-- CMPM 121
-- 6/4/25

local Card = require 'src/Card'
local VisualCard = require 'src/VisualCard'

local Deck = {}
Deck.__index = Deck

discardPile = {}

function Deck:new()
    local o = {
        cards = {},
        hand = {},
        discard = {}
    }
    setmetatable(o, self)

    -- take first 13 cards from Card.data
    for i = 1, math.min(13, #Card.data) do
        table.insert(o.cards, Card.data[i])
    end

    return o
end

function Deck:shuffle()
    for i = #self.cards, 2, -1 do
        local j = love.math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

function Deck:populate(count)
    self.cards = {}
    for i = 1, count do
        table.insert(self.cards, Card.data[i])
    end
end

function Deck:drawToHand(n)
    for i = 1, n do
        local drawn = table.remove(self.cards, 1)
        if drawn then
            table.insert(self.hand, drawn)
        end
    end
end

-- allows for the hand to be displayed
function Deck:getVisualHand(y)
    local visuals = {}
    local cardWidth = 120
    local spacing = 20
    local totalCards = #self.hand
    local totalWidth = (cardWidth + spacing) * totalCards - spacing
    local startX = (love.graphics.getWidth() - totalWidth) / 2

    for i, card in ipairs(self.hand) do
        local x = startX + (i - 1) * (cardWidth + spacing)
        table.insert(visuals, VisualCard:new(card, x, y))
    end

    return visuals
end

return Deck
