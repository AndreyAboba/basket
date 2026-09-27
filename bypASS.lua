-- Cold War client AC bypass. FirstLoad only: no UI, no Drawing, no game hooks.
-- New PlayerModule: raw C FireServer (not namecall), remote names via string.char,
-- g-scan of PlayerGui+CoreGui, MovementPing cadence (debug.info timing).
-- Snapshot image ids BEFORE MacLib:Window. Loader must run this chunk first.
-- AC captures Instance.new("RemoteEvent").FireServer in an upvalue BEFORE any
-- namecall. hookmetamethod never sees those sends. Marker is settleFocus:
-- step counts 9/13/17/21/25 + timeout 300. Do not require byte 102.

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
    uv = false,
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
    local ok = pcall(hookfunction, fn, wrapped)
    return ok == true
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
    for i = 1, 64 do
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

local fireOrig
local wrapFire

local function on_fire(orig, self, ...)
    local call = orig or fireOrig
    if not call then
        return
    end
    if is_hint(self) then
        local code, text = ...
        if code == "g" then
            local kept = filter_g(text)
            if not kept then
                return
            end
            return call(self, "g", kept)
        end
        if code == "f" or code == "s" or code == "b" or code == "a" or code == "c" then
            return
        end
        return call(self, ...)
    end
    if is_ping(self) then
        local payload = ...
        if type(payload) == "string" then
            return call(self, sanitize_cadence(payload))
        end
        return call(self, ...)
    end
    for i = 1, #sendFilters do
        local act, a, b, c, d = sendFilters[i](self, ...)
        if act == false then
            return
        end
        if act == true then
            return call(self, a, b, c, d)
        end
    end
    return call(self, ...)
end

local function lua_fire(self, ...)
    return on_fire(fireOrig, self, ...)
end

local function ensure_wrap()
    if wrapFire then
        return wrapFire
    end
    wrapFire = newcclosure(lua_fire, "FireServer")
    setstackhidden(wrapFire, true)
    api.wrapFire = wrapFire
    return wrapFire
end

local function capture_fs()
    if type(api.rawFire) == "function" then
        return api.rawFire
    end
    local tmp = Instance.new("RemoteEvent")
    local fs = tmp.FireServer
    tmp:Destroy()
    api.rawFire = fs
    return fs
end

local function hook_c_fire()
    local fs = capture_fs()
    if type(fs) ~= "function" then
        return false
    end
    if fireOrig and api.fire then
        return true
    end
    ensure_wrap()
    if oth and type(oth.hook) == "function" then
        local ok, hooked = pcall(oth.hook, fs, lua_fire)
        if ok and type(hooked) == "function" then
            fireOrig = hooked
            api.fireOrig = hooked
            api.fire = true
            return true
        end
    end
    if type(hookfunction) == "function" then
        local ok, hooked = pcall(hookfunction, fs, wrapFire)
        if ok and type(hooked) == "function" then
            fireOrig = hooked
            api.fireOrig = hooked
            api.fire = true
            return true
        end
        if ok then
            fireOrig = hooked or fs
            api.fireOrig = fireOrig
            api.fire = true
            return true
        end
    end
    return api.fire == true
end

local function hook_namecall()
    if api.namecall then
        return true
    end
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

-- settleFocus: 9/13/17/21/25 + timeout 300. lensSteps has the steps without 300.
-- Byte 102 is decompiler-lowered 'f'; do not require it.
local function is_marker(fn)
    local list = consts_of(fn)
    if not list then
        return false
    end
    return has_const(list, 300)
        and has_const(list, 9)
        and has_const(list, 13)
        and has_const(list, 17)
        and has_const(list, 21)
        and has_const(list, 25)
end

local function is_lens(fn)
    local list = consts_of(fn)
    return has_const(list, 110472940702397) or has_const(list, "rbxassetid://%d")
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

local function find_player_module()
    local function named(inst)
        return inst and inst.Name == "PlayerModule" and inst:IsA("ModuleScript")
    end
    if LP then
        local ps = LP:FindFirstChild("PlayerScripts")
        if ps then
            local m = ps:FindFirstChild("PlayerModule")
            if named(m) then
                return cloneref(m)
            end
        end
    end
    if type(getloadedmodules) == "function" then
        local ok, mods = pcall(getloadedmodules)
        if ok and type(mods) == "table" then
            for i = 1, #mods do
                if named(mods[i]) then
                    return cloneref(mods[i])
                end
            end
        end
    end
    if type(getnilinstances) == "function" then
        local ok, insts = pcall(getnilinstances)
        if ok and type(insts) == "table" then
            for i = 1, #insts do
                if named(insts[i]) then
                    return cloneref(insts[i])
                end
            end
        end
    end
    return nil
end

local function is_raw_fs(val)
    if type(val) ~= "function" then
        return false
    end
    if wrapFire and rawequal(val, wrapFire) then
        return false
    end
    return rawequal(val, api.rawFire) or rawequal(val, fireOrig)
