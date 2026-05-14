--[[
This file was generated on https://dsc.gg/decompiler | Pulsar v1.5
Resolved: 421 identifiers | 48 functions | 0 Strings | Renamed: 48 functions | Connected: 22 callbacks | Dead Code Removed: 14 blocks | Inlined: 26 wrappers | Detected loop: 24 blocks
[Renamer: ON] [Decompiler: ON]
]]

local repoUrl = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Window = loadstring(game:HttpGet(repoUrl .. 'Library.lua'))()
local themeManager = loadstring(game:HttpGet(repoUrl .. 'addons/ThemeManager.lua'))()
local saveManager = loadstring(game:HttpGet(repoUrl .. 'addons/SaveManager.lua'))()

local mainWindow = Window:CreateWindow({
    Title = 'hysteria.cc | Da Hood | v1.0.0',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

local menuTabs = {
    rage = mainWindow:AddTab('rage'),
    legit = mainWindow:AddTab('legit'),
    game = mainWindow:AddTab('game'),
    visuals = mainWindow:AddTab('visuals'),
    uiSettings = mainWindow:AddTab('UI Settings'),
}

local camlockGroupbox = menuTabs.legit:AddLeftGroupbox('camlock')

local camlockSettings = {
    Players = game:GetService('Players'),
    RunService = game:GetService('RunService'),
    LocalPlayer = game:GetService('Players').LocalPlayer,
    Camera = workspace.CurrentCamera,
    Mouse = game:GetService('Players').LocalPlayer:GetMouse(),
    isLockedOn = false,
    targetPlayer = nil,
    lockEnabled = false,
    aimLockEnabled = false,
    smoothingFactor = 0.1,
    predictionFactor = 0,
    bodyPartSelected = 'Head',
    teamCheckEnabled = false,
}

local function getClosestBodyPart(character, partName)
    return character:FindFirstChild(partName) and partName and partName or 'Head'
end

local function checkTeam(player)
    return not camlockSettings.teamCheckEnabled and true or player.Team ~= camlockSettings.LocalPlayer.Team
end

local function getCamlockTarget()
    if not camlockSettings.aimLockEnabled then
        return nil
    end

    local shortestDistance = math.huge
    local targetPlayer = nil

    for _, player in pairs(camlockSettings.Players:GetPlayers()) do
        if player ~= camlockSettings.LocalPlayer and player.Character and player.Character:FindFirstChild(camlockSettings.bodyPartSelected) and checkTeam(player) then
            local targetPart = player.Character[camlockSettings.bodyPartSelected]
            local screenPosition, onScreen = camlockSettings.Camera:WorldToViewportPoint(targetPart.Position)

            if onScreen then
                local magnitude = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(camlockSettings.Mouse.X, camlockSettings.Mouse.Y)).Magnitude

                if magnitude < shortestDistance then
                    targetPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end

    return targetPlayer
end

local function toggleCamlock()
    if camlockSettings.lockEnabled and camlockSettings.aimLockEnabled then
        if camlockSettings.isLockedOn then
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        else
            camlockSettings.targetPlayer = getCamlockTarget()

            if camlockSettings.targetPlayer and camlockSettings.targetPlayer.Character then
                local targetPart = getClosestBodyPart(camlockSettings.targetPlayer.Character, camlockSettings.bodyPartSelected)

                if camlockSettings.targetPlayer.Character:FindFirstChild(targetPart) then
                    camlockSettings.isLockedOn = true
                end
            end
        end
    end
end

camlockSettings.RunService.RenderStepped:Connect(function()
    if camlockSettings.aimLockEnabled and camlockSettings.lockEnabled and camlockSettings.isLockedOn and camlockSettings.targetPlayer and camlockSettings.targetPlayer.Character then
        local targetPartName = getClosestBodyPart(camlockSettings.targetPlayer.Character, camlockSettings.bodyPartSelected)
        local targetPart = camlockSettings.targetPlayer.Character:FindFirstChild(targetPartName)

        if targetPart and camlockSettings.targetPlayer.Character:FindFirstChildOfClass('Humanoid').Health > 0 then
            local predictedPosition = targetPart.Position + targetPart.AssemblyLinearVelocity * camlockSettings.predictionFactor
            local currentPosition = camlockSettings.Camera.CFrame.Position

            camlockSettings.Camera.CFrame = CFrame.new(currentPosition, predictedPosition) * CFrame.new(0, 0, camlockSettings.smoothingFactor)
        else
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        end
    end
end)

camlockGroupbox:AddToggle('aimLock_Enabled', {
    Text = 'Enable/Disable AimLock',
    Default = false,
    Tooltip = 'Toggle the AimLock feature on or off.',
    Callback = function(state)
        camlockSettings.aimLockEnabled = state

        if not camlockSettings.aimLockEnabled then
            camlockSettings.lockEnabled = false
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        end
    end,
})

camlockGroupbox:AddToggle('aim_Enabled', {
    Text = 'AimLock Keybind',
    Default = false,
    Tooltip = 'Toggle AimLock on or off.',
    Callback = function(state)
        camlockSettings.lockEnabled = state

        if not camlockSettings.lockEnabled then
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        end
    end,
}):AddKeyPicker('aim_Enabled_KeyPicker', {
    Default = 'Q',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'AimLock Key',
    Tooltip = 'Key to toggle AimLock',
    Callback = function()
        toggleCamlock()
    end,
})

camlockGroupbox:AddSlider('Prediction', {
    Text = 'Prediction Factor',
    Default = 0,
    Min = 0,
    Max = 0.9,
    Rounding = 3,
    Tooltip = 'Adjust prediction for target movement.',
    Callback = function(value)
        camlockSettings.predictionFactor = value
    end,
})

camlockGroupbox:AddInput('Smoothing', {
    Text = 'Camera Smoothing',
    Default = '0.1',
    Tooltip = 'Adjust camera smoothing factor. Set to 0 for no smoothness.',
    Placeholder = 'Enter smoothing value',
    Callback = function(value)
        local numericValue = tonumber(value)

        if numericValue then
            camlockSettings.smoothingFactor = numericValue
        end
    end,
})

camlockGroupbox:AddDropdown('BodyParts', {
    Values = {
        'Head',
        'UpperTorso',
        'RightUpperArm',
        'LeftUpperLeg',
        'RightUpperLeg',
        'LeftUpperArm',
    },
    Default = 'Head',
    Multi = false,
    Text = 'Target Body Part',
    Tooltip = 'Select which body part to lock onto.',
    Callback = function(value)
        camlockSettings.bodyPartSelected = value
    end,
})

camlockGroupbox:AddToggle('teamCheck', {
    Text = 'Team Check',
    Default = false,
    Tooltip = 'Only aimlock on players from the opposing team.',
    Callback = function(state)
        camlockSettings.teamCheckEnabled = state
    end,
})

local silentAimGroupbox = menuTabs.rage:AddLeftGroupbox('silent aim')
local playersService = game:GetService('Players')
local localPlayer = playersService.LocalPlayer
local playerMouse = localPlayer:GetMouse()
local currentCamera = workspace.CurrentCamera
local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')

local silentAimSettings = {
    Enabled = false,
    HitPart = 'Head',
    KOCheck = false,
    StickyAimEnabled = false,
    TargetPlayer = nil,
    HitChance = 100,
    LockOnKeybindEnabled = false,
    LockedTarget = nil,
}

local tracerSettings = {
    Players = playersService,
    RunService = runService,
    Camera = currentCamera,
    espBoxes = {},
    Settings = {
        TracerThickness = 2,
        TracerPosition = 'Mouse',
    },
    espColor = Color3.fromRGB(255, 0, 0),
    TRAEnabled = false,
}

local function getSilentAimTarget()
    local shortestDistance = math.huge
    local mouseLocation = userInputService:GetMouseLocation()
    local targetPart = nil

    for _, player in pairs(playersService:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local hitPart = character:FindFirstChild(silentAimSettings.HitPart)
            local humanoid = character:FindFirstChild('Humanoid')
            local bodyEffects = character:FindFirstChild('BodyEffects')

            if bodyEffects then
                bodyEffects = character.BodyEffects:FindFirstChild('K.O')
            end

            if hitPart and humanoid and humanoid.Health > 0 and (not silentAimSettings.KOCheck or bodyEffects and not bodyEffects.Value) then
                local screenPosition, onScreen = currentCamera:WorldToViewportPoint(hitPart.Position)

                if onScreen then
                    local magnitude = (mouseLocation - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude

                    if magnitude < shortestDistance then
                        targetPart = hitPart
                        shortestDistance = magnitude
                    end
                end
            end
        end
    end

    return targetPart
end

local function getStickyAimTarget()
    if silentAimSettings.TargetPlayer and silentAimSettings.TargetPlayer.Character then
        local hitPart = silentAimSettings.TargetPlayer.Character:FindFirstChild(silentAimSettings.HitPart)
        local humanoid = silentAimSettings.TargetPlayer.Character:FindFirstChild('Humanoid')
        local bodyEffects = silentAimSettings.TargetPlayer.Character:FindFirstChild('BodyEffects')

        if bodyEffects then
            bodyEffects = silentAimSettings.TargetPlayer.Character.BodyEffects:FindFirstChild('K.O')
        end

        if hitPart and humanoid and humanoid.Health > 0 and (not silentAimSettings.KOCheck or bodyEffects and not bodyEffects.Value) then
            return hitPart
        end
    end

    return nil
end

local mt = getrawmetatable(game)
local oldIndex = mt.__index

setreadonly(mt, false)

function mt.__index(self, key)
    if not checkcaller() and self == playerMouse and silentAimSettings.Enabled and (key == 'Hit' or key == 'Target') then
        local targetData

        if silentAimSettings.LockOnKeybindEnabled and silentAimSettings.LockedTarget then
            targetData = silentAimSettings.LockedTarget
        elseif silentAimSettings.StickyAimEnabled then
            targetData = getStickyAimTarget()
        else
            targetData = getSilentAimTarget()
        end

        if targetData then
            if math.random(0, 100) <= silentAimSettings.HitChance then
                return CFrame.new(targetData.Position)
            end

            local offset = Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
            return CFrame.new(targetData.Position + offset)
        end
    end

    return oldIndex(self, key)
end

local function lockSilentAimTarget()
    silentAimSettings.LockedTarget = getSilentAimTarget()
end

local function unlockSilentAimTarget()
    silentAimSettings.LockedTarget = nil
end

local targetingGroupbox = menuTabs.rage:AddLeftGroupbox('targeting')

targetingGroupbox:AddToggle('LockOnKeybind', {
    Text = 'sticky aim',
    Default = false,
    Tooltip = 'Enable or disable lock on keybind.',
    Callback = function(state)
        silentAimSettings.LockOnKeybindEnabled = state

        if not state then
            unlockSilentAimTarget()
        end
    end,
}):AddKeyPicker('LockOnKeybindPicker', {
    Default = 'F',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Lock On Keybind',
    Tooltip = 'Key to lock on to the closest player.',
    Callback = function(state)
        if silentAimSettings.LockOnKeybindEnabled then
            if state then
                lockSilentAimTarget()
            else
                unlockSilentAimTarget()
            end
        end
    end,
})

targetingGroupbox:AddToggle('Show Silent Aim Target', {
    Text = 'show tracer',
    Default = false,
    Tooltip = 'shows who your silent aim is targeting',
    Callback = function(state)
        tracerSettings.TRAEnabled = state
    end,
})

targetingGroupbox:AddDropdown('Hit Part', {
    Values = {
        'Head',
        'UpperTorso',
        'HumanoidRootPart',
        'LowerTorso',
        'LeftHand',
        'RightHand',
        'LeftLowerArm',
        'RightLowerArm',
        'LeftUpperArm',
        'RightUpperArm',
        'LeftFoot',
        'LeftLowerLeg',
        'LeftUpperLeg',
        'RightLowerLeg',
        'RightFoot',
        'RightUpperLeg',
    },
    Multi = false,
    Text = 'hit part',
    Default = silentAimSettings.HitPart,
    Callback = function(value)
        silentAimSettings.HitPart = value
    end,
})

local function addTracer(player)
    local tracerLine = Drawing.new('Line')
    tracerLine.Color = tracerSettings.espColor
    tracerLine.Thickness = tracerSettings.Settings.TracerThickness
    tracerLine.Visible = false
    tracerSettings.espBoxes[player] = tracerLine
end

local function removeTracer(player)
    if tracerSettings.espBoxes[player] then
        tracerSettings.espBoxes[player]:Remove()
        tracerSettings.espBoxes[player] = nil
    end
end

local function updateTracers()
    local lockedTargetPart = silentAimSettings.LockedTarget or getSilentAimTarget()

    for player, espBox in pairs(tracerSettings.espBoxes) do
        if player.Character and player.Character:FindFirstChild(silentAimSettings.HitPart) then
            local hitPart = player.Character[silentAimSettings.HitPart]
            local screenPosition, onScreen = currentCamera:WorldToViewportPoint(hitPart.Position)

            if onScreen and tracerSettings.TRAEnabled and hitPart == lockedTargetPart then
                espBox.From = userInputService:GetMouseLocation()
                espBox.To = Vector2.new(screenPosition.X, screenPosition.Y)
                espBox.Visible = true
            else
                espBox.Visible = false
            end
        else
            espBox.Visible = false
        end
    end
end

tracerSettings.Players.PlayerAdded:Connect(addTracer)
tracerSettings.Players.PlayerRemoving:Connect(removeTracer)

for _, player in pairs(tracerSettings.Players:GetPlayers()) do
    addTracer(player)
end

tracerSettings.RunService.RenderStepped:Connect(updateTracers)

silentAimGroupbox:AddToggle('Silent Aim', {
    Text = 'silent aim',
    Default = false,
    Tooltip = 'silently aim at a person without needing to aim at them',
    Callback = function(state)
        silentAimSettings.Enabled = state
    end,
})

silentAimGroupbox:AddToggle('force hit', {
    Text = 'force hit',
    Default = false,
    Tooltip = 'forces the bullet to hit the head',
    Callback = function(state)
        getgenv().forceHitEnabled = state
    end,
})

silentAimGroupbox:AddToggle('ko check', {
    Text = 'ko check',
    Default = false,
    Tooltip = 'checks if the player is knocked out before shooting',
    Callback = function(state)
        silentAimSettings.KOCheck = state
    end,
})

silentAimGroupbox:AddSlider('hitchance', {
    Text = 'hit chance',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Tooltip = 'the chance of hitting the target',
    Callback = function(value)
        silentAimSettings.HitChance = value
    end,
})

local menuGroupbox = menuTabs.uiSettings:AddLeftGroupbox('Menu')

menuGroupbox:AddButton('Unload', function()
    Window:Unload()
end)

menuGroupbox:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind',
})

local uiOptions = getgenv().Options or {}
uiOptions.MenuKeybind = uiOptions.MenuKeybind or {}
Window.ToggleKeybind = uiOptions.MenuKeybind

themeManager:SetLibrary(Window)
saveManager:SetLibrary(Window)
saveManager:IgnoreThemeSettings()
saveManager:SetIgnoreIndexes({'MenuKeybind'})
themeManager:SetFolder('hysteria.cc')
saveManager:SetFolder('hysteria/configs')
saveManager:BuildConfigSection(menuTabs.uiSettings)
themeManager:ApplyToTab(menuTabs.uiSettings)
saveManager:LoadAutoloadConfig()

local targetStrafeGroupbox = menuTabs.rage:AddRightGroupbox('Target Strafe')
local strafeSettings = {
    strafeRadius = 10,
    strafeSpeed = 5,
    strafeHeight = 5,
    enabled = false,
}

local isStrafing = false
local strafeTargetPlayer = nil
local updateCameraSubject = false

local function getStrafeTarget()
    local shortestDistance = math.huge
    local mouseLocation = userInputService:GetMouseLocation()
    local targetPlayer = nil

    for _, player in pairs(playersService:GetPlayers()) do
        if player ~= playersService.LocalPlayer and player.Character and player.Character:FindFirstChild('HumanoidRootPart') then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(humanoidRootPart.Position)

            if onScreen then
                local magnitude = (Vector2.new(screenPosition.X, screenPosition.Y) - mouseLocation).Magnitude

                if magnitude < shortestDistance then
                    targetPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end

    return targetPlayer
end

local function calculateStrafePosition(center, radius, angle, height)
    local xOffset = math.cos(math.rad(angle)) * radius
    local zOffset = math.sin(math.rad(angle)) * radius

    return Vector3.new(center.X + xOffset, center.Y + height, center.Z + zOffset)
end

local function highlightCharacter(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA('BasePart') or part:IsA('MeshPart') then
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end

local function unhighlightCharacter(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA('BasePart') or part:IsA('MeshPart') then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end

local function toggleStrafe()
    if isStrafing then
        isStrafing = false
        updateCameraSubject = false
        unhighlightCharacter(playersService.LocalPlayer.Character)
        game.Workspace.CurrentCamera.CameraSubject = playersService.LocalPlayer.Character:FindFirstChild('Humanoid')
        Window:Notify('Unstrafing ' .. (strafeTargetPlayer and strafeTargetPlayer.Name or ''))
        strafeTargetPlayer = nil
    else
        strafeTargetPlayer = getStrafeTarget()
        if strafeTargetPlayer then
            isStrafing = true
            updateCameraSubject = true
            highlightCharacter(playersService.LocalPlayer.Character)
            Window:Notify('Strafing ' .. strafeTargetPlayer.Name)
        end
    end
end

local currentStrafeAngle = 0

runService.RenderStepped:Connect(function(deltaTime)
    if strafeSettings.enabled and isStrafing and strafeTargetPlayer and strafeTargetPlayer.Character and strafeTargetPlayer.Character:FindFirstChild('HumanoidRootPart') then
        local targetRootPart = strafeTargetPlayer.Character.HumanoidRootPart
        currentStrafeAngle = (currentStrafeAngle + strafeSettings.strafeSpeed * deltaTime * 360) % 360

        local newPosition = calculateStrafePosition(targetRootPart.Position, strafeSettings.strafeRadius, currentStrafeAngle, strafeSettings.strafeHeight)
        
        local bodyParts = {
            'Head', 'UpperTorso', 'HumanoidRootPart', 'LowerTorso',
            'LeftHand', 'RightHand', 'LeftLowerArm', 'RightLowerArm',
            'LeftUpperArm', 'RightUpperArm', 'LeftFoot', 'LeftLowerLeg',
            'LeftUpperLeg', 'RightLowerLeg', 'RightFoot', 'RightUpperLeg'
        }

        for _, bodyPartName in ipairs(bodyParts) do
            local localBodyPart = playersService.LocalPlayer.Character:FindFirstChild(bodyPartName)
            if localBodyPart then
                localBodyPart.CFrame = CFrame.new(newPosition, targetRootPart.Position)
            end
        end

        if updateCameraSubject then
            game.Workspace.CurrentCamera.CameraSubject = targetRootPart
        end
    end
end)

targetStrafeGroupbox:AddToggle('StrafeEnabled', {
    Text = 'Enable/Disable Target Strafe',
    Default = strafeSettings.enabled,
    Tooltip = 'Enable or disable the target strafe functionality.',
    Callback = function(state)
        strafeSettings.enabled = state
    end,
})

targetStrafeGroupbox:AddLabel('Strafe Keybind'):AddKeyPicker('StrafeKeybind', {
    Default = 'V',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Strafe KeyBind',
    Tooltip = 'Toggle the target strafe.',
    Callback = function()
        toggleStrafe()
    end,
})

targetStrafeGroupbox:AddSlider('StrafeRadius', {
    Text = 'Strafe Radius',
    Default = strafeSettings.strafeRadius,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Tooltip = 'Set the radius of the strafe.',
    Callback = function(value)
        strafeSettings.strafeRadius = value
    end,
})

targetStrafeGroupbox:AddSlider('StrafeSpeed', {
    Text = 'Strafe Speed',
    Default = strafeSettings.strafeSpeed,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Tooltip = 'Set the speed of the strafe.',
    Callback = function(value)
        strafeSettings.strafeSpeed = value
    end,
})

targetStrafeGroupbox:AddSlider('StrafeHeight', {
    Text = 'Strafe Height',
    Default = strafeSettings.strafeHeight,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Tooltip = 'Set the height of the strafe.',
    Callback = function(value)
        strafeSettings.strafeHeight = value
    end,
})

local antiAimGroupbox = menuTabs.rage:AddRightGroupbox('anti aim')

local desyncSetback = Instance.new('Part')
desyncSetback.Name = 'Desync Setback'
desyncSetback.Parent = workspace
desyncSetback.Size = Vector3.new(2, 2, 1)
desyncSetback.CanCollide = false
desyncSetback.Anchored = true
desyncSetback.Transparency = 1

local desyncConfig = {
    enabled = false,
    mode = 'Void',
    teleportPosition = Vector3.new(0, 0, 0),
    oldPosition = nil,
    voidSpamActive = false,
    toggleEnabled = false,
}

local function resetCameraToPlayer()
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild('Humanoid')
    if humanoid then
        workspace.CurrentCamera.CameraSubject = humanoid
    end
end

local function toggleDesyncState(state)
    desyncConfig.enabled = state

    if desyncConfig.enabled then
        workspace.CurrentCamera.CameraSubject = desyncSetback
        Window:Notify("Desync Enabled '" .. desyncConfig.mode .. "' hoodware.lol $", 2)
    else
        resetCameraToPlayer()
        Window:Notify("Desync Disabled '" .. desyncConfig.mode .. "' hoodware.lol $", 2)
    end
end

local function setDesyncModeState(mode)
    desyncConfig.mode = mode
end

antiAimGroupbox:AddToggle('DesyncToggle', {
    Text = 'Anti Aim',
    Default = false,
    Callback = function(state)
        desyncConfig.toggleEnabled = state

        if not state then
            toggleDesyncState(false)
        end
    end,
}):AddKeyPicker('DesyncKeybind', {
    Default = 'V',
    Text = 'Desync',
    Mode = 'Toggle',
    Callback = function()
        if desyncConfig.toggleEnabled and not userInputService:GetFocusedTextBox() then
            toggleDesyncState(not desyncConfig.enabled)
        end
    end,
})

antiAimGroupbox:AddDropdown('DesyncMethodDropdown', {
    Values = {
        'Destroy Cheaters',
        'Underground',
        'Void Spam',
        'Void',
    },
    Default = 'Void',
    Multi = false,
    Text = 'Method',
    Callback = function(mode)
        setDesyncModeState(mode)
    end,
})

runService.Heartbeat:Connect(function()
    local localRootPart = desyncConfig.enabled and localPlayer.Character and localPlayer.Character:FindFirstChild('HumanoidRootPart')

    if localRootPart then
        desyncConfig.oldPosition = localRootPart.CFrame

        if desyncConfig.mode ~= 'Destroy Cheaters' then
            if desyncConfig.mode ~= 'Underground' then
                if desyncConfig.mode ~= 'Void Spam' then
                    if desyncConfig.mode == 'Void' then
                        desyncConfig.teleportPosition = Vector3.new(localRootPart.Position.X + math.random(-444444, 444444), localRootPart.Position.Y + math.random(-444444, 444444), localRootPart.Position.Z + math.random(-44444, 44444))
                    end
                else
                    desyncConfig.teleportPosition = math.random(1, 2) == 1 and desyncConfig.oldPosition.Position or Vector3.new(math.random(10000, 50000), math.random(10000, 50000), math.random(10000, 50000))
                end
            else
                desyncConfig.teleportPosition = localRootPart.Position - Vector3.new(0, 12, 0)
            end
        else
            desyncConfig.teleportPosition = Vector3.new(1.122334455667789e19, 1, 1)
        end

        if desyncConfig.mode ~= 'Rotation' then
            localRootPart.CFrame = CFrame.new(desyncConfig.teleportPosition)
            workspace.CurrentCamera.CameraSubject = desyncSetback

            runService.RenderStepped:Wait()

            desyncSetback.CFrame = desyncConfig.oldPosition * CFrame.new(0, localRootPart.Size.Y / 2 + 0.5, 0)
            localRootPart.CFrame = desyncConfig.oldPosition
        end
    end
end)

local espSettingsGroupbox = menuTabs.visuals:AddRightGroupbox('ESP Settings')
local espConfiguration = {
    showBox = false,
    showChams = false,
    showHealthBar = false,
    showName = false,
    showDistance = false,
    showTracers = false,
    tracerPosition = 'Mouse',
    tracerThickness = 1,
}

espSettingsGroupbox:AddToggle('ShowBox', {
    Text = 'Show Box',
    Default = espConfiguration.showBox,
    Tooltip = 'Show or hide a box around players.',
    Callback = function(state)
        espConfiguration.showBox = state
    end,
})

espSettingsGroupbox:AddToggle('ShowTracers', {
    Text = 'Show Tracers',
    Default = false,
    Tooltip = 'Show or hide tracers to players.',
    Callback = function(state)
        espConfiguration.showTracers = state
    end,
}):AddColorPicker('TracerColor', {
    Default = Color3.fromRGB(255, 0, 0),
    Text = 'Tracer Color',
    Tooltip = 'Set the color of the tracers.',
    Callback = function() end,
})

espSettingsGroupbox:AddDropdown('TracerPosition', {
    Values = {
        'Mouse',
        'Center',
        'Bottom',
    },
    Default = 1,
    Multi = false,
    Text = 'Tracer Position',
    Tooltip = 'Select the starting position of the tracers.',
    Callback = function(position)
        espConfiguration.tracerPosition = position
    end,
})

espSettingsGroupbox:AddSlider('TracerThickness', {
    Text = 'Tracer Thickness',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Tooltip = 'Adjust the thickness of the tracers.',
    Callback = function(thickness)
        espConfiguration.tracerThickness = thickness
    end,
})

espSettingsGroupbox:AddToggle('ShowHealthBar', {
    Text = 'show health bar',
    Default = espConfiguration.showHealthBar,
    Tooltip = 'Show or hide the health bar of players.',
    Callback = function(state)
        espConfiguration.showHealthBar = state
    end,
}):AddColorPicker('HealthBarColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Text = 'Health Bar Color',
    Tooltip = 'Set the color of the health bar.',
    Callback = function() end,
})

espSettingsGroupbox:AddToggle('ShowName', {
    Text = 'show name',
    Default = espConfiguration.showName,
    Tooltip = 'Show or hide the name of players.',
    Callback = function(state)
        espConfiguration.showName = state
    end,
})

espSettingsGroupbox:AddToggle('ShowDistance', {
    Text = 'show distance',
    Default = espConfiguration.showDistance,
    Tooltip = 'Show or hide the distance to players.',
    Callback = function(state)
        espConfiguration.showDistance = state
    end,
})

local espGlobalSettings = {
    defaultcolor = Color3.fromRGB(255, 0, 0),
    teamcheck = false,
    teamcolor = true,
}

local espDrawingsTable = {}

local function roundVector(...)
    local arguments = table.pack(...)
    local roundedArgs = {}

    for index, value in ipairs(arguments) do
        roundedArgs[index] = math.round(value)
    end

    return unpack(roundedArgs)
end

local function createEspObjects(player)
    local espObjects = {
        box = Drawing.new('Square')
    }

    espObjects.box.Thickness = 1
    espObjects.box.Filled = false
    espObjects.box.Color = espGlobalSettings.defaultcolor
    espObjects.box.Visible = false
    espObjects.box.ZIndex = 2
    
    espObjects.boxoutline = Drawing.new('Square')
    espObjects.boxoutline.Thickness = 3
    espObjects.boxoutline.Filled = false
    espObjects.boxoutline.Color = Color3.new()
    espObjects.boxoutline.Visible = false
    espObjects.boxoutline.ZIndex = 1
    
    espObjects.healthBar = Drawing.new('Line')
    espObjects.healthBar.Thickness = 2
    espObjects.healthBar.Color = Color3.fromRGB(0, 255, 0)
    espObjects.healthBar.Visible = false
    espObjects.healthBar.ZIndex = 2
    
    espObjects.name = Drawing.new('Text')
    espObjects.name.Size = 13
    espObjects.name.Color = Color3.fromRGB(255, 255, 255)
    espObjects.name.Outline = true
    espObjects.name.Center = true
    espObjects.name.Visible = false
    espObjects.name.ZIndex = 2
    
    espObjects.distance = Drawing.new('Text')
    espObjects.distance.Size = 13
    espObjects.distance.Color = Color3.fromRGB(255, 255, 255)
    espObjects.distance.Outline = true
    espObjects.distance.Center = true
    espObjects.distance.Visible = false
    espObjects.distance.ZIndex = 2
    
    espObjects.chams = Instance.new('Highlight')
    espObjects.chams.FillColor = espGlobalSettings.defaultcolor
    espObjects.chams.OutlineColor = Color3.new(0, 0, 0)
    espObjects.chams.FillTransparency = 0.5
    espObjects.chams.OutlineTransparency = 0
    espObjects.chams.Enabled = false
    espObjects.chams.Parent = player.Character
    
    espObjects.tracer = Drawing.new('Line')
    espObjects.tracer.Thickness = espConfiguration.tracerThickness
    espObjects.tracer.Color = espGlobalSettings.defaultcolor
    espObjects.tracer.Visible = false
    espObjects.tracer.ZIndex = 2

    espDrawingsTable[player] = espObjects
end

local function removeEspObjects(player)
    if rawget(espDrawingsTable, player) then
        for _, drawing in pairs(espDrawingsTable[player]) do
            drawing:Remove()
        end
        espDrawingsTable[player] = nil
    end
end

local function updateEspObjects(player, espObjects)
    local character = player.Character

    if character then
        local characterCFrame = character:GetModelCFrame()
        local screenPosition, onScreen, depth = currentCamera:WorldToViewportPoint(characterCFrame.Position)
        local screenVector = Vector2.new(screenPosition.X, screenPosition.Y)

        espObjects.box.Visible = onScreen and espConfiguration.showBox
        espObjects.boxoutline.Visible = onScreen and espConfiguration.showBox
        espObjects.healthBar.Visible = onScreen and espConfiguration.showHealthBar
        espObjects.name.Visible = onScreen and espConfiguration.showName
        espObjects.distance.Visible = onScreen and espConfiguration.showDistance
        espObjects.chams.Enabled = onScreen and espConfiguration.showChams
        espObjects.tracer.Visible = onScreen and espConfiguration.showTracers

        if characterCFrame and onScreen then
            local scaleFactor = 1 / (depth * math.tan(math.rad(currentCamera.FieldOfView / 2)) * 2) * 1000
            local boxWidth, boxHeight = roundVector(4 * scaleFactor, 5 * scaleFactor)
            local posX, posY = roundVector(screenVector.X, screenVector.Y)

            espObjects.box.Size = Vector2.new(boxWidth, boxHeight)
            espObjects.box.Position = Vector2.new(roundVector(posX - boxWidth / 2, posY - boxHeight / 2))
            espObjects.box.Color = espGlobalSettings.teamcolor and player.TeamColor.Color or espGlobalSettings.defaultcolor
            espObjects.boxoutline.Size = espObjects.box.Size
            espObjects.boxoutline.Position = espObjects.box.Position

            local humanoid = character:FindFirstChildOfClass('Humanoid')
            local healthFraction = (humanoid and (humanoid.Health or 0) or 0) / (humanoid and humanoid.MaxHealth or 100)

            espObjects.healthBar.From = Vector2.new(posX - boxWidth / 2 - 5, posY - boxHeight / 2 + boxHeight * (1 - healthFraction))
            espObjects.healthBar.To = Vector2.new(posX - boxWidth / 2 - 5, posY + boxHeight / 2)

            local textSize = math.clamp(16 / (depth / 100), 8, 16)

            espObjects.name.Text = player.Name
            espObjects.name.Position = Vector2.new(posX, posY - boxHeight / 2 - 15)
            espObjects.name.Size = textSize
            espObjects.distance.Text = string.format('%.1f', depth)
            espObjects.distance.Position = Vector2.new(posX, posY + boxHeight / 2 + 15)
            espObjects.distance.Size = textSize
            espObjects.chams.FillColor = Color3.fromRGB(255 * (1 - healthFraction), 0, 0)

            local tracerStartPos

            if espConfiguration.tracerPosition ~= 'Mouse' then
                if espConfiguration.tracerPosition ~= 'Center' then
                    tracerStartPos = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y)
                else
                    tracerStartPos = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)
                end
            else
                tracerStartPos = Vector2.new(localPlayer:GetMouse().X, localPlayer:GetMouse().Y)
            end

            espObjects.tracer.From = tracerStartPos
            espObjects.tracer.To = Vector2.new(posX, posY)
            espObjects.tracer.Color = espGlobalSettings.teamcolor and player.TeamColor.Color or espGlobalSettings.defaultcolor
            espObjects.tracer.Thickness = espConfiguration.tracerThickness
        end
    else
        espObjects.box.Visible = false
        espObjects.boxoutline.Visible = false
        espObjects.healthBar.Visible = false
        espObjects.name.Visible = false
        espObjects.distance.Visible = false
        espObjects.chams.Enabled = false
        espObjects.tracer.Visible = false
    end
