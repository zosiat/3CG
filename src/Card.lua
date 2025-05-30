-- author: Zosia Trela
-- 5/30/25
-- CMPM 121
-- states/Card.lua

local json = require("json")
local Card = {}

Card.data = {}

function Card.loadData()
    local filePath = "assets/data/card_data.json"
    if love.filesystem.getInfo(filePath) then
        local contents = love.filesystem.read(filePath)
        Card.data = json.decode(contents)
    else
        error("Could not find file: " .. filePath)
    end
end

function Card.getByName(name)
    for _, card in ipairs(Card.data) do
        if card.name == name then
            return card
        end
    end
    return nil
end

return Card
