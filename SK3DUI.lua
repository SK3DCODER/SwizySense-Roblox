    showNotification("Remote Spy", "Загружен успешно!", 3, "success")
end)

-- Menu functionality
themeButton.MouseButton1Click:Connect(function()
    local currentIndex = 1
    for i, scheme in ipairs(colorSchemes) do
        if scheme.name == currentScheme.name then
            currentIndex = i
            break
        end
    end
    
    local newIndex = currentIndex % #colorSchemes + 1
    currentScheme = colorSchemes[newIndex]
    colors = currentScheme
    
    -- Обновляем цвета интерфейса
    backgroundFrame.BackgroundColor3 = colors.background
    mainFrame.BackgroundColor3 = colors.mainBackground
    header.BackgroundColor3 = colors.primary
    
    themeButton.Text = "🎨 Тема: " .. currentScheme.name
    showNotification("Тема", "Изменена на: " .. currentScheme.name, 3, "success")
end)

scaleButton.MouseButton1Click:Connect(function()
    showNotification("Масштаб", "Функция в разработке", 2, "info")
end)

notifButton.MouseButton1Click:Connect(function()
    showNotification("Тест", "Обычное уведомление", 2, "info")
    wait(0.5)
    showNotification("Успех", "Тест пройден успешно! ✅", 2, "success")
    wait(0.5)
    showNotification("Предупреждение", "Тестовое сообщение", 2, "warning")
    wait(0.5)
    showNotification("Ошибка", "Тест завершен", 2, "error")
end)

unloadMenuButton.MouseButton1Click:Connect(function()
    showNotification("Выгрузка", "Меню выгружается...", 2, "warning")
    wait(1)
    gui:Destroy()
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    showNotification("Закрытие", "Интерфейс закрывается...", 1, "warning")
    wait(1)
    gui:Destroy()
end)

-- Unload button (minimize)
local isMinimized = false
unloadBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        showNotification("Свертывание", "Интерфейс свернут", 2, "info")
        
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 100, 0, 40), 
            Position = UDim2.new(1, -120, 1, -50)
        }):Play()
        
        TweenService:Create(backgroundFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 100, 0, 40),
            Position = UDim2.new(1, -120, 1, -50)
        }):Play()
        
        unloadBtn.Image = "rbxassetid://3926307956"
        isMinimized = true
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 440, 0, 550), 
            Position = UDim2.new(0.5, -220, 0.5, -275)
        }):Play()
        
        TweenService:Create(backgroundFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 440, 0, 550),
            Position = UDim2.new(0.5, -220, 0.5, -275)
        }):Play()
        
        unloadBtn.Image = "rbxassetid://3926307967"
        isMinimized = false
        showNotification("Восстановление", "Интерфейс восстановлен", 2, "success")
    end
end)

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

-- Character reconnection
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset flying if character respawns
    if isFlying then
        stopFlying()
        isFlying = false
        flyButton.Text = "🦅 Fly: ВЫКЛ"
    end
    
    showNotification("Персонаж", "Персонаж переподключен", 2, "info")
end)

-- Initial animation
mainFrame.Size = UDim2.new(0, 0, 0, 550)
mainFrame.BackgroundTransparency = 1
backgroundFrame.BackgroundTransparency = 1

wait(0.1)
TweenService:Create(backgroundFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
}):Play()

wait(0.2)

TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 440, 0, 550)
}):Play()

TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
}):Play()

wait(1)
showNotification("SK3D UI", "Премиум библиотека активирована! 🚀", 3, "success")

-- Auto-update character reference
RunService.Heartbeat:Connect(function()
    if not character or not character.Parent then
        character = player.Character
        if character then
            humanoid = character:FindFirstChild("Humanoid")
            rootPart = character:FindFirstChild("HumanoidRootPart")
        end
    end
end)

-- Export as library
local SK3DLibrary = {
    ShowNotification = showNotification,
    Unload = function() 
        stopFlying()
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        for player, espData in pairs(espObjects) do
            removeESP(player)
        end
        gui:Destroy() 
    end,
    GetGUI = function() return gui end,
    ToggleFly = function() 
        isFlying = not isFlying
        if isFlying then
            startFlying()
        else
            stopFlying()
        end
        return isFlying
    end,
    ToggleESP = function()
        espEnabled = not espEnabled
        if espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    createESP(player)
                end
            end
        else
            for player, espData in pairs(espObjects) do
                removeESP(player)
            end
        end
        return espEnabled
    end
}

return SK3DLibrary