--//uploaded by doitenroi.9941
local free_access = loadstring(game:HttpGet("https://pastebin.com/raw/mq68M8Zw"))() -- make it return true if delated
--
if free_access == true then
    local ReplicatedStorage = game:GetService('ReplicatedStorage')
    local OldGetFenv; OldGetFenv = hookfunction(getrenv().getfenv, function(...)
        if not checkcaller() then
            return coroutine.yield()
        end
        return OldGetFenv(...)
    end)
    
    local getinfo = getinfo or debug.getinfo
    local DEBUG = false
    local Hooked = {}
    local Detected, Kill
    setthreadidentity(2)
    for i, v in getgc(true) do
        if ( typeof(v) == 'table' ) then
            local DetectFunc = rawget(v, 'Detected')
            local KillFunc = rawget(v, 'Kill')
            if ( typeof(DetectFunc) == 'function' and not Detected ) then
                Detected = DetectFunc
                local Old; Old = hookfunction(Detected, newcclosure(function(Action, Info, NoCrash)
                    if ( Action ~= '_' ) then
                        end
                    return true
                end))
                table.insert(Hooked, Detected)
            end
            if ( rawget(v, 'Variables') and rawget(v, 'Process') and typeof(KillFunc) == 'function' and not Kill ) then
                Kill = KillFunc
                local Old; Old = hookfunction(Kill, newcclosure(function(Info)
                end))
                table.insert(Hooked, Kill)
            end
        end
    end
    local Old; Old = hookfunction(getrenv().debug.info, newcclosure(function(...)
        local LevelOrFunc, Info = ...
        if ( Detected and LevelOrFunc == Detected ) then
            return coroutine.yield(coroutine.running())
        end
        return Old(...)
    end))
    setthreadidentity(7)
    -- Pretty much just a bunch of know detection bypasses. (Big thanks to Lego Hacker, Modulus, Bluwu, and I guess Iris or something)
    
    -- GCInfo/CollectGarbage Bypass (Realistic by Lego - Amazing work!)
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
    
        local Amplitude = 200
        local RandomValue = {-200,200}
        local RandomTime = {.1, 1}
    
        local floor = math.floor
        local cos = math.cos
        local sin = math.sin
        local acos = math.acos
        local pi = math.pi
    
        local Maxima = 0
    
        --Waiting for gcinfo to decrease
        while task.wait() do
            if gcinfo() >= Maxima then
                Maxima = gcinfo()
            else
                break
            end
        end
    
        task.wait(0.30)
    
        local OldGcInfo = gcinfo()+Amplitude
        local tick = 0
    
        --Spoofing gcinfo
        local function getreturn()
            local Formula = ((acos(cos(pi * (tick)))/pi * (Amplitude * 2)) + -Amplitude )
            return floor(OldGcInfo + Formula);
        end
    
        local Old; Old = hookfunction(getrenv().gcinfo, function(...)
            return getreturn();
        end)
        local Old2; Old2 = hookfunction(getrenv().collectgarbage, function(arg, ...)
            local suc, err = pcall(Old2, arg, ...)
            if suc and arg == "count" then
                return getreturn();
            end
            return Old2(arg, ...);
        end)
    
    
        game:GetService("RunService").Stepped:Connect(function()
            local Formula = ((acos(cos(pi * (tick)))/pi * (Amplitude * 2)) + -Amplitude )
            if Formula > ((acos(cos(pi * (tick)+.01))/pi * (Amplitude * 2)) + -Amplitude ) then
                tick = tick + .07
            else
                tick = tick + 0.01
            end
        end)
    
        local old1 = Amplitude
        for i,v in next, RandomTime do
            RandomTime[i] = v * 10000
        end
    
        local RandomTimeValue = math.random(RandomTime[1],RandomTime[2])/10000
    
        --I can make it 0.003 seconds faster, yea, sure
        while wait(RandomTime) do
            Amplitude = math.random(old1+RandomValue[1], old1+RandomValue[2])
            RandomTimeValue = math.random(RandomTime[1],RandomTime[2])/10000
        end
    end)
    
    -- Memory Bypass
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
    
        local RunService = cloneref(game:GetService("RunService"))
        local Stats = cloneref(game:GetService("Stats"))
    
        local CurrMem = Stats:GetTotalMemoryUsageMb();
        local Rand = 0
    
        RunService.Stepped:Connect(function()
            local random = Random.new()
        	Rand = random:NextNumber(-10, 10);
        end)
    
        local function GetReturn()
            return CurrMem + Rand;
        end
    
        local _MemBypass
        _MemBypass = hookmetamethod(game, "__namecall", function(self,...)
            local method = getnamecallmethod();
    
            if not checkcaller() then
                if typeof(self) == "Instance" and (method == "GetTotalMemoryUsageMb" or method == "getTotalMemoryUsageMb") and self.ClassName == "Stats" then
                    return GetReturn();
                end
            end
    
            return _MemBypass(self,...)
        end)
    
        -- Indexed Versions
        local _MemBypassIndex; _MemBypassIndex = hookfunction(Stats.GetTotalMemoryUsageMb, function(self, ...)
            if not checkcaller() then
                if typeof(self) == "Instance" and self.ClassName == "Stats" then
                    return GetReturn();
                end
            end
        end)
    end)
    
    -- Memory Bypass X2 (Newer Method / Func)
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
    
        local RunService = cloneref(game:GetService("RunService"))
        local Stats = cloneref(game:GetService("Stats"))
    
        local CurrMem = Stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Gui);
        local Rand = 0
    
        RunService.Stepped:Connect(function()
        	local random = Random.new()
        	Rand = random:NextNumber(-0.1, 0.1);
        end)
    
        local function GetReturn()
            return CurrMem + Rand;
        end
    
        local _MemBypass
        _MemBypass = hookmetamethod(game, "__namecall", function(self,...)
            local method = getnamecallmethod();
    
            if not checkcaller() then
                if typeof(self) == "Instance" and (method == "GetMemoryUsageMbForTag" or method == "getMemoryUsageMbForTag") and self.ClassName == "Stats" then
                    return GetReturn();
                end
            end
    
            return _MemBypass(self,...)
        end)
    
        -- Indexed Versions
        local _MemBypassIndex; _MemBypassIndex = hookfunction(Stats.GetMemoryUsageMbForTag, function(self, ...)
            if not checkcaller() then
                if typeof(self) == "Instance" and self.ClassName == "Stats" then
                    return GetReturn();
                end
            end
        end)
    end)
    
    -- ContentProvider Bypasses
    local Content = cloneref(game:GetService("ContentProvider"));
    local CoreGui = cloneref(game:GetService("CoreGui"));
    local randomizedCoreGuiTable;
    local randomizedGameTable;
    
    local coreguiTable = {}
    
    game:GetService("ContentProvider"):PreloadAsync({CoreGui}, function(assetId) --use preloadasync to patch preloadasync :troll:
        if not assetId:find("rbxassetid://") then
            table.insert(coreguiTable, assetId);
    end
    end)
    local gameTable = {}
    
    for i, v in pairs(game:GetDescendants()) do
        if v:IsA("ImageLabel") then
            if v.Image:find('rbxassetid://') and v:IsDescendantOf(CoreGui) then else
                table.insert(gameTable, v.Image)
            end
        end
    end
    
    function randomizeTable(t)
        local n = #t
        while n > 0 do
            local k = math.random(n)
            t[n], t[k] = t[k], t[n]
            n = n - 1
        end
        return t
    end
    
    local ContentProviderBypass
    ContentProviderBypass = hookmetamethod(game, "__namecall", function(self, Instances, ...)
        local method = getnamecallmethod();
        local args = ...;
    
        if not checkcaller() and (method == "preloadAsync" or method == "PreloadAsync") then
            if Instances and Instances[1] and self.ClassName == "ContentProvider" then
                if Instances ~= nil then
                    if typeof(Instances[1]) == "Instance" and (table.find(Instances, CoreGui) or table.find(Instances, game)) then
                        if Instances[1] == CoreGui then
                            randomizedCoreGuiTable = randomizeTable(coreguiTable)
                            return ContentProviderBypass(self, randomizedCoreGuiTable, ...)
                        end
    
                        if Instances[1] == game then
                            randomizedGameTable = randomizeTable(gameTable)
                            return ContentProviderBypass(self, randomizedGameTable, ...)
                        end
                    end
                end
            end
        end
    
        return ContentProviderBypass(self, Instances, ...)
    end)
    
    local preloadBypass; preloadBypass = hookfunction(Content.PreloadAsync, function(a, b, c)
        if not checkcaller() then
            if typeof(a) == "Instance" and tostring(a) == "ContentProvider" and typeof(b) == "table" then
                if (table.find(b, CoreGui) or table.find(b, game)) and not (table.find(b, true) or table.find(b, false)) then
                    if b[1] == CoreGui then -- Double Check
                        randomizedCoreGuiTable = randomizeTable(coreguiTable)
                        return preloadBypass(a, randomizedCoreGuiTable, c)
                    end
                    if b[1] == game then -- Triple Check
                        randomizedGameTable = randomizeTable(gameTable)
                        return preloadBypass(a, randomizedGameTable, c)
                    end
                end
            end
        end
    
        return preloadBypass(a, b, c)
    end)
    
    --Newproxy Bypass (Stolen from Lego Hacker (V3RM))
    local TableNumbaor001 = {}
    local SomethingOld;
    SomethingOld = hookfunction(getrenv().newproxy, function(...)
        local proxy = SomethingOld(...)
        table.insert(TableNumbaor001, proxy)
        return proxy
    end)
    local RunService = cloneref(game:GetService("RunService"))
    RunService.Stepped:Connect(function()
        for i,v in pairs(TableNumbaor001) do
            if v == nil then end
        end
    end)
    --
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()
    
        if self == game.Players.LocalPlayer and Method:lower() == "kick" then
            print("fail..")
            return
        end
    
        return OldNamecall(self, ...)
    end))
    --
    local settings = settings()
    local rendering = settings:GetService("RenderSettings")
    rendering.QualityLevel = Enum.QualityLevel.Level01
    rendering.EagerBulkExecution = false
    game.Lighting.GlobalShadows = false
    setfpscap(9999)
    
    if AlwayswinExecuted then
        return
    end
    
    AlwayswinExecuted = true
    
    -- * Services
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local UserInputService  = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace         = game:GetService("Workspace")
    local TweenService      = game:GetService("TweenService")
    local Debris            = game:GetService('Debris')
    local Lighting          = game:GetService("Lighting")
    local LocalPlayer       = Players.LocalPlayer
    local Camera            = Workspace.CurrentCamera
    local Mouse             = LocalPlayer:GetMouse()
    
    -- * Variables
    local dahood_ids = {2788229376, 16033173781, 7213786345}
    local C_Desync = {["OldPosition"] = nil, ["PredictedPosition"] = nil}
    local bodyClone = game:GetObjects("rbxassetid://8246626421")[1]; bodyClone.Humanoid:Destroy(); bodyClone.Head.Face:Destroy(); bodyClone.Parent = game.Workspace; bodyClone.HumanoidRootPart.Velocity = Vector3.new(); bodyClone.HumanoidRootPart.CFrame = CFrame.new(9999,9999,9999); bodyClone.HumanoidRootPart.Transparency = 1; bodyClone.HumanoidRootPart.CanCollide = false 
    local visualizeChams = Instance.new("Highlight"); visualizeChams.Enabled = true; visualizeChams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; visualizeChams.FillColor = Color3.fromRGB(102, 60, 153); visualizeChams.OutlineColor =  Color3.fromRGB(0, 0, 0); visualizeChams.Adornee = bodyClone; visualizeChams.OutlineTransparency = 0.2; visualizeChams.FillTransparency = 0.5; visualizeChams.Parent = game.CoreGui
    
    -- * External Libraries
    local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/LionTheGreatRealFrFr/MobileLinoriaLib/main/addons/SaveManager.lua'))()
    local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/Deps/ThemeManager.lua"))()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/Deps/Library.lua"))()
    --
    local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/Deps/ESP.lua"))()
    local Crosshair = loadstring(game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/Deps/Crosshair.lua"))()
    local Rain = loadstring(game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/Deps/Rain.lua"))()
    local Skybox = loadstring(game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/Deps/Skyboxes.lua"))()
    local Drawing3D = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()
    local MainColor = Library.AccentColor;
    
    -- * Cheat
    local Settings = {
    	Combat = {
    		Enabled = false,
    		Method = "Fire Server",
    		HitPart = 'HumanoidRootPart',
    		Silent = false,
            AntiAimViewer = false,
    		LookAt = false,
    		Spectate = false,
    		Fov = 120,
    		Prediction = {
    			Enabled = false,
    			Amount = 0.135,
    			Multiplier = 1,
    			PingBased = false
    		},
    		AimAssist = {
    			Enabled = false,
    			HitPart = 'HumanoidRootPart',
    			Prediction = 0.135,
    			Sway = false,
    			Flick = false,
    			Smoothness = {
    				Enabled = false,
    				Amount = 1,
                    EasingStyle = 'Elastic',
                    EasingDirection = 'In'
    			},
    			Shake = {
    				Enabled = false,
    				Amount = 1
    			},
    		},
    		TriggerBot = {
    			Enabled = false,
    			Prediction = 0.135,
    			Mode = 'Always',
    			Method = 'Activate',
                UseDelay = false,
    			Delay = 0.04,
    			Range = 10
    		},
    		RageBot = {
    			Enabled = false,
    			Distance = 50,
    			AutoShoot = false,
    			AutoReload = false
            },
    		Checks = {
    			Enabled = false,
    			Vehicle = false,
    			Knocked = false,
    			Friend = false,
    			Wall = false,
    			ForceField = false,
    			Visible = false
    		},
    		Resolver = {
                Enabled = false,
                Smoothness = 0.5,
                JitterThreshold = 2,
                SmoothingMethod = 'KalmanFilter',
            },
    	},
    	Visuals = {
    		OnHit = {
    			Enabled = false,
    			Mark = {
    				Enabled = false,
    				Type = '2D',
    				Color = MainColor
    			},
    			Effect = {
    				Enabled = false,
    				Color = MainColor,
    				Type = 'Nova Impact',
    			},
    			Chams = {
    				Enabled = false,
    				Color = MainColor,
    				Material = Enum.Material.ForceField,
    				Duration = 1
    			},
    			Skeleton = {
    				Enabled = false,
    				Color = MainColor,
    				Duration = 1
    			},
    			Sound = {
    				Enabled = false,
    				Volume = 5,
    				Value = 'Rust'
    			},
    		},
    	},
    }
    --
    local Storage = {
        Silent = {
            Prediction = 0,
            AutoPrediction = 0
        },
    	Sounds = {
            Bubble = "rbxassetid://6534947588",
            Lazer = "rbxassetid://130791043",
            Pick = "rbxassetid://1347140027",
            Pop = "rbxassetid://198598793",
            Rust = "rbxassetid://1255040462",
            Sans = "rbxassetid://3188795283",
            Fart = "rbxassetid://130833677",
            Big = "rbxassetid://5332005053",
            Vine = "rbxassetid://5332680810",
            UwU = "rbxassetid://8679659744",
            Bruh = "rbxassetid://4578740568",
            Skeet = "rbxassetid://5633695679",
            Neverlose = "rbxassetid://6534948092",
            Fatality = "rbxassetid://6534947869",
            Bonk = "rbxassetid://5766898159",
            Minecraft = "rbxassetid://5869422451",
            Gamesense = "rbxassetid://4817809188",
            RIFK7 = "rbxassetid://9102080552",
            Bamboo = "rbxassetid://3769434519",
            Crowbar = "rbxassetid://546410481",
            Weeb = "rbxassetid://6442965016",
            Beep = "rbxassetid://8177256015",
            Bambi = "rbxassetid://8437203821",
            Stone = "rbxassetid://3581383408",
            OldFatality = "rbxassetid://6607142036",
            Click = "rbxassetid://8053704437",
            Ding = "rbxassetid://7149516994",
            Snow = "rbxassetid://6455527632",
            Laser = "rbxassetid://7837461331",
            Mario = "rbxassetid://2815207981",
            Steve = "rbxassetid://4965083997",
            CallofDuty = "rbxassetid://5952120301",
            Bat = "rbxassetid://3333907347",
            TF2Critical = "rbxassetid://296102734",
            Saber = "rbxassetid://8415678813",
            Baimware = "rbxassetid://3124331820",
            Osu = "rbxassetid://7149255551",
            TF2 = "rbxassetid://2868331684",
            Slime = "rbxassetid://6916371803",
            AmongUs = "rbxassetid://5700183626",
            One = "rbxassetid://7380502345"
        },
    	Resolver = {
            PositionHistory = {},
            TimeHistory = {},
            OldTick = os.clock(),
            OldPos = Vector3.new(0, 0, 0),
            ResolvedVelocity = Vector3.new(0, 0, 0)
        },
        HitEffect = {
        	['Nova Impact'] = nil,
            ['Crescent Slash'] = nil,
            ['Crescent Slash'] = nil,
            ['Coom'] = nil,
            ['Cosmic Explosion'] = nil,
            ['Slash'] = nil,
            ['Atomic Slash'] = nil,
        },
        ShitTalk = {
        	Alwayswin = {
        		"WHAT THE HELL IS AN AZURE 🤡🤡",
        		"Alwayswin ONTOP Alwayswin ONTOP Alwayswin ONTOP",
        		"IS THAT Alwayswin???!! | .gg/Alwayswinlua",
        		"Here is a wild Alwayswin user in its habitat | .gg/Alwayswinlua",
        		"Alwayswin >> ALL",
        		"Alwayswin ON TOP | .gg/Alwayswinlua",
        		"Alwayswin > U",
        		".gg/Alwayswinlua",
                "Owned By Alwayswin",
        		"Alwayswin Alwayswin Alwayswin RAHHHHH",
        		"Slammed by Alwayswin",
        		"YOU GOT SLAMMED BY Alwayswin",
        		"SEEMS LIKE YOU NEED Alwayswin .gg/Alwayswinlua",
        		".gg/Alwayswinlua .gg/Alwayswinlua .gg/Alwayswinlua",
        		".gg/Alwayswinlua <-- THIS WILL LET YOU COPE WITH YOUR ISSUES",
        		"WHAT YOU CANT BEAT Alwayswinlua?",
        		"PRO TIP: BUY Alwayswinlua"
        	},
        	AntiAim = {
        		"CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! CANT HIT ME?! ",
        		"Hmmm why arent u hitting me? Alwayswin too good XDDD",
        		"RESOLVER SUCCESSFULLY HIT 0 SHOTS",
        		"I think 0 prediction can hit more shots :(",
        		"Uphillian Aim???!!!!",
        		"Cmon man resolve my beanbot desync :^)",
        		"SKID DETECTED NOT RESOLVING!",
        		"Azure hits better cmon bro up the game 🤣"
        	},
        	Nerd = {
        		"im such a skid 😜",
        		"math is hard 🧮",
        		"i speak klingon 👽",
        		"i wear socks with sandals 👣",
        		"my pocket 😎 protector brings all the nerds to the yard",
        		"phd in quantum mechanics from hogwarts 🎓",
        		"im a nerd and im proud 🤓👊",
        		"i mainframe 💻 for fun",
        		"i dream in binary 💭",
        		"im fluent in c++ 💻",
        		"my code is poetry 📝"
        	},
        	Random = {
        		"sorry i hurt your roblox ego but look -> 🤏 I DON'T CARE",
        		"i 😎 hacked my toaster",
        		"i eat ones 😋 and zeros for breakfast",
        		"i hacked nasa 🚀",
        		"im a keyboard ninja ⌨️🥋",
        		"i hacked 😈 my calculator",
        		"banlands 🔨 🗻 down 🏚️ ⏬ STOP CRASHING BANLANDS!! 🤣",
        		"password is 😡 password",
        		"i can hack anything 💻🔓",
        		"i can play doom on a pregnancy test 🎮🤰😎",
        		"i can play doom on my fridge 🎮🍕",
        		"my screen 🎨 is my canvas",
        		"i'm the king 👑 of cyber",
        		"TURN YOUR HACKS OFF!!! 🥹🥹😤😡😡😡",
        		"BROO THIS IS SO UNFAIR 😭😢 TURN OFF PATHFINDING 😡💢💢💢💢💢😒🙄",
        		"TURN TELEPORT SCANNING OFF NOWWW 😡😡💢💢💢💢💢💢😭😭😭",
        		"i surf the dark web 🕸️",
        		"votekick him!!!!!!! 😠 vk VK VK VK VOTEKICK HIM!!!!!!!!! 😠 😢 VOTE KICK !!!!! PRESS Y WHY DIDNT U PRESS Y LOL!!!!!! 😭 ",
        		"YOU VOtEkickED tHe wrong PERson!!!!!!!!!",
        		"i dream in code 💭💻",
        		"i kick kittens 🐱👟",
        		"i once 😂 kicked a soccer ball",
        		"庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇",
        		"完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
        		"诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
        		"持有毁灭性的神经重景气游行脸红青铜色类别创意案",
        		"音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
        		"SETBASEWALKSPEED(999) SPEED CHEAT!!!!",
        		"i kick 🚪 doors open",
        		"i kicked a hole in space ⏰ time",
        		"i kicked my computer 💻👟",
        		"PASTE PASTE ITS PASTEEEEEDDDDDDD!!!!!!!",
        		"HAHAHAHAHAHAHA",
        		"i kicked a can down the road 🥫👟",
        		"i kickflip in my dreams 🛹💭",
        		"i kickstart my day ☕ with coffee",
        		"i kick back 🛋️ and relax",
        		"i kickstart revolutions 🔄👟",
        		"i kickflip over obstacles 🛹↗️",
        		"global🌍 warming🥵 freezing ❄️",
        		"i cooked soup 🍲 in the fridge ❄️",
        		"im a 🍦 popsicle",
        		"sweating like a ☀️ snowman in summer 😅",
        		"squirrel using 🐿️ oven mitts 🥊",
        		"cold as polar bear 🐻❄️ toenails",
        		"im hotter than the ☀️ sun 🔥",
        		"im colder than 🪐 pluto ❄️",
        		"im as cool as ice ❄️",
        		"im melting like 🧈 butter 🔥",
        		"im burning like a 🔥 furnace 💨",
        		"monkey see 🐒",
        		"monkey do 🙈",
        		"banana time 🍌",
        		"monkey business 🐵💼",
        		"monkeying around 🙊",
        		"ape escape 🦍",
        		"chimp champ 🐵🏆",
        		"gorilla warfare 🦍⚔️",
        		"jungle swing 🌴🐒",
        		"primate party 🎉🐵",
        		"ape-tastic 🦍🎉"
        	},
        	Scottish = {
        		"You Grandma Still Wears Shin Pads To Work 🤣🤣",
        		"Melon Head",
        		"Your Ma Is A Bin Man 🤣🤣",
        		"Taped You Like I Did To Your Ma",
        		"Fore Headed Mong",
        		"Such A Fruit",
        		"YoUr A BoOt",
        		"keep Trying You Jobby"
        	},
        },
        Locals = {
            Radians = 0,
            ShouldHaalfiDestroy = false,
            NetworkPreviousTick = tick(),
            NetworkShouldSleep = false,
            OriginalVelocity = {},
            Original = {},
            FFlags = {},
            AntiAimViewer = {
                MouseRemoteFound = false,
                MouseRemote = nil,
                MouseRemoteArgs = nil,
                MouseRemotePositionIndex = nil
            },
            World = {
                FogColor = Lighting.FogColor,
                FogStart = Lighting.FogStart,
                FogEnd = Lighting.FogEnd,
                Ambient = Lighting.Ambient,
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                ExposureCompensation = Lighting.ExposureCompensation,
                ColorShift_Top = Lighting.ColorShift_Top,
                ColorShift_Bottom = Lighting.ColorShift_Bottom
            },
            Guns = {
                "Revolver", "Double-Barrel SG", "High-Medium Armor", "Flamethrower", "SMG", "RPG", "P90", "LMG", "Key"
            },
            Food = {
                "Pizza", "Taco", "Chicken", "Cranberry", "Popcorn", "Hamburger", "HotDog"
            },
            Locations = {
                "Uphill", "Military", "Park", "Downhill", "Double Barrel", "Casino", "Trailer", "School", "Revolver",
                "Bank", "Sewer", "Fire Station", "Hood Fitness", "Hood Kicks", "Jail", "Church"
            },
        },
        Files = {
        	Folders = {"Alwayswin", "Alwayswin/Configs", "Alwayswin/Luas", "Alwayswin/Assets"},
    		Luas = {
    			Genshin = game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/LUAs/Genshin"),
    			ChinaHat = game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/LUAs/ChinaHat"),
    			Minecraft = game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/LUAs/Minecraft"),
    			BetterGame = game:HttpGet("https://raw.githubusercontent.com/haalfiperth/Alwayswin/refs/heads/main/LUAs/BetterGame")
    		}, 
        },
        Connections = {},
        Hooks = {},
        Drawings = {},
        Impacts = {}
    }
    --
    local SkyboxOptions = {}
    for name, _ in pairs(Skybox) do
        table.insert(SkyboxOptions, name)
    end
    --
    local ShitTalkOptions = {}
    for name, _ in pairs(Storage.ShitTalk) do
        table.insert(ShitTalkOptions, name)
    end
    --
    for i,v in pairs(Storage.Files.Folders) do
    	makefolder(v)
    end 
    -- 
    for LuaName, Contents in pairs(Storage.Files.Luas) do
    	writefile("Alwayswin/Luas/" .. LuaName .. ".lua", Contents)
    end 
    
    -- // Main Utility Functions
    do
        function Storage:Connection(ConnectionType, Function)
            local Connection = ConnectionType:Connect(Function)
            return Connection
        end
        --
        function Storage:NewDrawing(class, properties)
            local surge = Drawing.new(class)
            surge.Visible = false
            for property,value in pairs(properties) do
                surge[property] = value
            end
            return surge
        end
        --
        function Storage:NewObject(instance_type, properties)
            local instance = Instance.new(instance_type)
        
            for property,value in pairs(properties) do
                instance[property] = value
            end
        
            return instance
        end
        --
        function Storage:Gun(Name)
            for Check = 1, 100000 do
                if game.Workspace.Ignored.Shop:FindFirstChild("[" .. Name .. "] - $" .. Check) then
                    return tostring("[" .. Name .. "] - $" .. Check)
                end
            end
        end
        --
        function Storage:Ammo(Name)
            for Check1 = 1, 250 do
                for Check2 = 1, 500 do
                    if game.Workspace.Ignored.Shop:FindFirstChild(Check1 .. " [" .. Name .. " Ammo] - $" .. Check2) then
                        return tostring(Check1 .. " [" .. Name .. " Ammo] - $" .. Check2)
                    end
                end
            end
        end
        --
        function Storage:Buy(Target, Delay, LagBack, Times)
            if Times == nil then
                Times = 3
            end
            local item = game.Workspace.Ignored.Shop:FindFirstChild(Target)
            if item then
                savepos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                for i = 1, Times do
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.Head.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.5)
                    for i = 1, 10 do
                        fireclickdetector(item.ClickDetector)
                    end
                    task.wait(0.5)
                end
                if LagBack then
                    task.wait(1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savepos
                end
                if Delay ~= nil then
                    task.wait(Delay)
                end
            end
        end
        --
        function Storage:BuyGunAndAmmo(GUN, times)
            if
                game.Players.LocalPlayer.Backpack:FindFirstChild("[" .. GUN .. "]") or
                game.Players.LocalPlayer.Character:FindFirstChild("[" .. GUN .. "]")
            then
                Storage:Buy(Storage:Ammo(GUN), 0.3, true, times)
            else
                Storage:Buy(Storage:Gun(GUN), 0.5, true)
            end
        end
        --
        function Storage:Teleport(v)
            if v == "Uphill" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(482, 48, -602)
            elseif v == "Military" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(58.71923828125, 25.25499725341797, -869.0357055664062) 
            elseif v == "Park" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-268, 22, -754) 
            elseif v == "Admin" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-800, -40, -887) 
            elseif v == "Admin Guns" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-872, -33, -536) 
            elseif v == "Downhill" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-565, 8, -737) 
            elseif v == "Double Barrel" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1042, 22, -261) 
            elseif v == "Casino" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-864, 22, -143) 
            elseif v == "Trailer" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-963, -1, 469) 
            elseif v == "School" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-653, 22, 257) 
            elseif v == "Revolver" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-642, 22, -124) 
            elseif v == "Bank" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-446, 39, -286) 
            elseif v == "Sewer" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(112, -27, -277) 
            elseif v == "Fire Station" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-150, 54, -94) 
            elseif v == "Hood Fitness" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-76, 23, -638) 
            elseif v == "Hood Kicks" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-188, 22, -410) 
            elseif v == "Jail" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-299, 22, -91) 
            elseif v == "Church" then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(205, 22, -80) 
            end
        end
        --
        function Storage:Wall(player)
            local amount = Camera:GetPartsObscuringTarget({LocalPlayer.Character.HumanoidRootPart.Position,player.Character.HumanoidRootPart.Position},{LocalPlayer.Character,player.Character})
            return #amount ~= 0
        end
        --
        function Storage:GetTool() 
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then 
                return LocalPlayer.Character:FindFirstChildWhichIsA("Tool") 
            end 
        end 
        --
        function Storage:GetClosestCenter(huh)
            local Target, Closest = nil, huh
        
            for _, v in pairs(Players:GetPlayers()) do
                if ( (v['Character'] and v ~= LocalPlayer and v['Character']:FindFirstChild('HumanoidRootPart')) ) then
                    --
                    if Settings.Combat.Checks.Enabled and (
                        Settings.Combat.Checks.Vehicle and v.Character:FindFirstChild("[CarHitBox]") ~= nil or
                        Settings.Combat.Checks.Knocked and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health < 4 or
                        Settings.Combat.Checks.Friend and v:IsFriendsWith(LocalPlayer.UserId) or
                        Settings.Combat.Checks.Wall and Storage:Wall(v) or
                        Settings.Combat.Checks.Forcefield and v.Character:FindFirstChildOfClass("ForceField") or
                        Settings.Combat.Checks.Visible and v.Character:FindFirstChild("Head") and v.Character.Head.Transparency > 0.5
                    ) then continue end
                    --
                    local Position, OnScreen = Camera:WorldToScreenPoint(v['Character']['HumanoidRootPart'].Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - (Workspace.CurrentCamera.ViewportSize * 0.5)).Magnitude
        
                    if ( (Distance < Closest and OnScreen) ) then
                        Closest = Distance
                        Target = v
                    end
                end
            end
            return Target or false
        end
        --
        function Storage:GetClosestToMouse()
            local Target, Closest = nil, Settings.Combat.Silent and Settings.Combat.Fov or math.huge
        
            for _, v in pairs(Players:GetPlayers()) do
                if ( (v['Character'] and v ~= LocalPlayer and v['Character']:FindFirstChild('HumanoidRootPart')) ) then
                    --
                    if Settings.Combat.Checks.Enabled and (
                        Settings.Combat.Checks.Vehicle and v.Character:FindFirstChild("[CarHitBox]") ~= nil or
                        Settings.Combat.Checks.Knocked and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health < 4 or
                        Settings.Combat.Checks.Friend and v:IsFriendsWith(LocalPlayer.UserId) or
                        Settings.Combat.Checks.Wall and Storage:Wall(v) or
                        Settings.Combat.Checks.Forcefield and v.Character:FindFirstChildOfClass("ForceField") or
                        Settings.Combat.Checks.Visible and v.Character:FindFirstChild("Head") and v.Character.Head.Transparency > 0.5
                    ) then continue end
                    --
                    local Position, OnScreen = Camera:WorldToScreenPoint(v['Character']['HumanoidRootPart'].Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        
                    if ( (Distance < Closest and OnScreen) ) then
                        Closest = Distance
                        Target = v
                    end
                end
            end
            return Target or false
        end
        --
        function Storage:GetClosestToCharacter(origin,radius)
            local minDistance = radius
            local nearestTarget = nil
            
            for _,target in pairs(Players:GetPlayers()) do
                if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                    local RootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                    if RootPart then
                        --
                        if Settings.Combat.Checks.Enabled and (
                            Settings.Combat.Checks.Vehicle and v.Character:FindFirstChild("[CarHitBox]") ~= nil or
                            Settings.Combat.Checks.Knocked and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health < 4 or
                            Settings.Combat.Checks.Friend and v:IsFriendsWith(LocalPlayer.UserId) or
                            Settings.Combat.Checks.Wall and Storage:Wall(v) or
                            Settings.Combat.Checks.Forcefield and v.Character:FindFirstChildOfClass("ForceField") or
                            Settings.Combat.Checks.Visible and v.Character:FindFirstChild("Head") and v.Character.Head.Transparency > 0.5
                        ) then continue end
                        --
                        local distance = (target.Character.HumanoidRootPart.Position-origin).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            nearestTarget = target
                        end
                    end
                end
            end
        
            return nearestTarget
        end
        
        -- // Math Functions
        function Storage:CalculateOffset(origin, target)
            local actual_origin = origin * CFrame.new(0, -0.25, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0);
            return actual_origin:ToObjectSpace(target):inverse();
        end
        --
        function Storage:Resolve()
            if Settings.Combat.Enabled and Settings.Combat.Resolver.Enabled and Target and Target.Character then
        
                local function Lerp(A,B,T) return A*(1-T)+B*T end
        
                local HumanoidRootPart = Target.Character:FindFirstChild("HumanoidRootPart")
                if not HumanoidRootPart then return end
        
                Storage.Resolver.PositionHistory = Storage.Resolver.PositionHistory or {}
                Storage.Resolver.TimeHistory = Storage.Resolver.TimeHistory or {}
                Storage.Resolver.ResolvedVelocity = Storage.Resolver.ResolvedVelocity or Vector3.zero
                Storage.Resolver.Kalman = Storage.Resolver.Kalman or {P=1,Q=0.02,R=0.1}
        
                local CurrentTime = os.clock()
                local CurrentPosition = HumanoidRootPart.Position
        
                table.insert(Storage.Resolver.PositionHistory,CurrentPosition)
                table.insert(Storage.Resolver.TimeHistory,CurrentTime)
        
                if #Storage.Resolver.PositionHistory > 50 then
                    table.remove(Storage.Resolver.PositionHistory,1)
                    table.remove(Storage.Resolver.TimeHistory,1)
                end
        
                local PreviousPosition = Storage.Resolver.PositionHistory[#Storage.Resolver.PositionHistory-1] or CurrentPosition
                local PreviousTime = Storage.Resolver.TimeHistory[#Storage.Resolver.TimeHistory-1] or CurrentTime
        
                local DeltaTime = math.max(CurrentTime - PreviousTime,1e-6)
        
                local RawVelocity = (CurrentPosition - PreviousPosition) / DeltaTime
        
                -- 
                local PositionDelta = (CurrentPosition - PreviousPosition).Magnitude
                if PositionDelta > Settings.Combat.Resolver.JitterThreshold then
                    CurrentPosition = PreviousPosition + RawVelocity * DeltaTime
                end
        
                local SmoothingMethod = Settings.Combat.Resolver.SmoothingMethod or "Lerp"
                local Smoothness = math.clamp(Settings.Combat.Resolver.Smoothness or 0.5,0.01,1)
        
                local function ApplySmoothing(Previous,Raw,T)
                    local SmoothedValue
        
                    if SmoothingMethod == "Lerp" then
                        SmoothedValue = Lerp(Previous,Raw,T)
        
                    elseif SmoothingMethod == "Exponential" then
                        SmoothedValue = Previous + (Raw - Previous) * (1 - math.exp(-T * 5))
        
                    elseif SmoothingMethod == "MovingAverage" then
                        local Sum = Vector3.zero
                        local Count = math.min(#Storage.Resolver.PositionHistory,10)
                        for I = 1,Count do
                            Sum = Sum + (Storage.Resolver.PositionHistory[#Storage.Resolver.PositionHistory-I] or Vector3.zero)
                        end
                        SmoothedValue = Sum / Count
        
                    elseif SmoothingMethod == "MedianFilter" then
                        local Sorted = {}
                        for I = math.max(1,#Storage.Resolver.PositionHistory-5),#Storage.Resolver.PositionHistory do
                            table.insert(Sorted,Storage.Resolver.PositionHistory[I])
                        end
                        table.sort(Sorted,function(A,B) return A.Magnitude < B.Magnitude end)
                        SmoothedValue = Sorted[math.ceil(#Sorted / 2)] or Raw
        
                    elseif SmoothingMethod == "KalmanFilter" then
                        local K = Storage.Resolver.Kalman.P / (Storage.Resolver.Kalman.P + Storage.Resolver.Kalman.R)
                        SmoothedValue = Previous + K * (Raw - Previous)
                        Storage.Resolver.Kalman.P = (1 - K) * Storage.Resolver.Kalman.P + Storage.Resolver.Kalman.Q
        
                    elseif SmoothingMethod == "WeightedAverage" then
                        SmoothedValue = (Previous * 0.7 + Raw * 0.3)
        
                    elseif SmoothingMethod == "Adaptive" then
                        local AdaptiveT = math.clamp((Raw - Previous).Magnitude * 0.05,0.05,0.5)
                        SmoothedValue = Lerp(Previous,Raw,AdaptiveT)
        
                    elseif SmoothingMethod == "Momentum" then
                        SmoothedValue = Previous * 0.85 + Raw * 0.15
        
                    elseif SmoothingMethod == "Cosine" then
                        SmoothedValue = Previous + (Raw - Previous) * (0.5 - 0.5 * math.cos(T * math.pi))
        
                    elseif SmoothingMethod == "ExponentialDecay" then
                        SmoothedValue = Previous * math.exp(-T * 0.5) + Raw * (1 - math.exp(-T * 0.5))
        
                    else
                        SmoothedValue = Raw
                    end
        
                    return SmoothedValue
                end
        
                Storage.Resolver.ResolvedVelocity = ApplySmoothing(Storage.Resolver.ResolvedVelocity,RawVelocity,Smoothness)
        
                if Storage.Resolver.ResolvedVelocity.Magnitude < 1e-4 then
                    Storage.Resolver.ResolvedVelocity = RawVelocity
                end
        
                Storage.Resolver.OldPos = CurrentPosition
                Storage.Resolver.OldTick = CurrentTime
            end
        end
        --
        function Storage:RandomVector3(randomization)
            return Vector3.new(math.random(-randomization, randomization), math.random(-randomization, randomization), math.random(-randomization, randomization))
        end
        
        -- // Combat Functions
        function Storage:GetAimAssistPredictedPosition()
            if not Settings.Combat.AimAssist.Enabled or not Target or not Target.Character then return end
        
            local Character = Target.Character
            if not Character:FindFirstChild("Humanoid") or not Character.Humanoid.RootPart then return end
        
            local Position = Workspace.CurrentCamera:WorldToScreenPoint(Character.Humanoid.RootPart.Position)
            local Distance = (Vector2.new(Position.X,Position.Y) - Camera.ViewportSize * 0.5).Magnitude
            local Shake = Vector3.new(0,0,0)
            --
            if Settings.Combat.Checks.Enabled and (
                Settings.Combat.Checks.Vehicle and Character:FindFirstChild("[CarHitBox]") ~= nil or
                Settings.Combat.Checks.Knocked and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health < 4 or
                Settings.Combat.Checks.Friend and Target:IsFriendsWith(LocalPlayer.UserId) or
                Settings.Combat.Checks.Wall and Storage:Wall(Target) or
                Settings.Combat.Checks.Forcefield and Character:FindFirstChildOfClass("ForceField") or
                Settings.Combat.Checks.Visible and Character:FindFirstChild("Head") and Character.Head.Transparency > 0.5
            ) then return end
            --
            AimAssistAimPoint = Character.HumanoidRootPart.Position + Shake + Character.HumanoidRootPart.Velocity * Settings.Combat.AimAssist.Prediction
            --
            if Settings.Combat.AimAssist.Shake.Enabled  then
                Shake = Vector3.new(
                    math.random(-Settings.Combat.AimAssist.Shake.Amount,Settings.Combat.AimAssist.Shake.Amount),
                    math.random(-Settings.Combat.AimAssist.Shake.Amount,Settings.Combat.AimAssist.Shake.Amount),
                    math.random(-Settings.Combat.AimAssist.Shake.Amount,Settings.Combat.AimAssist.Shake.Amount)
                ) * 0.1
            end
            --
            local Main = CFrame.new(Workspace.CurrentCamera.CFrame.p,AimAssistAimPoint)
            local SmoothAmount = Settings.Combat.AimAssist.Smoothness.Enabled and Settings.Combat.AimAssist.Smoothness.Amount or 1
        
            Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame:Lerp(
                Main,
                SmoothAmount,
                Enum.EasingStyle[Settings.Combat.AimAssist.Smoothness.EasingStyle],
                Enum.EasingDirection[Settings.Combat.AimAssist.Smoothness.EasingDirection]
            )
        end
        
        function Storage:GetTargetAimPredictedPosition()
            local HumanoidRootPart = Target.Character.FindFirstChild("HumanoidRootPart")
            local Hit = HumanoidRootPart.CFrame
            local PlayerVelocity = Settings.Combat.Resolver.Enabled and (Storage.Resolver.ResolvedVelocity + Target.Character.Humanoid.MoveDirection * Target.Character.Humanoid.MoveDirection) or HumanoidRootPart.Velocity
            local PredictionOffset = Vector3.new(PlayerVelocity.X * Storage.Silent.Prediction, PlayerVelocity.Y * Storage.Silent.Prediction, PlayerVelocity.Z * Storage.Silent.Prediction)
            local PredictedPosition = Hit + (PredictionOffset * Vector3.new(Settings.Combat.Prediction.Multiplier, Settings.Combat.Prediction.Multiplier, Settings.Combat.Prediction.Multiplier))
            --
            return PredictedPosition
        end
        --
        function Storage:GetTriggerBotPredictedPosition()
            local TriggerBotTarget = Storage:GetClosestCenter(Settings.Combat.TriggerBot.Range)
            if TriggerBotTarget and Settings.Combat.TriggerBot.Enabled then
                local hrp = TriggerBotTarget.Character and TriggerBotTarget.Character:FindFirstChild("HumanoidRootPart")
                local playerTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            
                if hrp and playerTool then
                    local toolName = playerTool.Name
                    local validTool = toolName ~= "[Knife]" and toolName ~= "Wallet" and toolName ~= "Lock Tool"
            
                    if validTool then
                        local aimPos = hrp.Position + hrp.Velocity * Settings.Combat.TriggerBot.Prediction
                        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPos)
            
                        if onScreen then
                            local mousePos = Camera.ViewportSize * 0.5
                            local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).magnitude
            
                            if distance <= Settings.Combat.TriggerBot.Range then
                                if Settings.Combat.TriggerBot.UseDelay then
                                    task.delay(Settings.Combat.TriggerBot.Delay, function()
                                        if Settings.Combat.TriggerBot.Method == 'Activate' then
                                            playerTool:Activate()
                                        else
                                            mouse1click()
                                        end
                                    end)
                                else
                                    if Settings.Combat.TriggerBot.Method == 'Activate' then
                                        playerTool:Activate()
                                    else
                                        mouse1click()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- // Visuals Functions
        function Storage:Clone(Player)
            if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.Archivable = true
                local Cloned = Player.Character:Clone()
                Cloned.Name = "Player Clone"
        
                local BodyParts = {
                    "Head", "UpperTorso", "LowerTorso",
                    "LeftUpperArm", "LeftLowerArm", "LeftHand",
                    "RightUpperArm", "RightLowerArm", "RightHand",
                    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                    "RightUpperLeg", "RightLowerLeg", "RightFoot"
                }
        
                for _, Part in ipairs(Cloned:GetChildren()) do
                    if Part:IsA("BasePart") then
                        local PartValid = false
                        for _, validPart in ipairs(BodyParts) do
                            if Part.Name == validPart then
                                PartValid = true
                                break
                            end
                        end
                        
                        if not PartValid then
                            Part:Destroy()
                        end
                    elseif Part:IsA("Accessory") or Part:IsA("Tool") or Part.Name == "face" or Part:IsA("Shirt") or Part:IsA("Pants") or Part:IsA("Hat") then
                        Part:Destroy()
                    end
                end
        
                if Cloned:FindFirstChild("Humanoid") then
                    Cloned.Humanoid:Destroy()
                end
        
                for _, BodyPart in ipairs(Cloned:GetChildren()) do
                    if BodyPart:IsA("BasePart") then
                        BodyPart.CanCollide = false
                        BodyPart.Anchored = true
                        BodyPart.Transparency = 0.5
                        BodyPart.Color = MainColor
                        BodyPart.Material = Enum.Material.Neon
                    end
                end
        
                if Cloned:FindFirstChild("Head") then
                    local Head = Cloned.Head
                    Head.Transparency = 0.5
                    Head.Color = MainColor
                    Head.Material = Enum.Material.Neon
        
                    if Head:FindFirstChild("face") then
                        Head.face:Destroy()
                    end
                end
        
                Cloned.Parent = game.Workspace
        
                local tweenInfo = TweenInfo.new(
                    2,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    0,
                    true
                )
        
                for _, BodyPart in ipairs(Cloned:GetChildren()) do
                    if BodyPart:IsA("BasePart") then
                        local tween = TweenService:Create(BodyPart, tweenInfo, { Transparency = 1 })
                        tween:Play()
                    end
                end
        
                task.delay(2, function()
                    if Cloned and Cloned.Parent then
                        Cloned:Destroy()
                    end
                end)
            end
        end
        --
        function Storage:Effect(Part, Color)
            local Clone = Storage.HitEffect[Settings.Visuals.OnHit.Effect.Type]:Clone()
            Clone.Parent = Part
        
            for _, Effect in pairs(Clone:GetChildren()) do
                if Effect:IsA('ParticleEmitter') then
                    Effect.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
                        ColorSequenceKeypoint.new(0.495, MainColor),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
                    })
                    Effect:Emit()
                end
            end
        
            task.delay(2,function()
                Clone:Destroy()
            end)
        end
        
        function Storage:CreateBeam(from,to,color_1,color_2,duration,fade_enabled,fade_duration)
            local tween;
            local total_time = 0;
        
            local main_part = Storage:NewObject("Part",{
                Parent = Workspace,
                Size = Vector3.new(0,0,0),
                Massless = true,
                Transparency = 1,
                CanCollide = false,
                Position = from,
                Anchored = true
            });
        
            local part0 = Storage:NewObject("Part",{
                Parent = main_part,
                Size = Vector3.new(0,0,0),
                Massless = true,
                Transparency = 1,
                CanCollide = false,
                Position = from,
                Anchored = true
            });
        
            local part1 = Storage:NewObject("Part",{
                Parent = main_part,
                Size = Vector3.new(0,0,0),
                Massless = true,
                Transparency = 1,
                CanCollide = false,
                Position = to,
                Anchored = true
            });
        
            local attachment0 = Storage:NewObject("Attachment",{
                Parent = part0
            });
        
            local attachment1 = Storage:NewObject("Attachment",{
                Parent = part1
            });
        
            local beam = Storage:NewObject("Beam",{
                Texture = "rbxassetid://446111271",
                TextureMode = Enum.TextureMode.Wrap,
                TextureLength = 10,
                LightEmission = 1,
                LightInfluence = 1,
                FaceCamera = true,
                ZOffset = -1,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0,0),
                    NumberSequenceKeypoint.new(1,1),
                }),
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,color_1),
                    ColorSequenceKeypoint.new(1,color_2),
                }),
                Attachment0 = attachment0,
                Attachment1 = attachment1,
                Enabled = true,
                Parent = main_part
            });
        
            if fade_enabled then
                tween = Storage:Connection(RunService.Heartbeat,function(delta_time)
                    total_time += delta_time;
                    beam.Transparency = NumberSequence.new(TweenService:GetValue((total_time/fade_duration),Enum.EasingStyle.Quad,Enum.EasingDirection.In));
                end)
            end;
        
            task.delay(duration,function()
                main_part:Destroy();
        
                if tween then
                    tween:Disconnect();
                end;
            end);
        end;
        
        function Storage:CreateDrawingBeam(v1,v2)
            local line = Drawing.new("Line")
            line.Visible = true
            line.Color = Settings.Visuals.BulletTracers.Color
            line.Thickness = 5
        
            local function UpdateLine()
                local startPos = Workspace.CurrentCamera:WorldToViewportPoint(v1)
                local endPos = Workspace.CurrentCamera:WorldToViewportPoint(v2)
                local isVisible = startPos.Z > 0 and endPos.Z > 0
                if isVisible then
                    line.From = Vector2.new(startPos.X,startPos.Y)
                    line.To = Vector2.new(endPos.X,endPos.Y)
                else
                    line.Visible = false
                end
            end
        
            local startTime = tick()
            local connection
            connection = Storage:Connection(RunService.RenderStepped,function()
                UpdateLine()
        
                local elapsedTime = tick() - startTime
                if elapsedTime >= Settings.Visuals.BulletTracers.Duration then
                    connection:Disconnect()
                    line:Remove()
                else
                    local alpha = 1 - (elapsedTime/Settings.Visuals.BulletTracers.Duration)
                    line.Transparency = alpha
                end
            end)
        end;
        
        function Storage:CreateImpact(color,size,fade_enabled,fade_duration,duration,position)
            local impact = Storage:NewObject("Part",{
                CanCollide = false;
                Material = Enum.Material.Neon;
                Size = Vector3.new(size,size,size);
                Color = color;
                Position = position;
                Anchored = true;
                Parent = Workspace
            });
        
            local outline = Storage:NewObject("SelectionBox",{ 
                LineThickness = 0.01;
                Color3 = color;
                SurfaceTransparency = 1;
                Adornee = impact;
                Visible = true;
                Parent = impact
            });
        
            if fade_enabled then
                local tween_info = TweenInfo.new(duration);
                local tween = TweenService:Create(impact,tween_info,{Transparency = 1});
                local tween_outline = TweenService:Create(outline,tween_info,{Transparency = 1});
        
                tween:Play();
                tween_outline:Play();
            end;
        
            task.delay(duration,function()
                impact:Destroy()		
            end);
        end;
        --
        function Storage:CreateDrawingImpact(position)
            local impactInfo = { Position = position, Lines = {} }
        
            local vertices = {
                Vector3.new(1, 1, 1), Vector3.new(1, -1, 1), Vector3.new(-1, -1, 1), Vector3.new(-1, 1, 1),
                Vector3.new(1, 1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, -1, -1), Vector3.new(-1, 1, -1)
            }
        
            local edges = {
                {1, 2}, {2, 3}, {3, 4}, {4, 1},
                {5, 6}, {6, 7}, {7, 8}, {8, 5},
                {1, 5}, {2, 6}, {3, 7}, {4, 8}
            }
        
            for i, edge in ipairs(edges) do
                local line = Drawing.new("Line")
                line.Visible = true
                line.Color = Settings.Visuals.BulletImpacts.Color
                impactInfo.Lines[i] = line
            end
        
            local function UpdateBox()
                local worldVertices = {}
                for i, vertex in ipairs(vertices) do
                    worldVertices[i] = Camera:WorldToViewportPoint(position + vertex * Settings.Visuals.BulletImpacts.Size)
                end
        
                for i, edge in ipairs(edges) do
                    local p1, p2 = worldVertices[edge[1]], worldVertices[edge[2]]
                    if p1.Z > 0 and p2.Z > 0 then
                        impactInfo.Lines[i].From = Vector2.new(p1.X, p1.Y)
                        impactInfo.Lines[i].To = Vector2.new(p2.X, p2.Y)
                        impactInfo.Lines[i].Visible = true
                    else
                        impactInfo.Lines[i].Visible = false
                    end
                end
            end
        
            local startTime = os.clock()
            local connection
            connection = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
                UpdateBox()
                local elapsedTime = os.clock() - startTime
                if elapsedTime >= Settings.Visuals.BulletImpacts.Duration then
                    connection:Disconnect()
                    for _, line in ipairs(impactInfo.Lines) do
                        line:Remove()
                    end
                    for i, data in ipairs(Storage.Impacts) do
                        if data == impactInfo then
                            table.remove(Storage.Impacts, i)
                            break
                        end
                    end
                else
                    local alpha = 1 - (elapsedTime / Settings.Visuals.BulletImpacts.Duration)
                    for _, line in ipairs(impactInfo.Lines) do
                        line.Transparency = alpha
                    end
                end
            end))
        
            table.insert(Storage.Impacts, impactInfo)
        end
        --
        Storage.Drawings[1] = Storage:NewDrawing("Circle", {
            Filled = true,
            Thickness = 1,
            Color = Color3.fromRGB(255,255,255),
            Radius = 8,
            ZIndex = 3,
        })
        --
        Storage.Drawings[2] = Storage:NewDrawing("Line", {
            Thickness = 2,
            Color = Color3.fromRGB(255,255,255)
        })
        --
        Storage.Drawings[3] = Instance.new("Highlight")
        --
        Storage.Drawings[4] = Drawing3D:New3DCircle()
        Storage.Drawings[4].Visible = false
        Storage.Drawings[4].Filled = true
        Storage.Drawings[4].ZIndex = 1
        Storage.Drawings[4].Transparency = 1
        Storage.Drawings[4].Color = MainColor
        Storage.Drawings[4].Thickness = 1
        Storage.Drawings[4].Radius = 2
        Storage.Drawings[4].Rotation = Vector2.new(2, 0)
        --
        Storage.Drawings[5] = Drawing3D:New3DCube()
        Storage.Drawings[5].Visible = false
        Storage.Drawings[5].ZIndex = 5
        Storage.Drawings[5].Thickness = 1
        Storage.Drawings[5].Filled = false
        Storage.Drawings[5].Size = Vector3.new(1.5,3.5,1.5)
        --
        Storage.Drawings[6] = Drawing3D:New3DCircle()
        --
        Storage.Drawings[7] = Instance.new("Highlight")
        --
        Storage.Drawings[8] = Drawing3D:New3DLine(); Storage.Drawings[8].Visible = false; Storage.Drawings[8].Color = Color3.new(255, 255, 255); Storage.Drawings[8].Thickness = 1;
        --
        Storage.Drawings[9] = Instance.new("Part")
        Storage.Drawings[9].Name = "Actryn skid noob";
        Storage.Drawings[9].Parent = game.Workspace;
        Storage.Drawings[9].Size = LocalPlayer.Character.Humanoid.RootPart.Size;
        Storage.Drawings[9].CanCollide = false; 
        Storage.Drawings[9].Anchored = true; 
        Storage.Drawings[9].Transparency = 1; 
        --
        for i,v in pairs(bodyClone:GetDescendants()) do 
    		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then 
    			v.CanCollide = false 
    			v.Transparency = 0
    		end 
    	end 
    end
    --
    Storage:Connection(RunService.Heartbeat, function()
        Storage:GetTriggerBotPredictedPosition()
        Storage:GetAimAssistPredictedPosition()
        Storage:Resolve()
        --
        if Settings.Combat.Silent and Settings.Combat.RageBot.Enabled == false then
            Target = Storage:GetClosestCenter(Settings.Combat.Silent and Settings.Combat.Fov or math.huge)
        elseif Settings.Combat.RageBot.Enabled then
            Target = Storage:GetClosestToCharacter(LocalPlayer.Character.HumanoidRootPart.Position, Settings.Combat.RageBot.Distance)
        end
        --
        if Settings.Combat.LookAt and Target and Storage:GetTargetAimPredictedPosition().Position then
            LocalPlayer.Character.Humanoid.AutoRotate = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position, Vector3.new(Storage:GetTargetAimPredictedPosition().Position.X, Storage:GetTargetAimPredictedPosition().Position.Y, Storage:GetTargetAimPredictedPosition().Position.Z))
        else
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end        
        --
        if Settings.Combat.Spectate and Target and Target.Character.Humanoid then
           Camera.CameraSubject = Target.Character.Humanoid
        else
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
        --
        if Target and Target.Character and Settings.Combat.RageBot.Enabled then
            local Gun = Storage:GetTool()
            if Gun then
                if Settings.Combat.RageBot.AutoShoot then
                    Gun:Activate()
                end
                --
                if Settings.Combat.RageBot.AutoReload and Gun and Gun.Ammo.Value == 0 then
                    Storage.Locals.AntiAimViewer.MouseRemote:FireServer("Reload",Gun)
                end
            end
        end
        --
        if Settings.Combat.Prediction.PingBased then
            Storage.Silent.Prediction = Storage.Silent.AutoPrediction
        else
            Storage.Silent.Prediction = Settings.Combat.Prediction.Amount
        end
        --
        if Settings.Combat.Prediction.PingBased then
            local ping = tonumber(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():split(".")[1])
            if ping < 10 then
                Storage.Silent.AutoPrediction = 0.09
            elseif ping < 20 then
                Storage.Silent.AutoPrediction = 0.12588
            elseif ping < 30 then
                Storage.Silent.AutoPrediction = 0.11252476
            elseif ping < 40 then
                Storage.Silent.AutoPrediction = 0.125
            elseif ping < 50 then
                Storage.Silent.AutoPrediction = 0.13544
            elseif ping < 65 then
                Storage.Silent.AutoPrediction = 0.1264236
            elseif ping < 70 then
                Storage.Silent.AutoPrediction = 0.12533
            elseif ping < 80 then
                Storage.Silent.AutoPrediction = 0.139340
            elseif ping < 100 then
                Storage.Silent.AutoPrediction = 0.141987
            elseif ping < 110 then
                Storage.Silent.AutoPrediction = 0.1455
            elseif ping < 120 then
                Storage.Silent.AutoPrediction = 0.143765
            elseif ping < 130 then
                Storage.Silent.AutoPrediction = 0.156692
            elseif ping < 140 then
                Storage.Silent.AutoPrediction = 0.1223333
            elseif ping < 150 then
                Storage.Silent.AutoPrediction = 0.15
            elseif ping < 160 then
                Storage.Silent.AutoPrediction = 0.16
            elseif ping < 170 then
                Storage.Silent.AutoPrediction = 0.1923111
            elseif ping < 180 then
                Storage.Silent.AutoPrediction = 0.19284
            elseif ping < 190 then
                Storage.Silent.AutoPrediction = 0.166547
            elseif ping < 200 then
                Storage.Silent.AutoPrediction = 0.165566
            elseif ping < 210 then
                Storage.Silent.AutoPrediction = 0.16780
            elseif ping < 220 then
                Storage.Silent.AutoPrediction = 0.165566
            elseif ping < 230 then
                Storage.Silent.AutoPrediction = 0.15692
            elseif ping < 240 then
                Storage.Silent.AutoPrediction = 0.16780
            elseif ping < 250 then
                Storage.Silent.AutoPrediction = 0.1651
            elseif ping < 260 then
                Storage.Silent.AutoPrediction = 0.175566
            elseif ping < 270 then
                Storage.Silent.AutoPrediction = 0.195566
            elseif ping < 360 then
                Storage.Silent.AutoPrediction = 0.16537
            end
        end
        --
        if Settings.Combat.Method == "Index" then
            local LocalFramework = LocalPlayer.PlayerGui:WaitForChild("Framework", 1e9)
    
            if LocalFramework then
                local FrameworkEnvironment = getsenv(LocalFramework)
    
                if FrameworkEnvironment._G and FrameworkEnvironment._G.MOUSE_POSITION then
                    if Target then
                        FrameworkEnvironment._G.MOUSE_POSITION = Storage:GetTargetAimPredictedPosition().Position
                    end
                end
            end
        end        
    end)
    
    Storage.Hooks[1] = hookmetamethod(LocalPlayer:GetMouse(), '__index', function(self,index)
        if ( (index == 'Hit' ) and Settings.Combat.Enabled and Target ~= nil and Settings.Combat.Method == "Spoof Mouse" ) then
            local position = Storage:GetTargetAimPredictedPosition()
            return position
        end
        return Storage.Hooks[1](self,index)
    end)    
    
    Storage.Hooks[2] = hookmetamethod(game,"__namecall",newcclosure(function(Self,...)
        local args, method = {...}, tostring(getnamecallmethod())
        
        if not checkcaller() and method == "FireServer" then
            for i,arg in pairs(args) do
                if typeof(arg) == "Vector3" then
                    Storage.Locals.AntiAimViewer.MouseRemote = Self
                    Storage.Locals.AntiAimViewer.MouseRemoteFound = true
                    Storage.Locals.AntiAimViewer.MouseRemoteArgs = args
                    Storage.Locals.AntiAimViewer.MouseRemotePositionIndex = i
                    
                    if Target and Settings.Combat.Method == "Fire Server" and not Settings.Combat.AntiAimViewer then
                        args[i] = Storage:GetTargetAimPredictedPosition().Position
                    end
                    return Storage.Hooks[2](Self,unpack(args))
                elseif type(arg) == "table" then
                    for index,element in ipairs(arg) do
                        if typeof(element) == "Vector3" then
                            if Target and Settings.Combat.Method == "Fire Server" and not Settings.Combat.AntiAimViewer then
                                arg[index] = Storage:GetTargetAimPredictedPosition().Position
                            end
                        end
                    end
                end
            end
            return Storage.Hooks[2](Self,unpack(args))
        end
        
        return Storage.Hooks[2](Self,...)
    end))    

    local ScreenGui = Instance.new("ScreenGui")
    local ImageButton = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    local UiStroke = Instance.new("UIStroke")
    
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    ImageButton.Parent = ScreenGui
    ImageButton.BackgroundColor3 = Color3.fromRGB(61, 61, 61)
    ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0.86219734, 0, 0.21682848, 0)
    ImageButton.Size = UDim2.new(0.108007446, 0, 0.168284789, 0)
    ImageButton.Image = "rbxassetid://96075093188795"
    ImageButton.Draggable = true
    
    UICorner.CornerRadius = UDim.new(0, 27)
    UICorner.Parent = ImageButton
    
    UiStroke.Parent = ImageButton
    UiStroke.Color = MainColor
    UiStroke.Thickness = 1
    
    UIAspectRatioConstraint.Parent = ImageButton
    UIAspectRatioConstraint.AspectRatio = 1.115
    
    ImageButton.MouseButton1Down:Connect(function()
        Library:Toggle()
    end)
    
    -- * Library
    do
        local Status = game.Players.LocalPlayer.Name == "haalfiperth" and "Developer" or "Buyers"
        
        local Window = Library:CreateWindow({
            Title = 'Alwayswin.lua - [' .. Status .. ' Build]',
            Center = true,
            AutoShow = true,
            TabPadding = 8,
            MenuFadeTime = 0.2
        })
        
        local Tabs = {
            Combat = Window:AddTab("Combat"),
            Visuals = Window:AddTab("Visuals"),
            Misc = Window:AddTab("Misc"),
            Settings = Window:AddTab("Settings")
        }
        
        -- // Combat Tab
        do
            -- // Aim Assist And Target Aim Tab
            do
                local TabBox = Tabs.Combat:AddLeftTabbox()
                local TargetAim = TabBox:AddTab('Target Aim')
                TargetAim:AddToggle("TargetAimEnabled", {
                    Text = "Enabled",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.Enabled = state
                     end
                }):AddKeyPicker("TargetAimToggle", {
                    Default = "Q",
                    SyncToggleState = false,
                    Mode = "Toggle",
                    Text = "Targetting",
                    NoUI = false,
                    Callback = function()
                        if Settings.Combat.Enabled and Settings.Combat.RageBot.Enabled == false then
                            if not Target then
                                Target = Storage:GetClosestToMouse()
                                Library:Notify('Target: ' .. tostring(Target))
                            else
                                Target = nil
                                Library:Notify('Unlocked')
                            end
                        end
                    end
                })
                --
                TargetAim:AddToggle("SilentAimMode", {
                    Text = "Silent",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.Silent = state
                     end
                })
                --
                TargetAim:AddButton("Load Button", function()
                    if ButtonAlreadyLoaded then
                        Library:Notify("Already Loaded.", 5)
                        return
                    end
                    ButtonAlreadyLoaded = true
                    
                    do
                        local ScreenGui = Instance.new("ScreenGui")
                        local Frame = Instance.new("Frame")
                        local TextButton = Instance.new("ImageButton")
                        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
                    
                        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                        ScreenGui.ResetOnSpawn = false
                        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    
                        Frame.Parent = ScreenGui
                        Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                        Frame.BackgroundTransparency = 0.5
                        Frame.Position = UDim2.new(1,-96,0,-32)
                        Frame.Size = UDim2.new(0,90,0,90)
                        Frame.Draggable = true
                    
                        TextButton.Parent = Frame
                        TextButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
                        TextButton.BackgroundTransparency = 1
                        TextButton.Size = UDim2.new(0,75,0,75)
                        TextButton.AnchorPoint = Vector2.new(0.5,0.5)
                        TextButton.Position = UDim2.new(0.5,0,0.5,0)
                        TextButton.Image = "rbxassetid://121985415800493"
                    
                        local UICorner = Instance.new("UICorner",Frame)
                        UICorner.CornerRadius = UDim.new(0,8)
                    
                        TextButton.MouseButton1Down:Connect(function()
                            if Settings.Combat.Enabled and Settings.Combat.RageBot.Enabled == false then
                                if not Target then
                                    Target = Storage:GetClosestCenter(Settings.Combat.Silent and Settings.Combat.Fov or math.huge)
                                    Library:Notify('Target: ' .. tostring(Target))
                                else
                                    Target = nil
                                    Library:Notify('Unlocked')
                                end
                            end
                    
                            TextButton.Image = Target and "rbxassetid://74008192086426" or "rbxassetid://121985415800493"
                        end)
                    
                        UITextSizeConstraint.Parent = TextButton
                        UITextSizeConstraint.MaxTextSize = 30
                    
                        local inputService = game:GetService("UserInputService")
                        function makeDraggable(frame)
                            local dragging, dragInput, startPos, startFramePos
                            local function update(input)
                                local delta = input.Position - startPos
                                frame.Position = UDim2.new(startFramePos.X.Scale, startFramePos.X.Offset + delta.X, startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y)
                            end
                            frame.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                    dragging = true
                                    startPos = input.Position
                                    startFramePos = frame.Position
                                    input.Changed:Connect(function()
                                        if input.UserInputState == Enum.UserInputState.End then
                                            dragging = false
                                        end
                                    end)
                                end
                            end)
                            frame.InputChanged:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                                    dragInput = input
                                end
                            end)
                            inputService.InputChanged:Connect(function(input)
                                if input == dragInput and dragging then
                                    update(input)
                                end
                            end)
                        end
                        makeDraggable(Frame)
                    end
                end)
                --
                TargetAim:AddButton("Load Tool", function()
                    if ToolAlreadyLoaded then
                        Library:Notify("Already Loaded.", 5)
                        return
                    end
                    ToolAlreadyLoaded = true
                    local Tool = Instance.new("Tool")
                    Tool.RequiresHandle = false
                    Tool.Name = "Lock Tool"
                    Tool.Parent = game.Players.LocalPlayer.Backpack
                    
                    local player = game.Players.LocalPlayer
                    
                    local function connectCharacterAdded()
                        player.CharacterAdded:Connect(onCharacterAdded)
                    end
                    
                    connectCharacterAdded()
                    
                    player.CharacterRemoving:Connect(function()
                         Tool.Parent = game.Players.LocalPlayer.Backpack
                     end)
                     
                     Tool.Activated:Connect(function()
                        if Settings.Combat.Enabled and Settings.Combat.RageBot.Enabled == false then
                            if not Target then
                                Target = Storage:GetClosestToMouse()
                                Library:Notify('Target: ' .. tostring(Target))
                            else
                                Target = nil
                                Library:Notify('Unlocked')
                             end
                         end
                     end)
                end)
                --
                TargetAim:AddDropdown("TargetAimBypassingMethod", {
                    Values = {"Fire Server", "Spoof Mouse", "Index"},
                    Default = Settings.Combat.Method,
                    Multi = false,
                    Text = "Aiming Method",
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Method = state
                    end
                })
                --
                TargetAim:AddToggle("TargetAimLookAt", {
                    Text = "Look At",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.LookAt = state
                     end
                })
                --
                TargetAim:AddToggle("TargetAimSpectate", {
                    Text = "Spectate",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.Spectate = state
                     end
                })
                --
                TargetAim:AddInput("TargetAimPredictionAmount", {
                    Default = Settings.Combat.Prediction.Amount,
                    Numeric = false,
                    Finished = false,
                    Text = "Amount",
                    Tooltip = nil,
                    Placeholder = "no",
                    Callback = function(state)
                        Settings.Combat.Prediction.Amount = state
                    end
                })
                --
                TargetAim:AddInput("TargetAimPredictionMultiplier", {
                    Default = Settings.Combat.Prediction.Multiplier,
                    Numeric = false,
                    Finished = false,
                    Text = "Multiplier",
                    Tooltip = nil,
                    Placeholder = "no",
                    Callback = function(state)
                        Settings.Combat.Prediction.Multiplier = state
                    end
                })
                --
                TargetAim:AddToggle("TargetAimPingBased", {
                    Text = "Ping Based",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.Prediction.PingBased = state
                     end
                })
                --
                TargetAim:AddSlider("TargetAimFieldOfView", {
                    Text = "Field Of View",
                    Default = 80,
                    Min = 1,
                    Max = 100,
                    Rounding = 2,
                    Compact = false,
                    Callback = function(state)
                        Settings.Combat.Fov = state
                    end
                })
                --
                local AimAssist = TabBox:AddTab('Aim Assist')
                AimAssist:AddToggle("AimAssistEnabled", {
                    Text = "Enabled",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.AimAssist.Enabled = state
                     end
                })
                --
                AimAssist:AddInput("AimAssistPredictionAmount", {
                    Default = Settings.Combat.AimAssist.Prediction,
                    Numeric = false,
                    Finished = false,
                    Text = "Prediction",
                    Tooltip = nil,
                    Placeholder = "no",
                    Callback = function(state)
                        Settings.Combat.AimAssist.Prediction = state
                    end
                })
                --
                AimAssist:AddToggle("AimAssistSway", {
                    Text = "Sway",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.AimAssist.Sway = state
                     end
                })
                --
                AimAssist:AddToggle("AimAssistAutoFlick", {
                    Text = "Auto Flick",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.AimAssist.AutoFlick = state
                     end
                })
                --
                AimAssist:AddToggle("AimAssistSmoothness", {
                    Text = "Smoothness",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.AimAssist.Smoothness.Enabled = state
                     end
                })
                --
                local Smoothness = AimAssist:AddDependencyBox();
                --
                Smoothness:AddInput("AimAssistSmoothnessAmount", {
                    Default = Settings.Combat.AimAssist.Smoothness.Amount,
                    Numeric = false,
                    Finished = false,
                    Text = "Amount",
                    Tooltip = nil,
                    Placeholder = "no",
                    Callback = function(state)
                        Settings.Combat.AimAssist.Smoothness.Amount = state
                    end
                })
                --
                Smoothness:AddDropdown("AimAssistSmoothnessStyle", {
                    Values = {"Linear","Sine","Back","Quad","Quart","Quint","Bounce","Elastic","Exponential","Circular","Cubic"},
                    Default = Settings.Combat.AimAssist.Smoothness.EasingStyle,
                    Multi = false,
                    Text = "Easing Style",
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.AimAssist.Smoothness.EasingStyle = state
                    end
                })
                --
                Smoothness:AddDropdown("AimAssistSmoothnessDirection", {
                    Values = {"In", "Out", "InOut"},
                    Default = Settings.Combat.AimAssist.Smoothness.EasingDirection,
                    Multi = false,
                    Text = "Easing Direction",
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.AimAssist.Smoothness.EasingDirection = state
                    end
                })
                --
                Smoothness:SetupDependencies({
                    { Toggles["AimAssistSmoothness"], true } -- We can also pass `false` if we only want our features to show when the toggle is off!
                });
                --
                AimAssist:AddToggle("AimAssistShake", {
                    Text = "Shake",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.AimAssist.Shake.Enabled = state
                     end
                })
                --
                local Shake = AimAssist:AddDependencyBox();
                --
                Shake:AddSlider("AimAssistShakeAmount", {
                    Text = "Amount",
                    Default = Settings.Combat.AimAssist.Shake.Amount,
                    Min = 1,
                    Max = 50,
                    Rounding = 1,
                    Callback = function(state)
                        Settings.Combat.AimAssist.Shake.Amount = state
                    end
                })
                --
                Shake:SetupDependencies({
                    { Toggles["AimAssistShake"], true } -- We can also pass `false` if we only want our features to show when the toggle is off!
                });
                --
            end
            
            -- // TriggerBot and RageBot Tab
            do
                local TabBox = Tabs.Combat:AddRightTabbox()
                local RageBot = TabBox:AddTab('Rage Bot')
                RageBot:AddToggle("RageBotEnabled", {
                    Text = "Enabled",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.RageBot.Enabled = state
                     end
                })
                --
                RageBot:AddSlider("RageBotDistanceAmount", {
                    Text = "Distance",
                    Default = Settings.Combat.RageBot.Distance,
                    Min = 1,
                    Max = 50,
                    Rounding = 1,
                    Callback = function(v)
                        Settings.Combat.TriggerBot.Distance = v
                    end
                })
                --
                RageBot:AddToggle("RageBotAutoShoot", {
                    Text = "Auto Shoot",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.RageBot.AutoShoot = state
                     end
                })
                --
                RageBot:AddToggle("RageBotAutoReload", {
                    Text = "Auto Reload",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.RageBot.AutoReload = state
                     end
                })
                --
                local TriggerBot = TabBox:AddTab('Trigger Bot')
                TriggerBot:AddToggle("TrigerBotEnabled", {
                    Text = "Enabled",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.TriggerBot.Enabled = state
                     end
                })
                --
                TriggerBot:AddDropdown("TriggerBotMethod", {
                    Values = {'Activate', 'Mouse'},
                    Default = Settings.Combat.TriggerBot.Method,
                    Multi = false,
                    Text = "Method",
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.TriggerBot.Method = state
                    end
                })
                --
                TriggerBot:AddInput("TriggerBotPredictionAmount", {
                    Default = Settings.Combat.TriggerBot.Prediction,
                    Numeric = false,
                    Finished = false,
                    Text = "Prediction",
                    Tooltip = nil,
                    Placeholder = "no",
                    Callback = function(state)
                        Settings.Combat.TriggerBot.Prediction = state
                    end
                })
                --
                TriggerBot:AddToggle("TriggerBotUseDelay", {
                    Text = "Use Delay",
                    Default = Settings.Combat.TriggerBot.UseDelay,
                    Tooltip = nil,
                    Callback = function(W)
                        Settings.Combat.TriggerBot.UseDelay = W
                    end
                })
                --
                TriggerBot:AddSlider("TriggerBotDelayAmount", {
                    Text = "Delay",
                    Default = Settings.Combat.TriggerBot.Delay,
                    Min = 0.01,
                    Max = 1,
                    Rounding = 1,
                    Callback = function(v)
                        Settings.Combat.TriggerBot.Delay = v
                    end
                })
                --
                TriggerBot:AddSlider("TriggerBotRangeAmount", {
                    Text = "Range",
                    Default = Settings.Combat.TriggerBot.Range,
                    Min = 1,
                    Max = 50,
                    Rounding = 1,
                    Callback = function(v)
                        Settings.Combat.TriggerBot.Range = v
                    end
                })
            end
            
            -- // Hood Custom Shits...
            if game.PlaceId == 9825515356 then
                local Hc = Tabs.Combat:AddRightGroupbox("Hood Custom")
                
                local ForceHit = false
                local RapidFire = false
                local RapidFireAuto = true
                local RapidFireDelay = 0.05
                local GunModule = {
                    Enabled = false,
                    MaxAmmo = 60000,
                    CurrentAmmo = 50000,
                    AutoRefill = true
                }
                
                function shoot(targetHumanoidRootPart)
                    local currentPosition = targetHumanoidRootPart.Position
                    local shootDirection = targetHumanoidRootPart.CFrame.LookVector
                    local shootPosition = currentPosition + shootDirection * 10 
                    local normal = shootDirection.unit 
                    local offset = normal * 0.5
                
                    local args = {
                        [1] = "Shoot",
                        [2] = {
                            [1] = {
                                [1] = {
                                    ["Instance"] = targetHumanoidRootPart,
                                    ["Normal"] = normal,
                                    ["Position"] = currentPosition 
                                }
                            },
                            [2] = {
                                [1] = {
                                    ["thePart"] = targetHumanoidRootPart,
                                    ["theOffset"] = CFrame.new(offset) 
                                }
                            },
                            [3] = shootPosition, 
                            [4] = currentPosition,
                            [5] = os.clock() 
                        }
                    }
                    game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
                end
                
                Hc:AddToggle('ForceHitEnabled', {
                    Text = 'Force Hit',
                    Default = ForceHit,
                    Callback = function(value)
                        ForceHit = value
                        if ForceHit then
                            if Target and Target.Character then
                                local targetHumanoidRootPart = Target.Character.HumanoidRootPart
                                if targetHumanoidRootPart then
                                    shoot(targetHumanoidRootPart)
                                end
                            end
                            else
                        end
                    end
                })
                
                Hc:AddToggle('GunModuleEnabled', {
                    Text = 'Gun Modifier',
                    Default = GunModule.Enabled,
                    Callback = function(value) GunModule.Enabled = value end
                })
                
                local GunModuleCFG = Hc:AddDependencyBox();
                
                GunModuleCFG:AddInput('MaxAmmo', {
                    Default = GunModule.MaxAmmo,
                    Text = 'Max Ammo',
                    Callback = function(value) GunModule.MaxAmmo = tonumber(value) or 60000 end
                })
                
                GunModuleCFG:AddInput('CurrentAmmo', {
                    Default = GunModule.CurrentAmmo,
                    Text = 'Current Ammo',
                    Callback = function(value) GunModule.CurrentAmmo = tonumber(value) or 50000 end
                })
                
                GunModuleCFG:AddToggle('AutoRefill', {
                    Text = 'Auto Refill',
                    Default = GunModule.AutoRefill,
                    Callback = function(value) GunModule.AutoRefill = value end
                })
                
                GunModuleCFG:SetupDependencies({
                    { Toggles.GunModuleEnabled, true }
                });
                
                function ModifyGun(Tool)
                    if not GunModule.Enabled or not Tool:IsA("Tool") then return end
                    
                    local Script = Tool:WaitForChild("Script",2)
                    if not Script then return end
                    
                    local MaxAmmo = Script:FindFirstChild("MaxAmmo")
                    local Ammo = Script:FindFirstChild("Ammo")
                    
                    if MaxAmmo then 
                        MaxAmmo.Value = GunModule.MaxAmmo
                    end
                    
                    if Ammo then
                        Ammo.Value = GunModule.CurrentAmmo
                        
                        if GunModule.AutoRefill then
                            Ammo:GetPropertyChangedSignal("Value"):Connect(function()
                                Ammo.Value = GunModule.CurrentAmmo
                            end)
                        end
                    end
                end
                
                function HandleTool(Tool)
                    if GunModule.Enabled then
                        ModifyGun(Tool)
                    end
                end
                
                game.Players.LocalPlayer.Backpack.ChildAdded:Connect(HandleTool)
                
                Hc:AddToggle('FireRate', {
                    Text = 'Rapid Fire',
                    Default = false,
                    Tooltip = 'PP.',
        
                    Callback = function(Value)
                        RapidFire = Value
                    end
                })
                local FireRateCFG = Hc:AddDependencyBox();
                FireRateCFG:AddToggle('AutoFire', {
                    Text = 'Automatic',
                    Default = true,
                    Tooltip = 'PP.',
        
                    Callback = function(Value)
                        RapidFireAuto = Value
                    end
                })
                FireRateCFG:AddInput('FireRateCooldown', {
                    Default = '0.05',
                    Numeric = true,
                    Finished = true,
                    Text = 'Cooldown',
                    Tooltip = 'Cooldown Shit',
                    Placeholder = 'no',
        
                    Callback = function(Value)
                        RapidFireDelay = tonumber(Value)
                    end
                })
                FireRateCFG:SetupDependencies({
                    { Toggles.FireRate, true }
                });
                
                Storage:Connection(RunService.Heartbeat,function()
                    if RapidFire then
                        for _,item in pairs(LocalPlayer.Backpack:GetChildren()) do
                            local gunDataModule = item:FindFirstChild("GunData")
                            if gunDataModule and gunDataModule:IsA("ModuleScript") then
                                local gunData = require(gunDataModule)
                                if gunData.cooldown and gunData.slowdown_time then
                                    gunData.cooldown = RapidFireDelay
                                    gunData.is_automatic = RapidFireAuto
                                    gunData.slowdown_time = RapidFireDelay
                                end
                            end
                        end
                        task.wait(0)
                    end
                end)
            end
            
            -- // Da Hood Shits...
            if table.find(dahood_ids, game.PlaceId) then
                local KillAura = false
                local RapidFire = false
                local HyperFire = false
                local ModifiedTools = {}
                local HitboxExpander = {
                    Enabled = false,
                    HitPart = "HumanoidRootPart",
                    Size = 10,
                    Visualize = {
                        Enabled = false,
                        Color = MainColor
                    }
                }
                
                local DaHood = Tabs.Combat:AddRightGroupbox("Da Hood")
                
                local function rapidfire(tool)
                    if not tool or not tool:FindFirstChild("GunScript") or ModifiedTools[tool] then return end
                
                    for _, v in ipairs(getconnections(tool.Activated)) do
                        local funcinfo = debug.getinfo(v.Function)
                        for i = 1, funcinfo.nups do
                            local c, n = debug.getupvalue(v.Function, i)
                            if type(c) == "number" then
                                debug.setupvalue(v.Function, i, 0.0000000000001)
                            end
                        end
                    end
                
                    ModifiedTools[tool] = true
                end
                
                local function onCharacterAdded(character)
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            rapidfire(tool)
                        end
                    end
                
                    character.ChildAdded:Connect(function(child)
                        if child:IsA("Tool") and child:FindFirstChild("Handle") then
                            rapidfire(child)
                        end
                    end)
                end
                
                if LocalPlayer.Character then
                    onCharacterAdded(LocalPlayer.Character)
                end
                
                LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
                
                DaHood:AddToggle("RapidFireToggle", {
                    Text = "Rapid Fire",
                    Default = false,
                    Callback = function(Value)
                        RapidFire = Value
                        if Value then
                            ModifiedTools = {}
                            if LocalPlayer.Character then
                                onCharacterAdded(LocalPlayer.Character)
                            end
                        end
                    end
                })
                
                local function updateHyperFire()
                    for _, obj in ipairs(game:GetDescendants()) do
                        if obj.Name == "ToleranceCooldown" and obj:IsA("ValueBase") then
                            obj.Value = 0
                        end
                    end
                end
                
                DaHood:AddToggle("HyperFireToggle", {
                    Text = "Hyper Fire",
                    Default = false,
                    Callback = function(Value)
                        HyperFire = Value
                        updateHyperFire()
                    end
                })
                
                game.DescendantAdded:Connect(function(obj)
                    if obj.Name == "ToleranceCooldown" and obj:IsA("ValueBase") then
                        obj.Value = HyperFire and 0 or 3
                    end
                end)
                
                RunService.RenderStepped:Connect(function()
                    if HyperFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        local character = LocalPlayer.Character
                        if character then
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool and tool:FindFirstChild("Ammo") then
                                tool:Activate()
                            end
                        end
                    end
                end)
                
                DaHood:AddToggle("HitboxExpanderToggle", {
                    Text = "Hitbox Expander",
                    Default = false,
                    Callback = function(state)
                        HitboxExpander.Enabled = state
                        if not state then
                            for _, Player in pairs(Players:GetPlayers()) do
                                if Player ~= LocalPlayer and Player.Character then
                                    resetCharacter(Player.Character)
                                end
                            end
                        end
                    end,
                })
                
                DaHood:AddSlider("HitboxSizeSlider", {
                    Text = "Hitbox Size",
                    Default = 10,
                    Min = 10,
                    Max = 50,
                    Rounding = 0,
                    Callback = function(value)
                        HitboxExpander.Size = value
                    end,
                })
                
                DaHood:AddToggle("VisualizerToggle", {
                    Text = "Visualize",
                    Default = false,
                    Callback = function(state)
                        HitboxExpander.Visualize.Enabled = state
                        if not state then
                            for _, Player in pairs(Players:GetPlayers()) do
                                if Player ~= LocalPlayer and Player.Character then
                                    removeVisuals(Player.Character)
                                end
                            end
                        end
                    end,
                }):AddColorPicker("HitboxColorPicker", {
                    Text = "Hitbox Color",
                    Default = MainColor,
                    Callback = function(color)
                        HitboxExpander.Visualize.Color = color
                    end,
                })
                
                local function removeVisuals(Character)
                    if not Character then return end
                    local HRP = Character:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        local outline = HRP:FindFirstChild("HitboxOutline")
                        if outline then outline:Destroy() end
                        local glow = HRP:FindFirstChild("HitboxGlow")
                        if glow then glow:Destroy() end
                    end
                end
                
                local function resetCharacter(Character)
                    if not Character then return end
                    local HRP = Character:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        HRP.Size = Vector3.new(2, 1, 2)
                        HRP.Transparency = 1
                        HRP.CanCollide = true
                        removeVisuals(Character)
                    end
                end
                
                local function handleCharacter(Character)
                    if not Character or not HitboxExpander.Enabled then
                        resetCharacter(Character)
                        return
                    end
                    local HRP = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 5)
                    if not HRP then return end
                
                    HRP.Size = Vector3.new(HitboxExpander.Size, HitboxExpander.Size, HitboxExpander.Size)
                    HRP.Transparency = 1
                    HRP.CanCollide = false
                
                    if HitboxExpander.Visualize.Enabled then
                        local outline = HRP:FindFirstChild("HitboxOutline")
                        if not outline then
                            outline = Instance.new("BoxHandleAdornment")
                            outline.Name = "HitboxOutline"
                            outline.Adornee = HRP
                            outline.Size = HRP.Size
                            outline.Transparency = 0.8
                            outline.ZIndex = 10
                            outline.AlwaysOnTop = true
                            outline.Color3 = HitboxExpander.Visualize.Color
                            outline.Parent = HRP
                
                            local glow = Instance.new("BoxHandleAdornment")
                            glow.Name = "HitboxGlow"
                            glow.Adornee = HRP
                            glow.Size = HRP.Size + Vector3.new(0.1, 0.1, 0.1)
                            glow.Transparency = 0.9
                            glow.ZIndex = 9
                            glow.AlwaysOnTop = true
                            glow.Color3 = HitboxExpander.Visualize.Color
                            glow.Parent = HRP
                        else
                            outline.Size = HRP.Size
                            outline.Color3 = HitboxExpander.Visualize.Color
                            local glow = HRP:FindFirstChild("HitboxGlow")
                            if glow then
                                glow.Size = HRP.Size + Vector3.new(0.1, 0.1, 0.1)
                                glow.Color3 = HitboxExpander.Visualize.Color
                            end
                        end
                    else
                        removeVisuals(Character)
                    end
                end
                
                local function handlePlayer(Player)
                    if Player == LocalPlayer then return end
                    Player.CharacterAdded:Connect(function(Character)
                        Character:WaitForChild("HumanoidRootPart")
                        handleCharacter(Character)
                    end)
                    if Player.Character then
                        handleCharacter(Player.Character)
                    end
                end
                
                for _, Player in pairs(Players:GetPlayers()) do
                    handlePlayer(Player)
                end
                
                Players.PlayerAdded:Connect(handlePlayer)
                
                RunService.Heartbeat:Connect(function()
                    if not HitboxExpander.Enabled then
                        for _, Player in pairs(Players:GetPlayers()) do
                            if Player ~= LocalPlayer and Player.Character then
                                resetCharacter(Player.Character)
                            end
                        end
                        return
                    end
                    for _, Player in pairs(Players:GetPlayers()) do
                        if Player ~= LocalPlayer and Player.Character then
                            handleCharacter(Player.Character)
                        end
                    end
                end)
                
                DaHood:AddToggle('KillAura', {
                    Text = 'Kill Aura',
                    Default = false,
                    Callback = function(state)
                        KillAura = state
                        if KillAura then
                            game:GetService("RunService"):BindToRenderStep("Killaura", 100, function()
                                for i = 1, #game:GetService("Players"):GetPlayers() do
                                    local player = game:GetService("Players"):GetPlayers()[i]
                                    if player ~= game.Players.LocalPlayer and player.Character then
                                        local character = player.Character
                                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                                        local bodyEffects = character:FindFirstChild("BodyEffects")
                                        if humanoidRootPart and bodyEffects then
                                            local ko = bodyEffects:FindFirstChild("K.O")
                                            if ko and ko.Value == false then
                                                local localCharacter = game.Players.LocalPlayer.Character
                                                if localCharacter then
                                                    local localHumanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
                                                    if localHumanoidRootPart and (humanoidRootPart.Position - localHumanoidRootPart.Position).Magnitude <= 100 then
                                                        local head = character:FindFirstChild("Head")
                                                        if head then
                                                            local tool = localCharacter:FindFirstChildOfClass("Tool")
                                                            if tool and tool:FindFirstChild("Handle") then
                                                                local targetPart = head
                                                                local targetVelocity = targetPart.Velocity
                                                                local predictedPosition = targetPart.Position + targetVelocity * 0.2
                        
                                                                game:GetService("ReplicatedStorage").MainEvent:FireServer(
                                                                    "ShootGun",
                                                                    tool.Handle,
                                                                    localHumanoidRootPart.Position - Vector3.new(0, 10, 0),
                                                                    predictedPosition - Vector3.new(0, 25, 0),
                                                                    targetPart,
                                                                    (predictedPosition - localHumanoidRootPart.Position).unit
                                                                )
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        else
                            game:GetService("RunService"):UnbindFromRenderStep("Killaura")
                        end
                    end
                })
                
                DaHood:AddDivider()
                
                local SelectedTarget = nil
                local PlayerList = {}
                local groupIDs = {10604500, 17215700}
                local autoKillEnabled = false
                local orbitStompEnabled = false
                local lastPosition = nil
                local strafeEnabled = false
                local AutoAmmoEnabled = false
                local oldPosition = nil
                local invisiblePart = nil
                local isActionRunning = false
                
                function updatePlayerList()
                    PlayerList = {}
                    for _, player in ipairs(Players:GetPlayers()) do
                        table.insert(PlayerList, player.Name)
                    end
                    if TargetDropdown then
                        TargetDropdown:SetValues(PlayerList)
                    end
                end
                
                updatePlayerList()
                
                Players.PlayerAdded:Connect(updatePlayerList)
                Players.PlayerRemoving:Connect(updatePlayerList)
                
                function knockTarget(targetPlayer)
                    local character = targetPlayer.Character
                    local humanoid = character:FindFirstChild("Humanoid")
                    local bodyEffects = character:FindFirstChild("BodyEffects")
                    
                    if not bodyEffects or not humanoid then
                        warn("BodyEffects or Humanoid not found in the character!")
                        return
                    end
                    
                    local koValue = bodyEffects:WaitForChild("K.O", 5)
                    if not koValue then
                        warn("K.O value not found!")
                        return
                    end
                    
                    local oldPosition = LocalPlayer.Character.HumanoidRootPart.Position
                    
                    task.spawn(function()
                        while not koValue.Value and isActionRunning do
                            local targetPosition = character.HumanoidRootPart.Position
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))
                            
                            local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                            if tool and tool:FindFirstChild("Ammo") then
                                ReplicatedStorage.MainEvent:FireServer("ShootGun", tool:FindFirstChild("Handle"), tool:FindFirstChild("Handle").CFrame.Position, character.Head.Position, character.Head, Vector3.new(0, 0, -1))
                            end
                            
                            task.wait()
                        end
                        
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldPosition)
                    end)
                end
                
                
                function bringTarget(targetPlayer)
                    character = targetPlayer.Character
                    if not character then return end
                    
                    humanoid = character:FindFirstChild("Humanoid")
                    bodyEffects = character:FindFirstChild("BodyEffects")
                    if not bodyEffects or not humanoid then return end
                    
                    koValue = bodyEffects:FindFirstChild("K.O")
                    if not koValue then return end
                
                    localCharacter = LocalPlayer.Character
                    if not localCharacter then return end
                
                    humanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then return end
                    
                    oldPosition = humanoidRootPart.Position
                    isActionRunning = true
                
                    task.spawn(function()
                        while not koValue.Value and isActionRunning do
                            targetPosition = character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or nil
                            if targetPosition then
                                humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))
                            end
                            
                            tool = localCharacter:FindFirstChildWhichIsA("Tool")
                            if tool and tool:FindFirstChild("Ammo") then
                                game:GetService("ReplicatedStorage").MainEvent:FireServer(
                                    "ShootGun",
                                    tool:FindFirstChild("Handle"),
                                    tool:FindFirstChild("Handle").CFrame.Position,
                                    character.Head.Position,
                                    character.Head,
                                    Vector3.new(0, 0, -1)
                                )
                            end
                
                            task.wait()
                        end
                        
                        repeat
                            if koValue.Value then
                                isActionRunning = false
                                humanoidRootPart.CFrame = CFrame.new(oldPosition)
                                return
                            end
                
                            upperTorso = character:FindFirstChild("UpperTorso")
                            if upperTorso then
                                humanoidRootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                                game:GetService("RunService").RenderStepped:Wait()
                            end
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("Grabbing", false)
                            task.wait(0.1)
                        until character:FindFirstChild("GRABBING_CONSTRAINT")
                        task.wait(0.2)
                
                        humanoidRootPart.CFrame = CFrame.new(oldPosition)
                    end)
                end
                
                function stompTarget(targetPlayer)
                    character = targetPlayer.Character
                    humanoid = character:FindFirstChild("Humanoid")
                    bodyEffects = character:FindFirstChild("BodyEffects")
                    
                    if not bodyEffects or not humanoid then
                        warn("BodyEffects or Humanoid not found in the character!")
                        return
                    end
                    
                    koValue = bodyEffects:WaitForChild("K.O", 5)
                    sDeathValue = bodyEffects:WaitForChild("SDeath", 5)
                    if not koValue or not sDeathValue then
                        warn("K.O or SDeath value not found!")
                        return
                    end
                    
                    oldPosition = LocalPlayer.Character.HumanoidRootPart.Position
                    
                    task.spawn(function()
                        while not koValue.Value and isActionRunning do
                            targetPosition = character.HumanoidRootPart.Position
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))
                            
                            tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                            if tool and tool:FindFirstChild("Ammo") then
                                ReplicatedStorage.MainEvent:FireServer("ShootGun", tool:FindFirstChild("Handle"), tool:FindFirstChild("Handle").CFrame.Position, character.Head.Position, character.Head, Vector3.new(0, 0, -1))
                            end
                            
                            task.wait()
                        end
                        
                        while not sDeathValue.Value and isActionRunning do
                            upperTorso = character:FindFirstChild("UpperTorso")
                            if upperTorso then
                                humanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                                humanoidRootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                                RunService.RenderStepped:Wait()
                            end
                            ReplicatedStorage.MainEvent:FireServer("Stomp")
                            task.wait()
                        end
                        
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldPosition)
                    end)
                end
                
                function voidTarget(targetPlayer)
                    character = targetPlayer.Character
                    if not character then return end
                    
                    humanoid = character:FindFirstChild("Humanoid")
                    bodyEffects = character:FindFirstChild("BodyEffects")
                    if not bodyEffects or not humanoid then return end
                    
                    koValue = bodyEffects:FindFirstChild("K.O")
                    if not koValue then return end
                
                    localCharacter = LocalPlayer.Character
                    if not localCharacter then return end
                
                    humanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then return end
                    
                    oldPosition = humanoidRootPart.Position
                    isActionRunning = true
                
                    task.spawn(function()
                        while not koValue.Value and isActionRunning do
                            targetPosition = character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or nil
                            if targetPosition then
                                humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))
                            end
                            
                            tool = localCharacter:FindFirstChildWhichIsA("Tool")
                            if tool and tool:FindFirstChild("Ammo") then
                                game:GetService("ReplicatedStorage").MainEvent:FireServer(
                                    "ShootGun",
                                    tool:FindFirstChild("Handle"),
                                    tool:FindFirstChild("Handle").CFrame.Position,
                                    character.Head.Position,
                                    character.Head,
                                    Vector3.new(0, 0, -1)
                                )
                            end
                
                            task.wait()
                        end
                        
                        repeat
                            upperTorso = character:FindFirstChild("UpperTorso")
                            if upperTorso then
                                humanoidRootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                                game:GetService("RunService").RenderStepped:Wait()
                            end
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("Grabbing", false)
                            task.wait(0.2)
                        until character:FindFirstChild("GRABBING_CONSTRAINT")
                
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1000, 10000, -1000)
                        task.wait(0.3)
                        game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("Grabbing", false)
                        task.wait(0.2)
                        humanoidRootPart.CFrame = CFrame.new(oldPosition)
                    end)
                end
                
                function stopAllActions()
                    isActionRunning = false
                    if oldPosition then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldPosition)
                    end
                    Library:Notify("All actions stopped.", 5)
                end
                
                Services = {
                    Players = game:GetService("Players"),
                    LocalPlayer = game:GetService("Players").LocalPlayer
                }
                
                TargetDropdown = DaHood:AddDropdown('yepyep', {
                    SpecialType = 'Player',
                    Text = 'Select a Player',
                    Tooltip = 'Select a player to perform actions on.',
                    Callback = function(value)
                        SelectedTarget = value
                    end,
                })
                
                DaHood:AddInput('playerSearch', {
                    Text = 'Search Player',
                    Tooltip = 'Type to search for a player.',
                    Callback = function(value)
                        local matches = {}
                        value = string.lower(value)
                
                        for _, player in ipairs(Services.Players:GetPlayers()) do
                            local playerName = string.lower(player.Name)
                            local displayName = string.lower(player.DisplayName)
                
                            if string.find(playerName, value) or string.find(displayName, value) then
                                table.insert(matches, player.Name)
                            end
                        end
                
                        options.yepyep:SetValue(matches)
                
                        if #matches == 1 then
                            Options.myPlayerDropdown:SetValue(matches[1])
                            SelectedTarget = matches[1]
                        end
                    end,
                })
                
                DaHood:AddToggle('view', {
                    Text = 'View',
                    Default = false,
                    Callback = function(state)
                        if state and SelectedTarget then
                            local targetPlayer = Services.Players:FindFirstChild(SelectedTarget)
                            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                                workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
                            end
                        else
                            workspace.CurrentCamera.CameraSubject = Services.LocalPlayer.Character.Humanoid
                        end
                    end,
                })
                
                DaHood:AddButton('Teleport', function()
                    local targetPlayer = Services.Players:FindFirstChild(SelectedTarget)
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        Services.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    end
                end)
                
                DaHood:AddDropdown('actionType', {
                    Values = { 'Knock', 'Bring', 'Stomp', 'Void' },
                    Default = 'Knock',
                    Multi = false,
                    Text = 'action',
                    Callback = function(value)
                        SelectedAction = value
                    end,
                })
                
                DaHood:AddButton('Execute Action', function()
                    local targetPlayer = Players:FindFirstChild(SelectedTarget)
                    if targetPlayer and targetPlayer.Character then
                        local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                        if tool and tool:FindFirstChild("Ammo") then
                            isActionRunning = true
                            oldPosition = LocalPlayer.Character.HumanoidRootPart.Position
                            
                            if SelectedAction == "Knock" then
                                knockTarget(targetPlayer)
                            elseif SelectedAction == "Bring" then
                                bringTarget(targetPlayer)
                            elseif SelectedAction == "Stomp" then
                                stompTarget(targetPlayer)
                            elseif SelectedAction == "Void" then
                                voidTarget(targetPlayer)
                            end
                        else
                            Library:Notify("Equip a tool to use this function.", 5)
                        end
                    end
                end)
                
                DaHood:AddToggle("AutoKill", {
                    Text = "Auto Kill",
                    Default = false,
                    Callback = function(State)
                        autoKillEnabled = State
                        while autoKillEnabled and SelectedTarget do
                            local targetPlayer = Players:FindFirstChild(SelectedTarget)
                            if targetPlayer and targetPlayer.Character then
                                stompTarget(targetPlayer)
                            end
                            task.wait()
                        end
                    end
                })
                
                DaHood:AddButton('Stop', function()
                    stopAllActions()
                end)
                
                DaHood:AddDivider()
                
                local ShopFolder = Workspace:WaitForChild("Ignored"):WaitForChild("Shop")
                local OriginalPosition = nil
                local KillAllEnabled = false
                local StompAllEnabled = false
                local CurrentTarget = nil
                
                BuyItem = function(itemName)
                    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = LocalPlayer.Backpack
                        end
                    end
                
                    for _, item in pairs(ShopFolder:GetChildren()) do
                        if item.Name == itemName then
                            local itemHead = item:FindFirstChild("Head")
                            if itemHead then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = itemHead.CFrame + Vector3.new(0, 3.2, 0)
                                task.wait(0.1) 
                                fireclickdetector(item:FindFirstChild("ClickDetector"))
                            end
                            break
                        end
                    end
                end
                
                EquipLMG = function()
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool.Name == "[LMG]" then
                            tool.Parent = LocalPlayer.Character
                            return tool
                        end
                    end
                    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                        if tool.Name == "[LMG]" then
                            return tool
                        end
                    end
                    return nil
                end
                
                ShootPlayer = function(target, tool)
                    if not tool:FindFirstChild("Handle") then return end
                    local targetHead = target.Character:FindFirstChild("Head")
                    if not targetHead then return end
                    ReplicatedStorage.MainEvent:FireServer("ShootGun", tool.Handle, tool.Handle.CFrame.Position, targetHead.Position, targetHead, Vector3.new(0, 0, -1))
                end
                
                IsKnockedOut = function(target)
                    local bodyEffects = target.Character:FindFirstChild("BodyEffects")
                    if not bodyEffects then return false end
                    local koValue = bodyEffects:FindFirstChild("K.O")
                    return koValue and koValue.Value
                end
                
                HasForcefield = function(target)
                    return target.Character and target.Character:FindFirstChild("ForceField")
                end
                
                IsGrabbing = function(target)
                    return target.Character and target.Character:FindFirstChild("GRABBING_CONSTRAINT")
                end
                
                IsTooFar = function(target)
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                    return distance > 10000
                end
                
                KillAllPlayers = function()
                    OriginalPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
                    
                    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = LocalPlayer.Backpack
                        end
                    end
                
                    while not (LocalPlayer.Backpack:FindFirstChild("[LMG]") or LocalPlayer.Character:FindFirstChild("[LMG]")) do
                        BuyItem("[LMG] - $4098")
                        task.wait(0.2) 
                    end
                
                    for i = 1, 5 do
                        BuyItem("200 [LMG Ammo] - $328")
                        task.wait(0) 
                    end
                
                    local lmgTool = EquipLMG()
                    if not lmgTool then return end
                
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            if HasForcefield(player) or IsKnockedOut(player) or IsGrabbing(player) or IsTooFar(player) then
                                continue
                            end
                
                            CurrentTarget = player
                            workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
                
                            while not IsKnockedOut(player) and KillAllEnabled do
                                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame - Vector3.new(0, 20, 0)
                                ShootPlayer(player, lmgTool)
                                task.wait(0) 
                            end
                
                            if not KillAllEnabled then break end
                        end
                    end
                
                    if OriginalPosition then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = OriginalPosition
                    end
                
                    workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
                    CurrentTarget = nil
                
                    if StompAllEnabled then
                        StompAllPlayers()
                    end
                end
                
                StompAllPlayers = function()
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local character = player.Character
                            local humanoid = character:FindFirstChild("Humanoid")
                            local bodyEffects = character:FindFirstChild("BodyEffects")
                
                            if not bodyEffects or not humanoid then
                                continue
                            end
                
                            local koValue = bodyEffects:FindFirstChild("K.O")
                            local sDeathValue = bodyEffects:FindFirstChild("SDeath")
                
                            if not koValue or not sDeathValue then
                                continue
                            end
                
                            if koValue.Value and not sDeathValue.Value then
                                while not sDeathValue.Value and StompAllEnabled do
                                    if not koValue.Value or IsGrabbing(player) then
                                        break
                                    end
                
                                    local upperTorso = character:FindFirstChild("UpperTorso")
                                    if upperTorso then
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                                        RunService.RenderStepped:Wait()
                                    end
                                    ReplicatedStorage.MainEvent:FireServer("Stomp")
                                    task.wait(0) 
                                end
                            end
                        end
                    end
                end
                
                DaHood:AddToggle("KillAllToggle", {
                    Text = "Kill All",
                    Default = false,
                    Callback = function(value)
                        KillAllEnabled = value
                        if KillAllEnabled then
                            KillAllPlayers()
                        else
                            if OriginalPosition then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = OriginalPosition
                            end
                            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
                        end
                    end
                })
                
                DaHood:AddToggle("StompAllToggle", {
                    Text = "Stomp All",
                    Default = false,
                    Callback = function(value)
                        StompAllEnabled = value
                        if value and not KillAllEnabled then
                            StompAllPlayers()
                        end
                    end
                })
                
                serenity = {}
                AutoShootEnabled = false
                
                function isPlayerInSerenity(playerName)
                    for _, name in pairs(serenity) do
                        if name == playerName then
                            return true
                        end
                    end
                    return false
                end
                
                function findPlayerByName(playerName)
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player.Name:lower() == playerName:lower() then
                            return player
                        end
                    end
                    return nil
                end
                
                function togglePlayerInSerenity(playerName)
                    local player = findPlayerByName(playerName)
                    
                    if not player then
                        Library:Notify("Player not found in the game!", 5)
                        return
                    end
                
                    if isPlayerInSerenity(playerName) then
                        for i, name in pairs(serenity) do
                            if name == playerName then
                                table.remove(serenity, i)
                                break
                            end
                        end
                        Library:Notify(playerName .. " has been removed from Serenity Mode", 5)
                    else
                        table.insert(serenity, playerName)
                        Library:Notify(playerName .. " has been added to Serenity Mode", 5)
                    end
                end
                
                function autoEquipTool()
                    local player = game.Players.LocalPlayer
                    local backpack = player:FindFirstChild("Backpack")
                    if not backpack then return nil end
                
                    local bestTool = nil
                
                    for _, tool in pairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                            local toolName = tool.Name:lower()
                            if toolName == "rifle" or toolName == "aug" then
                                bestTool = tool
                                break
                            elseif not bestTool then
                                bestTool = tool
                            end
                        end
                    end
                
                    if bestTool then
                        bestTool.Parent = player.Character  
                        Library:Notify("Equipped tool: " .. bestTool.Name, 3)
                        
                        repeat task.wait() until player.Character:FindFirstChildOfClass("Tool") == bestTool
                
                        return bestTool
                    end
                
                    Library:Notify("No tool with Ammo found!", 3)
                    return nil
                end
                
                ShootPlayer = function(target, tool)
                    if not tool or not tool:FindFirstChild("Handle") then return end
                    local targetHead = target.Character and target.Character:FindFirstChild("Head")
                    if not targetHead then return end
                    game:GetService("ReplicatedStorage").MainEvent:FireServer("ShootGun", tool.Handle, tool.Handle.CFrame.Position, targetHead.Position, targetHead, Vector3.new(0, 0, -1))
                end
                
                playerTextBox = DaHood:AddInput('PlayerTextBox', {
                    Text = 'Serenity Mode',
                    Tooltip = 'This will add a player to a table and if they go near you, it will automatically shoot them.',
                    Default = '',
                    Finished = true,
                    Callback = function(Value)
                        if Value and Value ~= "" then
                            togglePlayerInSerenity(Value)
                        end
                    end
                })
                
                autoShootToggle = DaHood:AddToggle('AutoShootToggle', {
                    Text = 'Auto Shoot',
                    Tooltip = 'Automatically shoots players in the Serenity table within 250 studs',
                    Default = false,
                    Callback = function(Value)
                        AutoShootEnabled = Value
                
                        if Value then
                            while AutoShootEnabled do
                                local character = game.Players.LocalPlayer.Character
                                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                                if rootPart then
                                    for _, targetPlayerName in pairs(serenity) do
                                        local targetPlayer = game:GetService("Players"):FindFirstChild(targetPlayerName)
                                        if targetPlayer and targetPlayer.Character then
                                            local targetHead = targetPlayer.Character:FindFirstChild("Head")
                                            if targetHead then
                                                local distance = (rootPart.Position - targetHead.Position).Magnitude
                                                
                                                if distance <= 250 then
                                                    local tool = character:FindFirstChildOfClass("Tool")
                
                                                    if not tool then
                                                        tool = autoEquipTool()
                                                    end
                
                                                    if tool then
                                                        ShootPlayer(targetPlayer, tool)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                task.wait(0)
                            end
                        end
                    end
                })
            end
            
            -- // Resolver And Checks Tab
            do
                local TabBox = Tabs.Combat:AddRightTabbox()
                local Resolver = TabBox:AddTab('Resolver')
                Resolver:AddToggle("ResolverEnabled", {
                    Text = "Enabled",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.Resolver.Enabled = state
                     end
                })
                --
                Resolver:AddDropdown("ResolverMethod", {
                    Values = {"Lerp", "Exponential", "MovingAverage", "MedianFilter", "KalmanFilter",  "WeightedAverage", "Adaptive", "Gaussian", "RunningAverage", "Sigmoid",  "Quadratic", "Logarithmic", "InverseSqrt", "Momentum", "Cosine",  "Sinusoidal", "ExponentialDecay"},
                    Default = Settings.Combat.Resolver.SmoothingMethod,
                    Multi = false,
                    Text = "Method",
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Resolver.SmoothingMethod = state
                    end
                })
                --
                Resolver:AddInput("ResolverSmoothnessAmount", {
                    Default = Settings.Combat.Resolver.Smoothness,
                    Numeric = false,
                    Finished = false,
                    Text = "Smoothness",
                    Tooltip = nil,
                    Placeholder = "no",
                    Callback = function(state)
                        Settings.Combat.Resolver.Smoothness = state
                    end
                })
                --
                Resolver:AddInput("ResolverJitterThreshold", {
                    Default = Settings.Combat.Resolver.JitterThreshold,
                    Numeric = false,
                    Finished = false,
                    Text = "Jitter Threshold",
                    Tooltip = nil,
                    Placeholder = "no",
                    Callback = function(state)
                        Settings.Combat.Resolver.JitterThreshold = state
                    end
                })
                --
                local Checks = TabBox:AddTab('Checks')
                Checks:AddToggle("ChecksEnabled", {
                    Text = "Enabled",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                         Settings.Combat.Checks.Enabled = state
                     end
                })
                --
                Checks:AddToggle("CheckVehicle", {
                    Text = "Vehicle",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Checks.Vehicle = state
                    end
                })
                
                Checks:AddToggle("CheckKnocked", {
                    Text = "Knocked",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Checks.Knocked = state
                    end
                })
                
                Checks:AddToggle("CheckFriend", {
                    Text = "Friend",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Checks.Friend = state
                    end
                })
                
                Checks:AddToggle("CheckWall", {
                    Text = "Wall",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Checks.Wall = state
                    end
                })
                
                Checks:AddToggle("CheckForcefield", {
                    Text = "Forcefield",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Checks.Forcefield = state
                    end
                })
                
                Checks:AddToggle("CheckVisible", {
                    Text = "Visible",
                    Default = false,
                    Tooltip = nil,
                    Callback = function(state)
                        Settings.Combat.Checks.Visible = state
                    end
                })
            end
        end
        
        --// Settings Tab
        do
            local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu")
        
            Library.KeybindFrame.Visible = true
        
            MenuGroup:AddToggle("KeybindsListEnabled", {
                Text = "Keybinds List",
                Default = true
            })
        
            Toggles.KeybindsListEnabled:OnChanged(function()
                Library.KeybindFrame.Visible = Toggles.KeybindsListEnabled.Value
            end)
        
            MenuGroup:AddButton("Unload", function() Library:Unload() end)
        
            MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { 
                Default = "End", 
                NoUI = true, 
                Text = "Menu keybind" 
            })
        
            Library.ToggleKeybind = Options.MenuKeybind
        
            ThemeManager:SetLibrary(Library)
            SaveManager:SetLibrary(Library)
        
            ThemeManager:SetFolder("Alwayswin")
            SaveManager:SetFolder("Alwayswin")
        
            SaveManager:BuildConfigSection(Tabs.Settings)
            SaveManager:LoadAutoloadConfig()
            ThemeManager:ApplyToTab(Tabs.Settings)
        end
    end
end
