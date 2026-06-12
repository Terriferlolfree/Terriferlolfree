if Library then 
    Library:Unload()
end
loadstring(game:HttpGet('https://raw.githubusercontent.com/yuvic123/SKIDO-V3/refs/heads/main/fixed%20fireclick'))()
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Window = Library:CreateWindow({ Title = '                                                      $ Madlol | Modded $ .gg/dk9kWjF4jv', AutoShow = true, TabPadding = 2, MenuFadeTime = 0.2 })
local Tabs = { Main = Window:AddTab('Main'), Character = Window:AddTab('Character'), Visuals = Window:AddTab('Visuals'), Misc = Window:AddTab('Misc'), ['UI Settings'] = Window:AddTab('UI Settings') }
local GunMods = Tabs.Main:AddRightGroupbox('Gun Mods')
local KillAura = Tabs.Main:AddRightGroupbox('Combat')

game.Players.LocalPlayer.Character.Humanoid.Health = 0

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

local LocalPlayer = game:GetService('Players').LocalPlayer
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


local lockedTarget = nil
local targetlist = {}
local multiTargetEnabled = false
local selectedPlayerName = nil
local StickyAimEnabled = true
local TracerEnabled = true
local ViewTargetEnabled = false
local targetHitPart = "Head"
local targetToMouseTracer = true
local grabCheckEnabled = true
local koCheckEnabled = true
local friendCheckEnabled = false
local strafeEnabled = false
local strafeMode = "Random"
local predictMovementEnabled = true
local stompTargetEnabled = false
local lastPosition = nil
local oldPosition = nil
local Core = nil
local BodyVelocity = nil
local PredicTvalue = 1
local hiddenBulletsEnabled = true
local spectateStrafeEnabled = true
local AutoAmmoEnabled = true
local strafeWasEnabledBeforeAmmoBuy = false
local predictionMultiplier = PredicTvalue  -- mặc định dùng giá trị từ slider strafe

local function getPredictedPosition(part)
    if not part or not part.Parent then return part.Position end
    local velocity = part.Velocity
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000  -- Ping thực tế
    local prediction = velocity * (ping + PredicTvalue)  -- Prediction chuẩn: velocity * (ping + multiplier)
    if velocity.Magnitude > 5000 then return part.Position end  -- Clamp để tránh lỗi
    return part.Position + prediction
end

function predictPosition(targetRoot, predictionMultiplier)
    if not targetRoot then return targetRoot.Position end
    local velocity = targetRoot.Velocity
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local prediction = velocity * (ping + predictionMultiplier)
    if velocity.Magnitude > 5000 then return targetRoot.Position end
    return targetRoot.Position + prediction
end
local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Thickness = 1
tracer.Color = Color3.fromRGB(255, 255, 255)

local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerNames, p.DisplayName)
    end
end
local TargetingGroup = Tabs.Main:AddLeftGroupbox('Targeting')

local targetLabel = TargetingGroup:AddLabel("Target: None")

local function updateTargetLabel()
    if multiTargetEnabled then
        local names = {}
        for _, t in ipairs(targetlist) do
            table.insert(names, t.DisplayName)
        end
        targetLabel:SetText("Targets: " .. (#names > 0 and table.concat(names, ", ") or "None"))
    else
        targetLabel:SetText("Target: " .. (lockedTarget and lockedTarget.DisplayName or "None"))
    end
end

TargetingGroup:AddToggle("StickyAim", {
    Text = "Sticky Aim",
    Default = true,
    Callback = function(Value)
        StickyAimEnabled = Value
        if not Value then
            lockedTarget = nil
            targetlist = {}
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            updateTargetLabel()
        end
    end
}):AddKeyPicker("StickyAimKeybind", {
    Default = "Q",
    NoUI = false,
    Text = "Sticky Aim",
    Mode = "Toggle",
    Callback = function()
        if UserInputService:GetFocusedTextBox() then return end
        if multiTargetEnabled then
            local camera = workspace.CurrentCamera
            local mouseLocation = UserInputService:GetMouseLocation()
            local closestTarget, closestDistance = nil, math.huge
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild(targetHitPart) then
                    local bodyEffects = otherPlayer.Character:FindFirstChild("BodyEffects")
                    local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
                    local isGrabbed = otherPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT")
                    if (not grabCheckEnabled or not isGrabbed) and
                       (not friendCheckEnabled or not LocalPlayer:IsFriendsWith(otherPlayer.UserId)) then
                        local targetPart = otherPlayer.Character[targetHitPart]
                        local screenPosition, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mouseLocation).Magnitude
                            if distance < closestDistance then
                                closestTarget = otherPlayer
                                closestDistance = distance
                            end
                        end
                    end
                end
            end
            if closestTarget then
                local index = nil
                for i, t in ipairs(targetlist) do
                    if t == closestTarget then
                        index = i
                        break
                    end
                end
                if index then
                    table.remove(targetlist, index)
                else
                    table.insert(targetlist, closestTarget)
                end
            end
        else
            if lockedTarget then
                lockedTarget = nil
                workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            else
                local camera = workspace.CurrentCamera
                local mouseLocation = UserInputService:GetMouseLocation()
                local closestTarget, closestDistance = nil, math.huge
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild(targetHitPart) then
                        local bodyEffects = otherPlayer.Character:FindFirstChild("BodyEffects")
                        local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
                        local isGrabbed = otherPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT")
                        if (not grabCheckEnabled or not isGrabbed) and
                           (not friendCheckEnabled or not LocalPlayer:IsFriendsWith(otherPlayer.UserId)) then
                            local targetPart = otherPlayer.Character[targetHitPart]
                            local screenPosition, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mouseLocation).Magnitude
                                if distance < closestDistance then
                                    closestTarget = otherPlayer
                                    closestDistance = distance
                                end
                            end
                        end
                    end
                end
                if closestTarget then
                    lockedTarget = closestTarget
                end
            end
        end
        updateTargetLabel()
    end
})
TargetingGroup:AddDropdown("PlayerSelect", {
    Values = playerNames,
    Default = "",
    Multi = false,
    Text = "Select Player",
    Callback = function(Value)
        selectedPlayerName = Value
    end
})

TargetingGroup:AddButton({
    Text = "Set/Remove Target",
    Func = function()
        local selectedPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.DisplayName == selectedPlayerName then
                selectedPlayer = p
                break
            end
        end
        if selectedPlayer then
            if multiTargetEnabled then
                local index = nil
                for i, t in ipairs(targetlist) do
                    if t == selectedPlayer then
                        index = i
                        break
                    end
                end
                if index then
                    table.remove(targetlist, index)
                else
                    table.insert(targetlist, selectedPlayer)
                end
            else
                if lockedTarget == selectedPlayer then
                    lockedTarget = nil
                else
                    lockedTarget = selectedPlayer
                end
            end
            updateTargetLabel()
        end
    end
})

TargetingGroup:AddToggle("MultiTarget", {
    Text = "Multi Target",
    Default = false,
    Callback = function(Value)
        multiTargetEnabled = Value
        if not Value then
            targetlist = {}
            lockedTarget = nil
        end
        updateTargetLabel()
    end
})
TargetingGroup:AddButton({
    Text = "Select All Players",
    Func = function()
        if not multiTargetEnabled then
            Library:Notify("Please enable Multi Target first!", 4)
            return
        end
        
        targetlist = {}
        local addedCount = 0
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer 
                and player.Character 
                and player.Character:FindFirstChild("HumanoidRootPart") then
                
                -- Có thể thêm điều kiện lọc giống như khi chọn target bình thường
                local bodyEffects = player.Character:FindFirstChild("BodyEffects")
                local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
                local isGrabbed = player.Character:FindFirstChild("GRABBING_CONSTRAINT")
                
                if (not grabCheckEnabled or not isGrabbed)
                    and (not koCheckEnabled or not isKO)
                    and (not friendCheckEnabled or not LocalPlayer:IsFriendsWith(player.UserId)) then
                    
                    table.insert(targetlist, player)
                    addedCount = addedCount + 1
                end
            end
        end
        
        selectLockedFromList()  -- cập nhật lockedTarget nếu cần
        updateTargetLabel()
        Library:Notify("Added " .. addedCount .. " players to target list", 4)
    end
})

TargetingGroup:AddButton({
    Text = "Remove All Targets",
    Func = function()
        local before = #targetlist
        
        targetlist = {}
        lockedTarget = nil
        
        selectLockedFromList()  -- sẽ thành nil
        updateTargetLabel()
        
        if before > 0 then
            Library:Notify("Cleared " .. before .. " targets", 3)
        else
            Library:Notify("Target list already empty", 3)
        end
    end
})
local function selectLockedFromList()
    if #targetlist == 0 then
        lockedTarget = nil
        return
    end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        lockedTarget = nil
        return
    end
    local myPos = myRoot.Position
    local priority = {}
    local normal = {}
    for _, tgt in ipairs(targetlist) do
        if tgt and tgt.Character and tgt.Character:FindFirstChild(targetHitPart) then
            local bodyEffects = tgt.Character:FindFirstChild("BodyEffects")
            local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
            local isSDeath = bodyEffects and bodyEffects:FindFirstChild("SDeath") and bodyEffects["SDeath"].Value
            local isGrabbed = tgt.Character:FindFirstChild("GRABBING_CONSTRAINT")
            local hasFF = tgt.Character:FindFirstChildOfClass("ForceField")
            if not hasFF and not isKO and not isSDeath and not isGrabbed then
                table.insert(priority, tgt)
            else
                table.insert(normal, tgt)
            end
        end
    end
    local useList = #priority > 0 and priority or normal
    if #useList == 0 then
        lockedTarget = nil
        return
    end
    local closest, dist = nil, math.huge
    for _, tgt in ipairs(useList) do
        local tgtRoot = tgt.Character:FindFirstChild("HumanoidRootPart")
        if tgtRoot then
            local distance = (myPos - tgtRoot.Position).Magnitude
            if distance < dist then
                closest = tgt
                dist = distance
            end
        end
    end
    lockedTarget = closest
end
TargetingGroup:AddButton({
    Text = 'Teleport to Target',
    Func = function()
        if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = lockedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
    end
})
local tracers = {}

TargetingGroup:AddToggle("TracerToggle", {
    Text = "Draw Tracer",
    Default = true,
    Callback = function(Value)
        TracerEnabled = Value
    end
}):AddColorPicker('HitboxColorPicker', {
    Text = '',
    Default = Color3.new(1, 1, 1),
    Callback = function(color)
        tracerColor = color
    end,
})

TargetingGroup:AddDropdown("TracerMode", {
    Text = "Tracer Mode",
    Values = {"Mouse", "HumanoidRootPart"},
    Default = "Mouse",
    Callback = function(Value)
        targetToMouseTracer = (Value == "HumanoidRootPart")
    end
})
local Target = Tabs.Main:AddLeftGroupbox('Target')
maddieplsnomad = false

TargetingGroup:AddToggle("ViewTarget", {
    Text = "spectate",
    Default = false,
    Callback = function(Value)
        maddieplsnomad = Value
        if not Value then
            ViewTargetEnabled = false
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
}):AddKeyPicker("ViewTargetKeybind", {
    Default = "B",
    NoUI = false,
    Text = "spectate",
    Mode = "Toggle",
    Callback = function()
        if not maddieplsnomad or UserInputService:GetFocusedTextBox() then return end
        ViewTargetEnabled = not ViewTargetEnabled
        if ViewTargetEnabled and lockedTarget then
            workspace.CurrentCamera.CameraSubject = lockedTarget.Character
        else
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})

TargetingGroup:AddDropdown("hp", {
    Text = "Hit Part",
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    Default = "Head",
    Callback = function(Value)
        targetHitPart = Value
    end
})

Target:AddToggle("StrafeToggle", {
    Text = "Target Strafe",
    Default = false,
    Callback = function(Value)
        strafeEnabled = Value
        if Value then
            oldPosition = LocalPlayer.Character.HumanoidRootPart.CFrame  
        end
        if not Value then
            if Core then Core:Destroy() Core = nil end
            if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
            if oldPosition then
                LocalPlayer.Character.HumanoidRootPart.CFrame = oldPosition  -- Quay về khi tắt
            end
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
}):AddKeyPicker("StrafeKeybind", {
    Default = "N",
    NoUI = false,
    Text = "Strafe",
    Mode = "Toggle",
    Callback = function()
        if UserInputService:GetFocusedTextBox() then return end
        strafeEnabled = not strafeEnabled
        if strafeEnabled then
            oldPosition = LocalPlayer.Character.HumanoidRootPart.CFrame  -- Lưu khi bật qua key
        end
        if not strafeEnabled then
            if Core then Core:Destroy() Core = nil end
            if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
            if oldPosition then
                LocalPlayer.Character.HumanoidRootPart.CFrame = oldPosition  -- Quay về khi tắt
            end
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})
local autoEquipGunsEnabled = true
Target:AddToggle("AutoEquipGuns", {
    Text = "Auto Equip Guns",
    Default = true,
    Callback = function(Value)
        autoEquipGunsEnabled = Value
    end
})
local function checkVoid()
    if lockedTarget and lockedTarget.Character then
        local distance = (lockedTarget.Character.HumanoidRootPart.Position - Vector3.new(0,0,0)).Magnitude  -- Giả sử map center (0,0,0)
        if distance > 7000 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0)
            task.wait(1.5)
            if (lockedTarget.Character.HumanoidRootPart.Position - Vector3.new(0,0,0)).Magnitude > 10000 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-1111, 1111), math.random(0, 1111), math.random(-1111, 1111))
            end
        end
    end
end
Target:AddToggle("SpectateStrafe", {
    Text = "Spectate Strafe",
    Default = true,
    Callback = function(Value)
        spectateStrafeEnabled = Value
        if not Value then
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})

