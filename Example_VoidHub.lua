local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ESP_Settings = { Enabled = false, Color = Color3.fromRGB(0, 255, 80) }

local function ApplyESP(character)
    if not character or character == LocalPlayer.Character then return end
    local h = character:FindFirstChild("ESP_Highlight")
    if ESP_Settings.Enabled then
        if not h then
            h = Instance.new("Highlight")
            h.Name = "ESP_Highlight"
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = character
        end
        h.Enabled = true
        h.FillColor = ESP_Settings.Color
        h.OutlineColor = Color3.new(1, 1, 1)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0.2
    elseif h then
        h.Enabled = false
    end
end

local function UpdateAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then ApplyESP(p.Character) end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c) task.wait(0.5) ApplyESP(c) end)
end)
for _, p in ipairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function(c) task.wait(0.5) ApplyESP(c) end)
end

-- use o arquivo local atualizado / seu host
local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()

local okL, Loader = pcall(function()
    return VoidUI:LoadingScreen({ Title = "Void Ui", Desc = "Loading..." })
end)
if okL and Loader then
    pcall(function() Loader:SetProgress(1) end)
    pcall(function() Loader:Close(0.05) end)
end

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
pcall(function() Window:SetBackgroundImage("rbxassetid://84152360484913", 0.25) end)

local T = {}
local names = {
    {"Visuals","eye"},{"Elements","sparkles"},{"Management","chart-no-axes-gantt"},
    {"Input","file-input"},{"Notify","message-square-dot"},{"Appearance","palette"},
    {"Dialog","message-circle"},{"Demo","layout-list"},{"Advanced","blocks"},
    {"Farm","sprout"},{"Player","user"},{"Misc","box"},{"Combat","swords"},
    {"Teleport","map-pin"},{"Settings","settings"},
}
for _, n in ipairs(names) do
    T[n[1]] = Window:Tab({ Title = n[1], Icon = n[2], Border = true })
end

-- VISUALS
T.Visuals:TabSection({ Title = "ESP" })
T.Visuals:Toggle({ Title = "ESP Chams", Default = false, Callback = function(v) ESP_Settings.Enabled = v UpdateAllESP() end })
T.Visuals:Toggle({ Title = "Team Check", Default = true, Callback = function() end })
T.Visuals:Toggle({ Title = "Show Names", Default = false, Callback = function() end })
T.Visuals:Toggle({ Title = "Show Distance", Default = true, Callback = function() end })
T.Visuals:Slider({ Title = "Fill Transparency", Value = { Min = 0, Max = 1, Default = 0.5 }, Step = 0.05, Callback = function() end })
T.Visuals:Slider({ Title = "Max Distance", Value = { Min = 50, Max = 2000, Default = 500 }, Step = 10, Callback = function() end })
T.Visuals:Dropdown({ Title = "ESP Mode", Option = { "Box", "Chams", "Highlight", "Name", "Skeleton" }, Value = "Chams", Callback = function() end })
T.Visuals:Dropdown({ Title = "Box Type", Option = { "2D", "3D", "Corner" }, Value = "2D", Callback = function() end })
pcall(function()
    T.Visuals:Colorpicker({ Title = "ESP Color", Default = ESP_Settings.Color, Callback = function(c) ESP_Settings.Color = c UpdateAllESP() end })
end)
T.Visuals:Button({ Title = "Refresh ESP", Callback = function() UpdateAllESP() Window:Notify({ Title = "ESP", Content = "Refreshed", Duration = 2 }) end })

-- ELEMENTS mass
T.Elements:TabSection({ Title = "Buttons" })
for i = 1, 25 do
    T.Elements:Button({ Title = "Action "..i, Callback = function() Window:Notify({ Title = "Action", Content = tostring(i), Duration = 1.2 }) end })
end
T.Elements:TabSection({ Title = "Toggles" })
for i = 1, 20 do
    T.Elements:Toggle({ Title = "Toggle "..i, Default = (i % 2 == 0), Callback = function() end })
end
T.Elements:TabSection({ Title = "Sliders" })
for i = 1, 15 do
    T.Elements:Slider({ Title = "Slider "..i, Value = { Min = 0, Max = 100, Default = i * 4 }, Step = 1, Callback = function() end })
end

-- MANAGEMENT
T.Management:TabSection({ Title = "Control" })
for i = 1, 10 do
    T.Management:Button({ Title = "Manage "..i, Callback = function() end })
end
for i = 1, 8 do
    T.Management:Paragraph({ Title = "Note "..i, Desc = "Info line "..i })
end
T.Management:Dropdown({ Title = "Priority", Option = { "Low", "Medium", "High", "Critical" }, Value = "Medium", Callback = function() end })

