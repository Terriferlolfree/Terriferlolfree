local Settings = {
    Accent = Color3.fromHex("#90EE90"),
    Font = Enum.Font.SourceSans,
    IsBackgroundTransparent = true,
    Rounded = false,
    Dim = false,
    ItemColor = Color3.fromRGB(30, 30, 30),
    BorderColor = Color3.fromRGB(45, 45, 45),
    MinSize = Vector2.new(400, 370),
    MaxSize = Vector2.new(400, 370)
}

local Menu = {}
local Tabs = {}
local Items = {}
local EventObjects = {}
local Notifications = {}

local Scaling = {True = false, Origin = nil, Size = nil}
local Dragging = {Gui = nil, True = false}
local Draggables = {}
local ToolTip = {Enabled = false, Content = "", Item = nil}

local HotkeyRemoveKey = Enum.KeyCode.RightControl
local Selected = {
    Frame = nil,
    Item = nil,
    Offset = UDim2.new(),
    Follow = false
}
local SelectedTab
local SelectedTabLines = {}

local wait = task.wait
local delay = task.delay
local spawn = task.spawn
local protect_gui = function(Gui, Parent)
    if gethui and syn and syn.protect_gui then 
        Gui.Parent = gethui() 
    elseif not gethui and syn and syn.protect_gui then 
        syn.protect_gui(Gui)
        Gui.Parent = Parent 
    else 
        Gui.Parent = Parent 
    end
end

local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local __Menu = {}
setmetatable(Menu, {
    __index = function(self, Key) return __Menu[Key] end,
    __newindex = function(self, Key, Value)
        __Menu[Key] = Value
        if Key == "Hue" or Key == "ScreenSize" then return end
        for _, Object in pairs(EventObjects) do Object:Update() end
        for _, Notification in pairs(Notifications) do Notification:Update() end
    end
})

Menu.Accent = Settings.Accent
Menu.Font = Settings.Font
Menu.IsBackgroundTransparent = Settings.IsBackgroundTransparent
Menu.Rounded = Settings.IsRounded
Menu.Dim = Settings.IsDim
Menu.ItemColor = Settings.ItemColor
Menu.BorderColor = Settings.BorderColor
Menu.MinSize = Settings.MinSize
Menu.MaxSize = Settings.MaxSize

Menu.Hue = 0
Menu.IsVisible = false
Menu.ScreenSize = Vector2.new()

local function AddEventListener(self, Update)
    table.insert(EventObjects, {
        self = self,
        Update = Update
    })
end

local function CreateCorner(Parent, Pixels)
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "Corner"
    UICorner.Parent = Parent
    return UICorner
end

local function CreateStroke(Parent, Color, Thickness, Transparency)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "Stroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
    UIStroke.Color = Color or Color3.new()
    UIStroke.Thickness = Thickness or 1
    UIStroke.Transparency = Transparency or 0
    UIStroke.Enabled = true
    UIStroke.Parent = Parent
    return UIStroke
end

local function CreateLine(Parent, Size, Position, Color)
    local Line = Instance.new("Frame")
    Line.Name = "Line"
    Line.BackgroundColor3 = typeof(Color) == "Color3" and Color or Menu.Accent
    Line.BorderSizePixel = 0
    Line.Size = Size or UDim2.new(1, 0, 0, 1)
    Line.Position = Position or UDim2.new()
    Line.Parent = Parent
    if Line.BackgroundColor3 == Menu.Accent then
        AddEventListener(Line, function() Line.BackgroundColor3 = Menu.Accent end)
    end
    return Line
end

local function CreateLabel(Parent, Name, Text, Size, Position)
    local Label = Instance.new("TextLabel")
    Label.Name = Name
    Label.BackgroundTransparency = 1
    Label.Size = Size or UDim2.new(1, 0, 0, 15)
    Label.Position = Position or UDim2.new()
    Label.Font = Enum.Font.SourceSans
    Label.Text = Text or ""
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Parent
    return Label
end

local function UpdateSelected(Frame, Item, Offset)
    local Selected_Frame = Selected.Frame
    if Selected_Frame then
        Selected_Frame.Visible = false
        Selected_Frame.Parent = nil
    end
    Selected = {}
    if Frame then
        if Selected_Frame == Frame then return end
        Selected = {
            Frame = Frame,
            Item = Item,
            Offset = Offset
        }
        Frame.ZIndex = 3
        Frame.Visible = true
        Frame.Parent = Menu.Screen
    end
end

