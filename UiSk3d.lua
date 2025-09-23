-- SK3D UI Library v1.1 (Fixed)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local SK3D = {}
SK3D.__index = SK3D

function SK3D:CreateWindow()
    local newWindow = {}
    setmetatable(newWindow, SK3D)
    
    newWindow.gui = Instance.new("ScreenGui")
    newWindow.gui.Name = "SK3DUI"
    newWindow.gui.Parent = player:WaitForChild("PlayerGui")

    newWindow.colors = {
        primary = Color3.fromRGB(70, 130, 230),
        background = Color3.fromRGB(250, 252, 255),
        text = Color3.fromRGB(30, 35, 45)
    }

    newWindow.mainFrame = Instance.new("Frame")
    newWindow.mainFrame.Size = UDim2.new(0, 400, 0, 400)
    newWindow.mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
    newWindow.mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    newWindow.mainFrame.BackgroundColor3 = newWindow.colors.background
    newWindow.mainFrame.BorderSizePixel = 0
    newWindow.mainFrame.ClipsDescendants = true
    newWindow.mainFrame.Parent = newWindow.gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = newWindow.mainFrame

    newWindow.header = Instance.new("Frame")
    newWindow.header.Size = UDim2.new(1, 0, 0, 80)
    newWindow.header.BackgroundColor3 = newWindow.colors.primary
    newWindow.header.BorderSizePixel = 0
    newWindow.header.Parent = newWindow.mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = newWindow.header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "SK3D UI"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = newWindow.header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 0.9
    closeBtn.Text = "X"
    closeBtn.TextColor3 = newWindow.colors.text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = newWindow.header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    newWindow.content = Instance.new("Frame")
    newWindow.content.Size = UDim2.new(1, -20, 1, -100)
    newWindow.content.Position = UDim2.new(0, 10, 0, 90)
    newWindow.content.BackgroundTransparency = 1
    newWindow.content.Parent = newWindow.mainFrame

    newWindow.buttons = {}
    newWindow.buttonCount = 0

    newWindow.mainFrame.Size = UDim2.new(0, 0, 0, 400)
    local initTween = TweenService:Create(newWindow.mainFrame, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 400, 0, 400)
    })
    initTween:Play()

    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(newWindow.mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 400)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        newWindow.gui:Destroy()
    end)

    local dragging = false
    local dragStart, startPos

    newWindow.header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = newWindow.mainFrame.Position
        end
    end)

    newWindow.header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            newWindow.mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    return newWindow
end

function SK3D:AddButton(name, callback)
    self.buttonCount = self.buttonCount + 1
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 45)
    button.Position = UDim2.new(0, 0, 0, (self.buttonCount - 1) * 55)
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

return SK3D
