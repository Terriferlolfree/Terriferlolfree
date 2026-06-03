-- [
-- bunny hook script source
-- ] 
-- game.Players.LocalPlayer.Character.Humanoid.Health = 0 -- dont uncomment me 

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- ==================== COLOR PALETTE (PINK PASTEL) ====================
local Colors = {
    Background = Color3.fromRGB(255, 250, 252), -- Soft pink white
    Primary = Color3.fromRGB(255, 182, 193), -- Light pink
    Secondary = Color3.fromRGB(255, 218, 224), -- Lighter pink
    Accent = Color3.fromRGB(255, 105, 180), -- Hot pink
    White = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(80, 60, 70),
    TextLight = Color3.fromRGB(150, 120, 140),
    Border = Color3.fromRGB(255, 220, 230),
    Toggle_On = Color3.fromRGB(255, 182, 193),
    Toggle_Off = Color3.fromRGB(220, 200, 210)
}

-- ==================== CONFIG ====================
local Config = {
    Aimlock = {
        Enabled = false,
        Keybind = Enum.KeyCode.Q,
        Smooth = 1,
        FOV = 200,
        Prediction = 0
    },
    AutoShoot = false,
    SilentAim = {
        Enabled = false,
        Supported = true,
        Prediction = 0
    },
    AutoPrediction = false,
    Walkspeed = {
        Enabled = false,
        Speed = 50,
        Keybind = Enum.KeyCode.T
    },
    Noclip = {
        Enabled = false,
        Keybind = Enum.KeyCode.N
    },
    OutlineTarget = false
}

-- ==================== STATE ====================
local CurrentTarget = nil
local CurrentOutline = nil
local LastHealth = {}
local Connections = {}
local silentTarget = nil

-- ==================== UTILITY FUNCTIONS ====================
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function isAlive(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local be = plr.Character:FindFirstChild("BodyEffects")
    if be then
        local ko = be:FindFirstChild("K.O")
        local grabbed = be:FindFirstChild("GRABBING_CONSTRAINT")
        if (ko and ko.Value) or (grabbed and grabbed.Value) then
            return false
        end
    end
    return true
end

local function isVisible(pos, player)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local direction = pos - Camera.CFrame.Position
    local distance = direction.Magnitude
    local result = Workspace:Raycast(Camera.CFrame.Position, direction.Unit * distance, params)
    if not result or result.Instance:IsDescendantOf(player.Character) then
        return true
    end
    return false
end

local function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = Config.Aimlock.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isAlive(player) and player.Character then
            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen and isVisible(rootPart.Position, player) then
                    local mousePos = IsMobile() and Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) or Vector2.new(Mouse.X, Mouse.Y)
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function GetPartToAim(target)
    if not target or not target.Character then return nil end
    local character = target.Character
    return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end

-- ==================== NOTIFICATION SYSTEM ====================
local function Notify(message, duration, color)
    duration = duration or 3
    color = color or Colors.Primary
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "bunnyNotif"
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifGui.Parent = game:GetService("CoreGui")
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 70)
    frame.Position = UDim2.new(1, 10, 0.9, 0)
    frame.AnchorPoint = Vector2.new(0, 0.5)
    frame.BackgroundColor3 = Colors.White
    frame.BorderSizePixel = 0
    frame.Parent = notifGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2.5
    stroke.Parent = frame
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 10, 0.5, -25)
    icon.BackgroundTransparency = 1
    icon.Text = "🐰"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 32
    icon.Parent = frame
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -75, 1, 0)
    text.Position = UDim2.new(0, 65, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.Font = Enum.Font.GothamMedium
    text.TextSize = 14
    text.TextColor3 = Colors.Text
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextWrapped = true
    text.Parent = frame
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -330, 0.9, 0)
    }):Play()
    wait(duration)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 10, 0.9, 0)
    }):Play()
    wait(0.3)
    notifGui:Destroy()
end

