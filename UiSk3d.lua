-- SK3D UI Library v1.2 (Fixed)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local SK3D = {}
SK3D.__index = SK3D

function SK3D.new()
    local self = setmetatable({}, SK3D)
    return self
end

function SK3D:CreateWindow()
    if self.gui and self.gui.Parent then
        self.gui:Destroy()
    end
    
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "SK3DUI_" .. tick()
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.Parent = guiParent

    self.colors = {
        primary = Color3.fromRGB(70, 130, 230),
        background = Color3.fromRGB(250, 252, 255),
        text = Color3.fromRGB(30, 35, 45)
    }

    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = UDim2.new(0, 400, 0, 400)
    self.mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
    self.mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.mainFrame.BackgroundColor3 = self.colors.background
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.ClipsDescendants = true
    self.mainFrame.Parent = self.gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = self.mainFrame

    self.header = Instance.new("Frame")
    self.header.Size = UDim2.new(1, 0, 0, 80)
    self.header.BackgroundColor3 = self.colors.primary
    self.header.BorderSizePixel = 0
    self.header.Parent = self.mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = self.header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "SK3D UI"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 0.9
    closeBtn.Text = "X"
    closeBtn.TextColor3 = self.colors.text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = self.header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    self.content = Instance.new("Frame")
    self.content.Size = UDim2.new(1, -20, 1, -100)
    self.content.Position = UDim2.new(0, 10, 0, 90)
    self.content.BackgroundTransparency = 1
    self.content.Parent = self.mainFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.Parent = self.content

    self.buttons = {}
    self.buttonCount = 0

    self.mainFrame.Size = UDim2.new(0, 0, 0, 400)
    local initTween = TweenService:Create(self.mainFrame, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 400, 0, 400)
    })
    initTween:Play()

    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(self.mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 400)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        self.gui:Destroy()
    end)

    local dragging = false
    local dragStart, startPos

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end

    self.header.InputBegan:Connect(onInputBegan)
    self.header.InputEnded:Connect(onInputEnded)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    return self
end

function SK3D:AddButton(name, callback)
    self.buttonCount = self.buttonCount + 1
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = self.colors.primary
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Parent = self.content
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 110, 210)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = self.colors.primary
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    table.insert(self.buttons, button)
    return button
end

function SK3D:Notify(text, duration)
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(0, 20, 1, -80)
    notification.AnchorPoint = Vector2.new(0, 1)
    notification.BackgroundColor3 = self.colors.background
    notification.BorderSizePixel = 0
    notification.Parent = self.gui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, -10)
    notifText.Position = UDim2.new(0, 10, 0, 5)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = self.colors.text
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 12
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.Parent = notification
    
    notification.Position = UDim2.new(0, 20, 1, 100)
    
    local slideIn = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(0, 20, 1, -80)
    })
    
    local slideOut = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(0, 20, 1, 100)
    })
    
    slideIn:Play()
    wait(duration)
    slideOut:Play()
    slideOut.Completed:Wait()
    notification:Destroy()
end

function SK3D:Destroy()
    if self.gui then
        self.gui:Destroy()
    end
end

return SK3D
