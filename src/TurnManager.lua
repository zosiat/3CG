-- author: Zosia Trela
-- src/TurnManager.lua
-- 6/12/25

local TurnManager = {}

TurnManager.awaitingCleanup = false
TurnManager.cleanupTimer = 0
TurnManager.cleanupDelay = 1 -- seconds

function TurnManager:update(dt)
    if self.awaitingCleanup then
        self.cleanupTimer = self.cleanupTimer + dt
        if self.cleanupTimer >= self.cleanupDelay then
            self:cleanupCards(self.pendingPlayState)
            self:prepareNextTurn(self.pendingPlayState)
            self.awaitingCleanup = false
            self.cleanupTimer = 0
            self.pendingPlayState = nil
        end
    end
end

function TurnManager:endTurn(playState)
    playState.aiMana = playState.turn
    playState.aiPlacedCards = {}

    if playState.aiHandVisuals then
        for i = #playState.aiHandVisuals, 1, -1 do
            local card = playState.aiHandVisuals[i]
            if card and card.cost and playState.aiMana >= card.cost then
                playState.aiMana = playState.aiMana - card.cost
                
                -- random placement at y = 400
                card.x = math.random(100, love.graphics.getWidth() - 100)
                card.y = 400
                card.isAI = true
                table.insert(playState.aiPlacedCards, card)
                table.remove(playState.aiHandVisuals, i)
            end
        end
    end

    local playerPlayed = false
    for _, card in ipairs(playState.handVisuals or {}) do
        if card and card.y and card.y < love.graphics.getHeight() - 250 then
            playerPlayed = true
            break
        end
    end

    local aiPlayed = #playState.aiPlacedCards > 0

    if not playerPlayed and not aiPlayed then
        -- insert coinflip here
        self:prepareNextTurn(playState)
        return
    end

    -- if other player doesnt place card, player wins by default
    if playerPlayed and not aiPlayed then
        playState.points = playState.points + 1
    elseif aiPlayed and not playerPlayed then
        playState.aiPoints = playState.aiPoints + 1
    else
        self:evaluateBoard(playState)
    end

    self.awaitingCleanup = true
    self.cleanupTimer = 0
    self.pendingPlayState = playState

end

function TurnManager:evaluateBoard(playState)
    local playerCard = nil
    local aiCard = nil

    -- find the first valid player card placed
    for _, card in ipairs(playState.handVisuals or {}) do
        if card and card.y and card.y < love.graphics.getHeight() - 250 then
            playerCard = card
            break
        end
    end

    -- find the AI card placed (assuming only one for now)
    if #playState.aiPlacedCards > 0 then
        aiCard = playState.aiPlacedCards[1]
    end

    -- ensure both cards exist
    if playerCard and aiCard then
      
        local playerPower = playerCard.power or 0
        local aiPower = aiCard.power or 0

        if playerPower > aiPower then
            playState.points = playState.points + 1
        elseif aiPower > playerPower then
            playState.aiPoints = playState.aiPoints + 1
        else
            self:coinFlipWinner(playState)
        end
    end
end

function TurnManager:prepareNextTurn(playState)
    playState.turn = playState.turn + 1
    playState.mana = playState.turn
    playState.aiMana = playState.turn

    if playState.handVisuals and #playState.handVisuals < 7 then
        playState.deck:drawToHand(1)
        playState.handVisuals = playState.deck:getVisualHand(love.graphics.getHeight() - 200)
    end

    if playState.aiHandVisuals and #playState.aiHandVisuals < 7 then
        playState.aiDeck:drawToHand(1)
        playState.aiHandVisuals = playState.aiDeck:getVisualHand(100)
    end
end

function TurnManager:cleanupCards(playState)
    for i = #playState.handVisuals, 1, -1 do
        local cardVis = playState.handVisuals[i]
        if cardVis.y and cardVis.y < love.graphics.getHeight() - 250 then
            for j = #playState.deck.hand, 1, -1 do
                if playState.deck.hand[j].name == cardVis.name then
                    local discardedCard = table.remove(playState.deck.hand, j)
                    table.insert(playState.deck.discard, discardedCard)
                    break
                end
            end
            table.remove(playState.handVisuals, i)
        end
    end

    for i = #playState.aiPlacedCards, 1, -1 do
        local cardVis = playState.aiPlacedCards[i]
        print("Discarding AI card:", cardVis.name)
        for j = #playState.aiDeck.hand, 1, -1 do
            if playState.aiDeck.hand[j].name == cardVis.name then
                local discardedCard = table.remove(playState.aiDeck.hand, j)
                table.insert(playState.aiDeck.discard, discardedCard)
                break
            end
        end
        table.remove(playState.aiPlacedCards, i)
    end

    for _, location in ipairs(playState.board or {}) do
        for i = 1, 4 do
            location.playerSlots[i] = nil
            location.aiSlots[i] = nil
        end
    end
end

-- coinflip helper function
function TurnManager:coinFlipWinner(playState)
    local result = math.random(2)
    if result == 1 then
        playState.points = playState.points + 1
    else
        playState.aiPoints = playState.aiPoints + 1
    end
end


return TurnManager