end

for _, player in pairs(playersService:GetPlayers()) do
    if player ~= localPlayer then
        createEspObjects(player)
    end
end

playersService.PlayerAdded:Connect(function(player)
    createEspObjects(player)
end)

playersService.PlayerRemoving:Connect(function(player)
    removeEspObjects(player)
end)

runService:BindToRenderStep('esp', Enum.RenderPriority.Camera.Value, function()
    for player, espObjects in pairs(espDrawingsTable) do
        if (not espGlobalSettings.teamcheck or player.Team ~= localPlayer.Team) and player ~= localPlayer then
            updateEspObjects(player, espObjects)
        end
    end
end)

local selfChamsGroupbox = menuTabs.visuals:AddRightGroupbox('Self Chams')
local initialLocalCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local selfChamsSettings = {
    Color = Color3.fromRGB(255, 255, 255),
}

local function applyForcefield(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA('BasePart') or part:IsA('MeshPart') then
            part.Material = Enum.Material.ForceField
            part.Color = selfChamsSettings.Color
        end
    end
end

local function removeForcefield(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA('BasePart') or part:IsA('MeshPart') then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end

local forcefieldEnabled = false

selfChamsGroupbox:AddToggle('ForcefieldToggle', {
    Text = 'Forcefield Material',
    Default = false,
    Tooltip = 'Enable or disable forcefield material on your character.',
    Callback = function(state)
        forcefieldEnabled = state

        if forcefieldEnabled then
            applyForcefield(initialLocalCharacter)
        else
            removeForcefield(initialLocalCharacter)
        end
    end,
})

local trailColor = Color3.new(1, 1, 1)
getgenv().trail = true

local function applyTrail(character)
    local humanoidRootPart = character:WaitForChild('HumanoidRootPart')

    if not humanoidRootPart:FindFirstChild('Trail') then
        local trail = Instance.new('Trail', humanoidRootPart)
        trail.Name = 'Trail'
        humanoidRootPart.Material = Enum.Material.Neon

        local attachment1 = Instance.new('Attachment', humanoidRootPart)
        attachment1.Position = Vector3.new(0, 1, 0)

        local attachment2 = Instance.new('Attachment', humanoidRootPart)
        attachment2.Position = Vector3.new(0, -1, 0)
        
        trail.Attachment0 = attachment1
        trail.Attachment1 = attachment2
        trail.Color = ColorSequence.new(trailColor)
        trail.Lifetime = 1
        trail.Transparency = NumberSequence.new(0, 0)
        trail.LightEmission = 1
        trail.WidthScale = NumberSequence.new(0.08)
    end
    if not humanoidRootPart:FindFirstChild('LeftTrail') then
        local leftTrail = Instance.new('Trail', humanoidRootPart)
        leftTrail.Name = 'LeftTrail'

        local attachment3 = Instance.new('Attachment', humanoidRootPart)
        attachment3.Position = Vector3.new(-1, 1, 0)

        local attachment4 = Instance.new('Attachment', humanoidRootPart)
        attachment4.Position = Vector3.new(-1, -1, 0)
        
        leftTrail.Attachment0 = attachment3
        leftTrail.Attachment1 = attachment4
        leftTrail.Color = ColorSequence.new(trailColor)
        leftTrail.Lifetime = 1
        leftTrail.Transparency = NumberSequence.new(0, 0)
        leftTrail.LightEmission = 1
        leftTrail.WidthScale = NumberSequence.new(0.08)
    end
    if not humanoidRootPart:FindFirstChild('RightTrail') then
        local rightTrail = Instance.new('Trail', humanoidRootPart)
        rightTrail.Name = 'RightTrail'

        local attachment5 = Instance.new('Attachment', humanoidRootPart)
        attachment5.Position = Vector3.new(1, 1, 0)

        local attachment6 = Instance.new('Attachment', humanoidRootPart)
        attachment6.Position = Vector3.new(1, -1, 0)
        
        rightTrail.Attachment0 = attachment5
        rightTrail.Attachment1 = attachment6
        rightTrail.Color = ColorSequence.new(trailColor)
        rightTrail.Lifetime = 1
        rightTrail.Transparency = NumberSequence.new(0, 0)
        rightTrail.LightEmission = 1
        rightTrail.WidthScale = NumberSequence.new(0.08)
    end
end

local trailEnabled = false

selfChamsGroupbox:AddToggle('TrailToggle', {
    Text = 'Enable Trail',
    Default = trailEnabled,
    Tooltip = 'Enable or disable the trail effect.',
    Callback = function(state)
        trailEnabled = state
        getgenv().trail = state

        local currentCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()

        if trailEnabled then
            applyTrail(currentCharacter)
        else
            local humanoidRootPart = currentCharacter:FindFirstChild('HumanoidRootPart')

            if humanoidRootPart then
                for _, child in ipairs(humanoidRootPart:GetChildren()) do
                    if child:IsA('Trail') then
                        child:Destroy()
                    end
                end
            end
        end
    end,
})

selfChamsGroupbox:AddLabel('Trail Color'):AddColorPicker('TrailColorPicker', {
    Default = trailColor,
    Callback = function(color)
        trailColor = color

        if trailEnabled then
            applyTrail(localPlayer.Character or localPlayer.CharacterAdded:Wait())
        end
    end,
})

selfChamsGroupbox:AddSlider('TrailLifetimeSlider', {
    Text = 'Trail Lifetime',
    Default = 1,
    Min = 0.3,
    Max = 10,
    Rounding = 1,
    Tooltip = 'Adjust the lifetime of the trail.',
    Callback = function(value)
        local humanoidRootPart = trailEnabled and (localPlayer.Character or localPlayer.CharacterAdded:Wait()):FindFirstChild('HumanoidRootPart')

        if humanoidRootPart then
            for _, child in ipairs(humanoidRootPart:GetChildren()) do
                if child:IsA('Trail') then
                    child.Lifetime = value
                end
            end
        end
    end,
})

localPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)

    if trailEnabled then
        applyTrail(character)
    end
end)

