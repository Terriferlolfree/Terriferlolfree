
pcall(function()
    Library:Notify("Mobile UI Loaded", 3)
end)

--[[
This file was generated on https://dsc.gg/decompiler | Pulsar v1.5
Resolved: 421 identifiers | 48 functions | 0 Strings | Renamed: 48 functions | Connected: 22 callbacks | Dead Code Removed: 14 blocks | Inlined: 26 wrappers | Detected loop: 24 blocks
[Renamer: ON] [Decompiler: ON]
]]

local repo = "https://raw.githubusercontent.com/Mc4121ban/Linoria-Library-Mobile/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua") end)) end)() end)
-- ThemeManager removed for mobile compatibility
-- SaveManager removed for mobile compatibility

local Window = Library:CreateWindow({
    Title = 'hysteria.cc | Da Hood | v1.0.0',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
}) end)

local menuTabs = {
    rage = Window:AddTab('rage') end),
    legit = Window:AddTab('legit') end),
    game = Window:AddTab('game') end),
    visuals = Window:AddTab('visuals') end),
    uiSettings = Window:AddTab('UI Settings') end),
}

local camlockGroupbox = menuTabs.legit:AddLeftGroupbox('camlock') end)

local camlockSettings = {
    Players = game:GetService('Players') end),
    RunService = game:GetService('RunService') end),
    LocalPlayer = game:GetService('Players') end).LocalPlayer,
    Camera = workspace.CurrentCamera,
    Mouse = game:GetService('Players') end).LocalPlayer:GetMouse() end),
    isLockedOn = false,
    targetPlayer = nil,
    lockEnabled = false,
    aimLockEnabled = false,
    smoothingFactor = 0.1,
    predictionFactor = 0,
    bodyPartSelected = 'Head',
    teamCheckEnabled = false,
}

local function getClosestBodyPart(character, partName) end)
    return character:FindFirstChild(partName) end) and partName and partName or 'Head'
end

local function checkTeam(player) end)
    return not camlockSettings.teamCheckEnabled and true or player.Team ~= camlockSettings.LocalPlayer.Team
end

local function getCamlockTarget() end)
    if not camlockSettings.aimLockEnabled then
        return nil
    end

    local shortestDistance = math.huge
    local targetPlayer = nil

    for _, player in pairs(camlockSettings.Players:GetPlayers() end)) end) do
        if player ~= camlockSettings.LocalPlayer and player.Character and player.Character:FindFirstChild(camlockSettings.bodyPartSelected) end) and checkTeam(player) end) then
            local targetPart = player.Character[camlockSettings.bodyPartSelected]
            local screenPosition, onScreen = camlockSettings.Camera:WorldToViewportPoint(targetPart.Position) end)

            if onScreen then
                local magnitude = (Vector2.new(screenPosition.X, screenPosition.Y) end) - Vector2.new(camlockSettings.Mouse.X, camlockSettings.Mouse.Y) end)) end).Magnitude

                if magnitude < shortestDistance then
                    targetPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end

    return targetPlayer
end

local function toggleCamlock() end)
    if camlockSettings.lockEnabled and camlockSettings.aimLockEnabled then
        if camlockSettings.isLockedOn then
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        else
            camlockSettings.targetPlayer = getCamlockTarget() end)

            if camlockSettings.targetPlayer and camlockSettings.targetPlayer.Character then
                local targetPart = getClosestBodyPart(camlockSettings.targetPlayer.Character, camlockSettings.bodyPartSelected) end)

                if camlockSettings.targetPlayer.Character:FindFirstChild(targetPart) end) then
                    camlockSettings.isLockedOn = true
                end
            end
        end
    end
end

camlockSettings.RunService.RenderStepped:Connect(function() end)
    if camlockSettings.aimLockEnabled and camlockSettings.lockEnabled and camlockSettings.isLockedOn and camlockSettings.targetPlayer and camlockSettings.targetPlayer.Character then
        local targetPartName = getClosestBodyPart(camlockSettings.targetPlayer.Character, camlockSettings.bodyPartSelected) end)
        local targetPart = camlockSettings.targetPlayer.Character:FindFirstChild(targetPartName) end)

        if targetPart and camlockSettings.targetPlayer.Character:FindFirstChildOfClass('Humanoid') end).Health > 0 then
            local predictedPosition = targetPart.Position + targetPart.AssemblyLinearVelocity * camlockSettings.predictionFactor
            local currentPosition = camlockSettings.Camera.CFrame.Position

            camlockSettings.Camera.CFrame = CFrame.new(currentPosition, predictedPosition) end) * CFrame.new(0, 0, camlockSettings.smoothingFactor) end)
        else
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        end
    end
end) end)

camlockGroupbox:AddToggle('aimLock_Enabled', {
    Text = 'Enable/Disable AimLock',
    Default = false,
    Tooltip = 'Toggle the AimLock feature on or off.',
    Callback = function(state) end)
        camlockSettings.aimLockEnabled = state

        if not camlockSettings.aimLockEnabled then
            camlockSettings.lockEnabled = false
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        end
    end,
}) end)

camlockGroupbox:AddToggle('aim_Enabled', {
    Text = 'AimLock Keybind',
    Default = false,
    Tooltip = 'Toggle AimLock on or off.',
    Callback = function(state) end)
        camlockSettings.lockEnabled = state

        if not camlockSettings.lockEnabled then
            camlockSettings.isLockedOn = false
            camlockSettings.targetPlayer = nil
        end
    end,
}) end):AddKeyPicker('aim_Enabled_KeyPicker', {
    Default = 'Q',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'AimLock Key',
    Tooltip = 'Key to toggle AimLock',
    Callback = function() end)
        toggleCamlock() end)
    end,
}) end)

camlockGroupbox:AddSlider('Prediction', {
    Text = 'Prediction Factor',
    Default = 0,
    Min = 0,
    Max = 0.9,
    Rounding = 3,
    Tooltip = 'Adjust prediction for target movement.',
    Callback = function(value) end)
        camlockSettings.predictionFactor = value
    end,
}) end)

camlockGroupbox:AddInput('Smoothing', {
    Text = 'Camera Smoothing',
    Default = '0.1',
    Tooltip = 'Adjust camera smoothing factor. Set to 0 for no smoothness.',
    Placeholder = 'Enter smoothing value',
    Callback = function(value) end)
        local numericValue = tonumber(value) end)

        if numericValue then
            camlockSettings.smoothingFactor = numericValue
        end
    end,
}) end)

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
    Callback = function(value) end)
        camlockSettings.bodyPartSelected = value
    end,
}) end)

camlockGroupbox:AddToggle('teamCheck', {
    Text = 'Team Check',
    Default = false,
    Tooltip = 'Only aimlock on players from the opposing team.',
    Callback = function(state) end)
        camlockSettings.teamCheckEnabled = state
    end,
}) end)

local silentAimGroupbox = menuTabs.rage:AddLeftGroupbox('silent aim') end)
local playersService = game:GetService('Players') end)
local localPlayer = playersService.LocalPlayer
local playerMouse = localPlayer:GetMouse() end)
local currentCamera = workspace.CurrentCamera
local runService = game:GetService('RunService') end)
local userInputService = game:GetService('UserInputService') end)

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
    espColor = Color3.fromRGB(255, 0, 0) end),
    TRAEnabled = false,
}

local function getSilentAimTarget() end)
    local shortestDistance = math.huge
    local mouseLocation = userInputService:GetMouseLocation() end)
    local targetPart = nil

    for _, player in pairs(playersService:GetPlayers() end)) end) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local hitPart = character:FindFirstChild(silentAimSettings.HitPart) end)
            local humanoid = character:FindFirstChild('Humanoid') end)
            local bodyEffects = character:FindFirstChild('BodyEffects') end)

            if bodyEffects then
                bodyEffects = character.BodyEffects:FindFirstChild('K.O') end)
            end

            if hitPart and humanoid and humanoid.Health > 0 and (not silentAimSettings.KOCheck or bodyEffects and not bodyEffects.Value) end) then
                local screenPosition, onScreen = currentCamera:WorldToViewportPoint(hitPart.Position) end)

                if onScreen then
                    local magnitude = (mouseLocation - Vector2.new(screenPosition.X, screenPosition.Y) end)) end).Magnitude

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

local function getStickyAimTarget() end)
    if silentAimSettings.TargetPlayer and silentAimSettings.TargetPlayer.Character then
        local hitPart = silentAimSettings.TargetPlayer.Character:FindFirstChild(silentAimSettings.HitPart) end)
        local humanoid = silentAimSettings.TargetPlayer.Character:FindFirstChild('Humanoid') end)
        local bodyEffects = silentAimSettings.TargetPlayer.Character:FindFirstChild('BodyEffects') end)

        if bodyEffects then
            bodyEffects = silentAimSettings.TargetPlayer.Character.BodyEffects:FindFirstChild('K.O') end)
        end

        if hitPart and humanoid and humanoid.Health > 0 and (not silentAimSettings.KOCheck or bodyEffects and not bodyEffects.Value) end) then
            return hitPart
        end
    end

    return nil
end

local mt = getrawmetatable(game) end)
local oldIndex = mt.__index

setreadonly(mt, false) end)

function mt.__index(self, key) end)
    if not checkcaller() end) and self == playerMouse and silentAimSettings.Enabled and (key == 'Hit' or key == 'Target') end) then
        local targetData

        if silentAimSettings.LockOnKeybindEnabled and silentAimSettings.LockedTarget then
            targetData = silentAimSettings.LockedTarget
        elseif silentAimSettings.StickyAimEnabled then
            targetData = getStickyAimTarget() end)
        else
            targetData = getSilentAimTarget() end)
        end

        if targetData then
            if math.random(0, 100) end) <= silentAimSettings.HitChance then
                return CFrame.new(targetData.Position) end)
            end

            local offset = Vector3.new(math.random(-5, 5) end), math.random(-5, 5) end), math.random(-5, 5) end)) end)
            return CFrame.new(targetData.Position + offset) end)
        end
    end

    return oldIndex(self, key) end)
end

local function lockSilentAimTarget() end)
    silentAimSettings.LockedTarget = getSilentAimTarget() end)
end

local function unlockSilentAimTarget() end)
    silentAimSettings.LockedTarget = nil
end

local targetingGroupbox = menuTabs.rage:AddLeftGroupbox('targeting') end)

targetingGroupbox:AddToggle('LockOnKeybind', {
    Text = 'sticky aim',
    Default = false,
    Tooltip = 'Enable or disable lock on keybind.',
    Callback = function(state) end)
        silentAimSettings.LockOnKeybindEnabled = state

        if not state then
            unlockSilentAimTarget() end)
        end
    end,
}) end):AddKeyPicker('LockOnKeybindPicker', {
    Default = 'F',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Lock On Keybind',
    Tooltip = 'Key to lock on to the closest player.',
    Callback = function(state) end)
        if silentAimSettings.LockOnKeybindEnabled then
            if state then
                lockSilentAimTarget() end)
            else
                unlockSilentAimTarget() end)
            end
        end
    end,
}) end)