-- ==================== TARGET MESSAGES ====================
local TargetLeftMessages = {
    "🚪 Detected enemy rage quit!",
    "👋 Target said 'Alt+F4 time!'",
    "💨 Enemy vanished into thin air!",
    "🏃 Target escaped like a coward!",
    "😂 They couldn't handle the heat!",
    "🎪 Target left the circus!",
    "🌙 Enemy went to touch grass!",
    "⚡ Target teleported to another dimension!"
}

local TargetDiedMessages = {
    "💀 Target eliminated successfully!",
    "✨ Enemy sent to respawn!",
    "🎯 Perfect shot! Target down!",
    "👑 You're too good for them!",
    "🔥 Target got destroyed!",
    "⚰️ Another one bites the dust!",
    "🎊 Victory royale! Enemy eliminated!",
    "💫 Target couldn't compete!"
}

local function GetRandomMessage(messages)
    return messages[math.random(1, #messages)]
end

-- ==================== OUTLINE SYSTEM ====================
local function CreateOutline(character)
    if CurrentOutline then
        CurrentOutline:Destroy()
        CurrentOutline = nil
    end
    if not Config.OutlineTarget then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "bunnyOutline"
    highlight.Adornee = character
    highlight.FillColor = Colors.Accent
    highlight.FillTransparency = 1
    highlight.OutlineColor = Colors.Primary
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    CurrentOutline = highlight
    return highlight
end

local function UpdateOutlineColor(color, duration)
    if CurrentOutline then
        TweenService:Create(CurrentOutline, TweenInfo.new(duration or 0.1), {
            OutlineColor = color
        }):Play()
    end
end

-- ==================== TARGET MANAGEMENT ====================
local function SetTarget(player)
    -- Clear old target
    if CurrentTarget then
        if CurrentOutline then
            CurrentOutline:Destroy()
            CurrentOutline = nil
        end
    end
    CurrentTarget = player
    if player and player.Character then
        CreateOutline(player.Character)
        Notify("Target locked: " .. player.DisplayName, 2, Colors.Primary)
        -- Track health changes
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            LastHealth[player] = humanoid.Health
            -- Monitor health
            table.insert(Connections, humanoid.HealthChanged:Connect(function(health)
                if LastHealth[player] and health < LastHealth[player] then
                    -- Target took damage
                    UpdateOutlineColor(Color3.fromRGB(255, 50, 50), 0.1)
                    wait(1)
                    if CurrentTarget == player then
                        UpdateOutlineColor(Colors.Primary, 0.5)
                    end
                end
                LastHealth[player] = health
            end))
            -- Monitor death
            table.insert(Connections, humanoid.Died:Connect(function()
                if CurrentTarget == player then
                    Notify(GetRandomMessage(TargetDiedMessages), 3, Color3.fromRGB(100, 255, 100))
                end
            end))
        end
        -- Monitor character removal (left/reset)
        table.insert(Connections, player.CharacterRemoving:Connect(function()
            if CurrentTarget == player then
                Notify(GetRandomMessage(TargetLeftMessages), 3, Color3.fromRGB(255, 200, 100))
                SetTarget(nil)
            end
        end))
    else
        Notify("🔓 Target unlocked", 1.5, Colors.TextLight)
    end
end

-- ==================== AIMLOCK ====================
local AimlockConnection = nil
local function StartAimlock()
    if AimlockConnection then AimlockConnection:Disconnect() end
    AimlockConnection = RunService.RenderStepped:Connect(function()
        if not Config.Aimlock.Enabled or not CurrentTarget then return end
        if not isAlive(CurrentTarget) then return end
        local targetPart = GetPartToAim(CurrentTarget)
        if not targetPart then return end
        local root = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local pred = Config.Aimlock.Prediction
        local targetPos = targetPart.Position + root.Velocity * pred
        if not isVisible(targetPos, CurrentTarget) then return end
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        -- Smooth aimlock
        local smooth = Config.Aimlock.Smooth
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, smooth)
    end)
end

-- ==================== AUTO SHOOT ====================
local function AutoShoot()
    local shootTarget = nil
    if Config.Aimlock.Enabled and CurrentTarget then
        shootTarget = CurrentTarget
    elseif Config.SilentAim.Enabled and silentTarget then
        shootTarget = silentTarget
    end
    if not Config.AutoShoot or not shootTarget then return end
    if not isAlive(shootTarget) then return end
    local targetPart = GetPartToAim(shootTarget)
    if not targetPart then return end
    local root = shootTarget.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local pred = Config.SilentAim.Prediction  -- Use silent pred for consistency
    local targetPos = targetPart.Position + root.Velocity * pred
    if not isVisible(targetPos, shootTarget) then return end
    local character = LocalPlayer.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    -- Check if tool has Ammo
    local ammo = tool:FindFirstChild("Ammo")
    if ammo and ammo:IsA("IntValue") and ammo.Value > 0 then
        -- Activate tool
        tool:Activate()
    else
        -- Click mouse
        mouse1press()
        wait()
        mouse1release()
    end
end
table.insert(Connections, RunService.Heartbeat:Connect(AutoShoot))

-- ==================== SILENT AIM ====================
local SilentAimSupported = pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(self, idx)
        if Config.SilentAim.Enabled and self == Mouse and (idx == "Hit" or idx == "Target") then
            local target = silentTarget
            if not target or not target.Character then
                return oldIndex(self, idx)
            end
            local char = target.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local partName = "Head"
            local part = char:FindFirstChild(partName)
            if not root or not part or not isAlive(target) then
                return oldIndex(self, idx)
            end
            local pred = Config.SilentAim.Prediction
            local predicted = part.Position + root.Velocity * pred
            if not isVisible(predicted, target) then
                return oldIndex(self, idx)
            end
            if idx == "Hit" then
                return CFrame.new(predicted)
            elseif idx == "Target" then
                return part
            end
        end
        return oldIndex(self, idx)
    end)
    setreadonly(mt, true)
