-- Cold War client AC bypass. FirstLoad only: no UI, no Drawing, no game hooks.
-- New PlayerModule: raw C FireServer (not namecall), remote names via string.char,
-- g-scan of PlayerGui+CoreGui, MovementPing cadence (debug.info timing).
-- Snapshot image ids BEFORE MacLib:Window. Loader must run this chunk first.

local cloneref = cloneref or function(x)
    return x
end
local newcclosure = newcclosure or function(f)
    return f
end
local setstackhidden = setstackhidden or function() end
local getnamecallmethod = getnamecallmethod or function()
    return ""
end

local genv = (type(getgenv) == "function" and getgenv()) or _G
if type(genv) == "table" and type(genv.CWAcBypass) == "table" and genv.CWAcBypass.done then
    return genv.CWAcBypass
end

local Players = cloneref(game:GetService("Players"))
local LP = Players.LocalPlayer

local LENS_ID = "110472940702397"
local api = {
    done = false,
    fire = false,
    namecall = false,
    anim = false,
    mark = false,
    allow = {},
}
if type(genv) == "table" then
    genv.CWAcBypass = api
end

local function hook_fn(fn, wrapped)
    if type(fn) ~= "function" then
        return false
    end
    if isfunctionhooked and isfunctionhooked(fn) then
        return true
    end
    setstackhidden(wrapped, true)
    if type(hookfunction) ~= "function" then
        return false
    end
    return pcall(hookfunction, fn, wrapped) == true
end

local function consts_of(fn)
    if type(fn) ~= "function" then
        return nil
    end
    if debug.getconstants then
        local ok, list = pcall(debug.getconstants, fn)
        if ok and type(list) == "table" then
            return list
        end
    end
    if not debug.getconstant then
        return nil
    end
    local list = {}
    for i = 1, 48 do
        local ok, v = pcall(debug.getconstant, fn, i)
        if not ok then
            break
        end
        list[i] = v
    end
    return list
end

local function has_const(list, want)
    if not list then
        return false
    end
    for _, v in list do
        if v == want then
            return true
        end
    end
    return false
end

local function snapshot()
    local allow = api.allow
    local function pull(root)
        if not root then
            return
        end
        local desc = root:GetDescendants()
        for i = 1, #desc do
            local d = desc[i]
            local img
            if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                img = d.Image
            elseif d:IsA("Decal") then
                img = d.Texture
            end
            if type(img) == "string" then
                local id = string.match(img, "%d+")
                if id then
                    allow[id] = true
                end
            end
        end
    end
    pull(LP and LP:FindFirstChild("PlayerGui"))
    pcall(pull, game:GetService("CoreGui"))
end

local function filter_g(text)
    if type(text) ~= "string" or text == "" then
        return nil
    end
    local allow = api.allow
    local n = 0
    local out = {}
    for id in string.gmatch(text, "%d+") do
        if allow[id] then
            n += 1
            out[n] = id
        end
    end
    if n == 0 then
        return nil
    end
    return table.concat(out, ",")
end

-- MovementPing payload: samples,spikes,maxStreak,p50,p90,max,clipTicks
-- ratio > 22.5 is their debug.info hook fingerprint. Do not drop the ping.
local function sanitize_cadence(s)
    local a, b, c, d, e, f, g = string.match(s, "^(%d+),(%d+),(%d+),([%d%.]+),([%d%.]+),([%d%.]+),(%d+)$")
    if not a then
        return s
    end
    local spikes = tonumber(b)
    local p50 = tonumber(d)
    local p90 = tonumber(e)
    local mx = tonumber(f)
    if not (spikes and p50 and p90 and mx) then
        return s
    end
    if spikes <= 0 and p90 <= 22.5 then
        return s
    end
    if p50 > 18 then
        p50 = 12
    end
    if p90 > 20 then
        p90 = 14
    end
    if mx > 21 then
        mx = 16
    end
    return string.format("%d,%d,%d,%.1f,%.1f,%.1f,%d", tonumber(a), 0, 0, p50, p90, mx, tonumber(g))
end

local function is_hint(self)
    return typeof(self) == "Instance" and self.ClassName == "RemoteEvent" and self.Name == "StreamingHint"
end

local function is_ping(self)
    return typeof(self) == "Instance" and self.ClassName == "RemoteEvent" and self.Name == "MovementPing"
end

local function lens_anim(anim)
    if typeof(anim) ~= "Instance" then
        return false
    end
    local id = anim.AnimationId
    return type(id) == "string" and string.find(id, LENS_ID, 1, true) ~= nil
end

local sendFilters = {}