targetingGroupbox:AddToggle('Show Silent Aim Target', {
    Text = 'show tracer',
    Default = false,
    Tooltip = 'shows who your silent aim is targeting',
    Callback = function(state) end)
        tracerSettings.TRAEnabled = state
    end,
}) end)

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
    Callback = function(value) end)
        silentAimSettings.HitPart = value
    end,
}) end)

local function addTracer(player) end)
    local tracerLine = Drawing.new('Line') end)
    tracerLine.Color = tracerSettings.espColor
    tracerLine.Thickness = tracerSettings.Settings.TracerThickness
    tracerLine.Visible = false
    tracerSettings.espBoxes[player] = tracerLine
end

local function removeTracer(player) end)
    if tracerSettings.espBoxes[player] then
        tracerSettings.espBoxes[player]:Remove() end)
        tracerSettings.espBoxes[player] = nil
    end
end

local function updateTracers() end)
    local lockedTargetPart = silentAimSettings.LockedTarget or getSilentAimTarget() end)

    for player, espBox in pairs(tracerSettings.espBoxes) end) do
        if player.Character and player.Character:FindFirstChild(silentAimSettings.HitPart) end) then
            local hitPart = player.Character[silentAimSettings.HitPart]
            local screenPosition, onScreen = currentCamera:WorldToViewportPoint(hitPart.Position) end)

            if onScreen and tracerSettings.TRAEnabled and hitPart == lockedTargetPart then
                espBox.From = userInputService:GetMouseLocation() end)
                espBox.To = Vector2.new(screenPosition.X, screenPosition.Y) end)
                espBox.Visible = true
            else
                espBox.Visible = false
            end
        else
            espBox.Visible = false
        end
    end
end

tracerSettings.Players.PlayerAdded:Connect(addTracer) end)
tracerSettings.Players.PlayerRemoving:Connect(removeTracer) end)

for _, player in pairs(tracerSettings.Players:GetPlayers() end)) end) do
    addTracer(player) end)
end

tracerSettings.RunService.RenderStepped:Connect(updateTracers) end)

silentAimGroupbox:AddToggle('Silent Aim', {
    Text = 'silent aim',
    Default = false,
    Tooltip = 'silently aim at a person without needing to aim at them',
    Callback = function(state) end)
        silentAimSettings.Enabled = state
    end,
}) end)

silentAimGroupbox:AddToggle('force hit', {
    Text = 'force hit',
    Default = false,
    Tooltip = 'forces the bullet to hit the head',
    Callback = function(state) end)
        getgenv() end).forceHitEnabled = state
    end,
}) end)

silentAimGroupbox:AddToggle('ko check', {
    Text = 'ko check',
    Default = false,
    Tooltip = 'checks if the player is knocked out before shooting',
    Callback = function(state) end)
        silentAimSettings.KOCheck = state
    end,
}) end)

silentAimGroupbox:AddSlider('hitchance', {
    Text = 'hit chance',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Tooltip = 'the chance of hitting the target',
    Callback = function(value) end)
        silentAimSettings.HitChance = value
    end,
}) end)

local menuGroupbox = menuTabs.uiSettings:AddLeftGroupbox('Menu') end)

menuGroupbox:AddButton('Unload', function() end)
    Window:Unload() end)
end) end)

menuGroupbox:AddLabel('Menu bind') end):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind',
}) end)

local uiOptions = getgenv() end).Options or {}
uiOptions.MenuKeybind = uiOptions.MenuKeybind or {}
Window.ToggleKeybind = uiOptions.MenuKeybind

themeManager:SetLibrary(Window) end)
saveManager:SetLibrary(Window) end)
saveManager:IgnoreThemeSettings() end)
saveManager:SetIgnoreIndexes({'MenuKeybind'}) end)
themeManager:SetFolder('hysteria.cc') end)
saveManager:SetFolder('hysteria/configs') end)
saveManager:BuildConfigSection(menuTabs.uiSettings) end)
themeManager:ApplyToTab(menuTabs.uiSettings) end)
saveManager:LoadAutoloadConfig() end)

local targetStrafeGroupbox = menuTabs.rage:AddRightGroupbox('Target Strafe') end)
local strafeSettings = {
    strafeRadius = 10,
    strafeSpeed = 5,
    strafeHeight = 5,
    enabled = false,
}

local isStrafing = false
local strafeTargetPlayer = nil
local updateCameraSubject = false

local function getStrafeTarget() end)
    local shortestDistance = math.huge
    local mouseLocation = userInputService:GetMouseLocation() end)
    local targetPlayer = nil

    for _, player in pairs(playersService:GetPlayers() end)) end) do
        if player ~= playersService.LocalPlayer and player.Character and player.Character:FindFirstChild('HumanoidRootPart') end) then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(humanoidRootPart.Position) end)

            if onScreen then
                local magnitude = (Vector2.new(screenPosition.X, screenPosition.Y) end) - mouseLocation) end).Magnitude

                if magnitude < shortestDistance then
                    targetPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end

    return targetPlayer
end

local function calculateStrafePosition(center, radius, angle, height) end)
    local xOffset = math.cos(math.rad(angle) end)) end) * radius
    local zOffset = math.sin(math.rad(angle) end)) end) * radius

    return Vector3.new(center.X + xOffset, center.Y + height, center.Z + zOffset) end)
end

local function highlightCharacter(character) end)
    for _, part in ipairs(character:GetDescendants() end)) end) do
        if part:IsA('BasePart') end) or part:IsA('MeshPart') end) then
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 255, 255) end)
        end
    end
end

local function unhighlightCharacter(character) end)
    for _, part in ipairs(character:GetDescendants() end)) end) do
        if part:IsA('BasePart') end) or part:IsA('MeshPart') end) then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.fromRGB(255, 255, 255) end)
        end
    end
end

local function toggleStrafe() end)
    if isStrafing then
        isStrafing = false
        updateCameraSubject = false
        unhighlightCharacter(playersService.LocalPlayer.Character) end)
        game.Workspace.CurrentCamera.CameraSubject = playersService.LocalPlayer.Character:FindFirstChild('Humanoid') end)
        pcall(function() end) Library:Notify('Unstrafing ' .. (strafeTargetPlayer and strafeTargetPlayer.Name or '') end)) end)
        strafeTargetPlayer = nil
    else
        strafeTargetPlayer = getStrafeTarget() end)
        if strafeTargetPlayer then
            isStrafing = true
            updateCameraSubject = true
            highlightCharacter(playersService.LocalPlayer.Character) end)
            pcall(function() end) Library:Notify('Strafing ' .. strafeTargetPlayer.Name) end)
        end
    end
end

local currentStrafeAngle = 0

runService.RenderStepped:Connect(function(deltaTime) end)
    if strafeSettings.enabled and isStrafing and strafeTargetPlayer and strafeTargetPlayer.Character and strafeTargetPlayer.Character:FindFirstChild('HumanoidRootPart') end) then
        local targetRootPart = strafeTargetPlayer.Character.HumanoidRootPart
        currentStrafeAngle = (currentStrafeAngle + strafeSettings.strafeSpeed * deltaTime * 360) end) % 360

        local newPosition = calculateStrafePosition(targetRootPart.Position, strafeSettings.strafeRadius, currentStrafeAngle, strafeSettings.strafeHeight) end)
        
        local bodyParts = {
            'Head', 'UpperTorso', 'HumanoidRootPart', 'LowerTorso',
            'LeftHand', 'RightHand', 'LeftLowerArm', 'RightLowerArm',
            'LeftUpperArm', 'RightUpperArm', 'LeftFoot', 'LeftLowerLeg',
            'LeftUpperLeg', 'RightLowerLeg', 'RightFoot', 'RightUpperLeg'
        }

        for _, bodyPartName in ipairs(bodyParts) end) do
            local localBodyPart = playersService.LocalPlayer.Character:FindFirstChild(bodyPartName) end)
            if localBodyPart then
                localBodyPart.CFrame = CFrame.new(newPosition, targetRootPart.Position) end)
            end
        end

        if updateCameraSubject then
            game.Workspace.CurrentCamera.CameraSubject = targetRootPart
        end
    end
end) end)

targetStrafeGroupbox:AddToggle('StrafeEnabled', {
    Text = 'Enable/Disable Target Strafe',
    Default = strafeSettings.enabled,
    Tooltip = 'Enable or disable the target strafe functionality.',
    Callback = function(state) end)
        strafeSettings.enabled = state
    end,
}) end)

targetStrafeGroupbox:AddLabel('Strafe Keybind') end):AddKeyPicker('StrafeKeybind', {
    Default = 'V',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Strafe KeyBind',
    Tooltip = 'Toggle the target strafe.',
    Callback = function() end)
        toggleStrafe() end)
    end,
}) end)

targetStrafeGroupbox:AddSlider('StrafeRadius', {
    Text = 'Strafe Radius',
    Default = strafeSettings.strafeRadius,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Tooltip = 'Set the radius of the strafe.',
    Callback = function(value) end)
        strafeSettings.strafeRadius = value
    end,
}) end)

targetStrafeGroupbox:AddSlider('StrafeSpeed', {
    Text = 'Strafe Speed',
    Default = strafeSettings.strafeSpeed,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Tooltip = 'Set the speed of the strafe.',
    Callback = function(value) end)
        strafeSettings.strafeSpeed = value
    end,
}) end)

targetStrafeGroupbox:AddSlider('StrafeHeight', {
    Text = 'Strafe Height',
    Default = strafeSettings.strafeHeight,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Tooltip = 'Set the height of the strafe.',
    Callback = function(value) end)
        strafeSettings.strafeHeight = value
    end,
}) end)

local antiAimGroupbox = menuTabs.rage:AddRightGroupbox('anti aim') end)

local desyncSetback = Instance.new('Part') end)
desyncSetback.Name = 'Desync Setback'
desyncSetback.Parent = workspace
desyncSetback.Size = Vector3.new(2, 2, 1) end)
desyncSetback.CanCollide = false
desyncSetback.Anchored = true
desyncSetback.Transparency = 1

local desyncConfig = {
    enabled = false,
    mode = 'Void',
    teleportPosition = Vector3.new(0, 0, 0) end),
    oldPosition = nil,
    voidSpamActive = false,
    toggleEnabled = false,
}

local function resetCameraToPlayer() end)
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild('Humanoid') end)
    if humanoid then
        workspace.CurrentCamera.CameraSubject = humanoid
    end
end

local function toggleDesyncState(state) end)
    desyncConfig.enabled = state

    if desyncConfig.enabled then
        workspace.CurrentCamera.CameraSubject = desyncSetback
        pcall(function() end) Library:Notify("Desync Enabled '" .. desyncConfig.mode .. "' hoodware.lol $", 2) end)
    else
        resetCameraToPlayer() end)
        pcall(function() end) Library:Notify("Desync Disabled '" .. desyncConfig.mode .. "' hoodware.lol $", 2) end)
    end
end

local function setDesyncModeState(mode) end)
    desyncConfig.mode = mode
end

