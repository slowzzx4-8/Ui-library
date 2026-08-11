--[[ Void Ui Example — ~150 elements + Theme ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Ui%20Library.lua"))()

local Window = VoidUI:CreateWindow({
    Name = "Void Ui",
    Icon = "door-open",
    SideBarWidth = 160,
    Theme = "Dark",
    Transparent = true,
    Author = "By Slowzzx4",
    User = { Enabled = true, Anonymous = true },
})

Window:EditOpenButton({
    Title = "Open Void Ui",
    Icon = "door-open",
    Transparency = 0.2,
    StrokeThickness = 1,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255)),
    },
    AutoRotation = true,
    Speed = 15,
    CornerRadius = UDim.new(0, 16),
})

pcall(function() Window:SetWatermark("Void Ui  •  " .. LocalPlayer.Name) end)
pcall(function() Window:SetToggleKey(Enum.KeyCode.F) end)

local T = {}
for _, d in ipairs({
    {"Theme","palette"},{"Main","home"},{"Player","user"},{"Visuals","eye"},
    {"Farm","sprout"},{"Combat","swords"},{"Teleport","map-pin"},
    {"Demo","layout-list"},{"Advanced","blocks"},{"Settings","settings"},
}) do
    T[d[1]] = Window:Tab({ Title = d[1], Icon = d[2], Border = true })
end

-- ========== THEME ==========
local SelectedTheme, IconColor = "Dark", Color3.fromRGB(200, 200, 200)
T.Theme:TabSection({ Title = "Theme" })
T.Theme:Dropdown({
    Title = "Theme",
    Option = {
        "Dark","Light","White","Gray","Stone","Zinc","Slate","Rose",
        "Pink","Blue","Purple","Yellow","Green","Brown","Red","Cyan","Orange",
        "Lime","Teal","Indigo","Violet","Magenta","Sky","Amber","Emerald",
        "Coral","Gold","Silver","Navy","Mint","Peach","Lavender","Crimson",
        "Forest","Midnight","Neon","Sunset","Ocean","Grape",
    },
    Value = "Dark",
    Callback = function(v) SelectedTheme = v end,
})
pcall(function()
    T.Theme:Colorpicker({
        Title = "Icon Color",
        Default = IconColor,
        Callback = function(c) IconColor = c end,
    })
end)
T.Theme:Button({
    Title = "Apply Theme / Icons",
    Callback = function()
        pcall(function()
            if VoidUI.Themes and VoidUI.Themes[SelectedTheme] then
                VoidUI.Themes[SelectedTheme].IconColor = IconColor
            end
            Window:SetTheme(SelectedTheme)
        end)
        Window:Notify({ Title = "Theme", Content = "Applied: " .. SelectedTheme, Duration = 2 })
    end,
})
T.Theme:TabSection({ Title = "Background" })
local ImageInput = T.Theme:Input({ Title = "Image ID", Placeholder = "rbxassetid:// ou número", Callback = function() end })
T.Theme:Button({
    Title = "Apply Image Background",
    Callback = function()
        local id = (ImageInput and ImageInput.GetValue and ImageInput:GetValue()) or ""
        id = tostring(id):gsub("%s+", "")
        if id == "" then Window:Notify({ Title = "BG", Content = "Empty id", Duration = 2 }) return end
        pcall(function() Window:SetBackgroundImage(id, 0.25) end)
        Window:Notify({ Title = "BG", Content = "Image applied", Duration = 2 })
    end,
})
local VideoInput = T.Theme:Input({ Title = "Video ID", Placeholder = "rbxassetid:// ou número", Callback = function() end })
T.Theme:Button({
    Title = "Apply Video Background",
    Callback = function()
        local id = (VideoInput and VideoInput.GetValue and VideoInput:GetValue()) or ""
        id = tostring(id):gsub("%s+", "")
        if id == "" then Window:Notify({ Title = "BG", Content = "Empty id", Duration = 2 }) return end
        pcall(function() Window:SetBackgroundVideo(id, 0.3) end)
        Window:Notify({ Title = "BG", Content = "Video applied", Duration = 2 })
    end,
})
T.Theme:TabSection({ Title = "Window" })
T.Theme:Toggle({ Title = "Resizing", Default = true, Callback = function(v) pcall(function() Window:SetResizable(v) end) end })
T.Theme:Slider({ Title = "Acrylic", Value = { Min = 0, Max = 1, Default = 0 }, Step = 0.05, Callback = function(v)
    pcall(function() Window:ToggleAcrylic(v > 0.05) if v <= 0.05 then Window:SetTransparency(0.1) end end)
end })
T.Theme:Slider({ Title = "UI Transparency", Value = { Min = 0, Max = 1, Default = 0.15 }, Step = 0.05, Callback = function(v)
    pcall(function() Window:SetTransparency(v) end)
end })
T.Theme:Toggle({ Title = "User", Default = true, Callback = function(v) pcall(function() Window:UserEnabled(v) end) end })
T.Theme:Toggle({ Title = "Anonymous", Default = true, Callback = function(v) pcall(function() Window:Anonymous(v) end) end })
T.Theme:Keybind({ Title = "Toggle UI Key", Default = "F", Callback = function(k)
    pcall(function()
        if typeof(k) == "string" and Enum.KeyCode[k] then Window:SetToggleKey(Enum.KeyCode[k])
        else Window:SetToggleKey(Enum.KeyCode.F) end
    end)
end })

