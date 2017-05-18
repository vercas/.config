#!/usr/bin/env lua

local settings = {
    hostname = os.getenv "HOSTNAME",
    refresh_rate = 1,

    show_date = true,
    show_time = true,

    show_uptime = true,
    show_memory = true,
    show_load = true,
    show_vms = true,
    show_apt_updates = true,
    show_restart = true,

    show_session = true,
    show_username = true,
    show_hostname = true,
    show_prefix = true,
}
_G.settings = settings

if not settings.hostname or #settings.hostname == 0 then
    --  Need to retrieve this...

    local fDesc, fErr = io.popen("hostname")

    if fDesc then
        settings.hostname = fDesc:read "*a"

        if not fDesc:close() then
            settings.hostname = nil
        end
    end
end

local fDesc, fErr = io.open(string.format("%s/.vmux.conf.lua", os.getenv "HOME"), "r")

if fDesc then
    local text = fDesc:read "*a"
    fDesc:close()

    loadstring(text, "~/.vmux.conf.lua")()
end

if arg and arg[0]:match "vmux-settings.lua$" and arg[1] then
    val = settings[arg[1]]

    io.open("/tmp/vmux.settings.log", "a"):write(arg[1]):write(": "):write(tostring(val)):write("\n"):close()

    if val then
        io.write(val)
        os.exit(0)
    else
        os.exit(1)
    end
end

return settings