function api.on_send(fn)
    if type(fn) == "function" then
        sendFilters[#sendFilters + 1] = fn
    end
end

local function on_fire(orig, self, ...)
    if is_hint(self) then
        local code, text = ...
        if code == "g" then
            local kept = filter_g(text)
            if not kept then
                return
            end
            return orig(self, "g", kept)
        end
        if code == "f" or code == "s" or code == "b" or code == "a" or code == "c" then
            return
        end
        return orig(self, ...)
    end
    if is_ping(self) then
        local payload = ...
        if type(payload) == "string" then
            return orig(self, sanitize_cadence(payload))
        end
        return orig(self, ...)
    end
    for i = 1, #sendFilters do
        local act, a, b, c, d = sendFilters[i](self, ...)
        if act == false then
            return
        end
        if act == true then
            return orig(self, a, b, c, d)
        end
    end
    return orig(self, ...)
end

local function hook_c_fire()
    local tmp = Instance.new("RemoteEvent")
    local fs = tmp.FireServer
    tmp:Destroy()
    if type(fs) ~= "function" then
        return false
    end
    if isfunctionhooked and isfunctionhooked(fs) then
        api.fire = true
        return true
    end
    local orig
    local wrapped = newcclosure(function(self, ...)
        return on_fire(orig, self, ...)
    end, "FireServer")
    setstackhidden(wrapped, true)
    if oth and type(oth.hook) == "function" then
        local ok, hooked = pcall(oth.hook, fs, wrapped)
        if ok and type(hooked) == "function" then
            orig = hooked
            api.fire = true
            return true
        end
    end
    if type(hookfunction) == "function" then
        local ok, hooked = pcall(hookfunction, fs, wrapped)
        if ok and type(hooked) == "function" then
            orig = hooked
            api.fire = true
            return true
        end
        if ok then
            orig = hooked or fs
            api.fire = true
            return true
        end
    end
    return false
end

local function hook_namecall()
    if type(hookmetamethod) ~= "function" then
        return false
    end
    local orig
    local wrapped = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" then
            return on_fire(orig, self, ...)
        end
        if method == "LoadAnimation" then
            local anim = ...
            if lens_anim(anim) then
                return
            end
        end
        return orig(self, ...)
    end, "Namecall")
    setstackhidden(wrapped, true)
    local ok, hooked = pcall(hookmetamethod, game, "__namecall", wrapped)
    if not ok or type(hooked) ~= "function" then
        return false
    end
    orig = hooked
    api.namecall = true
    return true
end

-- New marker inlines string.byte('f'/'s'/'b'/'c'/'a') + step counts + timeout 300.
-- Old {f=9,s=13,b=17,a=25} table is gone.
local function is_marker(fn)
    local list = consts_of(fn)
    if not list then
        return false
    end
    return has_const(list, 300) and has_const(list, 102) and has_const(list, 9) and has_const(list, 13)
end

local function find_fn(constants)
    if type(filtergc) ~= "function" then
        return nil
    end
    local ok, res = pcall(filtergc, "function", { IgnoreExecutor = true, Constants = constants }, false)
    if not ok then
        return nil
    end
    if type(res) == "function" then
        return res
    end
    if type(res) == "table" then
        for _, obj in res do
            if type(obj) == "function" then
                return obj
            end
        end
    end
    return nil
end

local function hook_lua_side()
    local anim = find_fn({ 110472940702397 })
    if anim then
        api.anim = hook_fn(anim, newcclosure(function() end, "LoadAnimation")) or api.anim
    end
    local mark = nil
    if type(filtergc) == "function" then
        local okL, list = pcall(filtergc, "function", { IgnoreExecutor = true, Constants = { 300, 102 } }, false)
        if okL and type(list) == "function" and is_marker(list) then
            mark = list
        elseif okL and type(list) == "table" then
            for _, obj in list do
                if type(obj) == "function" and is_marker(obj) then
                    mark = obj
                    break
                end
            end
        end
    end
    if mark then
        api.mark = hook_fn(mark, newcclosure(function() end, "EquipTool")) or api.mark
    end
    if (not api.anim or not api.mark) and type(getgc) == "function" then
        for _, obj in getgc() do
            if type(obj) == "function" and not (isexecutorclosure and isexecutorclosure(obj)) then
                local list = consts_of(obj)
                if not api.anim and (has_const(list, 110472940702397) or has_const(list, "rbxassetid://%d")) then
                    api.anim = hook_fn(obj, newcclosure(function() end, "LoadAnimation")) or api.anim
                end
                if not api.mark and is_marker(obj) then
                    api.mark = hook_fn(obj, newcclosure(function() end, "EquipTool")) or api.mark
                end
                if api.anim and api.mark then
                    break
                end
            end
        end
    end
end

local function finish()
    local reports = api.fire or api.namecall
    local animOk = api.namecall or api.anim
    local punish = api.mark
    if reports and animOk and not api.announced then
        api.announced = true
        print("AC Bypass enabled")
        print("AC bypass - init")
    end
    if reports and animOk and punish then
        api.done = true
        return true
    end
    return false
end

if LP then
    pcall(function()
        LP:WaitForChild("PlayerGui", 1)
    end)
end
snapshot()
hook_c_fire()
hook_namecall()
hook_lua_side()
if not finish() then
    task.spawn(function()
        for _ = 1, 40 do
            if api.done then
                return
            end
            task.wait(0.25)
            if not api.fire then
                hook_c_fire()
            end
            if not api.namecall then
                hook_namecall()
            end
            hook_lua_side()
            if finish() then
                return
            end
        end
        if not api.done then
            warn(string.format(
                "[CWCombat] ac bypass incomplete upload=%d anim=%d mark=%d",
                (api.fire or api.namecall) and 1 or 0,
                (api.namecall or api.anim) and 1 or 0,
                api.mark and 1 or 0
            ))
        end
    end)
end

if type(genv) == "table" then
    genv.CWAcBypass = api
end

return {
    Init = function() end,
}
