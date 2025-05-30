-- author: Zosia Trela
-- main.lua
-- 5/30/25
-- CMPM 121

-- require state machine and states
local StateMachine = require 'src/StateMachine'
local TitleState = require 'states/TitleState'
local PlayState = require 'states/PlayState'
local CreditState = require 'states/CreditState'
local Card = require 'src/Card'

function love.load()
    Card.loadData()
    
    love.window.setTitle("Trial by Card")
    love.graphics.setFont(love.graphics.newFont(24))

    -- set up state machine
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['play'] = function() return PlayState() end,
        ['credit'] = function() return CreditState() end
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

