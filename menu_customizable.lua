--[[
    AbyssTech-style UI framework
    UI ONLY - no exploit/cheat functionality
    Mobile/touch supported

    This file ONLY creates the GUI framework.
    It does NOT create any tabs, buttons, toggles, or textboxes.

    Usage:
        local UI = loadstring(game:HttpGet("YOUR_RAW_URL"))()

        local Tabs = {}
        Tabs.Combat = UI:CreateTab("Combat")

        Tabs.Combat:AddSection("Example")
        Tabs.Combat:AddToggle("Example Toggle", false)
        Tabs.Combat:AddButton("Example Button")
        Tabs.Combat:AddTextBox("Example Text")
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("AbyssTechUI")
if Old then
    Old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AbyssTechUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 650, 0, 430)
Main.Position = UDim2.new(0.5, -325, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(17,17,20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,7)
MainCorner.Parent = Main

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,45)
Top.BackgroundColor3 = Color3.fromRGB(21,21,25)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0,7)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,16,0,0)
Title.Size = UDim2.new(0,200,1,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "AbyssTech"
Title.TextColor3 = Color3.fromRGB(235,235,240)
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local SubTitle = Instance.new("TextLabel")
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0,95,0,0)
SubTitle.Size = UDim2.new(0,150,1,0)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "Universal"
SubTitle.TextColor3 = Color3.fromRGB(125,125,135)
SubTitle.TextSize = 12
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Top

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1,-42,0,5)
Close.Size = UDim2.new(0,35,0,35)
Close.Font = Enum.Font.GothamBold
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(170,170,180)
Close.TextSize = 22
Close.Parent = Top

local Minimize = Instance.new("TextButton")
Minimize.BackgroundTransparency = 1
Minimize.Position = UDim2.new(1,-78,0,5)
Minimize.Size = UDim2.new(0,35,0,35)
Minimize.Font = Enum.Font.GothamBold
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(170,170,180)
Minimize.TextSize = 18
Minimize.Parent = Top

local Floating = Instance.new("TextButton")
Floating.Name = "FloatingButton"
Floating.Size = UDim2.new(0,52,0,52)
Floating.Position = UDim2.new(0,20,0.5,-26)
Floating.BackgroundColor3 = Color3.fromRGB(20,20,24)
Floating.BorderSizePixel = 0
Floating.Font = Enum.Font.GothamBold
Floating.Text = "A"
Floating.TextColor3 = Color3.fromRGB(235,235,240)
Floating.TextSize = 20
Floating.Visible = false
Floating.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1,0)
FloatCorner.Parent = Floating

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Floating.Visible = true
end)

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    Floating.Visible = true
end)

Floating.MouseButton1Click:Connect(function()
    Floating.Visible = false
    Main.Visible = true
end)

local Navigation = Instance.new("Frame")
Navigation.Position = UDim2.new(0,0,0,45)
Navigation.Size = UDim2.new(0,145,1,-45)
Navigation.BackgroundColor3 = Color3.fromRGB(14,14,17)
Navigation.BorderSizePixel = 0
Navigation.Parent = Main

local NavLayout = Instance.new("UIListLayout")
NavLayout.Padding = UDim.new(0,3)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Parent = Navigation

local NavPadding = Instance.new("UIPadding")
NavPadding.PaddingTop = UDim.new(0,12)
NavPadding.PaddingLeft = UDim.new(0,8)
NavPadding.PaddingRight = UDim.new(0,8)
NavPadding.Parent = Navigation

local Content = Instance.new("Frame")
Content.Position = UDim2.new(0,145,0,45)
Content.Size = UDim2.new(1,-145,1,-45)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Pages = {}
local TabButtons = {}

local UI = {}
UI.ScreenGui = ScreenGui
UI.Main = Main
UI.Navigation = Navigation
UI.Content = Content
UI.Pages = Pages
UI.Tabs = TabButtons

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1,-20,1,-20)
    page.Position = UDim2.new(0,10,0,10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(80,80,90)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.Visible = false
    page.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+15)
    end)

    Pages[name] = page
    return page
end

local function AddSection(page,text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-5,0,28)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,225)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = page
    return label
end