local movementGroupbox = menuTabs.game:AddLeftGroupbox('movement')
local cframeSpeedSettings = {
    localPlayer = game:GetService('Players').LocalPlayer,
    multiplier = 1,
    isSpeedActive = false,
    isFunctionalityEnabled = false,
}

movementGroupbox:AddToggle('functionalityEnabled', {
    Text = 'Enable/Disable Speed',
    Default = false,
    Tooltip = 'Enable or disable the speed thingy.',
    Callback = function(state)
        cframeSpeedSettings.isFunctionalityEnabled = state
    end,
})

movementGroupbox:AddToggle('speedEnabled', {
    Text = 'Speed Keybind',
    Default = false,
    Tooltip = 'It makes you go fast.',
    Callback = function(state)
        cframeSpeedSettings.isSpeedActive = state
    end,
}):AddKeyPicker('speedToggleKey', {
    Default = 'C',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Speed KeyBind',
    Tooltip = 'CFrame keybind.',
    Callback = function(state)
        cframeSpeedSettings.isSpeedActive = state
    end,
})

movementGroupbox:AddSlider('cframespeed', {
    Text = 'CFrame Multiplier',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Tooltip = 'The CFrame speed.',
    Callback = function(value)
        cframeSpeedSettings.multiplier = value
    end,
})

