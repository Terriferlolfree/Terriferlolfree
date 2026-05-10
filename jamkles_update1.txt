local Tool = Instance.new("Tool")

Tool.RequiresHandle = false

Tool.Name = "jamkles lua"

Tool.Parent = game.Players.LocalPlayer.Backpack

local player = game.Players.LocalPlayer

local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end

connectCharacterAdded()

player.CharacterRemoving:Connect(
    function()
        Tool.Parent = game.Players.LocalPlayer.Backpack
    end
)
--- { TOOL } ---

local NotificationHolder =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/kpLzpNXc"))()

local Window = Library:CreateWindow("jamkles lua", Vector2.new(300, 300), Enum.KeyCode.V)

getgenv().StrafeSpeed = 10

getgenv().StrafeRadius = 8

getgenv().StrafeHeight = 2

local AimingTab = Window:CreateTab("Legit")
local HvhTab = Window:CreateTab("Rage")
local MiscTab = Window:CreateTab("Misc")

--- { MAIN } ---

local Lock = AimingTab:CreateSector("Camlock", "left")

Lock:AddToggle(
    "toggle camlock",
    true,
    function(first)
        local Locked = first
    end
)

Lock:AddTextbox(
    "Prediction",
    0.12389724521,
    function(State)
        getgenv().Prediction = State
    end
)

Lock:AddTextbox(
    "Shake",
    0,
    function(State)
        getgenv().ShakeValue = State
    end
)

Lock:AddTextbox(
    "Smoothing",
    1,
    function(State)
        getgenv().Smoothness = State
    end
)

Lock:AddDropdown(
    "HitPart",
    {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    "UpperTorso",
    false,
    function(Option)
        getgenv().AimPart = Option
    end
)

local Lock = AimingTab:CreateSector("Silent aim", "right")

Lock:AddToggle(
    "Enabled",
    false,
    function(first)
        getgenv().jamklesSilent.Enabled = first
    end
)

Lock:AddTextbox(
    "Prediction",
    0.1255, 
    function(State)
        getgenv().jamklesSilent.Prediction = State
    end
)
Lock:AddToggle(
    "wallcheck",
    true,
    function(first)
        getgenv().jamklesSilent.WallCheck = first
    end
)

Lock:AddToggle(
    "Resolver",
    false,
    function(first)
        getgenv().jamklesSilent.Resolver = first
    end
)

Lock:AddToggle(
    "Show Fov",
    true,
    function(first)
        getgenv().jamklesSilent.FovSettings.FovVisible = first
    end
)

Lock:AddToggle(
    "Show hit point",
    false,
    function(first)
        getgenv().jamklesSilent.HitPoint.ShowHitPoint = first
    end
)

Lock:AddTextbox(
    "hitpoint radius",
    8,
    function(state)
        getgenv().HitPoint.HitPointRadius = first
    end
)
Lock:AddTextbox(
    "hitpoint Thickness",
    2,
    function(state)
        getgenv().HitPoint.HitPointThickness = first
    end
)
Lock:AddTextbox(
    "hitpoint Transparency",
    1,
    function(state)
        getgenv().HitPoint.HitPointTransparency = first
    end
)
--- { HVH } ---
local Hvh = HvhTab:CreateSector("rage ", "left")

Hvh:AddTextbox(
    "Speed",
    16,
    function(State)
        getgenv().jamklesluaspeed = State
    end
)

Hvh:AddButton(
    "SpinBot",
    function()
        game.Players.LocalPlayer.HumanoidRootPart.CFrame =
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad((psitive1)), 0)
    end
)

Hvh:AddButton(
    "jitter",
    function()
        game.Player.LocalPlayer.Character.HumanoidRootPart.CFrame =
            CFrame.new(game.Player.LocalPlayer.Character.HumanoidRootPart.CFrame.Position) *
            CFrame.Angles(0, math.rad(Angle) + math.rad((math.random(1, 2) == 1 and Jit or -Jit)), 0)
    end
)

local Hvh = HvhTab:CreateSector("target strafe", "right")

Hvh:AddToggle(
    "Enabled",
    false,
    function(first)
        getgenv().TargetStrafe = first
    end
)

