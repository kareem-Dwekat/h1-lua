local MenuState = {}

function MenuState:update(dt)
    -- لا شيء مؤقتاً
end

function MenuState:draw()
    love.graphics.print("Menu State - Press SPACE to Start", 100, 100)
end

return MenuState