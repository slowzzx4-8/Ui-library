local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ESP_Settings = { Enabled = false, Color = Color3.fromRGB(0, 255, 80) }
local SpeedVal, JumpVal = 16, 50
local AutoFarm, AutoCollect = false, false

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

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()

local Window = VoidUI:CreateWindow({
    Name = "Void Ui",
    Icon = "door-open",
    SideBarWidth = 160,
    Theme = "Dark",
    Transparent = true,
    Author = "By Slowzzx4",
    User = { Enabled = true, Anonymous = true },
    KeySystem = {
        Key = "1234",
        Note = "Password: 1234",
        SaveKey = false,
        KeyValidator = function(key)
            return tostring(key) == "1234"
        end,
        Discord = "https://discord.gg/",
    },
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
for _, n in ipairs({
    {"Visuals","eye"},{"Player","user"},{"Farm","sprout"},{"Combat","swords"},
    {"Teleport","map-pin"},{"Demo","layout-list"},{"Advanced","blocks"},
    {"Appearance","palette"},{"Settings","settings"},
}) do
    T[n[1]] = Window:Tab({ Title = n[1], Icon = n[2], Border = true })
end

-- Visuals
T.Visuals:TabSection({ Title = "ESP" })
T.Visuals:Toggle({ Title = "ESP Chams", Default = false, Callback = function(v) ESP_Settings.Enabled = v UpdateAllESP() Window:Notify({ Title = "ESP", Content = v and "On" or "Off", Duration = 1.5 }) end })
T.Visuals:Toggle({ Title = "Team Check", Default = true, Callback = function(v) print("TeamCheck", v) end })
T.Visuals:Toggle({ Title = "Show Names", Default = false, Callback = function(v) print("Names", v) end })
T.Visuals:Slider({ Title = "ESP Distance", Value = { Min = 50, Max = 2000, Default = 500 }, Step = 25, Callback = function(v) print("Dist", v) end })
T.Visuals:Dropdown({ Title = "ESP Mode", Option = { "Box", "Chams", "Highlight", "Name", "Skeleton" }, Value = "Chams", Callback = function(v) print("Mode", v) end })
pcall(function()
    T.Visuals:Colorpicker({ Title = "ESP Color", Default = ESP_Settings.Color, Callback = function(c) ESP_Settings.Color = c UpdateAllESP() end })
end)
T.Visuals:Button({ Title = "Refresh ESP", Callback = function() UpdateAllESP() Window:Notify({ Title = "ESP", Content = "Refreshed", Duration = 2 }) end })

-- Player
T.Player:TabSection({ Title = "Movement" })
T.Player:Slider({ Title = "WalkSpeed", Value = { Min = 16, Max = 200, Default = 16 }, Step = 1, Callback = function(v)
    SpeedVal = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end })
T.Player:Slider({ Title = "JumpPower", Value = { Min = 50, Max = 200, Default = 50 }, Step = 1, Callback = function(v)
    JumpVal = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v end
end })
T.Player:Toggle({ Title = "Infinite Jump", Default = false, Callback = function(v) print("InfJump", v) end })
T.Player:Toggle({ Title = "No Clip", Default = false, Callback = function(v) print("NoClip", v) end })
T.Player:Button({ Title = "Reset Character", Callback = function()
    local ch = LocalPlayer.Character
    if ch then ch:BreakJoints() end
end })
T.Player:Input({ Title = "Display Name", Placeholder = "Name...", Callback = function(v) print("Name", v) end })

-- Farm
T.Farm:TabSection({ Title = "Auto" })
T.Farm:Toggle({ Title = "Auto Farm", Default = false, Callback = function(v) AutoFarm = v Window:Notify({ Title = "Farm", Content = v and "Started" or "Stopped", Duration = 2 }) end })
T.Farm:Toggle({ Title = "Auto Collect", Default = false, Callback = function(v) AutoCollect = v end })
T.Farm:Dropdown({ Title = "Farm Area", Option = { "Spawn", "Cave", "Mountain", "City", "All" }, Value = "Spawn", Callback = function(v) print("Area", v) end })
T.Farm:Slider({ Title = "Farm Speed", Value = { Min = 1, Max = 10, Default = 3 }, Step = 1, Callback = function(v) print("FarmSpeed", v) end })
T.Farm:Button({ Title = "Collect Once", Callback = function() Window:Notify({ Title = "Farm", Content = "Collected", Duration = 1.5 }) end })

-- Combat
T.Combat:TabSection({ Title = "Combat" })
T.Combat:Toggle({ Title = "Kill Aura", Default = false, Callback = function(v) print("KA", v) end })
T.Combat:Slider({ Title = "Aura Range", Value = { Min = 5, Max = 50, Default = 15 }, Step = 1, Callback = function(v) print("Range", v) end })
T.Combat:Dropdown({ Title = "Weapon", Option = { "Sword", "Gun", "Bow", "Staff", "Fist" }, Value = "Sword", Callback = function(v) print(v) end })
T.Combat:Button({ Title = "Attack Nearest", Callback = function() Window:Notify({ Title = "Combat", Content = "Attack", Duration = 1 }) end })

-- Teleport
T.Teleport:TabSection({ Title = "Locations" })
local places = { "Spawn", "Shop", "Arena", "Forest", "Desert", "Snow", "Volcano", "Secret" }
for _, place in ipairs(places) do
    T.Teleport:Button({ Title = "TP " .. place, Callback = function()
        Window:Notify({ Title = "Teleport", Content = place, Duration = 1.5 })
    end })
end
T.Teleport:Dropdown({ Title = "World", Option = places, Value = "Spawn", Callback = function(v) print("World", v) end })
T.Teleport:Input({ Title = "Custom Position", Placeholder = "x,y,z", Callback = function(v) print("Pos", v) end })

-- Demo dropdown style Wind
T.Demo:TabSection({ Title = "Dropdown Test" })
local items = {}
for i = 1, 40 do items[i] = "Item A" .. i end
T.Demo:Dropdown({ Title = "Target", Option = items, Value = "Item A1", Callback = function(v) print("Target", v) end })
T.Demo:Dropdown({ Title = "Main Category", Option = { "All", "Pets", "Food", "Tools", "Rare" }, Value = "All", Callback = function(v) print(v) end })
T.Demo:Dropdown({ Title = "Multi Fruits", Multi = true, Option = { "Apple", "Banana", "Orange", "Mango", "Grape" }, Value = { "Apple" }, Callback = function(v) print(v) end })
T.Demo:TabSection({ Title = "Quick" })
T.Demo:Button({ Title = "Copy Discord", Callback = function() pcall(function() setclipboard("https://discord.gg/") end) Window:Notify({ Title = "Copied", Content = "Discord link", Duration = 2 }) end })
T.Demo:Button({ Title = "Show Popup", Callback = function()
    pcall(function()
        Window:Popup({ Title = "Void Ui", Content = "Popup example — key is 1234", Buttons = {
            { Title = "OK", Callback = function() end },
        }})
    end)
end })
T.Demo:Button({ Title = "Show Tooltip", Callback = function() pcall(function() Window:ShowTooltip("Tooltip Void Ui", 2) end) end })

-- Advanced
T.Advanced:TabSection({ Title = "Components" })
pcall(function() T.Advanced:Accordion({ Title = "Info", Content = "Accordion body text.", Open = false }) end)
pcall(function() T.Advanced:Timeline({ Title = "Steps", Steps = { "Load", "Key", "Ready" }, Index = 2 }) end)
pcall(function() T.Advanced:ChipList({ Title = "Tags", Options = { "PvP", "Farm", "Safe" }, Value = { "Farm" }, Callback = function(v) print(v) end }) end)
pcall(function() T.Advanced:SegmentedControl({ Title = "Difficulty", Options = { "Easy", "Normal", "Hard" }, Value = "Normal", Callback = function(v) print(v) end }) end)
pcall(function() T.Advanced:Path2D({ Title = "Chart", Values = { 0.2, 0.5, 0.8, 0.4, 0.7 } }) end)
pcall(function() T.Advanced:TabBox({ Title = "TabBox", Tabs = {
    { Title = "A", Content = "Content A" },
    { Title = "B", Content = "Content B" },
    { Title = "C", Content = "Content C" },
} }) end)
T.Advanced:Button({ Title = "Save Config", Callback = function() pcall(function() Window:SetConfig("speed", SpeedVal) Window:SaveConfig("VoidHub") end) end })
T.Advanced:Button({ Title = "Load Config", Callback = function() pcall(function() Window:LoadConfig("VoidHub") end) end })

-- Appearance
T.Appearance:TabSection({ Title = "Theme" })
T.Appearance:Dropdown({
    Title = "Theme",
    Option = {
        "Dark","Light","White","Gray","Stone","Zinc","Slate","Rose",
        "Pink","Blue","Purple","Yellow","Green","Brown","Red","Cyan","Orange",
        "Lime","Teal","Indigo","Violet","Magenta","Sky","Amber","Emerald",
        "Coral","Gold","Silver","Navy","Mint","Peach","Lavender","Crimson",
        "Forest","Midnight","Neon","Sunset","Ocean","Grape"
    },
    Value = "Dark",
    Callback = function(v) Window:SetTheme(v) end,
})
T.Appearance:Slider({ Title = "Transparency", Value = { Min = 0, Max = 1, Default = 0.15 }, Step = 0.05, Callback = function(v) pcall(function() Window:SetTransparency(v) end) end })
T.Appearance:Input({ Title = "Image ID", Placeholder = "rbxassetid://...", Callback = function(v) if v and #v > 3 then pcall(function() Window:SetBackgroundImage(v, 0.25) end) end end })
T.Appearance:Input({ Title = "Video ID", Placeholder = "rbxassetid://...", Callback = function(v) if v and #v > 3 then pcall(function() Window:SetBackgroundVideo(v, 0.3) end) end end })
T.Appearance:Button({ Title = "Acrylic Toggle", Callback = function() pcall(function() Window:ToggleAcrylic(not Window.Acrylic) end) end })

-- Settings
T.Settings:TabSection({ Title = "Window" })
T.Settings:Toggle({ Title = "Resizing", Default = true, Callback = function(v) pcall(function() Window:SetResizable(v) end) end })
T.Settings:Button({ Title = "To Center", Callback = function() pcall(function() Window:ToCenter() end) end })
T.Settings:Button({ Title = "Fullscreen", Callback = function() pcall(function() Window:ToggleFullscreen() end) end })
T.Settings:Button({ Title = "Lock All", Callback = function() pcall(function() Window:LockAll() end) end })
T.Settings:Button({ Title = "Unlock All", Callback = function() pcall(function() Window:UnlockAll() end) end })
T.Settings:Button({ Title = "Destroy UI", Callback = function() pcall(function() Window:Destroy() end) end })

task.wait(0.1)
pcall(function() Window:SelectFirstTab() end)
pcall(function() Window:Open() end)
pcall(function() Window:SelectFirstTab() end)
print("[Void Ui] ready — key 1234")
