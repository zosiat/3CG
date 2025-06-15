-- author: Zosia Trela
-- main.lua
-- 5/30/25
-- CMPM 121

-- require state machine and states
local StateMachine = require 'src/StateMachine'
local TitleState = require 'states/TitleState'
local PlayState = require 'states/PlayState'
local CreditState = require 'states/CreditState'
local LoseState = require 'states/LoseState'
local Card = require 'src/Card'

Fonts = {}

function love.load()
    Card.loadData()
    
    Fonts.large = love.graphics.newFont(24) -- for UI and titles
    Fonts.small = love.graphics.newFont(12) -- for card text

    love.graphics.setFont(Fonts.large) -- set default font

    love.window.setTitle("Trial by Card")
    
    -- set up state machine
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['play'] = function() return PlayState() end,
        ['credit'] = function() return CreditState() end,
        ['lose'] = function() return LoseState() end
        
    }

    gStateMachine:change('title')
end

function love.update(dt)
    gStateMachine:update(dt)
end

function love.draw()
    gStateMachine:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    gStateMachine:keypressed(key)
end

function love.mousepressed(x, y, button)
    gStateMachine:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    gStateMachine:mousereleased(x, y, button)
end