end)

if not SilentAimSupported then
    Config.SilentAim.Supported = false
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if Config.SilentAim.Enabled then
        silentTarget = GetClosestPlayerToCursor()
        if Config.OutlineTarget and silentTarget and silentTarget.Character and not CurrentTarget then
            CreateOutline(silentTarget.Character)
        elseif not silentTarget and CurrentOutline then
            CurrentOutline:Destroy()
            CurrentOutline = nil
        end
    else
        silentTarget = nil
        if CurrentOutline and not CurrentTarget then
            CurrentOutline:Destroy()
            CurrentOutline = nil
        end
    end
end))

-- ==================== AUTO PREDICTION ====================
local function getAutoPred()
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local pred
    if ping < 20 then pred = 0.13
    elseif ping < 30 then pred = 0.135
    elseif ping < 40 then pred = 0.14
    elseif ping < 50 then pred = 0.145
    elseif ping < 60 then pred = 0.15
    elseif ping < 70 then pred = 0.155
    elseif ping < 80 then pred = 0.157
    elseif ping < 90 then pred = 0.16
    elseif ping < 100 then pred = 0.165
    else pred = 0.17
    end
    return pred
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if Config.AutoPrediction then
        local pred = getAutoPred()
        Config.Aimlock.Prediction = pred
        Config.SilentAim.Prediction = pred
        updateSliderVisual(aimPredSlider, pred)
        updateSliderVisual(silentPredSlider, pred)
    end
end))

-- ==================== WALKSPEED ====================
local function UpdateWalkspeed()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if Config.Walkspeed.Enabled then
                humanoid.WalkSpeed = Config.Walkspeed.Speed
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
end
table.insert(Connections, RunService.Heartbeat:Connect(UpdateWalkspeed))

-- ==================== NOCLIP ====================
local function UpdateNoclip()
    local character = LocalPlayer.Character
    if character and Config.Noclip.Enabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end
table.insert(Connections, RunService.Stepped:Connect(UpdateNoclip))

