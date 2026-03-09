--[[
    Swizy.Sense - Swizy.Lib
    Roblox UI Library
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    Flags = {},
    Elements = {},
    Connections = {},
    Themes = {
        Dark = {
            Main = Color3.fromRGB(25, 25, 25),
            Second = Color3.fromRGB(35, 35, 35),
            Third = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(0, 170, 255),
            Text = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(150, 150, 150),
            Stroke = Color3.fromRGB(60, 60, 60)
        }
    },
    CurrentTheme = "Dark"
}

local SwizyGui = Instance.new("ScreenGui")
SwizyGui.Name = "SwizySense"
SwizyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
SwizyGui.Parent = (syn and syn.protect_gui and syn.protect_gui(SwizyGui) or gethui and gethui() or game:GetService("CoreGui"))

local function AddConnection(Signal, Func)
    local Connection = Signal:Connect(Func)
    table.insert(Library.Connections, Connection)
    return Connection
end

local function Create(Class, Properties)
    local Object = Instance.new(Class)
    for i,v in pairs(Properties or {}) do
        Object[i] = v
    end
    return Object
end

local function MakeDraggable(DragPoint, Main)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPos

    AddConnection(DragPoint.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Main.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    AddConnection(DragPoint.InputChanged, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)

    AddConnection(UserInputService.InputChanged, function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Main.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)
end

local function CreateCorner(Radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, Radius or 6)
    })
end

local function CreateStroke(Color, Thickness)
    return Create("UIStroke", {
        Color = Color or Color3.fromRGB(60, 60, 60),
        Thickness = Thickness or 1
    })
end

local function CreatePadding(Amount)
    return Create("UIPadding", {
        PaddingLeft = UDim.new(0, Amount or 8),
        PaddingRight = UDim.new(0, Amount or 8),
        PaddingTop = UDim.new(0, Amount or 8),
        PaddingBottom = UDim.new(0, Amount or 8)
    })
end

