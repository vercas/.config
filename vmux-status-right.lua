#!/usr/bin/env lua
WID = tonumber(arg[1])
CID = tonumber(arg[2])

package.path = string.format("%s;%s%s", package.path, os.getenv "HOME", "/.config/?.lua")

require "vline"
require "vmux-settings"

if CID then
    vline:set_id(CID)
end

if settings.force_utf8 ~= nil then
    vline:set_utf8(settings.force_utf8)
end

if settings.show_date and settings.show_time then
    vline:add(BGC "000000", FGC "EEEE22", function()
        if WID >= 130 then
            if vline.utf8 then
                return string.format(os.date(" 📅 %Y-%m-%d %a %%s %H:%M:%S", vline.time), vline.get_clock())
            else
                return os.date(" %Y-%m-%d %a %H:%M:%S", vline.time)
            end
        elseif WID >= 100 then
            if vline.utf8 then
                return os.date(" %Y-%m-%d📅 %H:%M:%S", vline.time)
            else
                return os.date(" %Y-%m-%d %H:%M:%S", vline.time)
            end
        elseif WID >= 70 then
            return os.date("%y-%m-%d %H:%M:%S", vline.time)
        else
            if vline.utf8 then
                return string.format(os.date("%m-%d %%s %M", vline.time), vline.get_clock())
            else
                return os.date("%m-%d %H:%M", vline.time)
            end
        end
    end)
elseif settings.show_date then
    vline:add(BGC "000000", FGC "EEEE22", function()
        if WID >= 130 then
            if vline.utf8 then
                return os.date(" 📅 %Y-%m-%d %a", vline.time)
            else
                return os.date(" %Y-%m-%d %a", vline.time)
            end
        elseif WID >= 100 then
            if vline.utf8 then
                return os.date(" %Y-%m-%d📅 ", vline.time)
            else
                return os.date(" %Y-%m-%d", vline.time)
            end
        elseif WID >= 70 then
            return os.date("%y-%m-%d", vline.time)
        else
            return os.date("%m-%d", vline.time)
        end
    end)
elseif settings.show_time then
    vline:add(BGC "000000", FGC "EEEE22", function()
        if WID >= 130 then
            if vline.utf8 then
                return string.format(os.date(" %%s %H:%M:%S", vline.time), vline.get_clock())
            else
                return os.date(" %H:%M:%S", vline.time)
            end
        elseif WID >= 100 then
            return os.date(" %H:%M:%S", vline.time)
        elseif WID >= 70 then
            return os.date("%H:%M:%S", vline.time)
        else
            if vline.utf8 then
                return string.format(os.date("%%s %M", vline.time), vline.get_clock())
            else
                return os.date("%H:%M", vline.time)
            end
        end
    end)
end

if settings.show_uptime then
    local fDesc, fErr = io.open("/proc/uptime", "r")

    if fDesc then
        local uptime = fDesc:read("*n")
        fDesc:close()

        if uptime then
            vline:add(BGC "CCCCCC", FGC "000000", function()
                if uptime < 60 then     --  Under a minute.
                    if WID >= 210 and vline.utf8 then
                        return " 💡 ", math.floor(uptime), "s"
                    elseif WID >= 100 then
                        return " ", math.floor(uptime), UNIC "s 💡 |s U "
                    else
                        return math.floor(uptime), "s"
                    end
                elseif uptime < 3600 then   --  Under an hour.
                    if WID >= 210 and vline.utf8 then
                        return " 💡 ", math.floor(uptime / 60), "m"
                    elseif WID >= 100 then
                        return " ", math.floor(uptime / 60), UNIC "m 💡 |m U "
                    else
                        return math.floor(uptime / 60), "m"
                    end
                elseif uptime < 86400 then  --  Under a day.
                    if WID >= 210 and vline.utf8 then
                        return " 💡 ", math.floor(uptime / 3600), "h ", FGC "666666", math.floor((uptime / 60) % 60), "m "
                    elseif WID >= 100 then
                        return " ", math.floor(uptime / 3600), "h ", FGC "666666", math.floor((uptime / 60) % 60), UNIC "m 💡 |m U "
                    elseif WID >= 70 then
                        return math.floor(uptime / 3600), "h", FGC "666666", math.floor((uptime / 60) % 60), UNIC "m💡|mU"
                    else
                        return math.floor(uptime / 3600), "h"
                    end
                else    --  Over a day.
                    if WID >= 210 and vline.utf8 then
                        return " 💡 ", math.floor(uptime / 86400), "d ", FGC "666666", math.floor((uptime / 3600) % 24), "h "
                    elseif WID >= 100 then
                        return " ", math.floor(uptime / 86400), "d ", FGC "666666", math.floor((uptime / 3600) % 24), UNIC "h 💡 |h U "
                    elseif WID >= 70 then
                        return math.floor(uptime / 86400), "d", FGC "666666", math.floor((uptime / 3600) % 24), UNIC "h💡|hU"
                    else
                        return math.floor(uptime / 86400), "d"
                    end
                end
            end)
        end
    end
end