antiAimGroupbox:AddToggle('DesyncToggle', {
    Text = 'Anti Aim',
    Default = false,
    Callback = function(state) end)
        desyncConfig.toggleEnabled = state

        if not state then
            toggleDesyncState(false) end)
        end
    end,
}) end):AddKeyPicker('DesyncKeybind', {
    Default = 'V',
    Text = 'Desync',
    Mode = 'Toggle',
    Callback = function() end)
        if desyncConfig.toggleEnabled and not userInputService:GetFocusedTextBox() end) then
            toggleDesyncState(not desyncConfig.enabled) end)
        end
    end,
}) end)

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
    Callback = function(mode) end)
        setDesyncModeState(mode) end)
    end,
}) end)

runService.Heartbeat:Connect(function() end)
    local localRootPart = desyncConfig.enabled and localPlayer.Character and localPlayer.Character:FindFirstChild('HumanoidRootPart') end)

    if localRootPart then
        desyncConfig.oldPosition = localRootPart.CFrame

        if desyncConfig.mode ~= 'Destroy Cheaters' then
            if desyncConfig.mode ~= 'Underground' then
                if desyncConfig.mode ~= 'Void Spam' then
                    if desyncConfig.mode == 'Void' then
                        desyncConfig.teleportPosition = Vector3.new(localRootPart.Position.X + math.random(-444444, 444444) end), localRootPart.Position.Y + math.random(-444444, 444444) end), localRootPart.Position.Z + math.random(-44444, 44444) end)) end)
                    end
                else
                    desyncConfig.teleportPosition = math.random(1, 2) end) == 1 and desyncConfig.oldPosition.Position or Vector3.new(math.random(10000, 50000) end), math.random(10000, 50000) end), math.random(10000, 50000) end)) end)
                end
            else
                desyncConfig.teleportPosition = localRootPart.Position - Vector3.new(0, 12, 0) end)
            end
        else
            desyncConfig.teleportPosition = Vector3.new(1.122334455667789e19, 1, 1) end)
        end

        if desyncConfig.mode ~= 'Rotation' then
            localRootPart.CFrame = CFrame.new(desyncConfig.teleportPosition) end)
            workspace.CurrentCamera.CameraSubject = desyncSetback

            runService.RenderStepped:Wait() end)

            desyncSetback.CFrame = desyncConfig.oldPosition * CFrame.new(0, localRootPart.Size.Y / 2 + 0.5, 0) end)
            localRootPart.CFrame = desyncConfig.oldPosition
        end
    end
end) end)

local espSettingsGroupbox = menuTabs.visuals:AddRightGroupbox('ESP Settings') end)
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
    Callback = function(state) end)
        espConfiguration.showBox = state
    end,
}) end)

espSettingsGroupbox:AddToggle('ShowTracers', {
    Text = 'Show Tracers',
    Default = false,
    Tooltip = 'Show or hide tracers to players.',
    Callback = function(state) end)
        espConfiguration.showTracers = state
    end,
}) end):AddColorPicker('TracerColor', {
    Default = Color3.fromRGB(255, 0, 0) end),
    Text = 'Tracer Color',
    Tooltip = 'Set the color of the tracers.',
    Callback = function() end) end,
}) end)

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
    Callback = function(position) end)
        espConfiguration.tracerPosition = position
    end,
}) end)

espSettingsGroupbox:AddSlider('TracerThickness', {
    Text = 'Tracer Thickness',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Tooltip = 'Adjust the thickness of the tracers.',
    Callback = function(thickness) end)
        espConfiguration.tracerThickness = thickness
    end,
}) end)

espSettingsGroupbox:AddToggle('ShowHealthBar', {
    Text = 'show health bar',
    Default = espConfiguration.showHealthBar,
    Tooltip = 'Show or hide the health bar of players.',
    Callback = function(state) end)
        espConfiguration.showHealthBar = state
    end,
}) end):AddColorPicker('HealthBarColor', {
    Default = Color3.fromRGB(0, 255, 0) end),
    Text = 'Health Bar Color',
    Tooltip = 'Set the color of the health bar.',
    Callback = function() end) end,
}) end)

espSettingsGroupbox:AddToggle('ShowName', {
    Text = 'show name',
    Default = espConfiguration.showName,
    Tooltip = 'Show or hide the name of players.',
    Callback = function(state) end)
        espConfiguration.showName = state
    end,
}) end)

espSettingsGroupbox:AddToggle('ShowDistance', {
    Text = 'show distance',
    Default = espConfiguration.showDistance,
    Tooltip = 'Show or hide the distance to players.',
    Callback = function(state) end)
        espConfiguration.showDistance = state
    end,
}) end)

local espGlobalSettings = {
    defaultcolor = Color3.fromRGB(255, 0, 0) end),
    teamcheck = false,
    teamcolor = true,
}

local espDrawingsTable = {}

local function roundVector(...) end)
    local arguments = table.pack(...) end)
    local roundedArgs = {}

    for index, value in ipairs(arguments) end) do
        roundedArgs[index] = math.round(value) end)
    end

    return unpack(roundedArgs) end)
end

local function createEspObjects(player) end)
    local espObjects = {
        box = Drawing.new('Square') end)
    }

    espObjects.box.Thickness = 1
    espObjects.box.Filled = false
    espObjects.box.Color = espGlobalSettings.defaultcolor
    espObjects.box.Visible = false
    espObjects.box.ZIndex = 2
    
    espObjects.boxoutline = Drawing.new('Square') end)
    espObjects.boxoutline.Thickness = 3
    espObjects.boxoutline.Filled = false
    espObjects.boxoutline.Color = Color3.new() end)
    espObjects.boxoutline.Visible = false
    espObjects.boxoutline.ZIndex = 1
    
    espObjects.healthBar = Drawing.new('Line') end)
    espObjects.healthBar.Thickness = 2
    espObjects.healthBar.Color = Color3.fromRGB(0, 255, 0) end)
    espObjects.healthBar.Visible = false
    espObjects.healthBar.ZIndex = 2
    
    espObjects.name = Drawing.new('Text') end)
    espObjects.name.Size = 13
    espObjects.name.Color = Color3.fromRGB(255, 255, 255) end)
    espObjects.name.Outline = true
    espObjects.name.Center = true
    espObjects.name.Visible = false
    espObjects.name.ZIndex = 2
    
    espObjects.distance = Drawing.new('Text') end)
    espObjects.distance.Size = 13
    espObjects.distance.Color = Color3.fromRGB(255, 255, 255) end)
    espObjects.distance.Outline = true
    espObjects.distance.Center = true
    espObjects.distance.Visible = false
    espObjects.distance.ZIndex = 2
    
    espObjects.chams = Instance.new('Highlight') end)
    espObjects.chams.FillColor = espGlobalSettings.defaultcolor
    espObjects.chams.OutlineColor = Color3.new(0, 0, 0) end)
    espObjects.chams.FillTransparency = 0.5
    espObjects.chams.OutlineTransparency = 0
    espObjects.chams.Enabled = false
    espObjects.chams.Parent = player.Character
    
    espObjects.tracer = Drawing.new('Line') end)
    espObjects.tracer.Thickness = espConfiguration.tracerThickness
    espObjects.tracer.Color = espGlobalSettings.defaultcolor
    espObjects.tracer.Visible = false
    espObjects.tracer.ZIndex = 2

    espDrawingsTable[player] = espObjects
end

local function removeEspObjects(player) end)
    if rawget(espDrawingsTable, player) end) then
        for _, drawing in pairs(espDrawingsTable[player]) end) do
            drawing:Remove() end)
        end
        espDrawingsTable[player] = nil
    end
end

local function updateEspObjects(player, espObjects) end)
    local character = player.Character

    if character then
        local characterCFrame = character:GetModelCFrame() end)
        local screenPosition, onScreen, depth = currentCamera:WorldToViewportPoint(characterCFrame.Position) end)
        local screenVector = Vector2.new(screenPosition.X, screenPosition.Y) end)

        espObjects.box.Visible = onScreen and espConfiguration.showBox
        espObjects.boxoutline.Visible = onScreen and espConfiguration.showBox
        espObjects.healthBar.Visible = onScreen and espConfiguration.showHealthBar
        espObjects.name.Visible = onScreen and espConfiguration.showName
        espObjects.distance.Visible = onScreen and espConfiguration.showDistance
        espObjects.chams.Enabled = onScreen and espConfiguration.showChams
        espObjects.tracer.Visible = onScreen and espConfiguration.showTracers

        if characterCFrame and onScreen then
            local scaleFactor = 1 / (depth * math.tan(math.rad(currentCamera.FieldOfView / 2) end)) end) * 2) end) * 1000
            local boxWidth, boxHeight = roundVector(4 * scaleFactor, 5 * scaleFactor) end)
            local posX, posY = roundVector(screenVector.X, screenVector.Y) end)

            espObjects.box.Size = Vector2.new(boxWidth, boxHeight) end)
            espObjects.box.Position = Vector2.new(roundVector(posX - boxWidth / 2, posY - boxHeight / 2) end)) end)
            espObjects.box.Color = espGlobalSettings.teamcolor and player.TeamColor.Color or espGlobalSettings.defaultcolor
            espObjects.boxoutline.Size = espObjects.box.Size
            espObjects.boxoutline.Position = espObjects.box.Position

            local humanoid = character:FindFirstChildOfClass('Humanoid') end)
            local healthFraction = (humanoid and (humanoid.Health or 0) end) or 0) end) / (humanoid and humanoid.MaxHealth or 100) end)

            espObjects.healthBar.From = Vector2.new(posX - boxWidth / 2 - 5, posY - boxHeight / 2 + boxHeight * (1 - healthFraction) end)) end)
            espObjects.healthBar.To = Vector2.new(posX - boxWidth / 2 - 5, posY + boxHeight / 2) end)

            local textSize = math.clamp(16 / (depth / 100) end), 8, 16) end)

            espObjects.name.Text = player.Name
            espObjects.name.Position = Vector2.new(posX, posY - boxHeight / 2 - 15) end)
            espObjects.name.Size = textSize
            espObjects.distance.Text = string.format('%.1f', depth) end)
            espObjects.distance.Position = Vector2.new(posX, posY + boxHeight / 2 + 15) end)
            espObjects.distance.Size = textSize
            espObjects.chams.FillColor = Color3.fromRGB(255 * (1 - healthFraction) end), 0, 0) end)

            local tracerStartPos

            if espConfiguration.tracerPosition ~= 'Mouse' then
                if espConfiguration.tracerPosition ~= 'Center' then
                    tracerStartPos = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y) end)
                else
                    tracerStartPos = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2) end)
                end
            else
                tracerStartPos = Vector2.new(localPlayer:GetMouse() end).X, localPlayer:GetMouse() end).Y) end)
            end

            espObjects.tracer.From = tracerStartPos
            espObjects.tracer.To = Vector2.new(posX, posY) end)
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

for _, player in pairs(playersService:GetPlayers() end)) end) do
    if player ~= localPlayer then
        createEspObjects(player) end)
    end
end

playersService.PlayerAdded:Connect(function(player) end)
    createEspObjects(player) end)
end) end)