function Library:CreateWindow(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Swizy.Lib"
    Config.Size = Config.Size or UDim2.new(0, 600, 0, 400)
    Config.Theme = Config.Theme or "Dark"

    local Window = {}
    local FirstTab = true

    local MainFrame = Create("Frame", {
        Parent = SwizyGui,
        BackgroundColor3 = Library.Themes[Config.Theme].Main,
        Size = Config.Size,
        Position = UDim2.new(0.5, -Config.Size.X.Offset/2, 0.5, -Config.Size.Y.Offset/2),
        ClipsDescendants = true
    })
    CreateCorner(8).Parent = MainFrame
    CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = MainFrame

    local TopBar = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Library.Themes[Config.Theme].Second,
        Size = UDim2.new(1, 0, 0, 40)
    })
    CreateCorner(8).Parent = TopBar
    CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = TopBar

    local Title = Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Text = Config.Name,
        TextColor3 = Library.Themes[Config.Theme].Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, -15, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabHolder = Create("ScrollingFrame", {
        Parent = MainFrame,
        BackgroundColor3 = Library.Themes[Config.Theme].Second,
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 0, 0, 45),
        ScrollBarThickness = 3,
        BorderSizePixel = 0
    })
    CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = TabHolder

    local TabLayout = Create("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local Padding = Create("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5)
    })

    local Container = Create("ScrollingFrame", {
        Parent = MainFrame,
        BackgroundColor3 = Library.Themes[Config.Theme].Main,
        Size = UDim2.new(1, -160, 1, -50),
        Position = UDim2.new(0, 155, 0, 45),
        ScrollBarThickness = 3,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    local ContainerLayout = Create("UIListLayout", {
        Parent = Container,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local ContainerPadding = Create("UIPadding", {
        Parent = Container,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })

    AddConnection(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 20)
    end)

    MakeDraggable(TopBar, MainFrame)

    function Window:AddTab(Name)
        local TabFrame = Create("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Library.Themes[Config.Theme].Third,
            Size = UDim2.new(1, -10, 0, 35),
            Text = Name,
            TextColor3 = Library.Themes[Config.Theme].Text,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            AutoButtonColor = false
        })
        CreateCorner(6).Parent = TabFrame
        CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = TabFrame

        local TabContainer = Create("ScrollingFrame", {
            Parent = Container,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })

        local TabLayout = Create("UIListLayout", {
            Parent = TabContainer,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        AddConnection(TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)

        if FirstTab then
            TabFrame.BackgroundColor3 = Library.Themes[Config.Theme].Accent
            TabContainer.Visible = true
            FirstTab = false
        end

        AddConnection(TabFrame.MouseButton1Click, function()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Library.Themes[Config.Theme].Third
                end
            end
            for _, v in pairs(Container:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabFrame.BackgroundColor3 = Library.Themes[Config.Theme].Accent
            TabContainer.Visible = true
        end)

        local Tab = {}

        function Tab:AddSection(Name)
            local SectionFrame = Create("Frame", {
                Parent = TabContainer,
                BackgroundColor3 = Library.Themes[Config.Theme].Second,
                Size = UDim2.new(1, 0, 0, 30)
            })
            CreateCorner(6).Parent = SectionFrame
            CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = SectionFrame

            local SectionTitle = Create("TextLabel", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Text = Name,
                TextColor3 = Library.Themes[Config.Theme].Accent,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 0, 30),
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SectionContainer = Create("Frame", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })

            local SectionLayout = Create("UIListLayout", {
                Parent = SectionContainer,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            AddConnection(SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 45)
            end)

            local Section = {}

            function Section:AddButton(Text, Callback)
                Callback = Callback or function() end

                local Button = Create("TextButton", {
                    Parent = SectionContainer,
                    BackgroundColor3 = Library.Themes[Config.Theme].Third,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = "",
                    AutoButtonColor = false
                })
                CreateCorner(6).Parent = Button
                CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = Button

                local ButtonText = Create("TextLabel", {
                    Parent = Button,
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Library.Themes[Config.Theme].Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ButtonIcon = Create("ImageLabel", {
                    Parent = Button,
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6031094678",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -25, 0.5, -10),
                    ImageColor3 = Library.Themes[Config.Theme].Accent
                })

                AddConnection(Button.MouseEnter, function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Library.Themes[Config.Theme].Accent}):Play()
                end)

                AddConnection(Button.MouseLeave, function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Library.Themes[Config.Theme].Third}):Play()
                end)

                AddConnection(Button.MouseButton1Click, Callback)

                local Btn = {}
                function Btn:Set(NewText)
                    ButtonText.Text = NewText
                end
                return Btn
            end

            function Section:AddToggle(Text, Default, Callback)
                Callback = Callback or function() end
                local State = Default or false

                local Toggle = Create("TextButton", {
                    Parent = SectionContainer,
                    BackgroundColor3 = Library.Themes[Config.Theme].Third,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = "",
                    AutoButtonColor = false
                })
                CreateCorner(6).Parent = Toggle
                CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = Toggle

                local ToggleText = Create("TextLabel", {
                    Parent = Toggle,
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Library.Themes[Config.Theme].Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ToggleBox = Create("Frame", {
                    Parent = Toggle,
                    BackgroundColor3 = State and Library.Themes[Config.Theme].Accent or Library.Themes[Config.Theme].Main,
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -45, 0.5, -10)
                })
                CreateCorner(10).Parent = ToggleBox

                local ToggleCircle = Create("Frame", {
                    Parent = ToggleBox,
                    BackgroundColor3 = Library.Themes[Config.Theme].Text,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                })
                CreateCorner(8).Parent = ToggleCircle

                local function UpdateVisual()
                    TweenService:Create(ToggleBox, TweenInfo.new(0.2), {BackgroundColor3 = State and Library.Themes[Config.Theme].Accent or Library.Themes[Config.Theme].Main}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                end

                AddConnection(Toggle.MouseButton1Click, function()
                    State = not State
                    UpdateVisual()
                    Callback(State)
                end)

                local Tgl = {}
                function Tgl:Set(Value)
                    State = Value
                    UpdateVisual()
                    Callback(State)
                end
                return Tgl
            end

            function Section:AddSlider(Text, Min, Max, Default, Callback)
                Callback = Callback or function() end
                local Value = Default or Min
                local Dragging = false

                local Slider = Create("Frame", {
                    Parent = SectionContainer,
                    BackgroundColor3 = Library.Themes[Config.Theme].Third,
                    Size = UDim2.new(1, 0, 0, 50),
                    ClipsDescendants = true
                })
                CreateCorner(6).Parent = Slider
                CreateStroke(Library.Themes[Config.Theme].Stroke, 1).Parent = Slider

                local SliderText = Create("TextLabel", {
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Library.Themes[Config.Theme].Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ValueLabel = Create("TextLabel", {
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Text = tostring(Value),
                    TextColor3 = Library.Themes[Config.Theme].Accent,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -60, 0, 5)
                })

                local SliderBar = Create("Frame", {
                    Parent = Slider,
                    BackgroundColor3 = Library.Themes[Config.Theme].Main,
                    Size = UDim2.new(1, -20, 0, 10),
                    Position = UDim2.new(0, 10, 0, 30)
                })
                CreateCorner(5).Parent = SliderBar

                local FillBar = Create("Frame", {
                    Parent = SliderBar,
                    BackgroundColor3 = Library.Themes[Config.Theme].Accent,
                    Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                })
                CreateCorner(5).Parent = FillBar

                AddConnection(SliderBar.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                    end
                end)

                AddConnection(SliderBar.InputEnded, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)

                AddConnection(UserInputService.InputChanged, function(Input)
                    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local Percentage = (Mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        Percentage = math.clamp(Percentage, 0, 1)
                        Value = Min + (Max - Min) * Percentage
                        Value = math.floor(Value * 100) / 100
                        ValueLabel.Text = tostring(Value)
                        FillBar.Size = UDim2.new(Percentage, 0, 1, 0)
                        Callback(Value)
                    end
                end)

                local Sld = {}
                function Sld:Set(NewValue)
                    Value = math.clamp(NewValue, Min, Max)
                    ValueLabel.Text = tostring(Value)
                    FillBar.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                    Callback(Value)
                end
                return Sld
            end

            return Section
        end

        return Tab
    end

    return Window
end

function Library:Destroy()
    for _, Connection in pairs(self.Connections) do
        Connection:Disconnect()
    end
    SwizyGui:Destroy()
end

return Library