task.spawn(function()
    while true do
        repeat
            task.wait()
        until cframeSpeedSettings.isFunctionalityEnabled

        local character = cframeSpeedSettings.localPlayer.Character

        if character and character:FindFirstChild('HumanoidRootPart') then
            local humanoid = character:FindFirstChild('Humanoid')

            if cframeSpeedSettings.isSpeedActive and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                local moveUnit = humanoid.MoveDirection.Unit
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + moveUnit * cframeSpeedSettings.multiplier
            end
        end
    end
end)

local nevermoreEngineMaid = loadstring(game:HttpGet('https://raw.githubusercontent.com/Quenty/NevermoreEngine/main/src/maid/src/Shared/Maid.lua'))()
shared.Maid = shared.Maid or nevermoreEngineMaid.new()
local movementMaid = shared.Maid

movementMaid:DoCleaning()
shared.Active = false

local isCFrameFlying = false
local cframeFlySpeed = 4
local flyCamera = workspace.CurrentCamera
local flyLocalPlayer = playersService.LocalPlayer or playersService.PlayerAdded:Wait()
local flyCharacter = flyLocalPlayer.Character or flyLocalPlayer.CharacterAdded:Wait()
local flyPivot = flyCharacter:GetPivot()

local function clearVelocity()
    local rootPart = flyCharacter and flyCharacter:FindFirstChild('HumanoidRootPart')
    if rootPart then
        rootPart.Velocity = Vector3.zero
    end
end

movementMaid:GiveTask(flyLocalPlayer.CharacterAdded:Connect(function(character)
    flyCharacter = character
end))

movementMaid:GiveTask(runService.Stepped:Connect(function()
    if shared.Active then
        clearVelocity()
        local cameraCFrame = flyCamera.CFrame
        flyPivot = CFrame.new(flyPivot.Position, flyPivot.Position + cameraCFrame.LookVector)
        flyCharacter:PivotTo(flyPivot)
    end
end))

