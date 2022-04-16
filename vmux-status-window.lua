#!/usr/bin/env lua
WID = tonumber(arg[5])
CID = tonumber(arg[6])

package.path = string.format("%s;%s%s", package.path, os.getenv "HOME", "/.config/?.lua")

require "vline"
require "vmux-settings"

if CID then
    vline:set_id(CID)
end

if settings.force_utf8 ~= nil then
    vline:set_utf8(settings.force_utf8)
else
    vline.cache("undermosh", 120, function()
        local fDesc, fErr = io.popen("pstree -s " .. CID)

        if fDesc then
            local result = fDesc:read "*a"
            fDesc:close()

            if result then
                return result:find("mosh-server", 1, true) or ""
            end
        end

        return ""
    end, function(dat, new)
        if dat ~= "" then
            vline:set_utf8(false)
        end
    end)
end

local function getFlag()
    if arg[3]:find "Z" then
        return UNIC "🔍|Z"
    elseif arg[3]:find "M" then
        return UNIC "※|M"
    elseif arg[3]:find "-" then
        return UNIC "∙|."
    else
        return " "
    end
end

if arg[4] == "true" then
    io.write(string.format("#[fg=#000000]#[fg=#E34234,bg=#000000]%s#[fg=#444444]%s#[fg=#E34234]%s%s#[fg=#000000,bg=default]", arg[1], UNIC "│||", arg[2], (function()
        return getFlag()
    end)()))
else
    local left, right, accent = " ", " ", "#666666"
    local separator = string.format("#[fg=%s]%s", accent, UNIC "⁞|'")

    if arg[3]:find "!" then
        --  Activity detected.
        accent = "#AAAAAA"
        left = "#[fg=" .. accent .. "]#[fg=default]"
        right = "#[fg=" .. accent .. "]"
        separator = string.format("#[fg=%s]%s", accent, UNIC "│||")
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

