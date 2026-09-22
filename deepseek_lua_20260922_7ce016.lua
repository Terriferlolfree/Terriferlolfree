--[[
    DH Mobile Pro - All-in-one Da Hood mobile script
    Features: Silent Aim, Camlock, ESP, FOV, Crosshair, Hit Sounds,
              Fullbright, No Fog, Speed, Inf Jump, Anti-AFK, Auto Pickup
]]

if game.PlaceId ~= 2788229376 then
    return warn("[DH Mobile] Not in Da Hood.")
end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local StarterGui        = game:GetService("StarterGui")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")
local LocalPlayer       = Players.LocalPlayer
local Camera            = workspace.CurrentCamera
local MainEvent         = ReplicatedStorage:WaitForChild("MainEvent", 10)

local Config = {
    Aim = {
        SilentAim       = false,
        SilentAimKey    = Enum.KeyCode.Q,
        Camlock         = false,
        CamlockKey      = Enum.KeyCode.C,
        AimPart         = "HumanoidRootPart",
        HorizontalPred  = 0.145,
        VerticalPred    = 0.145,
        FOVSize         = 100,
        ShowFOV         = false,
        FOVColor        = Color3.fromRGB(255, 255, 255),
        WallCheck       = false,
        TeamCheck       = false,
        StickyAim       = true,
        Smoothness      = 0.35,
    },
    Visuals = {
        ESPEnabled      = false,
        Box             = false,
        Name            = false,
        Health          = false,
        Distance        = false,
        Tracer          = false,
        Skeleton        = false,
        BoxColor        = Color3.fromRGB(255, 255, 255),
        NameColor       = Color3.fromRGB(255, 255, 255),
        TracerColor     = Color3.fromRGB(255, 255, 255),
        HealthColor     = Color3.fromRGB(0, 255, 0),
        SkeletonColor   = Color3.fromRGB(255, 255, 255),
    },
    Crosshair = {
        Enabled         = false,
        Size            = 10,
        Gap             = 5,
        Thickness       = 1,
        Color           = Color3.fromRGB(255, 255, 255),
        Spin            = false,
        SpinSpeed       = 100,
    },
    World = {
        Fullbright      = false,
        NoFog           = false,
        ClockTime       = false,
        ClockTimeValue  = 14,
    },
    Movement = {
        Speed           = false,
        SpeedValue      = 30,
        InfJump         = false,
    },
    Misc = {
        AntiAFK         = true,
        HitSound        = false,
        HitSoundId      = "rbxassetid://1347140027",
        HitSoundVolume  = 1,
        AutoPickup      = false,
    },
}

getgenv().DH = Config

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DH Mobile", Text = text, Duration = duration or 2,
        })
    end)
end
local function isAlive(plr)
    local c = plr.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
local function isTeamMate(plr)
    if not Config.Aim.TeamCheck then return false end
    local me = LocalPlayer.Team
    return me and plr.Team == me
end

local Drawing = Drawing or nil
local hasDrawing = Drawing and Drawing.new ~= nil

-- ESP
local espCache = {}
local function buildESP(plr)
    if not hasDrawing or plr == LocalPlayer then return end
    if espCache[plr] then return end
    espCache[plr] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        dist = Drawing.new("Text"),
        hp = Drawing.new("Text"),
        tracer = Drawing.new("Line"),
    }
    local e = espCache[plr]
    e.box.Thickness = 1; e.box.Filled = false; e.box.Visible = false
    e.name.Size = 14; e.name.Center = true; e.name.Outline = true; e.name.Visible = false
    e.dist.Size = 13; e.dist.Center = true; e.dist.Outline = true; e.dist.Visible = false
    e.hp.Size = 13; e.hp.Center = true; e.hp.Outline = true; e.hp.Visible = false
    e.tracer.Thickness = 1; e.tracer.Visible = false
end
local function clearESP(plr)
    if espCache[plr] then
        for _, o in pairs(espCache[plr]) do pcall(function() o:Remove() end) end
        espCache[plr] = nil
    end
end
for _, p in ipairs(Players:GetPlayers()) do buildESP(p) end
Players.PlayerAdded:Connect(buildESP)
Players.PlayerRemoving:Connect(clearESP)

