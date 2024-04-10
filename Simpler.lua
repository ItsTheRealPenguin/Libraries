--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")


--// Vars
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Textures = {
    ["Panel"] = "http://www.roblox.com/asset/?id=17084007357",
    ["Background"] = "http://www.roblox.com/asset/?id=17084005858",
    ["Shadow"] = "http://www.roblox.com/asset/?id=16012467267",
    ["Scrollframe"] = {
        ["Top"] = "http://www.roblox.com/asset/?id=16530731115",
        ["Middle"] = "http://www.roblox.com/asset/?id=16530729571",
        ["Bottom"] = "http://www.roblox.com/asset/?id=16530728356"
    }
}


--// Functions
local function Draggable(Object: Frame)
    Object.Active = true
    Object.Draggable = true
end
local function GetParent()
    return (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui"))or gethui()
end
local function lowerString(val)
    return ((type(val) == "string" and val or tostring(val))):lower()
end


--// Classes
local library = {}
library.__index = library


--// Init classes
function library.new()
    local self = setmetatable({
        Elements = {},
        Colors = {
            Text = {
                TabAcent = Color3.fromRGB(255, 255, 255),
                TabDef = Color3.fromRGB(50, 50, 50),
                PageAcent = Color3.fromRGB(200, 200, 200),
                PageDef = Color3.fromRGB(90, 90, 90)
            },
            Background = {
                Color3.fromRGB(16, 123, 255),
                Color3.fromRGB(25, 25, 25),
            }
        },
        Pages = {},
        Signals = {},
        Settings = {
            Toggle = Enum.KeyCode.LeftAlt,
            Hidden = false,
            Size = UDim2.fromOffset(600, 350)
        }
    }, library)
    return self
end


--// Int class methods
function library.isActivePage(self, ref: string)
    local _data = self._metaclass or self

    for _, v in next, _data.Elements do
        if (type(_) == "number" or type(_) == "string" and type(v) == "table") then
            if (v.RefId == ref or _ == ref) then
                if v.Page and v.Page.Visible then
                    return true
                else
                    continue
                end
            end
        else
            continue
        end
    end
end
function library.SetPageEnabled(self, ref: number | string)
    local _data = self._metaclass or self

    for _, v in next, _data.Elements do
        if (type(_) == "number" or type(_) == "string" and type(v) == "table") then
            local Tab = v.Tab
            local Title = v.Title
            local Page = v.Page


            if (v.RefId == ref or _ == ref) then
                local BackgroundTween = Tab and TweenService:Create(Tab, TweenInfo.new(0.250), {ImageColor3 = _data.Colors.Background[1]}):Play()
                local TextTween = Title and TweenService:Create(Title, TweenInfo.new(0.250), {TextColor3 = _data.Colors.Text.TabAcent}):Play()

                if (BackgroundTween and TextTween) then
                    BackgroundTween:Play()
                    TextTween:Play()
                end
                if Page then Page.Visible = true end
            end
            if (v.RefId ~= ref and _ ~= ref) then
                local BackgroundTween = Tab and TweenService:Create(Tab, TweenInfo.new(0.250), {ImageColor3 = _data.Colors.Background[2]}):Play()
                local TextTween = Title and TweenService:Create(Title, TweenInfo.new(0.250), {TextColor3 = _data.Colors.Text.TabDef}):Play()

                if (Page and BackgroundTween and TextTween) then
                    BackgroundTween:Play()
                    TextTween:Play()
                end
                if Page then Page.Visible = false end
            end
        end
    end
end


--// Init interface window
function library:Window(_title: string, _subtitle: string, _keybind: Enum.KeyCode?, Hidden: boolean?, Size: {x: number, y: number}?)
    --// Init class within our window :)
    local class = library.new()


    --// ScreenGuis
    local UI = Instance.new("ScreenGui", GetParent())


    --// UI Elements
    local Window = Instance.new("ImageLabel", UI)
    local Shadow = Instance.new("ImageLabel", Window)
    local Side = Instance.new("ImageLabel", Window)
    local Title = Instance.new("TextLabel", Side)
    local Subtitle = Instance.new("TextLabel", Side)
    local Tabs = Instance.new("Frame", Side)
    local TabContainerList = Instance.new("ScrollingFrame", Tabs)

    local UIListLayout = Instance.new("UIListLayout", TabContainerList)
    local UIPadding = Instance.new("UIPadding", TabContainerList)


    --// Add elements to class & keybind
    class.Settings.Toggle = ((typeof(_keybind) == "EnumItem" and Enum.KeyCode[_keybind.Name]) and _keybind)or class.Settings.Toggle
    class.Elements.UI = UI
    class.Elements.Window = Window
    class.Elements.TabContainerList = TabContainerList


    --// Element properties
    UI.Name = "A-REAL-LIBRARY"
    UI.Enabled = (type(Hidden) == "boolean" and Hidden)or class.Settings.Hidden
    UI.IgnoreGuiInset = true
    UI.ZIndexBehavior = Enum.ZIndexBehavior.Global


    Window.Name = "Window"
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.Position = UDim2.fromScale(0.5, 0.5)
    Window.Size = (type(Size) == "table" and Size.x and Size.y and UDim2.fromOffset(Size.x, Size.y))or class.Settings.Size
    Window.Image = Textures.Background

    Window.ImageColor3 = Color3.fromRGB(20, 20, 20)
    Window.BackgroundTransparency = 1

    Draggable(Window)

    Side.Name = "Side"
    Side.AnchorPoint = Vector2.new(0, 0.5)
    Side.Position = UDim2.fromScale(0, 0.5)
    Side.Size = UDim2.fromScale(0.25, 1)
    Side.Image = Textures.Panel
    Side.ImageColor3 = class.Colors.Background[2]
    Side.BackgroundTransparency = 1


    Title.Name = "Title"
    Subtitle.Name = "Subtitle"

    Title.TextColor3 = Color3.fromRGB(225, 225, 225)
    Subtitle.TextColor3 = Color3.fromRGB(75, 75, 75)

    Title.Font = Enum.Font.SourceSansSemibold
    Subtitle.Font = Enum.Font.SourceSansSemibold

    Title.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    Title.TextSize = 20
    Subtitle.TextSize = 18

    Title.Text = _title
    Subtitle.Text = lowerString(_subtitle)

    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.5, 0.06)
    Subtitle.Position = UDim2.fromScale(0.5, 0.1)

    Title.Size = UDim2.fromScale(0.75, 0.08)
    Subtitle.Size = UDim2.fromScale(0.75, 0.08)

    Title.BackgroundTransparency = 1
    Subtitle.BackgroundTransparency = 1


    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.fromScale(0.5, 0.5)
    Shadow.Size = UDim2.fromScale(1.3, 1.3)
    Shadow.Image = Textures.Shadow
    Shadow.ZIndex = 0
    Shadow.BackgroundTransparency = 1


    Tabs.Name = "Tabs"
    Tabs.AnchorPoint = Vector2.new(0.5, 0.5)
    Tabs.Position = UDim2.fromScale(0.5, 0.56)
    Tabs.Size = UDim2.fromScale(0.85, 0.8)
    Tabs.BackgroundTransparency = 1


    TabContainerList.Name = "Container"
    TabContainerList.AnchorPoint = Vector2.new(0.5, 0.5)
    TabContainerList.Position = UDim2.fromScale(0.5, 0.5)
    TabContainerList.Size = UDim2.fromScale(1, 1)
    TabContainerList.CanvasSize = UDim2.fromScale(0, 1)
    TabContainerList.ScrollBarThickness = 0
    TabContainerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainerList.BackgroundTransparency = 1

    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    UIPadding.PaddingTop = UDim.new(0, 1)


    --// Events
    UserInputService.InputBegan:Connect(function(input, event)
        if (not event and input.KeyCode == class.Settings.Toggle) then
            class.Elements.UI.Enabled = not class.Elements.UI.Enabled
        end
    end)
    

    return class
