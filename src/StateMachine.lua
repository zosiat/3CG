-- author: Zosia Trela
-- StateMachine.lua
-- 5/30/25
-- CMPM 121

local StateMachine = {}

function StateMachine:new(states)
    local o = {
        states = states or {},
        current = nil
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current = self.states[stateName]()
    if self.current.enter then
        self.current:enter(enterParams)
    end
end

function StateMachine:update(dt)
    if self.current and self.current.update then
        self.current:update(dt)
    end
end

function StateMachine:draw()
    if self.current and self.current.draw then
        self.current:draw()
    end
end

function StateMachine:keypressed(key)
    if self.current and self.current.keypressed then
        self.current:keypressed(key)
    end
end

return function(states)
    return StateMachine:new(states)
end
