# Swizy.Lib Documentation
This documentation is for the Swizy.Lib UI Library.

## Booting the Library
```lua
local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/SK3DCODER/SwizySense-Roblox/refs/heads/main/Swizy.Lib.lua')))()
```

## Creating a Window
```lua
local Window = Library:CreateWindow({
    Name = "Swizy.Lib",
    Size = UDim2.new(0, 650, 0, 450),
    Theme = "Dark"
})

--[[
Name = <string> - Window title.
Size = <UDim2> - Window size (width, height).
Theme = <string> - Theme (only "Dark" for now).
]]
```

## Creating a Tab
```lua
local Tab = Window:AddTab("Main")

--[[
Name = <string> - Tab name.
]]
Creating a Section
lua
local Section = Tab:AddSection("Controls")

--[[
Name = <string> - Section name.
]]
Notifications
lua
Library:MakeNotification({
    Name = "Title",
    Content = "Notification text",
    Time = 3
})

--[[
Name = <string> - Notification title.
Content = <string> - Notification text.
Time = <number> - Duration in seconds.
]]
Prompt Dialog
lua
Library:MakePrompt({
    Title = "Confirmation",
    Text = "Are you sure?",
    Buttons = {"Yes", "No"},
    Callback = function(result)
        print("Selected: " .. result)
    end
})

--[[
Title = <string> - Prompt title.
Text = <string> - Question text.
Buttons = <table> - Button options (string array).
Callback = <function> - Function when button clicked.
]]
Button
lua
local Button = Section:AddButton("Click Me", function()
    print("Button clicked!")
end)

--[[
First argument: <string> - Button text.
Second argument: <function> - Click callback.
]]

-- Change button text
Button:Set("New Text")
Toggle
lua
local Toggle = Section:AddToggle("Enable", false, function(state)
    print("State:", state)
end)

--[[
First argument: <string> - Toggle text.
Second argument: <bool> - Default state (true/false).
Third argument: <function> - State change callback.
]]

-- Change state
Toggle:Set(true)  -- enable
Toggle:Set(false) -- disable
Slider
lua
local Slider = Section:AddSlider("Speed", 0, 100, 50, function(value)
    print("Value:", value)
end)

--[[
First argument: <string> - Slider text.
Second argument: <number> - Minimum value.
Third argument: <number> - Maximum value.
Fourth argument: <number> - Default value.
Fifth argument: <function> - Value change callback.
]]

-- Set value
Slider:Set(75)
Dropdown
lua
local Dropdown = Section:AddDropdown("Select", 
    {"Option 1", "Option 2", "Option 3"}, 
    "Option 1", 
    function(option)
        print("Selected:", option)
    end
)

--[[
First argument: <string> - Dropdown text.
Second argument: <table> - Options list.
Third argument: <string> - Default option.
Fourth argument: <function> - Selection callback.
]]

-- Select option programmatically
Dropdown:Set("Option 2")
Menu Controls
lua
-- Toggle visibility
Library:ToggleMenu()              -- toggle
Library:ToggleMenu(true)          -- show
Library:ToggleMenu(false)         -- hide

-- Unload library completely
Library:Unload()

-- Alternative unload method
Library:Destroy()
Hotkeys
RightShift - Open/close menu

U (top bar button) - Unload library

X (top bar button) - Hide menu
```



## Complete Example
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SK3DCODER/SwizySense-Roblox/refs/heads/main/Swizy.Lib.lua"))()

local Window = Library:CreateWindow({
    Name = "My Script",
    Size = UDim2.new(0, 600, 0, 400)
})

local MainTab = Window:AddTab("Main")
local Section = MainTab:AddSection("Features")

Section:AddButton("Test", function()
    Library:MakeNotification({
        Name = "Test",
        Content = "Working!",
        Time = 2
    })
end)

local Toggle = Section:AddToggle("Enable", false, function(state)
    print("State:", state)
end)

Section:AddSlider("Value", 0, 100, 50, function(value)
    print("Value:", value)
end)
```
