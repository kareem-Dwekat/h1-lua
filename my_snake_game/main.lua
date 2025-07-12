local GameState = require("gamestate")
local game = GameState:new()

function love.load()
   
    if game.states[game.current].enter then
        game.states[game.current]:enter()
    end
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    if key == "space" then
        if game.current == "menu" then
            game:switch("playing")
            if game.states.playing.enter then
                game.states.playing:enter()
            end
        else
            game:switch("menu")
        end
    else
      
        if game.current == "playing" and game.states.playing.keypressed then
            game.states.playing:keypressed(key)
        end
    end
end