end


--// Create tab methods:
function library:Tab(Text: string)
    --// Creating elements
    local Tab = Instance.new("ImageLabel", self.Elements.TabContainerList)
    local Page = Instance.new("ScrollingFrame", self.Elements.Window)

    local Title = Instance.new("TextLabel", Tab)
    local Trigger = Instance.new("TextButton", Tab)

    local UIListLayout = Instance.new("UIListLayout", Page)
    local UIPadding = Instance.new("UIPadding", Page)
    local UICorner = Instance.new("UICorner", Tab)


    --// Adding elements to page
    self.Pages[Text] = {
        RefId = Text,
        Tab = Tab,
        Page = Page,
        Title = Title
    }
    self.Elements[#self.Elements + 1] = self.Pages[Text]


    --// Element properties
    Tab.Name = Text
    Page.Name = Text

    Page.AnchorPoint = Vector2.new(0.5, 0.5)
    Page.Position = UDim2.fromScale(0.625, 0.5)
    Page.Size = UDim2.fromScale(0.72, 0.95)
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(225, 225, 255)
    Page.TopImage = Textures.Scrollframe.Top
    Page.MidImage = Textures.Scrollframe.Middle
    Page.BottomImage = Textures.Scrollframe.Bottom
    Page.CanvasSize = UDim2.fromScale(0, 1)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.BorderSizePixel = 0
    Page.BackgroundTransparency = 1
    Page.Visible = false


    Tab.AnchorPoint = Vector2.new(0.5, 0.5)
    Tab.Size = UDim2.fromScale(0.94, 0.1)
    Tab.ImageColor3 = self.Colors.Background[2]
    Tab.Image = Textures.Background
    Tab.BackgroundTransparency = 1

    Title.Name = "Title"
    Title.TextColor3 = self.Colors.Text.TabDef
    Title.Font = Enum.Font.SourceSans
    Title.TextSize = 20
    Title.Text = Text
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.5, 0.5)
    Title.Size = UDim2.fromScale(0.75, 0.8)
    Title.BackgroundTransparency = 1

    Trigger.Name = "Trigger"
    Trigger.Text = ""
    Trigger.AnchorPoint = Vector2.new(0.5, 0.5)
    Trigger.Position = UDim2.fromScale(0.5, 0.5)
    Trigger.Size = UDim2.fromScale(1, 1)
    Trigger.BackgroundTransparency = 1

    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    UICorner.CornerRadius = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 1)


    --// Events
    Trigger.MouseButton1Click:Connect(function()
        self:SetPageEnabled(Text)
    end)
    Trigger.MouseEnter:Connect(function()
        if self:isActivePage(Text) then
            return;
        end
        TweenService:Create(
            Title,
            TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
            { TextColor3 = Color3.fromRGB(150, 150, 150) }
        ):Play()
    end)
    Trigger.MouseLeave:Connect(function()
        if self:isActivePage(Text) then
            return;
        end
        TweenService:Create(
            Title,
            TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
            { TextColor3 = self.Colors.Text.TabDef }
        ):Play()
    end)


    --// New class
    return setmetatable({
        Data = {
            Tab = Tab,
            Page = Page,
            Trigger = Trigger
        },
        _metaclass = self
    }, library)