-- ========== MAIN (muitos exemplos) ==========
T.Main:TabSection({ Title = "Buttons" })
for i = 1, 20 do
    local n = i
    T.Main:Button({ Title = "Action " .. n, Callback = function()
        Window:Notify({ Title = "Action", Content = "Pressed " .. n, Duration = 1.2 })
    end })
end
T.Main:TabSection({ Title = "Toggles" })
for i = 1, 15 do
    T.Main:Toggle({ Title = "Option " .. i, Default = (i % 2 == 0), Callback = function(v) print("T"..i, v) end })
end
T.Main:TabSection({ Title = "Sliders" })
for i = 1, 10 do
    T.Main:Slider({ Title = "Value " .. i, Value = { Min = 0, Max = 100, Default = i * 5 }, Step = 1, Callback = function(v) end })
end

-- Player
T.Player:TabSection({ Title = "Movement" })
T.Player:Slider({ Title = "WalkSpeed", Value = { Min = 16, Max = 200, Default = 16 }, Step = 1, Callback = function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end })
T.Player:Slider({ Title = "JumpPower", Value = { Min = 50, Max = 200, Default = 50 }, Step = 1, Callback = function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = v end
end })
for i = 1, 8 do
    T.Player:Toggle({ Title = "Player Flag " .. i, Default = false, Callback = function() end })
end
for i = 1, 5 do
    T.Player:Button({ Title = "Player Action " .. i, Callback = function() end })
end

-- Visuals
T.Visuals:TabSection({ Title = "ESP" })
T.Visuals:Toggle({ Title = "ESP Enabled", Default = false, Callback = function() end })
T.Visuals:Toggle({ Title = "Team Check", Default = true, Callback = function() end })
T.Visuals:Slider({ Title = "Distance", Value = { Min = 50, Max = 2000, Default = 500 }, Step = 25, Callback = function() end })
T.Visuals:Dropdown({ Title = "Mode", Option = { "Box", "Chams", "Highlight", "Name" }, Value = "Chams", Callback = function() end })
pcall(function() T.Visuals:Colorpicker({ Title = "ESP Color", Default = Color3.fromRGB(0, 255, 80), Callback = function() end }) end)
for i = 1, 6 do T.Visuals:Button({ Title = "Visual Action " .. i, Callback = function() end }) end