Target:AddToggle("PredictMovement", {
    Text = "predict movement",
    Default = true,
    Callback = function(Value)
        predictMovementEnabled = Value
    end
})
Target:AddToggle("AutoPred", {
    Text = "Auto Prediction",
    Default = true,
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Value do
                    if lockedTarget and lockedTarget.Character then
                        local root = lockedTarget.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local speed = root.Velocity.Magnitude
                            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
                            PredicTvalue = math.clamp((speed / 100) + ping, 0.1, 5)  -- Auto adjust theo velocity + ping
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
Target:AddSlider("StrafePredictionDistance", {
    Text = "movement prediction",
    Default = 0.3,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        PredicTvalue = Value
    end
})

TargetingGroup:AddToggle("StompTarget", {
    Text = "Stomp Target",
    Default = false,
    Callback = function(Value)
        stompTargetEnabled = Value
    end
})

TargetingGroup:AddToggle("HiddenBullets", {
    Text = "invisible bullets",
    Default = true,
    Callback = function(Value)
        hiddenBulletsEnabled = Value
    end
})

local function getCurrentGun()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        return tool.Name
    end
    return nil
end

local function getAmmoCount(gunName)
    local inventory = LocalPlayer.DataFolder.Inventory
    local ammo = inventory:FindFirstChild(gunName)
    if ammo then
        return tonumber(ammo.Value) or 0
    end
    return 0
end

local function buyAmmo(gunName)
    local ShopFolder = Workspace:WaitForChild("Ignored"):WaitForChild("Shop")
    local AmmoMap = {
        ["[AUG]"] = "90 [AUG Ammo] - $90",
        ["[LMG]"] = "200 [LMG Ammo] - $338",
        ["[Rifle]"] = "5 [Rifle Ammo] - $281",
    }

    local ammoItemName = AmmoMap[gunName]
    if not ammoItemName then return end

    local ammoItem = ShopFolder:FindFirstChild(ammoItemName)
    if not ammoItem then return end

    local oldPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
    local currentTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")

    if currentTool then
        currentTool.Parent = LocalPlayer.Backpack
    end

    LocalPlayer.Character.HumanoidRootPart.CFrame = ammoItem.Head.CFrame

    local clickDetector = ammoItem:FindFirstChild("ClickDetector")
    if clickDetector then
        for i = 1, 5 do
            fireclickdetector(clickDetector)
            task.wait(0)
        end
    end

    if currentTool then
        currentTool.Parent = LocalPlayer.Character
    end

    LocalPlayer.Character.HumanoidRootPart.CFrame = oldPosition
end

local function checkAmmoAndBuy()
    if not AutoAmmoEnabled then return end

    local gunName = getCurrentGun()
    if not gunName then return end

    local ammoCount = getAmmoCount(gunName)
    if ammoCount <= 0 then
        if strafeEnabled then
			strafeWasEnabledBeforeAmmoBuy = true
			strafeEnabled = false
        end
        if Core then
            Core:Destroy()
            Core = nil
        end
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end

        buyAmmo(gunName)

        if strafeWasEnabledBeforeAmmoBuy then
            strafeEnabled = true
            strafeWasEnabledBeforeAmmoBuy = false
        end
    end
end

getgenv().hitsounds = {
    ["Bubble"] = "rbxassetid://6534947588",
    ["Lazer"] = "rbxassetid://130791043",
    ["Pick"] = "rbxassetid://1347140027",
    ["Pop"] = "rbxassetid://198598793",
    ["Rust"] = "rbxassetid://1255040462",
    ["Sans"] = "rbxassetid://3188795283",
    ["Fart"] = "rbxassetid://130833677",
    ["Big"] = "rbxassetid://5332005053",
    ["Vine"] = "rbxassetid://5332680810",
    ["UwU"] = "rbxassetid://8679659744",
    ["Bruh"] = "rbxassetid://4578740568",
    ["Skeet"] = "rbxassetid://5633695679",
    ["Neverlose"] = "rbxassetid://6534948092",
    ["Fatality"] = "rbxassetid://6534947869",
    ["Bonk"] = "rbxassetid://5766898159",
    ["Minecraft"] = "rbxassetid://5869422451",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["RIFK7"] = "rbxassetid://9102080552",
    ["Bamboo"] = "rbxassetid://3769434519",
    ["Crowbar"] = "rbxassetid://546410481",
    ["Weeb"] = "rbxassetid://6442965016",
    ["Beep"] = "rbxassetid://8177256015",
    ["Bambi"] = "rbxassetid://8437203821",
    ["Stone"] = "rbxassetid://3581383408",
    ["Old Fatality"] = "rbxassetid://6607142036",
    ["Click"] = "rbxassetid://8053704437",
    ["Ding"] = "rbxassetid://7149516994",
    ["Snow"] = "rbxassetid://6455527632",
    ["Laser"] = "rbxassetid://7837461331",
    ["Mario"] = "rbxassetid://2815207981",
    ["Steve"] = "rbxassetid://4965083997",
    ["Call of Duty"] = "rbxassetid://5952120301",
    ["Bat"] = "rbxassetid://3333907347",
    ["TF2 Critical"] = "rbxassetid://296102814",
    ["Saber"] = "rbxassetid://8415678813",
    ["Baimware"] = "rbxassetid://3124331820",
    ["Osu"] = "rbxassetid://7149255551",
    ["TF2"] = "rbxassetid://2868331684",
    ["Slime"] = "rbxassetid://6916371803",
    ["Among Us"] = "rbxassetid://5700183626",
    ["One"] = "rbxassetid://7380502345"
}
getgenv().selectedHitsound = "Baimware"
getgenv().hitsoundEnabled = true
getgenv().hitsoundVolume = 1

function playHitsound()
    if getgenv().hitsoundEnabled then
        local sound = Instance.new("Sound")
        sound.SoundId = getgenv().hitsounds[getgenv().selectedHitsound]
        sound.Volume = getgenv().hitsoundVolume
        sound.Parent = workspace
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

GunMods:AddToggle('hstoggle', {
    Text = 'HitSound',
    Default = true,
    Callback = function(state)
        getgenv().hitsoundEnabled = state
    end
})

GunMods:AddDropdown('hs', {
    Text = 'Select Hitsound',
    Values = {"Bubble", "Lazer", "Pick", "Pop", "Rust", "Sans", "Fart", "Big", "Vine", "UwU", "Bruh", "Skeet", "Neverlose", "Fatality", "Bonk", "Minecraft", "Gamesense", "RIFK7", "Bamboo", "Crowbar", "Weeb", "Beep", "Bambi", "Stone", "Old Fatality", "Click", "Ding", "Snow", "Laser", "Mario", "Steve", "Call of Duty", "Bat", "TF2 Critical", "Saber", "Baimware", "Osu", "TF2", "Slime", "Among Us", "One"},
    Default = "Baimware",
    Callback = function(value)
        getgenv().selectedHitsound = value
    end
})

GunMods:AddSlider('hsvolume', {
    Text = 'Volume',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 2,
    Callback = function(value)
        getgenv().hitsoundVolume = value
    end
})
local function autoEquipAllGuns()
    local backpack = LocalPlayer.Backpack
    local character = LocalPlayer.Character

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                tool.Parent = character -- equip

        end
    end
end
getgenv().lastHealth = {}

Players.PlayerRemoving:Connect(function(player)
    local name = player.Name
    getgenv().lastHealth[name] = nil
    if multiTargetEnabled then
        for i, t in ipairs(targetlist) do
            if t == player then
                table.remove(targetlist, i)
                break
            end
        end
    else
        if lockedTarget == player then
            lockedTarget = nil
        end
    end
    Library:Notify(player.DisplayName .. " has left the game.", 5)
    updateTargetLabel()
end)
local targetHighlight = Instance.new("Highlight")
targetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
targetHighlight.FillTransparency = 1  -- Không fill
targetHighlight.OutlineColor = Color3.new(1, 1, 1)  -- Màu trắng mặc định
targetHighlight.OutlineTransparency = 0
targetHighlight.Parent = game.CoreGui

local lastTargetHealth = {}
local targetStates = {}  -- Để track trạng thái trước đó: {koNotified, deathNotified}
local fadeStartTime = nil
local fadeDuration = 0.8
local redColor = Color3.new(1, 0, 0)
local whiteColor = Color3.new(1, 1, 1)
local blackColor = Color3.new(0, 0, 0)

-- Hàm cập nhật highlight adornee
local function updateHighlight(target)
    targetHighlight.Adornee = (target and target.Character) or nil
end

-- Hàm bắt đầu fade
local function startFade()
    fadeStartTime = tick()
end

-- Xử lý player leaving
Players.PlayerRemoving:Connect(function(player)
    if player == lockedTarget then
        Library:Notify(player.DisplayName .. " has left the game.", 5)
        lockedTarget = nil
        updateHighlight(nil)
        fadeStartTime = nil
    end
end)

-- RunService riêng cho highlight logic
local highlightConnection = RunService.RenderStepped:Connect(function()
    if not lockedTarget or not lockedTarget.Character then
        updateHighlight(nil)
        fadeStartTime = nil
        return
    end
    
    local bodyEffects = lockedTarget.Character:FindFirstChild("BodyEffects")
    local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
    local isSDeath = bodyEffects and bodyEffects:FindFirstChild("SDeath") and bodyEffects["SDeath"].Value
    local humanoid = lockedTarget.Character:FindFirstChild("Humanoid")
    
    if not humanoid then return end
    
    -- Theo dõi trạng thái
    if not targetStates[lockedTarget.Name] then
        targetStates[lockedTarget.Name] = {koNotified = false, deathNotified = false}
    end
    
    local state = targetStates[lockedTarget.Name]
    
    -- Check K.O và SDeath
    if isSDeath then
        targetHighlight.OutlineColor = blackColor
        if not state.deathNotified then
            Library:Notify(lockedTarget.DisplayName .. " has died.", 5)
            state.deathNotified = true
        end
    elseif isKO then
        targetHighlight.OutlineColor = redColor
        if not state.koNotified then
            Library:Notify(lockedTarget.DisplayName .. " has been knocked.", 5)
            state.koNotified = true
        end
    else
        state.koNotified = false
        state.deathNotified = false
        
        -- Theo dõi mất máu
        if not lastTargetHealth[lockedTarget.Name] then
            lastTargetHealth[lockedTarget.Name] = humanoid.Health
        end
        if humanoid.Health < lastTargetHealth[lockedTarget.Name] then
            startFade()
            lastTargetHealth[lockedTarget.Name] = humanoid.Health
        end
        
        -- Fade logic
        if fadeStartTime then
            local elapsed = tick() - fadeStartTime
            if elapsed < fadeDuration then
                local t = elapsed / fadeDuration
                targetHighlight.OutlineColor = redColor:Lerp(whiteColor, t)
            else
                targetHighlight.OutlineColor = whiteColor
                fadeStartTime = nil
            end
        else
            targetHighlight.OutlineColor = whiteColor
        end
    end
    
    updateHighlight(lockedTarget)
end)
local tracers = {}
RunService.RenderStepped:Connect(function()
    checkAmmoAndBuy()
    if multiTargetEnabled then
        selectLockedFromList()
    end
	if lockedTarget == nil or not lockedTarget.Parent then  -- Thoát game
	    if spectateStrafeEnabled or ViewTargetEnabled then
	        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
	    end
	end
    if lockedTarget and lockedTarget.Character then
        local targetPart = lockedTarget.Character:FindFirstChild(targetHitPart)
        local bodyEffects = lockedTarget.Character:FindFirstChild("BodyEffects")
        local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
        local isGrabbed = lockedTarget.Character:FindFirstChild("GRABBING_CONSTRAINT")
        local isSDeath = bodyEffects and bodyEffects:FindFirstChild("SDeath") and bodyEffects["SDeath"].Value
        if ViewTargetEnabled then
            workspace.CurrentCamera.CameraSubject = lockedTarget.Character
        elseif spectateStrafeEnabled and strafeEnabled then
            workspace.CurrentCamera.CameraSubject = lockedTarget.Character:FindFirstChild("Head")
        end
        for _, tracer in pairs(tracers) do tracer:Remove() end
        tracers = {}
        local targetsForVisual = multiTargetEnabled and targetlist or {lockedTarget}
        for _, tgt in ipairs(targetsForVisual) do
            local tPart = tgt.Character and tgt.Character:FindFirstChild(targetHitPart)
            if TracerEnabled and tPart then
                local tracer = Drawing.new("Line")
                tracer.Visible = true
                tracer.Thickness = 1
                tracer.Color = tracerColor or Color3.fromRGB(255, 255, 255)
                local camera = workspace.CurrentCamera
                local targetScreenPos, onScreen = camera:WorldToViewportPoint(tPart.Position)
                local endScreenPos
                if targetToMouseTracer then
                    endScreenPos = UserInputService:GetMouseLocation()
                else
                    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local rootScreenPos, rootOnScreen = camera:WorldToViewportPoint(rootPart.Position)
                        if rootOnScreen then
                            endScreenPos = Vector2.new(rootScreenPos.X, rootScreenPos.Y)
                        end
                    end
                end
                if onScreen and endScreenPos then
                    tracer.From = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                    tracer.To = endScreenPos
                else
                    tracer.Visible = false
                end
                table.insert(tracers, tracer)
            end
        end
        local humanoid = lockedTarget.Character:FindFirstChild("Humanoid")
        if humanoid then
            if not getgenv().lastHealth[lockedTarget.Name] then
                getgenv().lastHealth[lockedTarget.Name] = humanoid.Health
            end
            if humanoid.Health < getgenv().lastHealth[lockedTarget.Name] then
                playHitsound()
            end
            getgenv().lastHealth[lockedTarget.Name] = humanoid.Health
        end
		if strafeEnabled and lockedTarget and (lockedTarget.Character:FindFirstChildOfClass("ForceField") or isSDeath or (isKO and not stompTargetEnabled)) then
		    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-1111, 1111), math.random(0, 1111), math.random(-1111, 1111)) return end
		if strafeEnabled and lockedTarget and isKO and stompTargetEnabled then
		    return end
        if strafeEnabled and targetPart and not isGrabbed then
            if autoEquipGunsEnabled then
                autoEquipAllGuns()  -- Equip nếu bật
            end
		    checkVoid()
            local targetRoot = lockedTarget.Character:FindFirstChild("HumanoidRootPart")
            local targetPosition = targetRoot.Position
            if predictMovementEnabled then
                targetPosition = predictPosition(targetRoot, PredicTvalue)
            end
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
            if strafeMode == "Random" then
                local offset = Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))
                local randomrotation = CFrame.Angles(0, 0, 0)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + offset) * randomrotation
            end
        else
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end

		local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
		local handle = tool and tool:FindFirstChild("Handle")

        local targetsForShoot = multiTargetEnabled and targetlist or {lockedTarget}
        for _, tgt in ipairs(targetsForShoot) do
            local tPart = tgt.Character and tgt.Character:FindFirstChild(targetHitPart)
            local tCharacter = tPart and tPart:FindFirstAncestorOfClass("Model")
            local tBodyEffects = tCharacter and tCharacter:FindFirstChild("BodyEffects")
            local tIsKO = tBodyEffects and tBodyEffects:FindFirstChild("K.O") and tBodyEffects["K.O"].Value
            local tIsGrabbed = tCharacter and tCharacter:FindFirstChild("GRABBING_CONSTRAINT")
            local tHasForceField = tCharacter and tCharacter:FindFirstChildOfClass("ForceField")
            if tool and handle and tPart and not tIsKO and not tIsGrabbed and not tHasForceField then
                local predictedPos = getPredictedPosition(tPart)  -- vị trí dự đoán
                
                if hiddenBulletsEnabled then
                    ReplicatedStorage.MainEvent:FireServer(
                        "ShootGun",
                        handle,
                        handle.CFrame.Position - Vector3.new(0, 10, 0),
                        predictedPos - Vector3.new(0, 10, 0),  -- dùng predicted
                        tPart,
                        Vector3.new(0, 0, -1)
                    )
                else
                    ReplicatedStorage.MainEvent:FireServer(
                        "ShootGun",
                        handle,
                        handle.CFrame.Position,
                        predictedPos,  -- dùng predicted
                        tPart,
                        Vector3.new(0, 0, -1)
                    )
                end
            end
        end

    else
        if strafeEnabled and oldPosition then
            LocalPlayer.Character.HumanoidRootPart.CFrame = oldPosition
            oldPosition = nil
        end
        for _, tracer in pairs(tracers) do tracer:Remove() end
        tracers = {}
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
    end
end)


local TextChatService = game:GetService("TextChatService")
local ChatVersion = TextChatService.ChatVersion
local ChatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
local function startStompLoop()

    task.spawn(function()
        while LocalPlayer.Character do
            if stompTargetEnabled and lockedTarget and lockedTarget ~= LocalPlayer then
                local character = lockedTarget.Character
                if character then
                    local bodyEffects = character:FindFirstChild("BodyEffects")
                    local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
                    local isSDeath = bodyEffects and bodyEffects:FindFirstChild("SDeath") and bodyEffects["SDeath"].Value

                    if isKO and not isSDeath then
                        local upperTorso = character:FindFirstChild("UpperTorso")
                        if upperTorso then
                            local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                            if not lastPosition then
                                lastPosition = hrp.Position
                            end
                            hrp.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                            RunService.RenderStepped:Wait()
                        end

                    elseif isSDeath and lastPosition then

                        local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                        while (hrp.Position - lastPosition).Magnitude > 5 do
                            hrp.CFrame = CFrame.new(lastPosition)
                            task.wait()
                        end
                        lastPosition = nil
                    end
                else
                    if lastPosition then
                        local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                        while (hrp.Position - lastPosition).Magnitude > 5 do
                            hrp.CFrame = CFrame.new(lastPosition)
                            task.wait()
                        end
                        lastPosition = nil
                    end
                end

                ReplicatedStorage.MainEvent:FireServer("Stomp")
            end

            task.wait()
        end
    end)
end
startStompLoop()

-- Khi chết -> hồi sinh
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    startStompLoop()
end)

local StarterGui = game:GetService("StarterGui")
local RapidFireEnabled = false
local hyperFireEnabled = false
local modifiedTools = {}

local function rapidfire(tool)
    if not tool or not tool:FindFirstChild("GunScript") or modifiedTools[tool] then return end

    for _, v in ipairs(getconnections(tool.Activated)) do
        local funcinfo = debug.getinfo(v.Function)
        for i = 1, funcinfo.nups do
            local c, n = debug.getupvalue(v.Function, i)
            if type(c) == "number" then
                debug.setupvalue(v.Function, i, 0.0000000000001)
            end
        end
    end

    modifiedTools[tool] = true
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

