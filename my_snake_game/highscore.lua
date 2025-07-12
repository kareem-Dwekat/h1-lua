local HighScore = {}

function HighScore:save(score)
    local file = io.open("highscore.txt", "w")
    if file then
        file:write(tostring(score))
        file:close()
    end
end

function HighScore:load()
    local file = io.open("highscore.txt", "r")
    if file then
        local content = file:read("*a")
        file:close()
        return tonumber(content) or 0
    end
    return 0
end

return HighScore