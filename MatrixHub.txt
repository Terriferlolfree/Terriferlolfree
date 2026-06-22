https://discord.gg/49Yz8jx3XC

local keyWhitelistUrl = "https://gist.githubusercontent.com/RKTOPAN/625371b509005f80e9e4360c2adba493/raw/c1bc3a617f17d899d30287a47848a9ee4f384f3c/script%2520keys"
local validKeys = {}

local success, result = pcall(function()
	local raw = game:HttpGet(keyWhitelistUrl)
	for line in raw:gmatch("[^\n]+") do
		local key = line:gsub("%s", "")
		if #key > 0 then
			validKeys[key] = true
		end
	end
end)

if not success then
	warn("Failed to get keys:", result)
end

local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local oldKeyGui = player.PlayerGui:FindFirstChild("RKTPAN_KEYSYSTEM")
if oldKeyGui then
	oldKeyGui:Destroy()
end

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "RKTPAN_KEYSYSTEM"
keyGui.ResetOnSpawn = false
keyGui.DisplayOrder = 9999
keyGui.Parent = player.PlayerGui

local keyBlur = Instance.new("BlurEffect")
keyBlur.Size = 0
keyBlur.Parent = game:GetService("Lighting")
TweenService:Create(keyBlur, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { Size = 18 }):Play()

local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0
backdrop.ZIndex = 10
backdrop.Parent = keyGui
TweenService:Create(backdrop, TweenInfo.new(0.35), { BackgroundTransparency = 0.55 }):Play()

local particles = {}
local function createParticle()
	local size = math.random(5, 12)
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, size, 0, size)
	dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dot.BackgroundTransparency = math.random(40, 80) / 100
	dot.BorderSizePixel = 0
	dot.ZIndex = 11
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	dot.Parent = keyGui
	return {
		dot = dot,
		x = math.random(0, 1200),
		y = math.random(0, 700),
		speedY = math.random(-30, -10),
		speedX = math.random(-5, 5)
	}
end

for i = 1, 30 do
	particles[i] = createParticle()
end

local lastParticleTick = tick()
local particleConnection
particleConnection = RunService.RenderStepped:Connect(function()
	local now = tick()
	local deltaTime = math.min(now - lastParticleTick, 0.05)
	lastParticleTick = now
	local screenWidth = keyGui.AbsoluteSize.X
	local screenHeight = keyGui.AbsoluteSize.Y
	for _, p in ipairs(particles) do
		p.x = p.x + p.speedX * deltaTime
		p.y = p.y + p.speedY * deltaTime
		if p.y < -6 then
			p.y = screenHeight + 6
			p.x = math.random(0, screenWidth)
		end
		p.dot.Position = UDim2.new(0, p.x, 0, p.y)
	end
end)

local card = Instance.new("Frame")
card.Size = UDim2.new(0, 360, 0, 0)
card.Position = UDim2.new(0.5, -180, 0.5, 0)
card.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
card.BorderSizePixel = 0
card.ZIndex = 20
card.ClipsDescendants = true
card.Parent = keyGui
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = Color3.fromRGB(60, 60, 60)
cardStroke.Thickness = 1.2
TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 360, 0, 210),
	Position = UDim2.new(0.5, -180, 0.5, -105)
}):Play()

local accentBar = Instance.new("Frame", card)
accentBar.Size = UDim2.new(1, 0, 0, 3)
accentBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
accentBar.BorderSizePixel = 0
accentBar.ZIndex = 21

local logoFrame = Instance.new("Frame", card)
logoFrame.Size = UDim2.new(1, 0, 0, 58)
logoFrame.Position = UDim2.new(0, 0, 0, 3)
logoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
logoFrame.BorderSizePixel = 0
logoFrame.ZIndex = 21

local logoLine = Instance.new("Frame", logoFrame)
logoLine.Size = UDim2.new(1, 0, 0, 1)
logoLine.Position = UDim2.new(0, 0, 1, -1)
logoLine.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
logoLine.BorderSizePixel = 0
logoLine.ZIndex = 22

local logoV = Instance.new("TextLabel", logoFrame)
logoV.Size = UDim2.new(0, 30, 0, 36)
logoV.Position = UDim2.new(0, 10, 0.5, -18)
logoV.BackgroundTransparency = 1
logoV.Text = "M"
logoV.TextColor3 = Color3.fromRGB(255, 255, 255)
logoV.Font = Enum.Font.Code
logoV.TextSize = 28
logoV.ZIndex = 23

local titleLabel = Instance.new("TextLabel", logoFrame)
titleLabel.Size = UDim2.new(1, -50, 0, 22)
titleLabel.Position = UDim2.new(0, 48, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Milkyway, for Da Hood"
titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 23

local subLabel = Instance.new("TextLabel", logoFrame)
subLabel.Size = UDim2.new(1, -50, 0, 14)
subLabel.Position = UDim2.new(0, 48, 0, 36)
subLabel.BackgroundTransparency = 1
subLabel.Text = "Key verification required"
subLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
subLabel.Font = Enum.Font.Code
subLabel.TextSize = 10
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.ZIndex = 23

local body = Instance.new("Frame", card)
body.Size = UDim2.new(1, 0, 1, -64)
body.Position = UDim2.new(0, 0, 0, 64)
body.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
body.BorderSizePixel = 0
body.ZIndex = 21

local inputLabel = Instance.new("TextLabel", body)
inputLabel.Size = UDim2.new(1, -32, 0, 14)
inputLabel.Position = UDim2.new(0, 16, 0, 16)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Enter your key"
inputLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
inputLabel.Font = Enum.Font.Code
inputLabel.TextSize = 9
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.ZIndex = 22

local inputWrap = Instance.new("Frame", body)
inputWrap.Size = UDim2.new(1, -32, 0, 36)
inputWrap.Position = UDim2.new(0, 16, 0, 32)
inputWrap.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
inputWrap.BorderSizePixel = 0
inputWrap.ZIndex = 22
Instance.new("UICorner", inputWrap).CornerRadius = UDim.new(0, 5)

local inputWrapStroke = Instance.new("UIStroke", inputWrap)
inputWrapStroke.Color = Color3.fromRGB(50, 50, 50)
inputWrapStroke.Thickness = 1

local inputBox = Instance.new("TextBox", inputWrap)
inputBox.Size = UDim2.new(1, -12, 1, 0)
inputBox.Position = UDim2.new(0, 8, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Milkyway-XXXXXXXXXXXXXXXX"
inputBox.PlaceholderColor3 = Color3.fromRGB(55, 55, 55)
inputBox.TextColor3 = Color3.fromRGB(210, 210, 210)
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 13
inputBox.ClearTextOnFocus = false
inputBox.ZIndex = 23
inputBox.Focused:Connect(function()
	TweenService:Create(inputWrapStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(120, 120, 120), Thickness = 1.2 }):Play()
end)
inputBox.FocusLost:Connect(function()
	TweenService:Create(inputWrapStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }):Play()
end)

local statusLabel = Instance.new("TextLabel", body)
statusLabel.Size = UDim2.new(1, -32, 0, 14)
statusLabel.Position = UDim2.new(0, 16, 0, 74)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(200, 70, 70)
statusLabel.Font = Enum.Font.Code
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 22

local submitButton = Instance.new("TextButton", body)
submitButton.Size = UDim2.new(1, -32, 0, 32)
submitButton.Position = UDim2.new(0, 16, 0, 96)
submitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
submitButton.BorderSizePixel = 0
submitButton.Text = "Verify Key"
submitButton.TextColor3 = Color3.fromRGB(230, 230, 230)
submitButton.Font = Enum.Font.Code
submitButton.TextSize = 12
submitButton.ZIndex = 22
Instance.new("UICorner", submitButton).CornerRadius = UDim.new(0, 5)

local buttonStroke = Instance.new("UIStroke", submitButton)
buttonStroke.Color = Color3.fromRGB(120, 120, 120)
buttonStroke.Thickness = 1
submitButton.MouseEnter:Connect(function()
	TweenService:Create(submitButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(80, 80, 80) }):Play()
end)
submitButton.MouseLeave:Connect(function()
	TweenService:Create(submitButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(60, 60, 60) }):Play()
end)

local function closeKeyGui()
	particleConnection:Disconnect()
	for _, p in ipairs(particles) do
		p.dot:Destroy()
	end
	TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 360, 0, 0),
		Position = UDim2.new(0.5, -180, 0.5, 0)
	}):Play()
	TweenService:Create(backdrop, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(keyBlur, TweenInfo.new(0.35), { Size = 0 }):Play()
	task.delay(0.35, function()
		keyGui:Destroy()
	end)
end

local function submitKey()
	local input = inputBox.Text:upper():gsub("%s", "")
	if validKeys[input] then
		statusLabel.TextColor3 = Color3.fromRGB(70, 190, 90)
		statusLabel.Text = "✓ Verified. Loading..."
		submitButton.Active = false
		TweenService:Create(submitButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 100, 50) }):Play()
		task.delay(0.7, closeKeyGui)
	else
		statusLabel.TextColor3 = Color3.fromRGB(210, 60, 60)
		statusLabel.Text = "✗ Invalid key. Try again."
		TweenService:Create(inputWrapStroke, TweenInfo.new(0.1), { Color = Color3.fromRGB(200, 50, 50), Thickness = 1.5 }):Play()
		TweenService:Create(card, TweenInfo.new(0.05), { Position = UDim2.new(0.5, -176, 0.5, -105) }):Play()
		task.delay(0.05, function()
			TweenService:Create(card, TweenInfo.new(0.05), { Position = UDim2.new(0.5, -184, 0.5, -105) }):Play()
		end)
		task.delay(0.1, function()
			TweenService:Create(card, TweenInfo.new(0.08), { Position = UDim2.new(0.5, -180, 0.5, -105) }):Play()
			TweenService:Create(inputWrapStroke, TweenInfo.new(0.3), { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }):Play()
		end)
	end
end

submitButton.MouseButton1Click:Connect(submitKey)
inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		submitKey()
	end
end)

local isGuiClosed = false
keyGui.AncestryChanged:Connect(function()
	if not keyGui.Parent then
		isGuiClosed = true
	end
end)

repeat
	task.wait()
until isGuiClosed

local Players = game:GetService("Players")

local settings = {
	highJump = false,
	highJumpKey = Enum.KeyCode.H,
	highJumpPower = 150,
	autoReload = false,
	flyEnabled = false,
	speedEnabled = false,
	flyKey = Enum.KeyCode.V,
	speedKey = Enum.KeyCode.X,
	flingRange = 50,
	voidSavedCFrame = nil,
	hudVisible = true,
	stickyAim = false,
	stickyTarget = nil,
	stickyKey = Enum.KeyCode.E,
	orbitEnabled = false,
	orbitKey = Enum.KeyCode.O,
	orbitTarget = nil,
	orbitRadius = 6,
	orbitSpeed = 8,
	orbitAngle = 0,
	killAuraWhitelist = {},
	killAuraFly = false,
	autoKillOrigin = nil,
	autoKillTarget = "",
	autoKillEnabled = false,
	autoKillStomp = true,
	tpSelectedPlayer = "none",
	tpPlayerKey = Enum.KeyCode.G,
	killAura = false,
	killAuraRange = 10,
	flingPlayer = false,
	flingForce = 500,
	radarEnabled = false,
	radarRange = 150,
	speedHack = false,
	autoSprint = false,
	noSlow = false,
	bhop = false,
	hitboxExpand = false,
	hitboxSize = 5,
	lockEnabled = false,
	lockHold = false,
	lockKey = Enum.KeyCode.CapsLock,
	lockTarget = nil,
	lockTeamCheck = false,
	lockWallCheck = true,
	lockFov = 150,
	lockPart = "Head",
	triggerBot = "none",
	triggerDelay = 0,
	teleportToTarget = false,
	teleportKey = Enum.KeyCode.T,
	fly = false,
	flySpeed = 50,
	maxSpeed = 325,
	walkSpeed = 16,
	jumpPower = 50,
	aimbot = false,
	silentAim = false,
	aimbotKey = false,
	aimSmooth = 8,
	aimFov = 50,
	aimPart = "Head",
	teamCheck = false,
	wallCheck = true,
	targetHighlight = false,
	noclip = false,
	antiRagdoll = false,
	netDesync = false,
	velDesync = false,
	fakePos = false,
	voidHide = false,
	safeZone = false,
	autoLoadout = false,
	followTarget = false,
	autoStomp = false,
	autoAmmo = false,
	autoArmor = false,
	antiStomp = false,
	autoMask = false,
	autoHeal = false,
	rapidFire = false,
	speedLines = false,
	velDisplay = false,
	speedRing = false,
	showFov = false,
	tracer = false,
	espEnabled = false,
	espBoxes = false,
	espBoxColor = Color3.fromRGB(255, 255, 255),
	espSkeleton = false,
	espSkelColor = Color3.fromRGB(220, 220, 220),
	espNames = false,
	espHealthBar = false,
	espDistance = false,
	espWeapon = false,
	espTracer = false,
	espOffscreen = false,
	espTeamCheck = false,
	espShowKnocked = true,
	espIgnoreNPC = false,
	espMaxDist = 300,
	espBoxOpacity = 1,
	espBoxStyle = "full",
	espHpBarPos = "left",
	espChams = false,
	espGlow = false,
	espSnapLines = false,
	guiOpen = true,
	toggleKey = Enum.KeyCode.Insert,
	velPred = false,
	gravComp = false,
	predSteps = 5,
	ignoreKnocked = false,
	ignoreFar = false,
	closestFov = true,
	useMaxDist = false,
	maxDist = 300
}