end


--// Create tab element methods:
function library:Label(Text: string)
    --// Creating elements
    local Label = Instance.new("ImageLabel", self.Data.Page)
    local Title = Instance.new("TextLabel", Label)

    local UIStroke = Instance.new("UIStroke", Label)
    local UICorner = Instance.new("UICorner", Label)


    --// Element properties
    Label.Name = Text
    Label.AnchorPoint = Vector2.new(0.5, 0.5)
    Label.Size = UDim2.fromScale(0.94, 0.1)
    Label.ImageColor3 = self._metaclass.Colors.Background[2]
    Label.Image = Textures.Background
    Label.BackgroundTransparency = 1

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(90, 90, 90)
    UICorner.CornerRadius = UDim.new(0, 8)

    Title.Name = "Title"
    Title.Text = Text
    Title.Font = Enum.Font.SourceSansSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 18
    Title.TextColor3 = self._metaclass.Colors.Text.PageDef

    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.475, 0.5)
    Title.Size = UDim2.fromScale(0.9, 0.8)
    Title.BackgroundTransparency = 1
end


--// Tab elements method
function library:Button(Text: string, Callback: ()->())
    --// Creating elements
    local Button = Instance.new("ImageLabel", self.Data.Page)
    local Title = Instance.new("TextLabel", Button)
    local Type = Instance.new("TextLabel", Button)
    local Trigger = Instance.new("TextButton", Button)

    local UIStroke = Instance.new("UIStroke", Button)
    local UICorner = Instance.new("UICorner", Button)


    --// Element properties
    Button.Name = Text
    Button.AnchorPoint = Vector2.new(0.5, 0.5)
    Button.Size = UDim2.fromScale(0.94, 0.1)
    Button.ImageColor3 = self._metaclass.Colors.Background[2]
    Button.Image = Textures.Background
    Button.BackgroundTransparency = 1

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(90, 90, 90)
    UICorner.CornerRadius = UDim.new(0, 8)

    Title.Name = "Title"
    Title.Text = Text
    Title.Font = Enum.Font.SourceSansSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 18
    Title.TextColor3 = self._metaclass.Colors.Text.PageDef

    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.475, 0.5)
    Title.Size = UDim2.fromScale(0.9, 0.8)
    Title.BackgroundTransparency = 1

    Type.Name = "Type"
    Type.Text = "button"
    Type.TextSize = 14
    Type.TextColor3 = Color3.fromRGB(40, 40, 40)
    Type.Font = Enum.Font.SourceSansSemibold

    Type.AnchorPoint = Vector2.new(0.5, 0.5)
    Type.Position = UDim2.fromScale(0.92, 0.5)
    Type.Size = UDim2.fromScale(0.1, 0.8)
    Type.BackgroundTransparency = 1

    Trigger.Name = "Trigger"
    Trigger.Text = ""
    Trigger.AnchorPoint = Vector2.new(0.5, 0.5)
    Trigger.Position = UDim2.fromScale(0.5, 0.5)
    Trigger.Size = UDim2.fromScale(1, 1)
    Trigger.BackgroundTransparency = 1


    --// Events
    Trigger.MouseButton1Click:Connect(function()
        Callback()
    end)
