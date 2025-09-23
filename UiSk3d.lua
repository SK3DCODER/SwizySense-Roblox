-- SK3D UI Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "SK3DUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Background frame only behind menu
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Size = UDim2.new(0, 500, 0, 600)
backgroundFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
backgroundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
backgroundFrame.BackgroundTransparency = 1
backgroundFrame.BorderSizePixel = 0
backgroundFrame.ZIndex = 0
backgroundFrame.Parent = gui

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 30)
bgCorner.Parent = backgroundFrame

-- Color schemes
local colorSchemes = {
    {
        name = "Ocean Blue",
        background = Color3.fromRGB(245, 250, 255),
        mainBackground = Color3.fromRGB(250, 252, 255),
        primary = Color3.fromRGB(70, 130, 230),
        secondary = Color3.fromRGB(240, 245, 255),
        text = Color3.fromRGB(30, 35, 45),
        textLight = Color3.fromRGB(100, 110, 130),
        accent = Color3.fromRGB(255, 90, 90),
        success = Color3.fromRGB(75, 190, 100)
    }
}

local currentScheme = colorSchemes[1]
local colors = currentScheme

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 440, 0, 300)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -150)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = colors.mainBackground
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 2
mainFrame.Parent = gui

-- Smooth corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 24)
corner.Parent = mainFrame

-- Subtle shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.85
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23,23,277,277)
shadow.ZIndex = 1
shadow.Parent = gui

-- Gradient header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 150)
header.BackgroundColor3 = colors.primary
header.BorderSizePixel = 0
header.ZIndex = 3
header.Parent = mainFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Rotation = 135
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, colors.primary),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(
        math.min(colors.primary.R * 255 + 30, 255)/255,
        math.min(colors.primary.G * 255 + 30, 255)/255, 
        math.min(colors.primary.B * 255 + 30, 255)/255
    ))
})
headerGradient.Parent = header

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 24)
headerCorner.Parent = header

-- Title with SK3D UI
local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(1, -50, 0, 90)
titleContainer.Position = UDim2.new(0, 25, 0, 35)
titleContainer.BackgroundTransparency = 1
titleContainer.ZIndex = 4
titleContainer.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "SK3D UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 36
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 4
title.Parent = titleContainer

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "БИБЛИОТЕКА v1.0"
subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 13
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextTransparency = 0.7
subtitle.ZIndex = 4
subtitle.Parent = titleContainer

-- Close button
local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0, 25)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.9
closeBtn.Image = "rbxassetid://3926307971"
closeBtn.ImageColor3 = colors.text
closeBtn.ImageTransparency = 0.2
closeBtn.ZIndex = 4
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- Content area (empty for buttons)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -40, 1, -160)
content.Position = UDim2.new(0, 20, 0, 160)
content.BackgroundTransparency = 1
content.ZIndex = 3
content.Parent = mainFrame

-- Notification system (stack in bottom left)
local notificationsFolder = Instance.new("Folder")
notificationsFolder.Parent = gui

local activeNotifications = {}
local notificationYPositions = {}

