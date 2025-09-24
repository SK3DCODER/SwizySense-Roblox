-- Credits To LeoDicap On The Old V3rmillion For Helping Me A Lot With The Script

-- Кастомная GUI библиотека
local CustomGUI = {}
CustomGUI.Windows = {}

function CustomGUI:CreateWindow(name)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomGUI"
    screenGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = name
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.Parent = titleBar
    
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "TabsFrame"
    tabsFrame.Size = UDim2.new(0, 120, 1, -30)
    tabsFrame.Position = UDim2.new(0, 0, 0, 30)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = mainFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -120, 1, -30)
    contentFrame.Position = UDim2.new(0, 120, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.Parent = contentFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = scrollingFrame
    uiListLayout.Padding = UDim.new(0, 5)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = not screenGui.Enabled
    end)
    
    local window = {
        ScreenGui = screenGui,
        TabsFrame = tabsFrame,
        ContentFrame = contentFrame,
        ScrollingFrame = scrollingFrame,
        Tabs = {},
        CurrentTab = nil
    }
    
    table.insert(CustomGUI.Windows, window)
    return window
end

function CustomGUI:CreateTab(window, name)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Size = UDim2.new(1, -10, 0, 30)
    tabButton.Position = UDim2.new(0, 5, 0, 5 + (#window.Tabs * 35))
    tabButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Text = name
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 12
    tabButton.Parent = window.TabsFrame
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = name
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = window.ScrollingFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabContent
    uiListLayout.Padding = UDim.new(0, 5)
    
    local tab = {
        Name = name,
        Button = tabButton,
        Content = tabContent
    }
    
    table.insert(window.Tabs, tab)
    
    tabButton.MouseButton1Click:Connect(function()
        CustomGUI:SwitchTab(window, tab)
    end)
    
    if #window.Tabs == 1 then
        CustomGUI:SwitchTab(window, tab)
    end
    
    return tab
end

function CustomGUI:SwitchTab(window, tab)
    if window.CurrentTab then
        window.CurrentTab.Content.Visible = false
        window.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end
    
    window.CurrentTab = tab
    tab.Content.Visible = true
    tab.Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end

function CustomGUI:AddButton(tab, name, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.Parent = tab.Content
    
    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return button
end

function CustomGUI:AddToggle(tab, name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name
    toggleFrame.Size = UDim2.new(1, -10, 0, 25)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = tab.Content
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 50, 1, 0)
    toggleButton.Position = UDim2.new(1, -55, 0, 0)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 11
    toggleButton.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local state = default
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggleButton.Text = state and "ON" or "OFF"
        pcall(callback, state)
    end)
    
    return {State = state}
end

function CustomGUI:AddLabel(tab, text)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.Content
    
    return label
end

function CustomGUI:AddDropdown(tab, name, options, default, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = name
    dropdownFrame.Size = UDim2.new(1, -10, 0, 30)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = tab.Content
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "Dropdown"
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.Text = name .. ": " .. default
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.TextSize = 12
    dropdownButton.Parent = dropdownFrame
    
    local selected = default
    
    dropdownButton.MouseButton1Click:Connect(function()
        for i, option in ipairs(options) do
            if option == selected then
                local nextIndex = (i % #options) + 1
                selected = options[nextIndex]
                break
            end
        end
        dropdownButton.Text = name .. ": " .. selected
        pcall(callback, selected)
    end)
    
    return {Selected = selected}
end

function CustomGUI:Notification(title, content, time)
    time = time or 5
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -310, 1, -90)
    notification.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    notification.BorderSizePixel = 0
    notification.Parent = game:GetService("CoreGui")
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.Parent = notification
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -10, 1, -30)
    contentLabel.Position = UDim2.new(0, 5, 0, 30)
    contentLabel.BackgroundTransparency = 1
    contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    contentLabel.Text = content
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextSize = 12
    contentLabel.TextWrapped = true
    contentLabel.Parent = notification
    
    task.spawn(function()
        task.wait(time)
        notification:Destroy()
    end)
end

-- Основной код скрипта
local function InitializeScript()
    -- Place Check
    if game.PlaceId ~= 13864667823 then
        if game.PlaceId == 14775231477 or game.PlaceId == 13864661000 then
            -- Free Gamepasses (LOBBY)
            local window = CustomGUI:CreateWindow("Breaking Blitz - Lobby")
            local tab = CustomGUI:CreateTab(window, "Free Gamepasses")
            
            CustomGUI:AddButton(tab, "Free Hacker Role", function()
                game:GetService("ReplicatedStorage").RemoteEvents.OutsideRole:FireServer("Phone", true, false)
            end)
            
            CustomGUI:AddButton(tab, "Free Nerd Kid Role", function()
                game:GetService("ReplicatedStorage").RemoteEvents.OutsideRole:FireServer("Book", true, false)
            end)
            
            CustomGUI:Notification("Loaded!", "Lobby Script Loaded!")
            
            for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                if v.Name == "Part" and v:FindFirstChild("TouchInterest") then
                    firetouchinterest(v, game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, 0)
                end
            end
        else
            game:GetService("Players").LocalPlayer:Kick("Error! Game Not Supported!")
        end
    else
        -- Основной игровой код
        local Part = Instance.new("Part")
        Part.Size = Vector3.new(5, 1, 5)
        Part.Parent = game:GetService("Workspace")
        Part.Anchored = true
        Part.Transparency = 1

        -- Локальные переменные
        local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
        local SelectedItem = "Med Kit"
        local Damange = 5
        local ScriptLoaded = false
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Lighting = game:GetService("Lighting")
        local OriginalWalkspeed = LocalPlayer.Character.Humanoid.WalkSpeed
        local OriginalJumpPower = LocalPlayer.Character.Humanoid.JumpPower
        local ModifiedWalkspeed = 50
        local ModifiedJumpPower = 100
        local OriginalBrightness = Lighting.Brightness
        local OriginalFog = Lighting.FogEnd
        local OriginalShadow = Lighting.GlobalShadows
        local HailClone = game:GetService("Workspace").Hails:Clone()
        
        -- Таблицы
        local SecretEndingTable = {"HatCollected", "MaskCollected", "CrowbarCollected"}
        
        local ItemsTable = {
            "Crowbar 1", "Crowbar 2", "Bat", "Pitchfork", "Hammer", "Wrench", "Broom",
            "Armor", "Med Kit", "Key", "Gold Key", "Louise", "Lollipop", "Chips",
            "Golden Apple", "Pizza", "Gold Pizza", "Rainbow Pizza", "Rainbow Pizza Box",
            "Book", "Phone", "Cookie", "Apple", "Bloxy Cola", "Expired Bloxy Cola",
            "Bottle", "Ladder", "Battery"
        }

        -- Базовые функции
        local function Notify(name, content, time)
            CustomGUI:Notification(name, content, time)
        end

        local function Delete(Instance)
            pcall(function()
                Events:WaitForChild("OnDoorHit"):FireServer(Instance)
            end)
        end

        local function UnequipAllTools()
            for i, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = LocalPlayer.Backpack
                end
            end
        end

        local function EquipAllTools()
            for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = LocalPlayer.Character
                end
            end
        end

        local function GiveItem(Item)
            if Item == "Armor" then
                Events:WaitForChild("Vending"):FireServer(3, "Armor2", "Armor", tostring(LocalPlayer), 1)
            elseif Item == "Crowbar 1" or Item == "Crowbar 2" or Item == "Bat" or Item == "Pitchfork" or Item == "Hammer" or Item == "Wrench" or Item == "Broom" then
                Events.Vending:FireServer(3, tostring(Item:gsub(" ", "")), "Weapons", LocalPlayer.Name, 1)
                Notify('Credits To', "Leo Dicap On V3rmillion For Making This Feature!", 3)
            else
                Events:WaitForChild("GiveTool"):FireServer(tostring(Item:gsub(" ", "")))
            end
        end

        local function GetBestTool()
            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Assets.Note.Note.Note:GetChildren()) do
                if v.Name:match("Circle") and v.Visible == true then
                    GiveItem(tostring(v.Name:gsub("Circle", "")))
                end
            end
        end

        local function Train(Ability)
            Events:WaitForChild("RainbowWhatStat"):FireServer(Ability)
        end

        local function TakeDamange(Amount)
            Events:WaitForChild("Energy"):FireServer(-Amount, false, false)
        end

        local function TeleportTo(CFrameArg)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameArg
        end

        local function GiveAll()
            GetBestTool()
            task.wait(.1)
            GiveItem("Armor")
            task.wait(.1)
            for i = 1, 5 do
                Train("Speed")
                Train("Strength")
            end
            task.wait(.1)
            UnequipAllTools()
            for i = 1, 15 do
                GiveItem("Gold Pizza")
                task.wait(0.05)
            end
        end

        local function HealAllPlayers()
            UnequipAllTools()
            task.wait(.2)
            GiveItem("Golden Apple")
            task.wait(.5)
            LocalPlayer.Backpack:WaitForChild("GoldenApple").Parent = LocalPlayer.Character
            task.wait(.5)
            Events:WaitForChild("HealTheNoobs"):FireServer()
        end

        local function HealYourself()
            GiveItem("Pizza")
            Events.Energy:FireServer(25, "Pizza")
        end

        local function BreakBarricades()
            for i, v in pairs(game:GetService("Workspace").FallenTrees:GetChildren()) do
                for i = 1, 20 do
                    if v:FindFirstChild("TreeHitPart") then
                        Events.RoadMissionEvent:FireServer(1, v.TreeHitPart, 5)
                    end
                end
            end
        end

        local function BreakEnemies()
            pcall(function()
                for i, v in pairs(game:GetService("Workspace").BadGuys:GetChildren()) do
                    if v:FindFirstChild("Humanoid", true) then
                        v:FindFirstChild("Humanoid", true).Health = 0
                    end
                end
                for i, v in pairs(game:GetService("Workspace").BadGuysBoss:GetChildren()) do
                    if v:FindFirstChild("Humanoid", true) then
                        v:FindFirstChild("Humanoid", true).Health = 0
                    end
                end
                for i, v in pairs(game:GetService("Workspace").BadGuysFront:GetChildren()) do
                    if v:FindFirstChild("Humanoid", true) then
                        v:FindFirstChild("Humanoid", true).Health = 0
                    end
                end
            end)
        end

        local function KillEnemies()
            pcall(function()
                for i, v in pairs(game:GetService("Workspace").BadGuys:GetChildren()) do
                    Events:WaitForChild("HitBadguy"):FireServer(v, 64.8, 4)
                end
                for i, v in pairs(game:GetService("Workspace").BadGuysBoss:GetChildren()) do
                    Events:WaitForChild("HitBadguy"):FireServer(v, 64.8, 4)
                end
                for i, v in pairs(game:GetService("Workspace").BadGuysFront:GetChildren()) do
                    Events:WaitForChild("HitBadguy"):FireServer(v, 64.8, 4)
                end
                if game:GetService("Workspace"):FindFirstChild("BadGuyPizza", true) then
                    Events:WaitForChild("HitBadguy"):FireServer(game:GetService("Workspace"):FindFirstChild("BadGuyPizza", true), 64.8, 4)
                end
                if game:GetService("Workspace"):FindFirstChild("BadGuyBrute") then
                    Events:WaitForChild("HitBadguy"):FireServer(game:GetService("Workspace").BadGuyBrute, 64.8, 4)
                end
            end)
        end

        local function GetDog()
            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Assets.Note.Note.Note:GetChildren()) do
                if v.Name:match("Circle") and v.Visible == true then
                    GiveItem(tostring(v.Name:gsub("Circle", "")))
                    task.wait(.1)
                    if LocalPlayer.Backpack:FindFirstChild(tostring(v.Name:gsub("Circle", ""))) then
                        LocalPlayer.Backpack:FindFirstChild(tostring(v.Name:gsub("Circle", ""))).Parent = LocalPlayer.Character
                        TeleportTo(CFrame.new(-257.56839, 29.4499969, -910.452637, -0.238445505, 7.71292363e-09, 0.971155882, 1.2913591e-10, 1, -7.91029819e-09, -0.971155882, -1.76076387e-09, -0.238445505))
                        task.wait(.5)
                        Events:WaitForChild("CatFed"):FireServer(tostring(v.Name:gsub("Circle", "")))
                    end
                end
            end
            task.wait(2)
            for i = 1, 3 do
                TeleportTo(CFrame.new(-203.533081, 30.4500484, -790.901428, -0.0148558766, 8.85941187e-09, -0.999889672, 2.65695732e-08, 1, 8.46563175e-09, 0.999889672, -2.64408779e-08, -0.0148558766) + Vector3.new(0, 5, 0))
                task.wait(.1)
            end
        end

        local function GetAgent()
            GiveItem("Louise")
            task.wait(.1)
            if LocalPlayer.Backpack:FindFirstChild("Louise") then
                LocalPlayer.Backpack:FindFirstChild("Louise").Parent = LocalPlayer.Character
                Events:WaitForChild("LouiseGive"):FireServer(2)
            end
        end

        local function GetUncle()
            GiveItem("Key")
            task.wait(.1)
            if LocalPlayer.Backpack:FindFirstChild("Key") then
                LocalPlayer.Backpack:FindFirstChild("Key").Parent = LocalPlayer.Character
                wait(.5)
                Events.KeyEvent:FireServer()
            end
        end

        local function ClickPete()
            if game:GetService("Workspace"):FindFirstChild("UnclePete") and game:GetService("Workspace").UnclePete:FindFirstChild("ClickDetector") then
                fireclickdetector(game:GetService("Workspace").UnclePete.ClickDetector)
            end
        end

        local function CollectCash()
            for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                if v.Name == "Part" and v:FindFirstChild("TouchInterest") and v:FindFirstChild("Weld") and v.Transparency == 1 then
                    firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart, 0)
                end
            end
        end

        local function GetAllOutsideItems()
            TeleportTo(CFrame.new(-199.240555, 30.0009422, -790.182739, 0.08340507, 2.48169538e-08, 0.996515751, -2.7112752e-09, 1, -2.46767993e-08, -0.996515751, -6.43658127e-10, 0.08340507))
            for i, v in pairs(game:GetService("Workspace").OutsideParts:GetChildren()) do
                if v:FindFirstChild("ClickDetector") then
                    fireclickdetector(v.ClickDetector)
                end
            end
            LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(-10, 0, 0))
        end

        local function BringAllEnemies()
            pcall(function()
                for i, v in pairs(game:GetService("Workspace").BadGuys:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.Anchored = true
                        v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                    end
                end
                for i, v in pairs(game:GetService("Workspace").BadGuysBoss:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.Anchored = true
                        v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                    end
                end
                for i, v in pairs(game:GetService("Workspace").BadGuysFront:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.Anchored = true
                        v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                    end
                end
            end)
        end

        local function GetSecretEnding()
            for i, v in next, SecretEndingTable do
                Events.LarryEndingEvent:FireServer(v, true)
            end
        end

        local function GetGAppleBadge()
            if game:GetService("Workspace"):FindFirstChild("FallenTrees") then
                for i, v in pairs(game:GetService("Workspace").FallenTrees:GetChildren()) do
                    for i = 1, 20 do
                        if v:FindFirstChild("TreeHitPart") then
                            Events.RoadMissionEvent:FireServer(1, v.TreeHitPart, 5)
                        end
                    end
                end
                task.wait(1)
                TeleportTo(CFrame.new(61.8781624, 29.4499969, -534.381165, -0.584439218, -1.05103076e-07, 0.811437488, -3.12853778e-08, 1, 1.06993674e-07, -0.811437488, 3.71451705e-08, -0.584439218))
                task.wait(.5)
                if game:GetService("Workspace"):FindFirstChild("GoldenApple") and game:GetService("Workspace").GoldenApple:FindFirstChild("ClickDetector") then
                    fireclickdetector(game:GetService("Workspace").GoldenApple.ClickDetector)
                end
            else
                Notify("Error", "Golden Apple Has Not Spawned Yet, Please Wait Until the First Wave.", 3)
            end
        end

        -- Создание главного GUI
        local mainWindow = CustomGUI:CreateWindow("Breaking Blitz")
        
        -- Вкладка INFO
        local infoTab = CustomGUI:CreateTab(mainWindow, "INFO")
        
        CustomGUI:AddLabel(infoTab, "GitHub: github.com/sk3dhub")
        CustomGUI:AddLabel(infoTab, "Telegram Channel: t.me/SK3DHUB")
        CustomGUI:AddLabel(infoTab, " ")
        CustomGUI:AddLabel(infoTab, "Скрипт создан для Breaking Blitz")
        CustomGUI:AddLabel(infoTab, "Все функции проверены и работают")
        
        -- Вкладка Game Breaking
        local gameBreakingTab = CustomGUI:CreateTab(mainWindow, "Game Breaking")
        
        CustomGUI:AddButton(gameBreakingTab, "Delete The Game", function()
            for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                pcall(function() Delete(v) end)
            end
        end)
        
        CustomGUI:AddButton(gameBreakingTab, "Delete The House", function()
            for i, v in pairs(game:GetService("Workspace").TheHouse:GetChildren()) do
                if v.Name ~= "FloorLayer" then
                    pcall(function() Delete(v) end)
                end
            end
        end)
        
        CustomGUI:AddButton(gameBreakingTab, "Delete Bad Guys", function()
            for i, v in pairs(game:GetService("Workspace").BadGuys:GetChildren()) do
                pcall(function() Delete(v) end)
            end
            for i, v in pairs(game:GetService("Workspace").BadGuysBoss:GetChildren()) do
                pcall(function() Delete(v) end)
            end
            for i, v in pairs(game:GetService("Workspace").BadGuysFront:GetChildren()) do
                pcall(function() Delete(v) end)
            end
        end)

        -- Вкладка Overpowered
        local overpoweredTab = CustomGUI:CreateTab(mainWindow, "Overpowered")
        
        CustomGUI:AddLabel(overpoweredTab, "Item Giver:")
        local itemDropdown = CustomGUI:AddDropdown(overpoweredTab, "Item", ItemsTable, "Med Kit", function(value)
            SelectedItem = value
        end)
        
        CustomGUI:AddButton(overpoweredTab, "Get Selected Item", function()
            GiveItem(SelectedItem)
        end)
        
        CustomGUI:AddButton(overpoweredTab, "Get All Equipment", function()
            GiveAll()
        end)
        
        CustomGUI:AddButton(overpoweredTab, "Train Strength", function()
            Train("Strength")
        end)
        
        CustomGUI:AddButton(overpoweredTab, "Train Speed", function()
            Train("Speed")
        end)
        
        CustomGUI:AddButton(overpoweredTab, "Heal Yourself", function()
            for i = 1, 10 do
                HealYourself()
            end
        end)
        
        CustomGUI:AddButton(overpoweredTab, "Heal All Players", function()
            HealAllPlayers()
        end)

        -- Вкладка Teleports
        local teleportsTab = CustomGUI:CreateTab(mainWindow, "Teleports")
        
        CustomGUI:AddButton(teleportsTab, "Boss Fight", function()
            TeleportTo(CFrame.new(-1565.78772, -368.711945, -1040.66626, 0.0929690823, -1.97564436e-08, 0.995669007, -1.53269308e-08, 1, 2.1273511e-08, -0.995669007, -1.72383299e-08, 0.0929690823))
        end)
        
        CustomGUI:AddButton(teleportsTab, "Shop", function()
            TeleportTo(CFrame.new(-246.653229, 30.4500484, -847.319275, 0.999987781, -9.18427645e-08, -0.00494772941, 9.19905787e-08, 1, 2.96483353e-08, 0.00494772941, -3.01031164e-08, 0.999987781))
        end)
        
        CustomGUI:AddButton(teleportsTab, "Kitchen", function()
            TeleportTo(CFrame.new(-249.753555, 30.4500484, -732.703125, -0.999205947, -1.97705017e-08, 0.0398429185, -2.00601384e-08, 1, -6.86967372e-09, -0.0398429185, -7.66347341e-09, -0.999205947))
        end)
        
        CustomGUI:AddButton(teleportsTab, "Golden Apple", function()
            TeleportTo(CFrame.new(61.8781624, 29.4499969, -534.381165, -0.584439218, -1.05103076e-07, 0.811437488, -3.12853778e-08, 1, 1.06993674e-07, -0.811437488, 3.71451705e-08, -0.584439218))
        end)

        -- Вкладка Combat
        local combatTab = CustomGUI:CreateTab(mainWindow, "Combat")
        
        CustomGUI:AddButton(combatTab, "Kill All Enemies", function()
            for i = 1, 10 do
                KillEnemies()
            end
        end)
        
        CustomGUI:AddButton(combatTab, "Break All Enemies", function()
            BreakEnemies()
        end)
        
        CustomGUI:AddButton(combatTab, "Bring All Enemies", function()
            BringAllEnemies()
        end)

        -- Вкладка Badges
        local badgesTab = CustomGUI:CreateTab(mainWindow, "Badges")
        
        CustomGUI:AddButton(badgesTab, "Dream Team (All NPCs)", function()
            GetDog()
            task.wait(5)
            GetAgent()
            task.wait(1)
            GetUncle()
        end)
        
        CustomGUI:AddButton(badgesTab, "Operation: Dog Rescue", GetDog)
        CustomGUI:AddButton(badgesTab, "Wake Up, Bradley!", GetAgent)
        CustomGUI:AddButton(badgesTab, "Uncle Pete's Return", GetUncle)
        CustomGUI:AddButton(badgesTab, "The Golden Apple", GetGAppleBadge)
        CustomGUI:AddButton(badgesTab, "Unlock Secret Ending", GetSecretEnding)

        -- Вкладка Misc
        local miscTab = CustomGUI:CreateTab(mainWindow, "Misc")
        
        CustomGUI:AddButton(miscTab, "Equip All Tools", EquipAllTools)
        CustomGUI:AddButton(miscTab, "Unequip All Tools", UnequipAllTools)
        CustomGUI:AddButton(miscTab, "Collect Cash", CollectCash)
        CustomGUI:AddButton(miscTab, "Get All Outside Items", GetAllOutsideItems)
        CustomGUI:AddButton(miscTab, "Break Fallen Trees", BreakBarricades)
        
        local speedToggle = CustomGUI:AddToggle(miscTab, "Speed Hack", false, function(state)
            if state then
                LocalPlayer.Character.Humanoid.WalkSpeed = ModifiedWalkspeed
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = OriginalWalkspeed
            end
        end)
        
        local jumpToggle = CustomGUI:AddToggle(miscTab, "Jump Hack", false, function(state)
            if state then
                LocalPlayer.Character.Humanoid.JumpPower = ModifiedJumpPower
            else
                LocalPlayer.Character.Humanoid.JumpPower = OriginalJumpPower
            end
        end)
        
        local noclipToggle = CustomGUI:AddToggle(miscTab, "Noclip", false, function(state)
            if state then
                getgenv().NoclipEnabled = true
            else
                getgenv().NoclipEnabled = false
            end
        end)
        
        local fullbrightToggle = CustomGUI:AddToggle(miscTab, "Full Bright", false, function(state)
            if state then
                Lighting.Brightness = 2
                Lighting.FogEnd = 1000000
                Lighting.GlobalShadows = false
            else
                Lighting.Brightness = OriginalBrightness
                Lighting.FogEnd = OriginalFog
                Lighting.GlobalShadows = OriginalShadow
            end
        end)
        
        local antiHailToggle = CustomGUI:AddToggle(miscTab, "Anti Hail", false, function(state)
            if state then
                for i, v in pairs(game:GetService("Workspace").Hails:GetChildren()) do
                    v:Destroy()
                end
                HailClone.Parent = nil
            else
                HailClone.Parent = game:GetService("Workspace")
            end
        end)
        
        local autoCollectToggle = CustomGUI:AddToggle(miscTab, "Auto Collect Cash", false, function(state)
            getgenv().AutoCollectCash = state
            while getgenv().AutoCollectCash do
                CollectCash()
                task.wait(1)
            end
        end)
        
        local autoPeteToggle = CustomGUI:AddToggle(miscTab, "Auto Claim Uncle Pete Quests", false, function(state)
            getgenv().AutoPete = state
            while getgenv().AutoPete do
                ClickPete()
                task.wait(10)
            end
        end)

        -- Вкладка Destroy GUI
        local destroyTab = CustomGUI:CreateTab(mainWindow, "Destroy GUI")
        
        CustomGUI:AddButton(destroyTab, "Destroy GUI", function()
            mainWindow.ScreenGui:Destroy()
        end)

        -- Финальное уведомление
        Notify('Loaded!', "Script Successfully Loaded!\nAll features are now available!", 10)

        -- Анти-афк
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)

        -- Ноклип
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().NoclipEnabled then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)

        ScriptLoaded = true
    end
end

-- Запуск скрипта с обработкой ошибок
local success, err = pcall(InitializeScript)
if not success then
    warn("Script Error: " .. tostring(err))
end