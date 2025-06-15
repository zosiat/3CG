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
    
    if self.points == 5 then
    gStateMachine:change('credits')
    elseif self.aipoints == 5 then
        gStateMachine:change('lose')
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

function StateMachine:mousepressed(x, y, button)
    if self.current and self.current.mousepressed then
        self.current:mousepressed(x, y, button)
    end
end

function StateMachine:mousereleased(x, y, button)
    if self.current and self.current.mousereleased then
        self.current:mousereleased(x, y, button)
    end
end

return function(states)
    return StateMachine:new(states)
end