-- INPUT
T.Input:TabSection({ Title = "Fields" })
for i = 1, 12 do
    T.Input:Input({ Title = "Input "..i, Placeholder = "Type here...", Callback = function() end })
end
for i = 1, 6 do
    T.Input:Keybind({ Title = "Keybind "..i, Callback = function() end })
end

-- NOTIFY
T.Notify:TabSection({ Title = "Notifications" })
for i = 1, 12 do
    T.Notify:Button({ Title = "Notify "..i, Callback = function() Window:Notify({ Title = "N"..i, Content = "Message "..i, Duration = 2 }) end })
end

-- APPEARANCE
T.Appearance:TabSection({ Title = "Theme / Icons" })
T.Appearance:Dropdown({
    Title = "Theme",
    Option = {
        "Dark","Light","Pink","Blue","Purple","Yellow","Green","Brown","Red",
        "Cyan","Orange","Lime","Teal","Indigo","Violet","Magenta","Sky",
        "Amber","Emerald","Coral","Gold","Silver","Navy","Mint","Peach",
        "Lavender","Crimson","Forest","Midnight","Neon","Sunset","Ocean","Grape"
    },
    Value = "Dark",
    Callback = function(v) Window:SetTheme(v) end,
})
T.Appearance:Slider({ Title = "Transparency", Value = { Min = 0, Max = 1, Default = 0.15 }, Step = 0.05, Callback = function(v) pcall(function() Window:SetTransparency(v) end) end })
T.Appearance:Input({ Title = "Image ID", Placeholder = "rbxassetid://...", Callback = function(v) if v and #v > 0 then pcall(function() Window:SetBackgroundImage(v, 0.25) end) end end })
T.Appearance:Input({ Title = "Video ID", Placeholder = "rbxassetid://...", Callback = function(v) if v and #v > 0 then pcall(function() Window:SetBackgroundVideo(v, 0.3) end) end end })
T.Appearance:Dropdown({
    Title = "Language",
    Option = { "English","Português","Español","Français","Deutsch","Italiano","Русский","日本語","中文","한국어","Polish","Turkish","Dutch","Swedish","Arabic","Hindi","Thai","Vietnamese","Indonesian" },
    Value = "English",
    Callback = function(v) pcall(function() Window:SetLanguage(v) end) end,
})
T.Appearance:Button({ Title = "Acrylic On/Off", Callback = function() pcall(function() Window:ToggleAcrylic(not Window.Acrylic) end) end })

-- DIALOG
T.Dialog:TabSection({ Title = "Dialogs" })
T.Dialog:Button({ Title = "Confirm Dialog", Callback = function()
    pcall(function()
        Window:Dialog({ Title = "Confirm", Content = "Continue?", Buttons = {
            { Title = "Yes", Callback = function() end },
            { Title = "No", Callback = function() end },
        }})
    end)
end })
T.Dialog:Button({ Title = "Popup", Callback = function() pcall(function() Window:Popup({ Title = "Popup", Content = "Hello" }) end) end })
T.Dialog:Button({ Title = "Tooltip", Callback = function() pcall(function() Window:ShowTooltip("Tooltip text", 2) end) end })
for i = 1, 8 do
    T.Dialog:Button({ Title = "Dialog Action "..i, Callback = function() end })
end

-- DEMO
T.Demo:TabSection({ Title = "Animals" })
local pets = {}
for i = 1, 40 do pets[i] = "Item A"..i end
T.Demo:Dropdown({ Title = "Target", Option = pets, Value = "Item A1", Callback = function(v) print(v) end })
T.Demo:Dropdown({ Title = "Main Category", Option = { "All", "Pets", "Food", "Tools", "Rare" }, Value = "All", Callback = function() end })
T.Demo:TabSection({ Title = "Controls" })
for i = 1, 10 do
    T.Demo:Toggle({ Title = "Demo Toggle "..i, Default = false, Callback = function() end })
end
for i = 1, 8 do
    T.Demo:Button({ Title = "Demo Button "..i, Callback = function() end })
end
T.Demo:Dropdown({ Title = "Fruits", Multi = true, Option = { "Apple","Banana","Orange","Mango","Grape","Kiwi","Pear" }, Value = { "Apple" }, Callback = function() end })

-- ADVANCED
T.Advanced:TabSection({ Title = "Extra" })
pcall(function() T.Advanced:Accordion({ Title = "Info", Content = "Extra details here.", Open = false }) end)
pcall(function() T.Advanced:Timeline({ Title = "Steps", Steps = { "Load","Auth","Ready","Done" }, Index = 2 }) end)
pcall(function() T.Advanced:ChipList({ Title = "Tags", Options = { "PvP","Farm","Safe","VIP" }, Value = { "Farm" }, Callback = function() end }) end)
pcall(function() T.Advanced:SegmentedControl({ Title = "Mode", Options = { "Easy","Normal","Hard" }, Value = "Normal", Callback = function() end }) end)
pcall(function() T.Advanced:Path2D({ Title = "Chart", Values = { 0.2,0.5,0.4,0.8,0.6 } }) end)
pcall(function() T.Advanced:Viewport({ Title = "Preview", Image = "84152360484913" }) end)
T.Advanced:Button({ Title = "Save Config", Callback = function() pcall(function() Window:SetConfig("x", true) Window:SaveConfig("VoidHub") end) end })
T.Advanced:Button({ Title = "Load Config", Callback = function() pcall(function() Window:LoadConfig("VoidHub") end) end })
for i = 1, 10 do
    T.Advanced:Button({ Title = "Adv Action "..i, Callback = function() end })
end

-- FARM
T.Farm:TabSection({ Title = "Farming" })
for i = 1, 15 do
    T.Farm:Toggle({ Title = "Farm Option "..i, Default = false, Callback = function() end })
end
for i = 1, 10 do
    T.Farm:Dropdown({ Title = "Crop "..i, Option = { "A","B","C","D" }, Value = "A", Callback = function() end })
end
for i = 1, 5 do
    T.Farm:Slider({ Title = "Speed "..i, Value = { Min = 1, Max = 10, Default = 3 }, Step = 1, Callback = function() end })
end

-- PLAYER
T.Player:TabSection({ Title = "Player" })
for i = 1, 15 do
    T.Player:Toggle({ Title = "Player Flag "..i, Default = false, Callback = function() end })
end
for i = 1, 8 do
    T.Player:Slider({ Title = "Stat "..i, Value = { Min = 0, Max = 100, Default = 50 }, Step = 1, Callback = function() end })
end
for i = 1, 5 do
    T.Player:Button({ Title = "Player Action "..i, Callback = function() end })
end

-- MISC
T.Misc:TabSection({ Title = "Misc" })
for i = 1, 15 do
    T.Misc:Button({ Title = "Misc "..i, Callback = function() end })
end
for i = 1, 10 do
    T.Misc:Toggle({ Title = "Misc Toggle "..i, Default = false, Callback = function() end })
end

-- COMBAT
T.Combat:TabSection({ Title = "Combat" })
for i = 1, 12 do
    T.Combat:Toggle({ Title = "Combat "..i, Default = false, Callback = function() end })
end
for i = 1, 8 do
    T.Combat:Slider({ Title = "Damage "..i, Value = { Min = 1, Max = 100, Default = 25 }, Step = 1, Callback = function() end })
end
T.Combat:Dropdown({ Title = "Weapon", Option = { "Sword","Gun","Bow","Staff","Fist" }, Value = "Sword", Callback = function() end })

-- TELEPORT
T.Teleport:TabSection({ Title = "Locations" })
for i = 1, 15 do
    T.Teleport:Button({ Title = "TP Location "..i, Callback = function() Window:Notify({ Title = "TP", Content = "Location "..i, Duration = 1.5 }) end })
end
T.Teleport:Dropdown({ Title = "World", Option = { "Spawn","City","Forest","Desert","Snow","Volcano" }, Value = "Spawn", Callback = function() end })

-- SETTINGS
T.Settings:TabSection({ Title = "Window" })
T.Settings:Toggle({ Title = "Resizing", Default = true, Callback = function(v) pcall(function() Window:SetResizable(v) end) end })
T.Settings:Button({ Title = "To Center", Callback = function() pcall(function() Window:ToCenter() end) end })
T.Settings:Button({ Title = "Fullscreen", Callback = function() pcall(function() Window:ToggleFullscreen() end) end })
T.Settings:Button({ Title = "Lock Window", Callback = function() pcall(function() Window:LockAll() end) end })
T.Settings:Button({ Title = "Unlock Window", Callback = function() pcall(function() Window:UnlockAll() end) end })
T.Settings:Button({ Title = "Destroy UI", Callback = function() pcall(function() Window:Destroy() end) end })
for i = 1, 8 do
    T.Settings:Toggle({ Title = "Setting "..i, Default = false, Callback = function() end })
end

-- força primeira aba aberta (depois de tudo criado)
task.wait(0.15)
pcall(function() Window:SelectFirstTab() end)
pcall(function() Window:SelectTab(1) end)
pcall(function() Window:Open() end)
pcall(function() Window:SelectFirstTab() end)

print("[Void Ui] Example loaded")