-- Silent Aim
local currentTarget = nil
local function wallClear(part)
    if not Config.Aim.WallCheck then return true end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local filter = {}
    if getChar() then filter[#filter + 1] = getChar() end
    rp.FilterDescendantsInstances = filter
    local origin = Camera.CFrame.Position
    local hit = workspace:Raycast(origin, part.Position - origin, rp)
    return not hit or hit.Instance:IsDescendantOf(part.Parent)
end
local function findTarget()
    local closest, dist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) and not isTeamMate(plr) then
            local part = plr.Character:FindFirstChild(Config.Aim.AimPart)
            if part and wallClear(part) then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d < Config.Aim.FOVSize and d < dist then
                        closest, dist = plr, d
                    end
                end
            end
        end
    end
    return closest
end

if setreadonly and getrawmetatable then
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and Config.Aim.SilentAim and method == "FireServer" and self == MainEvent then
            local args = {...}
            local first = args[1]
            if first == "UpdateMousePosI" or first == "UpdateMousePos" then
                local target = currentTarget
                if target and target.Character then
                    local part = target.Character:FindFirstChild(Config.Aim.AimPart)
                    if part then
                        local pred = part.Position
                            + part.AssemblyLinearVelocity * Config.Aim.HorizontalPred
                            + Vector3.new(0, Config.Aim.VerticalPred, 0)
                        for i = 2, #args do
                            if typeof(args[i]) == "Vector3" then args[i] = pred end
                        end
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

-- Camlock
RunService.RenderStepped:Connect(function()
    if Config.Aim.Camlock and currentTarget and currentTarget.Character then
        local part = currentTarget.Character:FindFirstChild(Config.Aim.AimPart)
        if part then
            local pred = part.Position
                + part.AssemblyLinearVelocity * Config.Aim.HorizontalPred
                + Vector3.new(0, Config.Aim.VerticalPred, 0)
            local want = CFrame.new(Camera.CFrame.Position, pred)
            Camera.CFrame = Camera.CFrame:Lerp(want, 1 - Config.Aim.Smoothness)
        end
    end
end)

-- Target loop
task.spawn(function()
    while task.wait(0.1) do
        if Config.Aim.SilentAim or Config.Aim.Camlock then
            if Config.Aim.StickyAim and currentTarget and isAlive(currentTarget) then
                local part = currentTarget.Character:FindFirstChild(Config.Aim.AimPart)
                if part and wallClear(part) then
                    -- keep
                else
                    currentTarget = findTarget()
                end
            else
                currentTarget = findTarget()
            end
        else
            currentTarget = nil
        end
    end
end)

-- FOV
local fovCircle
if hasDrawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1; fovCircle.Filled = false; fovCircle.Transparency = 1
    fovCircle.NumSides = 64; fovCircle.Visible = false
end
RunService.RenderStepped:Connect(function()
    if fovCircle then
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Radius = Config.Aim.FOVSize
        fovCircle.Color = Config.Aim.FOVColor
        fovCircle.Visible = Config.Aim.ShowFOV
    end
end)

-- Crosshair
local chLines = {}
local chSpin = 0
if hasDrawing then
    for i = 1, 4 do
        chLines[i] = Drawing.new("Line")
        chLines[i].Thickness = 1; chLines[i].Visible = false
    end
end
RunService.RenderStepped:Connect(function(dt)
    if not hasDrawing then return end
    if Config.Crosshair.Enabled then
        local cx = Camera.ViewportSize.X / 2
        local cy = Camera.ViewportSize.Y / 2
        local gap = Config.Crosshair.Gap
        local len = Config.Crosshair.Size
        local col = Config.Crosshair.Color
        local th = Config.Crosshair.Thickness
        if Config.Crosshair.Spin then chSpin = chSpin + dt * Config.Crosshair.SpinSpeed end
        local rad = math.rad(chSpin)
        local cos, sin = math.cos(rad), math.sin(rad)
        local dirs = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}}
        for i, d in ipairs(dirs) do
            local dx = d[1] * cos - d[2] * sin
            local dy = d[1] * sin + d[2] * cos
            chLines[i].From = Vector2.new(cx + dx * gap, cy + dy * gap)
            chLines[i].To   = Vector2.new(cx + dx * (gap + len), cy + dy * (gap + len))
            chLines[i].Color = col
            chLines[i].Thickness = th
            chLines[i].Visible = true
        end
    else
        for i = 1, 4 do chLines[i].Visible = false end
    end