local function SetDraggable(self)
    table.insert(Draggables, self)
    local DragOrigin
    local GuiOrigin
    self.InputBegan:Connect(function(Input, Process)
        if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            for _, v in ipairs(Draggables) do
                v.ZIndex = 1
            end
            self.ZIndex = 2
            Dragging = {Gui = self, True = true}
            DragOrigin = Vector2.new(Input.Position.X, Input.Position.Y)
            GuiOrigin = self.Position
        end
    end)
    UserInput.InputChanged:Connect(function(Input, Process)
        if Dragging.Gui ~= self then return end
        if not (UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch)) then
            Dragging = {Gui = nil, True = false}
            return
        end
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - DragOrigin
            local ScreenSize = Menu.ScreenSize
            local ScaleX = (ScreenSize.X * GuiOrigin.X.Scale)
            local ScaleY = (ScreenSize.Y * GuiOrigin.Y.Scale)
            local OffsetX = math.clamp(GuiOrigin.X.Offset + Delta.X + ScaleX, 0, ScreenSize.X - self.AbsoluteSize.X)
            local OffsetY = math.clamp(GuiOrigin.Y.Offset + Delta.Y + ScaleY, -36, ScreenSize.Y - self.AbsoluteSize.Y)
            local Position = UDim2.fromOffset(OffsetX, OffsetY)
            self.Position = Position
        end
    end)
end

Menu.Screen = Instance.new("ScreenGui")
Menu.Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
protect_gui(Menu.Screen, CoreGui)
Menu.ScreenSize = Menu.Screen.AbsoluteSize

local Menu_Frame = Instance.new("Frame")
local MenuScaler_Button = Instance.new("TextButton")
local Title_Label = Instance.new("TextLabel")
local Icon_Image = Instance.new("ImageLabel")
local TabHandler_Frame = Instance.new("Frame")
local TabIndex_Frame = Instance.new("Frame")
local Tabs_Frame = Instance.new("Frame")

local Notifications_Frame = Instance.new("Frame")
local MenuDim_Frame = Instance.new("Frame")
local ToolTip_Label = Instance.new("TextLabel")
local Modal = Instance.new("TextButton")

Menu_Frame.Name = "Menu"
Menu_Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Menu_Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
Menu_Frame.BorderMode = Enum.BorderMode.Inset
Menu_Frame.Position = UDim2.new(0.5, -250, 0.5, -200)
Menu_Frame.Size = UDim2.new(0, 400, 0, 370)
Menu_Frame.Visible = false
Menu_Frame.Parent = Menu.Screen
CreateStroke(Menu_Frame, Color3.new(), 2)
CreateLine(Menu_Frame, UDim2.new(1, -8, 0, 1), UDim2.new(0, 4, 0, 15))
SetDraggable(Menu_Frame)

MenuScaler_Button.Name = "MenuScaler"
MenuScaler_Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MenuScaler_Button.BorderColor3 = Color3.fromRGB(40, 40, 40)
MenuScaler_Button.BorderSizePixel = 0
MenuScaler_Button.Position = UDim2.new(1, -15, 1, -15)
MenuScaler_Button.Size = UDim2.fromOffset(15, 15)
MenuScaler_Button.Font = Enum.Font.SourceSans
MenuScaler_Button.Text = ""
MenuScaler_Button.TextColor3 = Color3.new(1, 1, 1)
MenuScaler_Button.TextSize = 14
MenuScaler_Button.AutoButtonColor = false
MenuScaler_Button.Parent = Menu_Frame
MenuScaler_Button.InputBegan:Connect(function(Input, Process)
    if Process then return end
    if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSelected()
        Scaling = {
            True = true,
            Origin = Vector2.new(Input.Position.X, Input.Position.Y),
            Size = Menu_Frame.AbsoluteSize - Vector2.new(0, 36)
        }
    end
end)
MenuScaler_Button.InputEnded:Connect(function(Input, Process)
    if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSelected()
        Scaling = {
            True = false,
            Origin = nil,
            Size = nil
        }
    end
end)

Icon_Image.Name = "Icon"
Icon_Image.BackgroundTransparency = 1
Icon_Image.Position = UDim2.new(0, 5, 0, 0)
Icon_Image.Size = UDim2.fromOffset(15, 15)
Icon_Image.Image = "rbxassetid://0"
Icon_Image.Visible = false
Icon_Image.Parent = Menu_Frame

Title_Label.Name = "Title"
Title_Label.BackgroundTransparency = 1
Title_Label.Position = UDim2.new(0, 5, 0, 0)
Title_Label.Size = UDim2.new(1, -10, 0, 15)
Title_Label.Font = Enum.Font.SourceSans
Title_Label.Text = ""
Title_Label.TextColor3 = Color3.new(1, 1, 1)
Title_Label.TextSize = 14
Title_Label.TextXAlignment = Enum.TextXAlignment.Left
Title_Label.RichText = true
Title_Label.Parent = Menu_Frame