end

function library:Switch(Text: string, State: boolean, Callback: (value: boolean)->())
    --// Creating elements
    local Button = Instance.new("ImageLabel", self.Data.Page)
    local Title = Instance.new("TextLabel", Button)
    local Switch = Instance.new("Frame", Button)
    local Pointer = Instance.new("Frame", Switch)
    local Trigger = Instance.new("TextButton", Button)

    local PointerCorner = Instance.new("UICorner", Pointer)
    local SwitchCorner = Instance.new("UICorner", Switch)
    local SwitchStroke = Instance.new("UIStroke", Switch)

    local UIStroke = Instance.new("UIStroke", Button)
    local UICorner = Instance.new("UICorner", Button)

    --// Vars
    local isActive = State

    local tweenInfo = TweenInfo.new(0.500, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local TweenInPointer = TweenService:Create(Pointer, tweenInfo, {Position = UDim2.fromScale(0.3, 0.5)})
    local TweenOutPointer = TweenService:Create(Pointer, tweenInfo, {Position = UDim2.fromScale(0.7, 0.5)})
    local TweenInSwitch = TweenService:Create(Switch, tweenInfo, {BackgroundColor3 = self._metaclass.Colors.Background[2]})
    local TweenOutSwitch = TweenService:Create(Switch, tweenInfo, {BackgroundColor3 = self._metaclass.Colors.Background[1]})

    --// Element properties
    Button.Name = Text
    Button.AnchorPoint = Vector2.new(0.5, 0.5)
    Button.Size = UDim2.fromScale(0.94, 0.1)
    Button.ImageColor3 = self._metaclass.Colors.Background[2]
    Button.Image = Textures.Background
    Button.BackgroundTransparency = 1

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(90, 90, 90)
    UICorner.CornerRadius = UDim.new(0, 8)

    Title.Name = "Title"
    Title.Text = Text
    Title.Font = Enum.Font.SourceSansSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 18
    Title.TextColor3 = self._metaclass.Colors.Text.PageDef

    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.475, 0.5)
    Title.Size = UDim2.fromScale(0.9, 0.8)
    Title.BackgroundTransparency = 1

    Switch.Name = "Switch"
    Switch.AnchorPoint = Vector2.new(0.5, 0.5)
    Switch.Position = UDim2.fromScale(0.92, 0.5)
    Switch.Size = UDim2.fromScale(0.1, 0.5)
    Switch.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    Pointer.Name = "Pointer"
    Pointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Pointer.AnchorPoint = Vector2.new(0.5, 0.5)
    Pointer.Position = UDim2.fromScale(0.3, 0.5)
    Pointer.Size = UDim2.fromOffset(9, 9)

    PointerCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.CornerRadius = UDim.new(0, 5)
    SwitchStroke.Color = Color3.fromRGB(18, 18, 18)

    Trigger.Name = "Trigger"
    Trigger.Text = ""
    Trigger.AnchorPoint = Vector2.new(0.5, 0.5)
    Trigger.Position = UDim2.fromScale(0.5, 0.5)
    Trigger.Size = UDim2.fromScale(1, 1)
    Trigger.BackgroundTransparency = 1


    --// Events
    Trigger.MouseButton1Click:Connect(function()
        isActive = not isActive
        Callback(isActive)

        if isActive then
            TweenOutPointer:Play()
            TweenOutSwitch:Play()
            SwitchStroke.Enabled = false
        else
            TweenInPointer:Play()
            TweenInSwitch:Play()
            SwitchStroke.Enabled = true
        end
    end)