end)

-- World
local worldTick = 0
RunService.Heartbeat:Connect(function(dt)
    worldTick = worldTick + dt
    if worldTick < 0.5 then return end
    worldTick = 0
    if Config.World.Fullbright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e6
    end
    if Config.World.NoFog then
        Lighting.FogStart = 1e6
        Lighting.FogEnd   = 1e6
    end
    if Config.World.ClockTime then
        Lighting.ClockTime = Config.World.ClockTimeValue
    end
end)

-- Movement
RunService.Heartbeat:Connect(function()
    if Config.Movement.Speed then
        local h = getHum()
        if h then h.WalkSpeed = Config.Movement.SpeedValue end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if Config.Movement.InfJump then
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Hit sound + ESP update loop
task.spawn(function()
    while task.wait(0.15) do
        if Config.Misc.HitSound and currentTarget and currentTarget.Character then
            local hum = currentTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if not currentTarget._lastHp then
                    currentTarget._lastHp = hum.Health
                elseif hum.Health < currentTarget._lastHp then
                    local s = Instance.new("Sound")
                    s.SoundId = Config.Misc.HitSoundId
                    s.Volume = Config.Misc.HitSoundVolume
                    s.Parent = workspace
                    s:Play()
                    task.delay(2, function() s:Destroy() end)
                    currentTarget._lastHp = hum.Health
                else
                    currentTarget._lastHp = hum.Health
                end
            end
        end
        if hasDrawing then
            for plr, e in pairs(espCache) do
                if not Config.Visuals.ESPEnabled or not isAlive(plr) or isTeamMate(plr) then
                    for _, o in pairs(e) do o.Visible = false end
                else
                    local char = plr.Character
                    local head = char:FindFirstChild("Head")
                    local hrp  = char:FindFirstChild("HumanoidRootPart")
                    local hum  = char:FindFirstChildOfClass("Humanoid")
                    if head and hrp and hum then
                        local headPos, hOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local rootPos, rOn = Camera:WorldToViewportPoint(hrp.Position)
                        local footPos, fOn = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        if hOn and rOn and fOn then
                            local h = headPos.Y - footPos.Y
                            local w = h * 0.6
                            local x = rootPos.X - w / 2
                            local y = headPos.Y - h * 0.1
                            if Config.Visuals.Box then
                                e.box.Size = Vector2.new(w, h)
                                e.box.Position = Vector2.new(x, y)
                                e.box.Color = Config.Visuals.BoxColor
                                e.box.Visible = true
                            else e.box.Visible = false end
                            if Config.Visuals.Name then
                                e.name.Text = plr.Name
                                e.name.Position = Vector2.new(rootPos.X, y - 16)
                                e.name.Color = Config.Visuals.NameColor
                                e.name.Visible = true
                            else e.name.Visible = false end
                            if Config.Visuals.Distance then
                                local d = (Camera.CFrame.Position - hrp.Position).Magnitude
                                e.dist.Text = string.format("[%d]", math.floor(d))
                                e.dist.Position = Vector2.new(rootPos.X, y + h + 4)
                                e.dist.Color = Color3.fromRGB(220, 220, 220)
                                e.dist.Visible = true
                            else e.dist.Visible = false end
                            if Config.Visuals.Health then
                                e.hp.Text = string.format("HP %d", math.floor(hum.Health))
                                e.hp.Position = Vector2.new(rootPos.X, y + h + 20)
                                e.hp.Color = Config.Visuals.HealthColor
                                e.hp.Visible = true
                            else e.hp.Visible = false end
                            if Config.Visuals.Tracer then
                                e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                e.tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                                e.tracer.Color = Config.Visuals.TracerColor
                                e.tracer.Visible = true
                            else e.tracer.Visible = false end
                        else
                            for _, o in pairs(e) do o.Visible = false end
                        end
                    end
                end
            end
        end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if not Config.Misc.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- Auto pickup
task.spawn(function()
    while task.wait(0.4) do
        if Config.Misc.AutoPickup then
            local hrp = getHRP()
            if hrp then
                local dropFolder = workspace:FindFirstChild("Ignored")
                    and workspace.Ignored:FindFirstChild("Drop")
                if dropFolder then
                    for _, drop in ipairs(dropFolder:GetChildren()) do
                        if drop.Name == "MoneyDrop" then
                            pcall(function()
                                local cd = drop:FindFirstChildOfClass("ClickDetector")
                                if cd and (drop.Position - hrp.Position).Magnitude < 25 then
                                    fireclickdetector(cd)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DHMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 400)
main.Position = UDim2.new(0.5, -160, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 34)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
title.BorderSizePixel = 0
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌆 DH MOBILE"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = title

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -58, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.Parent = title
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = title
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -12, 0, 32)
tabBar.Position = UDim2.new(0, 6, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
tabBar.BorderSizePixel = 0
tabBar.Parent = main
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

local tabNames = {"Aim", "Visuals", "Player", "Misc"}
local tabButtons = {}
local pages = {}

local pageHolder = Instance.new("Frame")
pageHolder.Size = UDim2.new(1, -12, 1, -85)
pageHolder.Position = UDim2.new(0, 6, 0, 80)
pageHolder.BackgroundTransparency = 1
pageHolder.Parent = main

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -3, 1, -4)
    btn.Position = UDim2.new((i - 1) * 0.25, 2, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 130)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = (i == 1)
    page.Parent = pageHolder
    pages[name] = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
end

local function switchTab(name)
    for n, b in pairs(tabButtons) do
        local active = (n == name)
        b.BackgroundColor3 = active and Color3.fromRGB(80, 80, 150) or Color3.fromRGB(38, 38, 48)
        b.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    end
    for n, p in pairs(pages) do
        p.Visible = (n == name)
    end
end
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

-- GUI helpers
local function addLabel(parent, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 0, 26)
    lbl.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(160, 160, 180)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.Parent = parent
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
    return lbl
end

local function makeToggle(parent, text, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local function apply(v)
        setter(v)
        btn.Text = text .. ": " .. (v and "ON" or "OFF")
        btn.BackgroundColor3 = v and Color3.fromRGB(60, 130, 60) or Color3.fromRGB(38, 38, 48)
    end
    if getter() then apply(true) end
    btn.MouseButton1Click:Connect(function() apply(not getter()) end)
    return btn
end

local function makeSlider(parent, text, getter, setter, minV, maxV)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -8, 0, 52)
    holder.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    holder.BorderSizePixel = 0
    holder.Parent = parent
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 22)
    lbl.Position = UDim2.new(0, 6, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. string.format("%.2f", getter())
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -12, 0, 10)
    bar.Position = UDim2.new(0, 6, 0, 32)
    bar.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    bar.BorderSizePixel = 0
    bar.Parent = holder
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    local ratio = (getter() - minV) / (maxV - minV)
    fill.Size = UDim2.new(ratio, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 140, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(1, 0, 1, 0)
    handle.BackgroundTransparency = 1
    handle.Text = ""
    handle.Parent = bar

    local dragging = false
    local function updateFromInput(input)
        local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = minV + rel * (maxV - minV)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        setter(value)
        lbl.Text = text .. ": " .. string.format("%.2f", value)
    end
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromInput(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement) then
            updateFromInput(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    return holder
end

local function makeColorPick(parent, text, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BackgroundColor3 = getter()
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        local palette = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 60, 60),
            Color3.fromRGB(60, 255, 60),
            Color3.fromRGB(60, 130, 255),
            Color3.fromRGB(255, 200, 0),
            Color3.fromRGB(200, 60, 255),
            Color3.fromRGB(0, 0, 0),
        }
        local cur = getter()
        local idx = 1
        for i, c in ipairs(palette) do if c == cur then idx = i break end end
        idx = (idx % #palette) + 1
        setter(palette[idx])
        btn.BackgroundColor3 = palette[idx]
    end)
    return btn
end

local function makeKeyPick(parent, text, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    btn.Text = text .. ": " .. tostring(getter().Name)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local waiting = false
    btn.MouseButton1Click:Connect(function()
        waiting = true
        btn.Text = text .. ": press a key..."
    end)
    UserInputService.InputBegan:Connect(function(input)
        if not waiting then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            setter(input.KeyCode)
            btn.Text = text .. ": " .. input.KeyCode.Name
            waiting = false
        end
    end)
    return btn
end

-- AIM TAB
local aimPage = pages["Aim"]
addLabel(aimPage, "SILENT AIM", Color3.fromRGB(255, 200, 80))
makeToggle(aimPage, "Silent Aim", function() return Config.Aim.SilentAim end, function(v) Config.Aim.SilentAim = v end)
makeToggle(aimPage, "Camlock", function() return Config.Aim.Camlock end, function(v) Config.Aim.Camlock = v end)
makeKeyPick(aimPage, "Silent Aim Key", function() return Config.Aim.SilentAimKey end, function(k) Config.Aim.SilentAimKey = k end)
makeKeyPick(aimPage, "Camlock Key", function() return Config.Aim.CamlockKey end, function(k) Config.Aim.CamlockKey = k end)
makeToggle(aimPage, "Sticky Aim", function() return Config.Aim.StickyAim end, function(v) Config.Aim.StickyAim = v end)
makeToggle(aimPage, "Wall Check", function() return Config.Aim.WallCheck end, function(v) Config.Aim.WallCheck = v end)
makeToggle(aimPage, "Team Check", function() return Config.Aim.TeamCheck end, function(v) Config.Aim.TeamCheck = v end)

addLabel(aimPage, "PREDICTION", Color3.fromRGB(255, 200, 80))
makeSlider(aimPage, "Horizontal Pred", function() return Config.Aim.HorizontalPred end, function(v) Config.Aim.HorizontalPred = v end, 0, 0.5)
makeSlider(aimPage, "Vertical Pred", function() return Config.Aim.VerticalPred end, function(v) Config.Aim.VerticalPred = v end, 0, 0.5)

addLabel(aimPage, "FOV", Color3.fromRGB(255, 200, 80))
makeToggle(aimPage, "Show FOV", function() return Config.Aim.ShowFOV end, function(v) Config.Aim.ShowFOV = v end)
makeSlider(aimPage, "FOV Size", function() return Config.Aim.FOVSize end, function(v) Config.Aim.FOVSize = v end, 20, 500)
makeColorPick(aimPage, "FOV Color", function() return Config.Aim.FOVColor end, function(c) Config.Aim.FOVColor = c end)

addLabel(aimPage, "AIM PART", Color3.fromRGB(255, 200, 80))
local partBtn = Instance.new("TextButton")
partBtn.Size = UDim2.new(1, -8, 0, 36)
partBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
partBtn.Text = "Aim Part: " .. Config.Aim.AimPart
partBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
partBtn.Font = Enum.Font.Gotham
partBtn.TextSize = 13
partBtn.Parent = aimPage
Instance.new("UICorner", partBtn).CornerRadius = UDim.new(0, 6)
local aimParts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}
partBtn.MouseButton1Click:Connect(function()
    local idx = 1
    for i, p in ipairs(aimParts) do if p == Config.Aim.AimPart then idx = i break end end
    idx = (idx % #aimParts) + 1
    Config.Aim.AimPart = aimParts[idx]
    partBtn.Text = "Aim Part: " .. aimParts[idx]
end)

-- VISUALS TAB
local visPage = pages["Visuals"]
addLabel(visPage, "ESP", Color3.fromRGB(255, 200, 80))
makeToggle(visPage, "ESP Master", function() return Config.Visuals.ESPEnabled end, function(v) Config.Visuals.ESPEnabled = v end)
makeToggle(visPage, "Box", function() return Config.Visuals.Box end, function(v) Config.Visuals.Box = v end)
makeToggle(visPage, "Name", function() return Config.Visuals.Name end, function(v) Config.Visuals.Name = v end)
makeToggle(visPage, "Health Text", function() return Config.Visuals.Health end, function(v) Config.Visuals.Health = v end)
makeToggle(visPage, "Distance", function() return Config.Visuals.Distance end, function(v) Config.Visuals.Distance = v end)
makeToggle(visPage, "Tracer", function() return Config.Visuals.Tracer end, function(v) Config.Visuals.Tracer = v end)
makeToggle(visPage, "Skeleton", function() return Config.Visuals.Skeleton end, function(v) Config.Visuals.Skeleton = v end)

addLabel(visPage, "ESP COLORS", Color3.fromRGB(255, 200, 80))
makeColorPick(visPage, "Box Color", function() return Config.Visuals.BoxColor end, function(c) Config.Visuals.BoxColor = c end)
makeColorPick(visPage, "Name Color", function() return Config.Visuals.NameColor end, function(c) Config.Visuals.NameColor = c end)
makeColorPick(visPage, "Tracer Color", function() return Config.Visuals.TracerColor end, function(c) Config.Visuals.TracerColor = c end)
makeColorPick(visPage, "Health Color", function() return Config.Visuals.HealthColor end, function(c) Config.Visuals.HealthColor = c end)
makeColorPick(visPage, "Skeleton Color", function() return Config.Visuals.SkeletonColor end, function(c) Config.Visuals.SkeletonColor = c end)

addLabel(visPage, "CROSSHAIR", Color3.fromRGB(255, 200, 80))
makeToggle(visPage, "Crosshair", function() return Config.Crosshair.Enabled end, function(v) Config.Crosshair.Enabled = v end)
makeToggle(visPage, "Spin", function() return Config.Crosshair.Spin end, function(v) Config.Crosshair.Spin = v end)
makeSlider(visPage, "Crosshair Size", function() return Config.Crosshair.Size end, function(v) Config.Crosshair.Size = v end, 2, 30)
makeSlider(visPage, "Crosshair Gap", function() return Config.Crosshair.Gap end, function(v) Config.Crosshair.Gap = v end, 0, 20)
makeSlider(visPage, "Crosshair Thickness", function() return Config.Crosshair.Thickness end, function(v) Config.Crosshair.Thickness = v end, 1, 5)
makeSlider(visPage, "Spin Speed", function() return Config.Crosshair.SpinSpeed end, function(v) Config.Crosshair.SpinSpeed = v end, 10, 500)
makeColorPick(visPage, "Crosshair Color", function() return Config.Crosshair.Color end, function(c) Config.Crosshair.Color = c end)

addLabel(visPage, "WORLD", Color3.fromRGB(255, 200, 80))
makeToggle(visPage, "Fullbright", function() return Config.World.Fullbright end, function(v)
    Config.World.Fullbright = v
    if not v then
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)
makeToggle(visPage, "No Fog", function() return Config.World.NoFog end, function(v)
    Config.World.NoFog = v
    if not v then
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
    end
end)
makeToggle(visPage, "Force Clock Time", function() return Config.World.ClockTime end, function(v) Config.World.ClockTime = v end)

-- PLAYER TAB
local plPage = pages["Player"]
addLabel(plPage, "MOVEMENT", Color3.fromRGB(255, 200, 80))
makeToggle(plPage, "Speed", function() return Config.Movement.Speed end, function(v) Config.Movement.Speed = v end)
makeSlider(plPage, "Speed Value", function() return Config.Movement.SpeedValue end, function(v) Config.Movement.SpeedValue = v end, 16, 60)
makeToggle(plPage, "Infinite Jump", function() return Config.Movement.InfJump end, function(v) Config.Movement.InfJump = v end)

addLabel(plPage, "PLAYER LIST (tap to lock)", Color3.fromRGB(255, 200, 80))
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, -8, 0, 200)
playerListFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
playerListFrame.BorderSizePixel = 0
playerListFrame.Parent = plPage
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 6)

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, -8, 1, -8)
playerScroll.Position = UDim2.new(0, 4, 0, 4)
playerScroll.BackgroundTransparency = 1
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 4
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerScroll.Parent = playerListFrame

