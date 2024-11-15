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
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Hxckerskyy/frost.lol/refs/heads/main/uilib.lua"))()