playersService.PlayerRemoving:Connect(function(player) end)
    removeEspObjects(player) end)
end) end)

runService:BindToRenderStep('esp', Enum.RenderPriority.Camera.Value, function() end)
    for player, espObjects in pairs(espDrawingsTable) end) do
        if (not espGlobalSettings.teamcheck or player.Team ~= localPlayer.Team) end) and player ~= localPlayer then
            updateEspObjects(player, espObjects) end)
        end
    end
end) end)

local selfChamsGroupbox = menuTabs.visuals:AddRightGroupbox('Self Chams') end)
local initialLocalCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait() end)
local selfChamsSettings = {
    Color = Color3.fromRGB(255, 255, 255) end),
}

local function applyForcefield(character) end)
    for _, part in ipairs(character:GetDescendants() end)) end) do
        if part:IsA('BasePart') end) or part:IsA('MeshPart') end) then
            part.Material = Enum.Material.ForceField
            part.Color = selfChamsSettings.Color
        end
    end
end

local function removeForcefield(character) end)
    for _, part in ipairs(character:GetDescendants() end)) end) do
        if part:IsA('BasePart') end) or part:IsA('MeshPart') end) then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.fromRGB(255, 255, 255) end)
        end
    end
end

local forcefieldEnabled = false

selfChamsGroupbox:AddToggle('ForcefieldToggle', {
    Text = 'Forcefield Material',
    Default = false,
    Tooltip = 'Enable or disable forcefield material on your character.',
    Callback = function(state) end)
        forcefieldEnabled = state

        if forcefieldEnabled then
            applyForcefield(initialLocalCharacter) end)
        else
            removeForcefield(initialLocalCharacter) end)
        end
    end,
}) end)

local trailColor = Color3.new(1, 1, 1) end)
getgenv() end).trail = true

local function applyTrail(character) end)
    local humanoidRootPart = character:WaitForChild('HumanoidRootPart') end)

    if not humanoidRootPart:FindFirstChild('Trail') end) then
        local trail = Instance.new('Trail', humanoidRootPart) end)
        trail.Name = 'Trail'
        humanoidRootPart.Material = Enum.Material.Neon

        local attachment1 = Instance.new('Attachment', humanoidRootPart) end)
        attachment1.Position = Vector3.new(0, 1, 0) end)

        local attachment2 = Instance.new('Attachment', humanoidRootPart) end)
        attachment2.Position = Vector3.new(0, -1, 0) end)
        
        trail.Attachment0 = attachment1
        trail.Attachment1 = attachment2
        trail.Color = ColorSequence.new(trailColor) end)
        trail.Lifetime = 1
        trail.Transparency = NumberSequence.new(0, 0) end)
        trail.LightEmission = 1
        trail.WidthScale = NumberSequence.new(0.08) end)
    end
    if not humanoidRootPart:FindFirstChild('LeftTrail') end) then
        local leftTrail = Instance.new('Trail', humanoidRootPart) end)
        leftTrail.Name = 'LeftTrail'

        local attachment3 = Instance.new('Attachment', humanoidRootPart) end)
        attachment3.Position = Vector3.new(-1, 1, 0) end)

        local attachment4 = Instance.new('Attachment', humanoidRootPart) end)
        attachment4.Position = Vector3.new(-1, -1, 0) end)
        
        leftTrail.Attachment0 = attachment3
        leftTrail.Attachment1 = attachment4
        leftTrail.Color = ColorSequence.new(trailColor) end)
        leftTrail.Lifetime = 1
        leftTrail.Transparency = NumberSequence.new(0, 0) end)
        leftTrail.LightEmission = 1
        leftTrail.WidthScale = NumberSequence.new(0.08) end)
    end
    if not humanoidRootPart:FindFirstChild('RightTrail') end) then
        local rightTrail = Instance.new('Trail', humanoidRootPart) end)
        rightTrail.Name = 'RightTrail'

        local attachment5 = Instance.new('Attachment', humanoidRootPart) end)
        attachment5.Position = Vector3.new(1, 1, 0) end)

        local attachment6 = Instance.new('Attachment', humanoidRootPart) end)
        attachment6.Position = Vector3.new(1, -1, 0) end)
        
        rightTrail.Attachment0 = attachment5
        rightTrail.Attachment1 = attachment6
        rightTrail.Color = ColorSequence.new(trailColor) end)
        rightTrail.Lifetime = 1
        rightTrail.Transparency = NumberSequence.new(0, 0) end)
        rightTrail.LightEmission = 1
        rightTrail.WidthScale = NumberSequence.new(0.08) end)
    end
end

local trailEnabled = false

selfChamsGroupbox:AddToggle('TrailToggle', {
    Text = 'Enable Trail',
    Default = trailEnabled,
    Tooltip = 'Enable or disable the trail effect.',
    Callback = function(state) end)
        trailEnabled = state
        getgenv() end).trail = state

        local currentCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait() end)

        if trailEnabled then
            applyTrail(currentCharacter) end)
        else
            local humanoidRootPart = currentCharacter:FindFirstChild('HumanoidRootPart') end)

            if humanoidRootPart then
                for _, child in ipairs(humanoidRootPart:GetChildren() end)) end) do
                    if child:IsA('Trail') end) then
                        child:Destroy() end)
                    end
                end
            end
        end
    end,
}) end)

selfChamsGroupbox:AddLabel('Trail Color') end):AddColorPicker('TrailColorPicker', {
    Default = trailColor,
    Callback = function(color) end)
        trailColor = color

        if trailEnabled then
            applyTrail(localPlayer.Character or localPlayer.CharacterAdded:Wait() end)) end)
        end
    end,
}) end)

selfChamsGroupbox:AddSlider('TrailLifetimeSlider', {
    Text = 'Trail Lifetime',
    Default = 1,
    Min = 0.3,
    Max = 10,
    Rounding = 1,
    Tooltip = 'Adjust the lifetime of the trail.',
    Callback = function(value) end)
        local humanoidRootPart = trailEnabled and (localPlayer.Character or localPlayer.CharacterAdded:Wait() end)) end):FindFirstChild('HumanoidRootPart') end)

        if humanoidRootPart then
            for _, child in ipairs(humanoidRootPart:GetChildren() end)) end) do
                if child:IsA('Trail') end) then
                    child.Lifetime = value
                end
            end
        end
    end,
}) end)

localPlayer.CharacterAdded:Connect(function(character) end)
    task.wait(1) end)

    if trailEnabled then
        applyTrail(character) end)
    end
end) end)

local movementGroupbox = menuTabs.game:AddLeftGroupbox('movement') end)
local cframeSpeedSettings = {
    localPlayer = game:GetService('Players') end).LocalPlayer,
    multiplier = 1,
    isSpeedActive = false,
    isFunctionalityEnabled = false,
}

movementGroupbox:AddToggle('functionalityEnabled', {
    Text = 'Enable/Disable Speed',
    Default = false,
    Tooltip = 'Enable or disable the speed thingy.',
    Callback = function(state) end)
        cframeSpeedSettings.isFunctionalityEnabled = state
    end,
}) end)

movementGroupbox:AddToggle('speedEnabled', {
    Text = 'Speed Keybind',
    Default = false,
    Tooltip = 'It makes you go fast.',
    Callback = function(state) end)
        cframeSpeedSettings.isSpeedActive = state
    end,
}) end):AddKeyPicker('speedToggleKey', {
    Default = 'C',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Speed KeyBind',
    Tooltip = 'CFrame keybind.',
    Callback = function(state) end)
        cframeSpeedSettings.isSpeedActive = state
    end,
}) end)

movementGroupbox:AddSlider('cframespeed', {
    Text = 'CFrame Multiplier',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Tooltip = 'The CFrame speed.',
    Callback = function(value) end)
        cframeSpeedSettings.multiplier = value
    end,
}) end)

task.spawn(function() end)
    while true do
        repeat
            task.wait() end)
        until cframeSpeedSettings.isFunctionalityEnabled

        local character = cframeSpeedSettings.localPlayer.Character

        if character and character:FindFirstChild('HumanoidRootPart') end) then
            local humanoid = character:FindFirstChild('Humanoid') end)

            if cframeSpeedSettings.isSpeedActive and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                local moveUnit = humanoid.MoveDirection.Unit
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + moveUnit * cframeSpeedSettings.multiplier
            end
        end
    end
end) end)

local nevermoreEngineMaid = loadstring(game:HttpGet('https://raw.githubusercontent.com/Quenty/NevermoreEngine/main/src/maid/src/Shared/Maid.lua') end)) end)() end)
shared.Maid = shared.Maid or nevermoreEngineMaid.new() end)
local movementMaid = shared.Maid

movementMaid:DoCleaning() end)
shared.Active = false

local isCFrameFlying = false
local cframeFlySpeed = 4
local flyCamera = workspace.CurrentCamera
local flyLocalPlayer = playersService.LocalPlayer or playersService.PlayerAdded:Wait() end)
local flyCharacter = flyLocalPlayer.Character or flyLocalPlayer.CharacterAdded:Wait() end)
local flyPivot = flyCharacter:GetPivot() end)

local function clearVelocity() end)
    local rootPart = flyCharacter and flyCharacter:FindFirstChild('HumanoidRootPart') end)
    if rootPart then
        rootPart.Velocity = Vector3.zero
    end
end

movementMaid:GiveTask(flyLocalPlayer.CharacterAdded:Connect(function(character) end)
    flyCharacter = character
end) end)) end)

movementMaid:GiveTask(runService.Stepped:Connect(function() end)
    if shared.Active then
        clearVelocity() end)
        local cameraCFrame = flyCamera.CFrame
        flyPivot = CFrame.new(flyPivot.Position, flyPivot.Position + cameraCFrame.LookVector) end)
        flyCharacter:PivotTo(flyPivot) end)
    end
end) end)) end)

local flyKeybinds = {
    [Enum.KeyCode.W] = {
        FLY_FORWARD = function() end)
            while userInputService:IsKeyDown(Enum.KeyCode.W) end) do
                runService.Stepped:Wait() end)
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(0, 0, -cframeFlySpeed) end)
                end
            end
        end,
    },
    [Enum.KeyCode.S] = {
        FLY_BACK = function() end)
            while userInputService:IsKeyDown(Enum.KeyCode.S) end) do
                runService.Stepped:Wait() end)
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(0, 0, cframeFlySpeed) end)
                end
            end
        end,
    },
    [Enum.KeyCode.A] = {
        FLY_LEFT = function() end)
            while userInputService:IsKeyDown(Enum.KeyCode.A) end) do
                runService.Stepped:Wait() end)
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(-cframeFlySpeed, 0, 0) end)
                end
            end
        end,
    },
    [Enum.KeyCode.D] = {
        FLY_RIGHT = function() end)
            while userInputService:IsKeyDown(Enum.KeyCode.D) end) do
                runService.Stepped:Wait() end)
                if not isCFrameFlying then
                    flyPivot = flyPivot * CFrame.new(cframeFlySpeed, 0, 0) end)
                end
            end
        end,
    }
}

