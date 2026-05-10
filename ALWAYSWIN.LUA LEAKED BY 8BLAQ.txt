local repo = 'https://raw.githubusercontent.com/LionTheGreatRealFrFr/MobileLinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'diax.cc | 8blaq | hxcker',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Aiming'),
    Misc = Window:AddTab('Misc'),
    Config = Window:AddTab('Config'),
}

local Main = Tabs.Main:AddLeftGroupbox("Camlock & TargetAim")

local Preds = Tabs.Main:AddLeftGroupbox("Predictions")

local LockType = Tabs.Main:AddRightGroupbox("LockType")

local Misc = Tabs.Misc:AddLeftGroupbox("ForceHit")

local HighLight = Tabs.Misc:AddRightGroupbox("Highlight")

local HitSound = Tabs.Main:AddRightGroupbox("Hitsounds")

local diaxcc = {
    TargetAim = {
        Enabled = true,
        Keybind = "C",
        Pred = 0.168,
        Part = "Head",
        Method = "Index", -- // you can choose index or namecall -- //
        ForcehitHC = {
            Enabled = false,
            Part = "Head",
        },
        HitSound = {
            Enabled = true,
            Sound = "Bameware",
        },
    },
    Camlock = {
        Enabled = true,
        Pred = 0.13,
        Part = "HumanoidRootPart",
        Settings = {
            Smoothness = 0.0015,
        },
    },
    KOCheck = {
        Enabled = true,
    },
    HitSoundId = { -- Added HitSoundId table here
        Bameware = "rbxassetid://3124331820",
        Bell = "rbxassetid://6534947240",
        Bubble = "rbxassetid://6534947588",
        Pick = "rbxassetid://1347140027",
        Pop = "rbxassetid://198598793",
        Rust = "rbxassetid://1255040462",
        Sans = "rbxassetid://3188795283",
        Fart = "rbxassetid://130833677",
        Big = "rbxassetid://5332005053",
        Vine = "rbxassetid://5332680810",
        Bruh = "rbxassetid://4578740568",
        Skeet = "rbxassetid://5633695679",
        Neverlose = "rbxassetid://6534948092",
        Fatality = "rbxassetid://6534947869",
        Bonk = "rbxassetid://5766898159",
        Minecraft = "rbxassetid://4018616850"
    }
}

local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalPlayerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local Targetting = false
local Target = nil

local funcs = {}

funcs.GetClosestPlayer = function()
    if not Camera then return nil end
    local closestDist = math.huge
    local closestPlr = nil
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Client and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            if v ~= Players.LocalPlayer then 
                local screenPos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if distFromCenter < closestDist then
                        closestDist = distFromCenter
                        closestPlr = v
                    end
                end
            end
        end
    end
    return closestPlr
end

funcs.Camlock = function()
    if diaxcc.Camlock.Enabled and Target and Target.Character then
        local TargetPart = Target.Character:FindFirstChild(diaxcc.Camlock.Part)
        if TargetPart then
            local Prediction = TargetPart.CFrame + (TargetPart.Velocity * diaxcc.Camlock.Pred)
            local Smoothness = diaxcc.Camlock.Settings.Smoothness
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, Prediction.Position), Smoothness)
        end
    end
end

runService.Heartbeat:Connect(funcs.Camlock)

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("ImageButton")

ScreenGui.Parent = gethui()
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

Frame.Parent = ScreenGui
Frame.BackgroundTransparency = 1
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 90, 0, 90)
Frame.Draggable = false
Frame.Active = true

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BackgroundTransparency = 0.5
TextButton.Size = UDim2.new(0, 75, 0, 75)
TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton.Position = UDim2.new(0.5, 0, 0.5, 0)
TextButton.Image = "rbxassetid://10747366027"
TextButton.Draggable = true
TextButton.Active = true

local uiiCorner = Instance.new("UICorner", TextButton)
uiiCorner.CornerRadius = UDim.new(0, 8)

funcs.Toggle = function()
    Targetting = not Targetting
    if Targetting then
        Target = funcs.GetClosestPlayer()
        if Target then
            TextButton.Image = "rbxassetid://10723434711"
        else
            Targetting = false
            TextButton.Image = "rbxassetid://10747366027"
        end
    else
        Target = nil
        TextButton.Image = "rbxassetid://10747366027"
    end
end

