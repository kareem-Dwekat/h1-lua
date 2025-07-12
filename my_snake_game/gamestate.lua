local GameState = {}
GameState.__index = GameState

function GameState:new()
    local state = {
        current = "menu",
        states = {
            menu = require("menu_state"),
            playing = require("game_state")
        }
    }
    return setmetatable(state, GameState)
end

function GameState:switch(newState)
    if self.states[newState] then
        self.current = newState
    end
end

function GameState:update(dt)
    local state = self.states[self.current]
    if state and state.update then
        state:update(dt)
    end
end

function GameState:draw()
    local state = self.states[self.current]
    if state and state.draw then
        state:draw()
    end
end

return GameState