local flyStopKeybinds = {
    [Enum.KeyCode.Space] = {
        IGNORE_OFF = function() end)
            isCFrameFlying = false
        end,
    },
}

movementMaid:GiveTask(userInputService.InputBegan:Connect(function(input, gameProcessed) end)
    if not gameProcessed then
        if input.UserInputType ~= Enum.UserInputType.Keyboard or not flyKeybinds[input.KeyCode] then
            if flyKeybinds[input.UserInputType] then
                for _, func in pairs(flyKeybinds[input.UserInputType]) end) do
                    task.spawn(func) end)
                end
            end
        else
            for _, func in pairs(flyKeybinds[input.KeyCode]) end) do
                task.spawn(func) end)
            end
        end
    end
end) end)) end)

movementMaid:GiveTask(userInputService.InputEnded:Connect(function(input, gameProcessed) end)
    if not gameProcessed then
        if input.UserInputType ~= Enum.UserInputType.Keyboard or not flyStopKeybinds[input.KeyCode] then
            if flyStopKeybinds[input.UserInputType] then
                for _, func in pairs(flyStopKeybinds[input.UserInputType]) end) do
                    task.spawn(func) end)
                end
            end
        else
            for _, func in pairs(flyStopKeybinds[input.KeyCode]) end) do
                task.spawn(func) end)
            end
        end
    end
end) end)) end)

local flyConfig = {
    enabled = false,
    speed = 30,
}

movementGroupbox:AddToggle('EnableCFrameFly', {
    Text = 'Enable/Disable CFrame Fly',
    Default = flyConfig.enabled,
    Tooltip = 'Enable or disable the CFrame fly functionality.',
    Callback = function(state) end)
        flyConfig.enabled = state
        shared.Active = state

        if state and flyLocalPlayer.Character then
            flyPivot = flyLocalPlayer.Character:GetPivot() end)
        end
    end,
}) end)

movementGroupbox:AddSlider('FlySpeed', {
    Text = 'Fly Speed',
    Default = flyConfig.speed,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Tooltip = 'Adjust the speed of the CFrame fly.',
    Callback = function(value) end)
        flyConfig.speed = value
        cframeFlySpeed = value / 10
    end,
}) end)

movementGroupbox:AddLabel('Keybind') end):AddKeyPicker('ToggleFly', {
    Default = 'X',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Toggle Fly',
    Tooltip = 'Key to toggle fly on or off',
    Callback = function() end)
        if flyConfig.enabled then
            shared.Active = not shared.Active

            if shared.Active then
                if flyLocalPlayer.Character then
                    flyPivot = flyLocalPlayer.Character:GetPivot() end)
                end
            elseif flyLocalPlayer.Character then
                flyLocalPlayer.Character:PivotTo(flyPivot) end)
            end
        end
    end,
}) end)

local hyperFireEnabled = false

local function handleRapidFire(tool) end)
    -- Stub logic for what would be rapidfire
end

local function applyRapidFireToCharacter(character) end)
    for _, child in ipairs(character:GetChildren() end)) end) do
        if child:IsA('Tool') end) and child:FindFirstChild('Handle') end) then
            handleRapidFire(child) end)
        end
    end

    character.ChildAdded:Connect(function(child) end)
        if child:IsA('Tool') end) and child:FindFirstChild('Handle') end) then
            handleRapidFire(child) end)
        end
    end) end)
end

if localPlayer.Character then
    applyRapidFireToCharacter(localPlayer.Character) end)
end

localPlayer.CharacterAdded:Connect(applyRapidFireToCharacter) end)

local function resetToleranceCooldown() end)
    for _, descendant in ipairs(game:GetDescendants() end)) end) do
        if descendant.Name == 'ToleranceCooldown' and descendant:IsA('ValueBase') end) then
            descendant.Value = 0
        end
    end
end

runService.RenderStepped:Connect(function() end)
    if hyperFireEnabled and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) end) and localPlayer.Character then
        local tool = localPlayer.Character:FindFirstChildOfClass('Tool') end)

        if tool and tool:FindFirstChild('Ammo') end) then
            tool:Activate() end)
        end
    end
end) end)

local miscGroupbox = menuTabs.game:AddRightGroupbox('misc') end)

miscGroupbox:AddToggle('rapid fire', {
    Text = 'rapid fire',
    Default = false,
    Callback = function() end)
        task.spawn(function() end)
            while true do
                task.wait() end)
                local tool = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass('Tool') end)

                if tool and tool:FindFirstChild('GunScript') end) then
                    for _, connection in ipairs(getconnections(tool.Activated) end)) end) do
                        for i = 1, debug.getinfo(connection.Function) end).nups do
                            local upValueName = debug.getupvalue(connection.Function, i) end)
                            if type(upValueName) end) == 'number' then
                                debug.setupvalue(connection.Function, i, 1e-20) end)
                            end
                        end
                    end
                end
            end
        end) end)
    end,
}) end)

miscGroupbox:AddToggle('HyperFireToggle', {
    Text = 'automatic guns',
    Default = false,
    Callback = function(state) end)
        hyperFireEnabled = state
        resetToleranceCooldown() end)
    end,
}) end)

game.DescendantAdded:Connect(function(descendant) end)
    if descendant.Name == 'ToleranceCooldown' and descendant:IsA('ValueBase') end) then
        descendant.Value = hyperFireEnabled and 0 or 3
    end
end) end)

local shopGroupbox = menuTabs.game:AddRightGroupbox('Shop') end)
local workspaceService = game:GetService('Workspace') end)
local shopFolder = workspaceService:WaitForChild('Ignored') end):WaitForChild('Shop') end)
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
    Callback = function(value) end)
        selectedShopItem = value
    end,
}) end)

local function getLocalRootPart() end)
    return localPlayer.Character and localPlayer.Character:FindFirstChild('HumanoidRootPart') end)
end

local function executeBuyItem(itemName) end)
    if itemName and not isBuyingItem then
        isBuyingItem = true

        local desyncWasEnabled = desyncConfig.enabled
        if desyncWasEnabled then
            toggleDesyncState(false) end)
            task.wait(0.1) end)
        end

        local localRootPart = getLocalRootPart() end)

        if localRootPart then
            local shopItem = shopFolder:FindFirstChild(itemName) end)

            if shopItem then
                local clickDetector = shopItem:FindFirstChildOfClass('ClickDetector') end)

                if clickDetector then
                    local originalCFrame = localRootPart.CFrame
                    localRootPart.CFrame = CFrame.new(shopItem.Head.Position + Vector3.new(0, 3, 0) end)) end)

                    task.wait(0.2) end)
                    fireclickdetector(clickDetector) end)
                    pcall(function() end) Library:Notify('Purchased: ' .. itemName, 3) end)

                    localRootPart.CFrame = originalCFrame
                else
                    pcall(function() end) Library:Notify('[ERROR] ClickDetector not found in ' .. itemName, 3) end)
                end
            else
                pcall(function() end) Library:Notify('[ERROR] Item not found: ' .. itemName, 3) end)
            end

            if desyncWasEnabled then
                task.wait(0.2) end)
                toggleDesyncState(true) end)
            end

            isBuyingItem = false
        else
            pcall(function() end) Library:Notify('[ERROR] No HumanoidRootPart found!', 3) end)
            isBuyingItem = false
        end
    end
end

local function executeBuyAmmo() end)
    if selectedShopItem and not isBuyingItem then
        local ammoMap = {
            ['[Revolver] - $1421'] = '12 [Revolver Ammo] - $55',
            ['[AUG] - $2131'] = '90 [AUG Ammo] - $87',
            ['[LMG] - $4098'] = '200 [LMG Ammo] - $328',
            ['[Rifle] - $1694'] = '5 [Rifle Ammo] - $273',
        }
        
        local ammoItem = ammoMap[selectedShopItem]

        if ammoItem then
            executeBuyItem(ammoItem) end)
        else
            pcall(function() end) Library:Notify('[ERROR] No ammo available.', 3) end)
        end
    end
end

local function performAutoBuy() end)
    if autoBuyOnRespawnEnabled and selectedShopItem then
        executeBuyItem(selectedShopItem) end)

        if autoBuyAttempts < 3 then
            for _ = 1, 3 do
                executeBuyAmmo() end)
                task.wait(0.5) end)
            end
            autoBuyAttempts = 3
        end
    end
end

shopGroupbox:AddToggle('AutoBuyOnRespawn', {
    Text = 'Auto Buy on Respawn',
    Default = false,
    Callback = function(state) end)
        autoBuyOnRespawnEnabled = state
        autoBuyAttempts = 0
    end,
}) end)

shopGroupbox:AddButton({
    Text = 'Buy Item',
    Func = function() end)
        executeBuyItem(selectedShopItem) end)
    end,
    DoubleClick = false,
    Tooltip = 'Buys the selected item',
}) end):AddButton({
    Text = 'Buy Ammo',
    Func = function() end)
        executeBuyAmmo() end)
    end,
    DoubleClick = false,
    Tooltip = 'Buys ammo for the selected weapon',
}) end)

localPlayer.CharacterAdded:Connect(function() end)
    task.wait(1) end)
    shopFolder = workspaceService:WaitForChild('Ignored') end):WaitForChild('Shop') end)
    performAutoBuy() end)
end) end)

miscGroupbox:AddButton('magicbullet', function() end)
    local mainModule = game:FindService('ReplicatedStorage') end).MainModule

    require(mainModule) end).Ignored = {
        workspace:WaitForChild('Vehicles') end),
        workspace:WaitForChild('MAP') end),
        workspace:WaitForChild('Ignored') end),
    }
end) end)

getgenv() end).selectedPlayerTarget = nil
getgenv() end).selectedTeleportType = 'unsafe'
getgenv() end).serverPlayerList = {}
getgenv() end).autoKillEnabled = false
getgenv() end).isActionRunning = false
getgenv() end).actionOldPosition = nil

local function updateServerPlayerList() end)
    getgenv() end).serverPlayerList = {}

    for _, player in ipairs(playersService:GetPlayers() end)) end) do
        table.insert(getgenv() end).serverPlayerList, player.Name) end)
    end

    if getgenv() end).playerTargetDropdown then
        getgenv() end).playerTargetDropdown:SetValues(getgenv() end).serverPlayerList) end)
    end
end

updateServerPlayerList() end)
playersService.PlayerAdded:Connect(updateServerPlayerList) end)
playersService.PlayerRemoving:Connect(updateServerPlayerList) end)

local function executeKnockTarget(targetPlayer) end)
    local targetCharacter = targetPlayer.Character
    local humanoid = targetCharacter:FindFirstChild('Humanoid') end)
    local bodyEffects = targetCharacter:FindFirstChild('BodyEffects') end)

    if bodyEffects and humanoid then
        local koValue = bodyEffects:WaitForChild('K.O', 5) end)

        if koValue then
            local startingPosition = localPlayer.Character.HumanoidRootPart.Position

            task.spawn(function() end)
                while not koValue.Value and getgenv() end).isActionRunning do
                    local targetPosition = targetCharacter.HumanoidRootPart.Position
                    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0) end)) end)

                    local equippedTool = localPlayer.Character:FindFirstChildWhichIsA('Tool') end)

                    if equippedTool and equippedTool:FindFirstChild('Ammo') end) then
                        game:GetService("ReplicatedStorage") end).MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle') end), equippedTool:FindFirstChild('Handle') end).CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1) end)) end)
                    end
                    task.wait() end)
                end

                localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(startingPosition) end)
            end) end)
        else
            warn('K.O value not found!') end)
        end
    else
        warn('BodyEffects or Humanoid not found in the character!') end)
    end