end

function library:Toggle(Text: string, State: boolean, Callback: (value: boolean)->())
    --// Creating elements
    local Button = Instance.new("ImageLabel", self.Data.Page)
    local Title = Instance.new("TextLabel", Button)
    local Toggle = Instance.new("Frame", Button)
    local Trigger = Instance.new("TextButton", Button)

    local ToggleCorner = Instance.new("UICorner", Toggle)
    local ToggleStroke = Instance.new("UIStroke", Toggle)

    local UIStroke = Instance.new("UIStroke", Button)
    local UICorner = Instance.new("UICorner", Button)

    --// Vars
    local isActive = State

    local tweenInfo = TweenInfo.new(0.500, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local TweenInToggle = TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = self._metaclass.Colors.Background[1]})
    local TweenOutToggle = TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = self._metaclass.Colors.Background[2]})

    --// Element properties
    Button.Name = Text
    Button.AnchorPoint = Vector2.new(0.5, 0.5)
    Button.Size = UDim2.fromScale(0.94, 0.1)
    Button.ImageColor3 = self._metaclass.Colors.Background[2]
    Button.Image = Textures.Background
    Button.BackgroundTransparency = 1

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(90, 90, 90)
    UICorner.CornerRadius = UDim.new(0, 5)

    Title.Name = "Title"
    Title.Text = Text
    Title.Font = Enum.Font.SourceSansSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 18
    Title.TextColor3 = self._metaclass.Colors.Text.PageDef

    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.475, 0.5)
    Title.Size = UDim2.fromScale(0.9, 0.8)
    Title.BackgroundTransparency = 1

    Toggle.Name = "Toggle"
    Toggle.AnchorPoint = Vector2.new(0.5, 0.5)
    Toggle.Position = UDim2.fromScale(0.95, 0.5)
    Toggle.Size = UDim2.fromOffset(20, 20)
    Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    ToggleCorner.CornerRadius = UDim.new(0, 5)
    ToggleStroke.Color = Color3.fromRGB(18, 18, 18)

    Trigger.Name = "Trigger"
    Trigger.Text = ""
    Trigger.AnchorPoint = Vector2.new(0.5, 0.5)
    Trigger.Position = UDim2.fromScale(0.5, 0.5)
    Trigger.Size = UDim2.fromScale(1, 1)
    Trigger.BackgroundTransparency = 1


    --// Events
    Trigger.MouseButton1Click:Connect(function()
        isActive = not isActive
        Callback(isActive)

        if isActive then
            TweenInToggle:Play()
            ToggleStroke.Enabled = false
        else
            TweenOutToggle:Play()
            ToggleStroke.Enabled = true
        end
    end)
end



--// Select default page (WINDOW);
function library:SelectPage(ref: number)
    self:SetPageEnabled(ref)
end


--// Cleanp (returns: success, error?) => boolean, string->possibly a string if ERROR;
function library:Unload(): (boolean, string?)
    return pcall(function()
        --// Destroy & clear (Interface & class)
        self.Elements.UI:Destroy()
        table.clear(getmetatable(self))
    end)
end


return library
