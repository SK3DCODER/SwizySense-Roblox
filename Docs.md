# UI Libraries Documentation

# Swizy.Lib Documentation

This documentation is for the Swizy.Lib UI Library.

## Booting the Library

```lua

```lua
local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/SK3DCODER/SwizySense-Roblox/refs/heads/main/Swizy.Lib.lua')))()
```

```

## Creating a Window

```lua

```lua
local Window = Library:CreateWindow({
```

    Name = "Swizy.Lib",

    Size = UDim2.new(0, 650, 0, 450),

    Theme = "Dark"

})

```lua
--[[
```

Name = <string> - Window title.

Size = <UDim2> - Window size (width, height).

Theme = <string> - Theme (only "Dark" for now).

```lua
]]
```

```

## Creating a Tab

```lua

```lua
local Tab = Window:AddTab("Main")
```

```lua
--[[
```

Name = <string> - Tab name.

```lua
]]
### Creating a Section

```

lua

```lua
local Section = Tab:AddSection("Controls")
```

```lua
--[[
```

Name = <string> - Section name.

```lua
]]
### Notifications

```

lua

```lua
Library:MakeNotification({
```

    Name = "Title",

    Content = "Notification text",

    Time = 3

})

```lua
--[[
```

Name = <string> - Notification title.

Content = <string> - Notification text.

Time = <number> - Duration in seconds.

```lua
]]
### Prompt Dialog

```

lua

```lua
Library:MakePrompt({
```

    Title = "Confirmation",

    Text = "Are you sure?",

    Buttons = {"Yes", "No"},

    Callback = function(result)

```lua
        print("Selected: " .. result)
    end
```

})

```lua
--[[
```

Title = <string> - Prompt title.

Text = <string> - Question text.

Buttons = <table> - Button options (string array).

Callback = <function> - Function when button clicked.

```lua
]]
### Button

```

lua

```lua
local Button = Section:AddButton("Click Me", function()
    print("Button clicked!")
```

end)

```lua
--[[
```

First argument: <string> - Button text.

Second argument: <function> - Click callback.

```lua
]]
```

```lua
-- Change button text
Button:Set("New Text")
### Toggle

```

lua

```lua
local Toggle = Section:AddToggle("Enable", false, function(state)
    print("State:", state)
```

end)

```lua
--[[
```

First argument: <string> - Toggle text.

Second argument: <bool> - Default state (true/false).

Third argument: <function> - State change callback.

```lua
]]
```

```lua
-- Change state
Toggle:Set(true)  -- enable
Toggle:Set(false) -- disable
### Slider

```

lua

```lua
local Slider = Section:AddSlider("Speed", 0, 100, 50, function(value)
    print("Value:", value)
```

end)

```lua
--[[
```

First argument: <string> - Slider text.

Second argument: <number> - Minimum value.

Third argument: <number> - Maximum value.

Fourth argument: <number> - Default value.

Fifth argument: <function> - Value change callback.

```lua
]]
```

```lua
-- Set value
Slider:Set(75)
### Dropdown

```

lua

```lua
local Dropdown = Section:AddDropdown("Select", 
    {"Option 1", "Option 2", "Option 3"}, 
```

    "Option 1", 

    function(option)

```lua
        print("Selected:", option)
    end
```

)

```lua
--[[
```

First argument: <string> - Dropdown text.

Second argument: <table> - Options list.

Third argument: <string> - Default option.

Fourth argument: <function> - Selection callback.

```lua
]]
```

```lua
-- Select option programmatically
Dropdown:Set("Option 2")
### Menu Controls

```

lua

```lua
-- Toggle visibility
Library:ToggleMenu()              -- toggle
Library:ToggleMenu(true)          -- show
Library:ToggleMenu(false)         -- hide
```

```lua
-- Unload library completely
Library:Unload()
```

```lua
-- Alternative unload method
Library:Destroy()
### Hotkeys

```

RightShift - Open/close menu

U (top bar button) - Unload library

X (top bar button) - Hide menu

```

## Complete Example

```lua

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SK3DCODER/SwizySense-Roblox/refs/heads/main/Swizy.Lib.lua"))()
```

```lua
local Window = Library:CreateWindow({
```

    Name = "My Script",

    Size = UDim2.new(0, 600, 0, 400)

})

```lua
local MainTab = Window:AddTab("Main")
local Section = MainTab:AddSection("Features")
```

```lua
Section:AddButton("Test", function()
    Library:MakeNotification({
```

        Name = "Test",

        Content = "Working!",

        Time = 2

    })

end)

```lua
local Toggle = Section:AddToggle("Enable", false, function(state)
    print("State:", state)
```

end)

```lua
Section:AddSlider("Value", 0, 100, 50, function(value)
    print("Value:", value)
```

end)

```