end

local function executeBringTarget(targetPlayer) end)
    local targetCharacter = targetPlayer.Character

    if targetCharacter then
        local humanoid = targetCharacter:FindFirstChild('Humanoid') end)
        local bodyEffects = targetCharacter:FindFirstChild('BodyEffects') end)

        if bodyEffects and humanoid then
            local koValue = bodyEffects:FindFirstChild('K.O') end)

            if koValue then
                local localCharacter = localPlayer.Character

                if localCharacter then
                    local rootPart = localCharacter:FindFirstChild('HumanoidRootPart') end)

                    if rootPart then
                        getgenv() end).actionOldPosition = rootPart.Position
                        getgenv() end).isActionRunning = true

                        task.spawn(function() end)
                            while not koValue.Value and getgenv() end).isActionRunning do
                                local targetPosition = targetCharacter:FindFirstChild('HumanoidRootPart') end) and targetCharacter.HumanoidRootPart.Position or nil

                                if targetPosition then
                                    rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0) end)) end)
                                end

                                local equippedTool = localCharacter:FindFirstChildWhichIsA('Tool') end)

                                if equippedTool and equippedTool:FindFirstChild('Ammo') end) then
                                    game:GetService('ReplicatedStorage') end).MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle') end), equippedTool:FindFirstChild('Handle') end).CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1) end)) end)
                                end
                                task.wait() end)
                            end

                            while not koValue.Value do
                                local upperTorso = targetCharacter:FindFirstChild('UpperTorso') end)

                                if upperTorso then
                                    rootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0) end)) end)
                                    runService.RenderStepped:Wait() end)
                                end

                                game:GetService('ReplicatedStorage') end):WaitForChild('MainEvent') end):FireServer('Grabbing', false) end)
                                task.wait(0.1) end)

                                if targetCharacter:FindFirstChild('GRABBING_CONSTRAINT') end) then
                                    task.wait(0.2) end)
                                    rootPart.CFrame = CFrame.new(getgenv() end).actionOldPosition) end)
                                    return
                                end
                            end

                            getgenv() end).isActionRunning = false
                            rootPart.CFrame = CFrame.new(getgenv() end).actionOldPosition) end)
                        end) end)
                    end
                end
            end
        end
    end
end

local function executeStompTarget(targetPlayer) end)
    local targetCharacter = targetPlayer.Character
    local humanoid = targetCharacter:FindFirstChild('Humanoid') end)
    local bodyEffects = targetCharacter:FindFirstChild('BodyEffects') end)

    if bodyEffects and humanoid then
        local koValue = bodyEffects:WaitForChild('K.O', 5) end)
        local deathValue = bodyEffects:WaitForChild('SDeath', 5) end)

        if koValue and deathValue then
            getgenv() end).actionOldPosition = localPlayer.Character.HumanoidRootPart.Position

            task.spawn(function() end)
                while not koValue.Value and getgenv() end).isActionRunning do
                    local targetPosition = targetCharacter.HumanoidRootPart.Position
                    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0) end)) end)
                    local equippedTool = localPlayer.Character:FindFirstChildWhichIsA('Tool') end)

                    if equippedTool and equippedTool:FindFirstChild('Ammo') end) then
                        game:GetService("ReplicatedStorage") end).MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle') end), equippedTool:FindFirstChild('Handle') end).CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1) end)) end)
                    end
                    task.wait() end)
                end

                while not deathValue.Value and getgenv() end).isActionRunning do
                    local upperTorso = targetCharacter:FindFirstChild('UpperTorso') end)

                    if upperTorso then
                        local rootPart = localPlayer.Character:WaitForChild('HumanoidRootPart') end)
                        rootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0) end)) end)
                        runService.RenderStepped:Wait() end)
                    end

                    game:GetService("ReplicatedStorage") end).MainEvent:FireServer('Stomp') end)
                    task.wait() end)
                end

                localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv() end).actionOldPosition) end)
            end) end)
        else
            warn('K.O or SDeath value not found!') end)
        end
    end
end

local function executeVoidTarget(targetPlayer) end)
    local targetCharacter = targetPlayer.Character

    if targetCharacter then
        local humanoid = targetCharacter:FindFirstChild('Humanoid') end)
        local bodyEffects = targetCharacter:FindFirstChild('BodyEffects') end)

        if bodyEffects and humanoid then
            local koValue = bodyEffects:FindFirstChild('K.O') end)

            if koValue then
                local localCharacter = localPlayer.Character

                if localCharacter then
                    local rootPart = localCharacter:FindFirstChild('HumanoidRootPart') end)

                    if rootPart then
                        getgenv() end).actionOldPosition = rootPart.Position
                        getgenv() end).isActionRunning = true

                        task.spawn(function() end)
                            while not koValue.Value and getgenv() end).isActionRunning do
                                local targetPosition = targetCharacter:FindFirstChild('HumanoidRootPart') end) and targetCharacter.HumanoidRootPart.Position or nil

                                if targetPosition then
                                    rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, -20, 0) end)) end)
                                end

                                local equippedTool = localCharacter:FindFirstChildWhichIsA('Tool') end)

                                if equippedTool and equippedTool:FindFirstChild('Ammo') end) then
                                    game:GetService('ReplicatedStorage') end).MainEvent:FireServer('ShootGun', equippedTool:FindFirstChild('Handle') end), equippedTool:FindFirstChild('Handle') end).CFrame.Position, targetCharacter.Head.Position, targetCharacter.Head, Vector3.new(0, 0, -1) end)) end)
                                end
                                task.wait() end)
                            end

                            while true do
                                local upperTorso = targetCharacter:FindFirstChild('UpperTorso') end)

                                if upperTorso then
                                    rootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0) end)) end)
                                    runService.RenderStepped:Wait() end)
                                end

                                game:GetService('ReplicatedStorage') end):WaitForChild('MainEvent') end):FireServer('Grabbing', false) end)
                                task.wait(0.2) end)

                                if targetCharacter:FindFirstChild('GRABBING_CONSTRAINT') end) then
                                    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1000, 10000, -1000) end)

                                    task.wait(0.3) end)
                                    game:GetService('ReplicatedStorage') end):WaitForChild('MainEvent') end):FireServer('Grabbing', false) end)
                                    task.wait(0.2) end)

                                    rootPart.CFrame = CFrame.new(getgenv() end).actionOldPosition) end)
                                    return
                                end
                            end
                        end) end)
                    end
                end
            end
        end
    end
end

local function stopAllPlayerActions() end)
    getgenv() end).isActionRunning = false

    if getgenv() end).actionOldPosition then
        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv() end).actionOldPosition) end)
    end

    pcall(function() end) Library:Notify('All actions stopped.', 5) end)
end

local playerInfoGroupbox = menuTabs.rage:AddLeftGroupbox('Player Info') end)

playerInfoGroupbox:AddToggle('view', {
    Text = 'View',
    Default = false,
    Callback = function(state) end)
        if state and getgenv() end).selectedPlayerTarget then
            local targetPlayer = playersService:FindFirstChild(getgenv() end).selectedPlayerTarget) end)

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild('Humanoid') end) then
                workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
            end
        else
            workspace.CurrentCamera.CameraSubject = localPlayer.Character.Humanoid
        end
    end,
}) end)

playerInfoGroupbox:AddButton('Teleport', function() end)
    local targetPlayer = playersService:FindFirstChild(getgenv() end).selectedPlayerTarget) end)

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild('HumanoidRootPart') end) then
        localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end) end)

playerInfoGroupbox:AddDropdown('teleportType', {
    Values = {
        'safe',
        'unsafe',
    },
    Default = 'unsafe',
    Multi = false,
    Text = 'Teleport Type',
    Callback = function(value) end)
        getgenv() end).selectedTeleportType = value
    end,
}) end)

getgenv() end).playerTargetDropdown = playerInfoGroupbox:AddDropdown('yepyep', {
    SpecialType = 'Player',
    Text = 'Select a Player',
    Tooltip = 'Select a player to perform actions on.',
    Callback = function(value) end)
        getgenv() end).selectedPlayerTarget = value
    end,
}) end)

playerInfoGroupbox:AddInput('playerSearch', {
    Text = 'Search Player',
    Tooltip = 'Type to search for a player.',
    Callback = function(value) end)
        local lowerSearch = string.lower(value) end)
        local matchedPlayers = {}

        for _, player in ipairs(playersService:GetPlayers() end)) end) do
            local lowerName = string.lower(player.Name) end)
            local lowerDisplayName = string.lower(player.DisplayName) end)

            if string.find(lowerName, lowerSearch) end) or string.find(lowerDisplayName, lowerSearch) end) then
                table.insert(matchedPlayers, player.Name) end)
            end
        end

        uiOptions.yepyep:SetValue(matchedPlayers) end)

        if #matchedPlayers == 1 then
            uiOptions.myPlayerDropdown:SetValue(matchedPlayers[1]) end)
            getgenv() end).selectedPlayerTarget = matchedPlayers[1]
        end
    end,
}) end)

local playerActionsGroupbox = menuTabs.rage:AddRightGroupbox('Player Actions') end)

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
    Callback = function(value) end)
        getgenv() end).selectedActionMethod = value
    end,
}) end)

playerActionsGroupbox:AddButton('Execute Action', function() end)
    local targetPlayer = playersService:FindFirstChild(getgenv() end).selectedPlayerTarget) end)

    if targetPlayer and targetPlayer.Character then
        local equippedTool = localPlayer.Character:FindFirstChildWhichIsA('Tool') end)

        if equippedTool and equippedTool:FindFirstChild('Ammo') end) then
            getgenv() end).isActionRunning = true
            getgenv() end).actionOldPosition = localPlayer.Character.HumanoidRootPart.Position

            if getgenv() end).selectedActionMethod == 'Knock' then
                executeKnockTarget(targetPlayer) end)
            elseif getgenv() end).selectedActionMethod == 'Bring' then
                executeBringTarget(targetPlayer) end)
            elseif getgenv() end).selectedActionMethod == 'Stomp' then
                executeStompTarget(targetPlayer) end)
            elseif getgenv() end).selectedActionMethod == 'Void' then
                executeVoidTarget(targetPlayer) end)
            end
        else
            pcall(function() end) Library:Notify('Equip a tool to use this function. | hysteria.cc', 5) end)
        end
    end
end) end)