GunMods:AddToggle("RapidFireToggle", {
    Text = "Rapid Fire",
    Default = false,
    Callback = function(Value)
        RapidFireEnabled = Value
        if Value then
            modifiedTools = {}
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

GunMods:AddToggle("HyperFireToggle", {
    Text = "Rapid Fire v2",
    Default = false,
    Callback = function(Value)
        hyperFireEnabled = Value
        updateHyperFire()
    end
})

game.DescendantAdded:Connect(function(obj)
    if obj.Name == "ToleranceCooldown" and obj:IsA("ValueBase") then
        obj.Value = hyperFireEnabled and 0 or 3
    end
end)

RunService.RenderStepped:Connect(function()
    if hyperFireEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Ammo") then
                tool:Activate()
            end
        end
    end
end)

local HBE = Tabs.Main:AddRightGroupbox('HBE')

local size = 10
local hitboxColor = Color3.new(0, 1, 1)
local visualizeHitbox = false
local hitboxExpanderEnabled = false
local Client = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

HBE:AddToggle('HitboxExpanderToggle', {
    Text = 'Hitbox Expander',
    Default = false,
    Callback = function(state)
        hitboxExpanderEnabled = state
        if not state then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= Client and Player.Character then
                    resetCharacter(Player.Character)
                end
            end
        end
    end,
}):AddKeyPicker("FlightKeybindPicker", {
    Default = "L",
    Text = "Hitbox",
    Mode = "Toggle",
    Callback = function(state)
        if UserInputService:GetFocusedTextBox() then return end
        hitboxExpanderEnabled = state
        if not state then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= Client and Player.Character then
                    resetCharacter(Player.Character)
                end
            end
        end
    end
})

HBE:AddSlider('HitboxSizeSlider', {
    Text = 'Hitbox Size',
    Default = 10,
    Min = 10,
    Max = 50,
    Rounding = 0,
    Callback = function(value)
        size = value
    end,
})

HBE:AddToggle('VisualizerToggle', {
    Text = 'Visualize',
    Default = false,
    Callback = function(state)
        visualizeHitbox = state
        if not state then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= Client and Player.Character then
                    removeVisuals(Player.Character)
                end
            end
        end
    end,
}):AddColorPicker('HitboxColorPicker', {
    Text = 'Hitbox Color',
    Default = Color3.new(0, 1, 1),
    Callback = function(color)
        hitboxColor = color
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
        -- Reset HRP size to default (2, 1, 2)
        HRP.Size = Vector3.new(2, 1, 2)
        HRP.Transparency = 1
        HRP.CanCollide = true
        removeVisuals(Character)
    end
end

local function handleCharacter(Character)
    if not Character or not hitboxExpanderEnabled then
        resetCharacter(Character)
        return
    end
    local HRP = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 5)
    if not HRP then return end

    HRP.Size = Vector3.new(size, size, size)
    HRP.Transparency = 1
    HRP.CanCollide = false

    if visualizeHitbox then
        local outline = HRP:FindFirstChild("HitboxOutline")
        if not outline then
            outline = Instance.new("BoxHandleAdornment")
            outline.Name = "HitboxOutline"
            outline.Adornee = HRP
            outline.Size = HRP.Size
            outline.Transparency = 0.8
            outline.ZIndex = 10
            outline.AlwaysOnTop = true
            outline.Color3 = hitboxColor
            outline.Parent = HRP

            local glow = Instance.new("BoxHandleAdornment")
            glow.Name = "HitboxGlow"
            glow.Adornee = HRP
            glow.Size = HRP.Size + Vector3.new(0.1, 0.1, 0.1)
            glow.Transparency = 0.9
            glow.ZIndex = 9
            glow.AlwaysOnTop = true
            glow.Color3 = hitboxColor
            glow.Parent = HRP
        else
            outline.Size = HRP.Size
            outline.Color3 = hitboxColor
            local glow = HRP:FindFirstChild("HitboxGlow")
            if glow then
                glow.Size = HRP.Size + Vector3.new(0.1, 0.1, 0.1)
                glow.Color3 = hitboxColor
            end
        end
    else
        removeVisuals(Character)
    end
end

local function handlePlayer(Player)
    if Player == Client then return end
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
    if not hitboxExpanderEnabled then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= Client and Player.Character then
                resetCharacter(Player.Character)
            end
        end
        return
    end
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= Client and Player.Character then
            handleCharacter(Player.Character)
        end
    end
end)

local CamLockBox = Tabs.Main:AddRightGroupbox('Legit')

local camLockEnabled = false
local camLockTarget = nil
local smoothness = 0.5

CamLockBox:AddToggle('CamLockToggle', {
    Text = 'CamLock',
    Default = false,
    Callback = function(state)
        camLockEnabled = state
        if not state then
            camLockTarget = nil
        end
    end,
}):AddKeyPicker('CamLockKeybind', {
    Default = 'Q',
    Text = 'CamLock',
    Mode = 'Toggle',
    Callback = function()
        if UserInputService:GetFocusedTextBox() then return end
        if not camLockEnabled then return end

        if camLockTarget then
            camLockTarget = nil
        else
            local closestPlayer = nil
            local closestDistance = math.huge
            local mousePos = UserInputService:GetMouseLocation()

            for _, Player in pairs(Players:GetPlayers()) do
                if Player == LocalPlayer then continue end
                local character = Player.Character
                if character then
                    local HRP = character:FindFirstChild("Head")
                    if HRP then
                        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(HRP.Position)
                        if onScreen then
                            local distance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestPlayer = Player
                            end
                        end
                    end
                end
            end

            camLockTarget = closestPlayer
        end
    end,
})

CamLockBox:AddInput('SmoothnessInput', {
    Default = '0.5',
    Numeric = true,
    Finished = false,
    Text = 'Smoothness',
    Tooltip = 'Controls how smoothly the camera follows the target (0 = instant)',
    Placeholder = 'Enter smoothness value...',
    Callback = function(Value)
        smoothness = tonumber(Value) or 0.5
    end
})

RunService.RenderStepped:Connect(function()
    if camLockEnabled and camLockTarget then
        local character = camLockTarget.Character
        if character then
            local HRP = character:FindFirstChild("HumanoidRootPart")
            if HRP then
                local camera = workspace.CurrentCamera
                local targetPosition = HRP.Position

                -- Get the current camera CFrame
                local currentCFrame = camera.CFrame

                -- Calculate the new look direction
                local lookVector = (targetPosition - currentCFrame.Position).Unit

                -- Smoothly interpolate the look direction
                local currentLookVector = currentCFrame.LookVector
                local smoothedLookVector = currentLookVector:Lerp(lookVector, smoothness)

                -- Update the camera's CFrame to face the smoothed direction
                camera.CFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + smoothedLookVector)
            end
        end
    end
end)

getgenv().range = 250

getgenv().whitelist = {}


getgenv().tracer = Instance.new("Part")
getgenv().tracer.Size = Vector3.new(0.2, 0.2, 0.2)
getgenv().tracer.Material = Enum.Material.Neon
getgenv().tracer.Color = Color3.new(1, 0, 0)
getgenv().tracer.Transparency = 1
getgenv().tracer.Anchored = true
getgenv().tracer.CanCollide = false
getgenv().tracer.Parent = workspace

getgenv().enabled = false
getgenv().active = false
getgenv().visualizeEnabled = true
getgenv().silentEnabled = true
getgenv().lastHealth = {}

KillAura:AddToggle('MainToggle', {
    Text = 'Kill Aura',
    Default = false,
    Callback = function(state)
        getgenv().enabled = state
        if not state then
            getgenv().active = false
            getgenv().tracer.Transparency = 1
        end
    end
}):AddKeyPicker('Keybind', {
    Default = 'K',
    Text = 'kill aura',
    Mode = 'Toggle',
    Callback = function(state)
        if not getgenv().enabled or UserInputService:GetFocusedTextBox() then return end
        getgenv().active = state
    end
})

KillAura:AddSlider("Range", {
    Text = "Range",
    Default = 250,
    Min = 10,
    Max = 250,
    Rounding = 1,
    Callback = function(value)
        getgenv().range = value
    end
})

KillAura:AddToggle('Visualizer', {
    Text = 'Visualize',
    Default = true,
    Callback = function(state)
        getgenv().visualizeEnabled = state
    end
}):AddColorPicker('VisualizerColor', {
    Text = 'Visualizer Color',
    Default = Color3.new(1, 0, 0),
    Callback = function(value)
        getgenv().tracer.Color = value
    end
})

KillAura:AddToggle('Silent', {
    Text = 'Silent',
    Default = true,
    Callback = function(state)
        getgenv().silentEnabled = state
    end
})

KillAura:AddInput('wlb', {
    Default = '',
    Numeric = false,
    Finished = false,
    Text = 'Add/Remove Player',
    Tooltip = 'Type a name or display name to add/remove from whitelist',
    Placeholder = 'Player Name',
    Callback = function(input)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Name == input or player.DisplayName == input then
                if getgenv().whitelist[player.Name] then
                    getgenv().whitelist[player.Name] = nil
                    Library:Notify(player.Name .. " removed from whitelist.", 2)
                else
                    getgenv().whitelist[player.Name] = true
                    Library:Notify(player.Name .. " added to whitelist.", 2)
                end
                return
            end
        end
        Library:Notify("Player not found.", 2)
    end,
    Autocomplete = function(input)
        local suggestions = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.find(string.lower(player.Name), string.lower(input)) or string.find(string.lower(player.DisplayName), string.lower(input)) then
                table.insert(suggestions, player.Name .. " (" .. player.DisplayName .. ")")
            end
        end
        return suggestions
    end
})



task.spawn(function()
    while true do
        if getgenv().active and getgenv().enabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Handle") then
            if workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild(game.Players.LocalPlayer.Name) and workspace.Players:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("BodyEffects") and workspace.Players:FindFirstChild(game.Players.LocalPlayer.Name).BodyEffects:FindFirstChild("K.O") and workspace.Players:FindFirstChild(game.Players.LocalPlayer.Name).BodyEffects["K.O"].Value then
                task.wait()
            else
				local closest = math.huge
				target = nil

				for _, player in pairs(game.Players:GetPlayers()) do
					if player ~= game.Players.LocalPlayer
					and not getgenv().whitelist[player.Name]
					and player.Character
					and player.Character:FindFirstChild("Head")
					and not player.Character:FindFirstChild("GRABBING_CONSTRAINT") then

						-- ForceField check
						if not player.Character:FindFirstChildOfClass("ForceField") then

							if workspace:FindFirstChild("Players")
							and workspace.Players:FindFirstChild(player.Name)
							and workspace.Players[player.Name]:FindFirstChild("BodyEffects")
							and workspace.Players[player.Name].BodyEffects:FindFirstChild("K.O")
							and not workspace.Players[player.Name].BodyEffects["K.O"].Value then

								local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position 
								- player.Character.Head.Position).Magnitude

								if dist < closest and dist <= getgenv().range then
									closest = dist
									target = player
								end
							end
						end
					end
				end


                if target and target.Character and target.Character:FindFirstChild("Head") then
                    if getgenv().visualizeEnabled then
                        getgenv().tracer.Transparency = 0
                        getgenv().tracer.Size = Vector3.new(0.2, 0.2, (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target.Character.Head.Position).Magnitude)
                        getgenv().tracer.CFrame = CFrame.lookAt(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, target.Character.Head.Position) * CFrame.new(0, 0, -getgenv().tracer.Size.Z / 2)
                    else
                        getgenv().tracer.Transparency = 1
                    end

                    local humanoid = target.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        if not getgenv().lastHealth[target.Name] then
                            getgenv().lastHealth[target.Name] = humanoid.Health
                        end
                        if humanoid.Health < getgenv().lastHealth[target.Name] then
                            playHitsound()
                        end
                        getgenv().lastHealth[target.Name] = humanoid.Health
                    end

                    if getgenv().silentEnabled then
                        local predictedPos = getPredictedPosition(target.Character:FindFirstChild("Head"))
                        game.ReplicatedStorage.MainEvent:FireServer(
                            "ShootGun",
                            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Handle"),
                            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Handle").CFrame.Position - Vector3.new(0, 12, 0),
                            predictedPos - Vector3.new(0, 12, 0),
                            target.Character.Head,
                            Vector3.new(0, 0, -1)
                    )
                    else
                        game.ReplicatedStorage.MainEvent:FireServer("ShootGun", game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Handle"), game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Handle").CFrame.Position, predictedPos, target.Character.Head, Vector3.new(0, 0, -1))
                    end
                else
                    getgenv().tracer.Transparency = 1
                end
            end
        else
            getgenv().tracer.Transparency = 1
        end
        task.wait()
    end
end)
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--true(On)  false(Off)

getgenv().ESPEnabled = false
getgenv().BoxESP = false
getgenv().TracerESP = false
getgenv().NameESP = false
getgenv().DistanceESP = false
getgenv().HealthESP = false
getgenv().HealthOutlineESP = false
getgenv().WallhackEnabled = true
getgenv().TeamCheck = false
getgenv().RenderDistance = 1000

getgenv().BoxColor = Color3.fromRGB(255,255,255)
getgenv().TracerColor = Color3.fromRGB(255,255,255)
getgenv().NameColor = Color3.fromRGB(255,255,255)
getgenv().DistanceColor = Color3.fromRGB(255,255,255)

local boxes = {}
local tracers = {}
local nameTags = {}
local distanceTags = {}
local healthBars = {}

local function createText(size)
    local text = Drawing.new("Text")
    text.Size = size
    text.Center = true
    text.Outline = false
    text.Visible = false
    return text
end

local function createBarPair()
    local outline = Drawing.new("Square")
    outline.Thickness = 1
    outline.Filled = true
    outline.Visible = false
    outline.Color = Color3.fromRGB(0,0,0)

    local bar = Drawing.new("Square")
    bar.Thickness = 1
    bar.Filled = true
    bar.Visible = false
    bar.Color = Color3.fromRGB(0,255,0)
    return {Outline = outline, Bar = bar}
end

local function isEnemy(player)
    if not getgenv().TeamCheck then return true end
    return player.Team ~= LocalPlayer.Team
end

local function createESP(character, player)
    if not character or boxes[character] then return end
    if player == LocalPlayer then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChild("Humanoid")
    if not hrp or not head then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = getgenv().BoxColor
    box.Filled = false
    box.Transparency = 1
    box.Thickness = 1
    
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = getgenv().TracerColor
    line.Thickness = 1
    line.Transparency = 1
    
    local nameTag = createText(11)
    local distTag = createText(11)
    
    if not healthBars[player] then
        healthBars[player] = createBarPair()
    end
    
    local connection = RunService.RenderStepped:Connect(function()
        if not getgenv().ESPEnabled or not getgenv().WallhackEnabled then
            box.Visible = false
            line.Visible = false
            nameTag.Visible = false
            distTag.Visible = false
            if healthBars[player] then
                healthBars[player].Outline.Visible = false
                healthBars[player].Bar.Visible = false
            end
            return
        end
        
        if not isEnemy(player) then
            box.Visible = false
            line.Visible = false
            nameTag.Visible = false
            distTag.Visible = false
            if healthBars[player] then
                healthBars[player].Outline.Visible = false
                healthBars[player].Bar.Visible = false
            end
            return
        end
        
        hrp = character:FindFirstChild("HumanoidRootPart")
        head = character:FindFirstChild("Head")
        humanoid = character:FindFirstChild("Humanoid")
        if not hrp or not head or not humanoid then return end
        
        local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.3, 0))
        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.5, 0))
        local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
        
        if visible and distance <= getgenv().RenderDistance then
            local scale = 1 / (pos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
            local width, height = math.floor(40 * scale), math.floor(62 * scale)
            local position = Vector2.new(pos.X - width/2, pos.Y - height/2)
            
            if getgenv().BoxESP then
                box.Size = Vector2.new(width, height)
                box.Position = position
                box.Color = getgenv().BoxColor
                box.Visible = true
            else box.Visible = false end
            
            if getgenv().TracerESP then
                line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y - 50)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = getgenv().TracerColor
                line.Visible = true
            else line.Visible = false end
            
            if getgenv().NameESP then
                nameTag.Position = Vector2.new(headPos.X, headPos.Y - 20)
                nameTag.Text = player.Name
                nameTag.Color = getgenv().NameColor
                nameTag.Visible = true
            else nameTag.Visible = false end
            
            if getgenv().DistanceESP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                distTag.Position = Vector2.new(legPos.X, legPos.Y + 5)
                distTag.Text = tostring(dist) .. "m"
                distTag.Color = getgenv().DistanceColor
                distTag.Visible = true
            else distTag.Visible = false end
            
            if getgenv().HealthESP then
                local outline = healthBars[player].Outline
                local bar = healthBars[player].Bar
                
                local barHeight = height * 0.95
                local barWidth = 2
                local barXPos = position.X - barWidth - 5
                local barYPos = position.Y + (height - barHeight) / 2
                
                local hpPercent = humanoid.Health / humanoid.MaxHealth
                local filledHeight = barHeight * hpPercent
                
                if getgenv().HealthOutlineESP then
                    outline.Size = Vector2.new(barWidth + 2, barHeight + 2)
                    outline.Position = Vector2.new(barXPos - 1, barYPos - 1)
                    outline.Visible = true
                else outline.Visible = false end
                
                bar.Size = Vector2.new(barWidth, filledHeight)
                bar.Position = Vector2.new(barXPos, barYPos + (barHeight - filledHeight))
                
                if humanoid.Health <= 20 then
                    bar.Color = Color3.fromRGB(255, 0, 0)
                elseif humanoid.Health <= 65 then
                    bar.Color = Color3.fromRGB(255, 255, 0)
                else
                    bar.Color = Color3.fromRGB(0, 255, 0)
                end
                
                bar.Visible = true
            else
                if healthBars[player] then
                    healthBars[player].Outline.Visible = false
                    healthBars[player].Bar.Visible = false
                end
            end
        else
            box.Visible = false
            line.Visible = false
            nameTag.Visible = false
            distTag.Visible = false
            if healthBars[player] then
                healthBars[player].Outline.Visible = false
                healthBars[player].Bar.Visible = false
            end
        end
    end)
    
    boxes[character] = {Box = box, Connection = connection}
    tracers[character] = {Line = line}
    nameTags[player] = nameTag
    distanceTags[player] = distTag
end

local function removeESP(character, player)
    if boxes[character] then
        if boxes[character].Connection then boxes[character].Connection:Disconnect() end
        if boxes[character].Box then boxes[character].Box:Remove() end
        boxes[character] = nil
    end
    
    if tracers[character] then
        if tracers[character].Line then tracers[character].Line:Remove() end
        tracers[character] = nil
    end
    
    if nameTags[player] then
        nameTags[player]:Remove()
        nameTags[player] = nil
    end
    
    if distanceTags[player] then
        distanceTags[player]:Remove()
        distanceTags[player] = nil
    end
    
    if healthBars[player] then
        if healthBars[player].Outline then healthBars[player].Outline:Remove() end
        if healthBars[player].Bar then healthBars[player].Bar:Remove() end
        healthBars[player] = nil
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then return end
    
    player.CharacterAdded:Connect(function(char)
        removeESP(char, player)
        task.wait(0.1)
        char:WaitForChild("HumanoidRootPart", 5)
        char:WaitForChild("Head", 5)
        char:WaitForChild("Humanoid", 5)
        createESP(char, player)
    end)
    
    player.CharacterRemoving:Connect(function(char)
        removeESP(char, player)
    end)
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
        createESP(player.Character, player)
    end
end

for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeESP(player.Character, player)
    end
end)

local espGr = Tabs.Visuals:AddLeftGroupbox("esp")
espGr:AddToggle("ESPEnabled", {
    Text = "Enable ESP",
    Callback = function(v)
        getgenv().ESPEnabled = v
    end
})

espGr:AddToggle("BoxESP", {
    Text = "Box ESP",
    Callback = function(v)
        getgenv().BoxESP = v
    end
}):AddColorPicker("BoxColor", {
    Default = getgenv().BoxColor,
    Title = "Box Color",
    Callback = function(v)
        getgenv().BoxColor = v
    end
})

espGr:AddToggle("TracerESP", {
    Text = "Tracer ESP",
    Callback = function(v)
        getgenv().TracerESP = v
    end
}):AddColorPicker("TracerColor", {
    Default = getgenv().TracerColor,
    Title = "Tracer Color",
    Callback = function(v)
        getgenv().TracerColor = v
    end
})

espGr:AddToggle("NameESP", {
    Text = "Name ESP",
    Callback = function(v)
        getgenv().NameESP = v
    end
}):AddColorPicker("NameColor", {
    Default = getgenv().NameColor,
    Title = "Name Color",
    Callback = function(v)
        getgenv().NameColor = v
    end
})

espGr:AddToggle("DistanceESP", {
    Text = "Distance ESP",
    Callback = function(v)
        getgenv().DistanceESP = v
    end
}):AddColorPicker("DistanceColor", {
    Default = getgenv().DistanceColor,
    Title = "Distance Color",
    Callback = function(v)
        getgenv().DistanceColor = v
    end
})

espGr:AddToggle("HealthESP", {
    Text = "Health ESP",
    Callback = function(v)
        getgenv().HealthESP = v
    end
})
espGr:AddToggle("HealthOutlineESP", {
    Text = "Health Outline",
    Callback = function(v)
        getgenv().HealthOutlineESP = v
    end
})

espGr:AddToggle("TeamCheck", {
    Text = "Team Check",
    Callback = function(v)
        getgenv().TeamCheck = v
    end
})
espGr:AddSlider("RenderDistance", {
    Text = "Render Distance",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Callback = function(v)
        getgenv().RenderDistance = v
    end
})


local faces = {"Front", "Back", "Bottom", "Top", "Right", "Left"}
local materials = {
    {"Wood", "3258599312"}, {"WoodPlanks", "8676581022"},
    {"Brick", "8558400252"}, {"Cobblestone", "5003953441"},
    {"Concrete", "7341687607"}, {"DiamondPlate", "6849247561"},
    {"Fabric", "118776397"}, {"Granite", "4722586771"},
    {"Grass", "4722588177"}, {"Ice", "3823766459"},
    {"Marble", "62967586"}, {"Metal", "62967586"},
    {"Sand", "152572215"}
}

local originalMaterials = {}
local textureConnection

function texture(ins, id)
    for _, v in pairs(faces) do
        local texture = Instance.new("Texture", ins)
        texture.ZIndex = 2147483647
        texture.Texture = "rbxassetid://" .. id
        texture.Face = Enum.NormalId[v]
        texture.Color3 = ins.Color
        texture.Transparency = ins.Transparency
    end
end

local function applyTextures()
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not originalMaterials[part] then
            originalMaterials[part] = part.Material
            for _, v in pairs(materials) do
                if part.Material.Name == v[1] then
                    texture(part, v[2])
                    part.Material = Enum.Material.SmoothPlastic
                    break
                end
            end
        end
    end
end

local function revertTextures()
    for part, material in pairs(originalMaterials) do
        if part and part.Parent then
            part.Material = material
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("Texture") then
                    child:Destroy()
                end
            end
        end
    end
    originalMaterials = {}
end

local TextureGroupbox = Tabs.Visuals:AddRightGroupbox('Texture')

TextureGroupbox:AddToggle('TextureToggle', {
    Text = 'Texture Minecraft(turn off lowgfx before)',
    Default = false,
    Callback = function(state)
        if state then
            applyTextures()
            textureConnection = workspace.DescendantAdded:Connect(function(desc)
                if desc:IsA("BasePart") then
                    originalMaterials[desc] = desc.Material
                    for _, v in pairs(materials) do
                        if desc.Material.Name == v[1] then
                            texture(desc, v[2])
                            desc.Material = Enum.Material.SmoothPlastic
                            break
                        end
                    end
                end
            end)
        else
            if textureConnection then
                textureConnection:Disconnect()
                textureConnection = nil
            end
            revertTextures()
        end
    end
})
local HudUi = Tabs.Visuals:AddLeftGroupbox('Hud Changer')

local defaultTextHP = " Health "
local defaultTextArmor = "                   Armor"
local defaultTextEnergy = "Dark Energy              "

local defaultColorHP = Color3.new(0.941176, 0.031373, 0.819608)
local defaultColorArmor = Color3.new(0.376471, 0.031373, 0.933333)
local defaultColorEnergy = Color3.new(0.768627, 0.039216, 0.952941)

local textHP, textArmor, textEnergy = defaultTextHP, defaultTextArmor, defaultTextEnergy
local colorHP, colorArmor, colorEnergy = defaultColorHP, defaultColorArmor, defaultColorEnergy

local toggleHP, toggleArmor, toggleEnergy = false, false, false

local function skibiditoilet()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = playerGui:WaitForChild("MainScreenGui").Bar

    if toggleHP then
        gui.HP.TextLabel.Text = textHP
        gui.HP.bar.BackgroundColor3 = colorHP
    end

    if toggleArmor then
        gui.Armor.TextLabel.Text = textArmor
        gui.Armor.bar.BackgroundColor3 = colorArmor
    end

    if toggleEnergy then
        gui.Energy.TextLabel.Text = textEnergy
        gui.Energy.bar.BackgroundColor3 = colorEnergy
    end