if settings.show_memory then
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

        vline:add(BGC "22AA00", FGC "EEEEEE", function()
            if WID >= 210 and vline.utf8 then
                return "📕 ", math.floor(100 * avl / total), "%/", BytesToHuman(total, 2, 9), " "
            elseif WID >= 150 then
                return " ", math.floor(100 * avl / total), "%/", BytesToHuman(total, 2, 9), UNIC " 📕 | M "
            elseif WID >= 120 then
                return " ", math.floor(100 * avl / total), "%/", BytesToHuman(total, 2), UNIC " 📕 | M "
            elseif WID >= 100 then
                return " ", math.floor(100 * avl / total), "%/", BytesToHuman(total, 0), UNIC " 📕 | M "
            elseif WID >= 80 then
                return math.floor(100 * avl / total), "%", BytesToHuman(total, 0), UNIC "📕|M"
            elseif WID >= 50 or not vline.utf8 then
                return math.floor(100 * avl / total), UNIC "%📕|%M"
            else
                return vline.get_bar(avl / total), "📕"
            end
        end)
    end)
end

if settings.show_load then
    local fDesc, fErr = io.open("/proc/loadavg", "r")

    if fDesc then
        local one = fDesc:read("*n")
        fDesc:close()

        if one then
            vline:add(BGC "444488", FGC "EEEEEE", (function()
                if vline.utf8 then
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
                else
                    if WID >= 100 then
                        return string.format(" %.2fL ", one)
                    elseif WID >= 80 then
                        return string.format("%.2fL", one)
                    elseif one < 10 then
                        return string.format("%.1fL", one)
                    else
                        return string.format("%dL", math.floor(one))
                    end
                end
            end)())
        end
    end
end

if settings.show_containers then
    vline.cache("docker", 60, function()
        local fDesc = io.popen([[echo -n "$(docker ps -q | wc -l)" "$(docker ps -aq | wc -l )"]])

        local dat = fDesc:read "*a"

        local res, reason, status = fDesc:close()

        if res and status == 0 then
            return dat
        else
            return "0\t0"
        end
    end, function(dat, new)
        local act, tot = dat:match "^(%d+)%s+(%d+)$"
        act, tot = tonumber(act), tonumber(tot)

        if not act or not tot or tot == 0 then
            return  --  No data, invalid data, or simply no VMs.
        end

        local bgc, fgc = BGC "0DB7ED", FGC "384D54"

        if WID >= 210 then
            vline:add(bgc, fgc, UNIC " 📦 | ", act, "/", tot," CTs ")
        elseif WID >= 120 then
            vline:add(bgc, fgc, " ", act, "/", tot, UNIC " 📦 | CTs ")
        elseif WID >= 100 then
            vline:add(bgc, fgc, " ", act, "/", tot, UNIC " 📦 |C ")
        else
            vline:add(bgc, fgc, act, "/", tot, UNIC "📦|C")
        end
    end)
end

if settings.show_vms then
    vline.cache("virsh", 60, function()
        local fDesc = io.popen([[echo -n "$(virsh list --name | grep -E '.+' | wc -l)" "$(virsh list --name --all | grep -E '.+' | wc -l )"]])

        local dat = fDesc:read "*a"

        local res, reason, status = fDesc:close()

        if res and status == 0 then
            return dat
        else
            return "0\t0"
        end
    end, function(dat, new)
        local act, tot = dat:match "^(%d+)%s+(%d+)$"
        act, tot = tonumber(act), tonumber(tot)

        if not act or not tot or tot == 0 then
            return  --  No data, invalid data, or simply no VMs.
        end

        local bgc, fgc = BGC "AAAAEE", FGC "000000"

        if WID >= 210 then
            vline:add(bgc, fgc, UNIC " 🖧 | ", act, "/", tot, " VMs ")
        elseif WID >= 120 then
            vline:add(bgc, fgc, " ", act, "/", tot, UNIC " 🖧 | VMs ")
        elseif WID >= 100 then
            vline:add(bgc, fgc, " ", act, "/", tot, UNIC " 🖧 |V ")
        else
            vline:add(bgc, fgc, act, "/", tot, UNIC "🖧|V")
        end
    end)
end

if settings.show_apt_updates then
    vline.cache("apt-updates", 120, function()
        local fDesc = io.popen("/usr/lib/update-notifier/apt-check 2>&1")

        local dat = fDesc:read "*a"

        local res, reason, status = fDesc:close()

        if res and status == 0 then
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

        local bgc, fgc = BGC "CC9900", FGC "000000"

        if WID >= 210 and vline.utf8 then
            if us > 0 then
                vline:add(bgc, fgc, " 📡 ", us, "/", ut, " ⚠ ")
            else
                vline:add(bgc, fgc, " 📡 ", ut, "! ")
            end
        elseif WID >= 120 then
            if us > 0 then
                vline:add(bgc, fgc, " ", us, "/", ut, UNIC " ⚠ | !! ")
            else
                vline:add(bgc, fgc, " ", ut, "! ")
            end
        elseif WID >= 100 then
            if us > 0 then
                vline:add(bgc, fgc, " ", ut, UNIC " ⚠ | !! ")
            else
                vline:add(bgc, fgc, " ", ut, "! ")
            end
        else
            if us > 0 then
                vline:add(bgc, fgc, ut, UNIC "⚠|!!")
            else
                vline:add(bgc, fgc, ut, "!")
            end
        end
    end)
end

if settings.show_restart then
    local fDesc, fErr = io.open("/var/run/reboot-required", "r")

    if fDesc then
        fDesc:close()

        local bgc, fgc = BGC "EF0000", FGC "000000"

        if WID >= 100 then
            vline:add(bgc, fgc, UNIC " ⥁ | R ")
        else
            vline:add(bgc, fgc, UNIC "⥁|R")
        end
    end
end

return vline:print_tmux()

