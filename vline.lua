local vline = {
    time = os.time(),
    utf8 = not not (os.getenv("LANG") or ""):upper():gsub("[%s%-]", ""):find("UTF8"),
    right = true,
    id = false,
}

local segs = {}
local _special_bgc, _special_fgc, _special_attr = {}, {}, {}

_G.vline = setmetatable({}, {
    __index = vline,

    __newindex = function() error("Do not modify this table directly.") end,
    __metatable = "Nawpe.",
})

function vline:set_utf8(val)
    if type(val) ~= "boolean" then
        error("UTF8 must be a boolean.")
    end

    vline.utf8 = val
end

function vline:set_id(num)
    if type(num) ~= "number" or num < 0 or num % 1 ~= 0 then
        error("ID must be a positive integer.")
    end

    if vline.id then
        error("ID was already set to " .. vline.id)
    end

    vline.id = num
end

function vline:add(...)
    local dat, res = {...}, {}

    local function expandArr(dat, res)
        for i = 1, #dat do
            local d = dat[i]
            local dType = type(d)

            if dType == "table" then
                if d[_special_bgc] then
                    if not res.FirstColor then
                        res.FirstColor = d[_special_bgc]
                    end

                    res.LastColor = d[_special_bgc]

                    res[#res + 1] = d
                elseif d[_special_fgc] or d[_special_attr] then
                    res[#res + 1] = d
                else
                    expandArr(d, res)
                end
            elseif dType == "string" or dType == "number" or dType == "boolean" then
                if not res.FirstColor then
                    error("Segment must specify a background color before any text/numbers.")
                end

                res[#res + 1] = d
            elseif dType == "function" then
                expandArr({ d() }, res)
            end
        end
    end

    expandArr(dat, res)

    if #res > 1 then
        if not res.FirstColor then
            error("Segment needs at least one background color.")
        end

        segs[#segs + 1] = res

        return true
    else
        return false
    end
end

---------------------------------------------------------------------
--  Rendering

function vline:expand()
    if #segs == 0 then
        error("No segments to print.")
    end

    local res, lastCol = { }, "default"

    for i = (self.right and #segs or 1), (self.right and 1 or #segs), (self.right and -1 or 1) do
        if self.right then
            res[#res + 1] = FGC(segs[i].FirstColor)
            res[#res + 1] = ""
            res[#res + 1] = FGC "default"
        elseif i > 1 then
            res[#res + 1] = FGC(lastCol)
            res[#res + 1] = BGC(segs[i].FirstColor)
            res[#res + 1] = ""
            res[#res + 1] = FGC "default"
        end

        for j = 1, #segs[i] do
            local e = segs[i][j]
            local eType = type(e)

            if eType == "string" then
                res[#res + 1] = e
            elseif eType == "table" then
                res[#res + 1] = e

                if not self.right and e[_special_bgc] then
                    lastCol = e[_special_bgc]
                end
            else
                res[#res + 1] = tostring(e)
            end
        end
    end

    if not self.right then
        res[#res + 1] = FGC(segs[#segs].LastColor)
        res[#res + 1] = BGC "default"
        res[#res + 1] = ""
    end

    return res
end

function vline:print_tmux(left)
    vline.right = not left

    local res = self:expand()

    local attribsChanged, attr, bgc, fgc = false

    local function setAttr(val) attribsChanged = attr ~= val; attr = val end
    local function setBgc(val) local _bgc = val == 'default' and val or ('#' .. val); attribsChanged = _bgc ~= bgc; bgc = _bgc end
    local function setFgc(val) local _fgc = val == "default" and val or ('#' .. val); attribsChanged = _fgc ~= fgc; fgc = _fgc end

    local function dumpattr()
        attribsChanged = false

        if attr then
            if bgc then
                if fgc then
                    io.write(string.format("#[%s,fg=%s,bg=%s]", attr, fgc, bgc))
                else
                    io.write(string.format("#[%s,bg=%s]", attr, bgc))
                end
            else
                if fgc then
                    io.write(string.format("#[%s,fg=%s]", attr, fgc))
                else
                    io.write(string.format("#[%s]", attr))
                end
            end
        else
            if bgc then
                if fgc then
                    io.write(string.format("#[fg=%s,bg=%s]", fgc, bgc))
                else
                    io.write(string.format("#[bg=%s]", bgc))
                end
            else
                if fgc then
                    io.write(string.format("#[fg=%s]", fgc))
                else
                    error "whut?"
                end
            end
        end

        attr = nil
    end

    if self.right then io.write " " end

    for i = 1, #res do
        local e = res[i]
        local eType = type(e)

        if eType == "table" then
            if e[_special_bgc] then
                setBgc(e[_special_bgc])
            elseif e[_special_fgc] then
                setFgc(e[_special_fgc])
            elseif e[_special_attr] then
                if e == B then
                    setAttr("bold")
                elseif e == I then
                    setAttr("italics")
                elseif e == U then
                    setAttr("underscore")
                else
                    setAttr("default")
                end
            end
        else
            if attribsChanged then
                dumpattr()
            end

            io.write(e)
        end
    end

    if not self.right then io.write " " end

    return 0
end

---------------------------------------------------------------------
--  Utilities

function BGC(col)
    if type(col) ~= "string" or (#col ~= 6 and col ~= "default") then
        error("Background color must be a string consisting of 6 hexadecimal characters, or 'default'; not '" .. col .. "'.")
    end

    return { [_special_bgc] = col }
end

function FGC(col)
    if type(col) ~= "string" or (#col ~= 6 and col ~= "default") then
        error("Foreground color must be a string consisting of 6 hexadecimal characters, or 'default'; not '" .. col .. "'.")
    end

    return { [_special_fgc] = col }
end

B     = { [_special_attr]  = true }
I     = { [_special_attr]  = true }
U     = { [_special_attr]  = true }
DEF   = { [_special_attr]  = true }

ARW_R = ""
ARW_L = ""

function UNIC(a, b)
    if type(a) ~= "string" then
        error("Unicode alternative must be a string.")
    end

    if b ~= nil then
        if type(b) ~= "string" then
            error("Non-unicode alternative must be a string.")
        end

        if vline.utf8 then
            return a
        else
            return b
        end
    else
        --  Means both alternatives are in the main string.

        local sep = a:find("|", 1, true)

        if not sep then
            error("Unicode alternative must contain a '|' to separate the unicode-enabled string on the left from the non-unicode string on the right. Alternatively, call the function with two arguments.")
        end

        if vline.utf8 then
            return a:sub(1, sep - 1)
        else
            return a:sub(sep + 1)
        end
    end
end

---------------------------------------------------------------------
--  Numeric Utilities

function NumberToString(val)
    val = tostring(math.floor(val))
    local changes

    repeat
        val, changes = val:gsub("^(%-?%d+)(%d%d%d)", "%1,%2")
    until changes == 0

    return val
end

local magnitudes1000, magnitudes1024 =
{ "B", "k"  , "M"  , "G"  , "T"  , "P"  , "E"  , "Z"  , "Y"   },
{ "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB" }

function BytesToHuman(val, size, threshold)
    local magn = 1

    if size == 0 then
        while val >= (threshold or 1) * 1000 do magn = magn + 1; val = val / 1000 end
        if val >= 10 then val = NumberToString(val) else val = tostring(val):sub(1, 3) end

        return val .. magnitudes1000[magn]
    else
        while val >= (threshold or 1) * 1024 do magn = magn + 1; val = val / 1024 end
        if val >= 10 then val = NumberToString(val) else val = tostring(val):sub(1, 3) end

        return val .. magnitudes1024[magn]
    end
end

---------------------------------------------------------------------
--  Bars

local barsV = { [0] = " ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
local barsH = { [0] = " ", "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }

function vline.get_bar(val, horizontal)
    return (horizontal and barsH or barsV)[math.floor(val * 8)]
end

function vline.get_barh(val)
    return barsH[math.floor(val * 8)]
end

function vline.get_barv(val)
    return barsV[math.floor(val * 8)]
end

---------------------------------------------------------------------
--  Clocks

local clocks = { [0] = "🕛", "🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚" }

function vline.get_clock(val)
    if val == nil then
        val = tonumber(os.date("%H", vline.time))
    end

    return clocks[math.floor(val) % 12]
end

---------------------------------------------------------------------
--  Numbers

local numsD = { [0] = '0', '⒈', '⒉', '⒊', '⒋', '⒌', '⒍', '⒎', '⒏', '⒐', '⒑', '⒒', '⒓', '⒔', '⒕', '⒖', '⒗', '⒘', '⒙', '⒚', '⒛', }
local numsP = { [0] = '0', '⑴', '⑵', '⑶', '⑷', '⑸', '⑹', '⑺', '⑻', '⑼', '⑽', '⑾', '⑿', '⒀', '⒁', '⒂', '⒃', '⒄', '⒅', '⒆', '⒇' }

function vline.get_number_dot(val)
    return numsD[math.floor(val)]
end

function vline.get_number_paren(val)
    return numsP[math.floor(val)]
end

---------------------------------------------------------------------
--  Data Caching

local cache_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"

function vline.cache(name, timeout, producer, consumer)
    local fName = cache_dir .. "/vline.cache." .. name .. "." .. (vline.id or "anon")

    local fDesc, fErr = io.open(fName, "r")

    if fDesc then
        local lastTime, _, rest = fDesc:read("*n", "*l", "*a")
        fDesc:close()

        if lastTime and vline.time - lastTime < timeout then
            if consumer then
                return consumer(rest, false)
            else
                return rest, false
            end
        end

        --  It could've failed to read the last time, for some reason...
    end

    --  Doesn't exist? Then this can pass.

    fDesc, fErr = io.open(fName, "w+")

    if not fDesc then
        error(fErr)
    end

    fDesc, fErr = fDesc:write(vline.time, "\n")

    if not fDesc then
        error(fErr)
    end

    fDesc:flush()   --  Need this to solve some synchronization issues that might occur when
    --  viciously spamming a command.

    local rest = producer()

    fDesc, fErr = fDesc:write(rest)

    if not fDesc then
        error(fErr)
    end

    fDesc:close()

    if consumer then
        return consumer(rest, true)
    else
        return rest, true
    end
end

---------------------------------------------------------------------
--  Logging

local log_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"

function vline.log(...)
    local dat, res = {...}, { os.date "[%Y-%m-%d %H:%M:%S] " }

    local function expandArr(dat, res)
        for i = 1, #dat do
            local e = dat[i]
            local eType = type(e)

            if eType == "function" then
                e = e()
                eType = type(e)
            end

            if eType == "table" then
                expandArr(e, res)
            elseif eType == "number" or eType == "boolean" then
                res[#res + 1] = tostring(e)
            elseif eType == "string" then
                res[#res + 1] = e
            else
                error("Only numbers, booleans, strings and arrays allowed. Functions that return one of those are also allowed.")
            end
        end
    end

    expandArr(dat, res)

    if res[#res]:sub(-1) ~= "\n" then
        res[#res + 1] = "\n"
    end

    local fDesc, fErr = io.open(log_dir .. "/vline.log." .. (vline.id or "anon"), "a")

    if not fDesc then
        error("Failed to open log file: " .. fErr, 2)
    end

    for i = 1, #res do
        fDesc, fErr = fDesc:write(res[i])
    end

    fDesc:close()
end

return _G.vline