end

HudUi:AddToggle('ToggleHP', {
    Text = 'Customize Health',
    Default = false,
    Callback = function(state)
        toggleHP = state
        skibiditoilet()
    end
}):AddColorPicker('ColorHP', {
    Text = 'Health Color',
    Default = defaultColorHP,
    Callback = function(value)
        if toggleHP then colorHP = value skibiditoilet() end
    end
})

HudUi:AddInput('TextHP', {
    Text = 'Health Text',
    Default = defaultTextHP,
    Callback = function(value)
        if toggleHP then textHP = value skibiditoilet() end
    end
})

HudUi:AddToggle('ToggleArmor', {
    Text = 'Customize Armor',
    Default = false,
    Callback = function(state)
        toggleArmor = state
        skibiditoilet()
    end
}):AddColorPicker('ColorArmor', {
    Text = 'Armor Color',
    Default = defaultColorArmor,
    Callback = function(value)
        if toggleArmor then colorArmor = value skibiditoilet() end
    end
})

HudUi:AddInput('TextArmor', {
    Text = 'Armor Text',
    Default = defaultTextArmor,
    Callback = function(value)
        if toggleArmor then textArmor = value skibiditoilet() end
    end
})

HudUi:AddToggle('ToggleEnergy', {
    Text = 'Customize Energy',
    Default = false,
    Callback = function(state)
        toggleEnergy = state
        skibiditoilet()
    end
}):AddColorPicker('ColorEnergy', {
    Text = 'Energy Color',
    Default = defaultColorEnergy,
    Callback = function(value)
        if toggleEnergy then colorEnergy = value skibiditoilet() end
    end
})

HudUi:AddInput('TextEnergy', {
    Text = 'Energy Text',
    Default = defaultTextEnergy,
    Callback = function(value)
        if toggleEnergy then textEnergy = value skibiditoilet() end
    end
})

local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function()
    if toggleHP or toggleArmor or toggleEnergy then
        player:WaitForChild("PlayerGui")
        skibiditoilet()
    end
end)


local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Auras = Tabs.Visuals:AddRightGroupbox("Self")
utility = utility or {}

local Settings = {
    Visuals = {
        SelfESP = {
            Trail = {
                Color = Color3.fromRGB(0, 86, 255),
                Color2 = Color3.fromRGB(255, 0, 0), -- Second color for gradient
                LifeTime = 1.6,
                Width = 0.1
            },
            Aura = {
                Color = Color3.fromRGB(152, 0, 252)
            }
        }
    }
}

utility.trail_character = function(Bool)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if Bool then
        if not humanoidRootPart:FindFirstChild("BlaBla") then
            local BlaBla = Instance.new("Trail", humanoidRootPart)
            BlaBla.Name = "BlaBla"
            humanoidRootPart.Material = Enum.Material.Neon

            local attachment0 = Instance.new("Attachment", humanoidRootPart)
            attachment0.Position = Vector3.new(0, 1, 0)

            local attachment1 = Instance.new("Attachment", humanoidRootPart)
            attachment1.Position = Vector3.new(0, -1, 0)

            BlaBla.Attachment0 = attachment0
            BlaBla.Attachment1 = attachment1
            BlaBla.Color = ColorSequence.new(Settings.Visuals.SelfESP.Trail.Color, Settings.Visuals.SelfESP.Trail.Color2) -- Gradient effect
            BlaBla.Lifetime = Settings.Visuals.SelfESP.Trail.LifeTime
            BlaBla.Transparency = NumberSequence.new(0, 0)
            BlaBla.LightEmission = 0.2
            BlaBla.Brightness = 10
            BlaBla.WidthScale = NumberSequence.new{
                NumberSequenceKeypoint.new(0, Settings.Visuals.SelfESP.Trail.Width),
                NumberSequenceKeypoint.new(1, 0)
            }
        end
    else
        for _, child in ipairs(humanoidRootPart:GetChildren()) do
            if child:IsA("Trail") and child.Name == 'BlaBla' then
                child:Destroy()
            end
        end
    end
end

local function onCharacterAdded(character)
    if getgenv().trailEnabled then
        utility.trail_character(true)
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

Auras:AddToggle("TrailToggle", {
    Text = "Trail",
    Default = false,
    Callback = function(state)
        getgenv().trailEnabled = state
        utility.trail_character(state)
    end
}):AddColorPicker("TrailColor", {
    Text = "Trail Color",
    Default = Settings.Visuals.SelfESP.Trail.Color,
    Callback = function(color)
        Settings.Visuals.SelfESP.Trail.Color = color
        if getgenv().trailEnabled then
            utility.trail_character(false)
            utility.trail_character(true)
        end
    end
}):AddColorPicker("TrailColor2", {
    Text = "Trail Color 2",
    Default = Settings.Visuals.SelfESP.Trail.Color2,
    Callback = function(color)
        Settings.Visuals.SelfESP.Trail.Color2 = color
        if getgenv().trailEnabled then
            utility.trail_character(false)
            utility.trail_character(true)
        end
    end
})

Auras:AddSlider("TrailLifetime", {
    Text = "Trail Lifetime",
    Default = 1.6,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Callback = function(value)
        Settings.Visuals.SelfESP.Trail.LifeTime = value
        if getgenv().trailEnabled then
            utility.trail_character(false)
            utility.trail_character(true)
        end
    end
})

local HitEffectModule = {
    Locals = {
        HitEffect = {
            Type = {}
        }
    }
}

local Attachment = Instance.new("Attachment")
HitEffectModule.Locals.HitEffect.Type["Skibidi RedRizz"] = Attachment
local swirl = Instance.new("ParticleEmitter", Attachment)
swirl.Name = "swirl"
swirl.Lifetime = NumberRange.new(2)
swirl.SpreadAngle = Vector2.new(-360, 360)
swirl.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1)})
swirl.LightEmission = 10
swirl.Color = ColorSequence.new(Settings.Visuals.SelfESP.Aura.Color)
swirl.VelocitySpread = -360
swirl.Squash = NumberSequence.new(0)
swirl.Speed = NumberRange.new(0.01)
swirl.Size = NumberSequence.new(7)
swirl.ZOffset = -1
swirl.ShapeInOut = Enum.ParticleEmitterShapeInOut.InAndOut
swirl.Rate = 40
swirl.LockedToPart = true
swirl.Texture = "rbxassetid://10558425570"
swirl.RotSpeed = NumberRange.new(200)
swirl.Orientation = Enum.ParticleOrientation.VelocityPerpendicular

local Bolts = Instance.new("ParticleEmitter", Attachment)
Bolts.Name = "Bolts"
Bolts.Lifetime = NumberRange.new(0.333)
Bolts.LockedToPart = true
Bolts.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.88), NumberSequenceKeypoint.new(0.055, 0.98),
    NumberSequenceKeypoint.new(0.111, 0.17), NumberSequenceKeypoint.new(0.166, 0.39),
    NumberSequenceKeypoint.new(0.222, 0.12), NumberSequenceKeypoint.new(0.277, 0.92),
    NumberSequenceKeypoint.new(0.333, 0.41), NumberSequenceKeypoint.new(0.388, 0.21),
    NumberSequenceKeypoint.new(0.444, 0.78), NumberSequenceKeypoint.new(0.499, 0.23),
    NumberSequenceKeypoint.new(0.555, 0.78), NumberSequenceKeypoint.new(0.610, 0.81),
    NumberSequenceKeypoint.new(0.666, 0.91), NumberSequenceKeypoint.new(0.721, 0.87),
    NumberSequenceKeypoint.new(0.777, 0.41), NumberSequenceKeypoint.new(0.832, 0.30),
    NumberSequenceKeypoint.new(0.888, 0.16), NumberSequenceKeypoint.new(0.943, 0.39),
    NumberSequenceKeypoint.new(0.999, 0.70), NumberSequenceKeypoint.new(1, 1)
})
Bolts.LightEmission = 1
Bolts.Color = ColorSequence.new(Settings.Visuals.SelfESP.Aura.Color)
Bolts.Speed = NumberRange.new(0)
Bolts.Size = NumberSequence.new(4.8)
Bolts.Rate = 12
Bolts.Texture = "rbxassetid://1084955012"
Bolts.Rotation = NumberRange.new(-180, 180)

local Bubble = Instance.new("ParticleEmitter", Attachment)
Bubble.Name = "Bubble"
Bubble.Lifetime = NumberRange.new(1)
Bubble.LockedToPart = true
Bubble.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 1)})
Bubble.LightEmission = 1
Bubble.Color = ColorSequence.new(Settings.Visuals.SelfESP.Aura.Color)
Bubble.Speed = NumberRange.new(0)
Bubble.Size = NumberSequence.new(4)
Bubble.Rate = 6
Bubble.Texture = "rbxassetid://1084955488"
Bubble.Rotation = NumberRange.new(-180, 180)

local function applyAura(auraName)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    Attachment.Parent = humanoidRootPart

    if getgenv().auraEnabled then
        swirl.Enabled = auraName == "Skibidi RedRizz"
        Bolts.Enabled = auraName == "Bolts"
        Bubble.Enabled = auraName == "Bubble"
        humanoidRootPart.Material = Enum.Material.Neon
    else
        swirl.Enabled = false
        Bolts.Enabled = false
        Bubble.Enabled = false
    end
end

local function onCharacterAdded(character)
    if getgenv().auraEnabled then
        applyAura(getgenv().selectedAura or "Skibidi RedRizz")
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

Auras:AddToggle("AuraToggle", {
    Text = "Auras",
    Default = false,
    Callback = function(state)
        getgenv().auraEnabled = state
        applyAura(getgenv().selectedAura or "Skibidi RedRizz")
    end
}):AddColorPicker("AuraColor", {
    Text = "Aura Color",
    Default = Settings.Visuals.SelfESP.Aura.Color,
    Callback = function(color)
        Settings.Visuals.SelfESP.Aura.Color = color
        swirl.Color = ColorSequence.new(color)
        Bolts.Color = ColorSequence.new(color)
        Bubble.Color = ColorSequence.new(color)
        if getgenv().auraEnabled then
            applyAura(getgenv().selectedAura or "Skibidi RedRizz")
        end
    end
})

Auras:AddDropdown("AuraType", {
    Text = "Select Aura",
    Values = {"Skibidi RedRizz", "Bolts", "Bubble"},
    Default = "Bubble",
    Callback = function(selected)
        getgenv().selectedAura = selected
        if getgenv().auraEnabled then
            applyAura(selected)
        end
    end
})

