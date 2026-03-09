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
local HttpService = game:GetService("HttpService")

local Library = {
    Flags = {},
    Elements = {},
    Connections = {},
    Themes = {
        Dark = {
            Main = Color3.fromRGB(8, 8, 8),
            Second = Color3.fromRGB(15, 15, 15),
            Third = Color3.fromRGB(22, 22, 22),
            Accent = Color3.fromRGB(0, 170, 255),
            Text = Color3.fromRGB(245, 245, 245),
            TextDark = Color3.fromRGB(130, 130, 130),
            Stroke = Color3.fromRGB(40, 40, 40)
        }
    },
    CurrentTheme = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,
    MenuVisible = true,
    MainFrame = nil,
    OriginalSize = nil,
    NotificationHolder = nil
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
        Color = Color or Color3.fromRGB(40, 40, 40),
        Thickness = Thickness or 1
    })
end

-- Метод для создания уведомлений
function Library:MakeNotification(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Notification"
    Config.Content = Config.Content or "Message"
    Config.Time = Config.Time or 5

    if not self.NotificationHolder then
        self.NotificationHolder = Create("Frame", {
            Parent = SwizyGui,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -320, 1, -20),
            Size = UDim2.new(0, 300, 1, -40),
            AnchorPoint = Vector2.new(1, 1)
        })
        
        Create("UIListLayout", {
            Parent = self.NotificationHolder,
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    end

    local Notification = Create("Frame", {
        Parent = self.NotificationHolder,
        BackgroundColor3 = self.Themes[self.CurrentTheme].Second,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(1, 20, 0, 0),
        ClipsDescendants = true,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    CreateCorner(6).Parent = Notification
    CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = Notification

    Create("UIPadding", {
        Parent = Notification,
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12)
    })

    local Title = Create("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Text = Config.Name,
        TextColor3 = self.Themes[self.CurrentTheme].Accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 20)
    })

    local Content = Create("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Text = Config.Content,
        TextColor3 = self.Themes[self.CurrentTheme].Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true,
        Position = UDim2.new(0, 0, 0, 25)
    })

    local ProgressBar = Create("Frame", {
        Parent = Notification,
        BackgroundColor3 = self.Themes[self.CurrentTheme].Accent,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2)
    })

    Notification.Size = UDim2.new(1, 0, 0, Title.TextBounds.Y + Content.TextBounds.Y + 40)

    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(ProgressBar, TweenInfo.new(Config.Time, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

    task.delay(Config.Time - 0.3, function()
        TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 20, 0, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(Content, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(ProgressBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.delay(0.4, Notification.Destroy, Notification)
    end)
end

-- Метод для создания диалогового окна
function Library:MakePrompt(Config)
    Config = Config or {}
    Config.Title = Config.Title or "Prompt"
    Config.Text = Config.Text or "Are you sure?"
    Config.Buttons = Config.Buttons or {"OK", "Cancel"}
    Config.Callback = Config.Callback or function() end

    local Overlay = Create("Frame", {
        Parent = SwizyGui,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1000
    })

    local Prompt = Create("Frame", {
        Parent = Overlay,
        BackgroundColor3 = self.Themes[self.CurrentTheme].Second,
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(0.5, -150, 0.5, -75),
        ZIndex = 1001,
        ClipsDescendants = true
    })
    CreateCorner(8).Parent = Prompt
    CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = Prompt

    local Title = Create("TextLabel", {
        Parent = Prompt,
        BackgroundTransparency = 1,
        Text = Config.Title,
        TextColor3 = self.Themes[self.CurrentTheme].Accent,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 10)
    })

    local Text = Create("TextLabel", {
        Parent = Prompt,
        BackgroundTransparency = 1,
        Text = Config.Text,
        TextColor3 = self.Themes[self.CurrentTheme].Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 45),
        TextWrapped = true
    })

    local ButtonFrame = Create("Frame", {
        Parent = Prompt,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 1, -40)
    })

    local ButtonWidth = 280 / #Config.Buttons

    for i, ButtonText in ipairs(Config.Buttons) do
        local Button = Create("TextButton", {
            Parent = ButtonFrame,
            BackgroundColor3 = self.Themes[self.CurrentTheme].Third,
            Size = UDim2.new(0, ButtonWidth - 10, 0, 30),
            Position = UDim2.new(0, 5 + (i-1) * (ButtonWidth + 5), 0, 2.5),
            Text = ButtonText,
            TextColor3 = self.Themes[self.CurrentTheme].Text,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            AutoButtonColor = false,
            ZIndex = 1002
        })
        CreateCorner(6).Parent = Button
        CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = Button

        AddConnection(Button.MouseEnter, function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Accent}):Play()
        end)

        AddConnection(Button.MouseLeave, function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Third}):Play()
        end)

        AddConnection(Button.MouseButton1Click, function()
            Config.Callback(ButtonText)
            TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Prompt, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
            task.delay(0.3, Overlay.Destroy, Overlay)
        end)
    end

    TweenService:Create(Prompt, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 150)}):Play()