-- ==================== CREATE GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "bunnyAimlock"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 50)
MainFrame.Position = UDim2.new(0.5, -170, 0, 20)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainBorder = Instance.new("UIStroke")
MainBorder.Color = Colors.Border
MainBorder.Thickness = 2
MainBorder.Transparency = 0.3
MainBorder.Parent = MainFrame

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundColor3 = Colors.White
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 14)
TopbarCorner.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐰 bunny Aimlock"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Colors.Primary
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local ArrowButton = Instance.new("TextButton")
ArrowButton.Size = UDim2.new(0, 40, 0, 40)
ArrowButton.Position = UDim2.new(1, -45, 0.5, -20)
ArrowButton.BackgroundColor3 = Colors.Primary
ArrowButton.BorderSizePixel = 0
ArrowButton.Text = "▼"
ArrowButton.Font = Enum.Font.GothamBold
ArrowButton.TextSize = 18
ArrowButton.TextColor3 = Colors.White
ArrowButton.AutoButtonColor = false
ArrowButton.Parent = Topbar

local ArrowCorner = Instance.new("UICorner")
ArrowCorner.CornerRadius = UDim.new(0, 10)
ArrowCorner.Parent = ArrowButton

-- Content
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 0, 0)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = Content

-- ==================== UI CREATION FUNCTIONS ====================
local function CreateToggle(name, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Colors.White
    frame.BorderSizePixel = 0
    frame.Parent = Content
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Colors.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 45, 0, 22)
    button.Position = UDim2.new(1, -52, 0.5, -11)
    button.BackgroundColor3 = default and Colors.Toggle_On or Colors.Toggle_Off
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = frame
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = button
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Colors.White
    knob.BorderSizePixel = 0
    knob.Parent = button
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    local enabled = default
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Colors.Toggle_On or Colors.Toggle_Off
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        if callback then callback(enabled) end
    end)
    return {Frame = frame}
end

local function CreateSlider(text, min, max, default, rounding, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Colors.White
    frame.BorderSizePixel = 0
    frame.Parent = Content
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Colors.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -55, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextColor3 = Colors.Accent
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 4)
    track.Position = UDim2.new(0, 10, 1, -12)
    track.BackgroundColor3 = Colors.Border
    track.BorderSizePixel = 0
    track.Parent = frame
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Primary
    fill.BorderSizePixel = 0
    fill.Parent = track
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Colors.Accent
    knob.BorderSizePixel = 0
    knob.Parent = track
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = Colors.White
    knobStroke.Thickness = 2
    knobStroke.Parent = knob
    local dragging = false
    local value = default
    local function updateSlider(input)
        local trackSize = track.AbsoluteSize.X
        local mousePos = input.Position.X - track.AbsolutePosition.X
        local percent = math.clamp(mousePos / trackSize, 0, 1)
        value = min + (max - min) * percent
        if rounding then
            value = math.floor(value / rounding + 0.5) * rounding
        end
        valueLabel.Text = tostring(value)
        TweenService:Create(fill, TweenInfo.new(0.1), {
            Size = UDim2.new(percent, 0, 1, 0)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.1), {
            Position = UDim2.new(percent, -7, 0.5, -7)
        }):Play()
        if callback then callback(value) end
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    return {Frame = frame, ValueLabel = valueLabel, Fill = fill, Knob = knob, Min = min, Max = max}
end

function updateSliderVisual(slider, val)
    val = math.clamp(val, slider.Min, slider.Max)
    local percent = (val - slider.Min) / (slider.Max - slider.Min)
    slider.ValueLabel.Text = string.format("%.3f", val)
    slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
    slider.Knob.Position = UDim2.new(percent, -7, 0.5, -7)
end

-- ==================== CREATE CONTROLS ====================
CreateToggle("AimlockToggle", "Aimlock(Q)", false, function(val)
    Config.Aimlock.Enabled = val
    if val then
        StartAimlock()
    else
        if AimlockConnection then
            AimlockConnection:Disconnect()
        end
        SetTarget(nil)
    end
end)

local aimSmoothSlider = CreateSlider("Aimlock Smooth (0 = instant)", 0, 1, 1, 0.01, function(val)
    Config.Aimlock.Smooth = val == 0 and 0.01 or val
end)

local aimPredSlider = CreateSlider("Aimlock Prediction", 0, 1, 0, 0.001, function(val)
    Config.Aimlock.Prediction = val
end)

CreateToggle("AutoShootToggle", "Auto Shoot ", false, function(val)
    Config.AutoShoot = val
end)