Hvh:AddTextbox(
    "Distance",
    nil,
    function(State)
        getgenv().StrafeRadius = State
    end
)

Hvh:AddTextbox(
    "Height",
    nil,
    function(State)
        getgenv().StrafeHeight = State
    end
)

Hvh:AddTextbox(
    "Speed",
    nil,
    function(State)
        getgenv().StrafeSpeed = State
    end
)

--- { Misc } ---

local Misc = MiscTab:CreateSector("Toggles", "left")

Misc:AddToggle(
    "Anti ground",
    false,
    function(first)
        getgenv().AntiGround = first
    end
)

Misc:AddToggle(
    "Anti aim viewer",
    false,
    function(first)
        getgenv().aav = first
    end
)

local Misc = MiscTab:CreateSector("Buttons", "right")

Misc:AddButton(
    "Click to tp tool",
    function()
        mouse = game.Players.LocalPlayer:GetMouse()
        tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click TP"
        tool.Activated:connect(
            function()
                local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
                pos = CFrame.new(pos.X, pos.Y, pos.Z)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
            end
        )
        tool.Parent = game.Players.LocalPlayer.Backpack
    end
)

Misc:AddButton(
    "Hitbox shower",
    function()
        _G.HeadSize = 3.631

        _G.Disabled = true

        game:GetService("RunService").RenderStepped:connect(
            function()
                if _G.Disabled then
                    for i, v in next, game:GetService("Players"):GetPlayers() do
                        if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                            pcall(
                                function()
                                    v.Character.HumanoidRootPart.Size =
                                        Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                                    v.Character.HumanoidRootPart.Transparency = 0.1
                                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Purple")
                                    v.Character.HumanoidRootPart.Material = "ForceField"
                                    v.Character.HumanoidRootPart.CanCollide = false
                                end
                            )
                        end
                    end
                end
            end
        )
    end
)

Misc:AddButton(
    "Rightclick",
    function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BalligusapoTT/BalligusapoTT/main/Leftclickballi"))()
    end
)

Misc:AddButton(
    "Strech res",
    function()
        getgenv().Resolution = {
            [".gg/scripters"] = 0.65
        }

        local Camera = workspace.CurrentCamera
        if getgenv().gg_scripters == nil then
            game:GetService("RunService").RenderStepped:Connect(
                function()
                    Camera.CFrame =
                        Camera.CFrame *
                        CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
                end
            )
        end
        getgenv().gg_scripters = "Aori0001"
    end
)

Misc:AddButton(
    "Global low gfx",
    function()
        for _, v in pairs(workspace:GetDescendants()) do
            if
                v.ClassName == "Part" or v.ClassName == "SpawnLocation" or v.ClassName == "WedgePart" or
                    v.ClassName == "Terrain" or
                    v.ClassName == "MeshPart"
             then
                v.Material = "Plastic"
            end
        end
    end
)

Misc:AddButton(
    "Rejoin Server",
    function()
        local ts = game:GetService("TeleportService")

        local p = game:GetService("Players").LocalPlayer

        ts:Teleport(game.PlaceId, p)
    end
)

Misc:AddButton(
    "Resolver",
    function()
        local CPlayer = Aiming.Selected
        local hrp = CPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Y, hrp.Velocity.Z)
    end
)

--- { Function } ---

getgenv().Prediction = 0.12389724521
getgenv().Smoothness = 1
getgenv().AimPart = "UpperTorso"
getgenv().ShakeValue = 0
getgenv().AutoPred = false

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset

local AimlockState = true
local Locked
local Victim

local SelectedKey = getgenv().Key
local SelectedDisableKey = getgenv().DisableKey

if getgenv().Loaded == true then
    Notify("Loaded")
    return
end

getgenv().Loaded = true

local fov = Drawing.new("Circle")
fov.Filled = false
fov.Transparency = 1
fov.Thickness = 1
fov.Color = Color3.fromRGB(255, 255, 0)
fov.NumSides = 1000

function update()
    if getgenv().FOV == true then
        if fov then
            fov.Radius = getgenv().FOVSize * 2
            fov.Visible = getgenv().ShowFOV
            fov.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GS).Y)

            return fov
        end
    end
