#!/usr/bin/env lua

local function getFlag()
    if arg[3]:find "Z" then
        return "🔍"
    elseif arg[3]:find "M" then
        return "※"
    elseif arg[3]:find "-" then
        return "∙"
    else
        return " "
    end
end

if arg[4] == "true" then
    io.write(string.format("#[fg=#000000]#[fg=#E34234,bg=#000000]%s#[fg=#444444]│#[fg=#E34234]%s%s#[fg=#000000,bg=default]", arg[1], arg[2], (function()
        return getFlag()
    end)()))
else
    local left, right, accent = " ", " ", "#666666"
    local separator = string.format("#[fg=%s]⁞", accent)

    if arg[3]:find "!" then
        --  Activity detected.
        accent = "#AAAAAA"
        left = "#[fg=" .. accent .. "]#[fg=default]"
        right = "#[fg=" .. accent .. "]"
        separator = string.format("#[fg=%s]│", accent)
    elseif arg[3]:find "#" then
        --  Activity detected.
        accent = "#666666"
        left = "#[fg=" .. accent .. "]#[fg=default]"
        right = "#[fg=" .. accent .. "]"
    end

    io.write(string.format("%s%s%s#[fg=default]%s%s%s", left, arg[1], separator, arg[2], (function()
        return getFlag()
    end)(), right))
end

--local d = io.open("/tmp/vmux.window.log", "a")
--d:write(table.concat(arg, "\t") .. "\n")
--d:close()

