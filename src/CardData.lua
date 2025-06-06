-- author: Zosia Trela
-- 5/30/25
-- CMPM 121
-- src/CardData.lua

local json = require("json")

local CardData = {}

CardData.data = {}

function CardData.loadData()
    local filePath = "assets/data/card_data.json"
    if love.filesystem.getInfo(filePath) then
        local contents = love.filesystem.read(filePath)
        CardData.data = json.decode(contents)
    else
        error("Could not find file: " .. filePath)
    end
end

function CardData.getByName(name)
    for _, card in ipairs(CardData.data) do
        if card.name == name then
            return card
        end
    end
    return nil
end

return CardData