local flyKeybinds = {
    [Enum.KeyCode.W] = {
        FLY_FORWARD = function()
            while userInputService:IsKeyDown(Enum.KeyCode.W) do
                runService.Stepped:Wait()
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(0, 0, -cframeFlySpeed)
                end
            end
        end,
    },
    [Enum.KeyCode.S] = {
        FLY_BACK = function()
            while userInputService:IsKeyDown(Enum.KeyCode.S) do
                runService.Stepped:Wait()
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(0, 0, cframeFlySpeed)
                end
            end
        end,
    },
    [Enum.KeyCode.A] = {
        FLY_LEFT = function()
            while userInputService:IsKeyDown(Enum.KeyCode.A) do
                runService.Stepped:Wait()
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(-cframeFlySpeed, 0, 0)
                end
            end
        end,
    },
    [Enum.KeyCode.D] = {
        FLY_RIGHT = function()
            while userInputService:IsKeyDown(Enum.KeyCode.D) do
                runService.Stepped:Wait()
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(cframeFlySpeed, 0, 0)
                end
            end
        end,
    }
}

local flyStopKeybinds = {
    [Enum.KeyCode.Space] = {
        IGNORE_OFF = function()
            isCFrameFlying = false
        end,
    },
}

movementMaid:GiveTask(userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType ~= Enum.UserInputType.Keyboard or not flyKeybinds[input.KeyCode] then
            if flyKeybinds[input.UserInputType] then
                for _, func in pairs(flyKeybinds[input.UserInputType]) do
                    task.spawn(func)
                end
            end
        else
            for _, func in pairs(flyKeybinds[input.KeyCode]) do
                task.spawn(func)
            end
        end
    end
end))

movementMaid:GiveTask(userInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType ~= Enum.UserInputType.Keyboard or not flyStopKeybinds[input.KeyCode] then
            if flyStopKeybinds[input.UserInputType] then
                for _, func in pairs(flyStopKeybinds[input.UserInputType]) do
                    task.spawn(func)
                end
            end
        else
            for _, func in pairs(flyStopKeybinds[input.KeyCode]) do
                task.spawn(func)
            end
        end
    end
end))

local flyConfig = {
    enabled = false,
    speed = 30,
}

movementGroupbox:AddToggle('EnableCFrameFly', {
    Text = 'Enable/Disable CFrame Fly',
    Default = flyConfig.enabled,
    Tooltip = 'Enable or disable the CFrame fly functionality.',
    Callback = function(state)
        flyConfig.enabled = state
        shared.Active = state

        if state and flyLocalPlayer.Character then
            flyPivot = flyLocalPlayer.Character:GetPivot()
        end
    end,
})

movementGroupbox:AddSlider('FlySpeed', {
    Text = 'Fly Speed',
    Default = flyConfig.speed,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Tooltip = 'Adjust the speed of the CFrame fly.',
    Callback = function(value)
        flyConfig.speed = value
        cframeFlySpeed = value / 10
    end,
})

movementGroupbox:AddLabel('Keybind'):AddKeyPicker('ToggleFly', {
    Default = 'X',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Toggle Fly',
    Tooltip = 'Key to toggle fly on or off',
    Callback = function()
        if flyConfig.enabled then
            shared.Active = not shared.Active

            if shared.Active then
                if flyLocalPlayer.Character then
                    flyPivot = flyLocalPlayer.Character:GetPivot()
                end
            elseif flyLocalPlayer.Character then
                flyLocalPlayer.Character:PivotTo(flyPivot)
            end
        end
    end,
})

local hyperFireEnabled = false

local function handleRapidFire(tool)
    -- Stub logic for what would be rapidfire
end

local function applyRapidFireToCharacter(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA('Tool') and child:FindFirstChild('Handle') then
            handleRapidFire(child)
        end
    end

    character.ChildAdded:Connect(function(child)
        if child:IsA('Tool') and child:FindFirstChild('Handle') then
            handleRapidFire(child)
        end
    end)
end

if localPlayer.Character then
    applyRapidFireToCharacter(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(applyRapidFireToCharacter)

local function resetToleranceCooldown()
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant.Name == 'ToleranceCooldown' and descendant:IsA('ValueBase') then
            descendant.Value = 0
        end
    end
end

runService.RenderStepped:Connect(function()
    if hyperFireEnabled and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and localPlayer.Character then
        local tool = localPlayer.Character:FindFirstChildOfClass('Tool')

        if tool and tool:FindFirstChild('Ammo') then
            tool:Activate()
        end
    end
end)

local miscGroupbox = menuTabs.game:AddRightGroupbox('misc')

miscGroupbox:AddToggle('rapid fire', {
    Text = 'rapid fire',
    Default = false,
    Callback = function()
        task.spawn(function()
            while true do
                task.wait()
                local tool = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass('Tool')

                if tool and tool:FindFirstChild('GunScript') then
                    for _, connection in ipairs(getconnections(tool.Activated)) do
                        for i = 1, debug.getinfo(connection.Function).nups do
                            local upValueName = debug.getupvalue(connection.Function, i)
                            if type(upValueName) == 'number' then
                                debug.setupvalue(connection.Function, i, 1e-20)
                            end
                        end
                    end
                end
            end
        end)
    end,
})

miscGroupbox:AddToggle('HyperFireToggle', {
    Text = 'automatic guns',
    Default = false,
    Callback = function(state)
        hyperFireEnabled = state
        resetToleranceCooldown()
    end,
})

game.DescendantAdded:Connect(function(descendant)
    if descendant.Name == 'ToleranceCooldown' and descendant:IsA('ValueBase') then
        descendant.Value = hyperFireEnabled and 0 or 3
    end
end)

local shopGroupbox = menuTabs.game:AddRightGroupbox('Shop')
local workspaceService = game:GetService('Workspace')
local shopFolder = workspaceService:WaitForChild('Ignored'):WaitForChild('Shop')
local selectedShopItem = nil
local isBuyingItem = false
local autoBuyOnRespawnEnabled = false
local autoBuyAttempts = 0

shopGroupbox:AddDropdown('Shop_Dropdown', {
    Values = {
        '[Taco] - $2',
        '[Hamburger] - $5',
        '[Revolver] - $1421',
        '12 [Revolver Ammo] - $55',
        '90 [AUG Ammo] - $87',
        '[AUG] - $2131',
        '[Rifle] - $1694',
        '[LMG] - $4098',
        '200 [LMG Ammo] - $328',
    },
    Default = 1,
    Multi = false,
    Text = 'Select an Item',
    Callback = function(value)
        selectedShopItem = value
    end,
})

local function getLocalRootPart()
    return localPlayer.Character and localPlayer.Character:FindFirstChild('HumanoidRootPart')
end

local function executeBuyItem(itemName)
    if itemName and not isBuyingItem then
        isBuyingItem = true

        local desyncWasEnabled = desyncConfig.enabled
        if desyncWasEnabled then
            toggleDesyncState(false)
            task.wait(0.1)
        end

        local localRootPart = getLocalRootPart()

        if localRootPart then
            local shopItem = shopFolder:FindFirstChild(itemName)

            if shopItem then
                local clickDetector = shopItem:FindFirstChildOfClass('ClickDetector')

                if clickDetector then
                    local originalCFrame = localRootPart.CFrame
                    localRootPart.CFrame = CFrame.new(shopItem.Head.Position + Vector3.new(0, 3, 0))

                    task.wait(0.2)
                    fireclickdetector(clickDetector)
                    Window:Notify('Purchased: ' .. itemName, 3)

                    localRootPart.CFrame = originalCFrame
                else
                    Window:Notify('[ERROR] ClickDetector not found in ' .. itemName, 3)
                end
            else
                Window:Notify('[ERROR] Item not found: ' .. itemName, 3)
            end

            if desyncWasEnabled then
                task.wait(0.2)
                toggleDesyncState(true)
            end

            isBuyingItem = false
        else
            Window:Notify('[ERROR] No HumanoidRootPart found!', 3)
            isBuyingItem = false
        end
    end
end

local function executeBuyAmmo()
    if selectedShopItem and not isBuyingItem then
        local ammoMap = {
            ['[Revolver] - $1421'] = '12 [Revolver Ammo] - $55',
            ['[AUG] - $2131'] = '90 [AUG Ammo] - $87',
            ['[LMG] - $4098'] = '200 [LMG Ammo] - $328',
            ['[Rifle] - $1694'] = '5 [Rifle Ammo] - $273',
        }
        
        local ammoItem = ammoMap[selectedShopItem]

        if ammoItem then
            executeBuyItem(ammoItem)
        else
            Window:Notify('[ERROR] No ammo available.', 3)
        end
    end
end

local function performAutoBuy()
    if autoBuyOnRespawnEnabled and selectedShopItem then
        executeBuyItem(selectedShopItem)

        if autoBuyAttempts < 3 then
            for _ = 1, 3 do
                executeBuyAmmo()
                task.wait(0.5)
            end
            autoBuyAttempts = 3
        end
    end
end

shopGroupbox:AddToggle('AutoBuyOnRespawn', {
    Text = 'Auto Buy on Respawn',
    Default = false,
    Callback = function(state)
        autoBuyOnRespawnEnabled = state
        autoBuyAttempts = 0
    end,
})

shopGroupbox:AddButton({
    Text = 'Buy Item',
    Func = function()
        executeBuyItem(selectedShopItem)
    end,
    DoubleClick = false,
    Tooltip = 'Buys the selected item',
}):AddButton({
    Text = 'Buy Ammo',
    Func = function()
        executeBuyAmmo()
    end,
    DoubleClick = false,
    Tooltip = 'Buys ammo for the selected weapon',
})

localPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    shopFolder = workspaceService:WaitForChild('Ignored'):WaitForChild('Shop')
    performAutoBuy()
end)

miscGroupbox:AddButton('magicbullet', function()
    local mainModule = game:FindService('ReplicatedStorage').MainModule

    require(mainModule).Ignored = {
        workspace:WaitForChild('Vehicles'),
        workspace:WaitForChild('MAP'),
        workspace:WaitForChild('Ignored'),
    }
end)

getgenv().selectedPlayerTarget = nil
getgenv().selectedTeleportType = 'unsafe'
getgenv().serverPlayerList = {}
getgenv().autoKillEnabled = false
getgenv().isActionRunning = false
getgenv().actionOldPosition = nil

local function updateServerPlayerList()
    getgenv().serverPlayerList = {}

    for _, player in ipairs(playersService:GetPlayers()) do
        table.insert(getgenv().serverPlayerList, player.Name)
    end

    if getgenv().playerTargetDropdown then
        getgenv().playerTargetDropdown:SetValues(getgenv().serverPlayerList)
    end
end

updateServerPlayerList()
playersService.PlayerAdded:Connect(updateServerPlayerList)
playersService.PlayerRemoving:Connect(updateServerPlayerList)

local function executeKnockTarget(targetPlayer)
    local targetCharacter = targetPlayer.Character
    local humanoid = targetCharacter:FindFirstChild('Humanoid')
    local bodyEffects = targetCharacter:FindFirstChild('BodyEffects')

    if bodyEffects and humanoid then
        local koValue = bodyEffects:WaitForChild('K.O', 5)

        if koValue then
            local startingPosition = localPlayer.Character.HumanoidRootPart.Position

            task.spawn(function()
                while not koValue.Value and getgenv().isActionRunning do
                    local targetPosition = targetCharacter.HumanoidRootPart.Position
                    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))

                    local equippedTool = localPlayer.Character:FindFirstChildWhichIsA('Tool')

                    if equippedTool and equippedTool:FindFirstChild('Ammo') then
                        game:GetService("ReplicatedStorage").MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle'), equippedTool:FindFirstChild('Handle').CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1))
                    end
                    task.wait()
                end

                localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(startingPosition)
            end)
        else
            warn('K.O value not found!')
        end
    else
        warn('BodyEffects or Humanoid not found in the character!')
    end