if Config.SilentAim.Supported then
    CreateToggle("SilentAimToggle", "Silent Aim", false, function(val)
        Config.SilentAim.Enabled = val
    end)
else
    local silentFrame = Instance.new("Frame")
    silentFrame.Size = UDim2.new(1, 0, 0, 35)
    silentFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
    silentFrame.BorderSizePixel = 0
    silentFrame.Parent = Content
    local silentCorner = Instance.new("UICorner")
    silentCorner.CornerRadius = UDim.new(0, 8)
    silentCorner.Parent = silentFrame
    local silentLabel = Instance.new("TextLabel")
    silentLabel.Size = UDim2.new(1, -20, 1, 0)
    silentLabel.Position = UDim2.new(0, 10, 0, 0)
    silentLabel.BackgroundTransparency = 1
    silentLabel.Text = "⚠️ Your executor doesn't support Silent Aim"
    silentLabel.Font = Enum.Font.GothamMedium
    silentLabel.TextSize = 11
    silentLabel.TextColor3 = Color3.fromRGB(180, 50, 50)
    silentLabel.TextXAlignment = Enum.TextXAlignment.Left
    silentLabel.TextWrapped = true
    silentLabel.Parent = silentFrame
end

local silentPredSlider = CreateSlider("Silent Aim Prediction", 0, 1, 0, 0.001, function(val)
    Config.SilentAim.Prediction = val
end)

CreateToggle("AutoPredictionToggle", "Auto Prediction", false, function(val)
    Config.AutoPrediction = val
end)

CreateToggle("OutlineToggle", "Outline Target", false, function(val)
    Config.OutlineTarget = val
    if not val and CurrentOutline then
        CurrentOutline:Destroy()
        CurrentOutline = nil
    elseif val and CurrentTarget and CurrentTarget.Character then
        CreateOutline(CurrentTarget.Character)
    elseif val and silentTarget and silentTarget.Character and Config.SilentAim.Enabled then
        CreateOutline(silentTarget.Character)
    end
end)

CreateToggle("WalkspeedToggle", "Walkspeed(T)", false, function(val)
    Config.Walkspeed.Enabled = val
end)

CreateSlider("Walkspeed Value", 1, 300, 50, 1, function(val)
    Config.Walkspeed.Speed = val
end)

CreateToggle("NoclipToggle", "Noclip(N)", false, function(val)
    Config.Noclip.Enabled = val
end)