TabHandler_Frame.Name = "TabHandler"
TabHandler_Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabHandler_Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
TabHandler_Frame.BorderMode = Enum.BorderMode.Inset
TabHandler_Frame.Position = UDim2.new(0, 4, 0, 19)
TabHandler_Frame.Size = UDim2.new(1, -8, 1, -25)
TabHandler_Frame.Parent = Menu_Frame
CreateStroke(TabHandler_Frame, Color3.new(), 2)

TabIndex_Frame.Name = "TabIndex"
TabIndex_Frame.BackgroundTransparency = 1
TabIndex_Frame.Position = UDim2.new(0, 1, 0, 1)
TabIndex_Frame.Size = UDim2.new(1, -2, 0, 20)
TabIndex_Frame.Parent = TabHandler_Frame

Tabs_Frame.Name = "Tabs"
Tabs_Frame.BackgroundTransparency = 1
Tabs_Frame.Position = UDim2.new(0, 1, 0, 26)
Tabs_Frame.Size = UDim2.new(1, -2, 1, -25)
Tabs_Frame.Parent = TabHandler_Frame

Notifications_Frame.Name = "Notifications"
Notifications_Frame.BackgroundTransparency = 1
Notifications_Frame.Size = UDim2.new(1, 0, 1, 36)
Notifications_Frame.Position = UDim2.fromOffset(0, -36)
Notifications_Frame.ZIndex = 5
Notifications_Frame.Parent = Menu.Screen

ToolTip_Label.Name = "ToolTip"
ToolTip_Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToolTip_Label.BorderColor3 = Menu.BorderColor
ToolTip_Label.BorderMode = Enum.BorderMode.Inset
ToolTip_Label.AutomaticSize = Enum.AutomaticSize.XY
ToolTip_Label.Size = UDim2.fromOffset(0, 0, 0, 15)
ToolTip_Label.Text = ""
ToolTip_Label.TextSize = 14
ToolTip_Label.Font = Enum.Font.SourceSans
ToolTip_Label.TextColor3 = Color3.new(1, 1, 1)
ToolTip_Label.ZIndex = 5
ToolTip_Label.Visible = false
ToolTip_Label.Parent = Menu.Screen
CreateStroke(ToolTip_Label, Color3.new(), 1)
AddEventListener(ToolTip_Label, function()
    ToolTip_Label.BorderColor3 = Menu.BorderColor
end)

Modal.Name = "Modal"
Modal.BackgroundTransparency = 1
Modal.Modal = true
Modal.Text = ""
Modal.Parent = Menu_Frame

SelectedTabLines.Left = CreateLine(nil, UDim2.new(0, 1, 1, 0), UDim2.new(), Color3.new())
SelectedTabLines.Right = CreateLine(nil, UDim2.new(0, 1, 1, 0), UDim2.new(1, -1, 0, 0), Color3.new())
SelectedTabLines.Bottom = CreateLine(TabIndex_Frame, UDim2.new(), UDim2.new(0, 0, 1, 0), Color3.new())
SelectedTabLines.Bottom2 = CreateLine(TabIndex_Frame, UDim2.new(), UDim2.new(), Color3.new())

local function GetDictionaryLength(Dictionary)
    local Length = 0
    for _ in pairs(Dictionary) do
        Length += 1
    end
    return Length
end

local function UpdateSelectedTabLines(Tab)
    if not Tab then return end

    if (Tab.Button.AbsolutePosition.X > Tab.self.AbsolutePosition.X) then
        SelectedTabLines.Left.Visible = true
    else
        SelectedTabLines.Left.Visible = false
    end

    if (Tab.Button.AbsolutePosition.X + Tab.Button.AbsoluteSize.X < Tab.self.AbsolutePosition.X + Tab.self.AbsoluteSize.X) then
        SelectedTabLines.Right.Visible = true
    else
        SelectedTabLines.Right.Visible = false
    end

    SelectedTabLines.Left.Parent = Tab.Button
    SelectedTabLines.Right.Parent = Tab.Button

    local FRAME_POSITION = Tab.self.AbsolutePosition
    local BUTTON_POSITION = Tab.Button.AbsolutePosition
    local BUTTON_SIZE = Tab.Button.AbsoluteSize
    local LENGTH = BUTTON_POSITION.X - FRAME_POSITION.X
    local OFFSET = (BUTTON_POSITION.X + BUTTON_SIZE.X) - FRAME_POSITION.X

    SelectedTabLines.Bottom.Size = UDim2.new(0, LENGTH + 1, 0, 1)
    SelectedTabLines.Bottom2.Size = UDim2.new(1, -OFFSET, 0, 1)
    SelectedTabLines.Bottom2.Position = UDim2.new(0, OFFSET, 1, 0)