end

local function executeBringTarget(targetPlayer)
    local targetCharacter = targetPlayer.Character

    if targetCharacter then
        local humanoid = targetCharacter:FindFirstChild('Humanoid')
        local bodyEffects = targetCharacter:FindFirstChild('BodyEffects')

        if bodyEffects and humanoid then
            local koValue = bodyEffects:FindFirstChild('K.O')

            if koValue then
                local localCharacter = localPlayer.Character

                if localCharacter then
                    local rootPart = localCharacter:FindFirstChild('HumanoidRootPart')

                    if rootPart then
                        getgenv().actionOldPosition = rootPart.Position
                        getgenv().isActionRunning = true

                        task.spawn(function()
                            while not koValue.Value and getgenv().isActionRunning do
                                local targetPosition = targetCharacter:FindFirstChild('HumanoidRootPart') and targetCharacter.HumanoidRootPart.Position or nil

                                if targetPosition then
                                    rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))
                                end

                                local equippedTool = localCharacter:FindFirstChildWhichIsA('Tool')

                                if equippedTool and equippedTool:FindFirstChild('Ammo') then
                                    game:GetService('ReplicatedStorage').MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle'), equippedTool:FindFirstChild('Handle').CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1))
                                end
                                task.wait()
                            end

                            while not koValue.Value do
                                local upperTorso = targetCharacter:FindFirstChild('UpperTorso')

                                if upperTorso then
                                    rootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                                    runService.RenderStepped:Wait()
                                end

                                game:GetService('ReplicatedStorage'):WaitForChild('MainEvent'):FireServer('Grabbing', false)
                                task.wait(0.1)

                                if targetCharacter:FindFirstChild('GRABBING_CONSTRAINT') then
                                    task.wait(0.2)
                                    rootPart.CFrame = CFrame.new(getgenv().actionOldPosition)
                                    return
                                end
                            end

                            getgenv().isActionRunning = false
                            rootPart.CFrame = CFrame.new(getgenv().actionOldPosition)
                        end)
                    end
                end
            end
        end
    end
end

local function executeStompTarget(targetPlayer)
    local targetCharacter = targetPlayer.Character
    local humanoid = targetCharacter:FindFirstChild('Humanoid')
    local bodyEffects = targetCharacter:FindFirstChild('BodyEffects')

    if bodyEffects and humanoid then
        local koValue = bodyEffects:WaitForChild('K.O', 5)
        local deathValue = bodyEffects:WaitForChild('SDeath', 5)

        if koValue and deathValue then
            getgenv().actionOldPosition = localPlayer.Character.HumanoidRootPart.Position

            task.spawn(function()
                while not koValue.Value and getgenv().isActionRunning do
                    local targetPosition = targetCharacter.HumanoidRootPart.Position
                    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))
                    local equippedTool = localPlayer.Character:FindFirstChildWhichIsA('Tool')

                    if equippedTool and equippedTool:FindFirstChild('Ammo') then
                        game:GetService("ReplicatedStorage").MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle'), equippedTool:FindFirstChild('Handle').CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1))
                    end
                    task.wait()
                end

                while not deathValue.Value and getgenv().isActionRunning do
                    local upperTorso = targetCharacter:FindFirstChild('UpperTorso')

                    if upperTorso then
                        local rootPart = localPlayer.Character:WaitForChild('HumanoidRootPart')
                        rootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                        runService.RenderStepped:Wait()
                    end

                    game:GetService("ReplicatedStorage").MainEvent:FireServer('Stomp')
                    task.wait()
                end

                localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv().actionOldPosition)
            end)
        else
            warn('K.O or SDeath value not found!')
        end
    end
end

local function executeVoidTarget(targetPlayer)
    local targetCharacter = targetPlayer.Character

    if targetCharacter then
        local humanoid = targetCharacter:FindFirstChild('Humanoid')
        local bodyEffects = targetCharacter:FindFirstChild('BodyEffects')

        if bodyEffects and humanoid then
            local koValue = bodyEffects:FindFirstChild('K.O')

            if koValue then
                local localCharacter = localPlayer.Character

                if localCharacter then
                    local rootPart = localCharacter:FindFirstChild('HumanoidRootPart')

                    if rootPart then
                        getgenv().actionOldPosition = rootPart.Position
                        getgenv().isActionRunning = true

                        task.spawn(function()
                            while not koValue.Value and getgenv().isActionRunning do
                                local targetPosition = targetCharacter:FindFirstChild('HumanoidRootPart') and targetCharacter.HumanoidRootPart.Position or nil

                                if targetPosition then
                                    rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0))
                                end

                                local equippedTool = localCharacter:FindFirstChildWhichIsA('Tool')

                                if equippedTool and equippedTool:FindFirstChild('Ammo') then
                                    game:GetService('ReplicatedStorage').MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle'), equippedTool:FindFirstChild('Handle').CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1))
                                end
                                task.wait()
                            end

                            while true do
                                local upperTorso = targetCharacter:FindFirstChild('UpperTorso')

                                if upperTorso then
                                    rootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                                    runService.RenderStepped:Wait()
                                end

                                game:GetService('ReplicatedStorage'):WaitForChild('MainEvent'):FireServer('Grabbing', false)
                                task.wait(0.2)

                                if targetCharacter:FindFirstChild('GRABBING_CONSTRAINT') then
                                    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1000, 10000, -1000)

                                    task.wait(0.3)
                                    game:GetService('ReplicatedStorage'):WaitForChild('MainEvent'):FireServer('Grabbing', false)
                                    task.wait(0.2)

                                    rootPart.CFrame = CFrame.new(getgenv().actionOldPosition)
                                    return
                                end
                            end
                        end)
                    end
                end
            end
        end
    end
end

local function stopAllPlayerActions()
    getgenv().isActionRunning = false

    if getgenv().actionOldPosition then
        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv().actionOldPosition)
    end

    Window:Notify('All actions stopped.', 5)
end

local playerInfoGroupbox = menuTabs.rage:AddLeftGroupbox('Player Info')

playerInfoGroupbox:AddToggle('view', {
    Text = 'View',
    Default = false,
    Callback = function(state)
        if state and getgenv().selectedPlayerTarget then
            local targetPlayer = playersService:FindFirstChild(getgenv().selectedPlayerTarget)

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild('Humanoid') then
                workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
            end
        else
            workspace.CurrentCamera.CameraSubject = localPlayer.Character.Humanoid
        end
    end,
})

playerInfoGroupbox:AddButton('Teleport', function()
    local targetPlayer = playersService:FindFirstChild(getgenv().selectedPlayerTarget)

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild('HumanoidRootPart') then
        localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end)

playerInfoGroupbox:AddDropdown('teleportType', {
    Values = {
        'safe',
        'unsafe',
    },
    Default = 'unsafe',
    Multi = false,
    Text = 'Teleport Type',
    Callback = function(value)
        getgenv().selectedTeleportType = value
    end,
})

getgenv().playerTargetDropdown = playerInfoGroupbox:AddDropdown('yepyep', {
    SpecialType = 'Player',
    Text = 'Select a Player',
    Tooltip = 'Select a player to perform actions on.',
    Callback = function(value)
        getgenv().selectedPlayerTarget = value
    end,
})

playerInfoGroupbox:AddInput('playerSearch', {
    Text = 'Search Player',
    Tooltip = 'Type to search for a player.',
    Callback = function(value)
        local lowerSearch = string.lower(value)
        local matchedPlayers = {}

        for _, player in ipairs(playersService:GetPlayers()) do
            local lowerName = string.lower(player.Name)
            local lowerDisplayName = string.lower(player.DisplayName)

            if string.find(lowerName, lowerSearch) or string.find(lowerDisplayName, lowerSearch) then
                table.insert(matchedPlayers, player.Name)
            end
        end

        uiOptions.yepyep:SetValue(matchedPlayers)

        if #matchedPlayers == 1 then
            uiOptions.myPlayerDropdown:SetValue(matchedPlayers[1])
            getgenv().selectedPlayerTarget = matchedPlayers[1]
        end
    end,
})

local playerActionsGroupbox = menuTabs.rage:AddRightGroupbox('Player Actions')

playerActionsGroupbox:AddDropdown('actionType', {
    Values = {
        'Knock',
        'Bring',
        'Stomp',
        'Void',
    },
    Default = 'Knock',
    Multi = false,
    Text = 'action',
    Callback = function(value)
        getgenv().selectedActionMethod = value
    end,
})

playerActionsGroupbox:AddButton('Execute Action', function()
    local targetPlayer = playersService:FindFirstChild(getgenv().selectedPlayerTarget)

    if targetPlayer and targetPlayer.Character then
        local equippedTool = localPlayer.Character:FindFirstChildWhichIsA('Tool')

        if equippedTool and equippedTool:FindFirstChild('Ammo') then
            getgenv().isActionRunning = true
            getgenv().actionOldPosition = localPlayer.Character.HumanoidRootPart.Position

            if getgenv().selectedActionMethod == 'Knock' then
                executeKnockTarget(targetPlayer)
            elseif getgenv().selectedActionMethod == 'Bring' then
                executeBringTarget(targetPlayer)
            elseif getgenv().selectedActionMethod == 'Stomp' then
                executeStompTarget(targetPlayer)
            elseif getgenv().selectedActionMethod == 'Void' then
                executeVoidTarget(targetPlayer)
            end
        else
            Window:Notify('Equip a tool to use this function. | hysteria.cc', 5)
        end
    end
end)

