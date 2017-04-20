#!/usr/bin/env lua
WID = tonumber(arg[1])

require "vline"

if WID >= 130 then
    vline:add(BGC "000000", FGC "EEEE22", string.format(os.date(" 📅 %Y-%m-%d %a %%s %H:%M:%S", vline.time), vline.get_clock()))
elseif WID >= 100 then
    vline:add(BGC "000000", FGC "EEEE22", os.date(" %Y-%m-%d📅 %H:%M:%S", vline.time))
elseif WID >= 70 then
    vline:add(BGC "000000", FGC "EEEE22", os.date("%y-%m-%d %H:%M:%S", vline.time))
else
    vline:add(BGC "000000", FGC "EEEE22", string.format(os.date("%m-%d %%s %M", vline.time), vline.get_clock()))
end

do
    local fDesc, fErr = io.open("/proc/uptime", "r")

    if fDesc then
        local uptime = fDesc:read("*n")
        fDesc:close()

        if uptime then
            vline:add(BGC "CCCCCC", FGC "000000", (function()
                if uptime < 60 then     --  Under a minute.
                    if WID >= 210 then
                        return " 💡 ", math.floor(uptime), "s"
                    elseif WID >= 100 then
                        return math.floor(uptime), "s 💡"
                    else
                        return math.floor(uptime), "s"
                    end
                elseif uptime < 3600 then   --  Under an hour.
                    if WID >= 210 then
                        return " 💡 ", math.floor(uptime / 60), "m"
                    elseif WID >= 100 then
                        return math.floor(uptime / 60), "m 💡"
                    else
                        return math.floor(uptime / 60), "m"
                    end
                elseif uptime < 86400 then  --  Under a day.
                    if WID >= 210 then
                        return " 💡 ", math.floor(uptime / 3600), "h ", FGC "666666", string.format("%dm ", (uptime / 60) % 60)
                    elseif WID >= 100 then
                        return " ", math.floor(uptime / 3600), "h ", FGC "666666", string.format("%dm 💡 ", (uptime / 60) % 60)
                    elseif WID >= 70 then
                        return math.floor(uptime / 3600), "h", FGC "666666", string.format("%dm💡", (uptime / 60) % 60)
                    else
                        return math.floor(uptime / 3600), "h"
                    end
                else    --  Over a day.
                    if WID >= 210 then
                        return " 💡 ", math.floor(uptime / 86400), "d ", FGC "666666", string.format("%dh ", (uptime / 3600) % 24)
                    elseif WID >= 100 then
                        return " ", math.floor(uptime / 86400), "d ", FGC "666666", string.format("%dh 💡 ", (uptime / 3600) % 24)
                    elseif WID >= 70 then
                        return math.floor(uptime / 86400), "d", FGC "666666", string.format("%dh💡", (uptime / 3600) % 24)
                    else
                        return math.floor(uptime / 86400), "d"
                    end
                end
            end)())
        end
    end
end

vline.cache("free-memory", 10, function()
    local fDesc, fErr = io.popen("free -bw")

    if fDesc then
        local meminfo = fDesc:read "*a"
        fDesc:close()

        if meminfo then
            local total, avl = meminfo:match "Mem:%s*(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)"
            total, avl = tonumber(total), tonumber(avl)

            if total and avl then
                return string.format("%d/%d", avl, total)
            end
        end
    end

    return "NOPE"
end, function(dat, new)
    if dat == "NOPE" then return end

    local avl, total = dat:match "^(%d+)/(%d+)$"
    avl, total = tonumber(avl), tonumber(total)

    vline:add(BGC "22AA00", FGC "EEEEEE", (function()
        if WID >= 210 then
            return string.format("📕 %d%%/%s ", 100 * avl / total, BytesToHuman(total, 2, 9))
        elseif WID >= 150 then
            return string.format("%d%%/%s 📕 ", 100 * avl / total, BytesToHuman(total, 2, 9))
        elseif WID >= 120 then
            return string.format("%d%%/%s 📕 ", 100 * avl / total, BytesToHuman(total, 2))
        elseif WID >= 100 then
            return string.format("%d%%/%s📕  ", 100 * avl / total, BytesToHuman(total, 0))
        elseif WID >= 80 then
            return string.format("%d%%%s📕", 100 * avl / total, BytesToHuman(total, 0))
        elseif WID >= 50 then
            return string.format("%d%%📕", 100 * avl / total)
        else
            return string.format("%s📕", vline.get_bar(avl / total))
        end
    end)())
end)

do
    local fDesc, fErr = io.open("/proc/loadavg", "r")

    if fDesc then
        local one = fDesc:read("*n")
        fDesc:close()

        if one then
            vline:add(BGC "444488", FGC "EEEEEE", (function()
                if WID >= 210 then
                    return string.format(" 🖩 %.2f ", one)
                elseif WID >= 100 then
                    return string.format(" %.2f🖩 ", one)
                elseif WID >= 80 then
                    return string.format("%.2f🖩", one)
                elseif WID >= 70 then
                    return string.format("%.1f🖩", one)
                elseif one >= 10 then
                    return string.format("%d🖩", math.floor(one))
                else
                    return string.format("%d%s🖩", math.floor(one), vline.get_bar(one % 1))
                end
            end)())
        end
    end
end

do
    local fDesc, fErr = io.open("/var/run/reboot-required", "r")

    if fDesc then
        fDesc:close()

        if WID >= 100 then
            vline:add(BGC "FF0000", FGC "FFFFFF", " ⥁ ")
        else
            vline:add(BGC "FF0000", FGC "FFFFFF", "⥁")
        end
    end
end

vline.cache("apt-updates", 120, function()
    local fDesc = io.popen("/usr/lib/update-notifier/apt-check")

    local dat = fDesc:read "*a"

    if (fDesc:close()) == 0 then
        return dat
    else
        return "0;0"
    end
end, function(dat, new)
    local ut, us = dat:match "^(%d+);(%d+)$"
    ut, us = tonumber(ut), tonumber(us)

    if not ut or not us or (ut == 0 and us == 0) then
        return  --  No updates.
    end

    if WID >= 120 then
        if us > 0 then
            vline:add(BGC "AA5500", FGC "FFFFFF", " ", us, "/", ut, " ⚠ ")
        else
            vline:add(BGC "AA5500", FGC "FFFFFF", " ", ut, "! ")
        end
    elseif WID >= 100 then
        if us > 0 then
            vline:add(BGC "AA5500", FGC "FFFFFF", " ", ut, " ⚠ ")
        else
            vline:add(BGC "AA5500", FGC "FFFFFF", " ", ut, "! ")
        end
    else
        if us > 0 then
            vline:add(BGC "AA5500", FGC "FFFFFF", ut, "⚠")
        else
            vline:add(BGC "AA5500", FGC "FFFFFF", ut, "!")
        end
    end
end)

return vline:print_tmux()