end

-- Метод для переключения видимости меню
function Library:ToggleMenu(State)
    if State ~= nil then
        self.MenuVisible = State
    else
        self.MenuVisible = not self.MenuVisible
    end

    if self.MainFrame then
        if self.MenuVisible then
            self.MainFrame.Visible = true
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = self.OriginalSize,
                BackgroundTransparency = 0
            }):Play()
        else
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            task.delay(0.3, function()
                if self.MainFrame then
                    self.MainFrame.Visible = false
                end
            end)
        end
    end
end

-- Горячая клавиша
AddConnection(UserInputService.InputBegan, function(Input)
    if Input.KeyCode == Library.ToggleKey and not UserInputService:GetFocusedTextBox() then
        Library:ToggleMenu()
    end
end)

function Library:CreateWindow(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Swizy.Lib"
    Config.Size = Config.Size or UDim2.new(0, 650, 0, 450)

    local Window = {}
    local FirstTab = true

    self.OriginalSize = Config.Size

    -- Интро анимация
    local IntroOverlay = Create("Frame", {
        Parent = SwizyGui,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0,
        ZIndex = 999
    })

    local IntroContainer = Create("Frame", {
        Parent = SwizyGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 250, 0, 120),
        Position = UDim2.new(0.5, -125, 0.5, -60),
        ZIndex = 1000
    })

    local IntroIcon = Create("ImageLabel", {
        Parent = IntroContainer,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094678",
        Size = UDim2.new(0, 70, 0, 70),
        Position = UDim2.new(0.5, -35, 0, 0),
        ImageColor3 = self.Themes[self.CurrentTheme].Accent,
        ImageTransparency = 0,
        ZIndex = 1000
    })

    local IntroText = Create("TextLabel", {
        Parent = IntroContainer,
        BackgroundTransparency = 1,
        Text = "Swizy.Lib",
        TextColor3 = self.Themes[self.CurrentTheme].Text,
        TextSize = 28,
        Font = Enum.Font.GothamBlack,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 75),
        ZIndex = 1000
    })

    -- Анимация интро
    TweenService:Create(IntroIcon, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, -40, 0, -5)
    }):Play()

    TweenService:Create(IntroText, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        TextTransparency = 0,
        Position = UDim2.new(0, 0, 0, 80)
    }):Play()

    -- Главное окно (создаем сразу, но скрытое)
    local MainFrame = Create("Frame", {
        Parent = SwizyGui,
        BackgroundColor3 = self.Themes[self.CurrentTheme].Main,
        Size = Config.Size,
        Position = UDim2.new(0.5, -Config.Size.X.Offset/2, 0.5, -Config.Size.Y.Offset/2),
        ClipsDescendants = true,
        Visible = false
    })
    CreateCorner(10).Parent = MainFrame
    CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = MainFrame

    self.MainFrame = MainFrame

    -- Top Bar
    local TopBar = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = self.Themes[self.CurrentTheme].Second,
        Size = UDim2.new(1, 0, 0, 45)
    })
    CreateCorner(10).Parent = TopBar
    CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = TopBar

    local Title = Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Text = Config.Name,
        TextColor3 = self.Themes[self.CurrentTheme].Accent,
        TextSize = 20,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, -15, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local CloseBtn = Create("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0.5, -15),
        Text = "X",
        TextColor3 = self.Themes[self.CurrentTheme].Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })

    AddConnection(CloseBtn.MouseButton1Click, function()
        self:ToggleMenu(false)
    end)

    -- Tab Holder
    local TabHolder = Create("ScrollingFrame", {
        Parent = MainFrame,
        BackgroundColor3 = self.Themes[self.CurrentTheme].Second,
        Size = UDim2.new(0, 160, 1, -60),
        Position = UDim2.new(0, 0, 0, 50),
        ScrollBarThickness = 3,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 5, 0)
    })
    CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = TabHolder

    local TabLayout = Create("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Create("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8)
    })

    -- Container
    local Container = Create("ScrollingFrame", {
        Parent = MainFrame,
        BackgroundColor3 = self.Themes[self.CurrentTheme].Main,
        Size = UDim2.new(1, -180, 1, -60),
        Position = UDim2.new(0, 170, 0, 50),
        ScrollBarThickness = 4,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    local ContainerLayout = Create("UIListLayout", {
        Parent = Container,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Create("UIPadding", {
        Parent = Container,
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12)
    })

    AddConnection(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 24)
    end)

    MakeDraggable(TopBar, MainFrame)

    -- Завершение интро и показ меню
    task.delay(2, function()
        TweenService:Create(IntroIcon, TweenInfo.new(0.4), {ImageTransparency = 1, Size = UDim2.new(0, 90, 0, 90)}):Play()
        TweenService:Create(IntroText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(IntroOverlay, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        task.delay(0.5, function()
            if IntroContainer then IntroContainer:Destroy() end
            if IntroOverlay then IntroOverlay:Destroy() end
            if MainFrame then MainFrame.Visible = true end
        end)
    end)

    function Window:AddTab(Name)
        local TabFrame = Create("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = self.Themes[self.CurrentTheme].Third,
            Size = UDim2.new(1, -16, 0, 38),
            Text = "",
            AutoButtonColor = false
        })
        CreateCorner(8).Parent = TabFrame
        CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = TabFrame

        local TabTitle = Create("TextLabel", {
            Parent = TabFrame,
            BackgroundTransparency = 1,
            Text = Name,
            TextColor3 = self.Themes[self.CurrentTheme].Text,
            TextSize = 15,
            Font = Enum.Font.GothamSemibold,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })

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
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        AddConnection(TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)

        if FirstTab then
            TabFrame.BackgroundColor3 = self.Themes[self.CurrentTheme].Accent
            TabContainer.Visible = true
            FirstTab = false
        end

        AddConnection(TabFrame.MouseButton1Click, function()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Third}):Play()
                end
            end
            for _, v in pairs(Container:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TweenService:Create(TabFrame, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Accent}):Play()
            TabContainer.Visible = true
        end)

        local Tab = {}

        function Tab:AddSection(Name)
            local SectionFrame = Create("Frame", {
                Parent = TabContainer,
                BackgroundColor3 = self.Themes[self.CurrentTheme].Second,
                Size = UDim2.new(1, 0, 0, 35)
            })
            CreateCorner(8).Parent = SectionFrame
            CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = SectionFrame

            local SectionTitle = Create("TextLabel", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Text = Name,
                TextColor3 = self.Themes[self.CurrentTheme].Accent,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 0, 35),
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SectionContainer = Create("Frame", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 40),
                Size = UDim2.new(1, -24, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })

            local SectionLayout = Create("UIListLayout", {
                Parent = SectionContainer,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            AddConnection(SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 55)
            end)

            local Section = {}

            function Section:AddButton(Text, Callback)
                Callback = Callback or function() end

                local Button = Create("TextButton", {
                    Parent = SectionContainer,
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Third,
                    Size = UDim2.new(1, 0, 0, 35),
                    Text = "",
                    AutoButtonColor = false
                })
                CreateCorner(6).Parent = Button
                CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = Button

                local ButtonText = Create("TextLabel", {
                    Parent = Button,
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = self.Themes[self.CurrentTheme].Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ButtonIcon = Create("ImageLabel", {
                    Parent = Button,
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6031094678",
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(1, -30, 0.5, -9),
                    ImageColor3 = self.Themes[self.CurrentTheme].Accent
                })

                AddConnection(Button.MouseEnter, function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Accent}):Play()
                end)

                AddConnection(Button.MouseLeave, function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Third}):Play()
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
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Third,
                    Size = UDim2.new(1, 0, 0, 35),
                    Text = "",
                    AutoButtonColor = false
                })
                CreateCorner(6).Parent = Toggle
                CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = Toggle

                local ToggleText = Create("TextLabel", {
                    Parent = Toggle,
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = self.Themes[self.CurrentTheme].Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ToggleBox = Create("Frame", {
                    Parent = Toggle,
                    BackgroundColor3 = State and self.Themes[self.CurrentTheme].Accent or self.Themes[self.CurrentTheme].Main,
                    Size = UDim2.new(0, 44, 0, 22),
                    Position = UDim2.new(1, -56, 0.5, -11)
                })
                CreateCorner(11).Parent = ToggleBox
                CreateStroke(self.Themes[self.CurrentTheme].Stroke, 0.5).Parent = ToggleBox

                local ToggleCircle = Create("Frame", {
                    Parent = ToggleBox,
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Text,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = State and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                })
                CreateCorner(9).Parent = ToggleCircle

                local function UpdateVisual()
                    TweenService:Create(ToggleBox, TweenInfo.new(0.2), {BackgroundColor3 = State and self.Themes[self.CurrentTheme].Accent or self.Themes[self.CurrentTheme].Main}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
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
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Third,
                    Size = UDim2.new(1, 0, 0, 60),
                    ClipsDescendants = true
                })
                CreateCorner(6).Parent = Slider
                CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = Slider

                local SliderText = Create("TextLabel", {
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = self.Themes[self.CurrentTheme].Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Size = UDim2.new(1, -24, 0, 20),
                    Position = UDim2.new(0, 12, 0, 8),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ValueLabel = Create("TextLabel", {
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Text = tostring(Value),
                    TextColor3 = self.Themes[self.CurrentTheme].Accent,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -62, 0, 8)
                })

                local SliderBar = Create("Frame", {
                    Parent = Slider,
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Main,
                    Size = UDim2.new(1, -24, 0, 12),
                    Position = UDim2.new(0, 12, 0, 35)
                })
                CreateCorner(6).Parent = SliderBar

                local FillBar = Create("Frame", {
                    Parent = SliderBar,
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Accent,
                    Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                })
                CreateCorner(6).Parent = FillBar

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

            function Section:AddDropdown(Text, Options, Default, Callback)
                Callback = Callback or function() end
                local Toggled = false
                local Selected = Default or Options[1] or "Select"

                local Dropdown = Create("Frame", {
                    Parent = SectionContainer,
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Third,
                    Size = UDim2.new(1, 0, 0, 45),
                    ClipsDescendants = true
                })
                CreateCorner(6).Parent = Dropdown
                CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = Dropdown

                local Title = Create("TextLabel", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = self.Themes[self.CurrentTheme].Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Size = UDim2.new(0.6, -12, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local SelectedLabel = Create("TextLabel", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Text = Selected,
                    TextColor3 = self.Themes[self.CurrentTheme].Accent,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    Size = UDim2.new(0.4, -30, 1, 0),
                    Position = UDim2.new(0.6, 0, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local Arrow = Create("ImageLabel", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6031094678",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -25, 0.5, -8),
                    ImageColor3 = self.Themes[self.CurrentTheme].TextDark,
                    Rotation = 0
                })

                local DropdownContainer = Create("Frame", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 0),
                    ClipsDescendants = true
                })

                local DropdownLayout = Create("UIListLayout", {
                    Parent = DropdownContainer,
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                local function UpdateSize()
                    Dropdown.Size = Toggled and UDim2.new(1, 0, 0, 45 + DropdownLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 45)
                end

                AddConnection(DropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"), UpdateSize)

                local Button = Create("TextButton", {
                    Parent = Dropdown,
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 2
                })

                AddConnection(Button.MouseButton1Click, function()
                    Toggled = not Toggled
                    UpdateSize()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = Toggled and 180 or 0}):Play()
                end)

                for _, Option in ipairs(Options) do
                    local OptionBtn = Create("TextButton", {
                        Parent = DropdownContainer,
                        BackgroundColor3 = self.Themes[self.CurrentTheme].Second,
                        Size = UDim2.new(1, -20, 0, 30),
                        Position = UDim2.new(0, 10, 0, 0),
                        Text = Option,
                        TextColor3 = self.Themes[self.CurrentTheme].Text,
                        TextSize = 13,
                        Font = Enum.Font.Gotham,
                        AutoButtonColor = false
                    })
                    CreateCorner(5).Parent = OptionBtn
                    CreateStroke(self.Themes[self.CurrentTheme].Stroke, 1).Parent = OptionBtn

                    AddConnection(OptionBtn.MouseEnter, function()
                        TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Accent}):Play()
                    end)

                    AddConnection(OptionBtn.MouseLeave, function()
                        TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Themes[self.CurrentTheme].Second}):Play()
                    end)

                    AddConnection(OptionBtn.MouseButton1Click, function()
                        Selected = Option
                        SelectedLabel.Text = Selected
                        Toggled = false
                        UpdateSize()
                        TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        Callback(Selected)
                    end)
                end

                UpdateSize()

                local Dpd = {}
                function Dpd:Set(Option)
                    if table.find(Options, Option) then
                        Selected = Option
                        SelectedLabel.Text = Selected
                        Callback(Selected)
                    end
                end
                return Dpd
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
    if SwizyGui then
        SwizyGui:Destroy()
    end
end

return Library
