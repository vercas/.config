#!/usr/bin/env lua
WID = tonumber(arg[1])

require "vline"

if WID >= 210 then
    vline:add(BGC "000000", FGC "EEEE22", "🖥 #{host} ")
elseif WID >= 160 then
    vline:add(BGC "000000", FGC "EEEE22", "#{host_short} 🖥 ")
end

if WID >= 210 then
    vline:add(BGC "BBBBBB", FGC "000000", " ❐ #{session_name} ")
elseif WID >= 160 then
    vline:add(BGC "BBBBBB", FGC "000000", " #{session_name} ❐ ")
elseif WID >= 100 then
    vline:add(BGC "BBBBBB", FGC "000000", "#{session_name} ❐ ")
else
    vline:add(BGC "BBBBBB", FGC "000000", "#{session_name}❐ ")
end

if WID >= 140 then
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
        if dat ~= "" then
            if WID >= 210 then
                vline:add(BGC "444444", FGC "EEEEEE", " 😒  ", dat, " ")
            else
                vline:add(BGC "444444", FGC "EEEEEE", " ", dat, " 😒 ")
            end
        end
    end)
end

return vline:print_tmux(true)

