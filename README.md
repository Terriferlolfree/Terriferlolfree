for Key, Object in pairs(getgc(true)) do
    if type(Object) == "table" then
        setreadonly(Object, false)
        local indexInstance = rawget(Object, "indexInstance")
        if type(indexInstance) == "table" and indexInstance[1] == "kick" then
            setreadonly(indexInstance, false)
            rawset(Object, "Table", {"kick", function() coroutine.yield() end})
            break
        end
    end
end

local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "Lock Tool"
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
local MainColor = Color3.fromRGB(173, 216, 230);
getgenv().Configurations = {
    Target = {
        Enabled = true,
        Prediction = 0.1356785,
        AutoPrediction = false,
        AimPart = "HumanoidRootPart",
        AutoArmor = false,
        Notify = true,
        AirPartEnabled = false,
        AirPart = "Head",
        LookAt = false,
        Spectate = false,
        AutoAir = false,
        CameraLock = {
            Enabled = false,
            UseShake = false,
            Shake = 3,
            Smoothness = false,
            SmoothnessAmount = 0.1,
            Style = "Elastic",
            Direction = "InOut"
        },
        HitPart = {
            Part = "HumanoidRootPart",
            ClosestPart = false,
            Mode = "Nearest Part" -- Options: Nearest Point, Part
        },
        FOV = {
            Show = false,
            Size = 100
        },
        Checks = {
            Enabled = false,
            Knocked = false,
            Grabbed = false,
            AntiGroundShots = true
        }
    },
    TriggerBot = {
        Enabled = false,
        Visualize = false,
        Prediction = 0.135,
        Range = 20,
        UseDelay = false,
        Delay = 0.02
    },
    Resolver = {
        Enabled = true,
        Method = "Recalculate", -- Options: LookVector, Recalculate, Zero Prediction, Move Direction
        AntiAimViewer = false
    },
    Misc = {
        CSync = {
            Enabled = false,
            VoidSpam = false,
            DestroyCheaters = false,
            Attach = true,
            Type = "Random",
            Visualize = {
                Enabled = true,
                Type = "Dot",
                Color = MainColor,
            },
            Randomize = {
                Value = 20,
            },
            Custom = {
                X = 0,
                Y = 0,
                Z = 0,
            },
            CFrameSpeed = {
              Enabled = false,
              Speed = 1,
            },
            AutoBuy = {
                SelectedFood = "Taco",
                SelectedGun = "LMG",
            }
        },
        TargetStrafe = {
            Enabled = false,
            CSync = true,
            Type = "Randomize",
            Randomization = 3,
            Speed = 10,
            Distance = 5,
            Height = 5,
            BypassDC = false
        },
        Animation = {
            Enabled = false,
            Speed = 1,
            SelectedDance = "Floss"
        }
    },
    Visuals = {
        World = {
            Enabled = false,
            Fog = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                End = 1000,
                Start = 10000
            },
            Ambient = {
                Enabled = false,
                Color = Color3.new(1, 1, 1)
            },
            Brightness = {
                Enabled = false,
                Value = 0
            },
            ClockTime = {
                Enabled = false,
                Value = 24
            },
            WorldExposure = {
                Enabled = false,
                Value = -0.1
            }
        },
        Bullet_Trails = {
            Enabled = false,
            Width = 1.7,
            Duration = 5,
            Fade = false,
            FadeDuration = 5,
            Color = MainColor,
            Texture = "Normal" -- 12781803086
        },
        Bullet_Impacts = {
            Enabled = false,
            Width = 0.25,
            Color = MainColor,
            Duration = 5,
            Fade = false,
            FadeDuration = 5
        },
        Hit_Detection = {
            Enabled = false,
            Notify = true,
            Clone = false,
            HitEffect = false,
            HitEffectType = "Crescent Slash",
            Sound = false,
            HitSound = "Rust"
        },
        HighLight = {
            Enabled = true,
            Fill = MainColor,
            OutLine = Color3.fromRGB(255, 255, 255)
        },
        Line = {
            Enabled = true,
            Color = MainColor,
            Thickness = 2
        },
        Dot = {
            Enabled = false,
            Color = MainColor,
            Size = 0.5
        },
        BackTrack = {
            Enabled = false,
            Color = MainColor,
            ApplyTo = "Local Player",
            Duration = 0.1,
            Transparency = 0.5
        },
    }
}
local Notifications = {};
local Utility = {};
local Desync = {}
--
local Script = {
    Locals = {
        Angle = 0,
        Target = nil,
        AimAssistTarget = nil,
        HitPart = nil,
        AimAssistHitPart = nil,
        AimPoint = nil,
        AimAssistAimPoint = nil,
        Position = nil
    },
    Textures = {
        Normal = "rbxassetid://7151778302",
        Fog = "rbxassetid://9150635648"
    },
    World = {
        FogColor = game:GetService("Lighting").FogColor,
        FogStart = game:GetService("Lighting").FogStart,
        FogEnd = game:GetService("Lighting").FogEnd,
        Ambient = game:GetService("Lighting").Ambient,
        Brightness = game:GetService("Lighting").Brightness,
        ClockTime = game:GetService("Lighting").ClockTime,
        ExposureCompensation = game:GetService("Lighting").ExposureCompensation
    },
    HitSounds = {
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
    },
    Guns = {
        "Revolver",
        "Double-Barrel SG",
        "High-Medium Armor",
        "Flamethrower",
        "SMG",
        "RPG",
        "P90",
        "LMG",
        "Key"
    },
    Food = {
        "Pizza",
        "Taco",
        "Chicken",
        "Cranberry",
        "Popcorn",
        "Hamburger",
        "HotDog"
    }
}