playerActionsGroupbox:AddToggle('AutoKill', {
    Text = 'Auto Kill',
    Default = false,
    Callback = function(state)
        getgenv().autoKillEnabled = state

        task.spawn(function()
            while getgenv().autoKillEnabled and getgenv().selectedPlayerTarget do
                local targetPlayer = playersService:FindFirstChild(getgenv().selectedPlayerTarget)

                if targetPlayer and targetPlayer.Character then
                    executeStompTarget(targetPlayer)
                end
                task.wait()
            end
        end)
    end,
})

playerActionsGroupbox:AddButton('Stop', function()
    stopAllPlayerActions()
end)

local massActionsGroupbox = menuTabs.rage:AddRightGroupbox('player actions')
getgenv().actionShopFolder = workspaceService:WaitForChild('Ignored'):WaitForChild('Shop')
getgenv().massActionOriginalPosition = nil
getgenv().killAllActive = false
getgenv().stompAllActive = false

local function buyItemForMassAction(itemName)
    for _, child in pairs(localPlayer.Character:GetChildren()) do
        if child:IsA('Tool') then
            child.Parent = localPlayer.Backpack
        end
    end

    for _, shopItem in pairs(getgenv().actionShopFolder:GetChildren()) do
        if shopItem.Name == itemName then
            local headPart = shopItem:FindFirstChild('Head')

            if headPart then
                localPlayer.Character.HumanoidRootPart.CFrame = headPart.CFrame + Vector3.new(0, 3.2, 0)
                task.wait(0.1)
                fireclickdetector(shopItem:FindFirstChild('ClickDetector'))
            end
            break
        end
    end
end

local function equipLmgTool()
    for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
        if tool.Name == '[LMG]' then
            tool.Parent = localPlayer.Character
            return tool
        end
    end

    for _, tool in pairs(localPlayer.Character:GetChildren()) do
        if tool.Name == '[LMG]' then
            return tool
        end
    end

    return nil
end

local function executeGunShot(targetPlayer, gunTool)
    if gunTool:FindFirstChild('Handle') then
        local targetHead = targetPlayer.Character:FindFirstChild('Head')

        if targetHead then
            game:GetService("ReplicatedStorage").MainEvent:FireServer('ShootGun', gunTool.Handle, gunTool.Handle.CFrame.Position, targetHead.Position, targetHead, Vector3.new(0, 0, -1))
        end
    end
end

local function isPlayerKnockedOut(player)
    local bodyEffects = player.Character:FindFirstChild('BodyEffects')
    if not bodyEffects then return false end

    local koValue = bodyEffects:FindFirstChild('K.O')
    if koValue then return koValue.Value end

    return false
end

local function isPlayerShielded(player)
    return player.Character and player.Character:FindFirstChild('ForceField')
end

local function isPlayerBeingGrabbed(player)
    return player.Character and player.Character:FindFirstChild('GRABBING_CONSTRAINT')
end