UIS.InputBegan:Connect(function(key, event)
    if diaxcc.TargetAim.Enabled then
        if event then return end
        if key.KeyCode == Enum.KeyCode[diaxcc.TargetAim.Keybind] then
            funcs.Toggle()
        end
    end
end)

TextButton.MouseButton1Click:Connect(function()
    if diaxcc.TargetAim.Enabled then
        funcs.Toggle()
    end
end)

runService.Heartbeat:Connect(function()
    if diaxcc.TargetAim.ForcehitHC.Enabled and Target then
        local LocalPlayer = Players.LocalPlayer
        local CurrentPosition = LocalPlayer.Character.HumanoidRootPart.Position
        local ShootDirection = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
        local ShootPosition = CurrentPosition + ShootDirection * 10
        local Normal = ShootDirection.unit
        local Offset = Normal * 0.5
        local ClosestPart = Target.Character:FindFirstChild(diaxcc.TargetAim.ForcehitHC.Part) or "Head"
        if ClosestPart and not Target.Character:FindFirstChildOfClass("ForceField") then
            local Args = {
                [1] = "Shoot",
                [2] = {
                    [1] = {
                        [1] = {
                            ["Instance"] = ClosestPart,
                            ["Normal"] = Normal,
                            ["Position"] = CurrentPosition
                        }
                    },
                    [2] = {
                        [1] = {
                            ["thePart"] = ClosestPart,
                            ["theOffset"] = CFrame.new(Offset)
                        }
                    },
                    [3] = ShootPosition,
                    [4] = CurrentPosition,
                    [5] = tick()
                }
            }
            replicatedStorage.MainEvent:FireServer(unpack(Args))
        end
    end
end)

if diaxcc.TargetAim.Method == "Namecall" and not diaxcc.TargetAim.ForcehitHC.Enabled then
    local __namecall
    __namecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)   
        local Args = {...}
        local Method = tostring(getnamecallmethod())
        if not checkcaller() and Method == "FireServer" then
            for i, Arg in pairs(Args) do
                if typeof(Arg) == "Vector3" and diaxcc.TargetAim.Enabled then
                    if Target and Target.Character and diaxcc.TargetAim.Part and Target.Character[diaxcc.TargetAim.Part] then
                        local TargetPart = Target.Character[diaxcc.TargetAim.Part]
                        local predictedPosition = TargetPart.Position + (TargetPart.Velocity * diaxcc.TargetAim.Pred)
                        Args[i] = predictedPosition
                    end
                    return __namecall(Self, unpack(Args))
                end
            end
        end
        return __namecall(Self, ...)
    end))
end

if diaxcc.TargetAim.Method == "Index" and not diaxcc.TargetAim.ForcehitHC.Enabled then
    local index = nil
    index = hookmetamethod(game, "__index", newcclosure(function(Object, Key, ...)
        if Object:IsA("Mouse") and Key == "Hit" then
            if diaxcc.TargetAim.Enabled and Target and Target.Character and diaxcc.TargetAim.Part and Target.Character[diaxcc.TargetAim.Part] then
                local TargetPart = Target.Character[diaxcc.TargetAim.Part]
                local predictedPosition = TargetPart.Position + (TargetPart.Velocity * diaxcc.TargetAim.Pred)
                return CFrame.new(predictedPosition)
            end
        end
        return index(Object, Key, ...)
    end))
end


Main:AddToggle("CamlockToggle", {
    Text = "Enable Camlock",
    Default = diaxcc.Camlock.Enabled,
    Callback = function(state)
        diaxcc.Camlock.Enabled = state
    end
})

Main:AddToggle("TargetAimToggle", {
    Text = "Enable Target Aim",
    Default = diaxcc.TargetAim.Enabled,
    Callback = function(state)
        diaxcc.TargetAim.Enabled = state
    end
})

Preds:AddInput('CamlockSmoothness', {
    Default = '0.9',
    Text = 'Smoothness for Camlock',
    Tooltip = 'Enter a value for camlock smoothness',
    Placeholder = 'Enter Smoothness Value',
    Callback = function(Value)
        diaxcc.Camlock.Settings.Smoothness = tonumber(Value) or diaxcc.Camlock.Settings.Smoothness
    end
})

Preds:AddInput('TargetAimPrediction', {
    Default = '0.168',
    Text = 'Prediction for Target Aim',
    Tooltip = 'Enter a value for target aim prediction',
    Placeholder = 'Enter Prediction Value',
    Callback = function(Value)
        diaxcc.TargetAim.Pred = tonumber(Value) or diaxcc.TargetAim.Pred
    end
})