-- ==================== MOBILE BUTTONS ====================
if IsMobile() then
    -- Aimlock Mobile Button
    local AimlockMobileBtn = Instance.new("TextButton")
    AimlockMobileBtn.Name = "AimlockMobile"
    AimlockMobileBtn.Size = UDim2.new(0, 60, 0, 60)
    AimlockMobileBtn.Position = UDim2.new(0, 20, 0.5, -30)
    AimlockMobileBtn.BackgroundColor3 = Colors.Primary
    AimlockMobileBtn.BorderSizePixel = 0
    AimlockMobileBtn.Text = "🎯"
    AimlockMobileBtn.Font = Enum.Font.GothamBold
    AimlockMobileBtn.TextSize = 28
    AimlockMobileBtn.TextColor3 = Colors.White
    AimlockMobileBtn.AutoButtonColor = false
    AimlockMobileBtn.Parent = ScreenGui
    local aimlockCorner = Instance.new("UICorner")
    aimlockCorner.CornerRadius = UDim.new(1, 0)
    aimlockCorner.Parent = AimlockMobileBtn
    local aimlockStroke = Instance.new("UIStroke")
    aimlockStroke.Color = Colors.Accent
    aimlockStroke.Thickness = 3
    aimlockStroke.Parent = AimlockMobileBtn
    AimlockMobileBtn.MouseButton1Click:Connect(function()
        if CurrentTarget then
            SetTarget(nil)
            AimlockMobileBtn.Text = "🎯"
        else
            local target = GetClosestPlayerToCursor()
            SetTarget(target)
            AimlockMobileBtn.Text = "🔓"
        end
    end)
    -- Dragging for mobile button
    local dragging = false
    local dragInput, dragStart, startPos
    AimlockMobileBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = AimlockMobileBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    AimlockMobileBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            TweenService:Create(AimlockMobileBtn, TweenInfo.new(0.1), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    -- Walkspeed Mobile Button
    local WalkspeedMobileBtn = Instance.new("TextButton")
    WalkspeedMobileBtn.Name = "WalkspeedMobile"
    WalkspeedMobileBtn.Size = UDim2.new(0, 60, 0, 60)
    WalkspeedMobileBtn.Position = UDim2.new(0, 20, 0.5, 50)
    WalkspeedMobileBtn.BackgroundColor3 = Colors.Primary
    WalkspeedMobileBtn.BorderSizePixel = 0
    WalkspeedMobileBtn.Text = "⚡"
    WalkspeedMobileBtn.Font = Enum.Font.GothamBold
    WalkspeedMobileBtn.TextSize = 28
    WalkspeedMobileBtn.TextColor3 = Colors.White
    WalkspeedMobileBtn.AutoButtonColor = false
    WalkspeedMobileBtn.Parent = ScreenGui
    local walkCorner = Instance.new("UICorner")
    walkCorner.CornerRadius = UDim.new(1, 0)
    walkCorner.Parent = WalkspeedMobileBtn
    local walkStroke = Instance.new("UIStroke")
    walkStroke.Color = Colors.Accent
    walkStroke.Thickness = 3
    walkStroke.Parent = WalkspeedMobileBtn
    WalkspeedMobileBtn.MouseButton1Click:Connect(function()
        Config.Walkspeed.Enabled = not Config.Walkspeed.Enabled
        WalkspeedMobileBtn.BackgroundColor3 = Config.Walkspeed.Enabled and Colors.Accent or Colors.Primary
    end)
    -- Dragging for walkspeed button
    local dragging2 = false
    local dragInput2, dragStart2, startPos2
    WalkspeedMobileBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            dragStart2 = input.Position
            startPos2 = WalkspeedMobileBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging2 = false
                end
            end)
        end
    end)
    WalkspeedMobileBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput2 = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging2 and input == dragInput2 and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart2
            TweenService:Create(WalkspeedMobileBtn, TweenInfo.new(0.1), {
                Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- ==================== KEYBINDS ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    -- Aimlock Keybind
    if input.KeyCode == Config.Aimlock.Keybind then
        if CurrentTarget then
            SetTarget(nil)
        else
            local target = GetClosestPlayerToCursor()
            SetTarget(target)
        end
    end
    -- Walkspeed Keybind
    if input.KeyCode == Config.Walkspeed.Keybind then
        Config.Walkspeed.Enabled = not Config.Walkspeed.Enabled
    end
    -- Noclip Keybind
    if input.KeyCode == Config.Noclip.Keybind then
        Config.Noclip.Enabled = not Config.Noclip.Enabled
        Notify(Config.Noclip.Enabled and "👻 Noclip Enabled" or "👻 Noclip Disabled", 1.5)
    end
end)

-- ==================== EXPAND/COLLAPSE ====================
local IsExpanded = false
local ContentHeight = 0
local function UpdateLayout()
    ContentHeight = ContentLayout.AbsoluteContentSize.Y
end
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateLayout)
UpdateLayout()

ArrowButton.MouseButton1Click:Connect(function()
    IsExpanded = not IsExpanded
    local targetHeight = IsExpanded and (60 + ContentHeight + 20) or 50
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 340, 0, targetHeight)
    }):Play()
    TweenService:Create(ArrowButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = IsExpanded and 180 or 0
    }):Play()
    ArrowButton.Text = IsExpanded and "▲" or "▼"
end)

-- ==================== DRAGGING ====================
local dragging = false
local dragInput, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        TweenService:Create(MainFrame, TweenInfo.new(0.1), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
end)

-- ==================== WELCOME MESSAGES ====================
wait(1)
Notify("script for cute people:3", 3, Colors.Accent)
Notify("Welcome " .. LocalPlayer.DisplayName .. " 💖", 2.5, Colors.Primary)