end

function WTVP(arg)
    return Camera:WorldToViewportPoint(arg)
end

function WTSP(arg)
    return Camera.WorldToScreenPoint(Camera, arg)
end

function getClosest()
    local closestPlayer
    local shortestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        local notKO = v.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local notGrabbed = v.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil

        if
            v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
                v.Character.Humanoid.Health ~= 0 and
                v.Character:FindFirstChild(getgenv().AimPart) and
                notKO and
                notGrabbed
         then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude

            if (getgenv().FOV) then
                if (fov.Radius > magnitude and magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            else
                if (magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

Tool.Activated:Connect(
    function()
        if AimlockState == true then
            Locked = not Locked
            if Locked then
                Victim = getClosest()

                Notification:Notify(
                    {
                        Title = "jamkles.lua",
                        Description = "Locked on: " .. tostring(Victim.Character.Humanoid.DisplayName)
                    },
                    {OutlineColor = Color3.fromRGB(255, 0, 54), Time = 3, Type = "default"},
                    {
                        Image = "http://www.roblox.com/asset/?id=6023426923",
                        ImageColor = Color3.fromRGB(255, 84, 84),
                        Callback = function(State)
                            print(tostring(State))
                        end
                    }
                )
            else
                if Victim ~= nil then
                    Victim = nil

                    Notification:Notify(
                        {Title = "jamkles.lua", Description = "unlocked"},
                        {OutlineColor = Color3.fromRGB(255, 0, 54), Time = 3, Type = "default"},
                        {
                            Image = "http://www.roblox.com/asset/?id=6023426923",
                            ImageColor = Color3.fromRGB(255, 84, 84),
                            Callback = function(State)
                                print(tostring(State))
                            end
                        }
                    )
                end
            end
        else
            Notify("Aimlock is not enabled!")
        end
    end
)

RS.RenderStepped:Connect(
    function()
        update()
        if Locked == true then
            if Victim ~= nil then
                local shakeOffset =
                    Vector3.new(
                    math.random(-getgenv().ShakeValue, getgenv().ShakeValue),
                    math.random(-getgenv().ShakeValue, getgenv().ShakeValue),
                    math.random(-getgenv().ShakeValue, getgenv().ShakeValue)
                ) * 0.171
                local LookPosition =
                    CFrame.new(
                    Camera.CFrame.p,
                    Victim.Character[getgenv().AimPart].Position +
                        (Vector3.new(
                            Victim.Character.HumanoidRootPart.Velocity.X,
                            Victim.Character.HumanoidRootPart.AssemblyAngularVelocity.Y * 0.5,
                            Victim.Character.HumanoidRootPart.Velocity.Z
                        ) *
                            getgenv().Prediction)
                ) + shakeOffset
                Camera.CFrame = Camera.CFrame:Lerp(LookPosition, getgenv().Smoothness)
            end
        end
    end
)

for _, con in next, getconnections(workspace.CurrentCamera.Changed) do
    task.wait()
    con:Disable()
end
for _, con in next, getconnections(workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")) do
    task.wait()
    con:Disable()
end

while task.wait() do
    if getgenv().AutoPred == true then
        pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        split = string.split(pingvalue, "(")
        ping = tonumber(split[1])
        if ping < 225 then
            getgenv().Prediction = 1.4
        elseif ping < 215 then
            getgenv().Prediction = 0.24
        elseif ping < 205 then
            getgenv().Prediction = 0.209
        elseif ping < 190 then
            getgenv().Prediction = 0.18474
        elseif ping < 180 then
            getgenv().Prediction = 0.177
        elseif ping < 170 then
            getgenv().Prediction = 0.174
        elseif ping < 160 then
            getgenv().Prediction = 0.17
        elseif ping < 150 then
            getgenv().Prediction = 0.165
        elseif ping < 140 then
            getgenv().Prediction = 0.165
        elseif ping < 130 then
            getgenv().Prediction = 0.165
        elseif ping < 120 then
            getgenv().Prediction = 0.155
        elseif ping < 110 then
            getgenv().Prediction = 0.155
        elseif ping < 105 then
            getgenv().Prediction = 0.149533
        elseif ping < 90 then
            getgenv().Prediction = 0.146373
        elseif ping < 80 then
            getgenv().Prediction = 0.14211
        elseif ping < 70 then
            getgenv().Prediction = 0.136354
        elseif ping < 60 then
            getgenv().Prediction = 0.1343
        elseif ping < 50 then
            getgenv().Prediction = 0.12846
        elseif ping < 40 then
            getgenv().Prediction = 0.126
        elseif ping < 30 then
            getgenv().Prediction = 0.12
        elseif ping < 20 then
            getgenv().Prediction = 0.11
        end
    end

    if getgenv().AntiGround == true then
        local currentvelocity = player.Character.HumanoidRootPart.Velocity
        player.Character.HumanoidRootPart.Velocity =
            Vector3.new(currentvelocity.X, currentvelocity.Y / 0.5, currentvelocity.Z)
    end

    if getgenv().TargetStrafe == true and Locked and Victim then
        local lp = game.Players.LocalPlayer.Character
        local targpos = Victim.Character.HumanoidRootPart.Position

        lp:SetPrimaryPartCFrame(
            CFrame.new(
                targpos +
                    Vector3.new(
                        math.cos(tick() * getgenv().StrafeSpeed) * getgenv().StrafeRadius,
                        getgenv().StrafeHeight,
                        math.sin(tick() * getgenv().StrafeSpeed) * getgenv().StrafeRadius
                    )
            )
        )

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            CFrame.new(
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position,
            Vector3.new(targpos.X, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y, targpos.Z)
        )

        game:GetService("Players").LocalPlayer.Character.Humanoid.AutoRotate = false
    else
        game:GetService("Players").LocalPlayer.Character.Humanoid.AutoRotate = true
    end
end

if getgenv().aav == true then
    function getClosestTarget()
        local closestDistance = math.huge
        local closestPlayer = nil

        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= Client and player.Character then
                local head = player.Character:FindFirstChild("Head")
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")

                if head and hrp then
                    local headScreenPos =
                        game.Workspace.CurrentCamera:WorldToViewportPoint(head.Position)(
                        Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(headScreenPos.X, headScreenPos.Y)
                    ).Magnitude

                    if distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end

        return closestPlayer
    end

    local ttarget = getClosestTarget()
    if ttarget then
    else
        wait()
    end
else
    print("Anti-aim viewer is disabled. Stopping the toggle.")
end

getgenv().jamklesluaspeed = 16

local Plrs = game:GetService("Players")

local MyPlr = Plrs.LocalPlayer
local MyChar = MyPlr.Character

if MyChar then
    local Hum = MyChar.Humanoid
    Hum.Changed:connect(
        function()
            Hum.WalkSpeed = getgenv().jamklesluaspeed
        end
    )
    Hum.WalkSpeed = getgenv().jamklesluaspeed
end

MyPlr.CharacterAdded:Connect(
    function(Char)
        MyChar = Char
        repeat
            wait()
        until Char:FindFirstChild("Humanoid")
        local Hum = Char.Humanoid
        Hum.Changed:connect(
            function()
                Hum.WalkSpeed = getgenv().jamklesluaspeed
            end
        )
        Hum.WalkSpeed = getgenv().jamklesluaspeed
    end
)

getgenv().jamklesSilent = {
    Enabled = false,
    Prediction = 0.1215,
    Keybind = "¿",
    Resolver = false,
    WallCheck = true,
    FovSettings = {
        FovVisible = true,
        FovRadius = 120,
        FovThickness = 1,
        FovTransparency = 0.8,
        FovColor = Color3.fromRGB(0, 255, 255),
        Filled = false,
        FillTransparency = 0.7,
        FovShape = "Circle"
    },
    HitPoint = {
        ShowHitPoint = false,
        HitPointRadius = 8,
        HitPointThickness = 2,
        HitPointColor = Color3.fromRGB(255, 0, 0),
        HitPointTransparency = 1,
    }
}
 loadstring(game:HttpGet("https://jamkleslua.000webhostapp.com/lua/silent.lua"))()