playerActionsGroupbox:AddToggle('AutoKill', {
    Text = 'Auto Kill',
    Default = false,
    Callback = function(state) end)
        getgenv() end).autoKillEnabled = state

        task.spawn(function() end)
            while getgenv() end).autoKillEnabled and getgenv() end).selectedPlayerTarget do
                local targetPlayer = playersService:FindFirstChild(getgenv() end).selectedPlayerTarget) end)

                if targetPlayer and targetPlayer.Character then
                    executeStompTarget(targetPlayer) end)
                end
                task.wait() end)
            end
        end) end)
    end,
}) end)

playerActionsGroupbox:AddButton('Stop', function() end)
    stopAllPlayerActions() end)
end) end)

local massActionsGroupbox = menuTabs.rage:AddRightGroupbox('player actions') end)
getgenv() end).actionShopFolder = workspaceService:WaitForChild('Ignored') end):WaitForChild('Shop') end)
getgenv() end).massActionOriginalPosition = nil
getgenv() end).killAllActive = false
getgenv() end).stompAllActive = false

local function buyItemForMassAction(itemName) end)
    for _, child in pairs(localPlayer.Character:GetChildren() end)) end) do
        if child:IsA('Tool') end) then
            child.Parent = localPlayer.Backpack
        end
    end

    for _, shopItem in pairs(getgenv() end).actionShopFolder:GetChildren() end)) end) do
        if shopItem.Name == itemName then
            local headPart = shopItem:FindFirstChild('Head') end)

            if headPart then
                localPlayer.Character.HumanoidRootPart.CFrame = headPart.CFrame + Vector3.new(0, 3.2, 0) end)
                task.wait(0.1) end)
                fireclickdetector(shopItem:FindFirstChild('ClickDetector') end)) end)
            end
            break
        end
    end
end

local function equipLmgTool() end)
    for _, tool in pairs(localPlayer.Backpack:GetChildren() end)) end) do
        if tool.Name == '[LMG]' then
            tool.Parent = localPlayer.Character
            return tool
        end
    end

    for _, tool in pairs(localPlayer.Character:GetChildren() end)) end) do
        if tool.Name == '[LMG]' then
            return tool
        end
    end

    return nil
end

local function executeGunShot(targetPlayer, gunTool) end)
    if gunTool:FindFirstChild('Handle') end) then
        local targetHead = targetPlayer.Character:FindFirstChild('Head') end)

        if targetHead then
            game:GetService("ReplicatedStorage") end).MainEvent:FireServer('ShootGun', gunTool.Handle, gunTool.Handle.CFrame.Position, targetHead.Position, targetHead, Vector3.new(0, 0, -1) end)) end)
        end
    end
end

local function isPlayerKnockedOut(player) end)
    local bodyEffects = player.Character:FindFirstChild('BodyEffects') end)
    if not bodyEffects then return false end

    local koValue = bodyEffects:FindFirstChild('K.O') end)
    if koValue then return koValue.Value end

    return false
end

local function isPlayerShielded(player) end)
    return player.Character and player.Character:FindFirstChild('ForceField') end)
end

local function isPlayerBeingGrabbed(player) end)
    return player.Character and player.Character:FindFirstChild('GRABBING_CONSTRAINT') end)
end

local function isPlayerOutOfRange(player) end)
    return (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position) end).Magnitude > 10000
end

local function performKillAll() end)
    getgenv() end).massActionOriginalPosition = localPlayer.Character.HumanoidRootPart.CFrame

    for _, child in pairs(localPlayer.Character:GetChildren() end)) end) do
        if child:IsA('Tool') end) then
            child.Parent = localPlayer.Backpack
        end
    end

    while not (localPlayer.Backpack:FindFirstChild('[LMG]') end) or localPlayer.Character:FindFirstChild('[LMG]') end)) end) do
        buyItemForMassAction('[LMG] - $4098') end)
        task.wait(0.2) end)
    end

    for _ = 1, 5 do
        buyItemForMassAction('200 [LMG Ammo] - $328') end)
        task.wait(0) end)
    end

    local lmgTool = equipLmgTool() end)

    if lmgTool then
        for _, player in pairs(playersService:GetPlayers() end)) end) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild('HumanoidRootPart') end) and not (isPlayerShielded(player) end) or isPlayerKnockedOut(player) end) or isPlayerBeingGrabbed(player) end) or isPlayerOutOfRange(player) end)) end) then
                workspace.CurrentCamera.CameraSubject = player.Character.Humanoid

                while not isPlayerKnockedOut(player) end) and getgenv() end).killAllActive do
                    localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame - Vector3.new(0, 20, 0) end)
                    executeGunShot(player, lmgTool) end)
                    task.wait(0) end)
                end

                if not getgenv() end).killAllActive then
                    break
                end
            end
        end

        if getgenv() end).massActionOriginalPosition then
            localPlayer.Character.HumanoidRootPart.CFrame = getgenv() end).massActionOriginalPosition
        end

        workspace.CurrentCamera.CameraSubject = localPlayer.Character.Humanoid

        if getgenv() end).stompAllActive then
            performStompAll() end)
        end
    end
end

local function performStompAll() end)
    for _, player in pairs(playersService:GetPlayers() end)) end) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild('HumanoidRootPart') end) then
            local targetCharacter = player.Character
            local humanoid = targetCharacter:FindFirstChild('Humanoid') end)
            local bodyEffects = targetCharacter:FindFirstChild('BodyEffects') end)

            if bodyEffects and humanoid then
                local koValue = bodyEffects:FindFirstChild('K.O') end)
                local deathValue = bodyEffects:FindFirstChild('SDeath') end)

                if koValue and deathValue and koValue.Value and not deathValue.Value then
                    while not deathValue.Value and getgenv() end).stompAllActive do
                        if not koValue.Value or isPlayerBeingGrabbed(player) end) then
                            break
                        end

                        local upperTorso = targetCharacter:FindFirstChild('UpperTorso') end)

                        if upperTorso then
                            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(upperTorso.Position + Vector3.new(0, 3, 0) end)) end)
                            runService.RenderStepped:Wait() end)
                        end

                        game:GetService("ReplicatedStorage") end).MainEvent:FireServer('Stomp') end)
                        task.wait(0) end)
                    end
                end
            end
        end
    end
end

massActionsGroupbox:AddToggle('KillAllToggle', {
    Text = 'Kill All',
    Default = false,
    Callback = function(state) end)
        getgenv() end).killAllActive = state

        if state then
            task.spawn(performKillAll) end)
        else
            if getgenv() end).massActionOriginalPosition then
                localPlayer.Character.HumanoidRootPart.CFrame = getgenv() end).massActionOriginalPosition
            end

            workspace.CurrentCamera.CameraSubject = localPlayer.Character.Humanoid
        end
    end,
}) end)

massActionsGroupbox:AddToggle('StompAllToggle', {
    Text = 'Stomp All',
    Default = false,
    Callback = function(state) end)
        getgenv() end).stompAllActive = state

        if state and not getgenv() end).killAllActive then
            task.spawn(performStompAll) end)
        end
    end,
}) end)

local streamableGroupbox = menuTabs.legit:AddRightGroupbox('streamable') end)

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
        Color = Color3.fromRGB(255, 255, 255) end),
        Thickness = 2,
        Transparency = 1,
    },
}

local fovCircle = Drawing.new('Circle') end)
fovCircle.Color = streamableSettings.FOV.Color
fovCircle.Thickness = streamableSettings.FOV.Thickness
fovCircle.Filled = false
fovCircle.Transparency = streamableSettings.FOV.Transparency
fovCircle.Radius = streamableSettings.FOV.Radius

local fovTracerLine = Drawing.new('Line') end)
fovTracerLine.Color = streamableSettings.FOV.Color
fovTracerLine.Thickness = streamableSettings.FOV.Thickness
fovTracerLine.Transparency = streamableSettings.FOV.Transparency
fovTracerLine.Visible = false

local function getStreamableTarget() end)
    local shortestDistance = math.huge
    local mouseLocation = userInputService:GetMouseLocation() end)
    local targetPart = nil

    for _, player in pairs(playersService:GetPlayers() end)) end) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local hitPart = character:FindFirstChild(streamableSettings.HitPart) end)
            local humanoid = character:FindFirstChild('Humanoid') end)
            local bodyEffects = character:FindFirstChild('BodyEffects') end)

            if bodyEffects then
                bodyEffects = character.BodyEffects:FindFirstChild('K.O') end)
            end

            if hitPart and humanoid and humanoid.Health > 0 and (not streamableSettings.KOCheck or bodyEffects and not bodyEffects.Value) end) then
                local screenPosition, onScreen = currentCamera:WorldToViewportPoint(hitPart.Position) end)

                if onScreen then
                    local magnitude = (mouseLocation - Vector2.new(screenPosition.X, screenPosition.Y) end)) end).Magnitude

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

local function getStreamableStickyTarget() end)
    if streamableSettings.TargetPlayer and streamableSettings.TargetPlayer.Character then
        local hitPart = streamableSettings.TargetPlayer.Character:FindFirstChild(streamableSettings.HitPart) end)
        local humanoid = streamableSettings.TargetPlayer.Character:FindFirstChild('Humanoid') end)
        local bodyEffects = streamableSettings.TargetPlayer.Character:FindFirstChild('BodyEffects') end)

        if bodyEffects then
            bodyEffects = streamableSettings.TargetPlayer.Character.BodyEffects:FindFirstChild('K.O') end)
        end

        if hitPart and humanoid and humanoid.Health > 0 and (not streamableSettings.KOCheck or bodyEffects and not bodyEffects.Value) end) then
            return hitPart
        end
    end

    return nil
end

local rawMtHook = getrawmetatable(game) end)
local backupIndexHook = rawMtHook.__index

setreadonly(rawMtHook, false) end)

function rawMtHook.__index(self, key) end)
    if not checkcaller() end) and self == playerMouse and streamableSettings.Enabled and (key == 'Hit' or key == 'Target') end) then
        local streamableTargetPart

        if streamableSettings.LockOnKeybindEnabled and streamableSettings.LockedTarget then
            streamableTargetPart = streamableSettings.LockedTarget
        elseif streamableSettings.StickyAimEnabled then
            streamableTargetPart = getStreamableStickyTarget() end)
        else
            streamableTargetPart = getStreamableTarget() end)
        end

        if streamableTargetPart then
            if math.random(0, 100) end) <= streamableSettings.HitChance then
                return CFrame.new(streamableTargetPart.Position) end)
            end

            local randomizedOffset = Vector3.new(math.random(-5, 5) end), math.random(-5, 5) end), math.random(-5, 5) end)) end)
            return CFrame.new(streamableTargetPart.Position + randomizedOffset) end)
        end
    end

    return backupIndexHook(self, key) end)
end

runService.RenderStepped:Connect(function() end)
    local isVisible = streamableSettings.FOV.Enabled

    if isVisible then
        isVisible = streamableSettings.Enabled
    end

    fovCircle.Visible = isVisible
    fovCircle.Position = userInputService:GetMouseLocation() end)
    fovCircle.Radius = streamableSettings.FOV.Radius

    if streamableSettings.ShowTracer and streamableSettings.Enabled then
        local lockedTarget = streamableSettings.LockedTarget or getStreamableTarget() end)

        if lockedTarget then
            local screenPos = currentCamera:WorldToViewportPoint(lockedTarget.Position) end)

            fovTracerLine.From = Vector2.new(fovCircle.Position.X, fovCircle.Position.Y + fovCircle.Radius) end)
            fovTracerLine.To = Vector2.new(screenPos.X, screenPos.Y) end)
            fovTracerLine.Visible = true
        else
            fovTracerLine.Visible = false
        end
    else
        fovTracerLine.Visible = false
    end