local colors = {
	bg = Color3.fromRGB(20, 20, 20),
	panel = Color3.fromRGB(28, 28, 28),
	panelAlt = Color3.fromRGB(35, 35, 35),
	panelHover = Color3.fromRGB(38, 38, 38),
	border = Color3.fromRGB(55, 55, 55),
	borderDim = Color3.fromRGB(40, 40, 40),
	text = Color3.fromRGB(200, 200, 200),
	textDim = Color3.fromRGB(120, 120, 120),
	textMuted = Color3.fromRGB(80, 80, 80),
	accent = Color3.fromRGB(255, 255, 255),
	accentBlue = Color3.fromRGB(100, 160, 255),
	accentDim = Color3.fromRGB(160, 160, 160),
	white = Color3.fromRGB(240, 240, 240),
	toggleOn = Color3.fromRGB(255, 255, 255),
	toggleOff = Color3.fromRGB(55, 55, 55),
	toggleThumb = Color3.fromRGB(14, 14, 14),
	sliderFill = Color3.fromRGB(180, 180, 180),
	sliderBg = Color3.fromRGB(50, 50, 50),
	tabSel = Color3.fromRGB(32, 32, 32),
	tabUnsel = Color3.fromRGB(20, 20, 20),
	tabText = Color3.fromRGB(210, 210, 210),
	tabDim = Color3.fromRGB(100, 100, 100),
	titleBg = Color3.fromRGB(15, 15, 15),
	sectionBg = Color3.fromRGB(22, 22, 22),
	red = Color3.fromRGB(200, 70, 70),
	green = Color3.fromRGB(70, 180, 70),
	dropBg = Color3.fromRGB(30, 30, 30)
}

local function getLocalHumanoid()
	if player.Character then
		return player.Character:FindFirstChildOfClass("Humanoid")
	end
end

local function getLocalRootPart()
	if player.Character then
		return player.Character:FindFirstChild("HumanoidRootPart")
	end
end

local function getLocalCharacter()
	return player.Character
end

local oldGui = player.PlayerGui:FindFirstChild("Milkyway_Main")
if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Milkyway_Main"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.Parent = player.PlayerGui

local radarFrame = Instance.new("Frame")
radarFrame.Size = UDim2.new(0, 160, 0, 160)
radarFrame.Position = UDim2.new(1, -176, 1, -176)
radarFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
radarFrame.BackgroundTransparency = 0.35
radarFrame.BorderSizePixel = 0
radarFrame.ZIndex = 60
radarFrame.Visible = false
radarFrame.Parent = screenGui
Instance.new("UICorner", radarFrame).CornerRadius = UDim.new(1, 0)
local radarStroke = Instance.new("UIStroke", radarFrame)
radarStroke.Color = Color3.fromRGB(80, 80, 80)
radarStroke.Thickness = 1
local radarCenter = Instance.new("Frame", radarFrame)
radarCenter.Size = UDim2.new(0, 6, 0, 6)
radarCenter.Position = UDim2.new(0.5, -3, 0.5, -3)
radarCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
radarCenter.BorderSizePixel = 0
radarCenter.ZIndex = 62
Instance.new("UICorner", radarCenter).CornerRadius = UDim.new(1, 0)

local radarDots = {}
local Lighting = game:GetService("Lighting")

local existingBlur = Lighting:FindFirstChild("Milkyway_Blur")
if existingBlur then
	existingBlur:Destroy()
end

local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "Milkyway_Blur"
blurEffect.Size = 24
blurEffect.Parent = Lighting

local function setBlur(open)
	TweenService:Create(blurEffect, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = open and 24 or 0 }):Play()
end

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 600, 0, 575)
win.Position = UDim2.new(0.5, -250, 0.5, -300)
win.BackgroundColor3 = colors.bg
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.ZIndex = 10
win.Parent = screenGui
win.ClipsDescendants = false
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 6)
local winStroke = Instance.new("UIStroke", win)
winStroke.Color = colors.border
winStroke.Thickness = 1

local particleCount = 55
local backgroundParticles = {}
local function createBackgroundParticle()
	local sz = math.random(1, 6)
	local sw = screenGui.AbsoluteSize.X
	local sh = screenGui.AbsoluteSize.Y
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, sz, 0, sz)
	dot.BackgroundColor3 = Color3.fromRGB(180, 255, 255)
	dot.BackgroundTransparency = math.random(20, 65) / 100
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	dot.Parent = screenGui
	return {
		dot = dot,
		x = math.random(0, sw),
		y = math.random(-sh, sh),
		speedY = math.random(40, 120),
		speedX = math.random(-8, 8),
		wobble = math.random() * math.pi * 2,
		wobbleSpeed = math.random(8, 16) / 10,
		wobbleAmp = sz > 3 and math.random(4, 14) or math.random(1, 5)
	}
end

for i = 1, particleCount do
	backgroundParticles[i] = createBackgroundParticle()
end

local lastParticleTick = tick()
RunService.RenderStepped:Connect(function()
	if not settings.guiOpen then
		return
	end
	local now = tick()
	local dt = math.min(now - lastParticleTick, 0.05)
	lastParticleTick = now
	local sw = screenGui.AbsoluteSize.X
	local sh = screenGui.AbsoluteSize.Y
	for _, p in ipairs(backgroundParticles) do
		p.wobble = p.wobble + p.wobbleSpeed * dt
		p.x = p.x + p.speedX * dt + math.sin(p.wobble) * p.wobbleAmp * dt
		p.y = p.y + p.speedY * dt
		if p.y > sh + 4 then
			p.y = -4
			p.x = math.random(0, sw)
			p.speedY = math.random(10, 34)
			p.speedX = math.random(-5, 5)
			p.wobbleAmp = math.random(2, 9)
		end
		if p.x > sw + 4 then
			p.x = -4
		end
		if p.x < -4 then
			p.x = sw + 4
		end
		p.dot.Position = UDim2.new(0, p.x, 0, p.y)
	end
end)

local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = colors.titleBg
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 15
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)
local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1, 0, 0, 8)
titleFix.Position = UDim2.new(0, 0, 1, -8)
titleFix.BackgroundColor3 = colors.titleBg
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 15
local titleStroke = Instance.new("UIStroke", titleBar)
titleStroke.Color = colors.borderDim
titleStroke.Thickness = 1

local logoDot = Instance.new("Frame", titleBar)
logoDot.Size = UDim2.new(0, 7, 0, 7)
logoDot.Position = UDim2.new(0, 12, 0.5, -3.5)
logoDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
logoDot.BorderSizePixel = 0
logoDot.ZIndex = 16
Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1, 0)

local watermark = Instance.new("TextLabel", titleBar)
watermark.Size = UDim2.new(0, 200, 1, 0)
watermark.Position = UDim2.new(0, 26, 0, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "Milkyway"
watermark.TextColor3 = colors.text
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 11
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.ZIndex = 16

local watermark2 = Instance.new("TextLabel", titleBar)
watermark2.Size = UDim2.new(0, 300, 1, 0)
watermark2.Position = UDim2.new(0, 108, 0, 0)
watermark2.BackgroundTransparency = 1
watermark2.Text = "/// for Da Hood"
watermark2.TextColor3 = colors.textMuted
watermark2.Font = Enum.Font.Code
watermark2.TextSize = 10
watermark2.TextXAlignment = Enum.TextXAlignment.Left
watermark2.ZIndex = 16

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 22, 0, 18)
closeButton.Position = UDim2.new(1, -26, 0.5, -9)
closeButton.BackgroundTransparency = 1
closeButton.Text = "✕"
closeButton.TextColor3 = colors.textDim
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 13
closeButton.ZIndex = 20
closeButton.MouseEnter:Connect(function()
	closeButton.TextColor3 = colors.text
end)
closeButton.MouseLeave:Connect(function()
	closeButton.TextColor3 = colors.textDim
end)

local tabBar = Instance.new("Frame", win)
tabBar.Size = UDim2.new(1, 0, 0, 28)
tabBar.Position = UDim2.new(0, 0, 0, 30)
tabBar.BackgroundColor3 = colors.titleBg
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 14

local tabDivider = Instance.new("Frame", win)
tabDivider.Size = UDim2.new(1, 0, 0, 1)
tabDivider.Position = UDim2.new(0, 0, 0, 58)
tabDivider.BackgroundColor3 = colors.border
tabDivider.BorderSizePixel = 0
tabDivider.ZIndex = 14

local tabNames = { "Aimbot", "Visuals", "World", "Movement", "Players", "Settings" }
local tabButtons = {}
local tabFrames = {}
local currentTabName = "Aimbot"

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 0)

local function selectTab(name)
	currentTabName = name
	for _, n in ipairs(tabNames) do
		local btn = tabButtons[n]
		local frm = tabFrames[n]
		local isActive = (n == name)
		if btn then
			btn.TextColor3 = isActive and colors.accent or colors.tabDim
			btn.BackgroundColor3 = isActive and colors.tabSel or colors.tabUnsel
			local indicator = btn:FindFirstChild("Indicator")
			if indicator then
				indicator.Visible = isActive
			end
		end
		if frm then
			frm.Visible = isActive
		end
	end
end

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.new(1 / #tabNames, 0, 1, 0)
	btn.BackgroundColor3 = colors.tabUnsel
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = colors.tabDim
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.ZIndex = 15
	btn.LayoutOrder = i
	btn.MouseButton1Click:Connect(function()
		selectTab(name)
	end)

	local indicator = Instance.new("Frame", btn)
	indicator.Name = "Indicator"
	indicator.Size = UDim2.new(0.6, 0, 0, 2)
	indicator.Position = UDim2.new(0.2, 0, 1, -2)
	indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	indicator.BorderSizePixel = 0
	indicator.ZIndex = 16
	indicator.Visible = false
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

	if i < #tabNames then
		local separator = Instance.new("Frame", btn)
		separator.Size = UDim2.new(0, 1, 0.6, 0)
		separator.Position = UDim2.new(1, -1, 0.2, 0)
		separator.BackgroundColor3 = colors.borderDim
		separator.BorderSizePixel = 0
		separator.ZIndex = 16
	end

	tabButtons[name] = btn

	local frm = Instance.new("Frame", win)
	frm.Size = UDim2.new(1, 0, 1, -59)
	frm.Position = UDim2.new(0, 0, 0, 59)
	frm.BackgroundTransparency = 1
	frm.ZIndex = 12
	frm.Visible = (name == "Aimbot")
	tabFrames[name] = frm
end

local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.new(0, 90, 0, 24)
reopenButton.Position = UDim2.new(0, 8, 0, 8)
reopenButton.BackgroundColor3 = colors.panel
reopenButton.BorderSizePixel = 0
reopenButton.Text = "Open Menu"
reopenButton.TextColor3 = colors.textDim
reopenButton.Font = Enum.Font.GothamBold
reopenButton.TextSize = 10
reopenButton.ZIndex = 50
reopenButton.Visible = false
reopenButton.Parent = screenGui
Instance.new("UICorner", reopenButton).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", reopenButton).Color = colors.border

local function setGuiOpen(open)
	settings.guiOpen = open
	win.Visible = open
	reopenButton.Visible = not open
	setBlur(open)
	for _, p in ipairs(backgroundParticles) do
		p.dot.Visible = open
	end
end

closeButton.MouseButton1Click:Connect(function()
	setGuiOpen(false)
end)
reopenButton.MouseButton1Click:Connect(function()
	setGuiOpen(true)
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if input.KeyCode == settings.toggleKey then
		setGuiOpen(not settings.guiOpen)
	end
end)

local TOGGLE_WIDTH = 36
local THUMB_PADDING_X = 2
local THUMB_PADDING_Y = 2
local THUMB_SIZE = THUMB_PADDING_X - THUMB_PADDING_Y * 2

local function createColumns(parent)
	local leftColumn = Instance.new("ScrollingFrame", parent)
	leftColumn.Size = UDim2.new(0.5, -1, 1, 0)
	leftColumn.BackgroundColor3 = colors.panel
	leftColumn.BorderSizePixel = 0
	leftColumn.ScrollBarThickness = 2
	leftColumn.ScrollBarImageColor3 = colors.textMuted
	leftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
	leftColumn.ScrollingDirection = Enum.ScrollingDirection.Y
	leftColumn.ZIndex = 13

	local leftLayout = Instance.new("UIListLayout", leftColumn)
	leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	leftLayout.Padding = UDim.new(0, 0)
	leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y)
	end)

	local divider = Instance.new("Frame", parent)
	divider.Size = UDim2.new(0, 1, 1, 0)
	divider.Position = UDim2.new(0.5, -1, 0, 0)
	divider.BackgroundColor3 = colors.border
	divider.BorderSizePixel = 0
	divider.ZIndex = 13

	local rightColumn = Instance.new("ScrollingFrame", parent)
	rightColumn.Size = UDim2.new(0.5, 0, 1, 0)
	rightColumn.Position = UDim2.new(0.5, 0, 0, 0)
	rightColumn.BackgroundColor3 = colors.panel
	rightColumn.BorderSizePixel = 0
	rightColumn.ScrollBarThickness = 2
	rightColumn.ScrollBarImageColor3 = colors.textMuted
	rightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
	rightColumn.ScrollingDirection = Enum.ScrollingDirection.Y
	rightColumn.ZIndex = 13

	local rightLayout = Instance.new("UIListLayout", rightColumn)
	rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rightLayout.Padding = UDim.new(0, 0)
	rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y)
	end)

	return leftColumn, rightColumn
end

local function createSingleColumn(parent)
	local scrollFrame = Instance.new("ScrollingFrame", parent)
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.BackgroundColor3 = colors.panel
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 2
	scrollFrame.ScrollBarImageColor3 = colors.textMuted
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollFrame.ZIndex = 13

	local listLayout = Instance.new("UIListLayout", scrollFrame)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 0)
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
	end)

	return scrollFrame
