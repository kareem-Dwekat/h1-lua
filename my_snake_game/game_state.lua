local SnakeGame = require("snake_game")
local Input = require("input")
local Events = require("events") 

local GameState = {}

local game
local input

function GameState:update(dt)
    if game then
        game:update(dt)
    end
end

function GameState:draw()
    if game then
        game:draw()
    end
end

function GameState:keypressed(key)
    if input then
        input:handleKey(key)
    end
end

function GameState:enter()
    game = SnakeGame:new()
    input = Input:new()

 
    input:bind("up", function() game:changeDirection(0, -1) end)
    input:bind("down", function() game:changeDirection(0, 1) end)
    input:bind("left", function() game:changeDirection(-1, 0) end)
    input:bind("right", function() game:changeDirection(1, 0) end)

   
    Events:subscribe("food_eaten", function(data)
        print("🎉 Food eaten! Score:", data.score)

      
        game.color = {
            love.math.random(),     
            love.math.random(),     
            love.math.random()     
        }
        game.colorTimer = 0.3
    end)

    
    Events:subscribe("game_over", function(data)
        print("💀 Game Over! Final Score:", data.score)
    end)
end

return GameState