getgenv().envt = Tabs.Visuals:AddRightGroupbox("Environment")
getgenv().Skyboxes = {
    Minecraft = {
        SkyboxBk = "rbxassetid://1876545003",
        SkyboxDn = "rbxassetid://1876544331",
        SkyboxFt = "rbxassetid://1876542941",
        SkyboxLf = "rbxassetid://1876543392",
        SkyboxRt = "rbxassetid://1876543764",
        SkyboxUp = "rbxassetid://1876544642"
    },
   
    PurpleDay = {
        SkyboxBk = "rbxassetid://296908715",
        SkyboxDn = "rbxassetid://296908724",
        SkyboxFt = "rbxassetid://296908740",
        SkyboxLf = "rbxassetid://296908755",
        SkyboxRt = "rbxassetid://296908764",
        SkyboxUp = "rbxassetid://296908769",
    },
    RedNight = {
        SkyboxBk = "rbxassetid://401664839",
        SkyboxDn = "rbxassetid://401664862",
        SkyboxFt = "rbxassetid://401664960",
        SkyboxLf = "rbxassetid://401664881",
        SkyboxRt = "rbxassetid://401664901",
        SkyboxUp = "rbxassetid://401664936",
    },
    Trollge = {
        SkyboxBk = "rbxassetid://6155393905",
        SkyboxDn = "rbxassetid://6155393905",
        SkyboxFt = "rbxassetid://6155393905",
        SkyboxLf = "rbxassetid://6155393905",
        SkyboxRt = "rbxassetid://6155393905",
        SkyboxUp = "rbxassetid://6155393905",
    },
   Night = {
        SkyboxBk = "rbxassetid://48020371",
        SkyboxDn = "rbxassetid://48020144",
        SkyboxFt = "rbxassetid://48020234",
        SkyboxLf = "rbxassetid://48020211",
        SkyboxRt = "rbxassetid://48020254",
        SkyboxUp = "rbxassetid://48020383",
    },
   Space = {
        SkyboxBk = "rbxassetid://149397692",
        SkyboxDn = "rbxassetid://149397686",
        SkyboxFt = "rbxassetid://149397697",
        SkyboxLf = "rbxassetid://149397684",
        SkyboxRt = "rbxassetid://149397688",
        SkyboxUp = "rbxassetid://149397702",
    },
    Default = {
        SkyboxBk = "rbxassetid://6444884337",
        SkyboxDn = "rbxassetid://6444884785",
        SkyboxFt = "rbxassetid://6444884337",
        SkyboxLf = "rbxassetid://6444884337",
        SkyboxRt = "rbxassetid://6444884337",
        SkyboxUp = "rbxassetid://6412503613",
    },
    VibeMorning = {
        SkyboxBk = "rbxassetid://1417494030",
        SkyboxDn = "rbxassetid://1417494146",
        SkyboxFt = "rbxassetid://1417494253",
        SkyboxLf = "rbxassetid://1417494402",
        SkyboxRt = "rbxassetid://1417494499",
        SkyboxUp = "rbxassetid://1417494643",
    },
    VibeNight = {
        SkyboxBk = "rbxassetid://5084575798",
        SkyboxDn = "rbxassetid://5084575916",
        SkyboxFt = "rbxassetid://5103949679",
        SkyboxLf = "rbxassetid://5103948542",
        SkyboxRt = "rbxassetid://5103948784",
        SkyboxUp = "rbxassetid://5084576400",
    },
    PurpleSplash = {
        SkyboxBk = "rbxassetid://8539982183",
        SkyboxDn = "rbxassetid://8539981943",
        SkyboxFt = "rbxassetid://8539981721",
        SkyboxLf = "rbxassetid://8539981424",
        SkyboxRt = "rbxassetid://8539980766",
        SkyboxUp = "rbxassetid://8539981085",
    },
    GreenSpace = {
        SkyboxBk = "rbxassetid://159248188",
        SkyboxDn = "rbxassetid://159248183",
        SkyboxFt = "rbxassetid://159248187",
        SkyboxLf = "rbxassetid://159248173",
        SkyboxRt = "rbxassetid://159248192",
        SkyboxUp = "rbxassetid://159248176",
    },
    Snowy = {
        SkyboxBk = "rbxassetid://155657655",
        SkyboxDn = "rbxassetid://155674246",
        SkyboxFt = "rbxassetid://155657609",
        SkyboxLf = "rbxassetid://155657671",
        SkyboxRt = "rbxassetid://155657619",
        SkyboxUp = "rbxassetid://155674931",
    },
    Spongebob = {
        SkyboxBk = "rbxassetid://10287764626",
        SkyboxDn = "rbxassetid://10287766382",
        SkyboxFt = "rbxassetid://10287764626",
        SkyboxLf = "rbxassetid://10287763421",
        SkyboxRt = "rbxassetid://10287764626",
        SkyboxUp = "rbxassetid://10287767597",
    },
    PinkDay = {
        SkyboxBk = "rbxassetid://271042516",
        SkyboxDn = "rbxassetid://271077243",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxRt = "rbxassetid://271042467",
        SkyboxUp = "rbxassetid://271077958",
    },
    AlienRed = {
        SkyboxBk = "rbxassetid://1012890",
        SkyboxDn = "rbxassetid://1012891",
        SkyboxFt = "rbxassetid://1012887",
        SkyboxLf = "rbxassetid://1012889",
        SkyboxRt = "rbxassetid://1012888",
        SkyboxUp = "rbxassetid://1014449",
    },
    WallsOfAutumn = {
        SkyboxBk = "rbxassetid://7123244709",
        SkyboxDn = "rbxassetid://7123246497",
        SkyboxFt = "rbxassetid://7123255895",
        SkyboxLf = "rbxassetid://7123257992",
        SkyboxRt = "rbxassetid://7123279103",
        SkyboxUp = "rbxassetid://7123281828",
    },
    ColdWinterness = {
        SkyboxBk = "rbxassetid://7123754562",
        SkyboxDn = "rbxassetid://7123756028",
        SkyboxFt = "rbxassetid://7123757422",
        SkyboxLf = "rbxassetid://7123758897",
        SkyboxRt = "rbxassetid://7123760563",
        SkyboxUp = "rbxassetid://7123762364",
    },
    Oblivion = {
        SkyboxBk = "rbxassetid://7123654189",
        SkyboxDn = "rbxassetid://7123657455",
        SkyboxFt = "rbxassetid://7123662047",
        SkyboxLf = "rbxassetid://7123664533",
        SkyboxRt = "rbxassetid://7123666598",
        SkyboxUp = "rbxassetid://7123668994",
    },
    ClassicSky = {
        SkyboxBk = "rbxassetid://672345740",
        SkyboxDn = "rbxassetid://672345828",
        SkyboxFt = "rbxassetid://672345879",
        SkyboxLf = "rbxassetid://672345927",
        SkyboxRt = "rbxassetid://672346006",
        SkyboxUp = "rbxassetid://672346072",
    },
    PurpleNight = {
        SkyboxBk = "rbxassetid://5084575798",
        SkyboxDn = "rbxassetid://5084575916",
        SkyboxFt = "rbxassetid://5103949679",
        SkyboxLf = "rbxassetid://5103948542",
        SkyboxRt = "rbxassetid://5103948784",
        SkyboxUp = "rbxassetid://5084576400",
    },
    PurpleDayClear = {
        SkyboxBk = "rbxassetid://6847607535",
        SkyboxDn = "rbxassetid://6847607977",
        SkyboxFt = "rbxassetid://6847608302",
        SkyboxLf = "rbxassetid://6847608608",
        SkyboxRt = "rbxassetid://6847608986",
        SkyboxUp = "rbxassetid://6847609323",
    },
    YellowDay = {
        SkyboxBk = "rbxassetid://2651432901",
        SkyboxDn = "rbxassetid://2651434974",
        SkyboxFt = "rbxassetid://2651435990",
        SkyboxLf = "rbxassetid://2651436494",
        SkyboxRt = "rbxassetid://2651436979",
        SkyboxUp = "rbxassetid://2651437350",
    },
    MinecraftSky = {
        SkyboxBk = "rbxassetid://8735166756",
        SkyboxDn = "rbxassetid://8735166707",
        SkyboxFt = "rbxassetid://8735231668",
        SkyboxLf = "rbxassetid://8735166755",
        SkyboxRt = "rbxassetid://8735166751",
        SkyboxUp = "rbxassetid://8735166729",
    },
    Sunset = {
        SkyboxBk = "rbxassetid://150939022",
        SkyboxDn = "rbxassetid://150939038",
        SkyboxFt = "rbxassetid://150939047",
        SkyboxLf = "rbxassetid://150939056",
        SkyboxRt = "rbxassetid://150939063",
        SkyboxUp = "rbxassetid://150939082",
    },
    CartoonSky = {
        SkyboxBk = "rbxassetid://6778646360",
        SkyboxDn = "rbxassetid://6778658683",
        SkyboxFt = "rbxassetid://6778648039",
        SkyboxLf = "rbxassetid://6778649136",
        SkyboxRt = "rbxassetid://6778650519",
        SkyboxUp = "rbxassetid://6778658364",
    },
    Anime = {
        SkyboxBk = "rbxassetid://7643700666",
        SkyboxDn = "rbxassetid://7643743687",
        SkyboxFt = "rbxassetid://7644304186",
        SkyboxLf = "rbxassetid://7644288724",
        SkyboxRt = "rbxassetid://7643700819",
        SkyboxUp = "rbxassetid://7643757404",
    },
    HellSky = {
        SkyboxBk = "rbxassetid://437430787",
        SkyboxDn = "rbxassetid://437430804",
        SkyboxFt = "rbxassetid://437430543",
        SkyboxLf = "rbxassetid://437430732",
        SkyboxRt = "rbxassetid://437430747",
        SkyboxUp = "rbxassetid://437430771",
    },
    StarryNight = {
        SkyboxBk = "rbxassetid://8291078911",
        SkyboxDn = "rbxassetid://8291077403",
        SkyboxFt = "rbxassetid://8291081613",
        SkyboxLf = "rbxassetid://8291074004",
        SkyboxRt = "rbxassetid://8291080353",
        SkyboxUp = "rbxassetid://8291075054",
    },
    Omori = {
        SkyboxBk = "rbxassetid://8767416629",
        SkyboxDn = "rbxassetid://8767416629",
        SkyboxFt = "rbxassetid://8767416629",
        SkyboxLf = "rbxassetid://8767416629",
        SkyboxRt = "rbxassetid://8767416629",
        SkyboxUp = "rbxassetid://8767416629",
    },
    c00lkidd = {
        SkyboxBk = "rbxassetid://433381097",
        SkyboxDn = "rbxassetid://433381097",
        SkyboxFt = "rbxassetid://433381097",
        SkyboxLf = "rbxassetid://433381097",
        SkyboxRt = "rbxassetid://433381097",
        SkyboxUp = "rbxassetid://433381097",
    },
    ClearDay = {
        SkyboxBk = "rbxassetid://591058823",
        SkyboxDn = "rbxassetid://591059876",
        SkyboxFt = "rbxassetid://591058104",
        SkyboxLf = "rbxassetid://591057861",
        SkyboxRt = "rbxassetid://591057625",
        SkyboxUp = "rbxassetid://591059642",
    },
    Mountains = {
        SkyboxBk = "http://www.roblox.com/asset/?id=324014980",
        SkyboxDn = "http://www.roblox.com/asset/?id=324015477",
        SkyboxFt = "http://www.roblox.com/asset/?id=324014995",
        SkyboxLf = "http://www.roblox.com/asset/?id=324014679",
        SkyboxRt = "http://www.roblox.com/asset/?id=324015013",
        SkyboxUp = "http://www.roblox.com/asset/?id=324015409",
    },
    Forest = {
        SkyboxBk = "http://www.roblox.com/asset/?id=70945545",
        SkyboxDn = "http://www.roblox.com/asset/?id=70945449",
        SkyboxFt = "http://www.roblox.com/asset/?id=70945487",
        SkyboxLf = "http://www.roblox.com/asset/?id=70945523",
        SkyboxRt = "http://www.roblox.com/asset/?id=70945508",
        SkyboxUp = "http://www.roblox.com/asset/?id=70945531",
    },
    LargeForest = {
        SkyboxBk = "rbxassetid://17428978603",
        SkyboxDn = "rbxassetid://17428977445",
        SkyboxFt = "rbxassetid://17428977114",
        SkyboxLf = "rbxassetid://17428978399",
        SkyboxRt = "rbxassetid://17428976828",
        SkyboxUp = "rbxassetid://17428976669",
    },
    Crimson = {
        SkyboxBk = "rbxassetid://15832429892",
        SkyboxDn = "rbxassetid://15832430998",
        SkyboxFt = "rbxassetid://15832430210",
        SkyboxLf = "rbxassetid://15832430671",
        SkyboxRt = "rbxassetid://15832431198",
        SkyboxUp = "rbxassetid://15832429401",
    },
    PumpkinHill = {
        SkyboxBk = "rbxassetid://11202510597",
        SkyboxDn = "rbxassetid://11202510255",
        SkyboxFt = "rbxassetid://11202509993",
        SkyboxLf = "rbxassetid://11202510806",
        SkyboxRt = "rbxassetid://11202511066",
        SkyboxUp = "rbxassetid://11202509704",
    },
    AnimeIsland = {
        SkyboxBk = "http://www.roblox.com/asset/?id=14753804949",
        SkyboxDn = "http://www.roblox.com/asset/?id=14753795573",
        SkyboxFt = "http://www.roblox.com/asset/?id=14753807625",
        SkyboxLf = "http://www.roblox.com/asset/?id=14753797417",
        SkyboxRt = "http://www.roblox.com/asset/?id=14753799966",
        SkyboxUp = "http://www.roblox.com/asset/?id=14753810287",
    },
    SnowyMountains = {
        SkyboxBk = "http://www.roblox.com/asset/?id=368385273",
        SkyboxDn = "http://www.roblox.com/asset/?id=48015300",
        SkyboxFt = "http://www.roblox.com/asset/?id=368388290",
        SkyboxLf = "http://www.roblox.com/asset/?id=368390615",
        SkyboxRt = "http://www.roblox.com/asset/?id=368385190",
        SkyboxUp = "http://www.roblox.com/asset/?id=48015387",
    },
    Desert = {
        SkyboxBk = "rbxassetid://161319957",
        SkyboxDn = "rbxassetid://161319965",
        SkyboxFt = "rbxassetid://161319970",
        SkyboxLf = "rbxassetid://161319983",
        SkyboxRt = "rbxassetid://161319989",
        SkyboxUp = "rbxassetid://161319996",
    },
    Cloudy = {
        SkyboxBk = "http://www.roblox.com/asset/?id=225469345",
        SkyboxDn = "http://www.roblox.com/asset/?id=225469349",
        SkyboxFt = "http://www.roblox.com/asset/?id=225469359",
        SkyboxLf = "http://www.roblox.com/asset/?id=225469364",
        SkyboxRt = "http://www.roblox.com/asset/?id=225469372",
        SkyboxUp = "http://www.roblox.com/asset/?id=225469380",
    },
    Island = {
        SkyboxBk = "http://www.roblox.com/asset/?id=319343577",
        SkyboxDn = "http://www.roblox.com/asset/?id=319343653",
        SkyboxFt = "http://www.roblox.com/asset/?id=319343666",
        SkyboxLf = "http://www.roblox.com/asset/?id=319343686",
        SkyboxRt = "http://www.roblox.com/asset/?id=319343631",
        SkyboxUp = "http://www.roblox.com/asset/?id=319343614",
    },
    OrangeFog = {
        SkyboxBk = "http://www.roblox.com/asset/?id=458016711",
        SkyboxDn = "http://www.roblox.com/asset/?id=458016826",
        SkyboxFt = "http://www.roblox.com/asset/?id=458016532",
        SkyboxLf = "http://www.roblox.com/asset/?id=458016655",
        SkyboxRt = "http://www.roblox.com/asset/?id=458016782",
        SkyboxUp = "http://www.roblox.com/asset/?id=458016792",
    },
    FadeNight = {
        SkyboxBk = "http://www.roblox.com/asset/?id=16888843486",
        SkyboxDn = "http://www.roblox.com/asset/?id=16888845693",
        SkyboxFt = "http://www.roblox.com/asset/?id=16888848245",
        SkyboxLf = "http://www.roblox.com/asset/?id=16888850949",
        SkyboxRt = "http://www.roblox.com/asset/?id=16888854243",
        SkyboxUp = "http://www.roblox.com/asset/?id=16888857144",
    },
    Office = {
        SkyboxBk = "rbxassetid://658623433",
        SkyboxDn = "rbxassetid://316342560",
        SkyboxFt = "rbxassetid://658625205",
        SkyboxLf = "rbxassetid://658627155",
        SkyboxRt = "rbxassetid://658628504",
        SkyboxUp = "rbxassetid://658632701",
    },
    Spongebob2 = {
        SkyboxBk = "rbxassetid://12049872454",
        SkyboxDn = "rbxassetid://12049872284",
        SkyboxFt = "rbxassetid://12049872181",
        SkyboxLf = "rbxassetid://12049872074",
        SkyboxRt = "rbxassetid://12049871884",
        SkyboxUp = "rbxassetid://12049871774",
    },
    PurpleFog = {
        SkyboxBk = "http://www.roblox.com/asset/?id=17279854976",
        SkyboxDn = "http://www.roblox.com/asset/?id=17279856318",
        SkyboxFt = "http://www.roblox.com/asset/?id=17279858447",
        SkyboxLf = "http://www.roblox.com/asset/?id=17279860360",
        SkyboxRt = "http://www.roblox.com/asset/?id=17279862234",
        SkyboxUp = "http://www.roblox.com/asset/?id=17279864507",
    },
    EarthSpace = {
        SkyboxBk = "rbxassetid://15753305495",
        SkyboxDn = "rbxassetid://15753362674",
        SkyboxFt = "rbxassetid://15753305823",
        SkyboxLf = "rbxassetid://15753310707",
        SkyboxRt = "rbxassetid://15753304774",
        SkyboxUp = "rbxassetid://15753304473",
    },
   
    GreenCloudy = {
        SkyboxBk = "rbxassetid://921882045",
        SkyboxDn = "rbxassetid://921881907",
        SkyboxFt = "rbxassetid://921882121",
        SkyboxLf = "rbxassetid://921881811",
        SkyboxRt = "rbxassetid://921881989",
        SkyboxUp = "rbxassetid://921882259",
    },
    SummerDay = {
        SkyboxBk = "http://www.roblox.com/asset/?version=1&id=135483466",
        SkyboxDn = "http://www.roblox.com/asset/?version=1&id=135483484",
        SkyboxFt = "http://www.roblox.com/asset/?version=1&id=135483461",
        SkyboxLf = "http://www.roblox.com/asset/?version=1&id=135483495",
        SkyboxRt = "http://www.roblox.com/asset/?version=1&id=135483499",
        SkyboxUp = "http://www.roblox.com/asset/?version=1&id=135483475",
    },
    SnowyPlains = {
        SkyboxBk = "http://www.roblox.com/asset/?id=155657655",
        SkyboxDn = "http://www.roblox.com/asset/?id=155674246",
        SkyboxFt = "http://www.roblox.com/asset/?id=155657609",
        SkyboxLf = "http://www.roblox.com/asset/?id=155657671",
        SkyboxRt = "http://www.roblox.com/asset/?id=155657619",
        SkyboxUp = "http://www.roblox.com/asset/?id=155674931",
    },
    Underwater = {
        SkyboxBk = "http://www.roblox.com/asset/?id=227635868",
        SkyboxDn = "http://www.roblox.com/asset/?id=227635921",
        SkyboxFt = "http://www.roblox.com/asset/?id=227635954",
        SkyboxLf = "http://www.roblox.com/asset/?id=227635974",
        SkyboxRt = "http://www.roblox.com/asset/?id=227635990",
        SkyboxUp = "http://www.roblox.com/asset/?id=227636031",
    },
    BlueAbyss = {
        SkyboxBk = "rbxassetid://16269815885",
        SkyboxDn = "rbxassetid://16269839652",
        SkyboxFt = "rbxassetid://16269798011",
        SkyboxLf = "rbxassetid://16269813852",
        SkyboxRt = "rbxassetid://16269814948",
        SkyboxUp = "rbxassetid://16269829700",
    },
    Poison = {
        SkyboxBk = "rbxassetid://1370716695",
        SkyboxDn = "rbxassetid://1370716766",
        SkyboxFt = "rbxassetid://1370716833",
        SkyboxLf = "rbxassetid://1370716898",
        SkyboxRt = "rbxassetid://1370716955",
        SkyboxUp = "rbxassetid://1370717024",
    },
    BlueSpace = {
        SkyboxBk = "rbxassetid://1127563035",
        SkyboxDn = "rbxassetid://1127563006",
        SkyboxFt = "rbxassetid://1127563026",
        SkyboxLf = "rbxassetid://1127563216",
        SkyboxRt = "rbxassetid://1127563115",
        SkyboxUp = "rbxassetid://1127562999",
    },
    AnimeMountains = {
        SkyboxBk = "http://www.roblox.com/asset/?id=12849370744",
        SkyboxDn = "http://www.roblox.com/asset/?id=12849378890",
        SkyboxFt = "http://www.roblox.com/asset/?id=12849390276",
        SkyboxLf = "http://www.roblox.com/asset/?id=12849405549",
        SkyboxRt = "http://www.roblox.com/asset/?id=12849398428",
        SkyboxUp = "http://www.roblox.com/asset/?id=12849426002",
    },
    PinkGradient = {
        SkyboxBk = "http://www.roblox.com/asset/?id=5371541816",
        SkyboxDn = "http://www.roblox.com/asset/?id=5371541154",
        SkyboxFt = "http://www.roblox.com/asset/?id=5371541816",
        SkyboxLf = "http://www.roblox.com/asset/?id=5371541816",
        SkyboxRt = "http://www.roblox.com/asset/?id=5371541816",
        SkyboxUp = "http://www.roblox.com/asset/?id=5371540604",
    },
    YellowGradient = {
        SkyboxBk = "http://www.roblox.com/asset/?id=159005370",
        SkyboxDn = "rbxassetid://858422412",
        SkyboxFt = "http://www.roblox.com/asset/?id=159005370",
        SkyboxLf = "http://www.roblox.com/asset/?id=159005370",
        SkyboxRt = "http://www.roblox.com/asset/?id=159005370",
        SkyboxUp = "http://www.roblox.com/asset/?id=159006363",
    },
    BlueGradient = {
        SkyboxBk = "http://www.roblox.com/asset/?id=4628466090",
        SkyboxDn = "http://www.roblox.com/asset/?id=4628471901",
        SkyboxFt = "http://www.roblox.com/asset/?id=4628466090",
        SkyboxLf = "http://www.roblox.com/asset/?id=4628466090",
        SkyboxRt = "http://www.roblox.com/asset/?id=4628466090",
        SkyboxUp = "http://www.roblox.com/asset/?id=4628472152",
    },
    GreenNebula = {
        SkyboxBk = "http://www.roblox.com/asset/?id=47974894",
        SkyboxDn = "http://www.roblox.com/asset/?id=47974690",
        SkyboxFt = "http://www.roblox.com/asset/?id=47974821",
        SkyboxLf = "http://www.roblox.com/asset/?id=47974776",
        SkyboxRt = "http://www.roblox.com/asset/?id=47974859",
        SkyboxUp = "http://www.roblox.com/asset/?id=47974909",
    },
    OrangeGradient = {
        SkyboxBk = "rbxassetid://6902754982",
        SkyboxDn = "rbxassetid://6902795826",
        SkyboxFt = "rbxassetid://6902754982",
        SkyboxLf = "rbxassetid://6902754982",
        SkyboxRt = "rbxassetid://6902754982",
        SkyboxUp = "rbxassetid://6902796078",
    },
    GreenAurora = {
        SkyboxBk = "http://www.roblox.com/asset/?id=16563478983",
        SkyboxDn = "http://www.roblox.com/asset/?id=16563481302",
        SkyboxFt = "http://www.roblox.com/asset/?id=16563484084",
        SkyboxLf = "http://www.roblox.com/asset/?id=16563485362",
        SkyboxRt = "http://www.roblox.com/asset/?id=16563487078",
        SkyboxUp = "http://www.roblox.com/asset/?id=16563489821",
    },
}

local skyboxNames = {}
for k in pairs(getgenv().Skyboxes) do
    table.insert(skyboxNames, k)
end
table.sort(skyboxNames)

local selectedSkybox = "Default"
local customSkyboxEnabled = false
local originalSkyProperties = {}
local lighting = game:GetService("Lighting")
if lighting:FindFirstChild("Sky") then
    local sky = lighting.Sky
    originalSkyProperties = {
        SkyboxBk = sky.SkyboxBk,
        SkyboxDn = sky.SkyboxDn,
        SkyboxFt = sky.SkyboxFt,
        SkyboxLf = sky.SkyboxLf,
        SkyboxRt = sky.SkyboxRt,
        SkyboxUp = sky.SkyboxUp
    }
end

local function applySkybox(name)
    if not getgenv().Skyboxes[name] then return end
    local sb = getgenv().Skyboxes[name]
    local sky = lighting:FindFirstChild("Sky") or Instance.new("Sky", lighting)
    sky.SkyboxBk = sb.SkyboxBk
    sky.SkyboxDn = sb.SkyboxDn
    sky.SkyboxFt = sb.SkyboxFt
    sky.SkyboxLf = sb.SkyboxLf
    sky.SkyboxRt = sb.SkyboxRt
    sky.SkyboxUp = sb.SkyboxUp
end

local function restoreOriginalSky()
    local sky = lighting:FindFirstChild("Sky")
    if sky and next(originalSkyProperties) ~= nil then
        sky.SkyboxBk = originalSkyProperties.SkyboxBk
        sky.SkyboxDn = originalSkyProperties.SkyboxDn
        sky.SkyboxFt = originalSkyProperties.SkyboxFt
        sky.SkyboxLf = originalSkyProperties.SkyboxLf
        sky.SkyboxRt = originalSkyProperties.SkyboxRt
        sky.SkyboxUp = originalSkyProperties.SkyboxUp
    end
end

local SkyboxGroup = Tabs.Visuals:AddRightGroupbox('Skybox')

SkyboxGroup:AddDropdown("SkyboxSelect", {
    Values = skyboxNames,
    Default = "Default",
    Multi = false,
    Text = "Select Skybox",
    Callback = function(Value)
        selectedSkybox = Value
        if customSkyboxEnabled then
            applySkybox(selectedSkybox)
        end
    end
})

SkyboxGroup:AddToggle("CustomSkyboxToggle", {
    Text = "Custom Skybox",
    Default = false,
    Callback = function(Value)
        customSkyboxEnabled = Value
        if Value then
            applySkybox(selectedSkybox)
        else
            restoreOriginalSky()
        end
    end
})