end

local function createSectionHeader(parent, text, order)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 22)
	row.BackgroundColor3 = colors.sectionBg
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.LayoutOrder = order or 0

	local accent = Instance.new("Frame", row)
	accent.Size = UDim2.new(0, 2, 0, 10)
	accent.Position = UDim2.new(0, 8, 0.5, -5)
	accent.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
	accent.BorderSizePixel = 0
	accent.ZIndex = 14
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1, -22, 1, 0)
	label.Position = UDim2.new(0, 16, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text:upper()
	label.TextColor3 = Color3.fromRGB(140, 140, 140)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 9
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 14

	local line = Instance.new("Frame", row)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = colors.borderDim
	line.BorderSizePixel = 0
	line.ZIndex = 14

	return row
end

getgenv().is_firing = false
local rapidFireConnections = {}

local function disconnectRapidFire()
	for _, c in ipairs(rapidFireConnections) do
		pcall(function()
			c:Disconnect()
		end)
	end
	rapidFireConnections = {}
end

local function toggleRapidFireListener(on)
	disconnectRapidFire()
	if not on then
		getgenv().is_firing = false
		return
	end
	local c1 = UserInputService.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			local char = getLocalCharacter()
			if not char then
				return
			end
			local gun
			for _, tool in next, char:GetChildren() do
				if tool:IsA("Tool") and tool:FindFirstChild("Shoot") then
					gun = tool
					break
				end
			end
			if settings.rapidFire and gun and not getgenv().is_firing then
				getgenv().is_firing = true
				while getgenv().is_firing do
					pcall(function()
						gun:Activate()
					end)
					task.wait(0.0001)
				end
			end
		end
	end)
	local c2 = UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			getgenv().is_firing = false
		end
	end)
	table.insert(rapidFireConnections, c1)
	table.insert(rapidFireConnections, c2)
end

local function createToggle(parent, label, default, onChange, order)
	local ROW_HEIGHT = 28
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
	row.BackgroundColor3 = colors.panel
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.LayoutOrder = order or 0

	local line = Instance.new("Frame", row)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = colors.borderDim
	line.BorderSizePixel = 0
	line.ZIndex = 14

	local labelText = Instance.new("TextLabel", row)
	labelText.Size = UDim2.new(1, -(TOGGLE_WIDTH + 20), 1, 0)
	labelText.Position = UDim2.new(0, 12, 0, 0)
	labelText.BackgroundTransparency = 1
	labelText.Text = label
	labelText.TextColor3 = default and colors.text or colors.textDim
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 11
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.ZIndex = 14

	local track = Instance.new("Frame", row)
	track.Size = UDim2.new(0, TOGGLE_WIDTH, 0, THUMB_PADDING_X)
	track.Position = UDim2.new(1, -(TOGGLE_WIDTH + 10), 0.5, -THUMB_PADDING_X / 2)
	track.BackgroundColor3 = default and colors.toggleOn or colors.toggleOff
	track.BorderSizePixel = 0
	track.ZIndex = 15
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local thumb = Instance.new("Frame", track)
	thumb.Size = UDim2.new(0, THUMB_SIZE, 0, THUMB_SIZE)
	thumb.Position = default and UDim2.new(1, -(THUMB_SIZE + THUMB_PADDING_Y), 0.5, -THUMB_SIZE / 2) or UDim2.new(0, THUMB_PADDING_Y, 0.5, -THUMB_SIZE / 2)
	thumb.BackgroundColor3 = colors.toggleThumb
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 16
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

	local isEnabled = default or false
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function updateToggle(value)
		isEnabled = value
		TweenService:Create(track, tweenInfo, { BackgroundColor3 = value and colors.toggleOn or colors.toggleOff }):Play()
		TweenService:Create(thumb, tweenInfo, { Position = value and UDim2.new(1, -(THUMB_SIZE + THUMB_PADDING_Y), 0.5, -THUMB_SIZE / 2) or UDim2.new(0, THUMB_PADDING_Y, 0.5, -THUMB_SIZE / 2) }):Play()
		labelText.TextColor3 = value and colors.text or colors.textDim
		if onChange then
			onChange(value)
		end
	end

	local button = Instance.new("TextButton", row)
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.ZIndex = 17
	button.MouseEnter:Connect(function()
		row.BackgroundColor3 = colors.panelHover
	end)
	button.MouseLeave:Connect(function()
		row.BackgroundColor3 = colors.panel
	end)
	button.MouseButton1Click:Connect(function()
		updateToggle(not isEnabled)
	end)
	return row, function()
		return isEnabled
	end
end