end

local function UpdateTabs()
    for _, Tab in pairs(Tabs) do
        Tab.Button.Size = UDim2.new(1 / GetDictionaryLength(Tabs), 0, 1, 0)
        Tab.Button.Position = UDim2.new((1 / GetDictionaryLength(Tabs)) * (Tab.Index - 1), 0, 0, 0)
    end
    UpdateSelectedTabLines(SelectedTab)
end

local function GetTab(Tab_Name)
    assert(Tab_Name, "NO TAB_NAME GIVEN")
    return Tabs[Tab_Name]
end

local function ChangeTab(Tab_Name)
    assert(Tabs[Tab_Name], "Tab "" .. tostring(Tab_Name) .. "" does not exist!")
    for _, Tab in pairs(Tabs) do
        Tab.self.Visible = false
        Tab.Button.BackgroundColor3 = Menu.ItemColor
        Tab.Button.TextColor3 = Color3.fromRGB(205, 205, 205)
    end
    local Tab = GetTab(Tab_Name)
    Tab.self.Visible = true
    Tab.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Tab.Button.TextColor3 = Color3.new(1, 1, 1)

    SelectedTab = Tab
    UpdateSelected()
    UpdateSelectedTabLines(Tab)
end

local function GetContainer(Tab_Name, Container_Name)
    assert(Tab_Name, "NO TAB_NAME GIVEN")
    assert(Container_Name, "NO CONTAINER NAME GIVEN")
    return GetTab(Tab_Name)[Container_Name]
end

-- Additional UI components and their respective functionality continue here...

function Menu:Init()
    UserInput.InputBegan:Connect(function(Input, Process) end)
    UserInput.InputEnded:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            Dragging = {Gui = nil, True = false}
        end
    end)
    RunService.RenderStepped:Connect(function(Step)
        local Menu_Frame = Menu.Screen.Menu
        Menu_Frame.Position = UDim2.fromOffset(
            math.clamp(Menu_Frame.AbsolutePosition.X, 0, math.clamp(Menu.ScreenSize.X - Menu_Frame.AbsoluteSize.X, 0, Menu.ScreenSize.X)),
            math.clamp(Menu_Frame.AbsolutePosition.Y, -36, math.clamp(Menu.ScreenSize.Y - Menu_Frame.AbsoluteSize.Y, 0, Menu.ScreenSize.Y - 36))
        )
        local Selected_Frame = Selected.Frame
        local Selected_Item = Selected.Item
        if (Selected_Frame and Selected_Item) then
            local Offset = Selected.Offset or UDim2.fromOffset()
            local Position = UDim2.fromOffset(Selected_Item.AbsolutePosition.X, Selected_Item.AbsolutePosition.Y)
            Selected_Frame.Position = Position + Offset
        end
        if Scaling.True then
            MenuScaler_Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            local Origin = Scaling.Origin
            local Size = Scaling.Size
            if Origin and Size then
                local Location = UserInput:GetMouseLocation()
                local NewSize = Location + (Size - Origin)
                Menu:SetSize(Vector2.new(
                    math.clamp(NewSize.X, Menu.MinSize.X, Menu.MaxSize.X),
                    math.clamp(NewSize.Y, Menu.MinSize.Y, Menu.MaxSize.Y)
                ))
            end
        else
            MenuScaler_Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        end
        Menu.Hue += math.clamp(Step / 100, 0, 1)
        if Menu.Hue >= 1 then Menu.Hue = 0 end
        if ToolTip.Enabled == true then
            ToolTip_Label.Text = ToolTip.Content
            ToolTip_Label.Position = UDim2.fromOffset(ToolTip.Item.AbsolutePosition.X, ToolTip.Item.AbsolutePosition.Y + 25)
        end
    end)
    Menu.Screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        Menu.ScreenSize = Menu.Screen.AbsoluteSize
    end)
end

function Menu:NameUpdate(waitTime, name, animatedText)
    while true do
        local PlaceHolder = ''
        for i = 1, #name do
            local Character = string.sub(name, i, i)
            PlaceHolder = PlaceHolder .. Character
            Menu:SetTitle(PlaceHolder .. '<font color="#90EE90">' .. animatedText .. '</font>')
            task.wait(waitTime)
        end
        for j = 1, #animatedText do
            local Character = string.sub(animatedText, j, j)
            Menu:SetTitle(PlaceHolder .. '<font color="#ADD8E6">' .. string.sub(animatedText, 1, j) .. '</font>')
            task.wait(waitTime)
        end
    end
end

local function MenuToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Menu:SetVisible(not Menu.IsVisible)
    end
end

return Menu