local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 3)
plLayout.Parent = playerScroll

local playerRows = {}
local function refreshPlayerList()
    for _, row in pairs(playerRows) do row:Destroy() end
    playerRows = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local row = Instance.new("TextButton")
            row.Size = UDim2.new(1, -4, 0, 28)
            row.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
            row.Text = plr.Name
            row.TextColor3 = Color3.fromRGB(220, 220, 220)
            row.Font = Enum.Font.Gotham
            row.TextSize = 12
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.Parent = playerScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
            local pad = Instance.new("UIPadding", row)
            pad.PaddingLeft = UDim.new(0, 8)
            row.MouseButton1Click:Connect(function()
                if currentTarget == plr then
                    currentTarget = nil
                    notify("Target cleared")
                else
                    currentTarget = plr
                    notify("Locked: " .. plr.Name)
                end
            end)
            playerRows[#playerRows + 1] = row
        end
    end
end
refreshPlayerList()
Players.PlayerAdded:Connect(function() task.wait(0.2) refreshPlayerList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.2) refreshPlayerList() end)

-- MISC TAB
local miscPage = pages["Misc"]
addLabel(miscPage, "MISC", Color3.fromRGB(255, 200, 80))
makeToggle(miscPage, "Anti-AFK", function() return Config.Misc.AntiAFK end, function(v) Config.Misc.AntiAFK = v end)
makeToggle(miscPage, "Hit Sound", function() return Config.Misc.HitSound end, function(v) Config.Misc.HitSound = v end)
makeToggle(miscPage, "Auto Pickup Money", function() return Config.Misc.AutoPickup end, function(v) Config.Misc.AutoPickup = v end)
makeSlider(miscPage, "Hit Sound Volume", function() return Config.Misc.HitSoundVolume end, function(v) Config.Misc.HitSoundVolume = v end, 0, 5)