local function createSlider(parent, label, min, max, default, onChange, order)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = colors.panel
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.LayoutOrder = order or 0

	local line = Instance.new("Frame", row)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = colors.borderDim
	line.BorderSizePixel = 0
	line.ZIndex = 14

	local labelText = Instance.new("TextLabel", row)
	labelText.Size = UDim2.new(0.65, 0, 0, 16)
	labelText.Position = UDim2.new(0, 12, 0, 5)
	labelText.BackgroundTransparency = 1
	labelText.Text = label
	labelText.TextColor3 = colors.textDim
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 10
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.ZIndex = 14

	local valueBackground = Instance.new("Frame", row)
	valueBackground.Size = UDim2.new(0, 36, 0, 14)
	valueBackground.Position = UDim2.new(1, -46, 0, 5)
	valueBackground.BackgroundColor3 = colors.panelAlt
	valueBackground.BorderSizePixel = 0
	valueBackground.ZIndex = 14
	Instance.new("UICorner", valueBackground).CornerRadius = UDim.new(0, 3)

	local valueLabel = Instance.new("TextLabel", valueBackground)
	valueLabel.Size = UDim2.new(1, 0, 1, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(default)
	valueLabel.TextColor3 = colors.text
	valueLabel.Font = Enum.Font.Code
	valueLabel.TextSize = 9
	valueLabel.ZIndex = 15

	local track = Instance.new("Frame", row)
	track.Size = UDim2.new(1, -24, 0, 4)
	track.Position = UDim2.new(0, 12, 0, 26)
	track.BackgroundColor3 = colors.sliderBg
	track.BorderSizePixel = 0
	track.ZIndex = 14
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local ratio = (default - min) / (max - min)
	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.new(ratio, 0, 1, 0)
	fill.BackgroundColor3 = colors.sliderFill
	fill.BorderSizePixel = 0
	fill.ZIndex = 15
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	local thumb = Instance.new("Frame", track)
	thumb.Size = UDim2.new(0, 10, 0, 10)
	thumb.AnchorPoint = Vector2.new(0.5, 0.5)
	thumb.Position = UDim2.new(ratio, 0, 0.5, 0)
	thumb.BackgroundColor3 = colors.white
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 16
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

	local hitbox = Instance.new("TextButton", track)
	hitbox.Size = UDim2.new(1, 0, 0, 22)
	hitbox.Position = UDim2.new(0, 0, 0.5, -11)
	hitbox.BackgroundTransparency = 1
	hitbox.Text = ""
	hitbox.ZIndex = 17

	local value = default
	local isDragging = false
	hitbox.MouseButton1Down:Connect(function()
		isDragging = true
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)

	RunService.RenderStepped:Connect(function()
		if not isDragging then
			return
		end
		local mouse = player:GetMouse()
		local t = math.clamp((mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		value = math.floor(min + t * (max - min))
		fill.Size = UDim2.new(t, 0, 1, 0)
		thumb.Position = UDim2.new(t, 0, 0.5, 0)
		valueLabel.Text = tostring(value)
		if onChange then
			onChange(value)
		end
	end)

	return row
end

local function createDropdown(parent, label, options, default, onChange, order)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 28)
	row.BackgroundColor3 = colors.panel
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.LayoutOrder = order or 0

	local line = Instance.new("Frame", row)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = colors.borderDim
	line.BorderSizePixel = 0
	line.ZIndex = 14

	local labelText = Instance.new("TextLabel", row)
	labelText.Size = UDim2.new(0.52, 0, 1, 0)
	labelText.Position = UDim2.new(0, 12, 0, 0)
	labelText.BackgroundTransparency = 1
	labelText.Text = label
	labelText.TextColor3 = colors.textDim
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 11
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.ZIndex = 14

	local valuePill = Instance.new("Frame", row)
	valuePill.Size = UDim2.new(0, 80, 0, 18)
	valuePill.Position = UDim2.new(1, -100, 0.5, -9)
	valuePill.BackgroundColor3 = colors.panelAlt
	valuePill.BorderSizePixel = 0
	valuePill.ZIndex = 14
	Instance.new("UICorner", valuePill).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", valuePill).Color = colors.borderDim

	local valueLabel = Instance.new("TextLabel", valuePill)
	valueLabel.Size = UDim2.new(1, -20, 1, 0)
	valueLabel.Position = UDim2.new(0, 6, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = options[default or 1]
	valueLabel.TextColor3 = colors.text
	valueLabel.Font = Enum.Font.Code
	valueLabel.TextSize = 10
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.ZIndex = 15

	local arrow = Instance.new("TextLabel", valuePill)
	arrow.Size = UDim2.new(0, 16, 1, 0)
	arrow.Position = UDim2.new(1, -18, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "›"
	arrow.TextColor3 = colors.textMuted
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 13
	arrow.ZIndex = 15

	local idx = default or 1
	local button = Instance.new("TextButton", row)
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.ZIndex = 16
	button.MouseEnter:Connect(function()
		row.BackgroundColor3 = colors.panelHover
	end)
	button.MouseLeave:Connect(function()
		row.BackgroundColor3 = colors.panel
	end)
	button.MouseButton1Click:Connect(function()
		idx = idx % #options + 1
		valueLabel.Text = options[idx]
		if onChange then
			onChange(options[idx], idx)
		end
	end)

	return row
end

local function createKeybind(parent, label, default, onChange, order)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 28)
	row.BackgroundColor3 = colors.panel
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.LayoutOrder = order or 0

	local line = Instance.new("Frame", row)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = colors.borderDim
	line.BorderSizePixel = 0
	line.ZIndex = 14

	local labelText = Instance.new("TextLabel", row)
	labelText.Size = UDim2.new(0.55, 0, 1, 0)
	labelText.Position = UDim2.new(0, 12, 0, 0)
	labelText.BackgroundTransparency = 1
	labelText.Text = label
	labelText.TextColor3 = colors.textDim
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 11
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.ZIndex = 14

	local keyPill = Instance.new("TextButton", row)
	keyPill.Size = UDim2.new(0, 56, 0, 16)
	keyPill.Position = UDim2.new(1, -66, 0.5, -8)
	keyPill.BackgroundColor3 = colors.panelAlt
	keyPill.BorderSizePixel = 0
	keyPill.Text = default or "none"
	keyPill.TextColor3 = colors.text
	keyPill.Font = Enum.Font.Code
	keyPill.TextSize = 9
	keyPill.ZIndex = 15
	Instance.new("UICorner", keyPill).CornerRadius = UDim.new(0, 3)
	Instance.new("UIStroke", keyPill).Color = colors.border

	local isBinding = false
	keyPill.MouseButton1Click:Connect(function()
		if isBinding then
			return
		end
		isBinding = true
		keyPill.Text = "..."
		keyPill.TextColor3 = colors.textMuted
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end
			conn:Disconnect()
			isBinding = false
			keyPill.Text = input.KeyCode.Name
			keyPill.TextColor3 = colors.text
			if onChange then
				onChange(input.KeyCode)
			end
		end)
	end)

	return row
end

local infoName, infoDist, infoHp, infoTeam, infoFov, infoLock
do
	local left, right = createColumns(tabFrames["Aimbot"])
	local leftOrder, rightOrder = 0, 0
	local function nextLeftOrder()
		leftOrder = leftOrder + 1
		return leftOrder
	end
	local function nextRightOrder()
		rightOrder = rightOrder + 1
		return rightOrder
	end

	createSectionHeader(left, "Aimbot", nextLeftOrder())
	createToggle(left, "Aimbot", false, function(value)
		settings.aimbot = value
	end, nextLeftOrder())
	createToggle(left, "Sticky Aim", false, function(value)
		settings.stickyAim = value
		if not value then
			settings.stickyTarget = nil
		end
	end, nextLeftOrder())
	createKeybind(left, "Sticky Key", "E", function(keyCode)
		settings.stickyKey = keyCode
	end, nextLeftOrder())
	createDropdown(left, "Aimbot Part", { "Head", "UpperTorso", "HumanoidRootPart" }, 1, function(value)
		settings.aimPart = value
	end, nextLeftOrder())
	createDropdown(left, "Method", { "Camera", "Mouse" }, 1, function() end, nextLeftOrder())
	createDropdown(left, "Aim-At", { "Head", "Body", "HumanoidRootPart" }, 1, function(value)
		settings.aimPart = value
	end, nextLeftOrder())
	createDropdown(left, "Aim-Sort", { "Head", "HumanoidRootPart" }, 1, function() end, nextLeftOrder())

	createSectionHeader(left, "FOV", nextLeftOrder())
	createToggle(left, "Show FOV", false, function(value)
		settings.showFov = value
	end, nextLeftOrder())
	createToggle(left, "Dynamic", false, function() end, nextLeftOrder())
	createToggle(left, "Silent", false, function() end, nextLeftOrder())
	createSlider(left, "FOV Size", 10, 400, 50, function(value)
		settings.aimFov = value
	end, nextLeftOrder())
	createSlider(left, "Dynamic Speed", 0, 10, 1, function() end, nextLeftOrder())
	createSlider(left, "Dynamic Amount", 0, 10, 1, function() end, nextLeftOrder())
	createSlider(left, "Silent", 0, 10, 1, function() end, nextLeftOrder())
	createDropdown(left, "Shape", { "Circle", "Square", "Triangle" }, 1, function() end, nextLeftOrder())

	createSectionHeader(right, "Smoothing", nextRightOrder())
	createSlider(right, "Smoothing", 1, 30, 8, function(value)
		settings.aimSmooth = value
	end, nextRightOrder())
	createSlider(right, "Prediction", 1, 10, 5, function() end, nextRightOrder())
	createSlider(right, "Prediction", 1, 10, 5, function() end, nextRightOrder())

	createSectionHeader(right, "Prediction", nextRightOrder())
	createSlider(right, "Prediction", 1, 10, 5, function() end, nextRightOrder())
	createSlider(right, "Prediction", 1, 10, 5, function() end, nextRightOrder())
	createDropdown(right, "Prediction - Type", { "None", "Linear", "Advanced" }, 1, function() end, nextRightOrder())
	createToggle(right, "Team Check", false, function(value)
		settings.teamCheck = value
	end, nextRightOrder())
	createToggle(right, "Ignore Knocked", false, function(value)
		settings.ignoreKnocked = value
	end, nextRightOrder())
	createToggle(right, "Wall Check", true, function(value)
		settings.wallCheck = value
	end, nextRightOrder())
	createToggle(right, "Use Max Distance", false, function(value)
		settings.useMaxDist = value
	end, nextRightOrder())
	createDropdown(right, "Trigger - Type", { "None", "Always", "ADS" }, 1, function(value)
		settings.triggerBot = value
	end, nextRightOrder())
	createSlider(right, "Trigger - Delay (ms)", 0, 500, 0, function(value)
		settings.triggerDelay = value
	end, nextRightOrder())

	createSectionHeader(right, "Aim Assist", nextRightOrder())
	createToggle(right, "Enable Lockon", false, function(value)
		settings.lockEnabled = value
		if not value then
			settings.lockTarget = nil
		end
	end, nextRightOrder())
	createToggle(right, "Hold", false, function(value)
		settings.lockHold = value
	end, nextRightOrder())
	createKeybind(right, "Lockon Key", "CapsLock", function(keyCode)
		settings.lockKey = keyCode
	end, nextRightOrder())
	createToggle(right, "Team - Team Check", false, function(value)
		settings.lockTeamCheck = value
	end, nextRightOrder())
	createToggle(right, "Wall - Wall Check", true, function(value)
		settings.lockWallCheck = value
	end, nextRightOrder())
	createDropdown(right, "Lockon Part", { "Head", "UpperTorso", "HumanoidRootPart" }, 1, function(value)
		settings.lockPart = value
	end, nextRightOrder())
	createSlider(right, "Lockon FOV", 10, 400, 150, function(value)
		settings.lockFov = value
	end, nextRightOrder())

	createSectionHeader(right, "Target Info", nextRightOrder())
	local function createInfoRow(parent, label, order)
		local row = Instance.new("Frame", parent)
		row.Size = UDim2.new(1, 0, 0, 20)
		row.BackgroundColor3 = colors.panel
		row.BorderSizePixel = 0
		row.ZIndex = 13
		row.LayoutOrder = order
		local line = Instance.new("Frame", row)
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Position = UDim2.new(0, 0, 1, -1)
		line.BackgroundColor3 = colors.borderDim
		line.BorderSizePixel = 0
		line.ZIndex = 14
		local labelText = Instance.new("TextLabel", row)
		labelText.Size = UDim2.new(0.5, 0, 1, 0)
		labelText.Position = UDim2.new(0, 12, 0, 0)
		labelText.BackgroundTransparency = 1
		labelText.Text = label
		labelText.TextColor3 = colors.textMuted
		labelText.Font = Enum.Font.Gotham
		labelText.TextSize = 10
		labelText.TextXAlignment = Enum.TextXAlignment.Left
		labelText.ZIndex = 14
		local valueText = Instance.new("TextLabel", row)
		valueText.Size = UDim2.new(0.5, -8, 1, 0)
		valueText.Position = UDim2.new(0.5, 0, 0, 0)
		valueText.BackgroundTransparency = 1
		valueText.Text = "—"
		valueText.TextColor3 = colors.text
		valueText.Font = Enum.Font.Code
		valueText.TextSize = 10
		valueText.TextXAlignment = Enum.TextXAlignment.Right
		valueText.ZIndex = 14
		return valueText
	end
	infoName = createInfoRow(right, "Name", nextRightOrder())
	infoDist = createInfoRow(right, "Distance", nextRightOrder())
	infoHp = createInfoRow(right, "Health", nextRightOrder())
	infoTeam = createInfoRow(right, "Team", nextRightOrder())
	infoFov = createInfoRow(right, "FOV", nextRightOrder())
	infoLock = createInfoRow(right, "Status", nextRightOrder())
end

do
	local left, right = createColumns(tabFrames["Visuals"])
	local leftOrder, rightOrder = 0, 0
	local function nextLeftOrder()
		leftOrder = leftOrder + 1
		return leftOrder
	end
	local function nextRightOrder()
		rightOrder = rightOrder + 1
		return rightOrder
	end
	createSectionHeader(left, "Silent Aim", nextLeftOrder())
	createToggle(left, "Silent Aim", false, function(value)
		settings.silentAim = value
	end, nextLeftOrder())
	createToggle(left, "Velocity Prediction", false, function(value)
		settings.velPred = value
	end, nextLeftOrder())
	createToggle(left, "Gravity Compensation", false, function(value)
		settings.gravComp = value
	end, nextLeftOrder())
	createSlider(left, "Prediction Steps", 1, 10, 5, function(value)
		settings.predSteps = value
	end, nextLeftOrder())
	createToggle(left, "Ignore knocked", false, function(value)
		settings.ignoreKnocked = value
	end, nextLeftOrder())
	createToggle(left, "Ignore far targets", false, function(value)
		settings.ignoreFar = value
	end, nextLeftOrder())
	createToggle(left, "Closest to FOV", true, function(value)
		settings.closestFov = value
	end, nextLeftOrder())

	createSectionHeader(right, "Checks", nextRightOrder())
	createToggle(right, "Team Check", false, function(value)
		settings.teamCheck = value
	end, nextRightOrder())
	createToggle(right, "Wall Check", true, function(value)
		settings.wallCheck = value
	end, nextRightOrder())
	createToggle(right, "Use Max Distance", false, function(value)
		settings.useMaxDist = value
	end, nextRightOrder())
	createSlider(right, "Max Distance", 50, 1000, 300, function(value)
		settings.maxDist = value
	end, nextRightOrder())
	createToggle(right, "Highlight Target", false, function(value)
		settings.targetHighlight = value
	end, nextRightOrder())
	createDropdown(right, "Target Part", { "Head", "UpperTorso", "HumanoidRootPart" }, 1, function(value)
		settings.aimPart = value
	end, nextRightOrder())
end

do
	local left, right = createColumns(tabFrames["World"])
	local leftOrder, rightOrder = 0, 0
	local function nextLeftOrder()
		leftOrder = leftOrder + 1
		return leftOrder
	end
	local function nextRightOrder()
		rightOrder = rightOrder + 1
		return rightOrder
	end
	createSectionHeader(left, "ESP", nextLeftOrder())
	createToggle(left, "Enable ESP", false, function(value)
		settings.espEnabled = value
	end, nextLeftOrder())
	createToggle(left, "Boxes", false, function(value)
		settings.espBoxes = value
	end, nextLeftOrder())
	createDropdown(left, "Box Color", { "White", "Green", "Red", "Blue" }, 1, function(value)
		local colorMap = {
			White = Color3.fromRGB(220, 220, 220),
			Green = Color3.fromRGB(130, 200, 130),
			Red = Color3.fromRGB(200, 80, 80),
			Blue = Color3.fromRGB(80, 130, 200)
		}
		settings.espBoxColor = colorMap[value] or settings.espBoxColor
	end, nextLeftOrder())
	createDropdown(left, "Box Style", { "Full", "Corners", "3D" }, 1, function(value)
		settings.espBoxStyle = value:lower()
	end, nextLeftOrder())
	createSlider(left, "Box Opacity", 0, 100, 80, function(value)
		settings.espBoxOpacity = value / 100
	end, nextLeftOrder())
	createToggle(left, "Names", false, function(value)
		settings.espNames = value
	end, nextLeftOrder())
	createToggle(left, "Health Bar", false, function(value)
		settings.espHealthBar = value
	end, nextLeftOrder())
	createToggle(left, "Distance", false, function(value)
		settings.espDistance = value
	end, nextLeftOrder())
	createToggle(left, "Tracers", false, function(value)
		settings.espTracer = value
	end, nextLeftOrder())
	createSlider(left, "Max Distance", 50, 1000, 300, function(value)
		settings.espMaxDist = value
	end, nextLeftOrder())

	createSectionHeader(right, "Extra", nextRightOrder())
	createToggle(right, "Chams", false, function(value)
		settings.espChams = value
	end, nextRightOrder())
	createToggle(right, "Highlight (Glow)", false, function(value)
		settings.espGlow = value
	end, nextRightOrder())
	createToggle(right, "Snap Lines", false, function(value)
		settings.espSnapLines = value
	end, nextRightOrder())

	createSectionHeader(right, "World Visuals", nextRightOrder())
	createToggle(right, "Speed Lines", false, function(value)
		settings.speedLines = value
	end, nextRightOrder())
	createToggle(right, "Velocity Display", false, function(value)
		settings.velDisplay = value
	end, nextRightOrder())
	createToggle(right, "Speed Ring", false, function(value)
		settings.speedRing = value
	end, nextRightOrder())
	createToggle(right, "Show FOV Circle", false, function(value)
		settings.showFov = value
	end, nextRightOrder())
	createToggle(right, "Snapline", false, function(value)
		settings.tracer = value
	end, nextRightOrder())

	createSectionHeader(right, "Radar", nextRightOrder())
	createToggle(right, "Radar", false, function(value)
		settings.radarEnabled = value
	end, nextRightOrder())
	createSlider(right, "Radar Range", 50, 500, 150, function(value)
		settings.radarRange = value
	end, nextRightOrder())
end

do
	local left, right = createColumns(tabFrames["Movement"])
	local leftOrder, rightOrder = 0, 0
	local function nextLeftOrder()
		leftOrder = leftOrder + 1
		return leftOrder
	end
	local function nextRightOrder()
		rightOrder = rightOrder + 1
		return rightOrder
	end
	createSectionHeader(left, "Movement", nextLeftOrder())
	createToggle(left, "Speed", false, function(value)
		settings.speedEnabled = value
		if not value then
			settings.speedHack = false
			local h = getLocalHumanoid()
			if h then
				h.WalkSpeed = settings.walkSpeed
			end
		end
	end, nextLeftOrder())
	createKeybind(left, "Speed Key", "X", function(keyCode)
		settings.speedKey = keyCode
	end, nextLeftOrder())
	createToggle(left, "Auto Sprint", false, function(value)
		settings.autoSprint = value
	end, nextLeftOrder())
	createToggle(left, "No Slow", false, function(value)
		settings.noSlow = value
	end, nextLeftOrder())
	createToggle(left, "Bhop", false, function(value)
		settings.bhop = value
	end, nextLeftOrder())
	createToggle(left, "Fly", false, function(value)
		settings.flyEnabled = value
		if not value then
			settings.fly = false
		end
	end, nextLeftOrder())
	createKeybind(left, "Fly Key", "V", function(keyCode)
		settings.flyKey = keyCode
	end, nextLeftOrder())
	createToggle(left, "Noclip", false, function(value)
		settings.noclip = value
		if not value then
			local c = getLocalCharacter()
			if c then
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") then
						p.CanCollide = true
					end
				end
			end
		end
	end, nextLeftOrder())

	createSectionHeader(left, "Values", nextLeftOrder())
	createSlider(left, "Max Speed", 16, 500, 325, function(value)
		settings.maxSpeed = value
	end, nextLeftOrder())
	createSlider(left, "Walkspeed", 0, 100, 16, function(value)
		settings.walkSpeed = value
		local h = getLocalHumanoid()
		if h and not settings.speedHack then
			h.WalkSpeed = value
		end
	end, nextLeftOrder())
	createSlider(left, "Fly Speed", 10, 300, 50, function(value)
		settings.flySpeed = value
	end, nextLeftOrder())
	createSlider(left, "Jump Power", 0, 300, 50, function(value)
		settings.jumpPower = value
		local h = getLocalHumanoid()
		if h then
			h.JumpPower = value
		end
	end, nextLeftOrder())
	createToggle(left, "High Jump", false, function(value)
		settings.highJump = value
		if not value then
			local h = getLocalHumanoid()
			if h then
				h.JumpPower = settings.jumpPower
			end
		end
	end, nextLeftOrder())
	createKeybind(left, "High Jump Key", "H", function(keyCode)
		settings.highJumpKey = keyCode
	end, nextLeftOrder())
	createSlider(left, "High Jump Power", 50, 1000, 150, function(value)
		settings.highJumpPower = value
	end, nextLeftOrder())
	createSlider(left, "Fling Range", 5, 200, 50, function(value)
		settings.flingRange = value
	end, nextLeftOrder())

	createSectionHeader(right, "Misc", nextRightOrder())
	createToggle(right, "Anti-Ragdoll", false, function(value)
		settings.antiRagdoll = value
	end, nextRightOrder())
	createToggle(right, "Infinite Jump?", false, function(value)
		settings.netDesync = value
	end, nextRightOrder())
	createToggle(right, "Velocity Desync?", false, function(value)
		settings.velDesync = value
	end, nextRightOrder())
	createToggle(right, "Fake Position", false, function(value)
		settings.fakePos = value
	end, nextRightOrder())
	createToggle(right, "Void Hide", false, function(value)
		settings.voidHide = value
		if value then
			local root = getLocalRootPart()
			if root then
				settings.voidSavedCFrame = root.CFrame
			end
		else
			local root = getLocalRootPart()
			if root and settings.voidSavedCFrame then
				root.CFrame = settings.voidSavedCFrame
			end
		end
	end, nextRightOrder())
end

do
	local left, right = createColumns(tabFrames["Players"])
	local leftOrder, rightOrder = 0, 0
	local function nextLeftOrder()
		leftOrder = leftOrder + 1
		return leftOrder
	end
	local function nextRightOrder()
		rightOrder = rightOrder + 1
		return rightOrder
	end

	createSectionHeader(left, "Exploits", nextLeftOrder())
	createToggle(left, "Hitbox Expander", false, function(value)
		settings.hitboxExpand = value
		if not value then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player then
					local box = workspace.CurrentCamera:FindFirstChild("HitboxPart_" .. p.UserId)
					if box then
						box:Destroy()
					end
					if p.Character then
						local r = p.Character:FindFirstChild("HumanoidRootPart")
						if r then
							r.Size = Vector3.new(2, 2, 1)
						end
					end
				end
			end
		end
	end, nextLeftOrder())
	createSlider(left, "Hitbox Size", 1, 20, 5, function(value)
		settings.hitboxSize = value
	end, nextLeftOrder())

	createSectionHeader(left, "Automation", nextLeftOrder())
	createToggle(left, "Safe Zone", false, function(value)
		settings.safeZone = value
	end, nextLeftOrder())
	createToggle(left, "Auto Loadout", false, function(value)
		settings.autoLoadout = value
	end, nextLeftOrder())
	createToggle(left, "Follow Target", false, function(value)
		settings.followTarget = value
	end, nextLeftOrder())
	createToggle(left, "Auto Stomp", false, function(value)
		settings.autoStomp = value
	end, nextLeftOrder())
	createToggle(left, "Auto Ammo", false, function(value)
		settings.autoAmmo = value
	end, nextLeftOrder())
	createToggle(left, "Auto Armor", false, function(value)
		settings.autoArmor = value
	end, nextLeftOrder())

	createSectionHeader(left, "Auto Kill", nextLeftOrder())
	local akRow = Instance.new("Frame", left)
	akRow.Size = UDim2.new(1, 0, 0, 30)
	akRow.BackgroundColor3 = colors.panel
	akRow.BorderSizePixel = 0
	akRow.ZIndex = 13
	akRow.LayoutOrder = nextLeftOrder()
	local akLine = Instance.new("Frame", akRow)
	akLine.Size = UDim2.new(1, 0, 0, 1)
	akLine.Position = UDim2.new(0, 0, 1, -1)
	akLine.BackgroundColor3 = colors.borderDim
	akLine.BorderSizePixel = 0
	akLine.ZIndex = 14
	local akLabel = Instance.new("TextLabel", akRow)
	akLabel.Size = UDim2.new(0, 80, 1, 0)
	akLabel.Position = UDim2.new(0, 12, 0, 0)
	akLabel.BackgroundTransparency = 1
	akLabel.Text = "Username"
	akLabel.TextColor3 = colors.textDim
	akLabel.Font = Enum.Font.Gotham
	akLabel.TextSize = 10
	akLabel.TextXAlignment = Enum.TextXAlignment.Left
	akLabel.ZIndex = 14
	local akInput = Instance.new("TextBox", akRow)
	akInput.Size = UDim2.new(1, -92, 0, 20)
	akInput.Position = UDim2.new(0, 88, 0.5, -10)
	akInput.BackgroundColor3 = colors.panelAlt
	akInput.BorderSizePixel = 0
	akInput.Text = ""
	akInput.PlaceholderText = "Target Username..."
	akInput.PlaceholderColor3 = colors.textMuted
	akInput.TextColor3 = colors.text
	akInput.Font = Enum.Font.Code
	akInput.TextSize = 10
	akInput.ClearTextOnFocus = false
	akInput.ZIndex = 15
	Instance.new("UICorner", akInput).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", akInput).Color = colors.border
	akInput:GetPropertyChangedSignal("Text"):Connect(function()
		settings.autoKillTarget = akInput.Text
	end)
	createToggle(left, "Auto Kill Enabled", false, function(value)
		settings.autoKillEnabled = value
	end, nextLeftOrder())
	createToggle(left, "Auto Kill Stomp", true, function(value)
		settings.autoKillStomp = value
	end, nextLeftOrder())

	createSectionHeader(left, "Kill Aura", nextLeftOrder())
	createToggle(left, "Kill Aura", false, function(value)
		settings.killAura = value
	end, nextLeftOrder())
	createToggle(left, "Fly when enabled", false, function(value)
		settings.killAuraFly = value
	end, nextLeftOrder())
	createSlider(left, "Kill Aura Range", 1, 100, 30, function(value)
		settings.killAuraRange = value
	end, nextLeftOrder())
	local kaWlRow = Instance.new("Frame", left)
	kaWlRow.Size = UDim2.new(1, 0, 0, 30)
	kaWlRow.BackgroundColor3 = colors.panel
	kaWlRow.BorderSizePixel = 0
	kaWlRow.ZIndex = 13
	kaWlRow.LayoutOrder = nextLeftOrder()
	local kaWlLine = Instance.new("Frame", kaWlRow)
	kaWlLine.Size = UDim2.new(1, 0, 0, 1)
	kaWlLine.Position = UDim2.new(0, 0, 1, -1)
	kaWlLine.BackgroundColor3 = colors.borderDim
	kaWlLine.BorderSizePixel = 0
	kaWlLine.ZIndex = 14
	local kaWlLabel = Instance.new("TextLabel", kaWlRow)
	kaWlLabel.Size = UDim2.new(0, 70, 1, 0)
	kaWlLabel.Position = UDim2.new(0, 12, 0, 0)
	kaWlLabel.BackgroundTransparency = 1
	kaWlLabel.Text = "Whitelist"
	kaWlLabel.TextColor3 = colors.textDim
	kaWlLabel.Font = Enum.Font.Gotham
	kaWlLabel.TextSize = 10
	kaWlLabel.TextXAlignment = Enum.TextXAlignment.Left
	kaWlLabel.ZIndex = 14
	local kaWlInput = Instance.new("TextBox", kaWlRow)
	kaWlInput.Size = UDim2.new(1, -82, 0, 20)
	kaWlInput.Position = UDim2.new(0, 80, 0.5, -10)
	kaWlInput.BackgroundColor3 = colors.panelAlt
	kaWlInput.BorderSizePixel = 0
	kaWlInput.Text = ""
	kaWlInput.PlaceholderText = "User1, User2..."
	kaWlInput.PlaceholderColor3 = colors.textMuted
	kaWlInput.TextColor3 = colors.text
	kaWlInput.Font = Enum.Font.Code
	kaWlInput.TextSize = 10
	kaWlInput.ClearTextOnFocus = false
	kaWlInput.ZIndex = 15
	Instance.new("UICorner", kaWlInput).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", kaWlInput).Color = colors.border
	kaWlInput:GetPropertyChangedSignal("Text"):Connect(function()
		settings.killAuraWhitelist = {}
		for name in kaWlInput.Text:gmatch("([^,]+)") do
			local t = name:gsub("%s", ""):lower()
			if #t > 0 then
				settings.killAuraWhitelist[t] = true
			end
		end
	end)

	createSectionHeader(right, "Misc", nextRightOrder())
	createToggle(right, "Anti-Stomp", false, function(value)
		settings.antiStomp = value
	end, nextRightOrder())
	createToggle(right, "Auto Mask", false, function(value)
		settings.autoMask = value
	end, nextRightOrder())
	createToggle(right, "Auto Heal", false, function(value)
		settings.autoHeal = value
	end, nextRightOrder())
	createToggle(right, "Rapid Fire", false, function(value)
		settings.rapidFire = value
		local h = getLocalHumanoid()
		if h then
			h.ToolPunchCooldown = value and 0 or 0.1
		end
		toggleRapidFireListener(value)
	end, nextRightOrder())
	createToggle(right, "Auto Reload", false, function(value)
		settings.autoReload = value
	end, nextRightOrder())

	createSectionHeader(right, "Teleports", nextRightOrder())
	createToggle(right, "Teleport to target", false, function(value)
		settings.teleportToTarget = value
	end, nextRightOrder())
	createKeybind(right, "Teleport Key", "T", function(keyCode)
		settings.teleportKey = keyCode
	end, nextRightOrder())

	createSectionHeader(right, "Teleport to Player", nextRightOrder())
	createKeybind(right, "Tp to Player Key", "G", function(keyCode)
		settings.tpPlayerKey = keyCode
	end, nextRightOrder())

	createSectionHeader(right, "Orbit", nextRightOrder())
	createToggle(right, "Orbit", false, function(value)
		settings.orbitEnabled = value
		if not value then
			settings.orbitTarget = nil
		end
	end, nextRightOrder())
	createKeybind(right, "Orbit Key", "O", function(keyCode)
		settings.orbitKey = keyCode
	end, nextRightOrder())
	createSlider(right, "Orbit Radius", 2, 20, 6, function(value)
		settings.orbitRadius = value
	end, nextRightOrder())
	createSlider(right, "Orbit Speed", 1, 30, 8, function(value)
		settings.orbitSpeed = value
	end, nextRightOrder())

	local playerScroll = Instance.new("ScrollingFrame", right)
	playerScroll.Size = UDim2.new(1, 0, 0, 130)
	playerScroll.BackgroundColor3 = colors.panelAlt
	playerScroll.BorderSizePixel = 0
	playerScroll.ScrollBarThickness = 3
	playerScroll.ScrollBarImageColor3 = colors.textMuted
	playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	playerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
	playerScroll.ZIndex = 13
	playerScroll.LayoutOrder = nextRightOrder()
	playerScroll.ClipsDescendants = true
	playerScroll.Parent = right

	local playerListContainer = Instance.new("Frame", playerScroll)
	playerListContainer.Size = UDim2.new(1, 0, 0, 0)
	playerListContainer.BackgroundTransparency = 1
	playerListContainer.BorderSizePixel = 0
	playerListContainer.ZIndex = 13
	playerListContainer.ClipsDescendants = true

	local playerListLayout = Instance.new("UIListLayout", playerListContainer)
	playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	playerListLayout.Padding = UDim.new(0, 0)
	playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		playerListContainer.Size = UDim2.new(1, 0, 0, playerListLayout.AbsoluteContentSize.Y)
		playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
	end)

	local playerRows = {}
	local function refreshPlayerList()
		for _, row in pairs(playerRows) do
			pcall(function()
				row:Destroy()
			end)
		end
		playerRows = {}
		local playerCount = 0
		for _, p in ipairs(Players:GetPlayers()) do
			if p == player then
				continue
			end
			playerCount = playerCount + 1
			local row = Instance.new("Frame", playerListContainer)
			row.Size = UDim2.new(1, 0, 0, 28)
			row.BackgroundColor3 = colors.panel
			row.BorderSizePixel = 0
			row.ZIndex = 13
			row.LayoutOrder = playerCount
			local line = Instance.new("Frame", row)
			line.Size = UDim2.new(1, 0, 0, 1)
			line.Position = UDim2.new(0, 0, 1, -1)
			line.BackgroundColor3 = colors.borderDim
			line.BorderSizePixel = 0
			line.ZIndex = 14
			local nameLabel = Instance.new("TextLabel", row)
			nameLabel.Size = UDim2.new(1, -60, 1, 0)
			nameLabel.Position = UDim2.new(0, 12, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = p.Name
			nameLabel.TextColor3 = colors.textDim
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 11
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.ZIndex = 14
			local tpButton = Instance.new("TextButton", row)
			tpButton.Size = UDim2.new(0, 46, 0, 18)
			tpButton.Position = UDim2.new(1, -52, 0.5, -9)
			tpButton.BackgroundColor3 = colors.panelAlt
			tpButton.BorderSizePixel = 0
			tpButton.Text = "TP"
			tpButton.TextColor3 = colors.text
			tpButton.Font = Enum.Font.GothamBold
			tpButton.TextSize = 10
			tpButton.ZIndex = 15
			Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 4)
			Instance.new("UIStroke", tpButton).Color = colors.border
			local targetPlayer = p
			tpButton.MouseEnter:Connect(function()
				tpButton.BackgroundColor3 = colors.panelHover
				nameLabel.TextColor3 = colors.text
			end)
			tpButton.MouseLeave:Connect(function()
				tpButton.BackgroundColor3 = colors.panelAlt
				nameLabel.TextColor3 = colors.textDim
			end)
			tpButton.MouseButton1Click:Connect(function()
				local myRoot = getLocalRootPart()
				if not myRoot then
					return
				end
				local pChar = targetPlayer.Character
				if not pChar then
					return
				end
				local pRoot = pChar:FindFirstChild("HumanoidRootPart")
				if not pRoot then
					return
				end
				myRoot.CFrame = pRoot.CFrame * CFrame.new(0, 0, -2)
			end)
			playerRows[p] = row
		end
		playerListContainer.Size = UDim2.new(1, 0, 0, playerCount * 28)
		playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerCount * 28)
	end

	local refreshRow = Instance.new("Frame", right)
	refreshRow.Size = UDim2.new(1, 0, 0, 28)
	refreshRow.BackgroundColor3 = colors.panel
	refreshRow.BorderSizePixel = 0
	refreshRow.ZIndex = 13
	refreshRow.LayoutOrder = nextRightOrder()
	local refreshButton = Instance.new("TextButton", refreshRow)
	refreshButton.Size = UDim2.new(1, -16, 0, 18)
	refreshButton.Position = UDim2.new(0, 8, 0.5, -9)
	refreshButton.BackgroundColor3 = colors.panelAlt
	refreshButton.BorderSizePixel = 0
	refreshButton.Text = "Refresh Player List"
	refreshButton.TextColor3 = colors.textDim
	refreshButton.Font = Enum.Font.GothamBold
	refreshButton.TextSize = 10
	refreshButton.ZIndex = 14
	Instance.new("UICorner", refreshButton).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", refreshButton).Color = colors.border
	refreshButton.MouseButton1Click:Connect(function()
		refreshPlayerList()
	end)

	createSectionHeader(right, "Fun", nextRightOrder())
	createToggle(right, "Fling Player", false, function(value)
		settings.flingPlayer = value
	end, nextRightOrder())
	createSlider(right, "Fling Force", 100, 5000, 500, function(value)
		settings.flingForce = value
	end, nextRightOrder())

	Players.PlayerAdded:Connect(refreshPlayerList)
	Players.PlayerRemoving:Connect(refreshPlayerList)
	task.defer(refreshPlayerList)
