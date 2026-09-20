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

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))
local SoundService = cloneref(game:GetService("SoundService"))
local Debris = cloneref(game:GetService("Debris"))
local CollectionService = cloneref(game:GetService("CollectionService"))
local LP = Players.LocalPlayer
local Cam = Workspace.CurrentCamera
local clock = os.clock
local V3, V2 = Vector3.new, Vector2.new
local min, max, floor, huge = math.min, math.max, math.floor, math.huge
local pi, cos, sin, acos = math.pi, math.cos, math.sin, math.acos
local ZERO3 = V3(0, 0, 0)
local rnd = math.random
local function clamp(x, a, b)
    return math.clamp(x, a, b)
end

local CFG = {
    ESP = true,
    EspEnemyOnly = true,
    EspMaxDistance = 700,
    EspBox = true,
    EspBoxMode = "Corner",
    EspCornerScale = 0.28,
    EspBoxAspect = 0.62,
    EspBoxThickness = 1.6,
    EspShowName = true,
    EspShowDistance = true,
    EspShowWeapon = true,
    EspShowHotbar = true,
    EspHotbarRarityColor = false,
    EspShowStates = true,
    EspHpBar = true,
    EspSmooth = false,
    EspSmoothAlpha = 0.5,
    EspVisibleCheck = true,
    EspVisMaxDist = 900,
    EspTextSize = 14,
    EspColorVisible = Color3.fromRGB(70, 255, 90),
    EspColorHidden = Color3.fromRGB(255, 55, 55),
    EspColorName = Color3.fromRGB(235, 235, 245),
    EspColorDist = Color3.fromRGB(235, 235, 245),
    EspColorWeapon = Color3.fromRGB(255, 165, 60),
    EspColorState = Color3.fromRGB(120, 200, 255),
    EspNameUseTier = true,
    EspHpHigh = Color3.fromRGB(70, 255, 90),
    EspHpLow = Color3.fromRGB(255, 55, 55),

    Chams = false,
    ChamsEnemyOnly = true,
    ChamsMaxDistance = 700,
    ChamsVisMaxDist = 900,
    ChamsFillTrans = 0.55,
    ChamsOutline = true,
    ChamsOutlineTrans = 0.2,
    ChamsColorVisible = Color3.fromRGB(70, 255, 90),
    ChamsColorHidden = Color3.fromRGB(255, 55, 55),

    CustomZoom = false,
    CustomZoomMul = 2,
    WheelZoom = false,

    SilentAim = true,
    VisibleCheck = true,
    SilentAimFOV = 140,
    SilentAimMaxDist = 2000,
    AimBone = "Head",
    IgnoreTeammates = true,
    HitChance = 70,
    HeadChance = 50,
    LegitAim = true,
    LegitSpread = 0.35,
    LegitBoneJitter = 0.32,

    ForceHit = true,
    InstantHit = true,
    InstantHitMul = 2.4,
    SmartInstant = true,
    ForceHitDelay = 0,
    SmartInstantRefDist = 400,
    SmartInstantRefDelay = 0.08,
    SmartInstantMaxDelay = 0.9,
    ForceHitPart = "auto",
    ForceHitMargin = 2.5,
    AutoHeal = false,
    AutoHealRadius = 7,
    AutoRecon = false,

    MultiPoint = true,
    SpoofOrigin = true,
    OriginFromHRP = false,
    OriginBudget = 5,
    MPMaxOffset = 5,
    MPPreferFrac = 0.5,
    MPMaxDist = 500,
    MPMaxTargets = 1,
    VisCacheSec = 0.1,
    PickRate = 0.04,
    EspPerFrame = 40,
    NoRecoil = true,
    InstantEquip = true,
    EquipAnimSpeed = 8,
    FullAuto = true,
    NoSpread = true,
    GunPredict = true,
    GunPredictMul = 0.3,
    GunPredictVehicleMul = 0.5,
    InterpLead = 0.02,
    InterpLeadVehicle = 0.1,
    PredictMaxLead = 8,
    PredictMaxLeadVehicle = 48,
    PredictIgnoreWeapon = false,
    PredictFixedSpeed = 850,
    InstantAim = true,
    InstantReload = false,
    ReloadSprint = true,
    AlwaysAct = true,
    NoLimp = true,
    TurretSA = true,
    InstantSit = true,
    SitAnimSpeed = 8,
    VehicleStealer = false,
    VehicleStealHighlight = false,
    VehicleSpeed = true,
    VehicleSpeedMul = 2.2,
    StaffDetect = true,
    StaffKick = false,
    StaffNotify = true,
    StaffWarning = true,

    Speed = false,
    SpeedStuds = 42,
    Fly = false,
    FlySpeed = 52,
    NoClip = false,
    NoFall = true,

    FovCircle = true,
    ShowFOV = true,
    FovCircleColor = Color3.fromRGB(255, 255, 255),
    FOVColor = Color3.fromRGB(255, 255, 255),
    FovCircleThick = 1,
    FovCircleFilled = false,
    FovCircleTrans = 0.6,

    MuzzleVisual = true,
    MuzzleLineColor = Color3.fromRGB(80, 220, 255),
    MuzzleLineThick = 2.0,
    MuzzleLineTrans = 0.15,

    AimVisuals = true,
    AimVisualStyle = "Diamond",
    AimVisualScale = 1.0,
    AimVisualColor = nil,
    EspStateSize = 12,

    ShotTracers = true,
    TracerColor = Color3.fromRGB(255, 90, 35),
    TracerDuration = 1.4,
    TracerFadeIn = 0.12,
    TracerThickness = 0.9,

    HitParticles = true,
    HitParticleType = "Wireframe",
    HitParticleCount = 10,
    HitParticleDur = 1.1,
    HitParticleGrav = -32,
    HitParticleSpdMin = 2,
    HitParticleSpdMax = 32,
    HitParticleColorA = Color3.fromRGB(88, 165, 255),
    HitParticleColorB = Color3.fromRGB(165, 95, 255),
    HitParticleOpMin = 0.45,
    HitParticleOpMax = 1.0,
    HitParticleWireS = 0.4,
    HitParticleMaxSys = 2,

    HitSound = true,
    HitSoundPreset = "Fatality",
    HitSoundId = 115982072912004,
    HitSoundVolume = 3.5,
    HitSoundPitch = 1.0,

    Aimbot = false,
    AimbotFOV = 80,
    AimbotMaxDist = 800,
    AimbotSmooth = 8,
    AimbotShowFOV = true,
    AimbotFovColor = Color3.fromRGB(255, 180, 60),
    AimbotFovTrans = 0.55,
    AimbotFovThick = 1,
    AimbotAdsOnly = false,
    AimbotShootOnly = false,
    AimbotBone = "Head",
    AimbotPredict = true,
    AimbotPredictMul = 0.35,

    Crosshair = true,
    CrosshairHideAds = false,
    CrosshairSyncAim = false,
    CrosshairSyncPad = 8,
    CrosshairAim = false,
    CrosshairStyle = "Cross",
    CrosshairColor = Color3.fromRGB(255, 255, 255),
    CrosshairSize = 8,
    CrosshairGap = 3,
    CrosshairThick = 1.2,
    CrosshairTrans = 0.95,

    VmAim = false,
    VmX = 0,
    VmY = 0,
    VmZ = 0,
    VmPitch = 0,
    VmYaw = 0,
    VmRoll = 0,
    VmColorOn = false,
    VmColor = Color3.fromRGB(0, 200, 255),
    VmMatOn = false,
    VmMaterial = "ForceField",
    VmTransparency = 0,
    VmOutline = false,
    VmHlFill = Color3.fromRGB(90, 210, 255),
    VmHlOutline = Color3.fromRGB(190, 245, 255),
}

local ESPC = { LabelSize = 14, LineStep = 0.52, StackGap = 1 }
local F = {}
local connections = {}
local espByModel = {}
local visCache = {}
local hotbarCache = {}
local stateCache = {}
local speedCache = {}
local moveHint = {}
local lastShotAt = {}
local aimTrackOf = {}
local aimWatchChar = {}
local saTgt = nil
local origFireVolley = nil
local fireVolleyKey = nil
local origSendClaim = nil
local extraHooksInstalled = false
local extraHooks = {}
local recoilHooked = false
local ClientFire = nil
local HitReporter = nil
local ShotCodec = nil
local PlayerSlots = nil
local BallisticsNet = nil
local WeaponConfigManager = nil
local Trajectory = nil
local DILib = nil
local useDI = false
local AimCtrl = nil
local CamCtrl = nil
function F.apply_custom_zoom()
    if not CFG.CustomZoom then
        return
    end
    if not (CamCtrl and type(CamCtrl.setFOV) == "function") then
        return
    end
    local aiming = AimCtrl and type(AimCtrl.isAiming) == "function" and AimCtrl.isAiming()
    if aiming then
        pcall(CamCtrl.setFOV, CFG.CustomZoomMul or 1)
    end
end
local lastAbDt = 1 / 60
local vmSkin = nil
local abPickAt, abTgt = 0, nil
local claimedSeeds = {}
local lastShotFrom = nil
local lastVolleyAt = 0
local lastVolleySpeed = 900
local lastVolleyDrag = 0
local lastSupport = {
    at = 0,
    heal = nil,
    reconUntil = 0,
    reconHooked = false,
    medicRE = nil,
    binRE = nil,
}
local lastHitSoundAt = 0
local dirScratch = {}
local dirCount = 4
local roster = {}
local rosterN = 0
local enemyOf = {}
local charRefs = {}
local aliveFrame = 0
local vpX, vpY = 0, 0
local fovCache = { r = -1, vx = -1, vy = -1, fov = -1, sa = -1 }
local candPool = {}
for i = 1, 48 do
    candPool[i] = { player = nil, char = nil, bone = nil, pos = ZERO3, dist = 0 }
end
local saTgtBuf = {
    player = nil,
    pos = nil,
    claimPos = nil,
    bone = nil,
    origin = nil,
    spoof = nil,
    tier = 0,
    mode = "live",
    inVeh = false,
}
local saFireTgt = {
    player = nil,
    pos = nil,
    claimPos = nil,
    bone = nil,
    origin = nil,
    spoof = nil,
    tier = 0,
    mode = "live",
    inVeh = false,
}
local FOOT_NAMES = { "LeftFoot", "RightFoot", "Left Leg", "Right Leg", "LeftLowerLeg", "RightLowerLeg" }
local visChars = {}
local visIgnoreN = 0
local visF = { myChar = nil, ignoreFolder = nil, cam = nil, tool = nil, builtChar = nil, builtTool = nil, builtFolder = nil, builtCam = nil }

local COL = {
    TIER0 = Color3.fromRGB(120, 255, 120),
    TIER1 = Color3.fromRGB(255, 220, 80),
    TIER2 = Color3.fromRGB(120, 180, 255),
    TIERX = Color3.fromRGB(255, 90, 90),
    SPOOF_A = Color3.fromRGB(255, 200, 60),
    SPOOF_B = Color3.fromRGB(120, 255, 180),
    WHITE = Color3.new(1, 1, 1),
    UP3 = V3(0, 1, 0),
    X3 = V3(1, 0, 0),
}

local STATE_COLOR = {
    Aim = Color3.fromRGB(120, 200, 255),
    Shoot = Color3.fromRGB(255, 90, 90),
    Heal = Color3.fromRGB(90, 255, 140),
    Drag = Color3.fromRGB(255, 180, 70),
    Crouch = Color3.fromRGB(170, 180, 200),
    Lay = Color3.fromRGB(200, 150, 255),
    Drive = Color3.fromRGB(120, 200, 255),
    Sit = Color3.fromRGB(170, 180, 200),
}