local skyboxLoop = RunService.Heartbeat:Connect(function()
    if customSkyboxEnabled then
        applySkybox(selectedSkybox)
    end
end)
envt:AddToggle('DayToggle', {
    Text = 'Daytime',
    Default = false,
    Tooltip = 'Always be day',
    Callback = function(state)
        if state then
            connection = RunService.Heartbeat:Connect(function()
                Lighting.TimeOfDay = "14:00:00"
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            Lighting.TimeOfDay = tostring(math.floor((tick() % 86400) / 3600)) .. ":00:00"
        end
    end
})

envt:AddToggle('NoFogToggle', {
    Text = 'No Fog',
    Default = false,
    Tooltip = 'This removes any kind of Fog from the game',
    Callback = function(Value)
        local lighting = game:GetService("Lighting")

        if Value then
            if not _G.FogRemovalExecuted then
                _G.OriginalFogSettings = {
                    FogEnd = lighting.FogEnd,
                    FogStart = lighting.FogStart
                }

                lighting.FogEnd = 100000
                lighting.FogStart = 0

                local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")
                if atmosphere then
                    atmosphere:Destroy()
                end

                _G.FogRemovalExecuted = true
            end
        else
            if _G.FogRemovalExecuted then
                lighting.FogEnd = _G.OriginalFogSettings.FogEnd
                lighting.FogStart = _G.OriginalFogSettings.FogStart
                _G.FogRemovalExecuted = false
            end
        end
        print('[cb] NoFogToggle changed to:', Value)
    end
})

local BrightnessValue = 5

envt:AddToggle('BrightToggle', {
    Text = 'Full Bright',
    Default = false,
    Tooltip = 'Increases brightness',
    Callback = function(Value)
        if not _G.FullBrightExecuted then
            _G.NormalLightingSettings = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime
            }

            local function setLightingProperties()
                Lighting.Brightness = BrightnessValue
                Lighting.ClockTime = 12
            end

            setLightingProperties()

            Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
                if _G.FullBrightEnabled and Lighting.Brightness ~= BrightnessValue then
                    Lighting.Brightness = BrightnessValue
                end
            end)

            Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
                if _G.FullBrightEnabled and Lighting.ClockTime ~= 12 then
                    Lighting.ClockTime = 12
                end
            end)

            task.spawn(function()
                local LastValue = Value
                while task.wait() do
                    if _G.FullBrightEnabled ~= LastValue then
                        if not _G.FullBrightEnabled then
                            Lighting.Brightness = _G.NormalLightingSettings.Brightness
                            Lighting.ClockTime = _G.NormalLightingSettings.ClockTime
                        else
                            setLightingProperties()
                        end
                        LastValue = _G.FullBrightEnabled
                    end
                end
            end)

            _G.FullBrightExecuted = true
        end

        _G.FullBrightEnabled = Value
        if Value then
            Lighting.Brightness = BrightnessValue
        else
            Lighting.Brightness = _G.NormalLightingSettings.Brightness
        end
    end
})
getgenv().Lighting = game:GetService("Lighting")

-- Get current game values as defaults
getgenv().DefaultFogStart = Lighting.FogStart
getgenv().DefaultFogEnd = Lighting.FogEnd
getgenv().DefaultFogColor = Lighting.FogColor
getgenv().DefaultAmbient = Lighting.Ambient
getgenv().DefaultTechnology = Lighting.Technology.Name

envt:AddToggle('FogToggle', {
    Text = 'Fog Changer',
    Default = false,

    Callback = function(Value)
        if Value then
            Lighting.FogEnd = getgenv().FogEnd or DefaultFogEnd
            Lighting.FogStart = getgenv().FogStart or DefaultFogStart
        else
            Lighting.FogEnd = DefaultFogEnd
            Lighting.FogStart = DefaultFogStart
            Lighting.FogColor = DefaultFogColor
        end
    end
}):AddColorPicker('FogColor', {
    Default = DefaultFogColor,
    Title = 'Fog Color',

    Callback = function(Value)
        Lighting.FogColor = Value
    end
})

envt:AddSlider('FogStart', {
    Text = 'Fog Start',
    Default = DefaultFogStart,
    Min = 0,
    Max = 1000,
    Rounding = 1,

    Callback = function(Value)
        getgenv().FogStart = Value
        Lighting.FogStart = Value
    end
})

envt:AddSlider('FogEnd', {
    Text = 'Fog End',
    Default = DefaultFogEnd,
    Min = 10,
    Max = 10000,
    Rounding = 1,

    Callback = function(Value)
        getgenv().FogEnd = Value
        Lighting.FogEnd = Value
    end
})

envt:AddToggle('AmbientToggle', {
    Text = 'Ambient',
    Default = false,

    Callback = function(Value)
        if Value then
            Lighting.Ambient = getgenv().AmbientColor or DefaultAmbient
        else
            Lighting.Ambient = DefaultAmbient
        end
    end
}):AddColorPicker('AmbientColor', {
    Default = DefaultAmbient,
    Title = 'Ambient Color',

    Callback = function(Value)
        getgenv().AmbientColor = Value
        Lighting.Ambient = Value
    end
})

envt:AddDropdown('LightingTech', {
    Text = 'Technology',
    Values = {'Voxel', 'Compatibility', 'ShadowMap', 'Future'},
    Default = table.find({'Voxel', 'Compatibility', 'ShadowMap', 'Future'}, DefaultTechnology) or 1,

    Callback = function(Value)
        Lighting.Technology = Enum.Technology[Value]
    end
})


getgenv().walkSpeedEnabled, getgenv().jumpPowerEnabled, getgenv().cframeSpeedEnabled = false, false, false
getgenv().walkSpeedKeybindActive, getgenv().cframeSpeedKeybindActive = false, false
getgenv().walkSpeed, getgenv().jumpPower, getgenv().cframeSpeed = 16, 50, 10

local uhhh = Tabs.Character:AddLeftGroupbox('Movement')

uhhh:AddToggle('CFrameSpeedToggle', {
    Text = 'cframe',
    Default = false,
    Callback = function(state)
        getgenv().cframeSpeedEnabled = state
        if not state then getgenv().cframeSpeedKeybindActive = false end
    end,
}):AddKeyPicker('CFrameSpeedKeybind', {
    Default = 'T',
    Text = 'Cframe',
    Mode = 'Toggle',
    Callback = function(state)
        if game:GetService("UserInputService"):GetFocusedTextBox() then return end
        if getgenv().cframeSpeedEnabled then getgenv().cframeSpeedKeybindActive = state end
    end,
})

uhhh:AddToggle('WalkSpeedToggle', {
    Text = 'WalkSpeed',
    Default = false,
    Callback = function(state)
        getgenv().walkSpeedEnabled = state
        if not state then getgenv().walkSpeedKeybindActive = false end
    end,
}):AddKeyPicker('WalkSpeedKeybind', {
    Default = 'T',
    Text = 'Velocity',
    Mode = 'Toggle',
    Callback = function(state)
        if game:GetService("UserInputService"):GetFocusedTextBox() then return end
        if getgenv().walkSpeedEnabled then getgenv().walkSpeedKeybindActive = state end
    end,
})

uhhh:AddSlider('WalkSpeedSlider', {
    Text = 'WalkSpeed',
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        getgenv().walkSpeed = value
    end,
})

uhhh:AddSlider('JumpPowerSlider', {
    Text = 'JumpPower',
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        getgenv().jumpPower = value
    end,
})

uhhh:AddSlider('CFrameSpeedSlider', {
    Text = 'Speed',
    Default = 10,
    Min = 1,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        getgenv().cframeSpeed = value
    end,
})

game:GetService('RunService').RenderStepped:Connect(function()
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChild('Humanoid')
    if not humanoid then return end
    
    humanoid.WalkSpeed = getgenv().walkSpeedEnabled and getgenv().walkSpeedKeybindActive and getgenv().walkSpeed or 16
    humanoid.JumpPower = getgenv().walkSpeedEnabled and getgenv().walkSpeedKeybindActive and getgenv().jumpPower or 50
end)

task.spawn(function()
    while task.wait(0) do
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if getgenv().cframeSpeedEnabled and getgenv().cframeSpeedKeybindActive and character and humanoid and humanoid.MoveDirection.Magnitude > 0 then
            character:TranslateBy(humanoid.MoveDirection * getgenv().cframeSpeed * task.wait() * 3)
        end
    end
end)


getgenv().FlightKeybind = Enum.KeyCode.X
getgenv().FlySpeed = 50
getgenv().FlightEnabled = false
getgenv().Flying = false

local function CreateCore()
    if workspace:FindFirstChild("Core") then workspace.Core:Destroy() end
    local Core = Instance.new("Part")
    Core.Name = "Core"
    Core.Size = Vector3.new(0.05, 0.05, 0.05)
    Core.CanCollide = false
    Core.Transparency = 1
    Core.Parent = workspace
    local Weld = Instance.new("Weld", Core)
    Weld.Part0 = Core
    Weld.Part1 = LocalPlayer.Character.HumanoidRootPart
    Weld.C0 = CFrame.new(0, 0, 0)
    return Core
end

local function StartFly()
    if getgenv().Flying then return end
    getgenv().Flying = true
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
    local Core = CreateCore()
    local BV = Instance.new("BodyVelocity", Core)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.zero
    local BG = Instance.new("BodyGyro", Core)
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.P = 9e4
    BG.CFrame = Core.CFrame
    RunService.RenderStepped:Connect(function()
        if not getgenv().Flying then return end
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        BV.Velocity = moveDirection * getgenv().FlySpeed
        BG.CFrame = camera.CFrame
    end)
end

local function StopFly()
    if not getgenv().Flying then return end
    getgenv().Flying = false
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
    if workspace:FindFirstChild("Core") then workspace.Core:Destroy() end
end

uhhh:AddToggle("FlightToggle", {
    Text = "Flight",
    Default = false,
    Callback = function(state)
        getgenv().FlightEnabled = state
        if not state then StopFly() end
    end
}):AddKeyPicker("FlightKeybindPicker", {
    Default = "X",
    Text = "Flight",
    Mode = "Toggle",
    Callback = function(state)
        if UserInputService:GetFocusedTextBox() then return end
        if state and getgenv().FlightEnabled then
            StartFly()
        else
            StopFly()
        end
    end
})

uhhh:AddSlider("FlySpeedSlider", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 5000,
    Rounding = 0,
    Callback = function(value)
        getgenv().FlySpeed = value
    end
})

getgenv().SpinbotEnabled = false
getgenv().SpinSpeed = 10

local function toggleSpinbot(state)
    if state then
        if not getgenv().SpinConnection then
            getgenv().SpinConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and not getgenv().Flying then
                    LocalPlayer.Character.Humanoid.AutoRotate = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(getgenv().SpinSpeed), 0)
                end
            end)
        end
    else
        if getgenv().SpinConnection then
            getgenv().SpinConnection:Disconnect()
            getgenv().SpinConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().SpinbotEnabled then
        toggleSpinbot(true)
    end
end)

uhhh:AddToggle('SpinbotToggle', {
    Text = 'Spinbot',
    Default = false,
    Callback = function(state)
        getgenv().SpinbotEnabled = state
        toggleSpinbot(state)
    end,
}):AddKeyPicker('SpinbotKeybind', {
    Default = 'N',
    Text = 'Spinbot',
    Mode = 'Toggle',
    Callback = function(state)
        if not UserInputService:GetFocusedTextBox() and getgenv().SpinbotEnabled then
            toggleSpinbot(state)
        end
    end,
})

uhhh:AddSlider('SpinSpeedSlider', {
    Text = 'Spin Speed',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(value)
        getgenv().SpinSpeed = value
    end,
})

local AnimationSpeed = 1

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://10714340543"

local animationTrack
local isPlaying = false
local flossEnabled = false

local function loadAnimationTrack(character)
    local humanoid = character:WaitForChild("Humanoid")
    animationTrack = humanoid:LoadAnimation(animation)
    animationTrack.Looped = true
    animationTrack.Priority = Enum.AnimationPriority.Action
    
    if flossEnabled then
        task.wait(0.6)
        animationTrack:Play()
        animationTrack:AdjustSpeed(AnimationSpeed)
        isPlaying = true
    end
end

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    loadAnimationTrack(character)
end)

if game:GetService("Players").LocalPlayer.Character then
    loadAnimationTrack(game:GetService("Players").LocalPlayer.Character)
end

local stutz = Tabs.Character:AddRightGroupbox('Misc')

stutz:AddToggle("FlossToggle", {
    Text = "floss",
    Default = false,
    Callback = function(state)
        flossEnabled = state
        if state and animationTrack then
            animationTrack:Play()
            animationTrack:AdjustSpeed(AnimationSpeed)
            isPlaying = true
        elseif not state and animationTrack then
            animationTrack:Stop()
            isPlaying = false
        end
    end
}):AddKeyPicker("FlossKeybindPicker", {
    Default = "V",
    Text = "Floss",
    Mode = "Toggle",
    Callback = function(key)
        if UserInputService:GetFocusedTextBox() then return end
        if flossEnabled and animationTrack then
            if isPlaying then
                animationTrack:Stop()
            else
                animationTrack:Play()
                animationTrack:AdjustSpeed(AnimationSpeed)
            end
            isPlaying = not isPlaying
        end
    end
})

stutz:AddToggle("NoClipToggle", {
    Text = "NoClip",
    Default = false,
    Callback = function(state)
        noClipEnabled = state
    end
}):AddKeyPicker("NoClipKeybindPicker", {
    Default = "J",
    Text = "NoClip",
    Mode = "Toggle",
    Callback = function(state)
        if noClipEnabled then
            local character = game:GetService("Players").LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and not part.Name:match("Arm") and not part.Name:match("Leg") then
                        part.CanCollide = state
                    end
                end
            end
        end
    end
})


DesyncBox = Tabs.Character:AddRightGroupbox("Anti Aim")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

desync_setback = Instance.new("Part")
desync_setback.Name = "Desync Setback"
desync_setback.Parent = workspace
desync_setback.Size = Vector3.new(2, 2, 1)
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1

desync = {
    enabled = false,
    mode = "Void",
    teleportPosition = Vector3.new(0, 0, 0),
    old_position = nil,
    voidSpamActive = false,
    toggleEnabled = false
}

function resetCamera()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

function toggleDesync(state)
    desync.enabled = state
    if desync.enabled then
        workspace.CurrentCamera.CameraSubject = desync_setback
        Library:Notify("Desync Enabled '" .. desync.mode .. "' Madlol $", 2)
    else
        resetCamera()
        Library:Notify("Desync Disabled '" .. desync.mode .. "' Madlol  $", 2)
    end
end

function setDesyncMode(mode)
    desync.mode = mode
end

DesyncBox:AddToggle('DesyncToggle', {
    Text = 'Anti Aim',
    Default = false,
    Callback = function(state)
        desync.toggleEnabled = state
        if not state then
            toggleDesync(false)
        end
    end,
}):AddKeyPicker('DesyncKeybind', {
    Default = 'V',
    Text = 'Desync',
    Mode = 'Toggle',
    Callback = function(state)
        if not desync.toggleEnabled or UserInputService:GetFocusedTextBox() then return end
        toggleDesync(not desync.enabled)
    end,
})

DesyncBox:AddDropdown('DesyncMethodDropdown', {
    Values = {"Destroy Cheaters", "Underground", "Void Spam", "Void"},
    Default = "Void",
    Multi = false,
    Text = 'Method',
    Callback = function(selected)
        setDesyncMode(selected)
    end
})

RunService.Heartbeat:Connect(function()
    if desync.enabled and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            desync.old_position = rootPart.CFrame

            if desync.mode == "Destroy Cheaters" then
                desync.teleportPosition = Vector3.new(11223344556677889900, 1, 1)

            elseif desync.mode == "Underground" then
                desync.teleportPosition = rootPart.Position - Vector3.new(0, 12, 0)

            elseif desync.mode == "Void Spam" then
                desync.teleportPosition = math.random(1, 2) == 1 and desync.old_position.Position or Vector3.new(
                    math.random(10000, 50000),
                    math.random(10000, 50000),
                    math.random(10000, 50000)
                )

            elseif desync.mode == "Void" then
                desync.teleportPosition = Vector3.new(
                    rootPart.Position.X + math.random(-444444, 444444),
                    rootPart.Position.Y + math.random(-444444, 444444),
                    rootPart.Position.Z + math.random(-44444, 44444)
                )
            end

            if desync.mode ~= "Rotation" then
                rootPart.CFrame = CFrame.new(desync.teleportPosition)
                workspace.CurrentCamera.CameraSubject = desync_setback

                RunService.RenderStepped:Wait()

                desync_setback.CFrame = desync.old_position * CFrame.new(0, rootPart.Size.Y / 2 + 0.5, 0)
                rootPart.CFrame = desync.old_position
            end
        end
    end
end)

local antifling = nil

stutz:AddToggle("AntiflingToggle", {
    Text = "Antifling",
    Default = false,
    Callback = function(state)
        if state then
            antifling = game:GetService("RunService").Stepped:Connect(function()
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        for _, v in pairs(player.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if antifling then
                antifling:Disconnect()
                antifling = nil
            end
        end
    end
})


getgenv().RemoveShootAnimationsEnabled = false
getgenv().ShootAnimationIds = {
    ["rbxassetid://2807049953"] = true, 
    ["rbxassetid://2809413000"] = true, 
    ["rbxassetid://2809419094"] = true,  
    ["rbxassetid://507768375"] = true,
    ["rbxassetid://507755388"] = true,
    ["rbxassetid://2807049953"] = true,
    ["rbxassetid://2877910736"] = true 
}

getgenv().StopAnimationTracks = function(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if getgenv().ShootAnimationIds[track.Animation.AnimationId] then
                track:Stop()
            end
        end
    end
end

getgenv().MonitorCharacter = function(character)
    character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("AnimationTrack") and getgenv().RemoveShootAnimationsEnabled then
            if getgenv().ShootAnimationIds[descendant.Animation.AnimationId] then
                descendant:Stop()
            end
        end
    end)
end

getgenv().MonitorPlayers = function()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
        getgenv().StopAnimationTracks(character)
        getgenv().MonitorCharacter(character)

        player.CharacterAdded:Connect(function(newCharacter)
            getgenv().StopAnimationTracks(newCharacter)
            getgenv().MonitorCharacter(newCharacter)
        end)
    end

    game:GetService("Players").PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            getgenv().StopAnimationTracks(character)
            getgenv().MonitorCharacter(character)
        end)
    end)
end

getgenv().MonitorAnimations = function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().RemoveShootAnimationsEnabled then
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                local character = player.Character
                if character then
                    getgenv().StopAnimationTracks(character)
                end
            end
        end
    end)
end

GunMods:AddToggle("AntiflingToggle", {
    Text = "remove shoot animations",
    Default = false,
    Callback = function(enabled)
        getgenv().RemoveShootAnimationsEnabled = enabled
        if enabled then
            getgenv().MonitorPlayers()
            task.spawn(getgenv().MonitorAnimations)
        end
    end
})


getgenv().Test = false
getgenv().SoundId = "6899466638"
getgenv().ToolEnabled = false

getgenv().CreateTool = function()
    getgenv().Tool = Instance.new("Tool")
    getgenv().Tool.RequiresHandle = false
    getgenv().Tool.Name = "[Kick]"
    getgenv().Tool.TextureId = "rbxassetid://483225199"
    getgenv().Animation = Instance.new("Animation")
    getgenv().Animation.AnimationId = "rbxassetid://2788306916"
    getgenv().Tool.Activated:Connect(function()
        getgenv().Test = true
        getgenv().Player = game.Players.LocalPlayer
        getgenv().Character = getgenv().Player.Character or getgenv().Player.CharacterAdded:Wait()
        getgenv().Humanoid = getgenv().Character:FindFirstChild("Humanoid")
        if getgenv().Humanoid then
            getgenv().AnimationTrack = getgenv().Humanoid:LoadAnimation(getgenv().Animation)
            getgenv().AnimationTrack:AdjustSpeed(3.4)
            getgenv().AnimationTrack:Play()
        end
        task.wait(0.6)
        getgenv().Boombox = game.Players.LocalPlayer.Backpack:FindFirstChild("[Boombox]")
        if getgenv().Boombox then
            getgenv().Boombox.Parent = game.Players.LocalPlayer.Character
            game:GetService("ReplicatedStorage").MainEvent:FireServer("Boombox", tonumber(getgenv().SoundId))
            getgenv().Boombox.RequiresHandle = false
            getgenv().Boombox.Parent = game.Players.LocalPlayer.Backpack
            task.wait(1)
            game:GetService("ReplicatedStorage").MainEvent:FireServer("BoomboxStop")
        else
            getgenv().Sound = Instance.new("Sound", workspace)
            getgenv().Sound.SoundId = "rbxassetid://" .. getgenv().SoundId
            getgenv().Sound:Play()
            task.wait(1)
            getgenv().Sound:Stop()
        end
        wait(1.4)
        getgenv().Test = false
    end)
    getgenv().Tool.Parent = game.Players.LocalPlayer:WaitForChild("Backpack")