addLabel(miscPage, "HIT SOUND PICKER", Color3.fromRGB(255, 200, 80))
local hitSounds = {
    {name = "Hitmarker", id = "rbxassetid://1347140027"},
    {name = "Minecraft", id = "rbxassetid://5869422451"},
    {name = "CSGO",      id = "rbxassetid://5952120301"},
    {name = "Bameware",  id = "rbxassetid://3124331820"},
    {name = "Rust",      id = "rbxassetid://6565371338"},
    {name = "Bubble",    id = "rbxassetid://6534947588"},
}
for _, s in ipairs(hitSounds) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    b.Text = s.name
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.Parent = miscPage
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        Config.Misc.HitSoundId = s.id
        notify("Hit sound: " .. s.name)
    end)
end

addLabel(miscPage, "UTILITY", Color3.fromRGB(255, 200, 80))
local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, -8, 0, 36)
unloadBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
unloadBtn.Text = "Unload Script"
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.TextSize = 13
unloadBtn.Parent = miscPage
Instance.new("UICorner", unloadBtn).CornerRadius = UDim.new(0, 6)
unloadBtn.MouseButton1Click:Connect(function()
    for _, e in pairs(espCache) do
        for _, o in pairs(e) do pcall(function() o:Remove() end) end
    end
    if fovCircle then pcall(function() fovCircle:Remove() end) end
    for _, l in ipairs(chLines) do pcall(function() l:Remove() end) end
    gui:Destroy()
    notify("Script unloaded")
end)

-- GUI events
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0, 320, 0, 34) or UDim2.new(0, 320, 0, 400)
end)

local dragStart, startPos, dragging
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0, 15, 0.35, 0)
floatBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
floatBtn.Text = "DH"
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 16
floatBtn.Parent = gui
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
floatBtn.MouseButton1Click:Connect(function()
    gui.Enabled = true
    main.Visible = true
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Config.Aim.SilentAimKey then
        Config.Aim.SilentAim = not Config.Aim.SilentAim
        notify("Silent Aim: " .. (Config.Aim.SilentAim and "ON" or "OFF"))
    elseif input.KeyCode == Config.Aim.CamlockKey then
        Config.Aim.Camlock = not Config.Aim.Camlock
        notify("Camlock: " .. (Config.Aim.Camlock and "ON" or "OFF"))
    end
end)

notify("🌆 DH Mobile loaded!", 3)
print("[DH Mobile] Script loaded. Place: " .. game.PlaceId)