local Guns = {
   "Revolver",
   "Double-Barrel SG",
   "High-Medium Armor",
   "Flamethrower",
   "SMG",
   "RPG",
   "P90",
   "LMG",
   "Key" 
}

local Food = {
   "Pizza",
   "Taco",
   "Chicken",
   "Cranberry",
   "Popcorn",
   "Hamburger",
   "HotDog",
 }

--
--
local game_support = {
    { Number = 1, Name = "Da Hood", Argument = real_dh_arg or "UpdateMousePosI", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Siren") and workspace.Ignored.Siren:FindFirstChild("Radius") or nil },
    { Number = 2, Name = "Locker Hood", Argument = "UpdateMousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 3, Name = "Hood Modded", Argument = "MousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 4, Name = "Da Downhill", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 5, Name = "Da Bank", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 6, Name = "Da Uphill", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 7, Name = "Da Strike", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 8, Name = "1v1 Hood Aim Trainer", Argument = "UpdateMousePos" },
    { Number = 9, Name = "Hood Aim", Argument = "MOUSE" },
    { Number = 10, Name = "Moon Hood", Argument = "MoonUpdateMousePos" },
    { Number = 11, Name = "OG Da Hood", Argument = "UpdateMousePos", Adonis = true },
    { Number = 12, Name = "Da Hood Macro", Argument = "UpdateMousePos1" },
    { Number = 13, Name = "Da Hood VC", Argument = real_dh_arg or "UpdateMousePosI", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Siren") and workspace.Ignored.Siren:FindFirstChild("Radius") or nil },
    { Number = 15, Name = "Hood Customs", Argument = real_dh_arg or "MousePosUpdate", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 16, Name = "Hood Z", Argument = "UpdateMousePos", BulletName = "bulletray", BulletBeamName = "beam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 17, Name = "Custom FFA", Argument = "UpdateMousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 18, Name = "Yeno Hood", Argument = "UpdateMousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
}

local connections = {}
if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_JIT_ULTRA = function(...) return ... end
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_NO_UPVALUES = function(f) return function(...) return f(...) end end
    LPH_ENCSTR = function(...) return ... end
    LPH_STRENC = function(...) return ... end
    LPH_HOOK_FIX = function(...) return ... end
    LPH_CRASH = function() return print(debug.traceback()) end
end

local wrap = LPH_NO_VIRTUALIZE(function(f)
    coroutine.resume(coroutine.create(f))
end)

local mouse_argument, bullet_beam_name, bullet_name, bullet_path

for _, support in ipairs(game_support) do
    bullet_beam_name = support.BulletBeamName
    bullet_name = support.BulletName
    bullet_path = support.BulletPath
    mouse_argument = support.Argument

    if bullet_name and bullet_beam_name and bullet_path then
        if bullet_path then
            bullet_path = bullet_path
            break
        end
    end
end


local Players           = game:GetService("Players");
local RunService        = game:GetService("RunService");
local UserInputService  = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace         = game:GetService("Workspace");
local TweenService      = game:GetService("TweenService");
local Configurations    = getgenv().Configurations -- you can just do Configurations but i defined it since i dont want that yellow indicator on my roblox lsp
local Debris            = game:GetService('Debris');
local Lighting       = game:GetService("Lighting");

local LocalPlayer       = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Drawing = Drawing.new
local crosshair_position = "Middle";
local clone_chams_tick = tick();
local is_targetting = false;
local old_hrp = nil;
local should_haalfi_destroy = false;
local Target = nil;
local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hxckerskyy/frost.lol/refs/heads/main/uilib.lua"))()

-- // Crosshair Handler \\ --
local Cursor = loadstring(game:HttpGet('https://pastebin.com/raw/bG7mehvN', true))() do
    getgenv().crosshair.enabled = true
    getgenv().crosshair.color = MainColor
    getgenv().crosshair.mode = "Middle"
end

-- // Trigger Bot FOV \\ --
local TriggerBotFOV = Drawing("Circle")
TriggerBotFOV.Transparency = 1
TriggerBotFOV.Thickness = 1
TriggerBotFOV.Radius = Configurations.TriggerBot.Range
TriggerBotFOV.Filled = false
TriggerBotFOV.Color = Color3.fromRGB(204, 255, 255)
TriggerBotFOV.Visible = false

do -- Notification Library
    local NotificationContainer = Instance.new("ScreenGui", gethui())

    local function UpdateNotifications()
        local i = 0
        for v in next, Notifications do
            if v.Holder then
                Utility:Tween(v.Holder, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0, 75 + (i * 25))})
                i = i + 1
            end
        end
    end

    local function UpdateNotifications2(Item)
        for _, v in pairs(Item) do
            if typeof(v) == "Instance" then
                task.spawn(function()
                    local tween = Utility:Tween(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                    tween.Completed:Connect(function()
                        if v.Name == "Holder" then v:Destroy() end
                    end)
                end)
                if v.ClassName == "TextLabel" then
                    Utility:Tween(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
                end
            end
        end
    end

    function Notifications:New(Text, Time, Color)
        Time = Time or 2
        Color = Color or Color3.fromRGB(173, 216, 230)
        Text = Text or "No text provided? "..tostring(math.random())

        local Notification = {}

        local Holder = Instance.new("Frame")
        Holder.Position = UDim2.new(0, -30, 0, 75)
        Holder.Size = UDim2.new(0, 0, 0, 23)
        Holder.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
        Holder.BorderSizePixel = 1
        Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Holder.Parent = NotificationContainer
        Notification.Holder = Holder

        local Background = Instance.new("Frame")
        Background.Size = UDim2.new(1, -4, 1, -4)
        Background.Position = UDim2.new(0, 2, 0, 2)
        Background.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        Background.BorderSizePixel = 1
        Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Background.Parent = Holder
        Notification.Background = Background

        local AccentBar = Instance.new("Frame")
        AccentBar.Size = UDim2.new(0, 1, 1, 0)
        AccentBar.BackgroundColor3 = Color
        AccentBar.Parent = Background
        Notification.AccentBar = AccentBar

        local AccentBar2 = Instance.new("Frame")
        AccentBar2.Size = UDim2.new(0, 0, 0, 1)
        AccentBar2.Position = UDim2.new(0, 0, 0, 15)
        AccentBar2.BackgroundColor3 = Color
        AccentBar2.Parent = Background
        Notification.AccentBar2 = AccentBar2

        local NotifText = Instance.new("TextLabel")
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.Position = UDim2.new(0, 3, 0, 0)
        NotifText.Size = UDim2.new(1, 0, 1, 0)
        NotifText.Font = Enum.Font.Ubuntu
        NotifText.TextColor3 = Color3.new(1, 1, 1)
        NotifText.BackgroundTransparency = 1
        NotifText.TextSize = 12
        NotifText.Text = Text
        NotifText.Parent = Background
        Notification.NotifText = NotifText

        Holder.Size = UDim2.new(0, NotifText.TextBounds.X + 10, 0, 19)
        AccentBar2.Size = UDim2.new(0, 1, 0, 1)

        Notifications[Notification] = true

        task.spawn(function()
            Holder.Size = UDim2.new(0, NotifText.TextBounds.X + 10, 0, 19)
            UpdateNotifications()
            AccentBar2:TweenSize(UDim2.new(0, Background.AbsoluteSize.X - 1, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, Time, false)
            task.wait(Time)
            UpdateNotifications2(Notification)
            task.wait(1.2)
            Notifications[Notification] = nil
            UpdateNotifications()
        end)
    end

    function Utility:Tween(...)
        local NewTween = game:GetService("TweenService"):Create(...)
        NewTween:Play()
        return NewTween
    end
end
--
-- // math
local custom_math = {}; do
   custom_math.get_auto_prediction = LPH_NO_VIRTUALIZE(function()
        local PingStats = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local Value = tostring(PingStats)
        local PingValue = Value:split(" ")
        local PingNumber = tonumber(PingValue[1])
        
        return tonumber(PingNumber / 1000 + 0.037)
        end)
   
   custom_math.random_vector3 = LPH_NO_VIRTUALIZE(function(randomization)
		return Vector3.new(math.random(-randomization, randomization), math.random(-randomization, randomization), math.random(-randomization, randomization));
	end);
	
   custom_math.recalculate_velocity = LPH_NO_VIRTUALIZE(function(player)
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local initialPosition = rootPart.Position
        local initialTime = tick()

        task.wait()

        local finalPosition = rootPart.Position
        local finalTime = tick()

        local distanceTraveled = finalPosition - initialPosition
        local timeInterval = finalTime - initialTime
        return distanceTraveled / timeInterval
    en