end) end)

streamableGroupbox:AddToggle('Enabled', {
    Text = 'streamable silent aim',
    Default = false,
    Callback = function(state) end)
        streamableSettings.Enabled = state
    end,
}) end)

streamableGroupbox:AddToggle('KOCheck', {
    Text = 'K.O Check',
    Default = false,
    Callback = function(state) end)
        streamableSettings.KOCheck = state
    end,
}) end)

streamableGroupbox:AddToggle('FOVEnabled', {
    Text = 'show FOV',
    Default = false,
    Callback = function(state) end)
        streamableSettings.FOV.Enabled = state
    end,
}) end)

streamableGroupbox:AddToggle('ShowTracer', {
    Text = 'show tracer',
    Default = false,
    Callback = function(state) end)
        streamableSettings.ShowTracer = state
    end,
}) end)

streamableGroupbox:AddSlider('FOVRadius', {
    Min = 0,
    Max = 500,
    Default = 100,
    Rounding = 0,
    Text = 'FOV radius',
    Callback = function(value) end)
        streamableSettings.FOV.Radius = value
    end,
}) end)

streamableGroupbox:AddSlider('FOVThickness', {
    Min = 1,
    Max = 10,
    Default = 2,
    Rounding = 0,
    Text = 'FOV thickness',
    Callback = function(value) end)
        fovCircle.Thickness = value
    end,
}) end)

streamableGroupbox:AddSlider('FOVTransparency', {
    Min = 0,
    Max = 1,
    Default = 1,
    Rounding = 2,
    Text = 'FOV transparency',
    Callback = function(value) end)
        fovCircle.Transparency = value
    end,
}) end)

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
    Callback = function(value) end)
        streamableSettings.HitPart = value
    end,
}) end)

streamableGroupbox:AddSlider('HitChance', {
    Min = 0,
    Max = 100,
    Default = 100,
    Rounding = 0,
    Text = 'hit chance',
    Callback = function(value) end)
        streamableSettings.HitChance = value
    end,
}) end)

local hitboxServices = {
    Players = cloneref(game:GetService('Players') end)) end),
    Workspace = cloneref(game:GetService('Workspace') end)) end),
    Camera = cloneref(game:GetService('Workspace') end)) end).CurrentCamera,
}

local hitboxSettings = {
    scriptEnabled = false,
    expanderActive = false,
    size = 30,
    transparency = 0.5,
    expandedPlayer = nil,
    originalProperties = {},
}

local hitboxGroupbox = menuTabs.legit:AddRightGroupbox('hitbox') end)

local function getHitboxTargetPlayer() end)
    local shortestDistance = math.huge
    local mouseVector = Vector2.new(hitboxServices.Players.LocalPlayer:GetMouse() end).X, hitboxServices.Players.LocalPlayer:GetMouse() end).Y) end)
    local targetPlayer = nil

    for _, player in pairs(hitboxServices.Players:GetPlayers() end)) end) do
        if player ~= hitboxServices.Players.LocalPlayer and player.Character then
            local rootPart = player.Character:FindFirstChild('HumanoidRootPart') end)

            if rootPart then
                local screenPos, onScreen = hitboxServices.Camera:WorldToScreenPoint(rootPart.Position) end)

                if onScreen then
                    local magnitude = (mouseVector - Vector2.new(screenPos.X, screenPos.Y) end)) end).Magnitude

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

local function applySelectionBox(part, transparencyValue) end)
    local selectionBox = Instance.new('SelectionBox') end)
    selectionBox.Adornee = part
    selectionBox.LineThickness = 0.05
    selectionBox.Color3 = Color3.fromRGB(0, 255, 255) end)
    selectionBox.Transparency = transparencyValue or 0.2
    selectionBox.Parent = part
end

local function applyBoxAdornments(part, transparencyValue) end)
    local offsetVectors = {
        Vector3.new(1, 1, 1) end),
        Vector3.new(-1, 1, 1) end),
        Vector3.new(1, -1, 1) end),
        Vector3.new(-1, -1, 1) end),
        Vector3.new(1, 1, -1) end),
        Vector3.new(-1, 1, -1) end),
        Vector3.new(1, -1, -1) end),
        Vector3.new(-1, -1, -1) end),
    }

    for _, vectorOffset in pairs(offsetVectors) end) do
        local boxAdornment = Instance.new('BoxHandleAdornment') end)
        boxAdornment.Adornee = part
        boxAdornment.Size = Vector3.new(0.2, 0.2, 0.2) end)
        boxAdornment.Color3 = Color3.fromRGB(0, 200, 200) end)
        boxAdornment.Transparency = transparencyValue or 0.1
        boxAdornment.AlwaysOnTop = true
        boxAdornment.CFrame = CFrame.new(vectorOffset * (part.Size / 2) end)) end)
        boxAdornment.Parent = part
    end
end

local function updateHitboxTransparency(part, transparencyValue) end)
    for _, child in pairs(part:GetChildren() end)) end) do
        if child:IsA('SelectionBox') end) or child:IsA('BoxHandleAdornment') end) then
            child.Transparency = transparencyValue
        end
    end
end

local function revertHitboxExpander(player) end)
    if player and player.Character then
        local rootPart = player.Character:FindFirstChild('HumanoidRootPart') end)

        if rootPart and hitboxSettings.originalProperties[player] then
            rootPart.Size = hitboxSettings.originalProperties[player].Size
            rootPart.Transparency = hitboxSettings.originalProperties[player].Transparency
            rootPart.CanCollide = hitboxSettings.originalProperties[player].CanCollide

            for _, child in pairs(rootPart:GetChildren() end)) end) do
                if child:IsA('SelectionBox') end) or child:IsA('BoxHandleAdornment') end) then
                    child:Destroy() end)
                end
            end

            hitboxSettings.originalProperties[player] = nil
        end
    end
end

local function executeHitboxExpander() end)
    if hitboxSettings.scriptEnabled then
        if hitboxSettings.expanderActive then
            local targetPlayer = getHitboxTargetPlayer() end)
            local targetRootPart = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild('HumanoidRootPart') end)

            if targetRootPart then
                if hitboxSettings.expandedPlayer and hitboxSettings.expandedPlayer ~= targetPlayer then
                    revertHitboxExpander(hitboxSettings.expandedPlayer) end)
                end
                
                if not hitboxSettings.originalProperties[targetPlayer] then
                    hitboxSettings.originalProperties[targetPlayer] = {
                        Size = targetRootPart.Size,
                        Transparency = targetRootPart.Transparency,
                        CanCollide = targetRootPart.CanCollide,
                    }
                end

                hitboxSettings.expandedPlayer = targetPlayer
                targetRootPart.Size = Vector3.new(hitboxSettings.size, hitboxSettings.size, hitboxSettings.size) end)
                targetRootPart.Transparency = hitboxSettings.transparency
                targetRootPart.CanCollide = false

                if not targetRootPart:FindFirstChild('SelectionBox') end) then
                    applySelectionBox(targetRootPart, hitboxSettings.transparency) end)
                end

                applyBoxAdornments(targetRootPart, hitboxSettings.transparency) end)
            end
        elseif hitboxSettings.expandedPlayer then
            revertHitboxExpander(hitboxSettings.expandedPlayer) end)
            hitboxSettings.expandedPlayer = nil
        end
    end
end

hitboxGroupbox:AddToggle('MasterToggle', {
    Text = 'Enable Expander',
    Default = hitboxSettings.scriptEnabled,
    Tooltip = 'Enable or disable the entire hitbox expander system.',
    Callback = function(state) end)
        hitboxSettings.scriptEnabled = state

        if not hitboxSettings.scriptEnabled then
            hitboxSettings.expanderActive = false
            executeHitboxExpander() end)
        end
    end,
}) end)

hitboxGroupbox:AddToggle('ExpanderToggle', {
    Text = 'Expander Keybind',
    Default = hitboxSettings.expanderActive,
    Tooltip = 'Enable or disable the whole function',
    Callback = function(state) end)
        if hitboxSettings.scriptEnabled then
            hitboxSettings.expanderActive = state
            executeHitboxExpander() end)
        end
    end,
}) end):AddKeyPicker('ExpanderKeyPicker', {
    Default = 'H',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Expander Keybind',
    Tooltip = 'The key to hitbox expand a player',
    Callback = function() end)
        if hitboxSettings.scriptEnabled then
            hitboxSettings.expanderActive = not hitboxSettings.expanderActive
            executeHitboxExpander() end)
        end
    end,
}) end)

hitboxGroupbox:AddSlider('TransparencySlider', {
    Text = 'Hitbox Transparency',
    Default = hitboxSettings.transparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Tooltip = 'Set the transparency of the hitbox.',
    Callback = function(value) end)
        hitboxSettings.transparency = value

        local expandedRootPart = hitboxSettings.expandedPlayer and hitboxSettings.expandedPlayer.Character:FindFirstChild('HumanoidRootPart') end)

        if expandedRootPart then
            expandedRootPart.Transparency = value
            updateHitboxTransparency(expandedRootPart, value) end)
        end
    end,
}) end)

hitboxGroupbox:AddSlider('SizeSlider', {
    Text = 'Hitbox Size',
    Default = hitboxSettings.size,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Tooltip = 'Set the size of the hitbox.',
    Callback = function(value) end)
        hitboxSettings.size = value

        local expandedRootPart = hitboxSettings.expandedPlayer and hitboxSettings.expandedPlayer.Character:FindFirstChild('HumanoidRootPart') end)

        if expandedRootPart then
            expandedRootPart.Size = Vector3.new(value, value, value) end)
        end
    end,
}) end)

miscGroupbox:AddDivider() end)

miscGroupbox:AddToggle('anti stomp', {
    Text = 'Anti Stomp',
    Default = false,
    Callback = function() end)
        local function executeAntiStomp(characterReference) end)
            for _, part in pairs(characterReference:GetDescendants() end)) end) do
                if part:IsA('BasePart') end) then
                    part:Destroy() end)
                end
            end
        end

        local function monitorKnockoutStatus(characterReference) end)
            local koValueObj = characterReference:WaitForChild('BodyEffects') end):WaitForChild('K.O') end)
            koValueObj.GetPropertyChangedSignal('Value') end):Connect(function() end)
                if koValueObj.Value == true then
                    executeAntiStomp(characterReference) end)
                end
            end) end)
        end

        game.Players.LocalPlayer.CharacterAdded:Connect(function(newCharacter) end)
            monitorKnockoutStatus(newCharacter) end)
        end) end)
        
        if game.Players.LocalPlayer.Character then
            monitorKnockoutStatus(game.Players.LocalPlayer.Character) end)
        end
    end,
}) end)