LockType:AddDropdown('TargetAimMethod', {
    Values = {"Index", "Namecall"},
    Default = "Index",
    Text = "Target Aim Method",
    Tooltip = "Choose the method for targeting (Index or Namecall)",
    Callback = function(Value)
        diaxcc.TargetAim.Method = Value
    end
})

Main:AddDropdown('CamlockPart', {
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftLeg", "RightLeg", "LeftArm", "RightArm"},
    Default = "HumanoidRootPart",
    Text = "Camlock Part",
    Tooltip = "Select the part of the target to focus camlock on",
    Callback = function(Value)
        diaxcc.Camlock.Part = Value
    end
})

Main:AddDropdown('TargetAimPart', {
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftLeg", "RightLeg", "LeftArm", "RightArm"},
    Default = "Head",
    Text = "Target Aim Part",
    Tooltip = "Select the part of the player to aim at",
    Callback = function(Value)
        diaxcc.TargetAim.Part = Value
    end
})

Misc:AddToggle('ForceHitToggle', {
    Text = "Force Hit",
    Default = false,
    Callback = function(State)
        diaxcc.TargetAim.ForcehitHC.Enabled = State
        if not State then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character then
                    resetCharacter(Player.Character)
                end
            end
        end
    end
})

Misc:AddDropdown('ForceHitMethod', {
    Values = {"KillAura", "Targeted", "AlwaysOn"},
    Default = "KillAura",
    Text = "Force Hit Method",
    Tooltip = "Select how Force Hit will behave (KillAura, Targeted, AlwaysOn)",
    Callback = function(Value)
        diaxcc.TargetAim.ForcehitHC.Method = Value
    end
})



HighLight:AddToggle('Highlight', {
    Text = "Highlight",
    Default = false,
    Callback = function(State)
        diaxcc.Camlock.HighlightEnabled = State
    end
})

local function ApplyHighlight()
    if diaxcc.Camlock.HighlightEnabled and Target and Target.Character then
        local highlight = Target.Character:FindFirstChild("Highlight")
        
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Parent = Target.Character
        end
        
        highlight.FillColor = diaxcc.Camlock.HighlightColor
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    elseif diaxcc.Camlock.HighlightEnabled == false and Target and Target.Character and Target.Character:FindFirstChild("Highlight") then
        Target.Character.Highlight:Destroy()
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if Target then
        ApplyHighlight()
    elseif Target == nil and Target.Character and Target.Character:FindFirstChild("Highlight") then
        Target.Character.Highlight:Destroy()
    end
end)

HighLight:AddDropdown('HighlightColor', {
    Values = {"Red", "Green", "Blue", "Yellow", "Purple", "Orange", "Pink"},
    Default = "Red",
    Text = "Highlight Color",
    Tooltip = "Choose the color for the highlight",
    Callback = function(Value)
        local colorMap = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            Purple = Color3.fromRGB(128, 0, 128),
            Orange = Color3.fromRGB(255, 165, 0),
            Pink = Color3.fromRGB(255, 105, 180),
        }
        diaxcc.Camlock.HighlightColor = colorMap[Value]
    end
})

HitSound:AddToggle('EnableHitSound', {
    Text = "Enable Hit Sounds",
    Default = true,
    Callback = function(state)
        HitSoundEnabled = state
    end
})

HitSound:AddDropdown('HitSound', {
    Values = {
        "Bameware", "Bell", "Bubble", "Pick", "Pop", 
        "Rust", "Sans", "Fart", "Big", "Vine", 
        "Bruh", "Skeet", "Neverlose", "Fatality", 
        "Bonk", "Minecraft"
    },
    Default = "Bameware",
    Text = "Select Hit Sound",
    Tooltip = "Choose the hit sound for when you hit an enemy.",
    Callback = function(Value)
        local selectedSoundId = HitSoundId[Value]
        print("Selected Hit Sound: " .. Value .. " with ID: " .. selectedSoundId)


        local sound = Instance.new("Sound")
        sound.SoundId = selectedSoundId
        sound.Parent = game.Workspace
        sound:Play()
    end
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder("Diaxcc")
SaveManager:SetFolder("Diaxcc")

SaveManager:BuildConfigSection(Tabs.Config)
SaveManager:LoadAutoloadConfig()
ThemeManager:ApplyToTab(Tabs.Config)