end

do
	local scrollFrame = createSingleColumn(tabFrames["Settings"])
	local order = 0
	local function nextOrder()
		order = order + 1
		return order
	end
	local themePresets = {
		Default = {
			bg = Color3.fromRGB(20, 20, 20),
			panel = Color3.fromRGB(28, 28, 28),
			accent = Color3.fromRGB(255, 255, 255),
			text = Color3.fromRGB(200, 200, 200),
			textDim = Color3.fromRGB(120, 120, 120),
			border = Color3.fromRGB(55, 55, 55),
			sliderFill = Color3.fromRGB(180, 180, 180),
			toggleOn = Color3.fromRGB(255, 255, 255),
			titleBg = Color3.fromRGB(15, 15, 15),
			sectionBg = Color3.fromRGB(22, 22, 22)
		},
		Blue = {
			bg = Color3.fromRGB(12, 16, 26),
			panel = Color3.fromRGB(18, 24, 38),
			accent = Color3.fromRGB(100, 160, 255),
			text = Color3.fromRGB(180, 210, 255),
			textDim = Color3.fromRGB(90, 120, 180),
			border = Color3.fromRGB(50, 80, 130),
			sliderFill = Color3.fromRGB(100, 160, 255),
			toggleOn = Color3.fromRGB(100, 160, 255),
			titleBg = Color3.fromRGB(10, 13, 22),
			sectionBg = Color3.fromRGB(15, 20, 32)
		},
		Red = {
			bg = Color3.fromRGB(22, 12, 12),
			panel = Color3.fromRGB(32, 18, 18),
			accent = Color3.fromRGB(220, 70, 70),
			text = Color3.fromRGB(240, 180, 180),
			textDim = Color3.fromRGB(160, 90, 90),
			border = Color3.fromRGB(100, 45, 45),
			sliderFill = Color3.fromRGB(220, 70, 70),
			toggleOn = Color3.fromRGB(220, 70, 70),
			titleBg = Color3.fromRGB(16, 10, 10),
			sectionBg = Color3.fromRGB(24, 14, 14)
		},
		Green = {
			bg = Color3.fromRGB(10, 20, 14),
			panel = Color3.fromRGB(16, 28, 20),
			accent = Color3.fromRGB(70, 200, 100),
			text = Color3.fromRGB(160, 240, 180),
			textDim = Color3.fromRGB(80, 150, 100),
			border = Color3.fromRGB(40, 90, 60),
			sliderFill = Color3.fromRGB(70, 200, 100),
			toggleOn = Color3.fromRGB(70, 200, 100),
			titleBg = Color3.fromRGB(8, 15, 10),
			sectionBg = Color3.fromRGB(12, 22, 16)
		},
		Purple = {
			bg = Color3.fromRGB(18, 12, 26),
			panel = Color3.fromRGB(26, 18, 38),
			accent = Color3.fromRGB(160, 100, 255),
			text = Color3.fromRGB(210, 180, 255),
			textDim = Color3.fromRGB(120, 90, 180),
			border = Color3.fromRGB(75, 50, 120),
			sliderFill = Color3.fromRGB(160, 100, 255),
			toggleOn = Color3.fromRGB(160, 100, 255),
			titleBg = Color3.fromRGB(13, 10, 20),
			sectionBg = Color3.fromRGB(20, 14, 30)
		},
		Orange = {
			bg = Color3.fromRGB(22, 16, 10),
			panel = Color3.fromRGB(32, 22, 14),
			accent = Color3.fromRGB(255, 150, 50),
			text = Color3.fromRGB(255, 210, 160),
			textDim = Color3.fromRGB(180, 120, 70),
			border = Color3.fromRGB(110, 70, 30),
			sliderFill = Color3.fromRGB(255, 150, 50),
			toggleOn = Color3.fromRGB(255, 150, 50),
			titleBg = Color3.fromRGB(16, 12, 8),
			sectionBg = Color3.fromRGB(24, 17, 11)
		}
	}
	local function applyTheme(name)
		local t = themePresets[name]
		if not t then
			return
		end
		colors.bg = t.bg
		colors.panel = t.panel
		colors.accent = t.accent
		colors.text = t.text
		colors.textDim = t.textDim
		colors.border = t.border
		colors.sliderFill = t.sliderFill
		colors.toggleOn = t.toggleOn
		colors.titleBg = t.titleBg
		colors.sectionBg = t.sectionBg
		colors.panelAlt = Color3.new(t.panel.R + 0.03, t.panel.G + 0.03, t.panel.B + 0.03)
		colors.panelHover = Color3.new(t.panel.R + 0.04, t.panel.G + 0.04, t.panel.B + 0.04)
		colors.borderDim = Color3.new(t.border.R * 0.7, t.border.G * 0.7, t.border.B * 0.7)
		colors.textMuted = Color3.new(t.textDim.R * 0.65, t.textDim.G * 0.65, t.textDim.B * 0.65)
		colors.tabSel = Color3.new(t.panel.R + 0.02, t.panel.G + 0.02, t.panel.B + 0.02)
		colors.tabUnsel = t.bg
		colors.tabDim = t.textDim
		win.BackgroundColor3 = t.bg
		winStroke.Color = t.border
		titleBar.BackgroundColor3 = t.titleBg
		titleFix.BackgroundColor3 = t.titleBg
		titleStroke.Color = colors.borderDim
		tabBar.BackgroundColor3 = t.titleBg
		tabDivider.BackgroundColor3 = t.border
		for _, n in ipairs(tabNames) do
			local btn = tabButtons[n]
			if btn then
				btn.TextColor3 = (n == currentTabName) and t.accent or t.textDim
				btn.BackgroundColor3 = (n == currentTabName) and colors.tabSel or t.bg
			end
		end
		watermark.TextColor3 = t.text
		watermark2.TextColor3 = colors.textMuted
		reopenButton.BackgroundColor3 = t.panel
		reopenButton.TextColor3 = t.textDim
	end
	createSectionHeader(scrollFrame, "UI Theme", nextOrder())
	local themeRow = Instance.new("Frame", scrollFrame)
	themeRow.Size = UDim2.new(1, 0, 0, 40)
	themeRow.BackgroundColor3 = colors.panel
	themeRow.BorderSizePixel = 0
	themeRow.ZIndex = 13
	themeRow.LayoutOrder = nextOrder()
	local tline = Instance.new("Frame", themeRow)
	tline.Size = UDim2.new(1, 0, 0, 1)
	tline.Position = UDim2.new(0, 0, 1, -1)
	tline.BackgroundColor3 = colors.borderDim
	tline.BorderSizePixel = 0
	tline.ZIndex = 14
	local themeNames = { "Default", "Blue", "Red", "Green", "Purple", "Orange" }
	local themeSwatchColors = {
		Default = Color3.fromRGB(200, 200, 200),
		Blue = Color3.fromRGB(100, 160, 255),
		Red = Color3.fromRGB(220, 70, 70),
		Green = Color3.fromRGB(70, 200, 100),
		Purple = Color3.fromRGB(160, 100, 255),
		Orange = Color3.fromRGB(255, 150, 50)
	}
	local tlbl = Instance.new("TextLabel", themeRow)
	tlbl.Size = UDim2.new(0, 70, 0, 16)
	tlbl.Position = UDim2.new(0, 12, 0, 4)
	tlbl.BackgroundTransparency = 1
	tlbl.Text = "Theme Color"
	tlbl.TextColor3 = colors.textDim
	tlbl.Font = Enum.Font.Gotham
	tlbl.TextSize = 10
	tlbl.TextXAlignment = Enum.TextXAlignment.Left
	tlbl.ZIndex = 14
	local currentThemeLabel = Instance.new("TextLabel", themeRow)
	currentThemeLabel.Size = UDim2.new(0, 80, 0, 16)
	currentThemeLabel.Position = UDim2.new(1, -92, 0, 4)
	currentThemeLabel.BackgroundTransparency = 1
	currentThemeLabel.Text = "Default"
	currentThemeLabel.TextColor3 = colors.text
	currentThemeLabel.Font = Enum.Font.GothamBold
	currentThemeLabel.TextSize = 10
	currentThemeLabel.TextXAlignment = Enum.TextXAlignment.Right
	currentThemeLabel.ZIndex = 14
	local swatchContainer = Instance.new("Frame", themeRow)
	swatchContainer.Size = UDim2.new(1, -16, 0, 16)
	swatchContainer.Position = UDim2.new(0, 12, 0, 22)
	swatchContainer.BackgroundTransparency = 1
	swatchContainer.ZIndex = 14
	local swatchLayout = Instance.new("UIListLayout", swatchContainer)
	swatchLayout.FillDirection = Enum.FillDirection.Horizontal
	swatchLayout.Padding = UDim.new(0, 6)
	swatchLayout.SortOrder = Enum.SortOrder.LayoutOrder
	for i, name in ipairs(themeNames) do
		local swatch = Instance.new("TextButton", swatchContainer)
		swatch.Size = UDim2.new(0, 16, 0, 16)
		swatch.BackgroundColor3 = themeSwatchColors[name]
		swatch.BorderSizePixel = 0
		swatch.Text = ""
		swatch.ZIndex = 15
		swatch.LayoutOrder = i
		Instance.new("UICorner", swatch).CornerRadius = UDim.new(1, 0)
		local swatchStroke = Instance.new("UIStroke", swatch)
		swatchStroke.Color = Color3.fromRGB(60, 60, 60)
		swatchStroke.Thickness = 1
		swatch.MouseEnter:Connect(function()
			swatchStroke.Color = Color3.fromRGB(200, 200, 200)
			swatchStroke.Thickness = 1.5
		end)
		swatch.MouseLeave:Connect(function()
			swatchStroke.Color = Color3.fromRGB(60, 60, 60)
			swatchStroke.Thickness = 1
		end)
		swatch.MouseButton1Click:Connect(function()
			applyTheme(name)
			currentThemeLabel.Text = name
			currentThemeLabel.TextColor3 = themeSwatchColors[name]
		end)
	end

	createSectionHeader(scrollFrame, "General", nextOrder())
	createKeybind(scrollFrame, "Toggle Menu Key", "Insert", function(keyCode)
		settings.toggleKey = keyCode
	end, nextOrder())

	createSectionHeader(scrollFrame, "HUD", nextOrder())
	createToggle(scrollFrame, "Show HUD", true, function(value)
		settings.hudVisible = value
	end, nextOrder())

	createSectionHeader(scrollFrame, "ESP Config", nextOrder())
	createDropdown(scrollFrame, "HP Bar Pos", { "Left", "Right", "Top", "Bottom" }, 1, function(value)
		settings.espHpBarPos = value:lower()
	end, nextOrder())
	createToggle(scrollFrame, "Show Team ESP", false, function(value)
		settings.espTeamCheck = value
	end, nextOrder())
	createToggle(scrollFrame, "Show Knocked", true, function(value)
		settings.espShowKnocked = value
	end, nextOrder())
	createToggle(scrollFrame, "Ignore NPCs", false, function(value)
		settings.espIgnoreNPC = value
	end, nextOrder())
	createDropdown(scrollFrame, "Tracer Origin", { "Bottom", "Center", "Mouse" }, 1, function(value)
		settings.espTracerOrigin = value:lower()
	end, nextOrder())

	createSectionHeader(scrollFrame, "Script", nextOrder())
	local uninjectRow = Instance.new("Frame", scrollFrame)
	uninjectRow.Size = UDim2.new(1, 0, 0, 36)
	uninjectRow.BackgroundColor3 = colors.panel
	uninjectRow.BorderSizePixel = 0
	uninjectRow.ZIndex = 13
	uninjectRow.LayoutOrder = nextOrder()
	local uninjectButton = Instance.new("TextButton", uninjectRow)
	uninjectButton.Size = UDim2.new(1, -16, 0, 24)
	uninjectButton.Position = UDim2.new(0, 8, 0.5, -12)
	uninjectButton.BackgroundColor3 = Color3.fromRGB(55, 18, 18)
	uninjectButton.BorderSizePixel = 0
	uninjectButton.Text = "Uninject Script"
	uninjectButton.TextColor3 = Color3.fromRGB(220, 80, 80)
	uninjectButton.Font = Enum.Font.GothamBold
	uninjectButton.TextSize = 11
	uninjectButton.ZIndex = 14
	Instance.new("UICorner", uninjectButton).CornerRadius = UDim.new(0, 5)
	local uninjectStroke = Instance.new("UIStroke", uninjectButton)
	uninjectStroke.Color = Color3.fromRGB(110, 35, 35)
	uninjectStroke.Thickness = 1
	uninjectButton.MouseEnter:Connect(function()
		uninjectButton.BackgroundColor3 = Color3.fromRGB(75, 22, 22)
		uninjectStroke.Color = Color3.fromRGB(200, 60, 60)
	end)
	uninjectButton.MouseLeave:Connect(function()
		uninjectButton.BackgroundColor3 = Color3.fromRGB(55, 18, 18)
		uninjectStroke.Color = Color3.fromRGB(110, 35, 35)
	end)
	uninjectButton.MouseButton1Click:Connect(function()
		uninjectButton.Text = "Uninjecting..."
		uninjectButton.TextColor3 = Color3.fromRGB(150, 50, 50)
		task.wait(0.3)
		for p, e in pairs(espData) do
			destroyEsp(p)
		end
		for p, hl in pairs(aimHighlights) do
			pcall(function()
				hl:Destroy()
			end)
		end
		aimHighlights = {}
		for _, p in ipairs(Players:GetPlayers()) do
			local box = workspace.CurrentCamera:FindFirstChild("HitboxPart_" .. p.UserId)
			if box then
				box:Destroy()
			end
			if p ~= player and p.Character then
				local r = p.Character:FindFirstChild("HumanoidRootPart")
				if r then
					r.Size = Vector3.new(2, 2, 1)
				end
			end
		end
		local h = getLocalHumanoid()
		if h then
			h.WalkSpeed = 16
			h.JumpPower = 50
			h.PlatformStand = false
			h.ToolPunchCooldown = 0.1
		end
		local root = getLocalRootPart()
		if root then
			cleanFlyInstances(root)
			local bv = root:FindFirstChild("bv")
			local bg = root:FindFirstChild("bg")
			if bv then
				bv:Destroy()
			end
			if bg then
				bg:Destroy()
			end
			pcall(function()
				root:SetNetworkOwner(nil)
			end)
		end
		disconnectRapidFire()
		if bhopConn then
			bhopConn:Disconnect()
			bhopConn = nil
		end
		if blurEffect and blurEffect.Parent then
			blurEffect:Destroy()
		end
		if speedRingPart and speedRingPart.Parent then
			speedRingPart:Destroy()
		end
		for _, p in ipairs(backgroundParticles) do
			pcall(function()
				p.dot:Destroy()
			end)
		end
		for _, dot in pairs(radarDots) do
			pcall(function()
				dot:Destroy()
			end)
		end
		if fovCircle then
			pcall(function()
				fovCircle:Destroy()
			end)
		end
		if tracerLine then
			pcall(function()
				tracerLine:Destroy()
			end)
		end
		if velDisplayLbl then
			pcall(function()
				velDisplayLbl:Destroy()
			end)
		end
		if speedLinesBB then
			pcall(function()
				speedLinesBB:Destroy()
			end)
		end
		if reopenButton and reopenButton.Parent then
			reopenButton:Destroy()
		end
		settings.fly = false
		settings.noclip = false
		settings.killAura = false
		settings.aimbot = false
		settings.silentAim = false
		settings.espEnabled = false
		settings.radarEnabled = false
		settings.voidHide = false
		settings.bhop = false
		settings.autoKillEnabled = false
		task.wait(0.1)
		screenGui:Destroy()
	end)