-- Function to create stacked notifications
local function showNotification(title, text, duration, notifType)
    duration = duration or 3
    
    local iconMap = {
        info = "3926305904",
        success = "3926305904", 
        warning = "3926305904",
        error = "3926305904"
    }
    
    local colorMap = {
        info = colors.primary,
        success = colors.success,
        warning = Color3.fromRGB(255, 180, 70),
        error = colors.accent
    }
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 340, 0, 85)
    notificationFrame.AnchorPoint = Vector2.new(0, 1)
    notificationFrame.BackgroundColor3 = colors.mainBackground
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 5
    notificationFrame.Parent = notificationsFolder

    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 14)
    notifCorner.Parent = notificationFrame

    local notifShadow = Instance.new("ImageLabel")
    notifShadow.Size = UDim2.new(1, 15, 1, 15)
    notifShadow.Position = UDim2.new(0, -7, 0, -7)
    notifShadow.BackgroundTransparency = 1
    notifShadow.Image = "rbxassetid://5554236805"
    notifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    notifShadow.ImageTransparency = 0.9
    notifShadow.ScaleType = Enum.ScaleType.Slice
    notifShadow.SliceCenter = Rect.new(23,23,277,277)
    notifShadow.ZIndex = 4
    notifShadow.Parent = notificationFrame

    local notifIcon = Instance.new("ImageLabel")
    notifIcon.Size = UDim2.new(0, 22, 0, 22)
    notifIcon.Position = UDim2.new(0, 18, 0, 18)
    notifIcon.BackgroundTransparency = 1
    notifIcon.Image = "rbxassetid://" .. iconMap[notifType]
    notifIcon.ImageColor3 = colorMap[notifType]
    notifIcon.ZIndex = 6
    notifIcon.Parent = notificationFrame

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -55, 0, 22)
    notifTitle.Position = UDim2.new(0, 50, 0, 15)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = colors.text
    notifTitle.Font = Enum.Font.GothamSemibold
    notifTitle.TextSize = 15
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.ZIndex = 6
    notifTitle.Parent = notificationFrame

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -55, 0, 40)
    notifText.Position = UDim2.new(0, 50, 0, 35)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = colors.textLight
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 13
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextYAlignment = Enum.TextYAlignment.Top
    notifText.ZIndex = 6
    notifText.Parent = notificationFrame

    local notifProgress = Instance.new("Frame")
    notifProgress.Size = UDim2.new(1, 0, 0, 3)
    notifProgress.Position = UDim2.new(0, 0, 1, -3)
    notifProgress.BackgroundColor3 = colorMap[notifType]
    notifProgress.BorderSizePixel = 0
    notifProgress.ZIndex = 6
    notifProgress.Parent = notificationFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2)
    progressCorner.Parent = notifProgress

    -- Calculate Y position (stack from bottom)
    local yOffset = 0
    for _, pos in pairs(notificationYPositions) do
        yOffset = yOffset + 95
    end
    
    notificationYPositions[notificationFrame] = yOffset
    table.insert(activeNotifications, notificationFrame)

    -- Initial position (off-screen left)
    notificationFrame.Position = UDim2.new(0, -400, 1, -25 - yOffset)

    -- Smooth slide in
    local slideIn = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 25, 1, -25 - yOffset)}
    )

    -- Progress bar animation
    local progressTween = TweenService:Create(
        notifProgress,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 0, 0, 3)}
    )

    slideIn:Play()
    progressTween:Play()

    -- Wait and remove
    wait(duration)
    
    -- Slide out
    local slideOut = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0, -400, 1, -25 - yOffset)}
    )
    
    slideOut:Play()
    slideOut.Completed:Wait()
    
    -- Cleanup
    notificationYPositions[notificationFrame] = nil
    for i, notif in ipairs(activeNotifications) do
        if notif == notificationFrame then
            table.remove(activeNotifications, i)
            break
        end
    end
    notificationFrame:Destroy()
    
    -- Update positions of remaining notifications
    for i, notif in ipairs(activeNotifications) do
        local newYOffset = (i - 1) * 95
        notificationYPositions[notif] = newYOffset
        TweenService:Create(
            notif,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, 25, 1, -25 - newYOffset)}
        ):Play()
    end
end

-- Close button function
closeBtn.MouseButton1Click:Connect(function()
    showNotification("Закрытие", "Интерфейс закрывается...", 1, "warning")
    wait(1)
    
    local scaleTween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 300)}
    )
    
    local fadeTween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )
    
    local shadowTween = TweenService:Create(
        shadow,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {ImageTransparency = 1}
    )
    
    local bgTween = TweenService:Create(
        backgroundFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )
    
    scaleTween:Play()
    fadeTween:Play() 
    shadowTween:Play()
    bgTween:Play()
    
    scaleTween.Completed:Wait()
    gui:Destroy()
end)

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 15, startPos.Y.Scale, startPos.Y.Offset + delta.Y - 15)
    backgroundFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Initial animation
mainFrame.Size = UDim2.new(0, 0, 0, 300)
mainFrame.BackgroundTransparency = 1
shadow.ImageTransparency = 1
backgroundFrame.BackgroundTransparency = 1

wait(0.1)
TweenService:Create(backgroundFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
}):Play()

wait(0.2)

local initSize = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0),
    {Size = UDim2.new(0, 440, 0, 300)}
)

local initFade = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {BackgroundTransparency = 0}
)

local initShadow = TweenService:Create(
    shadow,
    TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {ImageTransparency = 0.85}
)

initSize:Play()
wait(0.1)
initFade:Play()
initShadow:Play()

-- Welcome notification
wait(1)
showNotification("SK3D UI", "Библиотека активирована! 🚀", 3, "success")

-- Export as library
local SK3DLibrary = {
    ShowNotification = showNotification,
    AddButton = function(name, callback)
        local buttonCount = #content:GetChildren() - 1
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 50)
        button.Position = UDim2.new(0, 0, 0, buttonCount * 60)
        button.BackgroundColor3 = colors.primary
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamSemibold
        button.TextSize = 14
        button.ZIndex = 3
        button.Parent = content
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = button
        
        -- Adjust content size
        content.Size = UDim2.new(1, -40, 0, (buttonCount + 1) * 60 + 10)
        mainFrame.Size = UDim2.new(0, 440, 0, 160 + (buttonCount + 1) * 60)
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(
                    math.min(colors.primary.R * 255 - 20, 255)/255,
                    math.min(colors.primary.G * 255 - 20, 255)/255,
                    math.min(colors.primary.B * 255 - 20, 255)/255
                )
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.primary
            }):Play()
        end)
        
        button.MouseButton1Click:Connect(callback)
        
        return button
    end,
    
    Unload = function()
        gui:Destroy()
    end
}

return SK3DLibrary
