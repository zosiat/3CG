-- author: Zosia Trela
-- src/TurnManager.lua
-- 6/12/25

--local PlayState = require "states.PlayState"

local TurnManager = {}

function TurnManager:endTurn(playState)
    -- calculate location winners
    for i, location in ipairs(playState.board) do
        local playerPower = 0
        local aiPower = 0

        for _, card in ipairs(location.playerSlots) do
            if card then playerPower = playerPower + card.power end
        end

        for _, card in ipairs(location.aiSlots) do
            if card then aiPower = aiPower + card.power end
        end

        if playerPower > aiPower then
            playState.points = playState.points + 1
        elseif aiPower > playerPower then
            playState.points = playState.points - 1
        end
    end

    -- increment turn
    playState.turn = playState.turn + 1

    -- reset mana
    playState.mana = playState.turn

    -- draw new cards, reset visuals, etc.
    
    if playState.handVisuals and #playState.handVisuals < 7 then
      playState.deck:drawToHand(1)
      playState.handVisuals = playState.deck:getVisualHand(love.graphics.getHeight() - 200)
    else
      print("Cannot draw, hand already full.")
    end

    -- TODO: cards flip, winner flips over first
    -- TODO: add card effects, after 20 points take player to credit scene
    
end

return TurnManager