end

selectTab("Aimbot")

local hudFrame = Instance.new("Frame")
hudFrame.Size = UDim2.new(0, 168, 0, 24)
hudFrame.Position = UDim2.new(0, 8, 0.5, -100)
hudFrame.BackgroundColor3 = colors.bg
hudFrame.BackgroundTransparency = 0
hudFrame.BorderSizePixel = 0
hudFrame.ZIndex = 55
hudFrame.ClipsDescendants = true
hudFrame.Visible = false
hudFrame.Parent = screenGui
Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0, 5)
local hudStroke = Instance.new("UIStroke", hudFrame)
hudStroke.Color = colors.border
hudStroke.Thickness = 1
local hudHeader = Instance.new("Frame", hudFrame)
hudHeader.Size = UDim2.new(1, 0, 0, 22)
hudHeader.BackgroundColor3 = colors.titleBg
hudHeader.BorderSizePixel = 0
hudHeader.ZIndex = 56
Instance.new("UICorner", hudHeader).CornerRadius = UDim.new(0, 5)
local hudHeaderFix = Instance.new("Frame", hudHeader)
hudHeaderFix.Size = UDim2.new(1, 0, 0, 6)
hudHeaderFix.Position = UDim2.new(0, 0, 1, -6)
hudHeaderFix.BackgroundColor3 = colors.titleBg
hudHeaderFix.BorderSizePixel = 0
hudHeaderFix.ZIndex = 56
local hudHeaderLine = Instance.new("Frame", hudHeader)
hudHeaderLine.Size = UDim2.new(1, 0, 0, 1)
hudHeaderLine.Position = UDim2.new(0, 0, 1, -1)
hudHeaderLine.BackgroundColor3 = colors.borderDim
hudHeaderLine.BorderSizePixel = 0
hudHeaderLine.ZIndex = 57
local hudTitle = Instance.new("TextLabel", hudHeader)
hudTitle.Size = UDim2.new(1, -8, 1, 0)
hudTitle.Position = UDim2.new(0, 8, 0, 0)
hudTitle.BackgroundTransparency = 1
hudTitle.Text = "Module List"
hudTitle.TextColor3 = colors.textMuted
hudTitle.Font = Enum.Font.GothamBold
hudTitle.TextSize = 9
hudTitle.TextXAlignment = Enum.TextXAlignment.Left
hudTitle.ZIndex = 57