end

getgenv().RemoveTool = function()
    getgenv().Player = game.Players.LocalPlayer
    getgenv().Tool = getgenv().Player.Backpack:FindFirstChild("[Kick]") or getgenv().Player.Character:FindFirstChild("[Kick]")
    if getgenv().Tool then getgenv().Tool:Destroy() end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().Test then
        getgenv().Character = game.Players.LocalPlayer.Character
        if not getgenv().Character then return end
        getgenv().HumanoidRootPart = getgenv().Character:FindFirstChild("HumanoidRootPart")
        if not getgenv().HumanoidRootPart then return end
        getgenv().originalVelocity = getgenv().HumanoidRootPart.Velocity
        getgenv().HumanoidRootPart.Velocity = Vector3.new(getgenv().HumanoidRootPart.CFrame.LookVector.X * 800, 800, getgenv().HumanoidRootPart.CFrame.LookVector.Z * 800)
        game:GetService("RunService").RenderStepped:Wait()
        getgenv().HumanoidRootPart.Velocity = getgenv().originalVelocity
    end
end)

local stuffs = Tabs.Misc:AddRightGroupbox("Stuff")

stuffs:AddToggle("ToolToggle", {
    Text = "Pqnd4 kick",
    Default = false,
    Callback = function(state)
        getgenv().ToolEnabled = state
        if state then getgenv().CreateTool() else getgenv().RemoveTool() end
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().ToolEnabled then task.wait(1) getgenv().CreateTool() end
end)

local Modifications = Tabs.Misc:AddRightGroupbox("Modifications")

local antiStompActive = true
local flashbackActive = false
local lastPosition = nil

local function startAntiStomp()
    local RunService = game:GetService("RunService")

    local function checkAndKill()
        local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = chr:WaitForChild("Humanoid", 5)
        local bodyEffects = chr:WaitForChild("BodyEffects", 5)

        if not bodyEffects or not hum then
            warn("BodyEffects or Humanoid not found in the character!")
            return
        end

        local koValue = bodyEffects:WaitForChild("K.O", 5)
        if not koValue then
            warn("K.O value not found!")
            return
        end

        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not antiStompActive then
                connection:Disconnect()
                return
            end

            if koValue.Value == true and hum.Health > 0 then
                if flashbackActive then
                    lastPosition = chr:GetPrimaryPartCFrame()
                end
                hum.Health = 0
            end
        end)
    end

    checkAndKill()

    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        if antiStompActive then
            checkAndKill()

            if flashbackActive and lastPosition then
                local rootPart = newCharacter:WaitForChild("HumanoidRootPart", 5)
                if rootPart then
                    while (rootPart.Position - lastPosition.Position).Magnitude > 5 do
                        rootPart.CFrame = lastPosition
                        task.wait()
                    end
                end
                lastPosition = nil
            end
        end
    end)
end
startAntiStomp()
Modifications:AddToggle('AntiStomp', {
    Text = 'Anti Stomp',
    Default = true,
    Callback = function(state)
        antiStompActive = state
        if state then
            startAntiStomp()
        end
    end,
})

Modifications:AddToggle('Flashback', {
    Text = 'Flashback',
    Default = false,
    Callback = function(state)
        flashbackActive = state
    end,
})

getgenv().XZQW_ENABLED = false
getgenv().HIDE_ANIMATIONS = false
getgenv().YRWL_Connection___ = {}
getgenv().BlockedAnimations = {
    "rbxassetid://2788289281",
    "rbxassetid://507766388",
    "rbxassetid://2788292075",
    "rbxassetid://278829075",
    "rbxassetid://4798175381",
    "rbxassetid://2953512033",
    "rbxassetid://2788309982",
    "rbxassetid://2788312709",
    "rbxassetid://2788313790",
    "rbxassetid://2788316350",
    "rbxassetid://2788315673",
    "rbxassetid://2788314837"
}


ReplicatedStorage:WaitForChild("ClientAnimations").Block.AnimationId = "rbxassetid://0"

local function startAutoBlock()
    table.insert(getgenv().YRWL_Connection___, RunService.Stepped:Connect(function()
        if getgenv().XZQW_ENABLED then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("BodyEffects") then
                local bodyEffects = character.BodyEffects
                if bodyEffects:FindFirstChild("Block") then
                    bodyEffects.Block:Destroy()
                end
                local tool = character:FindFirstChildWhichIsA("Tool")
                if tool and tool:FindFirstChild("Ammo") then
                    ReplicatedStorage.MainEvent:FireServer("Block", false)
                else
                    ReplicatedStorage.MainEvent:FireServer("Block", true)
                    wait()
                    ReplicatedStorage.MainEvent:FireServer("Block", false)
                end
            end
        end
    end))
end

local function stopAutoBlock()
    for _, connection in ipairs(getgenv().YRWL_Connection___) do
        connection:Disconnect()
    end
    table.clear(getgenv().YRWL_Connection___)
end

local function startHidingAnimations()
    RunService:BindToRenderStep("Hide - Block", 0, function()
        if getgenv().HIDE_ANIMATIONS then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    for _, animationTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
                        if table.find(getgenv().BlockedAnimations, animationTrack.Animation.AnimationId) then
                            animationTrack:Stop()
                        end
                    end
                end
            end
        end
    end)
end

local function stopHidingAnimations()
    RunService:UnbindFromRenderStep("Hide - Block")
end

local RightGroupbox = Tabs.Character:AddRightGroupbox('Auto Block Settings')

RightGroupbox:AddToggle('AutoBlock', {
    Text = 'God Block',
    Default = false,

    Callback = function(state)
        getgenv().XZQW_ENABLED = state
        if state then
            startAutoBlock()
        else
            stopAutoBlock()
        end
    end,
})

local Depbox = RightGroupbox:AddDependencyBox()

Depbox:AddToggle('HideAnimations', {
    Text = 'Hide Animations',
    Default = false,

    Callback = function(state)
        getgenv().HIDE_ANIMATIONS = state
        if state then
            startHidingAnimations()
        else
            stopHidingAnimations()
        end
    end,
})

Depbox:SetupDependencies({
    { Toggles.AutoBlock, true }
})

CASH_AURA_ENABLED = false
COOLDOWN = 0.2
CASH_AURA_RANGE = 17

function GetCash()
    local Found = {}
    local Drop = workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Drop")
    
    if Drop then
        for _, v in pairs(Drop:GetChildren()) do 
            if v.Name == "MoneyDrop" then 
                local Pos = v:GetAttribute("OriginalPos") or v.Position
                
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                   (Pos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= CASH_AURA_RANGE then
                    table.insert(Found, v)
                end
            end
        end
    end
    
    return Found
end

function CashAura()
    while CASH_AURA_ENABLED do
        local Cash = GetCash()
        
        for _, v in pairs(Cash) do
            local clickDetector = v:FindFirstChildOfClass("ClickDetector")
            if clickDetector then
                fireclickdetector(clickDetector)
            end
        end
        
        task.wait(COOLDOWN)
    end
end

Modifications:AddToggle('Cash_Aura_Toggle', {
    Text = 'Cash Aura',
    Default = false,
    Callback = function(Value)
        CASH_AURA_ENABLED = Value
        if CASH_AURA_ENABLED then
            task.spawn(CashAura)
        end
    end
})

local autoReloadEnabled = true
local reloadMethod = "Normal"

function startAutoReload()
    _G.Connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not autoReloadEnabled then
            _G.Connection:Disconnect()
            return
        end

        local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        local ammo = tool and tool:FindFirstChild("Ammo")
        if ammo and ammo.Value <= (reloadMethod == "Rifle" and 1 or 0) then
            game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", tool)
            task.wait(3.7)
        end
    end)
end

Modifications:AddToggle('AntiStomp', {
    Text = 'Auto Reload',
    Default = true,

    Callback = function(state)
        autoReloadEnabled = state
        _G.AutoReloadEnabled = state
        if state then
            startAutoReload()
        end
    end,
})
startAutoReload()
Modifications:AddDropdown('MyDropdown', {
    Values = { 'Normal', 'Rifle'},
    Default = "Normal",
    Multi = false,

    Text = 'Reload Method',

    Callback = function(selected)
        reloadMethod = selected
    end
})

local AutoBuy = Tabs.Misc:AddLeftGroupbox("Shop")
local Workspace = game:GetService("Workspace")
local ShopFolder = Workspace:WaitForChild("Ignored"):WaitForChild("Shop")
local SelectedItems = {}
local Debounce = false
local AutoBuyEnabled = false
local AutoBuyConnection = nil
local ShopItems = {
    "[AUG] - $2195",
    "[Rifle] - $1745",
    "[LMG] - $4221",
}
local AmmoMap = {
    ["[AUG] - $2195"] = "90 [AUG Ammo] - $90",
    ["[LMG] - $4221"] = "200 [LMG Ammo] - $338",
    ["[Rifle] - $1745"] = "5 [Rifle Ammo] - $281",
}
AutoBuy:AddDropdown('Shop_Dropdown', {
    Values = ShopItems,
    Default = {},
    Multi = true,
    Text = 'Select Items',
    Callback = function(Value)
        SelectedItems = Value
    end
})
local function GetCharacterRoot()
    local Character = LocalPlayer.Character
    return Character and Character:FindFirstChild("HumanoidRootPart")
end
local function BuyItem(ItemName)
    if not ItemName or Debounce then return end
    Debounce = true
	if strafeEnabled then
		strafeWasEnabledBeforeAmmoBuy = true
		strafeEnabled = false
	end

    local wasDesyncEnabled = desync.enabled
    if wasDesyncEnabled then
        toggleDesync(false)
        task.wait(0.1)
    end

    local RootPart = GetCharacterRoot()
    if not RootPart then 
        Debounce = false
        return
    end

    local ItemModel = ShopFolder:FindFirstChild(ItemName)
    if ItemModel then
        local ClickDetector = ItemModel:FindFirstChildOfClass("ClickDetector")
        if ClickDetector then
            local OriginalPosition = RootPart.CFrame

            RootPart.CFrame = CFrame.new(ItemModel.Head.Position + Vector3.new(0, 3, 0))
            task.wait(0.2)

            fireclickdetector(ClickDetector)

            Library:Notify("Purchased: " .. ItemName, 3)

            RootPart.CFrame = OriginalPosition
        end
    end

    if wasDesyncEnabled then
        task.wait(0.2)
        toggleDesync(true)
    end

    Debounce = false
    if strafeWasEnabledBeforeAmmoBuy then
        strafeEnabled = true 
        strafeWasEnabledBeforeAmmoBuy = false
    end
end
local function BuyItems()
    for item, _ in pairs(SelectedItems) do
        BuyItem(item)
        task.wait(0.5)
    end
end
local function BuyAmmo()
    for item, _ in pairs(SelectedItems) do
        local AmmoItem = AmmoMap[item]
        if AmmoItem then
            BuyItem(AmmoItem)
        end
    end
end
RunService.Heartbeat:Connect(function()
if not AutoBuyEnabled then return end
if not LocalPlayer.Character then return end
for item, _ in pairs(SelectedItems) do
local gunName = string.match(item, "^(%[%w+%])")
if not gunName then continue end
local hasGun = LocalPlayer.Backpack:FindFirstChild(gunName) or LocalPlayer.Character:FindFirstChild(gunName)
if not hasGun then
BuyItem(item)
end
local ammoCount = getAmmoCount(gunName)
if hasGun and ammoCount == 0 then
local ammoItem = AmmoMap[item]
if ammoItem then
BuyItem(ammoItem)
end
end
end
end)
AutoBuy:AddToggle('AutoBuyToggle', {
    Text = 'Auto Gun',
    Default = false,
    Callback = function(state)
        AutoBuyEnabled = state
    end
})
AutoBuy:AddToggle("AutoAmmo", {
    Text = "Auto Ammo",
    Default = true,
    Callback = function(Value)
        AutoAmmoEnabled = Value
    end
})
local buy = AutoBuy:AddButton({
    Text = 'Buy Item',
    Func = function()
        BuyItems()
    end,
    DoubleClick = false,
    Tooltip = 'Buys the selected items'
})
buy:AddButton({
    Text = 'Buy Ammo',
    Func = function()
        BuyAmmo()
    end,
    DoubleClick = false,
    Tooltip = 'Buys ammo for the selected weapons'
})
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    ShopFolder = Workspace:WaitForChild("Ignored"):WaitForChild("Shop")
end)
Modifications:AddToggle('AntiVoid', {
    Text = 'Anti Void',
    Default = true,

    Callback = function(immatouchyoumaddie)
		if immatouchyoumaddie then
			workspace.FallenPartsDestroyHeight = -math.huge
		else
			Workspace.FallenPartsDestroyHeight = -50
		end
    end,
})
coroutine.wrap(function()
getgenv().autoArmorEnabled = false
getgenv().autoFArmorEnabled = false
getgenv().armorThreshold = 75
getgenv().fArmorThreshold = 75

local player = game:GetService("Players").LocalPlayer
local dataFolder = player:WaitForChild("DataFolder")
local armorInfo = dataFolder:WaitForChild("Information"):FindFirstChild("ArmorSave") or nil
local fireArmorInfo = dataFolder:WaitForChild("Information"):FindFirstChild("FireArmorSave") or nil
local armorShop = workspace.Ignored.Shop["[High-Medium Armor] - $2589"]
local fireArmorShop = workspace.Ignored.Shop["[Fire Armor] - $4501"]
local armorClickDetector = armorShop.ClickDetector
local fireArmorClickDetector = fireArmorShop.ClickDetector

local function canBuyArmor()
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 1 then return false end
    local bodyEffects = character:FindFirstChild("BodyEffects")
    local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
    if isKO then return false end
    return true
end

local function teleportAndBuy(shop, clickDetector)
    local character = player.Character
    if not character or not character.PrimaryPart then return end

    local originalPosition = character.PrimaryPart.CFrame
    task.wait(0.1)

    character:SetPrimaryPartCFrame(shop.Head.CFrame)
    task.wait(0.2)

    fireclickdetector(clickDetector)
    task.wait(0.1)

    character:SetPrimaryPartCFrame(originalPosition)
    task.wait(0.1)
end

local function buyArmor()
    if armorInfo and getgenv().autoArmorEnabled and tonumber(armorInfo.Value) < getgenv().armorThreshold and canBuyArmor() then
        if strafeEnabled then
			strafeWasEnabledBeforeAmmoBuy = true
			strafeEnabled = false
        end
        local wasDesyncEnabled = desync.enabled
        if wasDesyncEnabled then
            toggleDesync(false)
        end

        teleportAndBuy(armorShop, armorClickDetector)

        if wasDesyncEnabled then
            toggleDesync(true)
        end
        if strafeWasEnabledBeforeAmmoBuy then
	        strafeEnabled = true
            strafeWasEnabledBeforeAmmoBuy = false
        end
    end
end

local function buyFireArmor()
    if fireArmorInfo and getgenv().autoFArmorEnabled and tonumber(fireArmorInfo.Value) < getgenv().fArmorThreshold and canBuyArmor() then
        if strafeEnabled then
			strafeWasEnabledBeforeAmmoBuy = true
			strafeEnabled = false
        end
        local wasDesyncEnabled = desync.enabled
        if wasDesyncEnabled then
            toggleDesync(false)
        end

        teleportAndBuy(fireArmorShop, fireArmorClickDetector)

        if wasDesyncEnabled then
            toggleDesync(true)
        end
        if strafeWasEnabledBeforeAmmoBuy then
	        strafeEnabled = true
            strafeWasEnabledBeforeAmmoBuy = false
        end
    end
end

local function checkArmor()
    while task.wait(0.1) do
        if armorInfo then
            buyArmor()
        end
        if fireArmorInfo then
            buyFireArmor()
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(1.4)
    checkArmor()
end)

task.spawn(checkArmor)

Modifications:AddToggle('AutoArmorToggle', {
    Text = 'Auto Armor',
    Default = false,
    Callback = function(state)
        getgenv().autoArmorEnabled = state
    end,
})

Modifications:AddSlider('ArmorThresholdSlider', {
    Text = 'Armor Threshold',
    Default = 75,
    Min = 1,
    Max = 130,
    Rounding = 0,
    Callback = function(value)
        getgenv().armorThreshold = value
    end,
})

Modifications:AddToggle('AutoFArmorToggle', {
    Text = 'Auto Fire Armor',
    Default = false,
    Callback = function(state)
        getgenv().autoFArmorEnabled = state
    end,
})

Modifications:AddSlider('FArmorThresholdSlider', {
    Text = 'Fire Armor Threshold',
    Default = 75,
    Min = 1,
    Max = 130,
    Rounding = 0,
    Callback = function(value)
        getgenv().fArmorThreshold = value
    end,
})
end)()
local AntiSitcc
Modifications:AddToggle("AntiSitToggle", {
    Text = "Anti Sit",
    Default = true,
    Callback = function(state)
        getgenv().antiSitEnabled = state
        if state then
            AntiSitcc = RunService.RenderStepped:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Sit then hum.Sit = false end
            end)
        else
            if AntiSitcc then AntiSitcc:Disconnect() AntiSitcc = nil end
        end
    end
})

getgenv().AntiRPGDesyncEnabled, getgenv().GrenadeDetectionEnabled, getgenv().AntiRPGDesyncLoop = false, false, nil
local RunService, Workspace, LocalPlayer = game:GetService("RunService"), game.Workspace, game.Players.LocalPlayer

local function IsThreatNear(threatName)
    local Threat = Workspace:FindFirstChild("Ignored") and Workspace.Ignored:FindFirstChild(threatName)
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    return Threat and HRP and (Threat.Position - HRP.Position).Magnitude < 16
end

local function StartThreatDetection()
    if getgenv().AntiRPGDesyncLoop then return end

    getgenv().AntiRPGDesyncLoop = RunService.PostSimulation:Connect(function()
        local HRP, Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if not HRP or not Humanoid then return end

        local RPGThreat = Workspace.Ignored:FindFirstChild("Model") and Workspace.Ignored.Model:FindFirstChild("Launcher")
        local GrenadeThreat = IsThreatNear("Handle")

        if (getgenv().AntiRPGDesyncEnabled and RPGThreat or getgenv().GrenadeDetectionEnabled and GrenadeThreat) then
            local Offset = Vector3.new(math.random(-100, 100), math.random(50, 150), math.random(-100, 100))
            Humanoid.CameraOffset = -Offset
            local OldCFrame = HRP.CFrame
            HRP.CFrame = CFrame.new(HRP.CFrame.Position + Offset)
            RunService.RenderStepped:Wait()
            HRP.CFrame = OldCFrame
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if getgenv().AntiRPGDesyncEnabled or getgenv().GrenadeDetectionEnabled then StartThreatDetection() end
    end)