local function AddButton(page,text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-5,0,34)
    b.BackgroundColor3 = Color3.fromRGB(27,27,32)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Font = Enum.Font.Gotham
    b.Text = text
    b.TextColor3 = Color3.fromRGB(190,190,198)
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0,12)
    pad.Parent = b

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,5)
    corner.Parent = b

    return b
end

local function AddToggle(page,text,default)
    local b = AddButton(page,text)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0,9,0,9)
    indicator.Position = UDim2.new(1,-22,0.5,-4)
    indicator.BackgroundColor3 = Color3.fromRGB(65,65,72)
    indicator.BorderSizePixel = 0
    indicator.Parent = b

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1,0)
    corner.Parent = indicator

    local state = default == true

    local function update()
        indicator.BackgroundColor3 = state
            and Color3.fromRGB(235,235,240)
            or Color3.fromRGB(65,65,72)
    end

    b.MouseButton1Click:Connect(function()
        state = not state
        update()
    end)

    update()

    return {
        Button = b,
        Indicator = indicator,
        GetState = function()
            return state
        end,
        SetState = function(value)
            state = value == true
            update()
        end
    }
end

local function AddTextBox(page,placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-5,0,34)
    box.BackgroundColor3 = Color3.fromRGB(27,27,32)
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(100,100,110)
    box.TextColor3 = Color3.fromRGB(210,210,215)
    box.TextSize = 12
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0,12)
    pad.Parent = box

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,5)
    corner.Parent = box

    return box
end

function UI:CreateTab(name)
    if Pages[name] then
        return Pages[name]
    end

    local page = CreatePage(name)

    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1,0,0,38)
    button.BackgroundColor3 = Color3.fromRGB(14,14,17)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Font = Enum.Font.GothamMedium
    button.Text = "  "..name
    button.TextColor3 = Color3.fromRGB(145,145,155)
    button.TextSize = 13
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = Navigation

    TabButtons[name] = button

    button.MouseButton1Click:Connect(function()
        for tabName,p in pairs(Pages) do
            p.Visible = false
            local b = TabButtons[tabName]
            if b then
                b.BackgroundColor3 = Color3.fromRGB(14,14,17)
                b.TextColor3 = Color3.fromRGB(145,145,155)
            end
        end

        page.Visible = true
        button.BackgroundColor3 = Color3.fromRGB(32,32,38)
        button.TextColor3 = Color3.fromRGB(235,235,240)
    end)

    local TabObject = {
        Page = page,
        Button = button
    }

    function TabObject:AddSection(text)
        return AddSection(page,text)
    end

    function TabObject:AddButton(text)
        return AddButton(page,text)
    end

    function TabObject:AddToggle(text,default)
        return AddToggle(page,text,default)
    end

    function TabObject:AddTextBox(placeholder)
        return AddTextBox(page,placeholder)
    end

    return TabObject
end

function UI:SelectTab(name)
    local page = Pages[name]
    local button = TabButtons[name]

    if page and button then
        for tabName,p in pairs(Pages) do
            p.Visible = false
            local b = TabButtons[tabName]
            if b then
                b.BackgroundColor3 = Color3.fromRGB(14,14,17)
                b.TextColor3 = Color3.fromRGB(145,145,155)
            end
        end

        page.Visible = true
        button.BackgroundColor3 = Color3.fromRGB(32,32,38)
        button.TextColor3 = Color3.fromRGB(235,235,240)
    end
end

function UI:SetTitle(title,subtitle)
    Title.Text = title or Title.Text
    SubTitle.Text = subtitle or SubTitle.Text
end

function UI:Destroy()
    ScreenGui:Destroy()
end

-- Mobile-friendly dragging
local dragging = false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Mobile sizing
local function Resize()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize

    if UIS.TouchEnabled and viewport.X < 700 then
        local width = math.max(300, viewport.X - 20)
        local height = math.max(300, viewport.Y - 40)

        Main.Size = UDim2.new(
            0,
            math.min(width,650),
            0,
            math.min(height,430)
        )

        Main.Position = UDim2.new(
            0.5,
            -Main.Size.X.Offset/2,
            0.5,
            -Main.Size.Y.Offset/2
        )
    end
end

Resize()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)
end

return UI