local hudList = Instance.new("Frame", hudFrame)
hudList.Size = UDim2.new(1, 0, 1, -22)
hudList.Position = UDim2.new(0, 0, 0, 22)
hudList.BackgroundTransparency = 1
hudList.BorderSizePixel = 0
hudList.ZIndex = 56
local hudLayout = Instance.new("UIListLayout", hudList)
hudLayout.SortOrder = Enum.SortOrder.LayoutOrder
hudLayout.Padding = UDim.new(0, 0)

local hudEntries = {
	{ key = "autoReload", label = "Auto Reload", staticBind = "R" },
	{ key = "fly", label = "Fly", bindKey = "flyKey" },
	{ key = "speedEnabled", label = "Speed", bindKey = "speedKey" },
	{ key = "aimbot", label = "Aimbot", staticBind = "RMB" },
	{ key = "stickyAim", label = "Sticky Aim", bindKey = "stickyKey" },
	{ key = "silentAim", label = "Silent Aim", staticBind = "LMB" },
	{ key = "lockEnabled", label = "Lockon", bindKey = "lockKey" },
	{ key = "triggerBot", label = "Triggerbot", staticBind = "—", isCycle = true },
	{ key = "flingPlayer", label = "Fling", staticBind = "—" },
	{ key = "orbitEnabled", label = "Orbit", staticBind = "—" },
	{ key = "autoStomp", label = "Stomp", staticBind = "—" },
	{ key = "bhop", label = "Bhop", staticBind = "AUTO" },
	{ key = "antiStomp", label = "No Fall", staticBind = "—" },
	{ key = "autoHeal", label = "Auto Heal", staticBind = "—" },
	{ key = "hitboxExpand", label = "Hitbox Expander", staticBind = "—" },
	{ key = "teleportToTarget", label = "TP to Target", bindKey = "teleportKey" },
	{ key = "lockPlayer", label = "TpPlayer", bindKey = "tpPlayerKey" },
	{ key = "antiRagdoll", label = "No Ragdoll", staticBind = "—" },
	{ key = "noclip", label = "Noclip", staticBind = "—" },
	{ key = "netDesync", label = "Infinite Jump", staticBind = "—" },
	{ key = "velDesync", label = "Velocity Desync", staticBind = "—" },
	{ key = "fakePos", label = "Fake Position", staticBind = "—" },
	{ key = "voidHide", label = "Void Hide", staticBind = "—" },
	{ key = "autoKillStomp", label = "Auto Kill", staticBind = "—" },
	{ key = "killAura", label = "Kill Aura", staticBind = "—" },
	{ key = "rapidFire", label = "Rapid Fire", staticBind = "—" }
}

local function getFeatureColor(key)
	local combatKeys = { aimbot = true, silentAim = true, lockEnabled = true, triggerBot = true, killAura = true, flingPlayer = true, autoKillEnabled = true, stickyAim = true }
	local visualKeys = { espEnabled = true, radarEnabled = true, espChams = true }
	local movementKeys = { speedHack = true, fly = true, noclip = true, bhop = true, teleportToTarget = true, orbitEnabled = true, followTarget = true }

	if combatKeys[key] then
		return colors.red
	elseif visualKeys[key] then
		return colors.accentBlue
	elseif movementKeys[key] then
		return Color3.fromRGB(220, 175, 55)
	else
		return colors.green
	end
end

local function formatKeybind(keyCode)
	if not keyCode then
		return "—"
	end
	local name = tostring(keyCode):gsub("Enum.KeyCode.", "")
	local specials = {
		CapsLock = "CAPS",
		LeftShift = "SHIFT",
		RightShift = "RSHIFT",
		LeftControl = "CTRL",
		RightControl = "RCTRL",
		LeftAlt = "LALT",
		RightAlt = "RALT",
		BackSpace = "BKSP",
		Return = "ENTER",
		Insert = "INS",
		Delete = "DEL"
	}
	return (specials[name] or (name:len() > 5 and name:sub(1, 5) or name)):upper()
end

local hudRowData = {}
for i, entry in ipairs(hudEntries) do
	local row = Instance.new("Frame", hudList)
	row.Size = UDim2.new(1, 0, 0, 20)
	row.BackgroundColor3 = colors.panel
	row.BorderSizePixel = 0
	row.ZIndex = 56
	row.LayoutOrder = i
	row.Visible = false

	local separator = Instance.new("Frame", row)
	separator.Size = UDim2.new(1, 0, 0, 1)
	separator.Position = UDim2.new(0, 0, 1, -1)
	separator.BackgroundColor3 = colors.borderDim
	separator.BorderSizePixel = 0
	separator.ZIndex = 55

	local dot = Instance.new("Frame", row)
	dot.Size = UDim2.new(0, 5, 0, 5)
	dot.Position = UDim2.new(0, 8, 0.5, -2)
	dot.BackgroundColor3 = getFeatureColor(entry.key)
	dot.BorderSizePixel = 0
	dot.ZIndex = 57
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local labelText = Instance.new("TextLabel", row)
	labelText.Size = UDim2.new(0, 100, 1, 0)
	labelText.Position = UDim2.new(0, 20, 0, 0)
	labelText.BackgroundTransparency = 1
	labelText.Text = entry.label
	labelText.TextColor3 = colors.text
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 10
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.ZIndex = 57

	local bindLabel = Instance.new("TextLabel", row)
	bindLabel.Size = UDim2.new(0, 44, 1, 0)
	bindLabel.Position = UDim2.new(1, -48, 0, 0)
	bindLabel.BackgroundTransparency = 1
	bindLabel.Text = entry.staticBind or "—"
	bindLabel.TextColor3 = colors.textMuted
	bindLabel.Font = Enum.Font.Code
	bindLabel.TextSize = 9
	bindLabel.TextXAlignment = Enum.TextXAlignment.Right
	bindLabel.ZIndex = 57

	hudRowData[i] = { row = row, bindLbl = bindLabel, dot = dot, lbl = labelText, entry = entry }
end

local function updateHud()
	if not settings.hudVisible then
		hudFrame.Visible = false
		return
	end

	local activeCount = 0
	for _, r in ipairs(hudRowData) do
		local entry = r.entry
		local value = settings[entry.key]
		local isActive = entry.isCycle and (value ~= nil and value ~= false and value ~= "none") or (value == true)
		r.row.Visible = isActive

		if isActive then
			activeCount = activeCount + 1
			r.row.BackgroundColor3 = colors.panel
			r.lbl.TextColor3 = colors.text
			r.bindLbl.TextColor3 = colors.textMuted
			r.dot.BackgroundColor3 = getFeatureColor(entry.key)
			if entry.bindKey then
				r.bindLbl.Text = formatKeybind(settings[entry.bindKey])
			end
		end
	end

	if activeCount == 0 then
		hudFrame.Visible = false
		return
	end

	hudFrame.BackgroundColor3 = colors.bg
	hudStroke.Color = colors.border
	hudHeader.BackgroundColor3 = colors.titleBg
	hudHeaderFix.BackgroundColor3 = colors.titleBg
	hudHeaderLine.BackgroundColor3 = colors.borderDim
	hudTitle.TextColor3 = colors.textMuted
	hudFrame.Size = UDim2.new(0, 168, 0, 22 + activeCount * 20 + 2)
	hudFrame.Visible = true
end

RunService.Heartbeat:Connect(function()
	if not screenGui or not screenGui.Parent then
		return
	end
	updateHud()
end)

local camera = workspace.CurrentCamera
local FLY_ATTACH_NAME = "MilkywayFlyAttach"
local flyAttachment = nil
local flyLinearVelocity = nil
local flyAlignOrientation = nil
local flyVelocitycurrent = Vector3.new()
local flyNetworkCounter = 0
local flyStateCounter = 0

local function cleanFlyInstances(root)
	if root then
		local attachment = root:FindFirstChild(FLY_ATTACH_NAME)
		if attachment then
			attachment:Destroy()
		end
	end
	flyAttachment = nil
	flyLinearVelocity = nil
	flyAlignOrientation = nil
	flyVelocitycurrent = Vector3.new()
end