-- Farm
T.Farm:TabSection({ Title = "Auto" })
for i = 1, 10 do T.Farm:Toggle({ Title = "Farm " .. i, Default = false, Callback = function() end }) end
for i = 1, 5 do T.Farm:Dropdown({ Title = "Crop " .. i, Option = { "A", "B", "C", "D" }, Value = "A", Callback = function() end }) end
for i = 1, 5 do T.Farm:Slider({ Title = "Speed " .. i, Value = { Min = 1, Max = 10, Default = 3 }, Step = 1, Callback = function() end }) end

-- Combat
T.Combat:TabSection({ Title = "Combat" })
for i = 1, 8 do T.Combat:Toggle({ Title = "Combat " .. i, Default = false, Callback = function() end }) end
for i = 1, 5 do T.Combat:Slider({ Title = "Damage " .. i, Value = { Min = 1, Max = 100, Default = 25 }, Step = 1, Callback = function() end }) end
T.Combat:Dropdown({ Title = "Weapon", Option = { "Sword", "Gun", "Bow", "Staff" }, Value = "Sword", Callback = function() end })

-- Teleport
T.Teleport:TabSection({ Title = "Locations" })
for i = 1, 12 do
    local n = i
    T.Teleport:Button({ Title = "TP Loc " .. n, Callback = function()
        Window:Notify({ Title = "TP", Content = "Location " .. n, Duration = 1.2 })
    end })
end
T.Teleport:Dropdown({ Title = "World", Option = { "Spawn", "City", "Forest", "Desert", "Snow" }, Value = "Spawn", Callback = function() end })

-- Demo
T.Demo:TabSection({ Title = "Dropdowns" })
local big = {}
for i = 1, 40 do big[i] = "Item A" .. i end
T.Demo:Dropdown({ Title = "Target", Option = big, Value = "Item A1", Callback = function(v) print(v) end })
T.Demo:Dropdown({ Title = "Category", Option = { "All", "Pets", "Food", "Tools" }, Value = "All", Callback = function() end })
T.Demo:Dropdown({ Title = "Multi", Multi = true, Option = { "A", "B", "C", "D", "E" }, Value = { "A" }, Callback = function() end })
for i = 1, 5 do T.Demo:Button({ Title = "Demo " .. i, Callback = function() end }) end

-- Advanced
T.Advanced:TabSection({ Title = "Extra" })
pcall(function() T.Advanced:Accordion({ Title = "Info", Content = "Details here", Open = false }) end)
pcall(function() T.Advanced:Timeline({ Title = "Steps", Steps = { "A", "B", "C" }, Index = 2 }) end)
pcall(function() T.Advanced:ChipList({ Title = "Tags", Options = { "PvP", "Farm", "VIP" }, Value = { "Farm" }, Callback = function() end }) end)
pcall(function() T.Advanced:SegmentedControl({ Title = "Mode", Options = { "Easy", "Normal", "Hard" }, Value = "Normal", Callback = function() end }) end)
pcall(function() T.Advanced:Path2D({ Title = "Chart", Values = { 0.2, 0.5, 0.8, 0.4 } }) end)
for i = 1, 5 do T.Advanced:Button({ Title = "Adv " .. i, Callback = function() end }) end

-- Settings
T.Settings:TabSection({ Title = "Window" })
T.Settings:Button({ Title = "To Center", Callback = function() pcall(function() Window:ToCenter() end) end })
T.Settings:Button({ Title = "Fullscreen", Callback = function() pcall(function() Window:ToggleFullscreen() end) end })
T.Settings:Button({ Title = "Lock All", Callback = function() pcall(function() Window:LockAll() end) end })
T.Settings:Button({ Title = "Unlock All", Callback = function() pcall(function() Window:UnlockAll() end) end })
T.Settings:Button({ Title = "Destroy UI", Callback = function() pcall(function() Window:Destroy() end) end })

-- 1ª execução: abre a UI (library já seleciona a 1ª aba)
-- minimize/reabrir: mantém a última aba escolhida
task.wait(0.08)
pcall(function()
    Window._SavedTabIndex = Window._SavedTabIndex or 1
    Window:SelectTab(Window._SavedTabIndex or 1)
end)
pcall(function() Window:Open() end)
print("[Void Ui] Example loaded (~150 elements)")
