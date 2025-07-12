local SnakeGame = {}
SnakeGame.__index = SnakeGame

local Events = require("events")

function SnakeGame:new()
    local tileSize = 16
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local gridWidth = math.floor(screenWidth / tileSize)
    local gridHeight = math.floor(screenHeight / tileSize)

    local game = {
        snake = {
            {x = math.floor(gridWidth / 2), y = math.floor(gridHeight / 2)}
        },
        direction = {x = 1, y = 0},
        food = {
            x = love.math.random(0, gridWidth - 1),
            y = love.math.random(0, gridHeight - 1)
        },
        score = 0,
        gameOver = false,
        timer = 0,
        speed = 0.15,
        tileSize = tileSize,
        gridWidth = gridWidth,
        gridHeight = gridHeight,
        eventMessage = "",
        color = {1, 1, 1},        
        colorTimer = 0             
    }

    return setmetatable(game, SnakeGame)
end

function SnakeGame:update(dt)
    if self.gameOver then return end

   
    if self.colorTimer > 0 then
        self.colorTimer = self.colorTimer - dt
        if self.colorTimer <= 0 then
            self.color = {1, 1, 1}
        end
    end

    self.timer = self.timer + dt
    if self.timer >= self.speed then
        self.timer = 0

        local head = self.snake[1]
        local newHead = {
            x = head.x + self.direction.x,
            y = head.y + self.direction.y
        }

       
        if newHead.x < 0 or newHead.y < 0 or
           newHead.x >= self.gridWidth or newHead.y >= self.gridHeight then
            self.gameOver = true
            Events:emit("game_over", {score = self.score})
            return
        end

       
        for _, segment in ipairs(self.snake) do
            if segment.x == newHead.x and segment.y == newHead.y then
                self.gameOver = true
                Events:emit("game_over", {score = self.score})
                return
            end
        end

        table.insert(self.snake, 1, newHead)

        
        if newHead.x == self.food.x and newHead.y == self.food.y then
            self.score = self.score + 1
            self.eventMessage = "Yum! Score: " .. self.score

            
            self.color = {0, 1, 0}        
            self.colorTimer = 0.40        

            Events:emit("food_eaten", {score = self.score})

            self.food = {
                x = love.math.random(0, self.gridWidth - 1),
                y = love.math.random(0, self.gridHeight - 1)
            }
        else
            table.remove(self.snake)
        end
    end
end

function SnakeGame:draw()
 
    love.graphics.setColor(self.color)
    for _, segment in ipairs(self.snake) do
        love.graphics.rectangle("fill",
            segment.x * self.tileSize,
            segment.y * self.tileSize,
            self.tileSize,
            self.tileSize
        )
    end

  
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill",
        self.food.x * self.tileSize,
        self.food.y * self.tileSize,
        self.tileSize,
        self.tileSize
    )

   
    love.graphics.setColor(1, 1, 1)

    
    love.graphics.print("Score: " .. self.score, 10, 10)

   
    if self.eventMessage then
        love.graphics.print(self.eventMessage, 10, 30)
    end


    if self.gameOver then
        love.graphics.print("Game Over - Press SPACE", 300, 250)
    end
end

function SnakeGame:changeDirection(dx, dy)
    if self.direction.x + dx == 0 and self.direction.y + dy == 0 then return end
    self.direction = {x = dx, y = dy}
end

return SnakeGame