local function setupFly(root)
	cleanFlyInstances(root)
	local attach = Instance.new("Attachment")
	attach.Name = FLY_ATTACH_NAME
	attach.Parent = root
	flyAttachment = attach

	local lv = Instance.new("LinearVelocity")
	lv.Name = "MilkywayLV"
	lv.Attachment0 = attach
	lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	lv.MaxForce = 1e5
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.VectorVelocity = Vector3.new()
	lv.Parent = attach
	flyLinearVelocity = lv

	local ao = Instance.new("AlignOrientation")
	ao.Name = "MilkywayAO"
	ao.Attachment0 = attach
	ao.Attachment1 = attach
	ao.MaxTorque = 1e5
	ao.Responsiveness = 200
	ao.Parent = attach
	flyAlignOrientation = ao
end

local fovCircle, speedLinesBB, velDisplayLbl, speedRingPart, tracerLine, bhopConn = nil, nil, nil, nil, nil, nil
local aimHighlights = {}

local function createLine(thickness, color)
	local l = Drawing.new("Line")
	l.Visible = false
	l.Thickness = thickness or 1
	l.Color = color or Color3.fromRGB(255, 255, 255)
	l.Transparency = 1
	return l
end

local function createQuad(thickness, color)
	local q = Drawing.new("Quad")
	q.Visible = false
	q.Filled = false
	q.Thickness = thickness or 1
	q.Color = color or Color3.fromRGB(255, 255, 255)
	q.Transparency = 1
	return q
end

local function createText(color, outline)
	local t = Drawing.new("Text")
	t.Visible = false
	t.Size = 13
	t.Center = true
	t.Outline = true
	t.Color = color or Color3.fromRGB(255, 255, 255)
	t.OutlineColor = outline or Color3.fromRGB(0, 0, 0)
	t.Font = 2
	t.Transparency = 1
	return t
end

local espData = {}
local function getEspElements(p)
	if espData[p] and espData[p].box then
		return espData[p]
	end
	local e = {}
	e.box, e.boxOutline = createQuad(1, settings.espBoxColor), createQuad(2, Color3.fromRGB(0, 0, 0))
	e.tracer, e.tracerOutline = createLine(1, settings.espBoxColor), createLine(2, Color3.fromRGB(0, 0, 0))
	e.name = createText(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0))
	e.dist = createText(Color3.fromRGB(200, 200, 200), Color3.fromRGB(0, 0, 0))
	e.hpBg = createLine(3, Color3.fromRGB(0, 0, 0))
	e.hpFill = createLine(1.5, Color3.fromRGB(0, 255, 0))
	e.highlight = nil
	espData[p] = e
	return e
end

local function hideEspElements(e)
	if not e then
		return
	end
	e.box.Visible = false
	e.boxOutline.Visible = false
	e.tracer.Visible = false
	e.tracerOutline.Visible = false
	e.name.Visible = false
	e.dist.Visible = false
	e.hpBg.Visible = false
	e.hpFill.Visible = false
end

local function destroyEsp(p)
	local e = espData[p]
	if not e then
		return
	end
	for _, obj in pairs(e) do
		pcall(function()
			if type(obj) == "Instance" then
				if obj.Remove then
					obj:Remove()
				elseif obj.Destroy then
					obj:Destroy()
				end
			end
		end)
	end
	espData[p] = nil
end

local function destroyHighlight(e)
	if e and e.highlight then
		pcall(function()
			e.highlight:Destroy()
		end)
		e.highlight = nil
	end
end

local function updateHighlight(e, char, col, glow)
	if not e.highlight or not e.highlight.Parent then
		local hl = Instance.new("Highlight")
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent = workspace
		e.highlight = hl
	end
	e.highlight.Adornee = char
	e.highlight.FillColor = col
	e.highlight.OutlineColor = col
	e.highlight.FillTransparency = glow and 0.55 or 0.82
	e.highlight.OutlineTransparency = glow and 0 or 0.25
end

local function getCharacterScreenBounds(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head")
	if not hrp or not head then
		return nil
	end
	local screenPos, visible = camera:WorldToViewportPoint(hrp.Position)
	if not visible or screenPos.Z <= 0 then
		return nil
	end

	local headScreenPos = camera:WorldToViewportPoint(head.Position)
	local height = math.clamp(math.abs(screenPos.Y - headScreenPos.Y), 2, 400)
	return screenPos.X, screenPos.Y, height, true
end

local function getTracerOrigin()
	local viewport = camera.ViewportSize
	local o = settings.espTracerOrigin or "bottom"
	if o == "center" or o == "centre" then
		return Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
	elseif o == "mouse" then
		return UserInputService:GetMouseLocation()
	else
		return Vector2.new(viewport.X * 0.5, viewport.Y)
	end
end

local function updateEsp()
	local playerSet = {}
	for _, p in ipairs(Players:GetPlayers()) do
		playerSet[p] = true
	end
	for p in pairs(espData) do
		if not playerSet[p] then
			destroyEsp(p)
		end
	end

	if not settings.espEnabled then
		for p in pairs(espData) do
			local e = espData[p]
			if e then
				hideEspElements(e)
				destroyHighlight(e)
			end
		end
		return
	end

	local myRoot = getLocalRootPart()
	local myPosition = myRoot and myRoot.Position or Vector3.new()
	local myTeam = player.Team
	local tracerOrigin = getTracerOrigin()

	for _, p in ipairs(Players:GetPlayers()) do
		if p == player then
			continue
		end
		if settings.espTeamCheck and p.Team == myTeam then
			continue
		end
		local char = p.Character
		if not char then
			local e = espData[p]
			if e then
				hideEspElements(e)
			end
			continue
		end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			local e = espData[p]
			if e then
				hideEspElements(e)
			end
			continue
		end
		if not settings.espShowKnocked and humanoid.Health <= 0 then
			local e = espData[p]
			if e then
				hideEspElements(e)
				destroyHighlight(e)
			end
			continue
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then
			local e = espData[p]
			if e then
				hideEspElements(e)
			end
			continue
		end
		local distance = (root.Position - myPosition).Magnitude
		if distance > settings.espMaxDist then
			local e = espData[p]
			if e then
				hideEspElements(e)
				destroyHighlight(e)
			end
			continue
		end
		local sx, sy, height, visible = getCharacterScreenBounds(char)
		if not visible then
			local e = espData[p]
			if e then
				hideEspElements(e)
			end
			continue
		end

		local e = getEspElements(p)
		local color = settings.espBoxColor
		local width = height
		local top = sy - height * 2
		local bottom = sy + height * 2
		local left = sx - width
		local right = sx + width
		if settings.espBoxes then
			local function drawQuad(q, extraPad)
				extraPad = extraPad or 0
				q.PointA = Vector2.new(right + extraPad, top - extraPad)
				q.PointB = Vector2.new(left - extraPad, top - extraPad)
				q.PointC = Vector2.new(left - extraPad, bottom + extraPad)
				q.PointD = Vector2.new(right + extraPad, bottom + extraPad)
				q.Transparency = settings.espBoxOpacity
				q.Visible = true
			end
			drawQuad(e.boxOutline, 1)
			e.boxOutline.Color = Color3.fromRGB(0, 0, 0)
			drawQuad(e.box, 0)
			e.box.Color = color
		else
			e.box.Visible = false
			e.boxOutline.Visible = false
		end

		if settings.espTracer then
			local target = Vector2.new(sx, bottom)
			e.tracerOutline.From = tracerOrigin
			e.tracerOutline.To = target
			e.tracerOutline.Color = Color3.fromRGB(0, 0, 0)
			e.tracerOutline.Transparency = settings.espBoxOpacity
			e.tracerOutline.Visible = true
			e.tracer.From = tracerOrigin
			e.tracer.To = target
			e.tracer.Color = color
			e.tracer.Transparency = settings.espBoxOpacity
			e.tracer.Visible = true
		else
			e.tracer.Visible = false
			e.tracerOutline.Visible = false
		end

		if settings.espNames then
			e.name.Text = p.Name
			e.name.Position = Vector2.new(sx, top - 16)
			e.name.Color = Color3.fromRGB(255, 255, 255)
			e.name.Visible = true
		else
			e.name.Visible = false
		end
		if settings.espDistance then
			e.dist.Text = "[" .. math.floor(distance) .. "m]"
			e.dist.Position = Vector2.new(sx, bottom + 2)
			e.dist.Color = Color3.fromRGB(200, 200, 200)
			e.dist.Visible = true
		else
			e.dist.Visible = false
		end

		if settings.espHealthBar then
			local hpRatio = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
			local hpColor = Color3.new(1 - hpRatio, hpRatio, 0)
			local pos = settings.espHpBarPos
			local bgFrom, bgTo, fillFrom, fillTo
			if pos == "right" then
				local barX = right + 5
				bgFrom = Vector2.new(barX, bottom)
				bgTo = Vector2.new(barX, top)
				fillFrom = Vector2.new(barX, bottom)
				fillTo = bgFrom:Lerp(bgTo, hpRatio)
			elseif pos == "top" then
				bgFrom = Vector2.new(left, top - 5)
				bgTo = Vector2.new(right, top - 5)
				fillFrom = Vector2.new(left, top - 5)
				fillTo = bgFrom:Lerp(bgTo, hpRatio)
			elseif pos == "bottom" then
				bgFrom = Vector2.new(left, bottom + 5)
				bgTo = Vector2.new(right, bottom + 5)
				fillFrom = Vector2.new(left, bottom + 5)
				fillTo = bgFrom:Lerp(bgTo, hpRatio)
			else
				local barX = left - 5
				bgFrom = Vector2.new(barX, bottom)
				bgTo = Vector2.new(barX, top)
				fillFrom = Vector2.new(barX, bottom)
				fillTo = bgFrom:Lerp(bgTo, hpRatio)
			end
			e.hpBg.From = bgFrom
			e.hpBg.To = bgTo
			e.hpBg.Color = Color3.fromRGB(0, 0, 0)
			e.hpBg.Visible = true
			e.hpFill.From = fillFrom
			e.hpFill.To = fillTo
			e.hpFill.Color = hpColor
			e.hpFill.Visible = true
		else
			e.hpBg.Visible = false
			e.hpFill.Visible = false
		end
		if settings.espChams or settings.espGlow then
			updateHighlight(e, char, color, settings.espGlow)
		else
			destroyHighlight(e)
		end
	end
end

local function getScreenDistance(worldPos)
	local viewport = camera.ViewportSize
	local centerX, centerY = viewport.X / 2, viewport.Y / 2
	local screenPos, visible = camera:WorldToViewportPoint(worldPos)

	if not visible or screenPos.Z <= 0 then
		return math.huge, nil
	end

	local dx, dy = screenPos.X - centerX, screenPos.Y - centerY
	return math.sqrt(dx * dx + dy * dy), screenPos
end

local function isVisible(targetPos)
	if not settings.wallCheck then
		return true
	end
	local origin = camera.CFrame.Position
	local direction = targetPos - origin
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = { player.Character }
	params.FilterType = Enum.RaycastFilterType.Exclude

	local result = workspace:Raycast(origin, direction, params)
	if not result then
		return true
	end

	local hit = result.Instance
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character and hit:IsDescendantOf(p.Character) then
			return true
		end
	end
	return false
end

local function findBestTarget()
	local myRoot = getLocalRootPart()
	local myTeam = player.Team
	local bestTarget, bestScore = nil, math.huge

	for _, p in ipairs(Players:GetPlayers()) do
		if p == player then
			continue
		end
		if settings.teamCheck and p.Team == myTeam then
			continue
		end
		local char = p.Character
		if not char then
			continue
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			continue
		end
		if settings.ignoreKnocked and hum.Health < 1 then
			continue
		end
		local part = char:FindFirstChild(settings.aimPart) or char:FindFirstChild("HumanoidRootPart")
		if not part then
			continue
		end
		if myRoot and settings.useMaxDist then
			local distance = (part.Position - myRoot.Position).Magnitude
			if distance > (settings.maxDist or 300) then
				continue
			end
			if settings.ignoreFar and distance > 500 then
				continue
			end
		end

		if not isVisible(part.Position) then
			continue
		end

		local dist = getScreenDistance(part.Position)
		if dist > settings.aimFov then
			continue
		end

		local score = settings.closestFov and dist or (myRoot and (part.Position - myRoot.Position).Magnitude or dist)
		if score < bestScore then
			bestScore = score
			bestTarget = { player = p, char = char, part = part, hum = hum, screenDist = dist }
		end
	end
	return bestTarget
end

local aimHighlights = {}
local function updateTargetHighlight(target)
	for p, hl in pairs(aimHighlights) do
		if not hl.Parent or (target and p == target.player) then
			continue
		end
		hl:Destroy()
		aimHighlights[p] = nil
	end
	if not settings.targetHighlight or not target then
		return
	end
	local p = target.player
	if not aimHighlights[p] then
		local hl = Instance.new("SelectionBox")
		hl.Color3 = Color3.fromRGB(255, 255, 255)
		hl.LineThickness = 0.04
		hl.SurfaceTransparency = 1
		hl.Adornee = target.char
		hl.Parent = workspace
		aimHighlights[p] = hl
	end
end

local function aimAtPosition(targetPos)
	local pos = targetPos
	if settings.velPred then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local r = p.Character:FindFirstChild(settings.aimPart) or p.Character:FindFirstChild("HumanoidRootPart")
				if r and (r.Position - targetPos).Magnitude < 0.1 then
					local vel = r.Velocity
					local dist = (targetPos - camera.CFrame.Position).Magnitude
					local bulletTravelTime = dist / 600
					pos = targetPos + vel * bulletTravelTime * (settings.predSteps or 4) * 0.04
					if settings.gravComp then
						pos = pos + Vector3.new(0, workspace.Gravity * bulletTravelTime * bulletTravelTime * 0.5, 0)
					end
					break
				end
			end
		end
	end
	local targetCF = CFrame.lookAt(camera.CFrame.Position, pos)
	camera.CFrame = camera.CFrame:Lerp(targetCF, 1 / math.clamp(settings.aimSmooth, 1, 30))
end