end

local function patch_fs_upvalues(fn)
    if type(fn) ~= "function" then
        return
    end
    ensure_wrap()
    if debug.getupvalues then
        local ok, uvs = pcall(debug.getupvalues, fn)
        if ok and type(uvs) == "table" then
            for i, val in uvs do
                if is_raw_fs(val) then
                    if pcall(debug.setupvalue, fn, i, wrapFire) then
                        api.uv = true
                        api.fire = true
                    end
                end
            end
            return
        end
    end
    if not debug.getupvalue or not debug.setupvalue then
        return
    end
    for i = 1, 16 do
        local ok, a, b = pcall(function()
            return debug.getupvalue(fn, i)
        end)
        if not ok then
            break
        end
        local val = a
        if type(b) == "function" then
            val = b
        end
        if is_raw_fs(val) then
            if pcall(debug.setupvalue, fn, i, wrapFire) then
                api.uv = true
                api.fire = true
            end
        elseif a == nil and b == nil then
            break
        end
    end
end

local function each_live_proto(fn, visit, depth, seen)
    if type(fn) ~= "function" or depth > 10 then
        return
    end
    seen = seen or {}
    if seen[fn] then
        return
    end
    seen[fn] = true
    visit(fn)
    if type(debug.getproto) ~= "function" then
        return
    end
    for i = 1, 40 do
        local ok, proto = pcall(debug.getproto, fn, i, true)
        if not ok then
            break
        end
        if type(proto) == "table" then
            for j = 1, #proto do
                each_live_proto(proto[j], visit, depth + 1, seen)
            end
        elseif type(proto) == "function" then
            each_live_proto(proto, visit, depth + 1, seen)
        end
    end
end

local function visit_ac_fn(fn)
    if type(fn) ~= "function" then
        return
    end
    if isexecutorclosure and isexecutorclosure(fn) then
        return
    end
    patch_fs_upvalues(fn)
    if not api.anim and is_lens(fn) then
        api.anim = hook_fn(fn, newcclosure(function() end, "LoadAnimation")) or api.anim
    end
    if not api.mark and is_marker(fn) then
        api.mark = hook_fn(fn, newcclosure(function() end, "EquipTool")) or api.mark
    end
end

local gcTries = 0
local luaTicks = 0

local function hook_lua_side()
    luaTicks += 1
    if not api.anim then
        local anim = find_fn({ 110472940702397 })
        if anim then
            api.anim = hook_fn(anim, newcclosure(function() end, "LoadAnimation")) or api.anim
        end
    end
    if not api.mark then
        local okL, list
        if type(filtergc) == "function" then
            okL, list = pcall(filtergc, "function", { IgnoreExecutor = true, Constants = { 300, 9, 13, 17 } }, false)
        end
        if okL and type(list) == "function" and is_marker(list) then
            api.mark = hook_fn(list, newcclosure(function() end, "EquipTool")) or api.mark
        elseif okL and type(list) == "table" then
            for _, obj in list do
                if type(obj) == "function" and is_marker(obj) then
                    api.mark = hook_fn(obj, newcclosure(function() end, "EquipTool")) or api.mark
                    break
                end
            end
        end
    end

    local pm = find_player_module()
    if pm and type(getscriptclosure) == "function" then
        local okC, closure = pcall(getscriptclosure, pm)
        if okC and type(closure) == "function" then
            each_live_proto(closure, visit_ac_fn, 0)
        end
    end

    -- getgc is heavy. At most twice: when PlayerModule exists, or after ~1s if it was deleted.
    if (not api.anim or not api.mark or not api.uv) and gcTries < 2 and type(getgc) == "function" then
        if pm or luaTicks >= 4 then
            gcTries += 1
            local okG, objs = pcall(getgc)
            if okG and type(objs) == "table" then
                for _, obj in objs do
                    if type(obj) == "function" then
                        visit_ac_fn(obj)
                        if api.anim and api.mark and api.uv then
                            break
                        end
                    end
                end
            end
        end
    end
end

local function finish()
    -- namecall is NOT the AC upload path. C FireServer + upvalue patch is.
    local reports = api.fire
    local animOk = api.anim or api.namecall
    if reports and animOk and api.mark and not api.announced then
        api.announced = true
        print("AC Bypass enabled")
        print("AC bypass - init")
    end
    if reports and animOk and api.mark then
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
        for _ = 1, 60 do
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
                "[CWCombat] ac bypass incomplete upload=%d fire=%d namecall=%d anim=%d mark=%d uv=%d",
                api.fire and 1 or 0,
                api.fire and 1 or 0,
                api.namecall and 1 or 0,
                (api.anim or api.namecall) and 1 or 0,
                api.mark and 1 or 0,
                api.uv and 1 or 0
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