function F.bind(conn)
    connections[#connections + 1] = conn
    return conn
end

function F.roster_add(player)
    for i = 1, rosterN do
        if roster[i] == player then
            return
        end
    end
    rosterN += 1
    roster[rosterN] = player
end

function F.roster_remove(player)
    for i = 1, rosterN do
        if roster[i] == player then
            roster[i] = roster[rosterN]
            roster[rosterN] = nil
            rosterN -= 1
            break
        end
    end
    charRefs[player] = nil
    visCache[player] = nil
    hotbarCache[player] = nil
    stateCache[player] = nil
    moveHint[player] = nil
    lastShotAt[player] = nil
    aimTrackOf[player] = nil
    enemyOf[player] = nil
end

function F.roster_rebuild()
    table.clear(roster)
    rosterN = 0
    local list = Players:GetPlayers()
    for i = 1, #list do
        rosterN += 1
        roster[rosterN] = list[i]
    end
end
F.roster_rebuild()
F.bind(Players.PlayerAdded:Connect(F.roster_add))
F.bind(Players.PlayerRemoving:Connect(F.roster_remove))

function F.cv(char)
    return char and char:FindFirstChild("CharacterValues")
end

function F.cv_val(char, name)
    local folder = F.cv(char)
    local v = folder and folder:FindFirstChild(name)
    if v == nil then
        return nil
    end
    return v.Value
end

function F.char_ref(player)
    local char = player.Character
    local r = charRefs[player]
    if r and r.char == char and char then
        if r.hrp and r.hrp.Parent then
            return r
        end
    end
    r = r or {}
    r.char = char
    r.hum = char and char:FindFirstChildWhichIsA("Humanoid")
    r.hrp = char and char:FindFirstChild("HumanoidRootPart")
    r.head = char and char:FindFirstChild("Head")
    r.torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
    r.folder = char and char:FindFirstChild("CharacterValues")
    r.unc = r.folder and r.folder:FindFirstChild("Unconscious")
    r.shock = r.folder and r.folder:FindFirstChild("Shock")
    r.stance = r.folder and r.folder:FindFirstChild("Stance")
    r.headHp = r.head and r.head:FindFirstChild("Health")
    r.torsoHp = r.torso and r.torso:FindFirstChild("Health")
    r.tool = nil
    r.toolAt = -1
    r.toolSeq = aliveFrame
    r.aliveSeq = -1
    r.alive = false
    charRefs[player] = r
    return r
end

function F.hrp_of(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

function F.bone_of(char, name)
    if not char then
        return nil
    end
    return char:FindFirstChild(name) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

function F.ref_bone(player, name)
    local r = player and charRefs[player]
    local char = r and r.char or (player and player.Character)
    local bone
    if r then
        if name == "Head" then
            bone = r.head or r.hrp
        elseif name == "Torso" then
            bone = r.torso or r.hrp
        else
            bone = r.hrp or r.head
        end
    end
    if not (bone and bone.Parent) then
        bone = F.bone_of(char, name)
    end
    return bone, char
end

function F.part_name_for_shot()
    local mode = CFG.AimBone or "Head"
    if mode == "Torso" or mode == "HumanoidRootPart" then
        return mode
    end
    if mode == "Random" then
        if math.random() < 0.5 then
            return "Head"
        end
        return "Torso"
    end
    local hc = CFG.HeadChance
    if type(hc) ~= "number" then
        hc = 50
    end
    hc = clamp(hc, 0, 100)
    if hc >= 100 then
        return "Head"
    end
    if hc <= 0 then
        return "Torso"
    end
    if math.random() * 100 < hc then
        return "Head"
    end
    return "Torso"
end

function F.force_part_name()
    local mode = CFG.ForceHitPart or "auto"
    if mode == "Torso" then
        return "Torso"
    end
    if mode == "auto" then
        return F.part_name_for_shot()
    end
    local hc = CFG.HeadChance
    if type(hc) ~= "number" then
        hc = 50
    end
    hc = clamp(hc, 0, 100)
    if hc >= 100 then
        return "Head"
    end
    if hc <= 0 then
        return "Torso"
    end
    if math.random() * 100 < hc then
        return "Head"
    end
    return "Torso"
end

function F.seg_point_dist(p, a, b)
    local ab = b - a
    local den = ab:Dot(ab)
    if den < 1e-6 then
        return (p - a).Magnitude
    end
    local t = math.clamp((p - a):Dot(ab) / den, 0, 1)
    return (a + ab * t - p).Magnitude
end

function F.apply_force_hit(impact)
    if not CFG.ForceHit or type(impact) ~= "table" then
        return
    end
    local inst = impact.Instance
    local model = inst and inst:FindFirstAncestorOfClass("Model")
    local victim = model and Players:GetPlayerFromCharacter(model)
    if victim == LP then
        return
    end
    if victim and LP.Team and victim.Team and LP.Team == victim.Team then
        return
    end
    if not victim then
        local from = lastShotFrom
        local pos = impact.Position
        if typeof(pos) ~= "Vector3" and inst then
            pos = inst.Position
        end
        if typeof(from) ~= "Vector3" or typeof(pos) ~= "Vector3" then
            return
        end
        local margin = CFG.ForceHitMargin or 2.5
        if type(margin) ~= "number" or margin <= 0 then
            return
        end
        local best, bestD = nil, margin
        for ri = 1, rosterN do
            local pl = roster[ri]
            if F.enemy(pl) then
                local bone = F.ref_bone(pl, "Head") or F.ref_bone(pl, "Torso")
                if bone then
                    local d = F.seg_point_dist(bone.Position, from, pos)
                    if d < bestD then
                        best, bestD = pl, d
                    end
                end
            end
        end
        victim = best
    end
    if not victim then
        return
    end
    local part = F.ref_bone(victim, F.force_part_name())
    if part then
        impact.Instance = part
        impact.Position = part.Position
    end
end

function F.class_type()
    local a = LP:GetAttribute("ClassType")
    if type(a) == "string" and a ~= "" then
        return a
    end
    local v = F.cv_val(LP.Character, "ClassType")
    if type(v) == "string" then
        return v
    end
    local n = F.cv_val(LP.Character, "ClassName")
    if type(n) == "string" then
        return n
    end
    return nil
end

function F.held_named(needle)
    local char = LP.Character
    if not char or type(needle) ~= "string" then
        return nil
    end
    needle = string.lower(needle)
    local kids = char:GetChildren()
    for i = 1, #kids do
        local c = kids[i]
        if c:IsA("Tool") then
            local n = string.lower(c.Name)
            if string.find(n, needle, 1, true) then
                return c
            end
            local tt = c:GetAttribute("ToolType")
            if type(tt) == "string" and string.find(string.lower(tt), needle, 1, true) then
                return c
            end
        end
    end
    return nil
end

function F.ensure_support_remotes()
    local rem = ReplicatedStorage:FindFirstChild("Remotes")
    if rem then
        if not lastSupport.medicRE then
            lastSupport.medicRE = rem:FindFirstChild("MedicBag")
        end
        if not lastSupport.binRE then
            lastSupport.binRE = rem:FindFirstChild("Binoculars")
        end
    end
    if not lastSupport.medicRE or not lastSupport.binRE then
        local desc = ReplicatedStorage:GetDescendants()
        for i = 1, #desc do
            local d = desc[i]
            if d:IsA("RemoteEvent") then
                if not lastSupport.medicRE and d.Name == "MedicBag" then
                    lastSupport.medicRE = d
                elseif not lastSupport.binRE and d.Name == "Binoculars" then
                    lastSupport.binRE = d
                end
            end
            if lastSupport.medicRE and lastSupport.binRE then
                break
            end
        end
    end
    if lastSupport.binRE and not lastSupport.reconHooked then
        lastSupport.reconHooked = true
        lastSupport.binRE.OnClientEvent:Connect(function(sec)
            if type(sec) == "number" and sec > 0 then
                lastSupport.reconUntil = clock() + sec
            end
        end)
    end
end

function F.stop_heal()
    if lastSupport.heal and lastSupport.medicRE then
        pcall(function()
            lastSupport.medicRE:FireServer(lastSupport.heal, false)
        end)
    end
    lastSupport.heal = nil
end

function F.tick_support()
    local now = clock()
    if now - lastSupport.at < 0.3 then
        return
    end
    lastSupport.at = now
    F.ensure_support_remotes()
    local hrp = F.hrp_of(LP.Character)
    local ct = F.class_type()
    local ctLow = type(ct) == "string" and string.lower(ct) or ""
    if CFG.AutoHeal and lastSupport.medicRE and hrp then
        local bag = F.held_named("medicbag")
        local isMedic = bag ~= nil or string.find(ctLow, "medic", 1, true) ~= nil
        if isMedic then
            local radius = CFG.AutoHealRadius or 7
            local best, bestD
            local list = Players:GetPlayers()
            for i = 1, #list do
                local pl = list[i]
                if pl ~= LP and LP.Team and pl.Team and LP.Team == pl.Team then
                    local r = F.char_ref(pl)
                    local th = r.hrp
                    local hum = r.hum
                    if th and hum and hum.Health > 0 then
                        local d = (th.Position - hrp.Position).Magnitude
                        if d <= radius and (not bestD or d < bestD) then
                            best, bestD = r.char, d
                        end
                    end
                end
            end
            if best then
                if lastSupport.heal ~= best then
                    if lastSupport.heal then
                        pcall(function()
                            lastSupport.medicRE:FireServer(lastSupport.heal, false)
                        end)
                    end
                    lastSupport.heal = best
                    lastSupport.healAt = now
                    pcall(function()
                        lastSupport.medicRE:FireServer(best, true)
                    end)
                elseif now - (lastSupport.healAt or 0) > 1.2 then
                    lastSupport.healAt = now
                    pcall(function()
                        lastSupport.medicRE:FireServer(best, true)
                    end)
                end
            else
                F.stop_heal()
            end
        else
            F.stop_heal()
        end
    else
        F.stop_heal()
    end
    if CFG.AutoRecon and lastSupport.binRE and now >= lastSupport.reconUntil and Cam and hrp then
        local bins = F.held_named("binocular")
        local isRecon = bins ~= nil or string.find(ctLow, "recon", 1, true) ~= nil
        if isRecon then
            local best, bestD
            for ri = 1, rosterN do
                local pl = roster[ri]
                if F.enemy(pl) then
                    local r = F.char_ref(pl)
                    local th = r.hrp or r.head
                    if th then
                        local d = (th.Position - hrp.Position).Magnitude
                        if not bestD or d < bestD then
                            best, bestD = th, d
                        end
                    end
                end
            end
            if best then
                local dir = best.Position - Cam.CFrame.Position
                if dir.Magnitude > 0.05 then
                    lastSupport.reconUntil = now + 1.2
                    pcall(function()
                        lastSupport.binRE:FireServer("Spotting", dir.Unit)
                    end)
                end
            end
        end
    end
end

local LIMB_HP = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }

function F.limb_hp_frac(char, o)
    if not char then
        return 0
    end
    local sum, cap = 0, 0
    local inst = o and o.hpInst
    if inst and (inst.n or 0) > 0 then
        for i = 1, inst.n do
            local h = inst[i]
            if h and h.Parent and typeof(h.Value) == "number" then
                local mx = h:GetAttribute("MaxHealth")
                if typeof(mx) == "number" and mx > 0 then
                    sum += math.max(h.Value, 0)
                    cap += mx
                end
            end
        end
    else
        for i = 1, #LIMB_HP do
            local part = char:FindFirstChild(LIMB_HP[i])
            local h = part and part:FindFirstChild("Health")
            if h and typeof(h.Value) == "number" then
                local mx = h:GetAttribute("MaxHealth")
                if typeof(mx) == "number" and mx > 0 then
                    sum += math.max(h.Value, 0)
                    cap += mx
                end
            end
        end
    end
    if cap <= 0 then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.MaxHealth > 0 then
            return clamp(hum.Health / hum.MaxHealth, 0, 1)
        end
        return 0
    end
    return clamp(sum / cap, 0, 1)
end

function F.alive(player)
    local r = F.char_ref(player)
    if r.aliveSeq == aliveFrame then
        return r.alive
    end
    local ok = false
    local char = r.char
    if char and char.Parent then
        local hum = r.hum
        if hum and hum.Parent and hum.Health > 0 then
            local unc = r.unc
            if not (unc and unc.Parent and unc.Value == true) then
                local shock = r.shock
                if not (shock and shock.Parent and typeof(shock.Value) == "number" and shock.Value >= 100) then
                    local hh = r.headHp
                    local headDead = hh and hh.Parent and typeof(hh:GetAttribute("MaxHealth")) == "number" and hh.Value <= 0
                    if not headDead then
                        local th = r.torsoHp
                        local torsoDead = th and th.Parent and typeof(th:GetAttribute("MaxHealth")) == "number" and th.Value <= 0
                        ok = not torsoDead
                    end
                end
            end
        end
    end
    r.aliveSeq = aliveFrame
    r.alive = ok
    return ok
end

function F.enemy(player)
    if player == nil or player == LP then
        return false
    end
    if CFG.IgnoreTeammates then
        local rec = enemyOf[player]
        local my = LP.Team
        local their = player.Team
        if rec and rec.my == my and rec.their == their then
            if not rec.enemy then
                return false
            end
        else
            local isEnemy = not (my and their and my == their)
            enemyOf[player] = { my = my, their = their, enemy = isEnemy }
            if not isEnemy then
                return false
            end
        end
    end
    return F.alive(player)
end

function F.veh_part(player)
    local r = F.char_ref(player)
    if r.vehPartSeq == aliveFrame then
        return r.vehPart
    end
    r.vehPartSeq = aliveFrame
    local hum = r.hum
    local seat = hum and hum.SeatPart
    local part = seat
    if seat then
        local cur = seat
        for _ = 1, 10 do
            if not cur or cur == Workspace then
                break
            end
            if CollectionService:HasTag(cur, "AdoptVehicle") then
                if cur:IsA("Model") then
                    part = cur.PrimaryPart or cur:FindFirstChild("Chassis") or cur:FindFirstChild("Hull") or cur:FindFirstChildWhichIsA("BasePart") or seat
                elseif cur:IsA("BasePart") then
                    part = cur
                end
                break
            end
            cur = cur.Parent
        end
        if part == seat then
            local mdl = seat:FindFirstAncestorOfClass("Model")
            if mdl then
                part = mdl.PrimaryPart or mdl:FindFirstChildWhichIsA("BasePart") or seat
            end
        end
    end
    r.vehPart = part
    return part
end

local pingCached, pingAt = 0, -1
function F.ping_sec()
    local now = clock()
    if now - pingAt > 0.25 then
        pingAt = now
        local p = LP:GetNetworkPing()
        pingCached = type(p) == "number" and p or 0
    end
    return pingCached
end

function F.flight_time(dist, speed, drag)
    if type(dist) ~= "number" or dist <= 0 then
        return 0
    end
    speed = speed or 900
    if speed < 1 then
        speed = 900
    end
    if drag and drag > 1e-6 then
        local ratio = dist * drag / speed
        if ratio >= 0.98 then
            return dist / speed
        end
        return -(1 / drag) * math.log(1 - ratio)
    end
    return dist / speed
end

function F.in_vehicle(player)
    local r = F.char_ref(player)
    if r.vehSeq == aliveFrame then
        return r.inVeh
    end
    r.vehSeq = aliveFrame
    local hum = r.hum
    local hrp = r.hrp
    local ok = hum ~= nil and hum.Parent ~= nil and (hum.Sit == true or hum.SeatPart ~= nil)
    if not ok and hrp then
        local root = hrp.AssemblyRootPart
        if root and root ~= hrp and r.char and not root:IsDescendantOf(r.char) then
            ok = true
        end
    end
    r.inVeh = ok
    return ok
end

function F.lead_sec(origin, pos, speed, drag, inVeh)
    local t = inVeh and (CFG.InterpLeadVehicle or 0) or (CFG.InterpLead or 0)
    local ping = F.ping_sec()
    if type(ping) == "number" then
        t += ping * 0.5
    end
    if not CFG.PredictIgnoreWeapon then
        local dist = (origin and pos) and (pos - origin).Magnitude or 0
        local mul = inVeh and (CFG.GunPredictVehicleMul or 1) or (CFG.GunPredictMul or 1)
        t += F.flight_time(dist, speed, drag) * mul
    end
    return t
end

function F.extrap_pos(pos, vel, t, cap)
    if t <= 0 or typeof(vel) ~= "Vector3" then
        return pos
    end
    local dx, dy, dz = vel.X * t, vel.Y * t, vel.Z * t
    local mag = math.sqrt(dx * dx + dy * dy + dz * dz)
    cap = cap or CFG.PredictMaxLead or 12
    if cap > 0 and mag > cap then
        local sc = cap / mag
        dx, dy, dz = dx * sc, dy * sc, dz * sc
    end
    return V3(pos.X + dx, pos.Y + dy, pos.Z + dz)
end

function F.target_vel(player, bone, inVeh)
    local r = F.char_ref(player)
    local part = (bone and bone:IsA("BasePart") and bone) or r.hrp
    local pos = part and part.Position
    if not pos then
        return ZERO3
    end
    local now = clock()
    local h = moveHint[player]
    if not h then
        moveHint[player] = { p = pos, t = now, v = ZERO3 }
        return ZERO3
    end
    local dt = now - h.t
    if dt >= 0.016 and dt < 0.45 then
        local raw = (pos - h.p) / dt
        local maxV = inVeh and 350 or 90
        local m = raw.Magnitude
        if m > maxV then
            raw = raw.Unit * maxV
        end
        if h.v.Magnitude > 1 then
            h.v = h.v:Lerp(raw, inVeh and 0.55 or 0.4)
        else
            h.v = raw
        end
        h.p, h.t = pos, now
    elseif dt >= 0.45 then
        h.p, h.t, h.v = pos, now, ZERO3
    end
    local phys = ZERO3
    if part then
        phys = part.AssemblyLinearVelocity
        local root = part.AssemblyRootPart
        if root then
            local rv = root.AssemblyLinearVelocity
            if rv.Magnitude > phys.Magnitude then
                phys = rv
            end
        end
    end
    if inVeh then
        if h.v.Magnitude > 2 then
            return h.v
        end
        if phys.Magnitude > 2 then
            return phys
        end
        return h.v
    end
    if phys.Magnitude > h.v.Magnitude then
        return phys
    end
    return h.v
end

function F.predict_aim(player, bone, origin, nowPos, speed, drag, inVeh)
    if not CFG.GunPredict or typeof(nowPos) ~= "Vector3" then
        return nowPos, nowPos
    end
    local vel = F.target_vel(player, bone, inVeh)
    local cap = inVeh and (CFG.PredictMaxLeadVehicle or 48) or (CFG.PredictMaxLead or 8)
    local t = F.lead_sec(origin, nowPos, speed, drag, inVeh)
    local pred = F.extrap_pos(nowPos, vel, t, cap)
    t = F.lead_sec(origin, pred, speed, drag, inVeh)
    pred = F.extrap_pos(nowPos, vel, t, cap)
    return pred, pred
end

function F.light_predict(player, bone, origin, nowPos, inVeh)
    if typeof(nowPos) ~= "Vector3" then
        return nowPos
    end
    local vel = F.target_vel(player, bone, inVeh)
    local dist = (origin and nowPos) and (nowPos - origin).Magnitude or 0
    local mul = inVeh and (CFG.GunPredictVehicleMul or 0.5) or (CFG.AimbotPredictMul or 0.35)
    local t = F.flight_time(dist, 850, 0.95) * mul
    if inVeh then
        t += CFG.InterpLeadVehicle or 0.1
    end
    local cap = inVeh and (CFG.PredictMaxLeadVehicle or 48) or (CFG.PredictMaxLead or 8)
    return F.extrap_pos(nowPos, vel, t, cap)
end

function F.hit_rolls()
    local ch = CFG.HitChance
    if type(ch) ~= "number" then
        ch = 70
    end
    ch = clamp(ch, 0, 100)
    if ch >= 100 then
        return true
    end
    if ch <= 0 then
        return false
    end
    return math.random() * 100 < ch
end

function F.part_aim_point(part, pos)
    if not CFG.LegitAim or typeof(pos) ~= "Vector3" or not (part and part:IsA("BasePart")) then
        return pos
    end
    local j = clamp(CFG.LegitBoneJitter or 0.32, 0.05, 0.45)
    local s = part.Size
    local off = V3((rnd() - 0.5) * s.X * j, (rnd() - 0.5) * s.Y * j, (rnd() - 0.5) * s.Z * j)
    return pos + part.CFrame:VectorToWorldSpace(off)
end

function F.spread_around(dir, deg)
    if typeof(dir) ~= "Vector3" then
        return dir
    end
    dir = dir.Unit
    if type(deg) ~= "number" or deg <= 0.001 then
        return dir
    end
    local tan = math.tan(math.rad(deg))
    return (dir + V3(rnd() * 2 - 1, rnd() * 2 - 1, rnd() * 2 - 1) * tan).Unit
end

local visParams = RaycastParams.new()
visParams.FilterType = Enum.RaycastFilterType.Exclude
visParams.IgnoreWater = true
local visIgnore = {}

function F.vis_filter_dirty()
    if visF.builtChar ~= visF.myChar or visF.builtTool ~= visF.tool or visF.builtFolder ~= visF.ignoreFolder or visF.builtCam ~= visF.cam then
        return true
    end
    for i = 1, rosterN do
        local char = roster[i].Character
        if visChars[i] ~= char then
            return true
        end
    end
    return false
end

function F.rebuild_vis_filter()
    local n = 0
    if visF.myChar then
        n += 1
        visIgnore[n] = visF.myChar
    end
    if visF.ignoreFolder then
        n += 1
        visIgnore[n] = visF.ignoreFolder
    end
    if visF.cam then
        n += 1
        visIgnore[n] = visF.cam
    end
    if visF.tool then
        n += 1
        visIgnore[n] = visF.tool
    end
    for i = 1, rosterN do
        local char = roster[i].Character
        visChars[i] = char
        if char then
            n += 1
            visIgnore[n] = char
        end
    end
    for i = rosterN + 1, #visChars do
        visChars[i] = nil
    end
    for i = n + 1, visIgnoreN do
        visIgnore[i] = nil
    end
    visIgnoreN = n
    visF.builtChar, visF.builtTool, visF.builtFolder, visF.builtCam = visF.myChar, visF.tool, visF.ignoreFolder, visF.cam
    visParams.FilterDescendantsInstances = table.clone(visIgnore)
end

function F.prep_frame(fromFire)
    if not fromFire then
        aliveFrame += 1
    end
    Cam = Workspace.CurrentCamera
    visF.myChar = LP.Character
    if not visF.ignoreFolder or not visF.ignoreFolder.Parent then
        visF.ignoreFolder = Workspace:FindFirstChild("Ignore")
    end
    visF.cam = Cam
    if not (visF.tool and visF.tool.Parent == visF.myChar) then
        visF.tool = visF.myChar and visF.myChar:FindFirstChildWhichIsA("Tool")
    end
    local teamName = LP.Team and LP.Team.Name
    local rayGroup = teamName == "PACT" and "RayPACT" or (teamName == "NATO" and "RayNATO" or "RayNeutral")
    if visParams.CollisionGroup ~= rayGroup then
        pcall(function()
            visParams.CollisionGroup = rayGroup
        end)
    end
    if Cam then
        local vp = Cam.ViewportSize
        vpX, vpY = vp.X, vp.Y
    end
    if F.vis_filter_dirty() then
        F.rebuild_vis_filter()
    end
end

local visMemo = { frame = 0, char = nil, fx = 0, fy = 0, fz = 0, tx = 0, ty = 0, tz = 0, res = false }

function F.vis_pierce_inst(inst)
    if typeof(inst) ~= "Instance" then
        return false
    end
    local name = inst.Name
    if name == "HumanoidRootPart" then
        return true
    end
    local class = inst.ClassName
    if class == "VehicleSeat" or class == "Seat" then
        return true
    end
    if CollectionService:HasTag(inst, "FactoryVehicleSeat") or CollectionService:HasTag(inst, "BallisticsPhantom") then
        return true
    end
    return false
end

function F.world_visible(fromPos, toPos, char)
    if visMemo.frame == aliveFrame and visMemo.char == char then
        if visMemo.fx == fromPos.X and visMemo.fy == fromPos.Y and visMemo.fz == fromPos.Z
            and visMemo.tx == toPos.X and visMemo.ty == toPos.Y and visMemo.tz == toPos.Z then
            return visMemo.res
        end
    end
    local dir = toPos - fromPos
    local mag = dir.Magnitude
    if mag < 0.05 then
        visMemo.frame, visMemo.char, visMemo.res = aliveFrame, char, true
        visMemo.fx, visMemo.fy, visMemo.fz = fromPos.X, fromPos.Y, fromPos.Z
        visMemo.tx, visMemo.ty, visMemo.tz = toPos.X, toPos.Y, toPos.Z
        return true
    end
    local from = fromPos
    local remain = dir
    local ok = false
    for _ = 1, 4 do
        local hit = Workspace:Raycast(from, remain, visParams)
        if not hit then
            ok = true
            break
        end
        if char ~= nil and hit.Instance:IsDescendantOf(char) then
            ok = true
            break
        end
        if not F.vis_pierce_inst(hit.Instance) then
            ok = false
            break
        end
        local left = remain.Magnitude - (hit.Position - from).Magnitude - 0.2
        if left < 0.05 then
            ok = true
            break
        end
        local unit = remain.Unit
        from = hit.Position + unit * 0.2
        remain = unit * left
    end
    visMemo.frame, visMemo.char, visMemo.res = aliveFrame, char, ok
    visMemo.fx, visMemo.fy, visMemo.fz = fromPos.X, fromPos.Y, fromPos.Z
    visMemo.tx, visMemo.ty, visMemo.tz = toPos.X, toPos.Y, toPos.Z
    return ok
end

function F.cached_visible(player, fromPos, toPos)
    local ttl = CFG.VisCacheSec or 0
    if ttl > 0 then
        local now = clock()
        local slot = visCache[player]
        if slot and now - slot.t < ttl and slot.from and slot.to
            and (slot.from - fromPos).Magnitude < 3
            and (slot.to - toPos).Magnitude < 4 then
            return slot.v
        end
        local v = F.world_visible(fromPos, toPos, player.Character)
        slot = slot or {}
        slot.t, slot.v, slot.from, slot.to = now, v, fromPos, toPos
        visCache[player] = slot
        return v
    end
    return F.world_visible(fromPos, toPos, player.Character)
end

function F.force_hit_on()
    return CFG.ForceHit == true
end

function F.need_los()
    return CFG.VisibleCheck == true
end

function F.shot_origin(muzzleOrigin)
    if CFG.OriginFromHRP then
        local hrp = F.hrp_of(LP.Character)
        if hrp then
            return hrp.Position
        end
    end
    return muzzleOrigin
end

function F.mp_dirs(cam)
    local cf = cam and cam.CFrame
    local right = cf and cf.RightVector or COL.X3
    local look = cf and cf.LookVector or COL.X3
    dirScratch[1] = right
    dirScratch[2] = -right
    dirScratch[3] = COL.UP3
    dirScratch[4] = (right + look).Unit
    dirScratch[5] = (-right + look).Unit
    dirCount = 5
    return dirScratch, dirCount
end

function F.peek_at(origin, aimPoint, model, dir, dist)
    local pt = origin + dir * dist
    if F.world_visible(pt, aimPoint, model) then
        return pt
    end
    return nil
end

function F.clamp_origin(honest, spoof)
    local budget = CFG.OriginBudget or 8
    local off = spoof - honest
    local mag = off.Magnitude
    if mag <= 0.02 then
        return honest
    end
    if mag > budget then
        return honest + off.Unit * budget
    end
    return spoof
end

function F.find_multipoint(origin, aimPoint, part, knownOccluded)
    local model = part and part.Parent
    if not knownOccluded and F.world_visible(origin, aimPoint, model) then
        return origin, 0
    end
    if not CFG.MultiPoint then
        return nil, 3
    end
    if (aimPoint - origin).Magnitude > (CFG.MPMaxDist or 500) then
        return nil, 3
    end
    local limit = CFG.MPMaxOffset or 10
    local frac = CFG.MPPreferFrac or 0.5
    if frac < 0.15 then
        frac = 0.15
    elseif frac > 0.9 then
        frac = 0.9
    end
    local prefer = limit * frac
    local dirs, n = F.mp_dirs(Cam)
    for i = 1, n do
        local pt = F.peek_at(origin, aimPoint, model, dirs[i], prefer)
        if pt then
            local clamped = F.clamp_origin(origin, pt)
            if F.world_visible(clamped, aimPoint, model) then
                return clamped, 0
            end
        end
    end
    local best, bestDev = nil, huge
    local bandA, bandB = limit * math.min(frac + 0.15, 0.85), limit * math.max(frac - 0.15, 0.2)
    for i = 1, n do
        local dir = dirs[i]
        local a = F.peek_at(origin, aimPoint, model, dir, bandA)
        local b = F.peek_at(origin, aimPoint, model, dir, bandB)
        local pt = a or b
        if pt then
            local len = (pt - origin).Magnitude
            local dev = math.abs(len - prefer)
            if dev < bestDev then
                bestDev = dev
                best = pt
            end
        end
    end
    if best then
        best = F.clamp_origin(origin, best)
        if F.world_visible(best, aimPoint, model) then
            return best, 0
        end
    end
    return nil, 3
end

function F.boost_shot(proj, mul)
    if type(proj) ~= "table" or proj.Alive ~= true then
        return
    end
    mul = tonumber(mul)
    if not mul or mul <= 1.01 then
        return
    end
    if mul > 6 then
        mul = 6
    end
    local arc = proj._arc
    if type(arc) ~= "table" or type(arc.Traj) ~= "table" then
        return
    end
    local traj = arc.Traj
    local spd = traj.MuzzleSpeed
    if type(spd) ~= "number" or spd <= 0 then
        return
    end
    traj.MuzzleSpeed = spd * mul
    if type(traj.Decay) == "number" and traj.Decay > 1e-6 then
        traj.Decay = traj.Decay * mul
        traj.MaxForward = traj.MuzzleSpeed / traj.Decay
    elseif type(traj.Decay) == "number" and traj.Decay <= 1e-6 then
        traj.MaxForward = 1 / 0
    end
    if type(traj.Gravity) == "number" then
        traj.Gravity = traj.Gravity * mul * mul
    end
    if type(proj.Speed) == "number" then
        proj.Speed = proj.Speed * mul
    end
end

function F.claim_hit(seed, player, part, impact)
    if not (ShotCodec and PlayerSlots and BallisticsNet) then
        return
    end
    if player == LP then
        return
    end
    if LP.Team and player.Team and LP.Team == player.Team then
        return
    end
    local char = player.Character
    if not char or not char.Parent then
        return
    end
    local slot = PlayerSlots.getSlot(player)
    if type(slot) ~= "number" or slot < 1 then
        slot = player:GetAttribute("NetSlot")
    end
    if type(slot) ~= "number" or slot < 1 then
        return
    end
    local partName = part and part.Name or CFG.AimBone or "Head"
    local partId = ShotCodec.partIdOf(partName)
    if partId == 0 then
        partName = part and part.Name or "Torso"
        partId = ShotCodec.partIdOf(partName)
        if partId == 0 then
            partId = ShotCodec.partIdOf("Torso")
            partName = "Torso"
        end
    end
    local bone = part
    if bone == nil or bone.Name ~= partName then
        bone = F.bone_of(player.Character, partName)
    end
    local pos = impact or (bone and bone.Position)
    if typeof(pos) ~= "Vector3" then
        return
    end
    local buf = ShotCodec.encodeClaim(seed, slot, partId, pos)
    claimedSeeds[seed] = clock()
    BallisticsNet.HitClaim:FireServer(buf)
    local from = lastShotFrom
    if typeof(from) ~= "Vector3" then
        local mcf = F.muzzle_cframe()
        from = mcf and mcf.Position
    end
    F.hit_fx(from, pos)
end

function F.prune_claims()
    local now = clock()
    for seed, t in claimedSeeds do
        if now - t > 2 then
            claimedSeeds[seed] = nil
        end
    end
end

function F.weapon_profile(toolOrName, muzzleIdx, bulletIdx)
    muzzleIdx = muzzleIdx or 1
    bulletIdx = bulletIdx or 1
    local name = typeof(toolOrName) == "Instance" and toolOrName.Name or toolOrName
    if type(name) ~= "string" then
        return 900, 0.95, 0
    end
    local key = name .. ":" .. muzzleIdx .. ":" .. bulletIdx
    local cached = speedCache[key]
    if cached then
        return cached.speed, cached.drag, cached.pen or 0
    end
    local speed, drag, pen = 900, 0.95, 0
    if WeaponConfigManager then
        local ok, cfg = pcall(WeaponConfigManager.GetMuzzleConfig, WeaponConfigManager, name, muzzleIdx)
        if (not ok or not cfg) and WeaponConfigManager.GetAllMuzzlesConfig then
            local okAll, all = pcall(WeaponConfigManager.GetAllMuzzlesConfig, WeaponConfigManager, name)
            if okAll and type(all) == "table" then
                cfg = all[muzzleIdx] or all[1]
                ok = cfg ~= nil
            end
        end
        if ok and cfg and cfg.BulletSettings then
            local bs = cfg.BulletSettings[bulletIdx] or cfg.BulletSettings[1]
            if bs then
                speed = bs.MuzzleVelocity or speed
                drag = bs.Drag or drag
                pen = bs.Penetration or 0
            end
        end
    end
    speedCache[key] = { speed = speed, drag = drag, pen = pen }
    return speed, drag, pen
end

function F.ballistic_dir(origin, target, toolOrName, muzzleIdx, bulletIdx, noQuant)
    local delta = target - origin
    local dist = delta.Magnitude
    if dist < 0.05 then
        return delta.Magnitude > 0 and delta.Unit or Cam.CFrame.LookVector
    end
    local speed, drag = F.weapon_profile(toolOrName, muzzleIdx, bulletIdx)
    local g = Workspace.Gravity
    local hDist = math.sqrt(delta.X * delta.X + delta.Z * delta.Z)
    if hDist < 0.08 then
        return delta.Unit
    end
    local dy = delta.Y
    local traj
    if Trajectory and type(Trajectory.new) == "function" then
        local okT, t0 = pcall(Trajectory.new, {
            Origin = ZERO3,
            Direction = V3(0, 0, -1),
            MuzzleSpeed = speed,
            K = drag,
            Gravity = g,
        })
        if okT then
            traj = t0
        end
    end
    local function timeFor(pathLen)
        if traj and type(Trajectory.GetTimeForDistance) == "function" then
            local okD, tt = pcall(Trajectory.GetTimeForDistance, traj, pathLen)
            if okD and type(tt) == "number" then
                return tt
            end
        end
        return F.flight_time(pathLen, speed, drag)
    end
    local function residual(theta)
        local c = math.cos(theta)
        if c < 0.05 then
            return nil
        end
        local pathLen = hDist / c
        local t = timeFor(pathLen)
        if type(t) ~= "number" then
            return nil
        end
        return math.sin(theta) * pathLen - 0.5 * g * t * t - dy
    end
    local lo, hi = -0.55, 1.22
    local found
    local prevTh, prevR = lo, residual(lo)
    for i = 1, 48 do
        local th = lo + (hi - lo) * (i / 48)
        local r = residual(th)
        if type(r) == "number" and type(prevR) == "number" and prevR < 0 and r >= 0 then
            local a, b = prevTh, th
            for _ = 1, 20 do
                local m = 0.5 * (a + b)
                local rm = residual(m)
                if type(rm) == "number" and rm >= 0 then
                    b = m
                else
                    a = m
                end
            end
            found = 0.5 * (a + b)
            break
        end
        if type(r) == "number" then
            prevTh, prevR = th, r
        end
    end
    local dir
    if found then
        local flat = V3(delta.X / hDist, 0, delta.Z / hDist)
        dir = flat * math.cos(found) + V3(0, math.sin(found), 0)
        if dir.Magnitude > 1e-4 then
            dir = dir.Unit
        else
            dir = delta.Unit
        end
    else
        local t = timeFor(dist)
        local drop = 0.5 * g * t * t
        dir = target + V3(0, drop, 0) - origin
        dir = dir.Magnitude > 1e-4 and dir.Unit or delta.Unit
    end
    if not noQuant and ShotCodec and ShotCodec.quantizeDirection then
        dir = ShotCodec.quantizeDirection(dir)
    end
    return dir
end

function F.fov_px(deg)
    if not Cam then
        return 0
    end
    deg = deg or CFG.SilentAimFOV
    local fov = Cam.FieldOfView
    local dist = vpY * 0.5 / math.tan(math.rad(fov) * 0.5)
    return dist * math.tan(math.rad(deg) * 0.5)
end

function F.screen_fov_radius()
    local fov = Cam.FieldOfView
    local sa = CFG.SilentAimFOV
    if vpX == fovCache.vx and vpY == fovCache.vy and fov == fovCache.fov and sa == fovCache.sa then
        return fovCache.r
    end
    fovCache.r = F.fov_px(sa)
    fovCache.vx, fovCache.vy, fovCache.fov, fovCache.sa = vpX, vpY, fov, sa
    return fovCache.r
end

function F.is_aiming()
    if AimCtrl and type(AimCtrl.isAiming) == "function" then
        local ok, v = pcall(AimCtrl.isAiming)
        if ok then
            return v == true
        end
    end
    return false
end

function F.is_shooting()
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end

function F.pick_silent_target(origin, maxDist, needVis, fovDeg, boneName, allowMP)
    origin = F.shot_origin(origin)
    local cx, cy = vpX * 0.5, vpY * 0.5
    if cx == 0 and Cam then
        local vp = Cam.ViewportSize
        cx, cy = vp.X * 0.5, vp.Y * 0.5
    end
    local maxR = F.fov_px(fovDeg or CFG.SilentAimFOV)
    local maxR2 = maxR * maxR
    boneName = boneName or CFG.AimBone
    local nCand = 0
    for ri = 1, rosterN do
        local player = roster[ri]
        if F.enemy(player) then
            local r = charRefs[player]
            local char = r and r.char or player.Character
            local bone
            if r then
                if boneName == "Head" then
                    bone = r.head or r.hrp
                elseif boneName == "Torso" then
                    bone = r.torso or r.hrp
                else
                    bone = r.hrp or r.head
                end
            end
            if not (bone and bone.Parent) then
                bone = F.bone_of(char, boneName)
            end
            if bone then
                local nowPos = bone.Position
                local dist = (nowPos - origin).Magnitude
                if dist <= maxDist then
                    local sp, onScreen = Cam:WorldToViewportPoint(nowPos)
                    if onScreen and sp.Z > 0 then
                        local dx, dy = sp.X - cx, sp.Y - cy
                        local fov2 = dx * dx + dy * dy
                        if fov2 <= maxR2 then
                            nCand += 1
                            local c = candPool[nCand]
                            if not c then
                                c = {}
                                candPool[nCand] = c
                            end
                            c.player = player
                            c.char = char
                            c.bone = bone
                            c.pos = nowPos
                            c.dist = dist
                            c.fov2 = fov2
                        end
                    end
                end
            end
        end
    end
    if nCand == 0 then
        return nil
    end
    for i = 2, nCand do
        local key = candPool[i]
        local j = i - 1
        while j >= 1 and candPool[j].fov2 > key.fov2 do
            candPool[j + 1] = candPool[j]
            j -= 1
        end
        candPool[j + 1] = key
    end
    local cand, tier, spoof = nil, 0, origin
    if needVis then
        local visLimit = math.min(nCand, 4)
        for i = 1, visLimit do
            local c = candPool[i]
            if F.cached_visible(c.player, origin, c.pos) then
                cand = c
                break
            end
        end
        if not cand then
            local altName
            if boneName == "Head" then
                altName = "Torso"
            elseif boneName == "Torso" then
                altName = "Head"
            end
            if altName then
                for i = 1, visLimit do
                    local c = candPool[i]
                    local alt = F.ref_bone(c.player, altName)
                    if alt and F.cached_visible(c.player, origin, alt.Position) then
                        c.bone = alt
                        c.pos = alt.Position
                        cand = c
                        break
                    end
                end
            end
        end
    else
        cand = candPool[1]
    end
    if not cand and allowMP ~= false and CFG.MultiPoint then
        local mpLimit = math.min(nCand, 2)
        for i = 1, mpLimit do
            local c = candPool[i]
            local mp = F.find_multipoint(origin, c.pos, c.bone, true)
            if mp then
                cand, tier, spoof = c, 2, mp
                break
            end
        end
    end
    if not cand then
        if needVis then
            return nil
        end
        cand = candPool[1]
    end
    local nowPos = cand.pos
    local aimPos = nowPos
    local mode = "live"
    local inVeh = F.in_vehicle(cand.player)
    if CFG.GunPredict then
        local speed, drag
        if CFG.PredictIgnoreWeapon then
            speed = CFG.PredictFixedSpeed or 850
        else
            local selfRef = F.char_ref(LP)
            speed, drag = F.weapon_profile(F.refresh_tool(selfRef), 1, 1)
        end
        local pred, claim = F.predict_aim(cand.player, cand.bone, origin, nowPos, speed, drag, inVeh)
        aimPos = pred
        nowPos = claim
        mode = "predict"
    end
    saTgtBuf.player = cand.player
    saTgtBuf.pos = aimPos
    saTgtBuf.claimPos = nowPos
    saTgtBuf.bone = cand.bone
    saTgtBuf.origin = origin
    saTgtBuf.spoof = spoof
    saTgtBuf.tier = tier
    saTgtBuf.mode = mode
    saTgtBuf.inVeh = inVeh
    return saTgtBuf
end


function F.refresh_tool(r)
    if not r or not r.char then
        return nil
    end
    local now = clock()
    if r.tool and r.tool.Parent == r.char and r.toolAt and now - r.toolAt < 0.25 then
        return r.tool
    end
    r.toolAt = now
    r.tool = r.char:FindFirstChildWhichIsA("Tool")
    return r.tool
end

function F.equipped_weapon(player)
    local r = F.char_ref(player)
    local tool = F.refresh_tool(r)
    if tool then
        return tool.Name
    end
    return nil
end

function F.player_hotbar_slots(player)
    local now = clock()
    local cached = hotbarCache[player]
    if cached and now - cached.t < 4 then
        return cached.list
    end
    local slots = cached and cached.list or {}
    table.clear(slots)
    local r = F.char_ref(player)
    local tool = F.refresh_tool(r)
    local eqName = tool and tool.Name
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in backpack:GetChildren() do
            if child:IsA("Tool") and child.Name ~= eqName then
                local slot = slots[#slots + 1]
                if type(slot) ~= "table" then
                    slot = { text = child.Name, color = CFG.EspColorDist }
                    slots[#slots + 1] = slot
                else
                    slot.text = child.Name
                    slot.color = CFG.EspColorDist
                end
                if #slots >= 4 then
                    break
                end
            end
        end
    end
    if not cached then
        cached = { t = now, list = slots }
        hotbarCache[player] = cached
    else
        cached.t = now
        cached.list = slots
    end
    return slots
end

local aimIdByWeapon = {}
function F.mark_aim_id(tbl, id)
    if type(id) ~= "string" and type(id) ~= "number" then
        return
    end
    id = tostring(id)
    tbl[id] = true
    local num = string.match(id, "(%d+)$")
    if num then
        tbl[num] = true
        tbl["rbxassetid://" .. num] = true
    end
end

function F.aim_ids_of_weapon(name)
    if type(name) ~= "string" then
        return nil
    end
    local cached = aimIdByWeapon[name]
    if cached then
        return cached
    end
    local tbl = {}
    aimIdByWeapon[name] = tbl
    if not WeaponConfigManager then
        return tbl
    end
    local ok, all = pcall(WeaponConfigManager.GetAllMuzzlesConfig, WeaponConfigManager, name)
    if not ok or type(all) ~= "table" then
        return tbl
    end
    local function eat(anims)
        if type(anims) ~= "table" then
            return
        end
        F.mark_aim_id(tbl, anims.StanceAim)
        F.mark_aim_id(tbl, anims.AimIdle)
        F.mark_aim_id(tbl, anims.AimIdleUnchambered)
    end
    eat(all.Animations)
    for _, v in all do
        if type(v) == "table" then
            eat(v.Animations)
        end
    end
    return tbl
end

function F.ensure_aim_watch(player, char)
    if not char or aimWatchChar[char] then
        return
    end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    local animator = hum and hum:FindFirstChildWhichIsA("Animator")
    if not animator then
        return
    end
    aimWatchChar[char] = true
    local function id_key(id)
        if not id then
            return nil
        end
        id = tostring(id)
        local num = string.match(id, "(%d+)$")
        return id, num, num and ("rbxassetid://" .. num) or nil
    end
    local function is_aim_id(id)
        if not id then
            return false
        end
        local r = charRefs[player]
        local tool = r and r.tool
        if not (tool and tool.Parent == r.char) then
            return false
        end
        local ids = F.aim_ids_of_weapon(tool.Name)
        if not ids then
            return false
        end
        local a, b, c = id_key(id)
        return (a and ids[a]) or (b and ids[b]) or (c and ids[c]) or false
    end
    local function consider(track)
        if not track then
            return
        end
        local anim = track.Animation
        local id = anim and anim.AnimationId
        if is_aim_id(id) then
            aimTrackOf[player] = track
        end
    end
    connections[#connections + 1] = animator.AnimationPlayed:Connect(consider)
end

function F.player_states(player, char, hum, out)
    local now = clock()
    local rec = stateCache[player]
    if rec and rec.out and now - rec.t < 0.2 then
        return rec.out
    end
    if out then
        table.clear(out)
    else
        out = rec and rec.out or {}
        if rec then
            table.clear(out)
        end
    end
    F.ensure_aim_watch(player, char)
    local aiming = false
    local track = aimTrackOf[player]
    if track then
        aiming = track.IsPlaying == true
        if not aiming then
            aimTrackOf[player] = nil
        end
    end
    if aiming then
        out[#out + 1] = "Aim"
    end
    local shotT = lastShotAt[player]
    if shotT and clock() - shotT < 0.55 then
        out[#out + 1] = "Shoot"
    end
    if char and char:GetAttribute("isBandaging") then
        out[#out + 1] = "Heal"
    elseif player:GetAttribute("Reviving") ~= nil then
        out[#out + 1] = "Heal"
    end
    if player:GetAttribute("CarryingTarget") ~= nil or player:GetAttribute("ShoulderCarryTarget") ~= nil then
        out[#out + 1] = "Drag"
    end
    local stanceVal = nil
    local pref = F.char_ref(player)
    local stanceInst = pref and pref.stance
    if stanceInst and stanceInst.Parent then
        stanceVal = stanceInst.Value
    else
        stanceVal = F.cv_val(char, "Stance")
    end
    if stanceVal == "Crouch" then
        out[#out + 1] = "Crouch"
    elseif stanceVal == "Prone" then
        out[#out + 1] = "Lay"
    end
    if hum then
        if hum.SeatPart then
            local sn = hum.SeatPart.Name
            if sn == "DriverSeat" or string.find(sn, "Driver") then
                out[#out + 1] = "Drive"
            else
                out[#out + 1] = "Sit"
            end
        elseif hum.Sit then
            out[#out + 1] = "Sit"
        end
    end
    if not rec then
        rec = { t = now, out = out }
        stateCache[player] = rec
    else
        rec.t = now
        rec.out = out
    end
    return out
end

function F.make_text(z)
    local t = Drawing.new("Text")
    t.Outline, t.Center, t.ZIndex, t.Visible = true, true, z, false
    return t
end

function F.new_esp()
    local o = { boxLines = {} }
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.ZIndex, line.Visible = 20, false
        o.boxLines[i] = line
    end
    o.name, o.dist, o.weapon = F.make_text(22), F.make_text(23), F.make_text(23)
    o.hotbar = {}
    for i = 1, 4 do
        o.hotbar[i] = F.make_text(23)
    end
    o.chips = {}
    for i = 1, 8 do
        local chip = F.make_text(23)
        chip.Center = false
        o.chips[i] = chip
    end
    o.hpOutline = Drawing.new("Square")
    o.hpOutline.Filled, o.hpOutline.Thickness, o.hpOutline.ZIndex = false, 1, 17
    o.hpOutline.Color, o.hpOutline.Visible = Color3.fromRGB(8, 8, 8), false
    o.hpBg = Drawing.new("Square")
    o.hpBg.Filled, o.hpBg.ZIndex, o.hpBg.Color, o.hpBg.Visible = true, 18, Color3.fromRGB(22, 22, 22), false
    o.hpFill = Drawing.new("Square")
    o.hpFill.Filled, o.hpFill.ZIndex, o.hpFill.Visible = true, 19, false
    o.bounds = { minX = 0, maxX = 0, minY = 0, maxY = 0, centerX = 0, headTopY = 0 }
    o.states = {}
    o.hpInst = { n = 0 }
    o.hidden = true
    return o
end

function F.hide_esp(o)
    if o.hidden then
        return
    end
    o.hidden = true
    for i = 1, #o.boxLines do
        o.boxLines[i].Visible = false
    end
    o.name.Visible, o.dist.Visible, o.weapon.Visible = false, false, false
    for i = 1, #o.hotbar do
        o.hotbar[i].Visible = false
    end
    for i = 1, #o.chips do
        o.chips[i].Visible = false
    end
    o.hpOutline.Visible, o.hpBg.Visible, o.hpFill.Visible = false, false, false
end

function F.free_esp(o)
    F.hide_esp(o)
    for _, line in o.boxLines do
        line:Remove()
    end
    o.name:Remove()
    o.dist:Remove()
    o.weapon:Remove()
    for _, t in o.hotbar do
        t:Remove()
    end
    for _, t in o.chips do
        t:Remove()
    end
    o.hpOutline:Remove()
    o.hpBg:Remove()
    o.hpFill:Remove()
end

function F.esp_part(model, name)
    local d = model:FindFirstChild(name)
    if d and d:IsA("BasePart") then
        return d
    end
    return nil
end

function F.esp_refresh_limbs(o, model)
    local now = clock()
    if o.limbT and now - o.limbT < 0.5 and o.headPart and o.headPart.Parent and o.headPart:IsA("BasePart") then
        return
    end
    o.limbT = now
    o.headPart = F.esp_part(model, "Head") or F.esp_part(model, "UpperTorso") or F.esp_part(model, "Torso")
    local lowest, foot
    for i = 1, #FOOT_NAMES do
        local p = F.esp_part(model, FOOT_NAMES[i])
        if p then
            local y = p.Position.Y - p.Size.Y * 0.5
            if not lowest or y < lowest then
                lowest, foot = y, p
            end
        end
    end
    if not foot then
        o.footPart = nil
    else
        o.footPart = foot
    end
    local hpInst = o.hpInst
    if not hpInst then
        hpInst = { n = 0 }
        o.hpInst = hpInst
    end
    local n = 0
    for i = 1, #LIMB_HP do
        local part = model:FindFirstChild(LIMB_HP[i])
        local h = part and part:FindFirstChild("Health")
        if h then
            n += 1
            hpInst[n] = h
        end
    end
    for i = n + 1, hpInst.n or 0 do
        hpInst[i] = nil
    end
    hpInst.n = n
end

function F.feet_world(model, hrp, o)
    local foot = o and o.footPart
    if foot and foot.Parent and foot:IsA("BasePart") then
        return V3(hrp.Position.X, foot.Position.Y - foot.Size.Y * 0.5 - 0.12, hrp.Position.Z)
    end
    local hum = model:FindFirstChildWhichIsA("Humanoid")
    local hip = hum and hum.HipHeight or 0
    if hip < 2 then
        hip = 2
    end
    return V3(hrp.Position.X, hrp.Position.Y - hip - hrp.Size.Y * 0.5 - 0.2, hrp.Position.Z)
end

function F.compute_bounds(cam, model, o, hrp)
    hrp = hrp or F.hrp_of(model)
    if not hrp then
        return nil
    end
    F.esp_refresh_limbs(o, model)
    local head = o.headPart
    if head and not head:IsA("BasePart") then
        head = nil
    end
    local headWorld = head and (head.Position + V3(0, head.Size.Y * 0.5 + 0.25, 0)) or (hrp.Position + V3(0, 2.6, 0))
    local feetWorld = F.feet_world(model, hrp, o)
    local topScreen = cam:WorldToViewportPoint(headWorld)
    local botScreen = cam:WorldToViewportPoint(feetWorld)
    if topScreen.Z <= 0 or botScreen.Z <= 0 then
        return nil
    end
    local topY, botY = min(topScreen.Y, botScreen.Y), max(topScreen.Y, botScreen.Y)
    local height = botY - topY
    if height < 1 then
        return nil
    end
    local width = height * CFG.EspBoxAspect
    local centerX = (topScreen.X + botScreen.X) * 0.5
    local r = o.bounds
    if not r then
        r = {}
        o.bounds = r
    end
    r.minX = centerX - width * 0.5
    r.maxX = centerX + width * 0.5
    r.minY = topY
    r.maxY = botY
    r.centerX = centerX
    r.headTopY = topScreen.Y
    return r
end

function F.set_draw_line(line, x1, y1, x2, y2, color, thick)
    if line.Visible and line._x1 == x1 and line._y1 == y1 and line._x2 == x2 and line._y2 == y2 and line._c == color and line._th == thick then
        return
    end
    line._x1, line._y1, line._x2, line._y2, line._c, line._th = x1, y1, x2, y2, color, thick
    line.Visible = true
    line.Color = color
    line.Thickness = thick
    line.From = V2(x1, y1)
    line.To = V2(x2, y2)
end

function F.set_text_pos(t, x, y)
    if t._x == x and t._y == y then
        return
    end
    t._x, t._y = x, y
    t.Position = V2(x, y)
end

function F.draw_box(o, r, color)
    local w, h = r.maxX - r.minX, r.maxY - r.minY
    local thick = CFG.EspBoxThickness
    local used = 4
    if CFG.EspBoxMode == "Corner" then
        local cx, cy = min(w * CFG.EspCornerScale, w * 0.5), min(h * CFG.EspCornerScale, h * 0.5)
        F.set_draw_line(o.boxLines[1], r.minX, r.minY, r.minX + cx, r.minY, color, thick)
        F.set_draw_line(o.boxLines[2], r.minX, r.minY, r.minX, r.minY + cy, color, thick)
        F.set_draw_line(o.boxLines[3], r.maxX - cx, r.minY, r.maxX, r.minY, color, thick)
        F.set_draw_line(o.boxLines[4], r.maxX, r.minY, r.maxX, r.minY + cy, color, thick)
        F.set_draw_line(o.boxLines[5], r.minX, r.maxY - cy, r.minX, r.maxY, color, thick)
        F.set_draw_line(o.boxLines[6], r.minX, r.maxY, r.minX + cx, r.maxY, color, thick)
        F.set_draw_line(o.boxLines[7], r.maxX, r.maxY - cy, r.maxX, r.maxY, color, thick)
        F.set_draw_line(o.boxLines[8], r.maxX - cx, r.maxY, r.maxX, r.maxY, color, thick)
        used = 8
    else
        F.set_draw_line(o.boxLines[1], r.minX, r.minY, r.maxX, r.minY, color, thick)
        F.set_draw_line(o.boxLines[2], r.maxX, r.minY, r.maxX, r.maxY, color, thick)
        F.set_draw_line(o.boxLines[3], r.maxX, r.maxY, r.minX, r.maxY, color, thick)
        F.set_draw_line(o.boxLines[4], r.minX, r.maxY, r.minX, r.minY, color, thick)
        used = 4
    end
    for i = used + 1, #o.boxLines do
        local line = o.boxLines[i]
        if line.Visible then
            line.Visible = false
        end
    end
end

function F.lerp_color(a, b, t)
    t = math.clamp(t, 0, 1)
    return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end

function F.update_esp_one(player, cam, origin)
    if player == LP then
        return
    end
    local char = player.Character
    if not char or not char.Parent then
        return
    end
    if CFG.EspEnemyOnly then
        if not F.enemy(player) then
            local existing = espByModel[char]
            if existing then
                F.hide_esp(existing)
            end
            return
        end
    elseif not F.alive(player) then
        local existing = espByModel[char]
        if existing then
            F.hide_esp(existing)
        end
        return
    end
    local o = espByModel[char]
    if not o then
        o = F.new_esp()
        espByModel[char] = o
    end
    if not CFG.ESP then
        F.hide_esp(o)
        return
    end
    local pref = charRefs[player]
    local hrp = (pref and pref.hrp and pref.hrp.Parent and pref.hrp) or F.hrp_of(char)
    if not hrp then
        F.hide_esp(o)
        return
    end
    local dist = (hrp.Position - origin).Magnitude
    if dist > CFG.EspMaxDistance then
        F.hide_esp(o)
        return
    end
    local raw = F.compute_bounds(cam, char, o, hrp)
    if not raw then
        F.hide_esp(o)
        return
    end
    local r = raw
    if CFG.EspSmooth then
        local sm = o.smooth
        if not sm then
            sm = { minX = raw.minX, maxX = raw.maxX, minY = raw.minY, maxY = raw.maxY, headTopY = raw.headTopY }
            o.smooth = sm
        else
            local a = CFG.EspSmoothAlpha
            sm.minX += (raw.minX - sm.minX) * a
            sm.maxX += (raw.maxX - sm.maxX) * a
            sm.minY += (raw.minY - sm.minY) * a
            sm.maxY += (raw.maxY - sm.maxY) * a
            sm.headTopY += (raw.headTopY - sm.headTopY) * a
        end
        local out = o.smoothOut or {}
        o.smoothOut = out
        out.minX, out.maxX, out.minY, out.maxY = sm.minX, sm.maxX, sm.minY, sm.maxY
        out.centerX = (sm.minX + sm.maxX) * 0.5
        out.headTopY = sm.headTopY
        r = out
    end
    o.hidden = false
    local vis = true
    if CFG.EspVisibleCheck then
        local visMax = CFG.EspVisMaxDist
        if type(visMax) == "number" and dist > visMax then
            vis = false
        else
            vis = F.cached_visible(player, origin, hrp.Position)
        end
    end
    local color = vis and CFG.EspColorVisible or CFG.EspColorHidden
    if CFG.EspBox then
        F.draw_box(o, r, color)
    else
        for i = 1, #o.boxLines do
            if o.boxLines[i].Visible then
                o.boxLines[i].Visible = false
            end
        end
    end
    local labelSize = CFG.EspTextSize or ESPC.LabelSize
    if CFG.EspShowName then
        o.name.Visible, o.name.Size = true, labelSize + 1
        o.name.Color = CFG.EspNameUseTier and color or CFG.EspColorName
        if o.lastName ~= player.Name then
            o.lastName = player.Name
            o.name.Text = player.Name
        end
        F.set_text_pos(o.name, r.centerX, r.headTopY - (labelSize + 1) - 4)
    else
        o.name.Visible = false
    end
    local ly = r.maxY + ESPC.StackGap
    if CFG.EspShowDistance then
        o.dist.Visible, o.dist.Size, o.dist.Color = true, labelSize, CFG.EspColorDist
        local dm = floor(dist)
        if o.lastDist ~= dm then
            o.lastDist = dm
            o.dist.Text = dm .. "m"
        end
        F.set_text_pos(o.dist, r.centerX, ly)
        ly += labelSize * ESPC.LineStep + ESPC.StackGap
    else
        o.dist.Visible = false
    end
    if CFG.EspShowWeapon then
        local wname = F.equipped_weapon(player)
        if wname then
            o.weapon.Visible, o.weapon.Size = true, labelSize
            o.weapon.Color = CFG.EspColorWeapon
            if o.lastWeapon ~= wname then
                o.lastWeapon = wname
                o.weapon.Text = "[" .. wname .. "]"
            end
            F.set_text_pos(o.weapon, r.centerX, ly)
            ly += labelSize * ESPC.LineStep + ESPC.StackGap
        else
            o.weapon.Visible = false
        end
    else
        o.weapon.Visible = false
    end
    if CFG.EspShowStates then
        local selfRef = F.char_ref(player)
        local hum = selfRef and selfRef.hum
        local states = F.player_states(player, char, hum, o.states)
        o.states = states
        local sx = r.maxX + 6
        if sx + 52 > vpX then
            sx = r.minX - 6 - 48
        end
        if sx < 2 then
            sx = 2
        end
        local n = 0
        for i, label in states do
            local chip = o.chips[i]
            if not chip then
                break
            end
            local chipSize = CFG.EspStateSize or 12
            local chipStep = chipSize * 0.92
            local y = r.minY + (i - 1) * chipStep
            if y + chipSize > vpY then
                break
            end
            chip.Visible, chip.Size, chip.Center = true, chipSize, false
            if chip.Text ~= label then
                chip.Text = label
            end
            chip.Color = STATE_COLOR[label] or CFG.EspColorState
            F.set_text_pos(chip, sx, y)
            chip.ZIndex = 24
            n = i
        end
        for i = n + 1, #o.chips do
            if o.chips[i].Visible then
                o.chips[i].Visible = false
            end
        end
        o.chipsOn = n > 0
    elseif o.chipsOn then
        for i = 1, #o.chips do
            o.chips[i].Visible = false
        end
        o.chipsOn = false
    end
    if CFG.EspShowHotbar then
        local slots = F.player_hotbar_slots(player)
        for i = 1, #o.hotbar do
            local text = o.hotbar[i]
            local slot = slots[i]
            if slot then
                text.Visible, text.Size = true, labelSize - 1
                text.Color = (CFG.EspHotbarRarityColor and slot.color) or CFG.EspColorDist
                if text.Text ~= slot.text then
                    text.Text = slot.text
                end
                F.set_text_pos(text, r.centerX, ly)
                ly += (labelSize - 1) * ESPC.LineStep + ESPC.StackGap
            else
                text.Visible = false
            end
        end
    else
        for i = 1, #o.hotbar do
            o.hotbar[i].Visible = false
        end
    end
    if CFG.EspHpBar then
        local frac = F.limb_hp_frac(char, o)
        local barW, x, y, h = 3, r.minX - 6, r.minY, r.maxY - r.minY
        o.hpOutline.Visible, o.hpOutline.Position, o.hpOutline.Size = true, V2(x - 1, y - 1), V2(barW + 2, h + 2)
        o.hpBg.Visible, o.hpBg.Position, o.hpBg.Size = true, V2(x, y), V2(barW, h)
        o.hpFill.Visible, o.hpFill.Color = true, F.lerp_color(CFG.EspHpLow, CFG.EspHpHigh, frac)
        o.hpFill.Size = V2(barW, h * frac)
        o.hpFill.Position = V2(x, y + h * (1 - frac))
    else
        o.hpOutline.Visible, o.hpBg.Visible, o.hpFill.Visible = false, false, false
    end
end

local chamByChar = {}
local chamSeen = {}
local CHAMS_CAP = 31

local chamHolderCache = nil
function F.cham_holder()
    if chamHolderCache and chamHolderCache.Parent then
        return chamHolderCache
    end
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then
            chamHolderCache = h
            return h
        end
    end
    chamHolderCache = LP:FindFirstChild("PlayerGui") or LP
    return chamHolderCache
end

function F.chams_off()
    for char, hl in chamByChar do
        pcall(function()
            hl:Destroy()
        end)
        chamByChar[char] = nil
    end
    table.clear(chamSeen)
end

function F.update_chams(origin)
    if not CFG.Chams then
        if next(chamByChar) then
            F.chams_off()
        end
        return
    end
    table.clear(chamSeen)
    local maxd = CFG.ChamsMaxDistance
    if type(maxd) ~= "number" or maxd < 1 then
        maxd = 700
    end
    local fillT = CFG.ChamsFillTrans
    if type(fillT) ~= "number" then
        fillT = 0.55
    end
    local outT = CFG.ChamsOutline and (CFG.ChamsOutlineTrans or 0.2) or 1
    local visCol = CFG.ChamsColorVisible
    local hidCol = CFG.ChamsColorHidden
    local nOn = 0
    local parent = F.cham_holder()
    for i = 1, rosterN do
        if nOn >= CHAMS_CAP then
            break
        end
        local player = roster[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and F.hrp_of(char)
            if hrp and hrp.Parent and (not CFG.ChamsEnemyOnly or F.enemy(player)) then
                local dist = (hrp.Position - origin).Magnitude
                if dist <= maxd then
                    local vis = true
                    local visMax = CFG.ChamsVisMaxDist
                    if type(visMax) == "number" and dist > visMax then
                        vis = false
                    else
                        vis = F.cached_visible(player, origin, hrp.Position)
                    end
                    local col = vis and visCol or hidCol
                    local hl = chamByChar[char]
                    if not (hl and hl.Parent) then
                        hl = Instance.new("Highlight")
                        hl.Name = "CWChams"
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = char
                        hl.Parent = parent
                        chamByChar[char] = hl
                    else
                        if hl.Adornee ~= char then
                            hl.Adornee = char
                        end
                        hl.Enabled = true
                    end
                    if hl.FillColor ~= col then
                        hl.FillColor = col
                    end
                    if hl.OutlineColor ~= col then
                        hl.OutlineColor = col
                    end
                    if hl.FillTransparency ~= fillT then
                        hl.FillTransparency = fillT
                    end
                    if hl.OutlineTransparency ~= outT then
                        hl.OutlineTransparency = outT
                    end
                    chamSeen[char] = true
                    nOn += 1
                end
            end
        end
    end
    for char, hl in chamByChar do
        if not chamSeen[char] then
            pcall(function()
                hl:Destroy()
            end)
            chamByChar[char] = nil
        end
    end
end

function F.sweep_esp_models()
    local now = clock()
    if F.espSweepT and now - F.espSweepT < 1 then
        return
    end
    F.espSweepT = now
    local gen = (F.espLiveGen or 0) + 1
    F.espLiveGen = gen
    for i = 1, rosterN do
        local char = roster[i].Character
        local o = char and espByModel[char]
        if o then
            o.liveGen = gen
        end
    end
    for model, o in espByModel do
        if o.liveGen ~= gen then
            F.free_esp(o)
            espByModel[model] = nil
        end
    end
end

do
    local di = DrawingImmediate
    if type(di) ~= "table" and getgenv then
        di = getgenv().DrawingImmediate
    end
    if type(di) == "table" and type(di.GetPaint) == "function" and type(di.Line) == "function" then
        local ok, sig = pcall(di.GetPaint, 40)
        if ok and sig and type(sig.Connect) == "function" then
            DILib = di
            useDI = true
            F.bind(sig:Connect(function()
                if F.paint_overlay then
                    F.paint_overlay()
                end
            end))
        end
    end
end

local fovCircle, muzzleLine, spoofLineA, spoofLineB, abFovCircle, chDot
local RETICLE_MAX = 16
local reticleLines = {}
local CH_MAX = 8
local chLines = {}
if not useDI then
    fovCircle = Drawing.new("Circle")
    fovCircle.NumSides = 32
    fovCircle.ZIndex = 10
    fovCircle.Visible = false
    abFovCircle = Drawing.new("Circle")
    abFovCircle.NumSides = 32
    abFovCircle.ZIndex = 11
    abFovCircle.Visible = false
    chDot = Drawing.new("Circle")
    chDot.Filled = true
    chDot.NumSides = 12
    chDot.ZIndex = 46
    chDot.Visible = false
    muzzleLine = Drawing.new("Line")
    muzzleLine.ZIndex = 44
    muzzleLine.Visible = false
    spoofLineA = Drawing.new("Line")
    spoofLineA.ZIndex = 43
    spoofLineA.Visible = false
    spoofLineB = Drawing.new("Line")
    spoofLineB.ZIndex = 45
    spoofLineB.Visible = false
    for i = 1, RETICLE_MAX do
        local line = Drawing.new("Line")
        line.ZIndex = 45
        line.Visible = false
        reticleLines[i] = line
    end
    for i = 1, CH_MAX do
        local line = Drawing.new("Line")
        line.ZIndex = 46
        line.Visible = false
        chLines[i] = line
    end
end

local HIT_SOUNDS = {
    Fatality = 115982072912004,
    ["Minecraft XP"] = 15181891182,
    ["Minecraft Hit"] = 73571339886360,
    ["Minecraft Egg"] = 134530432300459,
    ["Minecraft Bow"] = 111481862692779,
    Click = 95635059379804,
    Bell = 124010691633262,
    Neverlose = 139452805868562,
    Primordial = 97511223764004,
}
local HIT_SOUND_ORDER = {
    "Fatality",
    "Minecraft XP",
    "Minecraft Hit",
    "Minecraft Egg",
    "Minecraft Bow",
    "Click",
    "Bell",
    "Neverlose",
    "Primordial",
}

local drawPool = { Line = {}, Circle = {} }
local TETRA = {
    verts = { V3(1, 1, 1), V3(1, -1, -1), V3(-1, 1, -1), V3(-1, -1, 1) },
    edges = { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 2, 3 }, { 2, 4 }, { 3, 4 } },
}
local particleSystems = {}
local tracers = {}
local TRACER_MAX = 20
local tracerLines = {}
if not useDI then
    for i = 1, TRACER_MAX do
        local line = Drawing.new("Line")
        line.ZIndex = 30
        line.Visible = false
        tracerLines[i] = line
    end
end

function F.acquire_draw(kind)
    local free = drawPool[kind]
    local obj = free[#free]
    if obj then
        free[#free] = nil
        obj.Visible = false
        return obj
    end
    obj = Drawing.new(kind)
    obj.ZIndex = 9
    obj.Visible = false
    return obj
end

function F.release_draw(kind, obj)
    obj.Visible = false
    local free = drawPool[kind]
    if #free < 512 then
        free[#free + 1] = obj
    else
        obj:Remove()
    end
end

function F.release_particle(particle)
    for _, drawing in particle.draw do
        F.release_draw(particle.kind, drawing)
    end
end

function F.tracer_alpha(age, life, fadeIn)
    if age < fadeIn then
        local t = age / fadeIn
        return t * t
    end
    local tail = life - fadeIn
    if tail <= 0.01 then
        return 0
    end
    local t = (age - fadeIn) / tail
    return (1 - t) * (1 - t)
end

function F.play_hit_sound()
    if not CFG.HitSound then
        return
    end
    local now = clock()
    if now - lastHitSoundAt < 0.04 then
        return
    end
    lastHitSoundAt = now
    local id = CFG.HitSoundId
    local preset = HIT_SOUNDS[CFG.HitSoundPreset]
    if preset then
        id = preset
    end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = clamp(CFG.HitSoundVolume or 3.5, 0, 10)
    s.PlaybackSpeed = clamp(CFG.HitSoundPitch or 1, 0.5, 2)
    s.Looped = false
    s.Parent = SoundService
    s:Play()
    Debris:AddItem(s, 4)
end

function F.spawn_particles(pos, normal)
    if not CFG.HitParticles then
        return
    end
    if #particleSystems >= (CFG.HitParticleMaxSys or 4) then
        local old = table.remove(particleSystems, 1)
        if old then
            for _, particle in old.parts do
                F.release_particle(particle)
            end
        end
    end
    normal = (typeof(normal) == "Vector3" and normal.Magnitude > 0.01) and normal.Unit or V3(0, 1, 0)
    local right = normal:Cross(V3(0, 1, 0))
    if right.Magnitude < 0.01 then
        right = normal:Cross(V3(1, 0, 0))
    end
    right = right.Unit
    local fwd = normal:Cross(right).Unit
    local sys = { t = clock(), parts = {} }
    local count = clamp(CFG.HitParticleCount or 18, 8, 48)
    for _ = 1, count do
        local theta = rnd() * pi * 2
        local phi = acos(clamp(1 - rnd() * 1.85, -1, 1))
        local dir = normal * cos(phi) + right * (sin(phi) * cos(theta)) + fwd * (sin(phi) * sin(theta))
            + V3((rnd() - 0.5) * 0.35, (rnd() - 0.2) * 0.25, (rnd() - 0.5) * 0.35)
        if dir.Magnitude < 0.001 then
            dir = normal
        end
        dir = dir.Unit
        local z = rnd()
        local speed = (CFG.HitParticleSpdMin or 2) + z * ((CFG.HitParticleSpdMax or 32) - (CFG.HitParticleSpdMin or 2))
        local particle = {
            pos = pos + dir * rnd() * 0.12,
            vel = dir * speed + V3((rnd() - 0.5) * 5, rnd() * 4, (rnd() - 0.5) * 5),
            z = z,
            phase = rnd(),
            ang = rnd() * pi * 2,
            angVel = (rnd() - 0.5) * 4,
            scale = (CFG.HitParticleWireS or 0.4) * (0.6 + z * 0.8),
            draw = {},
            proj = { nil, nil, nil, nil },
        }
        if CFG.HitParticleType == "Wireframe" then
            particle.kind = "Line"
            if not useDI then
                for _ = 1, #TETRA.edges do
                    local line = F.acquire_draw("Line")
                    line.Thickness = 0.7
                    particle.draw[#particle.draw + 1] = line
                end
            end
        elseif CFG.HitParticleType == "Orbs" then
            particle.kind = "Circle"
            if not useDI then
                local circle = F.acquire_draw("Circle")
                circle.Filled = true
                circle.NumSides = 12
                particle.draw[1] = circle
            end
        else
            particle.kind = "Line"
            if not useDI then
                local line = F.acquire_draw("Line")
                line.Thickness = 1.5
                particle.draw[1] = line
            end
        end
        sys.parts[#sys.parts + 1] = particle
    end
    particleSystems[#particleSystems + 1] = sys
end

function F.update_particles(cam, dt)
    if not CFG.HitParticles or #particleSystems == 0 then
        return
    end
    local duration = CFG.HitParticleDur or 1.1
    local gy = CFG.HitParticleGrav or -32
    local now = clock()
    for si = #particleSystems, 1, -1 do
        local sys = particleSystems[si]
        local age = now - sys.t
        if age > duration then
            for pi = 1, #sys.parts do
                F.release_particle(sys.parts[pi])
            end
            local last = #particleSystems
            particleSystems[si] = particleSystems[last]
            particleSystems[last] = nil
        else
            local fadeIn = duration * 0.15
            local fadeOut = duration * 0.75
            local fade
            if age < fadeIn then
                local t = age / fadeIn
                fade = t * (2 - t)
            elseif age > fadeOut then
                local t = (age - fadeOut) / (duration - fadeOut)
                fade = (1 - t) * (1 - t)
            else
                fade = 1
            end
            local pulseT = (sin(age * 3.2) + 1) * 0.5
            local step = min(dt, 0.05)
            local drag = clamp(1 - step * 0.35, 0.55, 1)
            local parts = sys.parts
            for pi = 1, #parts do
                local particle = parts[pi]
                local vel = particle.vel
                particle.vel = V3(vel.X * drag, (vel.Y + gy * step) * drag, vel.Z * drag)
                vel = particle.vel
                particle.pos = particle.pos + vel * step
                particle.ang = particle.ang + particle.angVel * step
                particle._fade = fade
                particle._pulseT = pulseT
                particle._age = age
                if not useDI then
                local screen, onScreen = cam:WorldToViewportPoint(particle.pos)
                local opacity = ((CFG.HitParticleOpMin or 0.45) + ((CFG.HitParticleOpMax or 1) - (CFG.HitParticleOpMin or 0.45)) * particle.z) * fade
                local color = F.lerp_color(CFG.HitParticleColorA, CFG.HitParticleColorB, (pulseT + particle.phase) % 1)
                local trans = 1 - opacity
                if onScreen and screen.Z > 0 then
                    if CFG.HitParticleType == "Wireframe" then
                        local s = particle.scale * (0.85 + 0.15 * sin(age * 4 + particle.phase))
                        local ca, sa = cos(particle.ang), sin(particle.ang)
                        local proj = particle.proj
                        if not proj then
                            proj = { nil, nil, nil, nil }
                            particle.proj = proj
                        end
                        local verts = TETRA.verts
                        local ppos = particle.pos
                        for vi = 1, #verts do
                            local v = verts[vi]
                            local q, qo = cam:WorldToViewportPoint(V3(
                                ppos.X + (v.X * ca - v.Z * sa) * s,
                                ppos.Y + v.Y * s,
                                ppos.Z + (v.X * sa + v.Z * ca) * s
                            ))
                            proj[vi] = (qo and V2(q.X, q.Y)) or nil
                        end
                        local edges = TETRA.edges
                        for ei = 1, #edges do
                            local edge = edges[ei]
                            local line = particle.draw[ei]
                            local a, b = proj[edge[1]], proj[edge[2]]
                            if line and a and b then
                                line.Visible = true
                                line.Color = color
                                line.Thickness = 0.65 + particle.z * 0.45
                                line.Transparency = trans
                                line.From = a
                                line.To = b
                            elseif line then
                                line.Visible = false
                            end
                        end
                    elseif CFG.HitParticleType == "Orbs" then
                        local circle = particle.draw[1]
                        if circle then
                            circle.Visible = true
                            circle.Color = color
                            circle.Transparency = trans
                            circle.Position = V2(screen.X, screen.Y)
                            circle.Radius = max(0.45, (0.28 + particle.z * 0.62) * 17 / max(screen.Z, 1))
                        end
                    else
                        local line = particle.draw[1]
                        if line then
                            local tail = clamp(particle.vel.Magnitude * 0.035, 0.05, 0.9)
                            local q, qo = cam:WorldToViewportPoint(particle.pos - particle.vel.Unit * tail)
                            if qo then
                                line.Visible = true
                                line.Color = color
                                line.Transparency = trans
                                line.From = V2(screen.X, screen.Y)
                                line.To = V2(q.X, q.Y)
                            else
                                line.Visible = false
                            end
                        end
                    end
                else
                    for _, drawing in particle.draw do
                        drawing.Visible = false
                    end
                end
                end
            end
        end
    end
end

function F.hit_fx(fromPos, hitPos)
    if typeof(hitPos) ~= "Vector3" then
        return
    end
    F.play_hit_sound()
    local normal = V3(0, 1, 0)
    if typeof(fromPos) == "Vector3" and (hitPos - fromPos).Magnitude > 0.05 then
        normal = (hitPos - fromPos).Unit
    end
    F.spawn_particles(hitPos, normal)
    if CFG.ShotTracers and typeof(fromPos) == "Vector3" then
        tracers[#tracers + 1] = { a = fromPos, b = hitPos, t = clock() }
        if #tracers > 32 then
            tracers[1] = tracers[#tracers]
            tracers[#tracers] = nil
        end
    end
end

function F.prune_tracers(now)
    local life = CFG.TracerDuration or 1.4
    for i = #tracers, 1, -1 do
        if now - tracers[i].t > life then
            local last = #tracers
            tracers[i] = tracers[last]
            tracers[last] = nil
        end
    end
end

function F.update_tracers(cam, now)
    F.prune_tracers(now)
    if useDI then
        return
    end
    if not CFG.ShotTracers then
        for i = 1, #tracerLines do
            tracerLines[i].Visible = false
        end
        return
    end
    local li = 0
    for i = #tracers, 1, -1 do
        local tr = tracers[i]
        if li < TRACER_MAX then
            local p1 = cam:WorldToViewportPoint(tr.a)
            local p2 = cam:WorldToViewportPoint(tr.b)
            if p1.Z > 0 and p2.Z > 0 then
                li += 1
                local line = tracerLines[li]
                local age = now - tr.t
                local alpha = F.tracer_alpha(age, CFG.TracerDuration or 1.4, CFG.TracerFadeIn or 0.12)
                line.Visible = true
                line.Thickness = (CFG.TracerThickness or 0.9) + alpha * 0.5
                line.Color = CFG.TracerColor
                line.Transparency = 1 - alpha
                line.From = V2(p1.X, p1.Y)
                line.To = V2(p2.X, p2.Y)
            end
        end
    end
    for i = li + 1, #tracerLines do
        tracerLines[i].Visible = false
    end
end

function F.free_hit_fx()
    for _, sys in particleSystems do
        for _, particle in sys.parts do
            F.release_particle(particle)
        end
    end
    table.clear(particleSystems)
    table.clear(tracers)
    for i = 1, #tracerLines do
        tracerLines[i].Visible = false
        tracerLines[i]:Remove()
    end
    for _, kind in { "Line", "Circle" } do
        for _, obj in drawPool[kind] do
            obj:Remove()
        end
        table.clear(drawPool[kind])
    end
end

function F.tier_color(tier)
    if CFG.AimVisualColor then
        return CFG.AimVisualColor
    end
    if tier == 0 then
        return COL.TIER0
    elseif tier == 1 then
        return COL.TIER1
    elseif tier == 2 then
        return COL.TIER2
    end
    return COL.TIERX
end

local reticleColor = COL.TIER0
local reticleAlpha = 0.95

function F.reticle_seg(i, x1, y1, x2, y2, thickness, alpha)
    local op = alpha or reticleAlpha
    if useDI then
        DILib.Line(V2(x1, y1), V2(x2, y2), reticleColor, op, thickness)
        return
    end
    local line = reticleLines[i]
    if not line then
        return
    end
    line.Visible = true
    line.From = V2(x1, y1)
    line.To = V2(x2, y2)
    line.Thickness = thickness
    line.Color = reticleColor
    line.Transparency = 1 - op
end

function F.draw_reticle(cx, cy, color, now)
    if not useDI then
        for i = 1, #reticleLines do
            reticleLines[i].Visible = false
        end
    end
    local sc = CFG.AimVisualScale or 1
    local style = CFG.AimVisualStyle
    reticleColor = color
    reticleAlpha = 0.95
    local seg = F.reticle_seg

    if style == "Default" then
        local arm = 9 * sc
        seg(1, cx - arm, cy, cx + arm, cy, 1.4)
        seg(2, cx, cy - arm, cx, cy + arm, 1.4)
    elseif style == "CrossGap" then
        local gap = 5 * sc
        local arm = 9 * sc
        seg(1, cx - arm, cy, cx - gap, cy, 1.3)
        seg(2, cx + gap, cy, cx + arm, cy, 1.3)
        seg(3, cx, cy - arm, cx, cy - gap, 1.3)
        seg(4, cx, cy + gap, cx, cy + arm, 1.3)
    elseif style == "DefaultV2" then
        local spin = now * 2.8
        local gap = 4 * sc
        local arm = 8 * sc
        for i = 0, 3 do
            local ang = spin + i * pi * 0.5
            seg(i + 1, cx + cos(ang) * gap, cy + sin(ang) * gap, cx + cos(ang) * (gap + arm), cy + sin(ang) * (gap + arm), 1.35)
        end
    else
        local pulse = 0.5 + 0.5 * sin(now * 5.8)
        local r = (6.5 + pulse * 3.5) * sc
        local outerSpin = now * 1.6
        local idx = 0
        for i = 0, 5 do
            local a1 = outerSpin + i * pi / 3
            local a2 = outerSpin + (i + 1) * pi / 3
            idx += 1
            seg(idx, cx + cos(a1) * r, cy + sin(a1) * r, cx + cos(a2) * r, cy + sin(a2) * r, 1.15 + pulse * 0.35)
        end
        local innerSpin = -now * 3.4
        local ig = (2.5 + pulse * 1.2) * sc
        local ia = (5.5 + pulse * 1.8) * sc
        for i = 0, 3 do
            local ang = innerSpin + i * pi * 0.5
            idx += 1
            seg(idx, cx + cos(ang) * ig, cy + sin(ang) * ig, cx + cos(ang) * (ig + ia), cy + sin(ang) * (ig + ia), 1.5)
        end
        local accSpin = now * 4.2
        local tr = r + 2.2 + pulse * 1.5
        for i = 0, 5 do
            if idx >= RETICLE_MAX then
                break
            end
            local ang = accSpin + i * pi / 3
            idx += 1
            seg(idx, cx + cos(ang) * tr, cy + sin(ang) * tr, cx + cos(ang) * (tr + 2.5), cy + sin(ang) * (tr + 2.5), 0.9, reticleAlpha * 0.55 * pulse)
        end
    end
end

function F.hide_ch()
    if useDI then
        return
    end
    for i = 1, #chLines do
        chLines[i].Visible = false
    end
    if chDot then
        chDot.Visible = false
        chDot.Filled = true
    end
end

function F.ch_seg(i, x1, y1, x2, y2, color, thick, op)
    if useDI then
        DILib.Line(V2(x1, y1), V2(x2, y2), color, op, thick)
        return
    end
    local line = chLines[i]
    if not line then
        return
    end
    line.Visible = true
    line.From = V2(x1, y1)
    line.To = V2(x2, y2)
    line.Color = color
    line.Thickness = thick
    line.Transparency = 1 - op
end

function F.paint_center_mark(style, color, size, gap, thick, op, ox, oy)
    F.hide_ch()
    local cx, cy = ox or (vpX * 0.5), oy or (vpY * 0.5)
    style = style or "Cross"
    color = color or COL.WHITE
    size = size or 8
    gap = gap or 0
    thick = thick or 1.2
    op = clamp(op or 0.95, 0, 1)
    if style == "Dot" then
        local r = math.max(1, size * 0.28)
        if useDI then
            DILib.FilledCircle(V2(cx, cy), r, color, 12, op)
        elseif chDot then
            chDot.Visible = true
            chDot.Filled = true
            chDot.Position = V2(cx, cy)
            chDot.Radius = r
            chDot.Color = color
            chDot.Transparency = 1 - op
        end
        return
    end
    if style == "Circle" then
        if useDI then
            DILib.Circle(V2(cx, cy), size, color, op, 24, thick)
        elseif chDot then
            chDot.Visible = true
            chDot.Filled = false
            chDot.Position = V2(cx, cy)
            chDot.Radius = size
            chDot.Color = color
            chDot.Transparency = 1 - op
            chDot.Thickness = thick
        end
        return
    end
    local g = (style == "Cross") and 0 or gap
    F.ch_seg(1, cx - size, cy, cx - g, cy, color, thick, op)
    F.ch_seg(2, cx + g, cy, cx + size, cy, color, thick, op)
    if style ~= "T" then
        F.ch_seg(3, cx, cy - size, cx, cy - g, color, thick, op)
    end
    F.ch_seg(4, cx, cy + g, cx, cy + size, color, thick, op)
end

local muzzleState = { att = nil, tool = false, fp = false, vm = nil }

function F.muzzle_att(root)
    if not root then
        return nil
    end
    local handle = root:FindFirstChild("Handle")
    if handle then
        local named = handle:FindFirstChild("Muzzle1") or handle:FindFirstChild("Muzzle")
        if named and named:IsA("Attachment") then
            return named
        end
    end
    return nil
end

function F.muzzle_cframe()
    Cam = Workspace.CurrentCamera
    local char = visF.myChar or LP.Character
    local tool = visF.tool or (char and char:FindFirstChildWhichIsA("Tool"))
    local firstPerson = Cam and (Cam.CFrame.Position - Cam.Focus.Position).Magnitude <= 0.75
    local att = muzzleState.att
    if att and att.Parent and muzzleState.tool == tool and muzzleState.fp == firstPerson then
        return att.WorldCFrame
    end
    if firstPerson then
        local vm = muzzleState.vm
        if not (vm and vm.Parent) then
            vm = nil
            local ignore = visF.ignoreFolder or Workspace:FindFirstChild("Ignore")
            if ignore then
                local children = ignore:GetChildren()
                for i = 1, #children do
                    local child = children[i]
                    if string.find(child.Name, "Viewmodel", 1, true) then
                        vm = child
                        break
                    end
                end
            end
            muzzleState.vm = vm
        end
        att = F.muzzle_att(vm)
        if att then
            muzzleState.att, muzzleState.tool, muzzleState.fp = att, tool, firstPerson
            return att.WorldCFrame
        end
    end
    att = F.muzzle_att(tool)
    if att then
        muzzleState.att, muzzleState.tool, muzzleState.fp = att, tool, firstPerson
        return att.WorldCFrame
    end
    muzzleState.att, muzzleState.tool, muzzleState.fp = nil, tool, firstPerson
    return Cam and Cam.CFrame
end

function F.vm_aim_offset()
    if not CFG.VmAim then
        return
    end
    local a = 0
    if AimCtrl and type(AimCtrl.getAlpha) == "function" then
        local ok, v = pcall(AimCtrl.getAlpha)
        if ok and type(v) == "number" then
            a = v
        end
    end
    if a < 0.02 then
        return
    end
    local vm = muzzleState.vm
    if not (vm and vm.Parent) then
        F.muzzle_cframe()
        vm = muzzleState.vm
    end
    if not vm then
        return
    end
    local hrp = vm:FindFirstChild("HumanoidRootPart") or vm.PrimaryPart
    if not hrp then
        return
    end
    local off = CFrame.new(CFG.VmX or 0, CFG.VmY or 0, CFG.VmZ or 0)
        * CFrame.Angles(math.rad(CFG.VmPitch or 0), math.rad(CFG.VmYaw or 0), math.rad(CFG.VmRoll or 0))
    hrp.CFrame = hrp.CFrame * CFrame.identity:Lerp(off, a)
end

function F.crosshair_screen()
    local cx, cy = vpX * 0.5, vpY * 0.5
    if not (CFG.CrosshairSyncAim and F.is_aiming() and Cam) then
        return cx, cy
    end
    if CFG.CrosshairAim then
        return cx, cy
    end
    local mcf = F.muzzle_cframe()
    if not mcf then
        return cx, cy
    end
    local origin, dir = mcf.Position, mcf.LookVector
    local hit = Workspace:Raycast(origin, dir * 2500, visParams)
    local world = hit and hit.Position or (origin + dir * 500)
    local sp = Cam:WorldToViewportPoint(world)
    if sp.Z <= 0 then
        return cx, cy
    end
    local pad = CFG.CrosshairSyncPad or 0
    local px, py = sp.X, sp.Y
    if pad > 0 then
        local dx, dy = px - cx, py - cy
        local mag = math.sqrt(dx * dx + dy * dy)
        if mag > pad then
            local s = (mag - pad) / mag
            px, py = cx + dx * s, cy + dy * s
        else
            px, py = cx, cy
        end
    end
    return px, py
end

function F.vm_style_restore()
    if not vmSkin then
        return
    end
    for i = 1, #vmSkin.parts do
        local rec = vmSkin.parts[i]
        if rec.inst and rec.inst.Parent then
            rec.inst.Material = rec.mat
            rec.inst.Color = rec.col
            rec.inst.Transparency = rec.tr
        end
    end
    if vmSkin.hl then
        pcall(function()
            vmSkin.hl:Destroy()
        end)
    end
    vmSkin = nil
end

function F.vm_style_step()
    local need = CFG.VmColorOn or CFG.VmMatOn or CFG.VmOutline
    if not need then
        F.vm_style_restore()
        return
    end
    local vm = muzzleState.vm
    if not (vm and vm.Parent) then
        F.muzzle_cframe()
        vm = muzzleState.vm
    end
    if not vm then
        F.vm_style_restore()
        return
    end
    local sig = tostring(CFG.VmColorOn) .. tostring(CFG.VmMatOn) .. tostring(CFG.VmOutline) .. tostring(CFG.VmMaterial) .. tostring(CFG.VmTransparency) .. tostring(CFG.VmColor) .. tostring(CFG.VmHlFill) .. tostring(CFG.VmHlOutline)
    if vmSkin and vmSkin.model == vm and vmSkin.sig == sig then
        return
    end
    if not vmSkin or vmSkin.model ~= vm then
        F.vm_style_restore()
        vmSkin = { model = vm, parts = {} }
        for _, d in vm:GetDescendants() do
            if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
                vmSkin.parts[#vmSkin.parts + 1] = { inst = d, mat = d.Material, col = d.Color, tr = d.Transparency }
            end
        end
        local hl = Instance.new("Highlight")
        hl.Adornee = vm
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = vm
        vmSkin.hl = hl
    end
    vmSkin.sig = sig
    local okMat, mat = pcall(function()
        return Enum.Material[CFG.VmMaterial]
    end)
    if not okMat or not mat then
        mat = Enum.Material.ForceField
    end
    for i = 1, #vmSkin.parts do
        local rec = vmSkin.parts[i]
        local d = rec.inst
        if d and d.Parent then
            if CFG.VmMatOn then
                d.Material = mat
            end
            if CFG.VmColorOn then
                d.Color = CFG.VmColor
            end
            local tr = CFG.VmTransparency or 0
            if tr > 0 and rec.tr < 1 then
                d.Transparency = tr
            elseif rec.tr < 1 then
                d.Transparency = rec.tr
            end
        end
    end
    local hl = vmSkin.hl
    if hl then
        if CFG.VmOutline then
            hl.Enabled = true
            hl.FillTransparency = 0.72
            hl.OutlineTransparency = 0.28
            hl.FillColor = CFG.VmHlFill
            hl.OutlineColor = CFG.VmHlOutline
        else
            hl.Enabled = false
        end
    end
end

local paintState = { cam = nil, now = 0, muzzlePos = nil }

function F.hide_aim_draw()
    if useDI then
        return
    end
    if fovCircle then
        fovCircle.Visible = false
    end
    if muzzleLine then
        muzzleLine.Visible = false
    end
    if spoofLineA then
        spoofLineA.Visible = false
    end
    if spoofLineB then
        spoofLineB.Visible = false
    end
    for i = 1, #reticleLines do
        reticleLines[i].Visible = false
    end
    if abFovCircle then
        abFovCircle.Visible = false
    end
    F.hide_ch()
end

function F.paint_world_line(fromPos, toPos, color, thick, opacity)
    local cam = paintState.cam
    if not cam then
        return
    end
    local a = cam:WorldToViewportPoint(fromPos)
    local b = cam:WorldToViewportPoint(toPos)
    if a.Z <= 0 or b.Z <= 0 then
        return
    end
    if useDI then
        DILib.Line(V2(a.X, a.Y), V2(b.X, b.Y), color, opacity, thick)
    end
end

function F.paint_overlay()
    local cam = paintState.cam
    if not cam then
        return
    end
    local now = paintState.now
    local muzzlePos = paintState.muzzlePos
    if (CFG.FovCircle or CFG.ShowFOV) and CFG.SilentAim then
        local radius = F.screen_fov_radius()
        local pos = V2(vpX * 0.5, vpY * 0.5)
        local color = CFG.FovCircleColor or CFG.FOVColor or COL.WHITE
        local op = CFG.FovCircleTrans or 0.6
        local thick = CFG.FovCircleThick or 1
        if useDI then
            if CFG.FovCircleFilled then
                DILib.FilledCircle(pos, radius, color, 32, op)
            else
                DILib.Circle(pos, radius, color, op, 32, thick)
            end
        else
            fovCircle.Visible = true
            fovCircle.Radius = radius
            fovCircle.Position = pos
            fovCircle.Color = color
            fovCircle.Transparency = 1 - op
            fovCircle.Thickness = thick
            fovCircle.Filled = CFG.FovCircleFilled == true
        end
    elseif not useDI then
        fovCircle.Visible = false
    end

    if CFG.Aimbot and CFG.AimbotShowFOV then
        local radius = F.fov_px(CFG.AimbotFOV)
        local pos = V2(vpX * 0.5, vpY * 0.5)
        local color = CFG.AimbotFovColor or COL.WHITE
        local op = CFG.AimbotFovTrans or 0.55
        local thick = CFG.AimbotFovThick or 1
        if useDI then
            DILib.Circle(pos, radius, color, op, 32, thick)
        elseif abFovCircle then
            abFovCircle.Visible = true
            abFovCircle.Radius = radius
            abFovCircle.Position = pos
            abFovCircle.Color = color
            abFovCircle.Transparency = 1 - op
            abFovCircle.Thickness = thick
            abFovCircle.Filled = false
        end
    elseif not useDI and abFovCircle then
        abFovCircle.Visible = false
    end

    if not useDI then
        muzzleLine.Visible = false
        spoofLineA.Visible = false
        spoofLineB.Visible = false
    end
    if CFG.SilentAim and CFG.MuzzleVisual and saTgt and saTgt.pos then
        if not muzzlePos then
            muzzlePos = Cam and Cam.CFrame.Position
        end
        if muzzlePos then
            local spoofed = saTgt.spoof and (saTgt.spoof - muzzlePos).Magnitude > 0.05
            if useDI then
                if spoofed then
                    F.paint_world_line(muzzlePos, saTgt.spoof, COL.SPOOF_A, 1.4, 0.3)
                    F.paint_world_line(saTgt.spoof, saTgt.pos, COL.SPOOF_B, 2.2, 0.2)
                else
                    F.paint_world_line(muzzlePos, saTgt.pos, CFG.MuzzleLineColor, CFG.MuzzleLineThick, CFG.MuzzleLineTrans or 0.15)
                end
            else
                local mScreen = cam:WorldToViewportPoint(muzzlePos)
                local tScreen = cam:WorldToViewportPoint(saTgt.pos)
                local mFront = mScreen.Z > 0
                local tFront = tScreen.Z > 0
                if not spoofed then
                    if mFront and tFront then
                        muzzleLine.Visible = true
                        muzzleLine.Color = CFG.MuzzleLineColor
                        muzzleLine.Thickness = CFG.MuzzleLineThick
                        muzzleLine.Transparency = 1 - (CFG.MuzzleLineTrans or 0.15)
                        muzzleLine.From = V2(mScreen.X, mScreen.Y)
                        muzzleLine.To = V2(tScreen.X, tScreen.Y)
                    end
                else
                    local sScreen = cam:WorldToViewportPoint(saTgt.spoof)
                    local sFront = sScreen.Z > 0
                    if mFront and sFront then
                        spoofLineA.Visible = true
                        spoofLineA.Color = COL.SPOOF_A
                        spoofLineA.Thickness = 1.4
                        spoofLineA.Transparency = 0.7
                        spoofLineA.From = V2(mScreen.X, mScreen.Y)
                        spoofLineA.To = V2(sScreen.X, sScreen.Y)
                    end
                    if sFront and tFront then
                        spoofLineB.Visible = true
                        spoofLineB.Color = COL.SPOOF_B
                        spoofLineB.Thickness = 2.2
                        spoofLineB.Transparency = 0.8
                        spoofLineB.From = V2(sScreen.X, sScreen.Y)
                        spoofLineB.To = V2(tScreen.X, tScreen.Y)
                    end
                    if not spoofLineA.Visible and not spoofLineB.Visible and mFront and tFront then
                        muzzleLine.Visible = true
                        muzzleLine.Color = CFG.MuzzleLineColor
                        muzzleLine.Thickness = CFG.MuzzleLineThick
                        muzzleLine.Transparency = 1 - (CFG.MuzzleLineTrans or 0.15)
                        muzzleLine.From = V2(mScreen.X, mScreen.Y)
                        muzzleLine.To = V2(tScreen.X, tScreen.Y)
                    end
                end
            end
        end
    end

    if CFG.SilentAim and CFG.AimVisuals and saTgt and saTgt.pos then
        local tScreen = cam:WorldToViewportPoint(saTgt.pos)
        if tScreen.Z > 0 then
            F.draw_reticle(tScreen.X, tScreen.Y, F.tier_color(saTgt.tier), now)
        elseif not useDI then
            for i = 1, #reticleLines do
                reticleLines[i].Visible = false
            end
        end
    elseif not useDI then
        for i = 1, #reticleLines do
            reticleLines[i].Visible = false
        end
    end

    if useDI and CFG.ShotTracers then
        local life = CFG.TracerDuration or 1.4
        local fadeIn = CFG.TracerFadeIn or 0.12
        local n = min(#tracers, TRACER_MAX)
        for i = 1, n do
            local tr = tracers[i]
            local age = now - tr.t
            local alpha = F.tracer_alpha(age, life, fadeIn)
            F.paint_world_line(tr.a, tr.b, CFG.TracerColor, (CFG.TracerThickness or 0.9) + alpha * 0.5, alpha)
        end
    end

    if useDI and CFG.HitParticles then
        local duration = CFG.HitParticleDur or 1.1
        for si = 1, #particleSystems do
            local sys = particleSystems[si]
            local age = now - sys.t
            if age <= duration then
                local parts = sys.parts
                for pi = 1, #parts do
                    local particle = parts[pi]
                    local fade = particle._fade or 1
                    local pulseT = particle._pulseT or 0
                    local opacity = ((CFG.HitParticleOpMin or 0.45) + ((CFG.HitParticleOpMax or 1) - (CFG.HitParticleOpMin or 0.45)) * particle.z) * fade
                    local color = F.lerp_color(CFG.HitParticleColorA, CFG.HitParticleColorB, (pulseT + particle.phase) % 1)
                    local screen, onScreen = cam:WorldToViewportPoint(particle.pos)
                    if onScreen and screen.Z > 0 then
                        if CFG.HitParticleType == "Wireframe" then
                            local s = particle.scale * (0.85 + 0.15 * sin((particle._age or age) * 4 + particle.phase))
                            local ca, sa = cos(particle.ang), sin(particle.ang)
                            local ppos = particle.pos
                            local verts = TETRA.verts
                            local proj = particle.proj
                            if not proj then
                                proj = { nil, nil, nil, nil }
                                particle.proj = proj
                            end
                            for vi = 1, #verts do
                                local v = verts[vi]
                                local q, qo = cam:WorldToViewportPoint(V3(
                                    ppos.X + (v.X * ca - v.Z * sa) * s,
                                    ppos.Y + v.Y * s,
                                    ppos.Z + (v.X * sa + v.Z * ca) * s
                                ))
                                proj[vi] = (qo and V2(q.X, q.Y)) or nil
                            end
                            local edges = TETRA.edges
                            local thick = 0.65 + particle.z * 0.45
                            for ei = 1, #edges do
                                local edge = edges[ei]
                                local a, b = proj[edge[1]], proj[edge[2]]
                                if a and b then
                                    DILib.Line(a, b, color, opacity, thick)
                                end
                            end
                        elseif CFG.HitParticleType == "Orbs" then
                            local radius = max(0.45, (0.28 + particle.z * 0.62) * 17 / max(screen.Z, 1))
                            DILib.FilledCircle(V2(screen.X, screen.Y), radius, color, 12, opacity)
                        else
                            local tail = clamp(particle.vel.Magnitude * 0.035, 0.05, 0.9)
                            local q, qo = cam:WorldToViewportPoint(particle.pos - particle.vel.Unit * tail)
                            if qo then
                                DILib.Line(V2(screen.X, screen.Y), V2(q.X, q.Y), color, opacity, 1.5)
                            end
                        end
                    end
                end
            end
        end
    end

    local ads = F.is_aiming()
    if CFG.Crosshair and not (CFG.CrosshairHideAds and ads) then
        local ox, oy = F.crosshair_screen()
        F.paint_center_mark(
            CFG.CrosshairStyle or "Cross",
            CFG.CrosshairColor,
            CFG.CrosshairSize or 8,
            CFG.CrosshairGap or 3,
            CFG.CrosshairThick or 1.2,
            CFG.CrosshairTrans or 0.95,
            ox,
            oy
        )
    else
        F.hide_ch()
    end
end

local namedModCache = {}
function F.find_named_mod(root, name)
    if not root then
        return nil
    end
    local hit = namedModCache[name]
    if hit and hit.Parent then
        return hit
    end
    local d = root:FindFirstChild(name)
    if d and d:IsA("ModuleScript") then
        namedModCache[name] = d
        return d
    end
    local ok, desc = pcall(root.GetDescendants, root)
    if not ok or type(desc) ~= "table" then
        return nil
    end
    for i = 1, #desc do
        local x = desc[i]
        if x.Name == name and x:IsA("ModuleScript") then
            namedModCache[name] = x
            return x
        end
    end
    return nil
end

function F.collect_str_consts(fn, depth)
    local out = {}
    if type(fn) ~= "function" then
        return out
    end
    if type(debug.getconstants) == "function" then
        local ok, consts = pcall(debug.getconstants, fn)
        if ok and type(consts) == "table" then
            for _, c in consts do
                if type(c) == "string" then
                    out[#out + 1] = c
                end
            end
        end
    elseif type(debug.getconstant) == "function" then
        for i = 1, 96 do
            local ok, c = pcall(debug.getconstant, fn, i)
            if not ok then
                break
            end
            if type(c) == "string" then
                out[#out + 1] = c
            end
        end
    end
    if (depth or 1) > 0 and type(debug.getproto) == "function" then
        for i = 1, 6 do
            local ok, proto = pcall(debug.getproto, fn, i)
            if not ok or type(proto) ~= "function" then
                break
            end
            local inner = F.collect_str_consts(proto, 0)
            for j = 1, #inner do
                out[#out + 1] = inner[j]
            end
        end
    end
    return out
end

function F.has_str_const(fn, s)
    local consts = F.collect_str_consts(fn)
    for i = 1, #consts do
        if consts[i] == s then
            return true
        end
    end
    return false
end

function F.is_volley_fn(fn)
    return F.has_str_const(fn, "encodeFire") or F.has_str_const(fn, "beginDischarge")
end

function F.export_matching(mod, pred)
    if type(mod) ~= "table" then
        return nil, nil
    end
    for k, v in mod do
        if type(k) == "string" and type(v) == "function" and pred(v, k) then
            return v, k
        end
    end
    return nil, nil
end

function F.key_from_caller(mod, caller, pred)
    if type(mod) ~= "table" or type(caller) ~= "function" then
        return nil, nil
    end
    local consts = F.collect_str_consts(caller)
    local hitFn, hitKey, nHit = nil, nil, 0
    for i = 1, #consts do
        local s = consts[i]
        local fn = mod[s]
        if type(fn) == "function" and (not pred or pred(fn, s)) then
            nHit += 1
            hitFn, hitKey = fn, s
        end
    end
    if nHit == 1 then
        return hitFn, hitKey
    end
    return nil, nil
end

function F.resolve_volley(mod)
    if type(mod) ~= "table" then
        return nil, nil
    end
    if type(mod.fireVolley) == "function" then
        return mod.fireVolley, "fireVolley"
    end
    if type(mod.tRa_ASYc_V) == "function" then
        return mod.tRa_ASYc_V, "tRa_ASYc_V"
    end
    local fn, key = F.export_matching(mod, function(v)
        return F.is_volley_fn(v)
    end)
    if fn then
        return fn, key
    end
    local client = ReplicatedStorage:FindFirstChild("Client")
    local tools = client and client:FindFirstChild("Tools")
    local weapon = tools and tools:FindFirstChild("Weapon")
    local muzzle = weapon and weapon:FindFirstChild("Muzzle")
    local dInst = muzzle and muzzle:FindFirstChild("Discharge")
    if not dInst then
        dInst = F.find_named_mod(ReplicatedStorage, "Discharge")
    end
    if dInst then
        local ok, d = pcall(require, dInst)
        if ok and type(d) == "table" and type(d.fire) == "function" then
            fn, key = F.key_from_caller(mod, d.fire, F.is_volley_fn)
            if not fn then
                fn, key = F.key_from_caller(mod, d.fire)
            end
            if fn and key ~= "fire" then
                return fn, key
            end
        end
    end
    return nil, nil
end

function F.resolve_recoil(mod)
    if type(mod) ~= "table" then
        return nil, nil
    end
    if type(mod.applyRecoil) == "function" then
        return mod.applyRecoil, "applyRecoil"
    end
    if type(mod.ibjoVLFtNP) == "function" then
        return mod.ibjoVLFtNP, "ibjoVLFtNP"
    end
    local skip = {
        update = true,
        attach = true,
        detach = true,
        getSpring = true,
        onMuzzleChanged = true,
    }
    local fn, key = F.export_matching(mod, function(v, k)
        if skip[k] then
            return false
        end
        return F.has_str_const(v, "DebugShotsGui") or F.has_str_const(v, "recoil suppressed")
    end)
    if fn then
        return fn, key
    end
    local client = ReplicatedStorage:FindFirstChild("Client")
    local tools = client and client:FindFirstChild("Tools")
    local weaponInst = tools and tools:FindFirstChild("Weapon")
    if weaponInst then
        local okW, WeaponMod = pcall(require, weaponInst)
        if okW and type(WeaponMod) == "table" and type(WeaponMod._onMuzzleFired) == "function" then
            fn, key = F.key_from_caller(mod, WeaponMod._onMuzzleFired)
            if fn then
                return fn, key
            end
        end
    end
    return nil, nil
end

function F.load_game_modules()
    local ps = LP:WaitForChild("PlayerScripts", 15)
    local cfInst, hrInst
    for _ = 1, 40 do
        cfInst = F.find_named_mod(ps, "ClientFire")
        hrInst = F.find_named_mod(ps, "HitReporter")
        if cfInst then
            local ok, mod = pcall(require, cfInst)
            if ok and type(mod) == "table" then
                ClientFire = mod
                if F.resolve_volley(mod) then
                    break
                end
            end
        end
        task.wait(0.15)
    end
    if hrInst then
        local okH, hr = pcall(require, hrInst)
        if okH then
            HitReporter = hr
        end
    end
    local shared = ReplicatedStorage:WaitForChild("Shared")
    local ballistics = shared:WaitForChild("Ballistics")
    ShotCodec = require(ballistics:WaitForChild("ShotCodec"))
    PlayerSlots = require(shared:WaitForChild("PlayerSlots"))
    BallisticsNet = require(ballistics:WaitForChild("Net"))
    local ok, wcm = pcall(require, shared:WaitForChild("WeaponConfigManager"))
    if ok then
        WeaponConfigManager = wcm
    end
    local okT, traj = pcall(require, ballistics:WaitForChild("Trajectory"))
    if okT and type(traj) == "table" then
        Trajectory = traj
    end
end

function F.install_hooks()
    local volleyFn, volleyKey = F.resolve_volley(ClientFire)
    if origFireVolley then
        return true
    end
    if not volleyFn then
        if not extraHooksInstalled then
            install_extra_hooks()
        elseif F.ensure_recoil then
            F.ensure_recoil()
        end
        return false
    end
    if HitReporter and type(HitReporter.sendClaim) == "function" then
        local claimHook = newcclosure(function(seed, impact)
            if type(seed) == "number" and claimedSeeds[seed] then
                return
            end
            if type(impact) == "table" then
                F.apply_force_hit(impact)
                local inst = impact.Instance
                local model = inst and inst:FindFirstAncestorOfClass("Model")
                local victim = model and Players:GetPlayerFromCharacter(model)
                if victim and victim ~= LP and (not LP.Team or not victim.Team or LP.Team ~= victim.Team) then
                    local pos = impact.Position
                    if typeof(pos) ~= "Vector3" and inst then
                        pos = inst.Position
                    end
                    if typeof(pos) == "Vector3" then
                        local from = lastShotFrom
                        if typeof(from) ~= "Vector3" then
                            local mcf = F.muzzle_cframe()
                            from = mcf and mcf.Position
                        end
                        F.hit_fx(from, pos)
                    end
                    if CFG.InstantHit then
                        local dist = 0
                        if typeof(lastShotFrom) == "Vector3" and typeof(pos) == "Vector3" then
                            dist = (pos - lastShotFrom).Magnitude
                        elseif typeof(pos) == "Vector3" then
                            dist = pos.Magnitude
                        end
                        local tReal = F.flight_time(dist, lastVolleySpeed, lastVolleyDrag)
                        local elapsed = clock() - lastVolleyAt
                        local wait = (tReal - elapsed) * 0.2
                        if wait > 0.12 then
                            wait = 0.12
                        end
                        if wait > 0.02 then
                            task.delay(wait, function()
                                if type(impact) ~= "table" then
                                    return
                                end
                                local live = impact.Instance
                                if live and live.Parent and live:IsA("BasePart") then
                                    impact.Position = live.Position
                                end
                                origSendClaim(seed, impact)
                            end)
                            return
                        end
                    end
                end
            end
            return origSendClaim(seed, impact)
        end, "sendClaim")
        setstackhidden(claimHook, true)
        if hookfunction then
            origSendClaim = hookfunction(HitReporter.sendClaim, claimHook)
        else
            origSendClaim = HitReporter.sendClaim
            HitReporter.sendClaim = claimHook
        end
    end
    local hook = newcclosure(function(tool, muzzleIdx, bulletIdx, origin, dirs, opts)
        opts = opts or {}
        if CFG.CrosshairAim and Cam then
            origin = Cam.CFrame.Position + Cam.CFrame.LookVector * 0.15
            if type(dirs) == "table" then
                local look = Cam.CFrame.LookVector
                for i = 1, #dirs do
                    dirs[i] = look
                end
            end
        end
        local rolled = F.hit_rolls()
        local legit = CFG.LegitAim == true
        if CFG.NoSpread and (not rolled or not legit) and type(dirs) == "table" and #dirs > 0 and typeof(dirs[1]) == "Vector3" then
            local base = dirs[1].Unit
            for i = 1, #dirs do
                dirs[i] = base
            end
        end
        local redirected = false
        local tgt
        local fireOrigin = origin
        local peek = false
        local isTurret = type(tool) == "string"
        if rolled and CFG.SilentAim and (not isTurret or CFG.TurretSA) and type(dirs) == "table" and typeof(origin) == "Vector3" then
            F.prep_frame(true)
            local prefer = F.part_name_for_shot()
            local src = F.pick_silent_target(F.shot_origin(origin), CFG.SilentAimMaxDist, F.need_los(), nil, prefer, true)
            if src then
                saFireTgt.player = src.player
                saFireTgt.pos = src.pos
                saFireTgt.claimPos = src.claimPos
                saFireTgt.bone = src.bone
                saFireTgt.origin = src.origin
                saFireTgt.spoof = src.spoof
                saFireTgt.tier = src.tier
                saFireTgt.mode = src.mode
                saFireTgt.inVeh = src.inVeh
                tgt = saFireTgt
            end
            if tgt then
                local bone = tgt.bone
                local nowPos = (bone and bone.Parent and bone.Position) or tgt.claimPos or tgt.pos
                if CFG.GunPredict and tgt.player and typeof(nowPos) == "Vector3" then
                    local speed, drag
                    if CFG.PredictIgnoreWeapon then
                        speed = CFG.PredictFixedSpeed or 850
                    else
                        speed, drag = F.weapon_profile(tool, muzzleIdx, bulletIdx)
                    end
                    local inVeh = tgt.inVeh
                    if inVeh == nil then
                        inVeh = F.in_vehicle(tgt.player)
                        tgt.inVeh = inVeh
                    end
                    local pred = F.predict_aim(tgt.player, bone, origin, nowPos, speed, drag, inVeh)
                    tgt.pos = pred
                    tgt.claimPos = pred
                end
                local char = tgt.player and tgt.player.Character
                local bonePos = (bone and bone.Parent and bone.Position) or tgt.claimPos or nowPos
                if CFG.MultiPoint and char and bonePos then
                    local occluded = tgt.tier == 2
                    if not occluded then
                        occluded = not F.world_visible(origin, bonePos, char)
                    end
                    if occluded then
                        local spoofNow = tgt.spoof
                        if typeof(spoofNow) == "Vector3" and (spoofNow - origin).Magnitude > 0.05 then
                            tgt.tier = 2
                        else
                            local mp = F.find_multipoint(origin, bonePos, tgt.bone, true)
                            if mp then
                                tgt.spoof = mp
                                tgt.tier = 2
                            end
                        end
                    end
                end
                local spoof = tgt.spoof
                peek = CFG.SpoofOrigin and CFG.MultiPoint and tgt.tier == 2 and typeof(spoof) == "Vector3" and (spoof - origin).Magnitude > 0.05
                if peek then
                    fireOrigin = F.clamp_origin(origin, spoof)
                end
                local canSilent = CFG.SilentAim
                if canSilent and CFG.VisibleCheck and not peek then
                    local to = (tgt.bone and tgt.bone.Parent and tgt.bone.Position) or nil
                    canSilent = char ~= nil and to ~= nil and F.world_visible(origin, to, char)
                end
                if canSilent then
                    local aimHit = tgt.pos or tgt.claimPos or nowPos
                    if not peek then
                        aimHit = F.part_aim_point(bone, aimHit)
                    end
                    local dir = F.ballistic_dir(fireOrigin, aimHit, tool, muzzleIdx, bulletIdx, legit)
                    local spread = legit and (CFG.LegitSpread or 0.35) or 0
                    for i = 1, #dirs do
                        local d = spread > 0 and F.spread_around(dir, spread) or dir
                        if ShotCodec and ShotCodec.quantizeDirection then
                            d = ShotCodec.quantizeDirection(d)
                        end
                        dirs[i] = d
                    end
                    redirected = true
                    tgt.claimPos = aimHit
                else
                    tgt = nil
                    fireOrigin = origin
                end
            end
        end
        lastShotFrom = fireOrigin
        lastVolleyAt = clock()
        lastVolleySpeed, lastVolleyDrag = F.weapon_profile(tool, muzzleIdx, bulletIdx)
        local results = origFireVolley(tool, muzzleIdx, bulletIdx, fireOrigin, dirs, opts)
        if type(results) == "table" then
            local mul = 1
            if CFG.InstantHit then
                mul = CFG.InstantHitMul or 2.4
            end
            if mul > 1.01 then
                for i = 1, #results do
                    local row = results[i]
                    F.boost_shot(row and row.proj, mul)
                end
            end
        end
        return results
    end, "fireVolley")
    setstackhidden(hook, true)
    fireVolleyKey = volleyKey
    if hookfunction then
        origFireVolley = hookfunction(volleyFn, hook)
    else
        origFireVolley = volleyFn
        ClientFire[volleyKey] = hook
    end
    install_extra_hooks()
    local function mark_shot(plr)
        if typeof(plr) == "Instance" and plr:IsA("Player") then
            lastShotAt[plr] = clock()
        elseif typeof(plr) == "number" then
            local p = Players:GetPlayerByUserId(plr)
            if p then
                lastShotAt[p] = clock()
            end
        end
    end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local weaponRE = remotes and remotes:FindFirstChild("Weapon")
    if weaponRE and weaponRE:IsA("RemoteEvent") then
        connections[#connections + 1] = weaponRE.OnClientEvent:Connect(function(a, b, c, d)
            if c == "Shot" then
                mark_shot(a)
            elseif b == "Shot" then
                mark_shot(a)
            elseif a == "Shot" then
                mark_shot(b)
            end
        end)
    end
    local events = ReplicatedStorage:FindFirstChild("Events")
    local effect = events and events:FindFirstChild("WeaponEffect")
    if effect then
        local sig = effect:IsA("BindableEvent") and effect.Event or (effect:IsA("RemoteEvent") and effect.OnClientEvent)
        if sig then
            connections[#connections + 1] = sig:Connect(function(a, b, c)
                if c == "Recoil" or c == "Shot" or b == "Recoil" or b == "Shot" then
                    mark_shot(a)
                end
            end)
        end
    end
    return true
end

function F.hook_fn(obj, key, wrapperName, wrap)
    if not (obj and type(obj[key]) == "function") then
        return
    end
    local clone = obj[key]
    if hookfunction then
        local okH, hooked = pcall(function()
            local proxy = newcclosure(function(...)
                return wrap(clone, ...)
            end, wrapperName)
            setstackhidden(proxy, true)
            return hookfunction(obj[key], proxy)
        end)
        if okH then
            clone = hooked
            extraHooks[#extraHooks + 1] = { kind = "fn", target = obj[key] }
            return
        end
    end
    extraHooks[#extraHooks + 1] = { kind = "assign", obj = obj, key = key, orig = clone }
    obj[key] = function(...)
        return wrap(clone, ...)
    end
end

F.ensure_recoil = function()
    if recoilHooked then
        return
    end
    local client = ReplicatedStorage:FindFirstChild("Client")
    local tools = client and client:FindFirstChild("Tools")
    local weapon = tools and tools:FindFirstChild("Weapon")
    local controllers = weapon and weapon:FindFirstChild("controllers")
    local recInst = controllers and controllers:FindFirstChild("RecoilController")
    if not recInst then
        return
    end
    local ok, recoil = pcall(require, recInst)
    if not (ok and type(recoil) == "table") then
        return
    end
    local _, recoilKey = F.resolve_recoil(recoil)
    if not recoilKey then
        return
    end
    F.hook_fn(recoil, recoilKey, "noRecoil", function(orig, ...)
        if CFG.NoRecoil then
            return
        end
        return orig(...)
    end)
    recoilHooked = true
end

function install_extra_hooks()
    if extraHooksInstalled then
        return
    end
    local client = ReplicatedStorage:FindFirstChild("Client")
    if not client then
        return
    end
    extraHooksInstalled = true
    local tools = client:FindFirstChild("Tools")
    local weapon = tools and tools:FindFirstChild("Weapon")
    if weapon then
        local controllers = weapon:FindFirstChild("controllers")
        if controllers then
            local oka, aimCtrl = pcall(require, controllers:FindFirstChild("AimController"))
            if oka and aimCtrl then
                AimCtrl = aimCtrl
            end
            local charFolder = client:FindFirstChild("Character")
            local camInst = charFolder and charFolder:FindFirstChild("CameraController")
            if camInst then
                local okc, CC = pcall(require, camInst)
                if okc and type(CC) == "table" then
                    CamCtrl = CC
                    if type(CC.setFOV) == "function" then
                        F.hook_fn(CC, "setFOV", "customZoom", function(orig, mag)
                            if CFG.CustomZoom then
                                local aiming = AimCtrl and type(AimCtrl.isAiming) == "function" and AimCtrl.isAiming()
                                if aiming then
                                    mag = CFG.CustomZoomMul or 1
                                end
                            end
                            return orig(mag)
                        end)
                    end
                end
            end
            if weapon then
                local okWep, WeaponMod = pcall(require, weapon)
                if okWep and type(WeaponMod) == "table" and type(WeaponMod.adjustZero) == "function" then
                    F.hook_fn(WeaponMod, "adjustZero", "wheelZoomEat", function(orig, self, dir, ...)
                        if CFG.CustomZoom and CFG.WheelZoom then
                            local aiming = AimCtrl and type(AimCtrl.isAiming) == "function" and AimCtrl.isAiming()
                            if aiming then
                                return
                            end
                        end
                        return orig(self, dir, ...)
                    end)
                end
            end
            F.bind(UserInputService.InputChanged:Connect(function(input, processed)
                if processed or not CFG.CustomZoom or not CFG.WheelZoom then
                    return
                end
                if input.UserInputType ~= Enum.UserInputType.MouseWheel then
                    return
                end
                local aiming = AimCtrl and type(AimCtrl.isAiming) == "function" and AimCtrl.isAiming()
                if not aiming then
                    return
                end
                local dz = input.Position.Z
                if dz == 0 then
                    return
                end
                local cur = CFG.CustomZoomMul
                if type(cur) ~= "number" then
                    cur = 2
                end
                cur = clamp(cur + (dz > 0 and 0.25 or -0.25), 1, 10)
                CFG.CustomZoomMul = cur
                if CamCtrl and type(CamCtrl.setFOV) == "function" then
                    pcall(CamCtrl.setFOV, cur)
                end
            end))
            if oka and aimCtrl and aimCtrl.getAlpha then
                F.hook_fn(aimCtrl, "getAlpha", "instantAim", function(orig)
                    if CFG.InstantAim then
                        if aimCtrl.isAiming and aimCtrl.isAiming() then
                            return 1
                        end
                        return 0
                    end
                    return orig()
                end)
            end
            local ok, recoil = pcall(require, controllers:FindFirstChild("RecoilController"))
            if ok and type(recoil) == "table" then
                F.ensure_recoil()
            end
            local bipodFolder = controllers:FindFirstChild("bipod")
            local bipodMod = bipodFolder and bipodFolder:FindFirstChild("BipodController")
            if bipodMod then
                local okb, bipod = pcall(require, bipodMod)
                if okb and bipod and bipod.applyRecoil then
                    F.hook_fn(bipod, "applyRecoil", "noBipodRecoil", function(orig, ...)
                        if CFG.NoRecoil then
                            return
                        end
                        return orig(...)
                    end)
                end
            end
        end
        local muzzle = weapon:FindFirstChild("Muzzle")
        local modes = muzzle and muzzle:FindFirstChild("firemodes")
        if modes then
            local shooterInst = muzzle:FindFirstChild("Shooter")
            if shooterInst then
                local oks, shooter = pcall(require, shooterInst)
                if oks and shooter and type(shooter.fire) == "function" and debug.getupvalue then
                    local okuv, spreadFn = pcall(debug.getupvalue, shooter.fire, 7)
                    if okuv and type(spreadFn) == "function" then
                        F.hook_fn({ spreadVector = spreadFn }, "spreadVector", "noSpread", function(orig, dir, spread, ...)
                            if CFG.NoSpread then
                                return dir.Unit
                            end
                            return orig(dir, spread, ...)
                        end)
                    end
                end
            end
            local oka, automatic = pcall(require, modes:FindFirstChild("Automatic"))
            if oka and automatic and automatic.fire then
                for _, name in { "SemiAuto", "Burst" } do
                    local child = modes:FindFirstChild(name)
                    if child then
                        local okm, mod = pcall(require, child)
                        if okm and mod and type(mod.fire) == "function" then
                            F.hook_fn(mod, "fire", "fullAuto_" .. name, function(orig, ctrl, ...)
                                if CFG.FullAuto and automatic.fire then
                                    return automatic.fire(ctrl, ...)
                                end
                                return orig(ctrl, ...)
                            end)
                        end
                    end
                end
            end
        end
        local animatorMod = muzzle and muzzle:FindFirstChild("MuzzleAnimator")
        if animatorMod then
            local oka2, animator = pcall(require, animatorMod)
            if oka2 and animator then
                if animator.playAndYield then
                    F.hook_fn(animator, "playAndYield", "instantEquipYield", function(orig, self, name, ...)
                        local spd = CFG.EquipAnimSpeed or 8
                        if CFG.InstantEquip and (name == "EquipUnfold" or name == "Equip" or name == "Chamber") then
                            local track = self._track and self:_track(name)
                            if track then
                                self._current = track
                                track:Play(0, 1, spd)
                            end
                            return
                        end
                        if spd > 1 and (name == "EquipUnfold" or name == "Equip" or name == "Chamber") then
                            local track = self._track and self:_track(name)
                            if track then
                                self._current = track
                                track:Play(0, 1, spd)
                                if track.Length and track.Length > 0 then
                                    task.wait(track.Length / spd)
                                end
                                return
                            end
                        end
                        return orig(self, name, ...)
                    end)
                end
                if animator.playScaledTo then
                    F.hook_fn(animator, "playScaledTo", "instantEquipScaled", function(orig, self, name, dur, ...)
                        local spd = CFG.EquipAnimSpeed or 8
                        if CFG.InstantEquip and (name == "EquipUnfold" or name == "Equip" or name == "Chamber") then
                            local track = self._track and self:_track(name)
                            if track then
                                self._current = track
                                track:Play(0, 1, spd)
                            end
                            return
                        end
                        if spd > 1 and (name == "EquipUnfold" or name == "Equip" or name == "Chamber") then
                            local track = self._track and self:_track(name)
                            if track then
                                self._current = track
                                track:Play(0, 1, spd)
                                local waitDur = (type(dur) == "number" and dur > 0) and (dur / spd) or nil
                                if waitDur then
                                    task.wait(waitDur)
                                elseif track.Length and track.Length > 0 then
                                    task.wait(track.Length / spd)
                                end
                                return
                            end
                        end
                        return orig(self, name, dur, ...)
                    end)
                end
                local reloadFolder = muzzle:FindFirstChild("reload")
                local stratMod = reloadFolder and reloadFolder:FindFirstChild("ReloadStrategy")
                if stratMod then
                    local oks, strat = pcall(require, stratMod)
                    if oks and strat then
                        if strat.playMain then
                            F.hook_fn(strat, "playMain", "instantReloadMain", function(orig, mz, ctx, animName, reloadTime, ...)
                                if CFG.InstantReload then
                                    if mz and mz.animator and animName and mz.animator.has and mz.animator:has(animName) then
                                        local track = mz.animator._track and mz.animator:_track(animName)
                                        if track then
                                            mz.animator._current = track
                                            track:Play(0, 1, 30)
                                        end
                                    end
                                    return
                                end
                                return orig(mz, ctx, animName, reloadTime, ...)
                            end)
                        end
                        if strat.finishChambering then
                            F.hook_fn(strat, "finishChambering", "instantReloadFinish", function(orig, mz, ctx, ...)
                                if CFG.InstantReload then
                                    if mz and mz.chamber and not mz.chamber:isLoaded() then
                                        pcall(function()
                                            mz.chamber:load(ctx and ctx.isSingleShot)
                                        end)
                                    end
                                    return
                                end
                                return orig(mz, ctx, ...)
                            end)
                        end
                    end
                end
                local reloadCtrlMod = reloadFolder and reloadFolder:FindFirstChild("ReloadController")
                if reloadCtrlMod then
                    local okr, ReloadCtrl = pcall(require, reloadCtrlMod)
                    if okr and ReloadCtrl and ReloadCtrl._context then
                        F.hook_fn(ReloadCtrl, "_context", "instantReloadCtx", function(orig, self, bulletIdx, ...)
                            local ctx = orig(self, bulletIdx, ...)
                            if CFG.InstantReload and type(ctx) == "table" then
                                ctx.reloadTime = 0.05
                                ctx.insertTime = 0.05
                                local oldWait = ctx.waitForReplication
                                ctx.waitForReplication = function()
                                    return
                                end
                            end
                            return ctx
                        end)
                    end
                end
            end
        end
    end
    local charFolder = client:FindFirstChild("Character")
    local invMod = charFolder and charFolder:FindFirstChild("InventoryController")
    local oki, inv = false, nil
    if invMod then
        oki, inv = pcall(require, invMod)
    end
    if oki and type(inv) == "table" and type(inv.equip) == "function" and debug.getupvalue and hookfunction then
        local okD, draw = pcall(debug.getupvalue, inv.equip, 9)
        if not (okD and type(draw) == "function") then
            for i = 1, 16 do
                local okU, uv = pcall(debug.getupvalue, inv.equip, i)
                if not okU then
                    break
                end
                if type(uv) == "function" then
                    local okN, n1 = pcall(debug.getupvalue, uv, 1)
                    if okN and typeof(n1) == "Instance" then
                        draw = uv
                        break
                    end
                end
            end
        end
        local awaitLen
        if type(draw) == "function" then
            for i = 1, 16 do
                local okU, uv = pcall(debug.getupvalue, draw, i)
                if not okU then
                    break
                end
                if type(uv) == "function" then
                    local okW, w = pcall(debug.getupvalue, uv, 1)
                    if okW and type(w) == "table" and type(w.isConscious) == "function" then
                        awaitLen = uv
                        break
                    end
                end
            end
        end
        if type(awaitLen) == "function" then
            local origAwait
            origAwait = hookfunction(awaitLen, function(track)
                if CFG.InstantEquip then
                    return false
                end
                return origAwait(track)
            end)
            extraHooks[#extraHooks + 1] = { kind = "fn", target = awaitLen }
        else
            warn("[CWCombat] holdForTrack missing")
        end
    elseif not (oki and type(inv) == "table" and type(inv.equip) == "function") then
        warn("[CWCombat] InventoryController require failed")
    end

    do
        local wielderMod = charFolder and charFolder:FindFirstChild("Wielder")
        local okW, Wielder = false, nil
        if wielderMod then
            okW, Wielder = pcall(require, wielderMod)
        end
        if okW and type(Wielder) == "table" then
            local function act_on()
                return CFG.AlwaysAct == true or CFG.ReloadSprint == true
            end
            if type(Wielder.isBusy) == "function" then
                F.hook_fn(Wielder, "isBusy", "alwaysActBusy", function(orig, self, ...)
                    if act_on() then
                        return false
                    end
                    return orig(self, ...)
                end)
            end
            if type(Wielder.isConscious) == "function" then
                F.hook_fn(Wielder, "isConscious", "alwaysActConscious", function(orig, self, ...)
                    if CFG.AlwaysAct then
                        return true
                    end
                    return orig(self, ...)
                end)
            end
            if type(Wielder.beginAction) == "function" then
                F.hook_fn(Wielder, "beginAction", "alwaysActBegin", function(orig, self, ...)
                    if act_on() then
                        return
                    end
                    return orig(self, ...)
                end)
            end
            if type(Wielder.canAct) == "function" then
                F.hook_fn(Wielder, "canAct", "alwaysActCan", function(orig, self, ...)
                    if CFG.AlwaysAct then
                        return true
                    end
                    if CFG.ReloadSprint then
                        if type(Wielder.isConscious) == "function" then
                            return Wielder.isConscious(self)
                        end
                        return true
                    end
                    return orig(self, ...)
                end)
            end
            
        else
            warn("[CWCombat] Wielder missing")
        end
    end

    do
        local stanceFolder = charFolder and charFolder:FindFirstChild("stance")
        local mtInst = stanceFolder and stanceFolder:FindFirstChild("MovementTuning")
        local stInst = stanceFolder and stanceFolder:FindFirstChild("StanceState")
        local okM, MT = false, nil
        local okS, StanceState = false, nil
        if mtInst then
            okM, MT = pcall(require, mtInst)
        end
        if stInst then
            okS, StanceState = pcall(require, stInst)
        end
        local tuneFn = nil
        if okM and type(MT) == "table" then
            if type(MT.apply) == "function" then
                tuneFn = "apply"
            elseif type(MT.update) == "function" then
                tuneFn = "update"
            end
        end
        if tuneFn then
            F.hook_fn(MT, tuneFn, "moveTune", function(orig, ctx)
                orig(ctx)
                if type(ctx) ~= "table" then
                    return
                end
                local hum = ctx.humanoid
                local char = ctx.character
                if not (hum and char) then
                    return
                end
                if hum.Sit or hum.SeatPart then
                    return
                end
                if not CFG.NoLimp then
                    return
                end
                local speeds = okS and StanceState and StanceState.WALK_SPEED
                local st = okS and StanceState.current and StanceState.current() or "Walk"
                local base = speeds and (speeds[st] or speeds.Walk) or 10
                local prone = speeds and speeds.Prone or 4
                local wade = char:GetAttribute("WadeFactor")
                if type(wade) ~= "number" then
                    wade = 1
                end
                hum.WalkSpeed = math.max(base, prone) * wade
            end)
        else
            warn("[CWCombat] MovementTuning missing")
        end
    end

    do
        local function sit_speed()
            local s = CFG.SitAnimSpeed
            if type(s) ~= "number" or s < 0.05 then
                return 8
            end
            return s
        end

        local function speed_track(tr)
            if not tr then
                return
            end
            pcall(function()
                tr:AdjustSpeed(sit_speed())
            end)
        end

        local shared = ReplicatedStorage:FindFirstChild("Shared")
        local veh = shared and shared:FindFirstChild("Vehicle")
        local vcInst = veh and veh:FindFirstChild("VehicleController")
        if vcInst then
            local okC, VC = pcall(require, vcInst)
            if okC and type(VC) == "table" then
                if type(VC.GetSeatTracks) == "function" then
                    F.hook_fn(VC, "GetSeatTracks", "instantSitTracks", function(orig, self, name, seat)
                        local tracks = orig(self, name, seat)
                        if CFG.InstantSit and type(tracks) == "table" then
                            speed_track(tracks.enter)
                            speed_track(tracks.idle)
                            speed_track(tracks.exit)
                            if tracks.enter then
                                local enter = tracks.enter
                                pcall(function()
                                    enter:Play(0)
                                    enter:AdjustSpeed(sit_speed())
                                end)
                                tracks.enter = nil
                            end
                        end
                        return tracks
                    end)
                end
                if type(VC._requestExit) == "function" then
                    F.hook_fn(VC, "_requestExit", "instantSitRequestExit", function(orig, self, ...)
                        if CFG.InstantSit and type(self) == "table" and type(self._seatTracks) == "table" then
                            local exit = self._seatTracks.exit
                            speed_track(exit)
                            if exit then
                                pcall(function()
                                    exit:Play(0)
                                    exit:AdjustSpeed(sit_speed())
                                end)
                            end
                            self._seatTracks.exit = nil
                            if self._seatTracks.enter then
                                pcall(function()
                                    self._seatTracks.enter:Stop(0)
                                end)
                            end
                            if self._seatTracks.idle then
                                pcall(function()
                                    self._seatTracks.idle:Stop(0)
                                end)
                            end
                        end
                        return orig(self, ...)
                    end)
                end
            end
        end
    end

    do
        local CS = game:GetService("CollectionService")
        local PPS = game:GetService("ProximityPromptService")
        local highlights = {}
        local origDist = {}
        local watching = {}

        local function vehicle_of(inst)
            local cur = inst
            for _ = 1, 12 do
                if not cur or cur == Workspace then
                    return nil
                end
                if CS:HasTag(cur, "AdoptVehicle") then
                    return cur
                end
                if cur:IsA("Model") and cur:FindFirstChild("Seats") then
                    return cur
                end
                cur = cur.Parent
            end
            return nil
        end

        local function seat_of_prompt(prompt)
            local p = prompt and prompt.Parent
            if p and CS:HasTag(p, "FactoryVehicleSeat") then
                return p
            end
            if p and (p:IsA("VehicleSeat") or p:IsA("Seat")) then
                return p
            end
            local cur = p
            for _ = 1, 6 do
                if not cur then
                    break
                end
                if CS:HasTag(cur, "FactoryVehicleSeat") then
                    return cur
                end
                cur = cur.Parent
            end
            return p
        end

        local function occupant_of(seat)
            if not seat then
                return nil
            end
            local ov = seat:FindFirstChild("Occupant")
            if ov and ov:IsA("ObjectValue") then
                return ov.Value
            end
            if seat:IsA("VehicleSeat") or seat:IsA("Seat") then
                return seat.Occupant
            end
            return nil
        end

        local function occupant_char(occ)
            if not occ then
                return nil
            end
            if occ:IsA("Model") then
                return occ
            end
            if occ:IsA("Humanoid") then
                return occ.Parent
            end
            return nil
        end

        local function is_driver_seat(seat)
            return seat ~= nil and type(seat.Name) == "string" and string.find(seat.Name, "Driver", 1, true) ~= nil
        end

        local function driver_taken(seat)
            if not is_driver_seat(seat) then
                return false
            end
            local ch = occupant_char(occupant_of(seat))
            if not ch then
                return false
            end
            return ch ~= LP.Character
        end

        local function take_wheel(seat)
            local veh = vehicle_of(seat)
            if not veh then
                return
            end
            task.defer(function()
                local shared = ReplicatedStorage:FindFirstChild("Shared")
                local vf = shared and shared:FindFirstChild("Vehicle")
                local dcInst = vf and vf:FindFirstChild("DriverController")
                local vcmInst = shared and shared:FindFirstChild("VehicleConfigManager")
                local DC, trans
                if dcInst then
                    local ok, mod = pcall(require, dcInst)
                    if ok then
                        DC = mod
                    end
                end
                if vcmInst then
                    local ok, VCM = pcall(require, vcmInst)
                    if ok and type(VCM) == "table" and type(VCM.GetVehicleConfigFromName) == "function" then
                        local cfg = VCM.GetVehicleConfigFromName(veh.Name)
                        trans = cfg and cfg.Transmission
                    end
                end
                if DC then
                    if type(DC.IsDriving) ~= "function" or not DC.IsDriving() then
                        pcall(DC.Attach, veh, seat, trans, LP, { deferInputs = false })
                    end
                    if type(DC.EnableInputs) == "function" then
                        pcall(DC.EnableInputs)
                    end
                end
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local Vehicle = remotes and remotes:FindFirstChild("Vehicle")
                if Vehicle then
                    pcall(function()
                        Vehicle:FireServer("SeatReady")
                    end)
                    pcall(function()
                        Vehicle:FireServer("DriveReady")
                    end)
                end
                local Inputs = ReplicatedStorage:FindFirstChild("Inputs")
                local vdc = Inputs and Inputs:FindFirstChild("VehicleDriverContext")
                if vdc then
                    vdc.Enabled = true
                end
                local vctx = Inputs and Inputs:FindFirstChild("VehicleContext")
                if vctx then
                    vctx.Enabled = true
                end
            end)
        end

        local function engine_sit(hum, seat)
            if not (hum and seat) then
                return false
            end
            if driver_taken(seat) then
                return false
            end
            local char = hum.Parent
            if seat:IsA("VehicleSeat") or seat:IsA("Seat") then
                pcall(function()
                    if hum.SeatPart then
                        hum.Sit = false
                    end
                    seat:Sit(hum)
                end)
            end
            local occ = seat:FindFirstChild("Occupant")
            if occ and occ:IsA("ObjectValue") and char then
                occ.Value = char
            end
            if is_driver_seat(seat) then
                take_wheel(seat)
            end
            return hum.SeatPart == seat or (occ and occ.Value == char)
        end

        local function is_locked_veh(veh)
            if not veh then
                return false
            end
            local ownerId = veh:GetAttribute("OwnerUserId")
            if type(ownerId) == "number" and ownerId == LP.UserId then
                return false
            end
            local mode = veh:GetAttribute("LockMode")
            if mode == "SQUAD" or mode == "FRIENDS" then
                return true
            end
            if mode == "EVERYONE" then
                return false
            end
            return type(ownerId) == "number" and ownerId ~= LP.UserId
        end

        local function hl_parent()
            if gethui then
                local ok, h = pcall(gethui)
                if ok and h then
                    return h
                end
            end
            return LP:FindFirstChild("PlayerGui") or LP
        end

        local function set_hl(veh, on)
            if on and not CFG.VehicleStealHighlight then
                on = false
            end
            local hl = highlights[veh]
            if on then
                if not (hl and hl.Parent) then
                    hl = Instance.new("Highlight")
                    hl.Name = "CWLockHl"
                    hl.FillColor = Color3.fromRGB(255, 40, 40)
                    hl.OutlineColor = Color3.fromRGB(255, 80, 80)
                    hl.FillTransparency = 0.62
                    hl.OutlineTransparency = 0.15
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Adornee = veh
                    hl.Parent = hl_parent()
                    highlights[veh] = hl
                else
                    hl.Adornee = veh
                    hl.Enabled = true
                end
            elseif hl then
                pcall(function()
                    hl:Destroy()
                end)
                highlights[veh] = nil
            end
        end

        local function clear_hls()
            for veh in highlights do
                set_hl(veh, false)
            end
        end

        local hiddenPrompts = {}

        local function unlock_prompt(prompt)
            if not (prompt and prompt:IsA("ProximityPrompt")) then
                return
            end
            if not CFG.VehicleStealer then
                return
            end
            if origDist[prompt] == nil then
                local d = prompt.MaxActivationDistance
                origDist[prompt] = (type(d) == "number" and d > 0) and d or 32
            end
            local seat = seat_of_prompt(prompt)
            if driver_taken(seat) then
                prompt.Enabled = false
                prompt.MaxActivationDistance = 0
                return
            end
            local wasHidden = prompt.MaxActivationDistance < 1 or prompt.Enabled == false
            if wasHidden then
                hiddenPrompts[prompt] = true
            end
            prompt.Enabled = true
            prompt.RequiresLineOfSight = false
            if prompt.HoldDuration > 0.05 then
                prompt.HoldDuration = 0
            end
            if prompt.MaxActivationDistance < 1 then
                prompt.MaxActivationDistance = origDist[prompt]
            end
            local veh = vehicle_of(prompt)
            if veh then
                set_hl(veh, hiddenPrompts[prompt] == true or is_locked_veh(veh))
            end
        end

        local function watch_prompt(prompt)
            if not (prompt and prompt:IsA("ProximityPrompt")) or watching[prompt] then
                return
            end
            watching[prompt] = true
            unlock_prompt(prompt)
            local seat = seat_of_prompt(prompt)
            local ov = seat and seat:FindFirstChild("Occupant")
            if ov and ov:IsA("ObjectValue") then
                F.bind(ov.Changed:Connect(function()
                    if CFG.VehicleStealer then
                        unlock_prompt(prompt)
                    end
                end))
            end
            F.bind(prompt.Triggered:Connect(function(player)
                if player ~= LP or not CFG.VehicleStealer then
                    return
                end
                local seat = seat_of_prompt(prompt)
                local char = LP.Character
                local hum = char and char:FindFirstChildWhichIsA("Humanoid")
                if not (seat and hum) or hum.Health <= 0 then
                    return
                end
                engine_sit(hum, seat)
                local veh = vehicle_of(prompt)
                if veh then
                    set_hl(veh, false)
                end
            end))
            F.bind(prompt.Destroying:Connect(function()
                watching[prompt] = nil
                origDist[prompt] = nil
                hiddenPrompts[prompt] = nil
            end))
        end

        local lockHooked = false
        local function hook_lock_blocked()
            if lockHooked then
                return
            end
            local shared = ReplicatedStorage:FindFirstChild("Shared")
            local vehFolder = shared and shared:FindFirstChild("Vehicle")
            local gate = vehFolder and vehFolder:FindFirstChild("VehiclePromptGate")
            if not (gate and gate:IsA("ModuleScript") and hookfunction) then
                return
            end
            lockHooked = true
            local function hook_one(fn)
                if type(fn) ~= "function" then
                    return false
                end
                local old
                local ok, hooked = pcall(function()
                    return hookfunction(fn, newcclosure(function(...)
                        if CFG.VehicleStealer then
                            return false
                        end
                        return old(...)
                    end, "isLockBlocked"))
                end)
                if ok and hooked then
                    old = hooked
                    extraHooks[#extraHooks + 1] = { kind = "fn", target = fn }
                    return true
                end
                return false
            end
            if getscriptclosure and debug and debug.getproto then
                local ok, root = pcall(getscriptclosure, gate)
                if ok and type(root) == "function" then
                    local seen = {}
                    local function walk(fn, depth)
                        if type(fn) ~= "function" or depth > 8 or seen[fn] then
                            return false
                        end
                        seen[fn] = true
                        local okUv, uv3 = pcall(debug.getupvalue, fn, 3)
                        if okUv and type(uv3) == "table" and uv3.ATTRIBUTE == "LockMode" then
                            return hook_one(fn)
                        end
                        for i = 1, 48 do
                            local pok, proto = pcall(debug.getproto, fn, i, true)
                            if not pok then
                                pok, proto = pcall(debug.getproto, fn, i)
                            end
                            if not pok or type(proto) ~= "function" then
                                break
                            end
                            if walk(proto, depth + 1) then
                                return true
                            end
                        end
                        return false
                    end
                    walk(root, 0)
                end
            end
        end

        local function scan_vehicle_prompts()
            if not CFG.VehicleStealer then
                return
            end
            hook_lock_blocked()
            local tagged = CS:GetTagged("VehiclePrompt")
            for i = 1, #tagged do
                watch_prompt(tagged[i])
            end
            local seats = CS:GetTagged("FactoryVehicleSeat")
            for i = 1, #seats do
                local seat = seats[i]
                if seat then
                    if seat:IsA("ProximityPrompt") then
                        watch_prompt(seat)
                    else
                        local p = seat:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if p then
                            watch_prompt(p)
                        end
                    end
                end
            end
            local vehs = CS:GetTagged("AdoptVehicle")
            for i = 1, #vehs do
                local veh = vehs[i]
                if veh and is_locked_veh(veh) then
                    set_hl(veh, true)
                end
            end
        end

        task.defer(scan_vehicle_prompts)
        F.bind(CS:GetInstanceAddedSignal("VehiclePrompt"):Connect(watch_prompt))
        F.bind(CS:GetInstanceAddedSignal("FactoryVehicleSeat"):Connect(function(seat)
            if not CFG.VehicleStealer or not seat then
                return
            end
            local p = seat:FindFirstChildWhichIsA("ProximityPrompt", true)
            if p then
                watch_prompt(p)
            end
        end))
        F.bind(CS:GetInstanceAddedSignal("AdoptVehicle"):Connect(function(veh)
            if CFG.VehicleStealer and is_locked_veh(veh) then
                set_hl(veh, true)
            end
        end))
        F.bind(PPS.PromptTriggered:Connect(function(prompt, player)
            if not CFG.VehicleStealer or player ~= LP then
                return
            end
            local seat = seat_of_prompt(prompt)
            local char = LP.Character
            local hum = char and char:FindFirstChildWhichIsA("Humanoid")
            if not (seat and hum) or hum.Health <= 0 then
                return
            end
            engine_sit(hum, seat)
            local veh = vehicle_of(prompt)
            if veh then
                set_hl(veh, false)
            end
        end))
        F.bind(LP.CharacterAdded:Connect(function()
            task.defer(scan_vehicle_prompts)
        end))
        F.stealer_off = function()
            clear_hls()
        end
        F.stealer_scan = scan_vehicle_prompts
        task.spawn(function()
            while F.stealer_scan do
                task.wait(1)
                if CFG.VehicleStealer then
                    for prompt in watching do
                        if prompt.Parent and (prompt.MaxActivationDistance < 1 or prompt.Enabled == false) then
                            unlock_prompt(prompt)
                        end
                    end
                end
            end
        end)
    end

    do
        local function scale_torque(cfg)
            if type(cfg) ~= "table" then
                return cfg
            end
            local mul = CFG.VehicleSpeedMul
            if type(mul) ~= "number" or mul <= 1 then
                return cfg
            end
            local okCopy, copy = pcall(table.clone, cfg)
            if not okCopy or type(copy) ~= "table" then
                return cfg
            end
            local keys = { "PeakTorque", "IdleTorque", "RedlineTorque", "TorqueScale", "DriveGain", "HorsepowerLimit" }
            for i = 1, #keys do
                local k = keys[i]
                local v = cfg[k]
                if type(v) == "number" then
                    copy[k] = v * mul
                end
            end
            return copy
        end
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        local veh = shared and shared:FindFirstChild("Vehicle")
        if veh then
            local wd = veh:FindFirstChild("WheelDrive")
            if wd then
                local okW, WheelDrive = pcall(require, wd)
                if okW and type(WheelDrive) == "table" and type(WheelDrive.new) == "function" then
                    F.hook_fn(WheelDrive, "new", "vehicleSpeedWheel", function(orig, vehicle, config, inputs)
                        if CFG.VehicleSpeed then
                            config = scale_torque(config)
                        end
                        return orig(vehicle, config, inputs)
                    end)
                end
            end
            local td = veh:FindFirstChild("TrackDrive")
            if td then
                local okT, TrackDrive = pcall(require, td)
                if okT and type(TrackDrive) == "table" and type(TrackDrive.new) == "function" then
                    F.hook_fn(TrackDrive, "new", "vehicleSpeedTrack", function(orig, vehicle, config, inputs)
                        if CFG.VehicleSpeed then
                            config = scale_torque(config)
                        end
                        return orig(vehicle, config, inputs)
                    end)
                end
            end
        end
    end

    do
        local okW, WeaponEffects = pcall(require, client:FindFirstChild("WeaponEffects"))
        if okW and type(WeaponEffects) == "table" and WeaponEffects.MuzzleFlash then
            F.hook_fn(WeaponEffects, "MuzzleFlash", "shootEspMuzzle", function(orig, muzzle, ...)
                local model = muzzle and (muzzle:FindFirstAncestorOfClass("Model") or muzzle.Parent)
                while model and model.Parent and not Players:GetPlayerFromCharacter(model) do
                    if model.Parent == Workspace then
                        break
                    end
                    model = model.Parent
                end
                local plr = model and Players:GetPlayerFromCharacter(model)
                if plr then
                    lastShotAt[plr] = clock()
                end
                return orig(muzzle, ...)
            end)
        end
        local bodyRep = client:FindFirstChild("BodyReplication")
        local recoilMod = bodyRep and bodyRep:FindFirstChild("Recoil")
        if not recoilMod then
            local inside = client:FindFirstChild("Inside_BodyReplication") or (bodyRep and bodyRep:FindFirstChild("Recoil"))
        end
        local okR, Recoil = pcall(function()
            return require(client:WaitForChild("BodyReplication"):WaitForChild("Recoil"))
        end)
        if not (okR and Recoil) then
            okR, Recoil = pcall(function()
                local folder = client:FindFirstChild("Inside_BodyReplication")
                return folder and require(folder:FindFirstChild("Recoil"))
            end)
        end
        if okR and type(Recoil) == "table" and Recoil.ApplyShot then
            F.hook_fn(Recoil, "ApplyShot", "shootEspRecoil", function(orig, info, ...)
                if type(info) == "table" and info.UserId then
                    local plr = Players:GetPlayerByUserId(info.UserId)
                    if plr then
                        lastShotAt[plr] = clock()
                    end
                end
                return orig(info, ...)
            end)
        end
    end


end

function F.restore_hooks()
    if origFireVolley and ClientFire then
        local key = fireVolleyKey or "fireVolley"
        if restorefunction then
            pcall(restorefunction, ClientFire[key] or origFireVolley)
        else
            ClientFire[key] = origFireVolley
        end
        origFireVolley = nil
        fireVolleyKey = nil
    end
    if origSendClaim and HitReporter then
        if restorefunction then
            pcall(restorefunction, HitReporter.sendClaim)
        else
            HitReporter.sendClaim = origSendClaim
        end
        origSendClaim = nil
    end
    for _, rec in extraHooks do
        if rec.kind == "fn" and rec.target and restorefunction then
            pcall(restorefunction, rec.target)
        elseif rec.kind == "assign" and rec.obj then
            rec.obj[rec.key] = rec.orig
        elseif rec.kind == "meta" and rec.orig and hookmetamethod then
            pcall(hookmetamethod, rec.obj, rec.method, rec.orig)
        elseif rec.kind == "uv" and rec.fn and rec.idx and debug and debug.setupvalue then
            pcall(debug.setupvalue, rec.fn, rec.idx, rec.orig)
        end
    end
    table.clear(extraHooks)
end

function F.install_movement()
    local collideSave = {}

    local function hum_hrp()
        local char = LP.Character
        if not char then
            return nil, nil, nil
        end
        return char, char:FindFirstChildWhichIsA("Humanoid"), char:FindFirstChild("HumanoidRootPart")
    end

    local function ground_lock(hum, lock)
        if not hum then
            return
        end
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, not lock)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not lock)
        hum:SetStateEnabled(Enum.HumanoidStateType.Flying, not lock)
        if lock then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end

    local noclipDesc
    local function noclip_set(on)
        local char = LP.Character
        if not on then
            if noclipDesc then
                noclipDesc:Disconnect()
                noclipDesc = nil
            end
            for part, saved in collideSave do
                if part.Parent then
                    part.CanCollide = saved
                end
            end
            table.clear(collideSave)
            return
        end
        if not char then
            return
        end
        for _, part in char:GetDescendants() do
            if part:IsA("BasePart") then
                if collideSave[part] == nil then
                    collideSave[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
        if not noclipDesc then
            noclipDesc = char.DescendantAdded:Connect(function(inst)
                if inst:IsA("BasePart") then
                    if collideSave[inst] == nil then
                        collideSave[inst] = inst.CanCollide
                    end
                    inst.CanCollide = false
                end
            end)
            F.bind(noclipDesc)
        end
    end

    F.mv_off = function()
        CFG.Fly, CFG.Speed, CFG.NoClip = false, false, false
        local char, hum, hrp = hum_hrp()
        ground_lock(hum, false)
        if hrp then
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = V3(0, math.min(v.Y, 0), 0)
        end
        noclip_set(false)
        local cv = char and char:FindFirstChild("CharacterValues")
        local sm = cv and cv:FindFirstChild("SpeedMultiplier")
        if sm and sm:IsA("NumberValue") then
            local orig = sm:GetAttribute("CWOrig")
            sm.Value = type(orig) == "number" and orig or 1
            pcall(sm.SetAttribute, sm, "CWOrig", nil)
        end
    end

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local ff = remotes and remotes:FindFirstChild("Freefall")
    local compareinstances = compareinstances
    local function is_freefall_remote(inst)
        if typeof(inst) ~= "Instance" then
            return false
        end
        if inst.Name == "Freefall" and inst.ClassName == "RemoteEvent" then
            return true
        end
        if ff and compareinstances then
            local ok, same = pcall(compareinstances, inst, ff)
            if ok and same then
                return true
            end
        end
        return false
    end
    if ff and ff:IsA("RemoteEvent") and hookfunction then
        local orig
        local proxy = newcclosure(function(self, yVel, height, ...)
            if not is_freefall_remote(self) then
                return orig(self, yVel, height, ...)
            end
            if CFG.Fly then
                if type(yVel) ~= "number" then
                    yVel = -16
                else
                    yVel = math.clamp(yVel, -40, 8)
                end
                if type(height) ~= "number" then
                    height = 6
                else
                    height = math.clamp(height, 0, 12)
                end
                return orig(self, yVel, height, ...)
            end
            if CFG.NoFall then
                return
            end
            return orig(self, yVel, height, ...)
        end, "suppressFreefall")
        local okH, hooked = pcall(hookfunction, ff.FireServer, proxy)
        if okH then
            orig = hooked
            extraHooks[#extraHooks + 1] = { kind = "fn", target = ff.FireServer }
        end
    end

    F.bind(LP.CharacterAdded:Connect(function()
        table.clear(collideSave)
        if noclipDesc then
            noclipDesc:Disconnect()
            noclipDesc = nil
        end
        task.defer(function()
            if CFG.NoClip then
                noclip_set(true)
            end
            if CFG.Speed then
                apply_speed_mul(true)
            end
        end)
    end))

    F.set_fly = function(on)
        CFG.Fly = on and true or false
        local _, hum, hrp = hum_hrp()
        if not CFG.Fly then
            ground_lock(hum, false)
            if hrp then
                local v = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = V3(0, math.min(v.Y, 0), 0)
            end
        end
    end
    local function apply_speed_mul(on)
        local char = LP.Character
        local cv = char and char:FindFirstChild("CharacterValues")
        local sm = cv and cv:FindFirstChild("SpeedMultiplier")
        if not (sm and sm:IsA("NumberValue")) then
            return
        end
        if on then
            if sm:GetAttribute("CWOrig") == nil then
                sm:SetAttribute("CWOrig", sm.Value)
            end
            local spd = CFG.SpeedStuds
            if type(spd) ~= "number" or spd < 1 then
                spd = 42
            end
            sm.Value = spd / 22
        else
            local orig = sm:GetAttribute("CWOrig")
            sm.Value = type(orig) == "number" and orig or 1
            pcall(sm.SetAttribute, sm, "CWOrig", nil)
        end
    end

    F.set_speed = function(on)
        CFG.Speed = on and true or false
        apply_speed_mul(CFG.Speed)
    end
    F.set_noclip = function(on)
        CFG.NoClip = on and true or false
        noclip_set(CFG.NoClip)
    end

    F.bind(UserInputService.InputBegan:Connect(function(input, processed)
        if F.maclibUi then
            return
        end
        if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        local code = input.KeyCode
        if code == Enum.KeyCode.G then
            F.set_fly(not CFG.Fly)
        elseif code == Enum.KeyCode.H then
            F.set_speed(not CFG.Speed)
        elseif code == Enum.KeyCode.J then
            F.set_noclip(not CFG.NoClip)
        end
    end))

    F.bind(RunService.Heartbeat:Connect(function(dt)
        F.tick_support()
        local char, hum, hrp = hum_hrp()
        if char and hum and hrp and hum.Health > 0 and not CFG.NoClip and not CFG.Fly and not hum.Sit and not hum.SeatPart then
            if hrp.Massless or hrp.CollisionGroup == "Crew" then
                local team = LP.Team and LP.Team.Name
                local group = team == "PACT" and "CharPACT" or (team == "NATO" and "CharNATO" or "Default")
                for _, d in char:GetDescendants() do
                    if d:IsA("BasePart") then
                        if d.CollisionGroup == "Crew" then
                            d.CollisionGroup = group
                        end
                        if d.Massless then
                            d.Massless = false
                        end
                    end
                end
                if not hrp.CanCollide then
                    hrp.CanCollide = true
                end
                if hum:GetState() == Enum.HumanoidStateType.Physics then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end
        if not (CFG.Fly or CFG.Speed or CFG.NoClip) then
            return
        end
        if dt <= 0 then
            dt = 1 / 60
        elseif dt > 0.05 then
            dt = 0.05
        end
        local char, hum, hrp = hum_hrp()
        if not (char and hum and hrp) or hum.Health <= 0 then
            return
        end
        if CFG.NoClip then
            for part in collideSave do
                if part.Parent and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
        if hum.Sit or hum.SeatPart then
            return
        end
        if CFG.Fly then
            Cam = Workspace.CurrentCamera
            local dir = ZERO3
            if Cam then
                local look, right = Cam.CFrame.LookVector, Cam.CFrame.RightVector
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    dir += look
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    dir -= look
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    dir -= right
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    dir += right
                end
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                dir += V3(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                dir -= V3(0, 1, 0)
            end
            local spd = CFG.FlySpeed or 52
            local want = dir.Magnitude > 0.05 and dir.Unit * spd or V3(0, 0.15, 0)
            local mass = hrp.AssemblyMass
            if mass < 1 then
                mass = 1
            end
            hrp:ApplyImpulse(V3(0, mass * Workspace.Gravity * dt, 0))
            hrp.AssemblyLinearVelocity = want
        elseif CFG.Speed then
            local md = hum.MoveDirection
            if md.Magnitude > 0.05 then
                local spd = CFG.SpeedStuds
                if type(spd) ~= "number" or spd < 1 then
                    spd = 42
                end
                local horiz = md.Unit * spd
                local vy = hrp.AssemblyLinearVelocity.Y
                hrp.AssemblyLinearVelocity = V3(horiz.X, vy, horiz.Z)
            end
        end
    end))
end

function F.unload()
    pcall(RunService.UnbindFromRenderStep, RunService, "CW_VmAim")
    pcall(RunService.UnbindFromRenderStep, RunService, "CW_Aimbot")
    pcall(F.vm_style_restore)
    F.restore_hooks()
    for _, conn in connections do
        conn:Disconnect()
    end
    table.clear(connections)
    for model, o in espByModel do
        F.free_esp(o)
        espByModel[model] = nil
    end
    F.hide_aim_draw()
    if F.staff_warn_free then
        F.staff_warn_free()
    end
    if F.stealer_off then
        F.stealer_off()
    end
    if F.stop_heal then
        F.stop_heal()
    end
    if F.chams_off then
        F.chams_off()
    end
    if F.mv_off then
        F.mv_off()
    end
    F.free_hit_fx()
    if fovCircle then
        fovCircle:Remove()
    end
    if abFovCircle then
        abFovCircle:Remove()
    end
    if chDot then
        chDot:Remove()
    end
    for i = 1, #chLines do
        chLines[i]:Remove()
    end
    if muzzleLine then
        muzzleLine:Remove()
    end
    if spoofLineA then
        spoofLineA:Remove()
    end
    if spoofLineB then
        spoofLineB:Remove()
    end
    for i = 1, #reticleLines do
        reticleLines[i]:Remove()
    end
    getgenv().CWCombat = nil
    
end

function F.install_staff_detect()
    local STAFF_GROUP = 32519006
    local STAFF_RANK = 103
    local STAFF_ROLES = {
        Admin = true,
        Owner = true,
        Granted = true,
    }
    local kicked = false
    local rankCache = {}
    local alerted = {}
    F.staff_running = true
    F.staffWarnUntil = 0
    local warnText = nil
    pcall(function()
        if Drawing and Drawing.new then
            warnText = Drawing.new("Text")
            warnText.Center = true
            warnText.Outline = true
            warnText.Size = 32
            warnText.Color = Color3.fromRGB(255, 45, 45)
            warnText.Text = "STAFF DETECTED!"
            warnText.ZIndex = 80
            warnText.Visible = false
        end
    end)
    F.staff_warn_free = function()
        F.staff_running = false
        F.staffWarnUntil = 0
        if warnText then
            warnText.Visible = false
            pcall(function()
                warnText:Remove()
            end)
            warnText = nil
        end
    end

    local pendingNotify = {}
    local function staff_notify(name)
        if not CFG.StaffNotify then
            return
        end
        if F.ui_notify then
            F.ui_notify("Staff Detect", name, true)
            return
        end
        pendingNotify[#pendingNotify + 1] = name
    end
    F.staff_flush_notify = function()
        if not F.ui_notify then
            return
        end
        for i = 1, #pendingNotify do
            F.ui_notify("Staff Detect", pendingNotify[i], true)
        end
        table.clear(pendingNotify)
    end

    local function staff_hit(plr)
        if not CFG.StaffDetect or not plr or plr == LP then
            return
        end
        local uid = plr.UserId
        local first = not alerted[uid]
        alerted[uid] = true
        if first then
            staff_notify(plr.Name)
            if CFG.StaffWarning then
                F.staffWarnUntil = clock() + 8
            end
        end
        if CFG.StaffKick and not kicked then
            kicked = true
            pcall(LP.Kick, LP, "Staff detected")
            task.defer(function()
                pcall(game.Shutdown, game)
                pcall(F.unload)
            end)
        end
    end

    local function private_attrs()
        local pg = LP:FindFirstChild("PlayerGui")
        return pg and pg:FindFirstChild("PrivateAttributes")
    end

    local function role_of(plr)
        local pa = private_attrs()
        local uid = plr and plr.UserId
        local role, key
        if pa and uid then
            key = "Role_" .. tostring(uid)
            role = pa:GetAttribute(key)
            if not role and type(uid) == "number" and uid < 0 then
                key = "Role_n" .. tostring(-uid)
                role = pa:GetAttribute(key)
            end
        end
        local old = plr and plr:GetAttribute("ControlPanelRole")
        return role, key, old
    end

    local function is_staff(plr)
        if not plr or plr == LP then
            return false
        end
        local role, _, old = role_of(plr)
        if STAFF_ROLES[role] or STAFF_ROLES[old] then
            return true
        end
        return false
    end

    local rankAt = {}
    local rankPending = {}
    local function check_player(plr)
        if kicked or not CFG.StaffDetect or not plr or plr == LP then
            return
        end
        if not plr.Parent then
            return
        end
        if is_staff(plr) then
            staff_hit(plr)
            return
        end
        local uid = plr.UserId
        if rankCache[uid] == true then
            staff_hit(plr)
            return
        end
        if rankPending[uid] then
            return
        end
        local now = clock()
        local last = rankAt[uid]
        local waitFor = 90
        if rankCache[uid] ~= false then
            waitFor = last and (now - last < 45) and 8 or 30
        end
        if last and now - last < waitFor then
            return
        end
        rankAt[uid] = now
        rankPending[uid] = true
        task.spawn(function()
            local ok, rank = pcall(function()
                return plr:GetRankInGroup(STAFF_GROUP)
            end)
            rankPending[uid] = nil
            if not ok or type(rank) ~= "number" then
                rankAt[uid] = now - 6
                return
            end
            if rank >= STAFF_RANK then
                rankCache[uid] = true
                staff_hit(plr)
            elseif rank > 0 then
                rankCache[uid] = false
            else
                rankCache[uid] = nil
            end
        end)
    end

    local function scan()
        if kicked or not CFG.StaffDetect then
            return
        end
        for i = 1, rosterN do
            check_player(roster[i])
        end
    end

    local function watch_join(plr)
        if not plr or plr == LP then
            return
        end
        check_player(plr)
        task.delay(2, check_player, plr)
        task.delay(8, check_player, plr)
        task.delay(20, check_player, plr)
    end

    F.bind(Players.PlayerAdded:Connect(watch_join))
    do
        local list = Players:GetPlayers()
        for i = 1, #list do
            task.defer(watch_join, list[i])
        end
    end
    local paHooked
    local function hook_pa(pa)
        if not (pa and F.staff_running) then
            return
        end
        if paHooked == pa then
            return
        end
        paHooked = pa
        F.bind(pa.AttributeChanged:Connect(function(attr)
            if type(attr) ~= "string" or string.sub(attr, 1, 5) ~= "Role_" then
                return
            end
            local rest = string.sub(attr, 6)
            if string.sub(rest, 1, 1) == "n" then
                rest = string.sub(rest, 2)
            end
            local uid = tonumber(rest)
            local plr = uid and Players:GetPlayerByUserId(uid)
            if plr then
                check_player(plr)
            else
                scan()
            end
        end))
        scan()
    end
    task.spawn(function()
        local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 20)
        if not pg then
            return
        end
        local pa = pg:FindFirstChild("PrivateAttributes")
        if pa then
            hook_pa(pa)
            return
        end
        F.bind(pg.ChildAdded:Connect(function(ch)
            if ch.Name == "PrivateAttributes" then
                hook_pa(ch)
            end
        end))
        pa = pg:WaitForChild("PrivateAttributes", 30)
        hook_pa(pa)
    end)
    task.spawn(function()
        while F.staff_running do
            task.wait(2)
            scan()
        end
    end)
    F.paint_staff_warn = function()
        if not warnText then
            return
        end
        local show = CFG.StaffDetect and CFG.StaffWarning and clock() < (F.staffWarnUntil or 0)
        if not show then
            if warnText.Visible then
                warnText.Visible = false
            end
            return
        end
        Cam = Workspace.CurrentCamera
        if Cam then
            local vp = Cam.ViewportSize
            vpX, vpY = vp.X, vp.Y
        end
        warnText.Visible = true
        warnText.Position = V2(vpX * 0.5, vpY * 0.28)
        local pulse = 0.4 + 0.6 * (0.5 + 0.5 * sin(clock() * 10))
        warnText.Transparency = pulse
    end
end

F.load_game_modules()
if not F.install_hooks() then
    task.spawn(function()
        for _ = 1, 25 do
            task.wait(0.4)
            pcall(F.load_game_modules)
            if F.install_hooks() then
                return
            end
        end
        warn("[CWCombat] ClientFire.fireVolley not found")
    end)
end
F.install_movement()
F.install_staff_detect()
pcall(function()
    RunService:BindToRenderStep("CW_VmAim", Enum.RenderPriority.Camera.Value + 2, function()
        F.vm_aim_offset()
        F.vm_style_step()
    end)
    RunService:BindToRenderStep("CW_Aimbot", Enum.RenderPriority.Camera.Value + 3, function(dt)
        if not CFG.Aimbot then
            return
        end
        if CFG.AimbotAdsOnly and not F.is_aiming() then
            return
        end
        if CFG.AimbotShootOnly and not F.is_shooting() then
            return
        end
        Cam = Workspace.CurrentCamera
        if not Cam then
            return
        end
        if type(dt) ~= "number" or dt <= 0 then
            dt = 1 / 60
        end
        local origin = Cam.CFrame.Position
        local now = clock()
        if now - abPickAt > 0.05 then
            abPickAt = now
            abTgt = F.pick_silent_target(origin, CFG.AimbotMaxDist, CFG.VisibleCheck, CFG.AimbotFOV, CFG.AimbotBone, false)
        end
        local tgt = abTgt
        if not (tgt and tgt.pos) then
            return
        end
        local live = tgt.bone
        local livePos = (live and live.Parent and live.Position) or tgt.pos
        local aimPos = livePos
        if CFG.AimbotPredict or tgt.inVeh then
            aimPos = F.light_predict(tgt.player, live, origin, livePos, tgt.inVeh)
        end
        local look = CFrame.lookAt(Cam.CFrame.Position, aimPos, Cam.CFrame.UpVector)
        local sm = CFG.AimbotSmooth
        if type(sm) ~= "number" or sm < 1 then
            sm = 1
        end
        local a = 1 - math.exp(-dt * (18 / sm))
        if a > 1 then
            a = 1
        end
        Cam.CFrame = Cam.CFrame:Lerp(look, a)
    end)
end)


local espRun = { cursor = 0, pickAt = 0, hidden = false }

F.bind(RunService.RenderStepped:Connect(function(dt)
    Cam = Workspace.CurrentCamera
    if not Cam then
        return
    end
    F.prep_frame()
    if F.paint_staff_warn then
        F.paint_staff_warn()
    end
    local now = clock()
    local mcf = F.muzzle_cframe()
    local muzzlePos = (mcf and mcf.Position) or Cam.CFrame.Position
    local origin = F.shot_origin(muzzlePos)
    if CFG.ESP then
        espRun.hidden = false
        F.sweep_esp_models()
        local n = rosterN
        if n > 0 then
            local per = CFG.EspPerFrame
            if type(per) ~= "number" or per <= 0 or per >= n then
                for i = 1, n do
                    F.update_esp_one(roster[i], Cam, muzzlePos)
                end
            else
                for i = 0, per - 1 do
                    local idx = ((espRun.cursor + i) % n) + 1
                    F.update_esp_one(roster[idx], Cam, muzzlePos)
                end
                espRun.cursor = (espRun.cursor + per) % n
            end
        end
    else
        if not espRun.hidden then
            for _, o in espByModel do
                F.hide_esp(o)
            end
            espRun.hidden = true
        end
    end
    F.update_chams(muzzlePos)

    local pickEvery = CFG.PickRate or 0
    if CFG.SilentAim and (pickEvery <= 0 or now - espRun.pickAt >= pickEvery) then
        espRun.pickAt = now
        saTgt = F.pick_silent_target(origin, CFG.SilentAimMaxDist, F.need_los())
    elseif not CFG.SilentAim then
        saTgt = nil
    end

    paintState.cam = Cam
    paintState.now = now
    paintState.muzzlePos = muzzlePos
    F.update_tracers(Cam, now)
    F.update_particles(Cam, dt)
    if not useDI then
        F.paint_overlay()
    end
end))

function F.buildUI(ctx)
    F.maclibUi = true
    local uiReady = false
    task.defer(function()
        uiReady = true
    end)
    local function notify(title, body, force)
        if uiReady or force then
            pcall(ctx.notify, title, body)
        end
    end
    F.ui_notify = notify
    if F.staff_flush_notify then
        F.staff_flush_notify()
    end
    local function disc(section, text)
        section:SubLabel({ Text = text })
    end
    local function feature(section, o)
        local guard, togEl = false, nil
        local function commit(val)
            val = val and true or false
            o.set(val)
            notify(o.Title, val and "Enabled" or "Disabled")
            guard = true
            if togEl then
                pcall(function()
                    togEl:UpdateState(val)
                end)
            end
            guard = false
        end
        togEl = section:Toggle({
            Name = "Enabled",
            Default = o.get() and true or false,
            Callback = function(v)
                if not guard then
                    commit(v)
                end
            end,
        }, ctx.flag(o.Flag))
        if o.Desc then
            disc(section, o.Desc)
        end
        ctx.keybind(section, {
            Name = "Keybind",
            Flag = ctx.flag(o.Flag .. "_KB"),
            OnBinded = o.OnBinded,
            Toggle = function()
                commit(not o.get())
            end,
        })
        return { commit = commit }
    end
    local function boolToggle(section, name, flag, get, set, desc)
        section:Toggle({
            Name = name,
            Default = get() and true or false,
            Callback = function(v)
                set(v and true or false)
                notify(name, v and "Enabled" or "Disabled")
            end,
        }, ctx.flag(flag))
        if desc then
            disc(section, desc)
        end
    end
    local function slider(section, o)
        local el = section:Slider({
            Name = o.Name,
            Default = o.Default,
            Minimum = o.Min,
            Maximum = o.Max,
            Precision = o.Precision or 0,
            Suffix = o.Suffix,
            Callback = o.Callback,
        }, ctx.flag(o.Flag))
        if o.Desc then
            disc(section, o.Desc)
        end
        return el
    end

    local Combat = ctx.tabs.Combat
    local GunMods = ctx.tabs.GunMods
    local Movement = ctx.tabs.Movement
    local Visuals = ctx.tabs.Visuals
    local Misc = ctx.tabs.Misc

    local sa = Combat:Section({ Side = "Left" })
    sa:Header({ Name = "Silent Aim" })
    feature(sa, {
        Title = "Silent Aim",
        Flag = "CW_SilentAim",
        get = function()
            return CFG.SilentAim
        end,
        set = function(v)
            CFG.SilentAim = v
        end,
    })
    boolToggle(sa, "Visible Check", "CW_SA_Vis", function()
        return CFG.VisibleCheck
    end, function(v)
        CFG.VisibleCheck = v
    end)
    boolToggle(sa, "Ignore Teammates", "CW_SA_Team", function()
        return CFG.IgnoreTeammates
    end, function(v)
        CFG.IgnoreTeammates = v
    end)
    boolToggle(sa, "Turret Silent", "CW_TurretSA", function()
        return CFG.TurretSA
    end, function(v)
        CFG.TurretSA = v
    end)
    sa:Dropdown({
        Name = "Hit Part",
        Options = { "Head", "Torso", "Random", "HumanoidRootPart" },
        Default = CFG.AimBone,
        Callback = function(v)
            CFG.AimBone = v
        end,
    }, ctx.flag("CW_AimBone"))
    slider(sa, {
        Name = "Head Chance",
        Flag = "CW_HeadChance",
        Default = CFG.HeadChance,
        Min = 0,
        Max = 100,
        Suffix = "%",
        Desc = "When Hit Part is Head, chance to go for the head. Otherwise torso.",
        Callback = function(v)
            CFG.HeadChance = v
        end,
    })
    slider(sa, {
        Name = "FOV",
        Flag = "CW_SA_FOV",
        Default = CFG.SilentAimFOV,
        Min = 1,
        Max = 360,
        Suffix = " deg",
        Callback = function(v)
            CFG.SilentAimFOV = v
        end,
    })
    slider(sa, {
        Name = "Max Distance",
        Flag = "CW_SA_MaxDist",
        Default = CFG.SilentAimMaxDist,
        Min = 20,
        Max = 2000,
        Suffix = " stds",
        Callback = function(v)
            CFG.SilentAimMaxDist = v
        end,
    })
    slider(sa, {
        Name = "Hit Chance",
        Flag = "CW_HitChance",
        Default = CFG.HitChance,
        Min = 0,
        Max = 100,
        Suffix = "%",
        Desc = "How often silent aim takes the shot.",
        Callback = function(v)
            CFG.HitChance = v
        end,
    })

    sa:Divider()
    sa:Header({ Name = "Instant Hit" })
    boolToggle(sa, "Enabled", "CW_InstantHit", function()
        return CFG.InstantHit
    end, function(v)
        CFG.InstantHit = v
    end, "Speeds up your tracer. The hit lands with the bullet.")
    slider(sa, {
        Name = "Bullet Speed",
        Flag = "CW_InstantMul",
        Default = CFG.InstantHitMul,
        Min = 1,
        Max = 4,
        Precision = 2,
        Suffix = "x",
        Callback = function(v)
            CFG.InstantHitMul = v
        end,
    })
    boolToggle(sa, "Force Hit", "CW_ForceHit", function()
        return CFG.ForceHit
    end, function(v)
        CFG.ForceHit = v
    end, "If the bullet hits them or passes close, the hit registers on the selected part.")
    sa:Dropdown({
        Name = "Force Hit Part",
        Options = { "auto", "Head", "Torso" },
        Default = CFG.ForceHitPart or "auto",
        Callback = function(v)
            CFG.ForceHitPart = v
        end,
    }, ctx.flag("CW_ForceHitPart"))
    slider(sa, {
        Name = "Force Hit Margin",
        Flag = "CW_ForceMargin",
        Default = CFG.ForceHitMargin,
        Min = 0.5,
        Max = 5,
        Precision = 1,
        Suffix = " stds",
        Desc = "Near-miss distance that still counts.",
        Callback = function(v)
            CFG.ForceHitMargin = v
        end,
    })

    sa:Divider()
    sa:Header({ Name = "Prediction" })
    boolToggle(sa, "Enabled", "CW_GunPredict", function()
        return CFG.GunPredict
    end, function(v)
        CFG.GunPredict = v
    end)
    boolToggle(sa, "Ignore Weapon Speed", "CW_PredIgnWep", function()
        return CFG.PredictIgnoreWeapon
    end, function(v)
        CFG.PredictIgnoreWeapon = v
    end)
    slider(sa, {
        Name = "Fixed Speed",
        Flag = "CW_PredFixed",
        Default = CFG.PredictFixedSpeed,
        Min = 200,
        Max = 2000,
        Callback = function(v)
            CFG.PredictFixedSpeed = v
        end,
    })
    slider(sa, {
        Name = "Gun Lead",
        Flag = "CW_GunPred",
        Default = CFG.GunPredictMul,
        Min = 0,
        Max = 4,
        Precision = 2,
        Callback = function(v)
            CFG.GunPredictMul = v
        end,
    })
    slider(sa, {
        Name = "Vehicle Lead",
        Flag = "CW_VehPred",
        Default = CFG.GunPredictVehicleMul,
        Min = 0,
        Max = 4,
        Precision = 2,
        Callback = function(v)
            CFG.GunPredictVehicleMul = v
        end,
    })
    slider(sa, {
        Name = "Interp Lead",
        Flag = "CW_InterpLead",
        Default = CFG.InterpLead,
        Min = 0,
        Max = 0.4,
        Precision = 3,
        Callback = function(v)
            CFG.InterpLead = v
        end,
    })
    slider(sa, {
        Name = "Vehicle Interp",
        Flag = "CW_InterpVeh",
        Default = CFG.InterpLeadVehicle,
        Min = 0,
        Max = 0.4,
        Precision = 3,
        Callback = function(v)
            CFG.InterpLeadVehicle = v
        end,
    })
    slider(sa, {
        Name = "Max Lead",
        Flag = "CW_PredCap",
        Default = CFG.PredictMaxLead,
        Min = 0,
        Max = 24,
        Precision = 1,
        Suffix = " stds",
        Callback = function(v)
            CFG.PredictMaxLead = v
        end,
    })
    slider(sa, {
        Name = "Vehicle Max Lead",
        Flag = "CW_PredCapVeh",
        Default = CFG.PredictMaxLeadVehicle,
        Min = 0,
        Max = 80,
        Precision = 1,
        Suffix = " stds",
        Callback = function(v)
            CFG.PredictMaxLeadVehicle = v
        end,
    })

    sa:Divider()
    sa:Header({ Name = "MultiPoint" })
    boolToggle(sa, "Enabled", "CW_MultiPoint", function()
        return CFG.MultiPoint
    end, function(v)
        CFG.MultiPoint = v
    end, "Shoots around cover when the target is blocked.")
    boolToggle(sa, "Spoof Origin", "CW_SpoofOrigin", function()
        return CFG.SpoofOrigin
    end, function(v)
        CFG.SpoofOrigin = v
    end)
    boolToggle(sa, "Origin From HRP", "CW_OriginHRP", function()
        return CFG.OriginFromHRP
    end, function(v)
        CFG.OriginFromHRP = v
    end)
    slider(sa, {
        Name = "Offset",
        Flag = "CW_MPOff",
        Default = CFG.MPMaxOffset,
        Min = 1,
        Max = 12,
        Precision = 1,
        Suffix = " stds",
        Callback = function(v)
            CFG.MPMaxOffset = v
        end,
    })
    slider(sa, {
        Name = "Max Dist",
        Flag = "CW_MPMaxDist",
        Default = CFG.MPMaxDist or 500,
        Min = 50,
        Max = 800,
        Suffix = " stds",
        Desc = "How far MultiPoint still works.",
        Callback = function(v)
            CFG.MPMaxDist = v
        end,
    })
    slider(sa, {
        Name = "Origin Budget",
        Flag = "CW_OriginBudget",
        Default = CFG.OriginBudget,
        Min = 0,
        Max = 12,
        Precision = 1,
        Suffix = " stds",
        Callback = function(v)
            CFG.OriginBudget = v
        end,
    })

    local lg = Combat:Section({ Side = "Left" })
    lg:Header({ Name = "Shot Noise" })
    disc(lg, "Makes silent shots look less perfect.")
    boolToggle(lg, "Enabled", "CW_LegitAim", function()
        return CFG.LegitAim
    end, function(v)
        CFG.LegitAim = v
    end)
    slider(lg, {
        Name = "Spread",
        Flag = "CW_LegitSpread",
        Default = CFG.LegitSpread,
        Min = 0,
        Max = 2,
        Precision = 2,
        Suffix = " deg",
        Desc = "Random cone on redirected shots.",
        Callback = function(v)
            CFG.LegitSpread = v
        end,
    })
    slider(lg, {
        Name = "Bone Jitter",
        Flag = "CW_LegitJitter",
        Default = CFG.LegitBoneJitter,
        Min = 0.05,
        Max = 0.45,
        Precision = 2,
        Desc = "Random offset inside the hitbox.",
        Callback = function(v)
            CFG.LegitBoneJitter = v
        end,
    })

    local ab = Combat:Section({ Side = "Right" })
    ab:Header({ Name = "Aimbot" })
    feature(ab, {
        Title = "Aimbot",
        Flag = "CW_Aimbot",
        get = function()
            return CFG.Aimbot
        end,
        set = function(v)
            CFG.Aimbot = v
        end,
    })
    boolToggle(ab, "Only When Aiming", "CW_AbAds", function()
        return CFG.AimbotAdsOnly
    end, function(v)
        CFG.AimbotAdsOnly = v
    end)
    boolToggle(ab, "Only When Shooting", "CW_AbShoot", function()
        return CFG.AimbotShootOnly
    end, function(v)
        CFG.AimbotShootOnly = v
    end)
    ab:Dropdown({
        Name = "Aim Bone",
        Options = { "Head", "Torso", "HumanoidRootPart" },
        Default = CFG.AimbotBone,
        Callback = function(v)
            CFG.AimbotBone = v
        end,
    }, ctx.flag("CW_AbBone"))
    boolToggle(ab, "Predict", "CW_AbPred", function()
        return CFG.AimbotPredict
    end, function(v)
        CFG.AimbotPredict = v
    end, "Leads the camera on moving targets.")
    slider(ab, {
        Name = "Predict Amount",
        Flag = "CW_AbPredMul",
        Default = CFG.AimbotPredictMul,
        Min = 0,
        Max = 1.5,
        Precision = 2,
        Callback = function(v)
            CFG.AimbotPredictMul = v
        end,
    })
    slider(ab, {
        Name = "FOV",
        Flag = "CW_AbFOV",
        Default = CFG.AimbotFOV,
        Min = 1,
        Max = 360,
        Suffix = " deg",
        Callback = function(v)
            CFG.AimbotFOV = v
        end,
    })
    slider(ab, {
        Name = "Distance",
        Flag = "CW_AbDist",
        Default = CFG.AimbotMaxDist,
        Min = 20,
        Max = 2000,
        Suffix = " stds",
        Callback = function(v)
            CFG.AimbotMaxDist = v
        end,
    })
    slider(ab, {
        Name = "Smoothing",
        Flag = "CW_AbSmooth",
        Default = CFG.AimbotSmooth,
        Min = 1,
        Max = 25,
        Precision = 1,
        Desc = "How fast the camera locks on.",
        Callback = function(v)
            CFG.AimbotSmooth = v
        end,
    })
    boolToggle(ab, "FOV Circle", "CW_AbShowFOV", function()
        return CFG.AimbotShowFOV
    end, function(v)
        CFG.AimbotShowFOV = v
    end)
    slider(ab, {
        Name = "Circle Thickness",
        Flag = "CW_AbFovThick",
        Default = CFG.AimbotFovThick,
        Min = 0.4,
        Max = 6,
        Precision = 1,
        Callback = function(v)
            CFG.AimbotFovThick = v
        end,
    })
    slider(ab, {
        Name = "Circle Opacity",
        Flag = "CW_AbFovOp",
        Default = CFG.AimbotFovTrans,
        Min = 0,
        Max = 1,
        Precision = 2,
        Callback = function(v)
            CFG.AimbotFovTrans = v
        end,
    })
    ab:Colorpicker({
        Name = "Circle Color",
        Default = CFG.AimbotFovColor,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.AimbotFovColor = c
            end
        end,
    }, ctx.flag("CW_AbFovCol"))

    local vis = Combat:Section({ Side = "Right" })
    vis:Header({ Name = "Silent Visuals" })
    boolToggle(vis, "Show FOV", "CW_ShowFOV", function()
        return CFG.ShowFOV
    end, function(v)
        CFG.ShowFOV = v
        CFG.FovCircle = v
    end)
    boolToggle(vis, "Filled FOV", "CW_FovFilled", function()
        return CFG.FovCircleFilled
    end, function(v)
        CFG.FovCircleFilled = v
    end)
    boolToggle(vis, "Muzzle Line", "CW_Muzzle", function()
        return CFG.MuzzleVisual
    end, function(v)
        CFG.MuzzleVisual = v
    end)
    boolToggle(vis, "Aim Marker", "CW_AimViz", function()
        return CFG.AimVisuals
    end, function(v)
        CFG.AimVisuals = v
    end)
    vis:Dropdown({
        Name = "Marker Style",
        Options = { "Default", "CrossGap", "DefaultV2", "Diamond" },
        Default = CFG.AimVisualStyle,
        Callback = function(v)
            CFG.AimVisualStyle = v
        end,
    }, ctx.flag("CW_AimStyle"))
    slider(vis, {
        Name = "Marker Scale",
        Flag = "CW_AimScale",
        Default = CFG.AimVisualScale,
        Min = 0.3,
        Max = 3,
        Precision = 2,
        Callback = function(v)
            CFG.AimVisualScale = v
        end,
    })
    slider(vis, {
        Name = "FOV Thickness",
        Flag = "CW_FovThick",
        Default = CFG.FovCircleThick,
        Min = 0.4,
        Max = 6,
        Precision = 1,
        Callback = function(v)
            CFG.FovCircleThick = v
        end,
    })
    slider(vis, {
        Name = "FOV Opacity",
        Flag = "CW_FovOp",
        Default = CFG.FovCircleTrans,
        Min = 0,
        Max = 1,
        Precision = 2,
        Callback = function(v)
            CFG.FovCircleTrans = v
        end,
    })
    slider(vis, {
        Name = "Muzzle Opacity",
        Flag = "CW_MuzOp",
        Default = CFG.MuzzleLineTrans,
        Min = 0,
        Max = 1,
        Precision = 2,
        Callback = function(v)
            CFG.MuzzleLineTrans = v
        end,
    })
    vis:Colorpicker({
        Name = "FOV Color",
        Default = CFG.FovCircleColor or CFG.FOVColor,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.FovCircleColor = c
                CFG.FOVColor = c
            end
        end,
    }, ctx.flag("CW_FOVColor"))
    vis:Colorpicker({
        Name = "Muzzle Color",
        Default = CFG.MuzzleLineColor,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.MuzzleLineColor = c
            end
        end,
    }, ctx.flag("CW_MuzColor"))

    local gmR = GunMods:Section({ Side = "Left" })
    gmR:Header({ Name = "No Recoil" })
    feature(gmR, {
        Title = "No Recoil",
        Flag = "CW_NoRecoil",
        get = function()
            return CFG.NoRecoil
        end,
        set = function(v)
            CFG.NoRecoil = v
        end,
    })

    local gmNs = GunMods:Section({ Side = "Left" })
    gmNs:Header({ Name = "No Spread" })
    feature(gmNs, {
        Title = "No Spread",
        Flag = "CW_NoSpread",
        get = function()
            return CFG.NoSpread
        end,
        set = function(v)
            CFG.NoSpread = v
        end,
    })

    local gmFa = GunMods:Section({ Side = "Right" })
    gmFa:Header({ Name = "Full Auto" })
    feature(gmFa, {
        Title = "Full Auto",
        Flag = "CW_FullAuto",
        get = function()
            return CFG.FullAuto
        end,
        set = function(v)
            CFG.FullAuto = v
        end,
    })

    local gmCh = GunMods:Section({ Side = "Right" })
    gmCh:Header({ Name = "Crosshair Aim" })
    feature(gmCh, {
        Title = "Crosshair Aim",
        Flag = "CW_CrosshairAim",
        Desc = "Shoots from the center of the screen.",
        get = function()
            return CFG.CrosshairAim
        end,
        set = function(v)
            CFG.CrosshairAim = v
        end,
    })

    local gmA = GunMods:Section({ Side = "Right" })
    gmA:Header({ Name = "Instant Aim" })
    feature(gmA, {
        Title = "Instant Aim",
        Flag = "CW_InstantAim",
        get = function()
            return CFG.InstantAim
        end,
        set = function(v)
            CFG.InstantAim = v
        end,
    })

    local gmE = GunMods:Section({ Side = "Left" })
    gmE:Header({ Name = "Instant Equip" })
    feature(gmE, {
        Title = "Instant Equip",
        Flag = "CW_InstantEquip",
        get = function()
            return CFG.InstantEquip
        end,
        set = function(v)
            CFG.InstantEquip = v
        end,
    })
    slider(gmE, {
        Name = "Equip Speed",
        Flag = "CW_EquipSpd",
        Default = CFG.EquipAnimSpeed,
        Min = 1,
        Max = 20,
        Precision = 1,
        Callback = function(v)
            CFG.EquipAnimSpeed = v
        end,
    })
    boolToggle(gmE, "Instant Reload", "CW_InstantReload", function()
        return CFG.InstantReload
    end, function(v)
        CFG.InstantReload = v
    end)
    boolToggle(gmE, "Reload Sprint", "CW_ReloadSprint", function()
        return CFG.ReloadSprint
    end, function(v)
        CFG.ReloadSprint = v
    end)
    boolToggle(gmE, "Always Act", "CW_AlwaysAct", function()
        return CFG.AlwaysAct
    end, function(v)
        CFG.AlwaysAct = v
    end)

    local gmZ = GunMods:Section({ Side = "Left" })
    gmZ:Header({ Name = "Custom Zoom" })
    feature(gmZ, {
        Title = "Custom Zoom",
        Flag = "CW_CustomZoom",
        Desc = "Sets ADS zoom from 1x to 10x.",
        get = function()
            return CFG.CustomZoom
        end,
        set = function(v)
            CFG.CustomZoom = v
            if v then
                F.apply_custom_zoom()
            elseif CamCtrl and type(CamCtrl.resetFOV) == "function" then
                local aiming = AimCtrl and type(AimCtrl.isAiming) == "function" and AimCtrl.isAiming()
                if not aiming then
                    pcall(CamCtrl.resetFOV)
                end
            end
        end,
    })
    slider(gmZ, {
        Name = "Zoom",
        Flag = "CW_CustomZoomMul",
        Default = CFG.CustomZoomMul,
        Min = 1,
        Max = 10,
        Precision = 2,
        Suffix = "x",
        Desc = "ADS magnification.",
        Callback = function(v)
            CFG.CustomZoomMul = v
            F.apply_custom_zoom()
        end,
    })
    boolToggle(gmZ, "Wheel Zoom", "CW_WheelZoom", function()
        return CFG.WheelZoom
    end, function(v)
        CFG.WheelZoom = v
    end, "Scroll the mouse wheel while aiming to change zoom.")

    local ad = Movement:Section({ Side = "Left" })
    ad:Header({ Name = "Fly" })
    feature(ad, {
        Title = "Fly",
        Flag = "CW_Fly",
        get = function()
            return CFG.Fly
        end,
        set = function(v)
            if F.set_fly then
                F.set_fly(v)
            else
                CFG.Fly = v
            end
        end,
    })
    slider(ad, {
        Name = "Speed",
        Flag = "CW_FlySpd",
        Default = CFG.FlySpeed,
        Min = 8,
        Max = 160,
        Callback = function(v)
            CFG.FlySpeed = v
        end,
    })

    local ts = Movement:Section({ Side = "Left" })
    ts:Header({ Name = "Speed" })
    feature(ts, {
        Title = "Speed",
        Flag = "CW_Speed",
        get = function()
            return CFG.Speed
        end,
        set = function(v)
            if F.set_speed then
                F.set_speed(v)
            else
                CFG.Speed = v
            end
        end,
    })
    slider(ts, {
        Name = "Studs",
        Flag = "CW_SpeedStuds",
        Default = CFG.SpeedStuds,
        Min = 8,
        Max = 120,
        Callback = function(v)
            CFG.SpeedStuds = v
            if CFG.Speed and F.set_speed then
                F.set_speed(true)
            end
        end,
    })

    local hj = Movement:Section({ Side = "Left" })
    hj:Header({ Name = "NoClip" })
    feature(hj, {
        Title = "NoClip",
        Flag = "CW_NoClip",
        get = function()
            return CFG.NoClip
        end,
        set = function(v)
            if F.set_noclip then
                F.set_noclip(v)
            else
                CFG.NoClip = v
            end
        end,
    })
    boolToggle(hj, "No Fall", "CW_NoFall", function()
        return CFG.NoFall
    end, function(v)
        CFG.NoFall = v
    end)
    boolToggle(hj, "No Limp", "CW_NoLimp", function()
        return CFG.NoLimp
    end, function(v)
        CFG.NoLimp = v
    end)

    local car = Movement:Section({ Side = "Right" })
    car:Header({ Name = "Vehicle Speed" })
    feature(car, {
        Title = "Vehicle Speed",
        Flag = "CW_VehSpeed",
        get = function()
            return CFG.VehicleSpeed
        end,
        set = function(v)
            CFG.VehicleSpeed = v
        end,
    })
    slider(car, {
        Name = "Multiplier",
        Flag = "CW_VehMul",
        Default = CFG.VehicleSpeedMul,
        Min = 1,
        Max = 5,
        Precision = 2,
        Desc = "Makes vehicles faster.",
        Callback = function(v)
            CFG.VehicleSpeedMul = v
        end,
    })

    local sit = Movement:Section({ Side = "Right" })
    sit:Header({ Name = "Instant Sit" })
    feature(sit, {
        Title = "Instant Sit",
        Flag = "CW_InstantSit",
        get = function()
            return CFG.InstantSit
        end,
        set = function(v)
            CFG.InstantSit = v
        end,
    })
    slider(sit, {
        Name = "Sit Speed",
        Flag = "CW_SitSpd",
        Default = CFG.SitAnimSpeed,
        Min = 1,
        Max = 20,
        Precision = 1,
        Callback = function(v)
            CFG.SitAnimSpeed = v
        end,
    })

    local steal = Movement:Section({ Side = "Right" })
    steal:Header({ Name = "Vehicle Stealer" })
    feature(steal, {
        Title = "Vehicle Stealer",
        Flag = "CW_VehSteal",
        Desc = "Lets you enter locked vehicles.",
        get = function()
            return CFG.VehicleStealer
        end,
        set = function(v)
            CFG.VehicleStealer = v
            if not v then
                if F.stealer_off then
                    F.stealer_off()
                end
            elseif F.stealer_scan then
                F.stealer_scan()
            end
        end,
    })
    boolToggle(steal, "Highlight locked cars", "CW_VehStealHl", function()
        return CFG.VehicleStealHighlight
    end, function(v)
        CFG.VehicleStealHighlight = v and true or false
        if not CFG.VehicleStealHighlight then
            if F.stealer_off then
                F.stealer_off()
            end
        elseif F.stealer_scan then
            F.stealer_scan()
        end
    end, "Marks locked vehicles in red.")

    local es = Visuals:Section({ Side = "Left" })
    es:Header({ Name = "ESP" })
    feature(es, {
        Title = "ESP",
        Flag = "CW_ESP",
        get = function()
            return CFG.ESP
        end,
        set = function(v)
            CFG.ESP = v
        end,
    })
    boolToggle(es, "Enemy Only", "CW_EspEnemy", function()
        return CFG.EspEnemyOnly
    end, function(v)
        CFG.EspEnemyOnly = v
    end)
    boolToggle(es, "Box", "CW_EspBox", function()
        return CFG.EspBox
    end, function(v)
        CFG.EspBox = v
    end)
    es:Dropdown({
        Name = "Box Mode",
        Options = { "Corner", "Full" },
        Default = CFG.EspBoxMode,
        Callback = function(v)
            CFG.EspBoxMode = v
        end,
    }, ctx.flag("CW_EspBoxMode"))
    slider(es, {
        Name = "Box Thickness",
        Flag = "CW_EspBoxTh",
        Default = CFG.EspBoxThickness,
        Min = 0.5,
        Max = 4,
        Precision = 1,
        Callback = function(v)
            CFG.EspBoxThickness = v
        end,
    })
    slider(es, {
        Name = "Corner Scale",
        Flag = "CW_EspCorner",
        Default = CFG.EspCornerScale,
        Min = 0.1,
        Max = 0.5,
        Precision = 2,
        Callback = function(v)
            CFG.EspCornerScale = v
        end,
    })
    slider(es, {
        Name = "Box Aspect",
        Flag = "CW_EspAspect",
        Default = CFG.EspBoxAspect,
        Min = 0.3,
        Max = 1,
        Precision = 2,
        Callback = function(v)
            CFG.EspBoxAspect = v
        end,
    })
    boolToggle(es, "Name", "CW_EspName", function()
        return CFG.EspShowName
    end, function(v)
        CFG.EspShowName = v
    end)
    boolToggle(es, "Distance", "CW_EspDist", function()
        return CFG.EspShowDistance
    end, function(v)
        CFG.EspShowDistance = v
    end)
    boolToggle(es, "Weapon", "CW_EspWep", function()
        return CFG.EspShowWeapon
    end, function(v)
        CFG.EspShowWeapon = v
    end)
    boolToggle(es, "Hotbar", "CW_EspHot", function()
        return CFG.EspShowHotbar
    end, function(v)
        CFG.EspShowHotbar = v
    end)
    boolToggle(es, "States", "CW_EspState", function()
        return CFG.EspShowStates
    end, function(v)
        CFG.EspShowStates = v
    end)
    boolToggle(es, "HP Bar", "CW_EspHp", function()
        return CFG.EspHpBar
    end, function(v)
        CFG.EspHpBar = v
    end)
    boolToggle(es, "Visible Check", "CW_EspVis", function()
        return CFG.EspVisibleCheck
    end, function(v)
        CFG.EspVisibleCheck = v
    end)
    slider(es, {
        Name = "Vis Check Distance",
        Flag = "CW_EspVisMax",
        Default = CFG.EspVisMaxDist,
        Min = 50,
        Max = 2000,
        Suffix = " stds",
        Desc = "Skip vis check past this range.",
        Callback = function(v)
            CFG.EspVisMaxDist = v
        end,
    })
    boolToggle(es, "Smooth", "CW_EspSmooth", function()
        return CFG.EspSmooth
    end, function(v)
        CFG.EspSmooth = v
    end)
    slider(es, {
        Name = "Max Distance",
        Flag = "CW_EspMax",
        Default = CFG.EspMaxDistance,
        Min = 50,
        Max = 2000,
        Callback = function(v)
            CFG.EspMaxDistance = v
        end,
    })
    slider(es, {
        Name = "Text Size",
        Flag = "CW_EspText",
        Default = CFG.EspTextSize,
        Min = 8,
        Max = 28,
        Callback = function(v)
            CFG.EspTextSize = v
        end,
    })
    es:Colorpicker({
        Name = "Visible",
        Default = CFG.EspColorVisible,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.EspColorVisible = c
            end
        end,
    }, ctx.flag("CW_EspVisCol"))
    es:Colorpicker({
        Name = "Hidden",
        Default = CFG.EspColorHidden,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.EspColorHidden = c
            end
        end,
    }, ctx.flag("CW_EspHid"))
    es:Colorpicker({
        Name = "Name",
        Default = CFG.EspColorName,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.EspColorName = c
            end
        end,
    }, ctx.flag("CW_EspNameCol"))
    es:Colorpicker({
        Name = "HP High",
        Default = CFG.EspHpHigh,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.EspHpHigh = c
            end
        end,
    }, ctx.flag("CW_EspHpHi"))
    es:Colorpicker({
        Name = "HP Low",
        Default = CFG.EspHpLow,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.EspHpLow = c
            end
        end,
    }, ctx.flag("CW_EspHpLo"))

    local chm = Visuals:Section({ Side = "Right" })
    chm:Header({ Name = "Chams" })
    feature(chm, {
        Title = "Chams",
        Flag = "CW_Chams",
        Desc = "Highlights players through walls.",
        get = function()
            return CFG.Chams
        end,
        set = function(v)
            CFG.Chams = v
            if not v and F.chams_off then
                F.chams_off()
            end
        end,
    })
    boolToggle(chm, "Enemy Only", "CW_ChamsEnemy", function()
        return CFG.ChamsEnemyOnly
    end, function(v)
        CFG.ChamsEnemyOnly = v
    end)
    boolToggle(chm, "Outline", "CW_ChamsOutline", function()
        return CFG.ChamsOutline
    end, function(v)
        CFG.ChamsOutline = v
    end)
    slider(chm, {
        Name = "Fill Transparency",
        Flag = "CW_ChamsFillT",
        Default = CFG.ChamsFillTrans,
        Min = 0,
        Max = 1,
        Precision = 2,
        Desc = "How see-through the fill is.",
        Callback = function(v)
            CFG.ChamsFillTrans = v
        end,
    })
    slider(chm, {
        Name = "Outline Transparency",
        Flag = "CW_ChamsOutT",
        Default = CFG.ChamsOutlineTrans,
        Min = 0,
        Max = 1,
        Precision = 2,
        Callback = function(v)
            CFG.ChamsOutlineTrans = v
        end,
    })
    slider(chm, {
        Name = "Max Distance",
        Flag = "CW_ChamsMax",
        Default = CFG.ChamsMaxDistance,
        Min = 50,
        Max = 2000,
        Suffix = " stds",
        Callback = function(v)
            CFG.ChamsMaxDistance = v
        end,
    })
    slider(chm, {
        Name = "Vis Check Distance",
        Flag = "CW_ChamsVisMax",
        Default = CFG.ChamsVisMaxDist,
        Min = 50,
        Max = 2000,
        Suffix = " stds",
        Desc = "Skip vis check past this range.",
        Callback = function(v)
            CFG.ChamsVisMaxDist = v
        end,
    })
    chm:Colorpicker({
        Name = "Visible",
        Default = CFG.ChamsColorVisible,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.ChamsColorVisible = c
            end
        end,
    }, ctx.flag("CW_ChamsVisCol"))
    chm:Colorpicker({
        Name = "Hidden",
        Default = CFG.ChamsColorHidden,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.ChamsColorHidden = c
            end
        end,
    }, ctx.flag("CW_ChamsHidCol"))

    local fx = Visuals:Section({ Side = "Right" })
    fx:Header({ Name = "Bullet Tracer" })
    boolToggle(fx, "Enabled", "CW_Tracers", function()
        return CFG.ShotTracers
    end, function(v)
        CFG.ShotTracers = v
    end)
    slider(fx, {
        Name = "Duration",
        Flag = "CW_TrDur",
        Default = CFG.TracerDuration,
        Min = 0.1,
        Max = 4,
        Precision = 2,
        Suffix = "s",
        Callback = function(v)
            CFG.TracerDuration = v
        end,
    })
    slider(fx, {
        Name = "Thickness",
        Flag = "CW_TrThick",
        Default = CFG.TracerThickness,
        Min = 0.2,
        Max = 4,
        Precision = 1,
        Callback = function(v)
            CFG.TracerThickness = v
        end,
    })
    slider(fx, {
        Name = "Fade In",
        Flag = "CW_TrFade",
        Default = CFG.TracerFadeIn,
        Min = 0,
        Max = 0.8,
        Precision = 2,
        Suffix = "s",
        Callback = function(v)
            CFG.TracerFadeIn = v
        end,
    })
    fx:Colorpicker({
        Name = "Color",
        Default = CFG.TracerColor,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.TracerColor = c
            end
        end,
    }, ctx.flag("CW_TrColor"))

    local hs = Visuals:Section({ Side = "Right" })
    hs:Header({ Name = "Hit Sound" })
    boolToggle(hs, "Enabled", "CW_HitSound", function()
        return CFG.HitSound
    end, function(v)
        CFG.HitSound = v
    end)
    hs:Button({
        Name = "Preview",
        Callback = function()
            F.play_hit_sound()
        end,
    })
    hs:Dropdown({
        Name = "Preset",
        Options = HIT_SOUND_ORDER,
        Default = CFG.HitSoundPreset,
        Callback = function(v)
            CFG.HitSoundPreset = v
            if HIT_SOUNDS[v] then
                CFG.HitSoundId = HIT_SOUNDS[v]
            end
        end,
    }, ctx.flag("CW_HitPreset"))
    slider(hs, {
        Name = "Volume",
        Flag = "CW_HitVol",
        Default = CFG.HitSoundVolume,
        Min = 0,
        Max = 10,
        Precision = 1,
        Callback = function(v)
            CFG.HitSoundVolume = v
        end,
    })
    slider(hs, {
        Name = "Pitch",
        Flag = "CW_HitPitch",
        Default = CFG.HitSoundPitch,
        Min = 0.5,
        Max = 2,
        Precision = 2,
        Callback = function(v)
            CFG.HitSoundPitch = v
        end,
    })

    local hp = Visuals:Section({ Side = "Right" })
    hp:Header({ Name = "Hit Particles" })
    boolToggle(hp, "Enabled", "CW_HitFX", function()
        return CFG.HitParticles
    end, function(v)
        CFG.HitParticles = v
    end)
    hp:Dropdown({
        Name = "Type",
        Options = { "Wireframe", "Orbs", "Sparks" },
        Default = CFG.HitParticleType,
        Callback = function(v)
            CFG.HitParticleType = v
        end,
    }, ctx.flag("CW_HitPType"))
    slider(hp, {
        Name = "Count",
        Flag = "CW_HitPCount",
        Default = CFG.HitParticleCount,
        Min = 4,
        Max = 48,
        Callback = function(v)
            CFG.HitParticleCount = v
        end,
    })
    slider(hp, {
        Name = "Duration",
        Flag = "CW_HitPDur",
        Default = CFG.HitParticleDur,
        Min = 0.2,
        Max = 4,
        Precision = 2,
        Callback = function(v)
            CFG.HitParticleDur = v
        end,
    })
    hp:Colorpicker({
        Name = "Color A",
        Default = CFG.HitParticleColorA,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.HitParticleColorA = c
            end
        end,
    }, ctx.flag("CW_HitPA"))
    hp:Colorpicker({
        Name = "Color B",
        Default = CFG.HitParticleColorB,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.HitParticleColorB = c
            end
        end,
    }, ctx.flag("CW_HitPB"))

    local chs = Visuals:Section({ Side = "Left" })
    chs:Header({ Name = "Crosshair" })
    boolToggle(chs, "Enabled", "CW_Crosshair", function()
        return CFG.Crosshair
    end, function(v)
        CFG.Crosshair = v
    end)
    boolToggle(chs, "Hide When Aiming", "CW_ChHideAds", function()
        return CFG.CrosshairHideAds
    end, function(v)
        CFG.CrosshairHideAds = v
    end)
    boolToggle(chs, "Sync With Aim", "CW_ChSync", function()
        return CFG.CrosshairSyncAim
    end, function(v)
        CFG.CrosshairSyncAim = v
    end, "Moves the crosshair to the aim point while ADS.")
    slider(chs, {
        Name = "Sync Pad",
        Flag = "CW_ChSyncPad",
        Default = CFG.CrosshairSyncPad,
        Min = 0,
        Max = 40,
        Suffix = " px",
        Desc = "How far the synced crosshair sits from center.",
        Callback = function(v)
            CFG.CrosshairSyncPad = v
        end,
    })
    chs:Dropdown({
        Name = "Style",
        Options = { "Cross", "CrossGap", "T", "Dot", "Circle" },
        Default = CFG.CrosshairStyle,
        Callback = function(v)
            CFG.CrosshairStyle = v
        end,
    }, ctx.flag("CW_ChStyle"))
    slider(chs, {
        Name = "Size",
        Flag = "CW_ChSize",
        Default = CFG.CrosshairSize,
        Min = 2,
        Max = 40,
        Precision = 1,
        Callback = function(v)
            CFG.CrosshairSize = v
        end,
    })
    slider(chs, {
        Name = "Gap",
        Flag = "CW_ChGap",
        Default = CFG.CrosshairGap,
        Min = 0,
        Max = 20,
        Precision = 1,
        Callback = function(v)
            CFG.CrosshairGap = v
        end,
    })
    slider(chs, {
        Name = "Thickness",
        Flag = "CW_ChThick",
        Default = CFG.CrosshairThick,
        Min = 0.4,
        Max = 5,
        Precision = 1,
        Callback = function(v)
            CFG.CrosshairThick = v
        end,
    })
    slider(chs, {
        Name = "Opacity",
        Flag = "CW_ChOp",
        Default = CFG.CrosshairTrans,
        Min = 0,
        Max = 1,
        Precision = 2,
        Callback = function(v)
            CFG.CrosshairTrans = v
        end,
    })
    chs:Colorpicker({
        Name = "Color",
        Default = CFG.CrosshairColor,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.CrosshairColor = c
            end
        end,
    }, ctx.flag("CW_ChCol"))

    local vm = Visuals:Section({ Side = "Left" })
    vm:Header({ Name = "Aim Viewmodel" })
    disc(vm, "Moves the first-person gun while aiming.")
    boolToggle(vm, "Enabled", "CW_VmAim", function()
        return CFG.VmAim
    end, function(v)
        CFG.VmAim = v
    end)
    local vmX = slider(vm, {
        Name = "X",
        Flag = "CW_VmX",
        Default = CFG.VmX,
        Min = -3,
        Max = 3,
        Precision = 2,
        Callback = function(v)
            CFG.VmX = v
        end,
    })
    local vmY = slider(vm, {
        Name = "Y",
        Flag = "CW_VmY",
        Default = CFG.VmY,
        Min = -3,
        Max = 3,
        Precision = 2,
        Callback = function(v)
            CFG.VmY = v
        end,
    })
    local vmZ = slider(vm, {
        Name = "Z",
        Flag = "CW_VmZ",
        Default = CFG.VmZ,
        Min = -3,
        Max = 3,
        Precision = 2,
        Callback = function(v)
            CFG.VmZ = v
        end,
    })
    local vmPitch = slider(vm, {
        Name = "Pitch",
        Flag = "CW_VmPitch",
        Default = CFG.VmPitch,
        Min = -45,
        Max = 45,
        Precision = 1,
        Suffix = " deg",
        Callback = function(v)
            CFG.VmPitch = v
        end,
    })
    local vmYaw = slider(vm, {
        Name = "Yaw",
        Flag = "CW_VmYaw",
        Default = CFG.VmYaw,
        Min = -45,
        Max = 45,
        Precision = 1,
        Suffix = " deg",
        Callback = function(v)
            CFG.VmYaw = v
        end,
    })
    local vmRoll = slider(vm, {
        Name = "Roll",
        Flag = "CW_VmRoll",
        Default = CFG.VmRoll,
        Min = -45,
        Max = 45,
        Precision = 1,
        Suffix = " deg",
        Callback = function(v)
            CFG.VmRoll = v
        end,
    })
    vm:Button({
        Name = "Reset",
        Callback = function()
            CFG.VmX, CFG.VmY, CFG.VmZ = 0, 0, 0
            CFG.VmPitch, CFG.VmYaw, CFG.VmRoll = 0, 0, 0
            local function snap(el, v)
                if not el then
                    return
                end
                pcall(function()
                    el:UpdateValue(v, true)
                end)
            end
            snap(vmX, 0)
            snap(vmY, 0)
            snap(vmZ, 0)
            snap(vmPitch, 0)
            snap(vmYaw, 0)
            snap(vmRoll, 0)
            notify("Aim Viewmodel", "reset")
        end,
    })
    vm:Divider()
    boolToggle(vm, "Recolor", "CW_VmColOn", function()
        return CFG.VmColorOn
    end, function(v)
        CFG.VmColorOn = v
    end)
    vm:Colorpicker({
        Name = "Color",
        Default = CFG.VmColor,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.VmColor = c
            end
        end,
    }, ctx.flag("CW_VmCol"))
    boolToggle(vm, "Change Material", "CW_VmMatOn", function()
        return CFG.VmMatOn
    end, function(v)
        CFG.VmMatOn = v
    end)
    vm:Dropdown({
        Name = "Material",
        Options = { "ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Metal" },
        Default = CFG.VmMaterial,
        Callback = function(v)
            CFG.VmMaterial = v
        end,
    }, ctx.flag("CW_VmMat"))
    slider(vm, {
        Name = "Transparency",
        Flag = "CW_VmTr",
        Default = CFG.VmTransparency,
        Min = 0,
        Max = 1,
        Precision = 2,
        Callback = function(v)
            CFG.VmTransparency = v
        end,
    })
    boolToggle(vm, "Outline", "CW_VmOutline", function()
        return CFG.VmOutline
    end, function(v)
        CFG.VmOutline = v
    end)
    vm:Colorpicker({
        Name = "Outline Color",
        Default = CFG.VmHlOutline,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.VmHlOutline = c
            end
        end,
    }, ctx.flag("CW_VmOutCol"))
    vm:Colorpicker({
        Name = "Fill Color",
        Default = CFG.VmHlFill,
        Callback = function(c)
            if typeof(c) == "Color3" then
                CFG.VmHlFill = c
            end
        end,
    }, ctx.flag("CW_VmFillCol"))

    local optz = Misc:Section({ Side = "Right" })
    optz:Header({ Name = "Optimizer" })
    disc(optz, "Lowers ESP and silent aim cost.")
    slider(optz, {
        Name = "Pick Rate",
        Flag = "CW_PickRate",
        Default = CFG.PickRate,
        Min = 0,
        Max = 0.2,
        Precision = 3,
        Suffix = "s",
        Desc = "How often silent aim picks a target.",
        Callback = function(v)
            CFG.PickRate = v
        end,
    })
    slider(optz, {
        Name = "Vis Cache",
        Flag = "CW_VisCache",
        Default = CFG.VisCacheSec,
        Min = 0,
        Max = 0.5,
        Precision = 2,
        Suffix = "s",
        Callback = function(v)
            CFG.VisCacheSec = v
        end,
    })
    slider(optz, {
        Name = "ESP Per Frame",
        Flag = "CW_EspPer",
        Default = CFG.EspPerFrame,
        Min = 0,
        Max = 64,
        Desc = "How many players ESP updates each frame.",
        Callback = function(v)
            CFG.EspPerFrame = v
        end,
    })

    local healSec = Misc:Section({ Side = "Left" })
    healSec:Header({ Name = "Auto Heal" })
    boolToggle(healSec, "Enabled", "CW_AutoHeal", function()
        return CFG.AutoHeal
    end, function(v)
        CFG.AutoHeal = v
        if not v then
            F.stop_heal()
        end
    end, "Heals the nearest teammate while the medic bag is out.")
    slider(healSec, {
        Name = "Heal Radius",
        Flag = "CW_HealRadius",
        Default = CFG.AutoHealRadius,
        Min = 4,
        Max = 12,
        Suffix = " stds",
        Callback = function(v)
            CFG.AutoHealRadius = v
        end,
    })

    local reconSec = Misc:Section({ Side = "Right" })
    reconSec:Header({ Name = "Auto Recon" })
    boolToggle(reconSec, "Enabled", "CW_AutoRecon", function()
        return CFG.AutoRecon
    end, function(v)
        CFG.AutoRecon = v
    end, "Spots the nearest enemy. Respects cooldown.")

    local dbg = Misc:Section({ Side = "Left" })
    dbg:Header({ Name = "Staff Detect" })
    feature(dbg, {
        Title = "Staff Detect",
        Flag = "CW_StaffDetect",
        Desc = "Detects staff on the server.",
        get = function()
            return CFG.StaffDetect
        end,
        set = function(v)
            CFG.StaffDetect = v
        end,
    })
    boolToggle(dbg, "Kick", "CW_StaffKick", function()
        return CFG.StaffKick
    end, function(v)
        CFG.StaffKick = v
    end)
    boolToggle(dbg, "Notify", "CW_StaffNotify", function()
        return CFG.StaffNotify
    end, function(v)
        CFG.StaffNotify = v
    end)
    boolToggle(dbg, "Warning Text", "CW_StaffWarning", function()
        return CFG.StaffWarning
    end, function(v)
        CFG.StaffWarning = v
    end)
    dbg:Header({ Name = "Cold War Combat" })
    dbg:Button({
        Name = "Unload Combat",
        Callback = function()
            pcall(F.unload)
            notify("CWCombat", "unloaded")
        end,
    })
end

getgenv().CWCombat = {
    config = CFG,
    unload = F.unload,
    pick = F.pick_silent_target,
    buildUI = F.buildUI,
}



return {
    Init = function(UI, Core, notifyFn, ctx)
        ctx = ctx or (UI and UI.ctx)
        if type(ctx) == "table" and ctx.tabs then
            F.buildUI(ctx)
        end
    end,
}