end

local function StopThreatDetection()
    if getgenv().AntiRPGDesyncLoop then
        getgenv().AntiRPGDesyncLoop:Disconnect()
        getgenv().AntiRPGDesyncLoop = nil
    end
end

Modifications:AddToggle('RPGDetection', {
    Text = 'RPG detection',
    Default = false,
    Callback = function(state)
        getgenv().AntiRPGDesyncEnabled = state
        if state or getgenv().GrenadeDetectionEnabled then StartThreatDetection() else StopThreatDetection() end
    end,
})

Modifications:AddToggle('GrenadeDetection', {
    Text = 'grenade detection',
    Default = false,
    Callback = function(state)
        getgenv().GrenadeDetectionEnabled = state
        if state or getgenv().AntiRPGDesyncEnabled then StartThreatDetection() else StopThreatDetection() end
    end,
})
Modifications:AddButton('Force Reset', function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration").Enabled = true 

coroutine.wrap(function()
local flashbackBox = Tabs.Misc:AddRightGroupbox("Detection")
local antiModEnabled, checkModFriendsEnabled, groupCheckEnabled = true, true, true
local antiModMethod = "Kick"


local modList = {
    163721789, 15427717, 201454243, 822999, 63794379, 17260230, 28357488,
    93101606, 8195210, 89473551, 16917269, 85989579, 1553950697, 476537893,
    155627580, 31163456, 7200829, 25717070, 201454243, 15427717, 63794379,
    16138978, 60660789, 17260230, 16138978, 1161411094, 9125623, 11319153,
    34758833, 194109750, 35616559, 1257271138, 28885841, 23558830, 25717070,
    4255947062, 29242182, 2395613299, 3314981799, 3390225662, 2459178,
    2846299656, 2967502742, 7001683347, 7312775547, 328566086, 170526279,
    99356639, 352087139, 6074834798, 2212830051, 3944434729, 5136267958,
    84570351, 542488819, 1830168970, 3950637598, 1962396833
}

local groupIDs = {10604500, 17215700}

local function detectModerators()
    while antiModEnabled do
        task.wait(1)
        for _, player in ipairs(Players:GetPlayers()) do
            if table.find(modList, player.UserId) then
                local message = "⚠️ MODERATOR DETECTED: " .. player.DisplayName .. " (" .. player.Name .. ")"
                if antiModMethod == "Notify" then
                    Library:Notify(message, 3)
                else
                    game.Players.LocalPlayer:Kick("🚨 " .. message)
                end
            end

            if groupCheckEnabled then
                for _, groupID in ipairs(groupIDs) do
                    local success, isInGroup = pcall(function() return player:IsInGroup(groupID) end)
                    if success and isInGroup then
                        local roleName = "Unknown Role"
                        pcall(function()
                            roleName = player:GetRoleInGroup(groupID)
                        end)

                        local groupMessage = "⚠️ [" .. roleName .. "] JOINED: " .. player.DisplayName .. " (" .. player.Name .. ")"
                        if antiModMethod == "Notify" then
                            Library:Notify(groupMessage, 3)
                        else
                            game.Players.LocalPlayer:Kick("🚨 " .. groupMessage)
                        end
                    end
                end
            end
        end
    end
end

local function checkFriendsWithMods()
    while checkModFriendsEnabled do
        task.wait(1)
        for _, player in ipairs(Players:GetPlayers()) do
            pcall(function()
                for _, friend in pairs(player:GetFriendsAsync():GetCurrentPage()) do
                    if table.find(modList, friend.Id) then
                        local friendMessage = "⚠️ " .. player.DisplayName .. " (" .. player.Name .. ") is friends with a Moderator!"
                        Library:Notify(friendMessage, 4)
                        break
                    end
                end
            end)
        end
    end
end

local AntiModToggle = flashbackBox:AddToggle("AntiModToggle", {
    Text = "Mod Detection",
    Default = true,
    Callback = function(Value)
        antiModEnabled = Value
        Library:Notify(antiModEnabled and "✅ Anti-Mod Enabled" or "⚠️ Anti-Mod Disabled", 3)
        if antiModEnabled then task.spawn(detectModerators) end
    end
})

local AntiModDepbox = flashbackBox:AddDependencyBox()
AntiModDepbox:SetupDependencies({ { AntiModToggle, true } })

AntiModDepbox:AddDropdown("AntiModMethod", {
    Values = {"Notify", "Kick"},
    Default = "Notify",
    Multi = false,
    Text = "Anti-Mod Method",
    Callback = function(Value)
        antiModMethod = Value
        Library:Notify("ℹ️ Anti-Mod Method set to: " .. antiModMethod, 3)
    end
})

AntiModDepbox:AddToggle("CheckModFriends", {
    Text = "Friended Checking",
    Tooltip = "Detects if any player is friends with a Moderator",
    Default = true,
    Callback = function(Value)
        checkModFriendsEnabled = Value
        Library:Notify(checkModFriendsEnabled and "✅ Checking for Mod Friends Enabled" or "⚠️ Checking for Mod Friends Disabled", 3)
        if checkModFriendsEnabled then task.spawn(checkFriendsWithMods) end
    end
})
local GroupCheckDepbox = AntiModDepbox:AddDependencyBox()
GroupCheckDepbox:SetupDependencies({ { AntiModToggle, true } })

GroupCheckDepbox:AddToggle("GroupCheck", {
    Text = "Group Role Checking",
    Tooltip = "Detects if any player is in the restricted groups",
    Default = true,
    Callback = function(Value)
        groupCheckEnabled = Value
        Library:Notify(groupCheckEnabled and "✅ Group Membership Check Enabled" or "⚠️ Group Membership Check Disabled", 3)
        if groupCheckEnabled then task.spawn(detectModerators) end
    end
})

local LeftGroupBox = Tabs.Misc:AddLeftGroupbox("Animation")

local KeepOnDeath = false

local AnimationOptions = {
    ["Idle1"] = "http://www.roblox.com/asset/?id=180435571",
    ["Idle2"] = "http://www.roblox.com/asset/?id=180435792",
    ["Walk"] = "http://www.roblox.com/asset/?id=180426354",
    ["Run"] = "http://www.roblox.com/asset/?id=180426354",
    ["Jump"] = "http://www.roblox.com/asset/?id=125750702",
    ["Climb"] = "http://www.roblox.com/asset/?id=180436334",
    ["Fall"] = "http://www.roblox.com/asset/?id=180436148"
}

local AnimationSets = {
    ["Default"] = {
        idle1 = "http://www.roblox.com/asset/?id=180435571",
        idle2 = "http://www.roblox.com/asset/?id=180435792",
        walk = "http://www.roblox.com/asset/?id=180426354",
        run = "http://www.roblox.com/asset/?id=180426354",
        jump = "http://www.roblox.com/asset/?id=125750702",
        climb = "http://www.roblox.com/asset/?id=180436334",
        fall = "http://www.roblox.com/asset/?id=180436148"
    },
    ["Ninja"] = {
        idle1 = "http://www.roblox.com/asset/?id=656117400",
        idle2 = "http://www.roblox.com/asset/?id=656118341",
        walk = "http://www.roblox.com/asset/?id=656121766",
        run = "http://www.roblox.com/asset/?id=656118852",
        jump = "http://www.roblox.com/asset/?id=656117878",
        climb = "http://www.roblox.com/asset/?id=656114359",
        fall = "http://www.roblox.com/asset/?id=656115606"
    },
    ["Superhero"] = {
        idle1 = "http://www.roblox.com/asset/?id=616111295",
        idle2 = "http://www.roblox.com/asset/?id=616113536",
        walk = "http://www.roblox.com/asset/?id=616122287",
        run = "http://www.roblox.com/asset/?id=616117076",
        jump = "http://www.roblox.com/asset/?id=616115533",
        climb = "http://www.roblox.com/asset/?id=616104706",
        fall = "http://www.roblox.com/asset/?id=616108001"
    },
    ["Robot"] = {
        idle1 = "http://www.roblox.com/asset/?id=616088211",
        idle2 = "http://www.roblox.com/asset/?id=616089559",
        walk = "http://www.roblox.com/asset/?id=616095330",
        run = "http://www.roblox.com/asset/?id=616091570",
        jump = "http://www.roblox.com/asset/?id=616090535",
        climb = "http://www.roblox.com/asset/?id=616086039",
        fall = "http://www.roblox.com/asset/?id=616087089"
    },
    ["Cartoon"] = {
        idle1 = "http://www.roblox.com/asset/?id=742637544",
        idle2 = "http://www.roblox.com/asset/?id=742638445",
        walk = "http://www.roblox.com/asset/?id=742640026",
        run = "http://www.roblox.com/asset/?id=742638842",
        jump = "http://www.roblox.com/asset/?id=742637942",
        climb = "http://www.roblox.com/asset/?id=742636889",
        fall = "http://www.roblox.com/asset/?id=742637151"
    },
    ["Catwalk"] = {
        idle1 = "http://www.roblox.com/asset/?id=133806214992291",
        idle2 = "http://www.roblox.com/asset/?id=94970088341563",
        walk = "http://www.roblox.com/asset/?id=109168724482748",
        run = "http://www.roblox.com/asset/?id=81024476153754",
        jump = "http://www.roblox.com/asset/?id=116936326516985",
        climb = "http://www.roblox.com/asset/?id=119377220967554",
        fall = "http://www.roblox.com/asset/?id=92294537340807"
    },
    ["Zombie"] = {
        idle1 = "http://www.roblox.com/asset/?id=616158929",
        idle2 = "http://www.roblox.com/asset/?id=616160636",
        walk = "http://www.roblox.com/asset/?id=616168032",
        run = "http://www.roblox.com/asset/?id=616163682",
        jump = "http://www.roblox.com/asset/?id=616161997",
        climb = "http://www.roblox.com/asset/?id=616156119",
        fall = "http://www.roblox.com/asset/?id=616157476"
    },
    ["Mage"] = {
        idle1 = "http://www.roblox.com/asset/?id=707742142",
        idle2 = "http://www.roblox.com/asset/?id=707855907",
        walk = "http://www.roblox.com/asset/?id=707897309",
        run = "http://www.roblox.com/asset/?id=707861613",
        jump = "http://www.roblox.com/asset/?id=707853694",
        climb = "http://www.roblox.com/asset/?id=707826056",
        fall = "http://www.roblox.com/asset/?id=707829716"
    },
    ["Pirate"] = {
        idle1 = "http://www.roblox.com/asset/?id=750785693",
        idle2 = "http://www.roblox.com/asset/?id=750782770",
        walk = "http://www.roblox.com/asset/?id=750785693",
        run = "http://www.roblox.com/asset/?id=750782770",
        jump = "http://www.roblox.com/asset/?id=750782770",
        climb = "http://www.roblox.com/asset/?id=750782770",
        fall = "http://www.roblox.com/asset/?id=750782770"
    },
    ["Knight"] = {
        idle1 = "http://www.roblox.com/asset/?id=657595757",
        idle2 = "http://www.roblox.com/asset/?id=657568135",
        walk = "http://www.roblox.com/asset/?id=657552124",
        run = "http://www.roblox.com/asset/?id=657564596",
        jump = "http://www.roblox.com/asset/?id=657560148",
        climb = "http://www.roblox.com/asset/?id=657556206",
        fall = "http://www.roblox.com/asset/?id=657552124"
    },
    ["Vampire"] = {
        idle1 = "http://www.roblox.com/asset/?id=1083465857",
        idle2 = "http://www.roblox.com/asset/?id=1083465857",
        walk = "http://www.roblox.com/asset/?id=1083465857",
        run = "http://www.roblox.com/asset/?id=1083465857",
        jump = "http://www.roblox.com/asset/?id=1083465857",
        climb = "http://www.roblox.com/asset/?id=1083465857",
        fall = "http://www.roblox.com/asset/?id=1083465857"
    },
    ["Bubbly"] = {
        idle1 = "http://www.roblox.com/asset/?id=910004836",
        idle2 = "http://www.roblox.com/asset/?id=910009958",
        walk = "http://www.roblox.com/asset/?id=910034870",
        run = "http://www.roblox.com/asset/?id=910025107",
        jump = "http://www.roblox.com/asset/?id=910016857",
        climb = "http://www.roblox.com/asset/?id=910009958",
        fall = "http://www.roblox.com/asset/?id=910009958"
    },
    ["Elder"] = {
        idle1 = "http://www.roblox.com/asset/?id=845386501",
        idle2 = "http://www.roblox.com/asset/?id=845397899",
        walk = "http://www.roblox.com/asset/?id=845403856",
        run = "http://www.roblox.com/asset/?id=845386501",
        jump = "http://www.roblox.com/asset/?id=845386501",
        climb = "http://www.roblox.com/asset/?id=845386501",
        fall = "http://www.roblox.com/asset/?id=845386501"
    },
    ["Toy"] = {
        idle1 = "http://www.roblox.com/asset/?id=782841498",
        idle2 = "http://www.roblox.com/asset/?id=782841498",
        walk = "http://www.roblox.com/asset/?id=782841498",
        run = "http://www.roblox.com/asset/?id=782841498",
        jump = "http://www.roblox.com/asset/?id=782841498",
        climb = "http://www.roblox.com/asset/?id=782841498",
        fall = "http://www.roblox.com/asset/?id=782841498"
    }
}

local function applyCustomAnimations(character)
    if not character then return end

    local Animate = character:FindFirstChild("Animate")
    if not Animate then return end

    local ClonedAnimate = Animate:Clone()

    ClonedAnimate.idle.Animation1.AnimationId = AnimationOptions["Idle1"]
    ClonedAnimate.idle.Animation2.AnimationId = AnimationOptions["Idle2"]
    ClonedAnimate.walk.WalkAnim.AnimationId = AnimationOptions["Walk"]
    ClonedAnimate.run.RunAnim.AnimationId = AnimationOptions["Run"]
    ClonedAnimate.jump.JumpAnim.AnimationId = AnimationOptions["Jump"]
    ClonedAnimate.climb.ClimbAnim.AnimationId = AnimationOptions["Climb"]
    ClonedAnimate.fall.FallAnim.AnimationId = AnimationOptions["Fall"]

    Animate:Destroy()
    ClonedAnimate.Parent = character
end

LocalPlayer.CharacterAdded:Connect(function(character)
    if KeepOnDeath then
        task.wait(1)
        applyCustomAnimations(character)
    end
end)

local animationNames = {"Default", "Ninja", "Superhero", "Robot", "Cartoon", "Catwalk", "Zombie", "Mage", "Pirate", "Knight", "Vampire", "Bubbly", "Elder", "Toy"}

LeftGroupBox:AddDropdown("Idle1Dropdown", {
    Values = animationNames,
    Default = 0,
    Multi = false,
    Text = "Idle1",
    Callback = function(Value)
        AnimationOptions["Idle1"] = AnimationSets[Value].idle1
        applyCustomAnimations(LocalPlayer.Character)
    end
})

LeftGroupBox:AddDropdown("Idle2Dropdown", {
    Values = animationNames,
    Default = 0,
    Multi = false,
    Text = "Idle2",
    Callback = function(Value)
        AnimationOptions["Idle2"] = AnimationSets[Value].idle2
        applyCustomAnimations(LocalPlayer.Character)
    end
})

LeftGroupBox:AddDropdown("WalkDropdown", {
    Values = animationNames,
    Default = 0,
    Multi = false,
    Text = "Walk",
    Callback = function(Value)
        AnimationOptions["Walk"] = AnimationSets[Value].walk
        applyCustomAnimations(LocalPlayer.Character)
    end
})

LeftGroupBox:AddDropdown("RunDropdown", {
    Values = animationNames,
    Default = 0,
    Multi = false,
    Text = "Run",
    Callback = function(Value)
        AnimationOptions["Run"] = AnimationSets[Value].run
        applyCustomAnimations(LocalPlayer.Character)
    end
})

LeftGroupBox:AddDropdown("JumpDropdown", {
    Values = animationNames,
    Default = 0,
    Multi = false,
    Text = "Jump",
    Callback = function(Value)
        AnimationOptions["Jump"] = AnimationSets[Value].jump
        applyCustomAnimations(LocalPlayer.Character)
    end
})

LeftGroupBox:AddDropdown("ClimbDropdown", {
    Values = animationNames,
    Default = 0,
    Multi = false,
    Text = "Climb",
    Callback = function(Value)
        AnimationOptions["Climb"] = AnimationSets[Value].climb
        applyCustomAnimations(LocalPlayer.Character)
    end
})

LeftGroupBox:AddDropdown("FallDropdown", {
    Values = animationNames,
    Default = 0,
    Multi = false,
    Text = "Fall",
    Callback = function(Value)
        AnimationOptions["Fall"] = AnimationSets[Value].fall
        applyCustomAnimations(LocalPlayer.Character)
    end
})

LeftGroupBox:AddToggle("MyToggle", {
    Text = "Keep On Death",
    Default = false,
    Tooltip = "Keeps the animation after respawning",
    Callback = function(Value)
        KeepOnDeath = Value
    end
})
end)()

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

MenuGroup:AddToggle('KeybindListToggle', {
    Text = 'Show Keybind List',
    Default = false,
    Callback = function(state)
        Library.KeybindFrame.Visible = state
    end
})

getgenv().vu = game:GetService("VirtualUser")
getgenv().isAntiAfkEnabled = false
getgenv().antiAfkConnection = nil

MenuGroup:AddToggle('AntiAFKToggle', {
    Text = 'Anti-AFK',
    Default = false,
    Callback = function(state)
        getgenv().isAntiAfkEnabled = state
        if getgenv().isAntiAfkEnabled then
            getgenv().antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                getgenv().vu:CaptureController()
                getgenv().vu:ClickButton2(Vector2.new())
            end)
        else
            if getgenv().antiAfkConnection then
                getgenv().antiAfkConnection:Disconnect()
                getgenv().antiAfkConnection = nil
            end
        end
    end
})


MenuGroup:AddButton('Copy Job ID', function()
    setclipboard(game.JobId)
end)

MenuGroup:AddButton('Copy JS Join Script', function()
    local jsScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)'
    setclipboard(jsScript)
end)

MenuGroup:AddInput('JobIdInput', {
    Default = '',
    Numeric = false,
    Finished = true,
    Text = '..JobId..',
    Tooltip = 'Enter a Job ID to join a specific server',
    Placeholder = 'Enter Job ID here',
    Callback = function(Value)
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, Value, game:GetService('Players').LocalPlayer)
    end	
})


MenuGroup:AddButton('Rejoin Server', function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)



ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Madlol')
SaveManager:SetFolder('Madlol/configs')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

Library:Notify("Loaded Madlol - discord.gg/dk9kWjF4jv", 10)
Library:Notify("vanhuy wishes you a good day.", 10)
Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)