local function isPlayerOutOfRange(player)
    return (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude > 10000
end

local function performKillAll()
    getgenv().massActionOriginalPosition = localPlayer.Character.HumanoidRootPart.CFrame

    for _, child in pairs(localPlayer.Character:GetChildren()) do
        if child:IsA('Tool') then
            child.Parent = localPlayer.Backpack
        end
    end

    while not (localPlayer.Backpack:FindFirstChild('[LMG]') or localPlayer.Character:FindFirstChild('[LMG]')) do
        buyItemForMassAction('[LMG] - $4098')
        task.wait(0.2)
    end

    for _ = 1, 5 do
        buyItemForMassAction('200 [LMG Ammo] - $328')
        task.wait(0)
    end

    local lmgTool = equipLmgTool()

    if lmgTool then
        for _, player in pairs(playersService:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild('HumanoidRootPart') and not (isPlayerShielded(player) or isPlayerKnockedOut(player) or isPlayerBeingGrabbed(player) or isPlayerOutOfRange(player)) then
                workspace.CurrentCamera.CameraSubject = player.Character.Humanoid

                while not isPlayerKnockedOut(player) and getgenv().killAllActive do
                    localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame - Vector3.new(0, 20, 0)
                    executeGunShot(player, lmgTool)
                    task.wait(0)
                end

                if not getgenv().killAllActive then
                    break
                end
            end
        end

        if getgenv().massActionOriginalPosition then
            localPlayer.Character.HumanoidRootPart.CFrame = getgenv().massActionOriginalPosition
        end

        workspace.CurrentCamera.CameraSubject = localPlayer.Character.Humanoid

        if getgenv().stompAllActive then
            performStompAll()
        end
    end
end

local function performStompAll()
    for _, player in pairs(playersService:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild('HumanoidRootPart') then
            local targetCharacter = player.Character
            local humanoid = targetCharacter:FindFirstChild('Humanoid')
            local bodyEffects = targetCharacter:FindFirstChild('BodyEffects')

            if bodyEffects and humanoid then
                local koValue = bodyEffects:FindFirstChild('K.O')
                local deathValue = bodyEffects:FindFirstChild('SDeath')

                if koValue and deathValue and koValue.Value and not deathValue.Value then
                    while not deathValue.Value and getgenv().stompAllActive do
                        if not koValue.Value or isPlayerBeingGrabbed(player) then
                            break
                        end

                        local upperTorso = targetCharacter:FindFirstChild('UpperTorso')

                        if upperTorso then
                            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0))
                            runService.RenderStepped:Wait()
                        end

                        game:GetService("ReplicatedStorage").MainEvent:FireServer('Stomp')
                        task.wait(0)
                    end
                end
            end
        end
    end
end

massActionsGroupbox:AddToggle('KillAllToggle', {
    Text = 'Kill All',
    Default = false,
    Callback = function(state)
        getgenv().killAllActive = state

        if state then
            task.spawn(performKillAll)
        else
            if getgenv().massActionOriginalPosition then
                localPlayer.Character.HumanoidRootPart.CFrame = getgenv().massActionOriginalPosition
            end

            workspace.CurrentCamera.CameraSubject = localPlayer.Character.Humanoid
        end
    end,
})

massActionsGroupbox:AddToggle('StompAllToggle', {
    Text = 'Stomp All',
    Default = false,
    Callback = function(state)
        getgenv().stompAllActive = state

        if state and not getgenv().killAllActive then
            task.spawn(performStompAll)
        end
    end,
})

local streamableGroupbox = menuTabs.legit:AddRightGroupbox('streamable')

local streamableSettings = {
    Enabled = false,
    HitPart = 'Head',
    KOCheck = false,
    StickyAimEnabled = false,
    TargetPlayer = nil,
    HitChance = 100,
    LockOnKeybindEnabled = false,
    LockedTarget = nil,
    ShowTracer = false,
    FOV = {
        Enabled = false,
        Radius = 100,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 1,
    },
}

local fovCircle = Drawing.new('Circle')
fovCircle.Color = streamableSettings.FOV.Color
fovCircle.Thickness = streamableSettings.FOV.Thickness
fovCircle.Filled = false
fovCircle.Transparency = streamableSettings.FOV.Transparency
fovCircle.Radius = streamableSettings.FOV.Radius

local fovTracerLine = Drawing.new('Line')
fovTracerLine.Color = streamableSettings.FOV.Color
fovTracerLine.Thickness = streamableSettings.FOV.Thickness
fovTracerLine.Transparency = streamableSettings.FOV.Transparency
fovTracerLine.Visible = false

local function getStreamableTarget()
    local shortestDistance = math.huge
    local mouseLocation = userInputService:GetMouseLocation()
    local targetPart = nil

    for _, player in pairs(playersService:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local hitPart = character:FindFirstChild(streamableSettings.HitPart)
            local humanoid = character:FindFirstChild('Humanoid')
            local bodyEffects = character:FindFirstChild('BodyEffects')

            if bodyEffects then
                bodyEffects = character.BodyEffects:FindFirstChild('K.O')
            end

            if hitPart and humanoid and humanoid.Health > 0 and (not streamableSettings.KOCheck or bodyEffects and not bodyEffects.Value) then
                local screenPosition, onScreen = currentCamera:WorldToViewportPoint(hitPart.Position)

                if onScreen then
                    local magnitude = (mouseLocation - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude

                    if magnitude < shortestDistance then
                        if magnitude <= streamableSettings.FOV.Radius then
                            targetPart = hitPart
                            shortestDistance = magnitude
                        end
                    end
                end
            end
        end
    end

    return targetPart
end

local function getStreamableStickyTarget()
    if streamableSettings.TargetPlayer and streamableSettings.TargetPlayer.Character then
        local hitPart = streamableSettings.TargetPlayer.Character:FindFirstChild(streamableSettings.HitPart)
        local humanoid = streamableSettings.TargetPlayer.Character:FindFirstChild('Humanoid')
        local bodyEffects = streamableSettings.TargetPlayer.Character:FindFirstChild('BodyEffects')

        if bodyEffects then
            bodyEffects = streamableSettings.TargetPlayer.Character.BodyEffects:FindFirstChild('K.O')
        end

        if hitPart and humanoid and humanoid.Health > 0 and (not streamableSettings.KOCheck or bodyEffects and not bodyEffects.Value) then
            return hitPart
        end
    end

    return nil
end

local rawMtHook = getrawmetatable(game)
local backupIndexHook = rawMtHook.__index

setreadonly(rawMtHook, false)

function rawMtHook.__index(self, key)
    if not checkcaller() and self == playerMouse and streamableSettings.Enabled and (key == 'Hit' or key == 'Target') then
        local streamableTargetPart

        if streamableSettings.LockOnKeybindEnabled and streamableSettings.LockedTarget then
            streamableTargetPart = streamableSettings.LockedTarget
        elseif streamableSettings.StickyAimEnabled then
            streamableTargetPart = getStreamableStickyTarget()
        else
            streamableTargetPart = getStreamableTarget()
        end

        if streamableTargetPart then
            if math.random(0, 100) <= streamableSettings.HitChance then
                return CFrame.new(streamableTargetPart.Position)
            end

            local randomizedOffset = Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
            return CFrame.new(streamableTargetPart.Position + randomizedOffset)
        end
    end

    return backupIndexHook(self, key)
end

runService.RenderStepped:Connect(function()
    local isVisible = streamableSettings.FOV.Enabled

    if isVisible then
        isVisible = streamableSettings.Enabled
    end

    fovCircle.Visible = isVisible
    fovCircle.Position = userInputService:GetMouseLocation()
    fovCircle.Radius = streamableSettings.FOV.Radius

    if streamableSettings.ShowTracer and streamableSettings.Enabled then
        local lockedTarget = streamableSettings.LockedTarget or getStreamableTarget()

        if lockedTarget then
            local screenPos = currentCamera:WorldToViewportPoint(lockedTarget.Position)

            fovTracerLine.From = Vector2.new(fovCircle.Position.X, fovCircle.Position.Y + fovCircle.Radius)
            fovTracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
            fovTracerLine.Visible = true
        else
            fovTracerLine.Visible = false
        end
    else
        fovTracerLine.Visible = false
    end
end)

streamableGroupbox:AddToggle('Enabled', {
    Text = 'streamable silent aim',
    Default = false,
    Callback = function(state)
        streamableSettings.Enabled = state
    end,
})

streamableGroupbox:AddToggle('KOCheck', {
    Text = 'K.O Check',
    Default = false,
    Callback = function(state)
        streamableSettings.KOCheck = state
    end,
})

streamableGroupbox:AddToggle('FOVEnabled', {
    Text = 'show FOV',
    Default = false,
    Callback = function(state)
        streamableSettings.FOV.Enabled = state
    end,
})

streamableGroupbox:AddToggle('ShowTracer', {
    Text = 'show tracer',
    Default = false,
    Callback = function(state)
        streamableSettings.ShowTracer = state
    end,
})

streamableGroupbox:AddSlider('FOVRadius', {
    Min = 0,
    Max = 500,
    Default = 100,
    Rounding = 0,
    Text = 'FOV radius',
    Callback = function(value)
        streamableSettings.FOV.Radius = value
    end,
})

streamableGroupbox:AddSlider('FOVThickness', {
    Min = 1,
    Max = 10,
    Default = 2,
    Rounding = 0,
    Text = 'FOV thickness',
    Callback = function(value)
        fovCircle.Thickness = value
    end,
})

streamableGroupbox:AddSlider('FOVTransparency', {
    Min = 0,
    Max = 1,
    Default = 1,
    Rounding = 2,
    Text = 'FOV transparency',
    Callback = function(value)
        fovCircle.Transparency = value
    end,
})

streamableGroupbox:AddDropdown('HitPart', {
    Values = {
        'Head',
        'UpperTorso',
        'HumanoidRootPart',
        'LowerTorso',
        'LeftHand',
        'RightHand',
        'LeftLowerArm',
        'RightLowerArm',
        'LeftUpperArm',
        'RightUpperArm',
        'LeftFoot',
        'LeftLowerLeg',
        'LeftUpperLeg',
        'RightLowerLeg',
        'RightFoot',
        'RightUpperLeg',
    },
    Default = 'Head',
    Multi = false,
    Text = 'hit part',
    Callback = function(value)
        streamableSettings.HitPart = value
    end,
})

streamableGroupbox:AddSlider('HitChance', {
    Min = 0,
    Max = 100,
    Default = 100,
    Rounding = 0,
    Text = 'hit chance',
    Callback = function(value)
        streamableSettings.HitChance = value
    end,
})

local hitboxServices = {
    Players = cloneref(game:GetService('Players')),
    Workspace = cloneref(game:GetService('Workspace')),
    Camera = cloneref(game:GetService('Workspace')).CurrentCamera,
}

local hitboxSettings = {
    scriptEnabled = false,
    expanderActive = false,
    size = 30,
    transparency = 0.5,
    expandedPlayer = nil,
    originalProperties = {},
}

local hitboxGroupbox = menuTabs.legit:AddRightGroupbox('hitbox')

local function getHitboxTargetPlayer()
    local shortestDistance = math.huge
    local mouseVector = Vector2.new(hitboxServices.Players.LocalPlayer:GetMouse().X, hitboxServices.Players.LocalPlayer:GetMouse().Y)
    local targetPlayer = nil

    for _, player in pairs(hitboxServices.Players:GetPlayers()) do
        if player ~= hitboxServices.Players.LocalPlayer and player.Character then
            local rootPart = player.Character:FindFirstChild('HumanoidRootPart')

            if rootPart then
                local screenPos, onScreen = hitboxServices.Camera:WorldToScreenPoint(rootPart.Position)

                if onScreen then
                    local magnitude = (mouseVector - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                    if magnitude < shortestDistance then
                        targetPlayer = player
                        shortestDistance = magnitude
                    end
                end
            end
        end
    end

    return targetPlayer
end

local function applySelectionBox(part, transparencyValue)
    local selectionBox = Instance.new('SelectionBox')
    selectionBox.Adornee = part
    selectionBox.LineThickness = 0.05
    selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
    selectionBox.Transparency = transparencyValue or 0.2
    selectionBox.Parent = part
end

local function applyBoxAdornments(part, transparencyValue)
    local offsetVectors = {
        Vector3.new(1, 1, 1),
        Vector3.new(-1, 1, 1),
        Vector3.new(1, -1, 1),
        Vector3.new(-1, -1, 1),
        Vector3.new(1, 1, -1),
        Vector3.new(-1, 1, -1),
        Vector3.new(1, -1, -1),
        Vector3.new(-1, -1, -1),
    }

    for _, vectorOffset in pairs(offsetVectors) do
        local boxAdornment = Instance.new('BoxHandleAdornment')
        boxAdornment.Adornee = part
        boxAdornment.Size = Vector3.new(0.2, 0.2, 0.2)
        boxAdornment.Color3 = Color3.fromRGB(0, 200, 200)
        boxAdornment.Transparency = transparencyValue or 0.1
        boxAdornment.AlwaysOnTop = true
        boxAdornment.CFrame = CFrame.new(vectorOffset * (part.Size / 2))
        boxAdornment.Parent = part
    end
end

local function updateHitboxTransparency(part, transparencyValue)
    for _, child in pairs(part:GetChildren()) do
        if child:IsA('SelectionBox') or child:IsA('BoxHandleAdornment') then
            child.Transparency = transparencyValue
        end
    end
end

local function revertHitboxExpander(player)
    if player and player.Character then
        local rootPart = player.Character:FindFirstChild('HumanoidRootPart')

        if rootPart and hitboxSettings.originalProperties[player] then
            rootPart.Size = hitboxSettings.originalProperties[player].Size
            rootPart.Transparency = hitboxSettings.originalProperties[player].Transparency
            rootPart.CanCollide = hitboxSettings.originalProperties[player].CanCollide

            for _, child in pairs(rootPart:GetChildren()) do
                if child:IsA('SelectionBox') or child:IsA('BoxHandleAdornment') then
                    child:Destroy()
                end
            end

            hitboxSettings.originalProperties[player] = nil
        end
    end
end

local function executeHitboxExpander()
    if hitboxSettings.scriptEnabled then
        if hitboxSettings.expanderActive then
            local targetPlayer = getHitboxTargetPlayer()
            local targetRootPart = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild('HumanoidRootPart')

            if targetRootPart then
                if hitboxSettings.expandedPlayer and hitboxSettings.expandedPlayer ~= targetPlayer then
                    revertHitboxExpander(hitboxSettings.expandedPlayer)
                end
                
                if not hitboxSettings.originalProperties[targetPlayer] then
                    hitboxSettings.originalProperties[targetPlayer] = {
                        Size = targetRootPart.Size,
                        Transparency = targetRootPart.Transparency,
                        CanCollide = targetRootPart.CanCollide,
                    }
                end

                hitboxSettings.expandedPlayer = targetPlayer
                targetRootPart.Size = Vector3.new(hitboxSettings.size, hitboxSettings.size, hitboxSettings.size)
                targetRootPart.Transparency = hitboxSettings.transparency
                targetRootPart.CanCollide = false

                if not targetRootPart:FindFirstChild('SelectionBox') then
                    applySelectionBox(targetRootPart, hitboxSettings.transparency)
                end

                applyBoxAdornments(targetRootPart, hitboxSettings.transparency)
            end
        elseif hitboxSettings.expandedPlayer then
            revertHitboxExpander(hitboxSettings.expandedPlayer)
            hitboxSettings.expandedPlayer = nil
        end
    end
end

hitboxGroupbox:AddToggle('MasterToggle', {
    Text = 'Enable Expander',
    Default = hitboxSettings.scriptEnabled,
    Tooltip = 'Enable or disable the entire hitbox expander system.',
    Callback = function(state)
        hitboxSettings.scriptEnabled = state

        if not hitboxSettings.scriptEnabled then
            hitboxSettings.expanderActive = false
            executeHitboxExpander()
        end
    end,
})

hitboxGroupbox:AddToggle('ExpanderToggle', {
    Text = 'Expander Keybind',
    Default = hitboxSettings.expanderActive,
    Tooltip = 'Enable or disable the whole function',
    Callback = function(state)
        if hitboxSettings.scriptEnabled then
            hitboxSettings.expanderActive = state
            executeHitboxExpander()
        end
    end,
}):AddKeyPicker('ExpanderKeyPicker', {
    Default = 'H',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Expander Keybind',
    Tooltip = 'The key to hitbox expand a player',
    Callback = function()
        if hitboxSettings.scriptEnabled then
            hitboxSettings.expanderActive = not hitboxSettings.expanderActive
            executeHitboxExpander()
        end
    end,
})

hitboxGroupbox:AddSlider('TransparencySlider', {
    Text = 'Hitbox Transparency',
    Default = hitboxSettings.transparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Tooltip = 'Set the transparency of the hitbox.',
    Callback = function(value)
        hitboxSettings.transparency = value

        local expandedRootPart = hitboxSettings.expandedPlayer and hitboxSettings.expandedPlayer.Character:FindFirstChild('HumanoidRootPart')

        if expandedRootPart then
            expandedRootPart.Transparency = value
            updateHitboxTransparency(expandedRootPart, value)
        end
    end,
})

hitboxGroupbox:AddSlider('SizeSlider', {
    Text = 'Hitbox Size',
    Default = hitboxSettings.size,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Tooltip = 'Set the size of the hitbox.',
    Callback = function(value)
        hitboxSettings.size = value

        local expandedRootPart = hitboxSettings.expandedPlayer and hitboxSettings.expandedPlayer.Character:FindFirstChild('HumanoidRootPart')

        if expandedRootPart then
            expandedRootPart.Size = Vector3.new(value, value, value)
        end
    end,
})

miscGroupbox:AddDivider()

miscGroupbox:AddToggle('anti stomp', {
    Text = 'Anti Stomp',
    Default = false,
    Callback = function()
        local function executeAntiStomp(characterReference)
            for _, part in pairs(characterReference:GetDescendants()) do
                if part:IsA('BasePart') then
                    part:Destroy()
                end
            end
        end

        local function monitorKnockoutStatus(characterReference)
            local koValueObj = characterReference:WaitForChild('BodyEffects'):WaitForChild('K.O')
            koValueObj.GetPropertyChangedSignal('Value'):Connect(function()
                if koValueObj.Value == true then
                    executeAntiStomp(characterReference)
                end
            end)
        end

        game.Players.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
            monitorKnockoutStatus(newCharacter)
        end)
        
        if game.Players.LocalPlayer.Character then
            monitorKnockoutStatus(game.Players.LocalPlayer.Character)
        end
    end,
})