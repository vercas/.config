#!/usr/bin/env lua
WID = tonumber(arg[1])
CID = tonumber(arg[2])

package.path = string.format("%s;%s%s", package.path, os.getenv "HOME", "/.config/?.lua")

require "vline"
require "vmux-settings"

if CID then
    vline:set_id(CID)
end

if settings.show_hostname then
    if WID >= 210 then
        vline:add(BGC "000000", FGC "EEEE22", UNIC "🖥 |", "#{host} ")
    elseif WID >= 160 then
        vline:add(BGC "000000", FGC "EEEE22", "#{host_short} ", UNIC "🖥 |")
    end
end

if settings.show_session then
    if WID >= 210 then
        vline:add(BGC "BBBBBB", FGC "000000", UNIC " ❐ | ", "#{session_name} ")
    elseif WID >= 160 then
        vline:add(BGC "BBBBBB", FGC "000000", " #{session_name} ", UNIC "❐ |")
    elseif WID >= 100 then
        vline:add(BGC "BBBBBB", FGC "000000", "#{session_name} ", UNIC "❐ |")
    else
        vline:add(BGC "BBBBBB", FGC "000000", "#{session_name}")
    end
end

if settings.show_username then
    vline.cache("username", 120, function()
        local fDesc, fErr = io.popen("whoami")

        if fDesc then
            local username = fDesc:read "*l"
            fDesc:close()

            if username then
                return username
            end
        end

        return ""
    end, function(dat, new)
        local bgc, fgc = BGC "444444", FGC "EEEEEE"

        if dat ~= "" then
            if WID >= 210 then
                vline:add(bgc, fgc, UNIC " 😒 | ", dat, " ")
            elseif WID >= 140 then
                vline:add(bgc, fgc, " ", dat, UNIC " 😒 | ")
            end
        end
    end)
end

return vline:print_tmux(true)

