local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ESP_Settings = {
    Enabled = false,
    Color = Color3.fromRGB(0, 255, 80)
}

local function ApplyESP(character)
    if not character or character == LocalPlayer.Character then return end
    local highlight = character:FindFirstChild("ESP_Highlight")
    if ESP_Settings.Enabled then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character
        end
        highlight.Enabled = true
        highlight.FillColor = ESP_Settings.Color
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.2
    else
        if highlight then highlight.Enabled = false end
    end
end

local function UpdateAllESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ApplyESP(player.Character)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        ApplyESP(character)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        ApplyESP(character)
    end)
end

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()

local Loader = VoidUI:LoadingScreen({ Title = "Void Hub", Desc = "Loading..." })
Loader:SetProgress(0.4)
task.wait(0.15)
Loader:SetProgress(1)
Loader:Close(0.1)

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
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255))
    },
    AutoRotation = true,
    Speed = 15,
    CornerRadius = UDim.new(0, 16),
})

Window:SetWatermark("Void Hub  •  " .. LocalPlayer.Name)
Window:SetBackgroundImage("rbxassetid://84152360484913", 0.45)

local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye", Border = true })
local NewElements = Window:Tab({ Title = "New Elements", Icon = "sparkles", Border = true })
local DisplayTab = Window:Tab({ Title = "Display", Icon = "picture-in-picture", Border = true })
local ManagementTab = Window:Tab({ Title = "Management", Icon = "chart-no-axes-gantt", Border = true })
local InputTab = Window:Tab({ Title = "Input", Icon = "file-input", Border = true })
local NotificationTab = Window:Tab({ Title = "Notification", Icon = "message-square-dot", Border = true })
local LockedTab = Window:Tab({ Title = "Locked", Icon = "lock-keyhole", Border = true })
local GroupTab = Window:Tab({ Title = "Group", Icon = "group", Border = true })
local BackgroundTab = Window:Tab({ Title = "Background", Icon = "image", Border = true })
Window:SelectTab(1)

local Section = Window:Section({ Title = "Other", Icon = "hash" })
local Settings = Section:Tab({ Title = "Settings", Icon = "settings", Border = true })

-- Visuals
VisualsTab:Section({ Title = "ESP" })
VisualsTab:Toggle({
    Title = "ESP Chams",
    Default = false,
    Callback = function(v)
        ESP_Settings.Enabled = v
        UpdateAllESP()
    end
})
VisualsTab:Colorpicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(0, 255, 80),
    Callback = function(c)
        ESP_Settings.Color = c
        UpdateAllESP()
    end
})

-- New Elements
NewElements:Section({ Title = "Progress / Checkbox / Radio" })
local Progress = NewElements:ProgressBar({ Title = "Loading Progress", Value = 35, Max = 100 })
NewElements:Button({ Title = "Progress +10", Callback = function() Progress:Set(math.min(100, (Progress.Value or 0) + 10)) end })
NewElements:Checkbox({ Title = "Enable Feature", Default = false, Callback = function(v) print(v) end })
NewElements:Radio({ Title = "Aim Mode", Option = {"Mouse", "Camera", "Silent"}, Value = "Mouse", Callback = function(v) print(v) end })

NewElements:Section({ Title = "Badge / Label / KeyValue / Stepper" })
NewElements:Badge({ Title = "Status", Text = "ONLINE", Color = Color3.fromRGB(40, 180, 80) })
NewElements:Label({ Title = "Info Label" })
NewElements:KeyValue({ Title = "Version", Value = "1.0.0" })
NewElements:Stepper({ Title = "Amount", Value = { Min = 0, Max = 50, Default = 5 }, Step = 1, Callback = function(v) print(v) end })

NewElements:Section({ Title = "Code / Empty / Discord" })
NewElements:Code({ Title = "Code", Code = "print('Void Hub')" })
NewElements:EmptyState({ Title = "Empty", Desc = "No items", Icon = "search" })
NewElements:Discord({ Title = "Discord", URL = "https://discord.gg/your-invite" })

-- Background
BackgroundTab:Section({ Title = "Background" })
local lastImageId = "84152360484913"
BackgroundTab:Input({
    Title = "Image ID",
    Callback = function(text)
        lastImageId = tostring(text or ""):gsub("%D", "")
        if lastImageId ~= "" then
            Window:SetBackgroundImage("rbxassetid://" .. lastImageId, 0.45)
        end
    end
})
BackgroundTab:Button({
    Title = "Apply Image",
    Callback = function()
        if lastImageId ~= "" then
            Window:SetBackgroundImage("rbxassetid://" .. lastImageId, 0.45)
        end
    end
})
BackgroundTab:Button({
    Title = "Gradient",
    Callback = function()
        Window:SetBackgroundGradient(ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15)),
        }), 45, 0.2)
    end
})
BackgroundTab:Colorpicker({ Title = "Solid Color", Default = Color3.fromRGB(16, 16, 16), Callback = function(c) Window:SetBackgroundColor(c) end })
BackgroundTab:Slider({ Title = "Transparency", Value = { Min = 0, Max = 100, Default = 45 }, Step = 1, Callback = function(v) Window:SetBackgroundImageTransparency(v / 100) end })
BackgroundTab:Button({ Title = "Clear", Callback = function() Window:ClearBackground() end })

-- Display
DisplayTab:Section({ Title = "Text" })
DisplayTab:Paragraph({ Title = "Paragraph", Desc = "Short text" })
DisplayTab:Paragraph({ Title = "With Icon <smile>", Icon = "bird" })
DisplayTab:Devider()
DisplayTab:Paragraph({ Title = "Thumbnail", Thumbnail = "rbxassetid://78903626783621", Icon = "bird" })

-- Management
ManagementTab:Button({ Title = "Button", Callback = function() print("Click") end })
ManagementTab:Toggle({ Title = "Toggle", Callback = function(v) print(v) end })
ManagementTab:Slider({ Title = "Slider", Value = { Min = 0, Max = 100, Default = 25 }, Step = 1, Callback = function(v) print(v) end })
ManagementTab:Dropdown({
    Title = "Dropdown",
    Multi = false,
    Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"},
    Value = "Option 1",
    Callback = function(v) print(v) end
})
ManagementTab:Dropdown({
    Title = "Multi Dropdown",
    Multi = true,
    Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"},
    Value = "Option 1",
    Callback = function(v) print(unpack(v)) end
})
ManagementTab:Colorpicker({ Title = "Color", Default = Color3.fromRGB(100, 160, 255), Callback = function(c) print(c) end })

-- Input
InputTab:Input({ Title = "Input", Callback = function(i) print(i) end })
InputTab:Input({ Title = "Limited", MaxSymbols = 10, Callback = function(i) print(i) end })
InputTab:Keybind({ Title = "Keybind", Callback = function(k) print(k) end })

-- Notification
NotificationTab:Button({
    Title = "Notify",
    Callback = function()
        VoidUI:Notification({ Title = "Void Hub", Desc = "Hello", Icon = "bird", Duration = 4 })
    end
})
NotificationTab:Button({
    Title = "Notify Icon",
    Callback = function()
        VoidUI:Notification({ Title = "Alert", Icon = "bell", Desc = "Done", Duration = 3 })
    end
})

-- Locked
local LockBtn = LockedTab:Button({ Title = "Button", Locked = true, Callback = function() end })
local LockTog = LockedTab:Toggle({ Title = "Toggle", Locked = true, Callback = function() end })
local LockSlider = LockedTab:Slider({ Title = "Slider", Locked = true, Value = { Min = 0, Max = 100, Default = 25 }, Step = 1, Callback = function() end })
local LockDrop = LockedTab:Dropdown({ Title = "Dropdown", Locked = true, Multi = false, Option = {"A", "B", "C"}, Value = "A", Callback = function() end })
local LockInp = LockedTab:Input({ Title = "Input", Locked = true, Callback = function() end })
local LockKey = LockedTab:Keybind({ Title = "Keybind", Locked = true, Callback = function() end })
LockedTab:Toggle({
    Title = "Lock All",
    Default = true,
    Callback = function(v)
        if v then
            LockBtn:Lock(); LockTog:Lock(); LockSlider:Lock(); LockDrop:Lock(); LockInp:Lock(); LockKey:Lock()
        else
            LockBtn:UnLock(); LockTog:UnLock(); LockSlider:UnLock(); LockDrop:UnLock(); LockInp:UnLock(); LockKey:UnLock()
        end
    end
})
LockedTab:Button({ Title = "LockAll()", Callback = function() Window:LockAll() end })
LockedTab:Button({ Title = "UnlockAll()", Callback = function() Window:UnlockAll() end })

-- Group
GroupTab:Section({ Title = "Group" })
local g = GroupTab:Group({})
g:Toggle({ Title = "One", Callback = function() end })
g = GroupTab:Group({})
g:Toggle({ Title = "Aimbot", Callback = function() end })
g:Toggle({ Title = "Trigger", Callback = function() end })

-- Settings
Settings:Section({ Title = "Theme" })
local AllThemes = {
    "Dark", "Light", "Forest", "Amethyst", "Crimson", "DarkBlue", "Pink", "Orange",
    "Rose", "Plant", "Red", "Indigo", "Sky", "Violet", "Amber", "Emerald", "Midnight",
    "Monokai Pro", "Cotton Candy", "Mellowsi", "Cyber", "Sunset", "Ocean", "Grape",
    "Nord", "Dracula", "Catppuccin", "TokyoNight", "Gruvbox", "Solarized",
    "Blood", "Neon", "Mocha", "Arctic", "Matrix"
}
Settings:Dropdown({
    Title = "Theme",
    Option = AllThemes,
    Value = "Dark",
    Callback = function(v)
        Window:SetTheme(v)
        VoidUI:Notification({ Title = v, Duration = 2 })
    end
})
Settings:Toggle({ Title = "Transparent", Default = true, Callback = function(v) Window:SetTransparency(v) end })

local s1 = Settings:Group({})
s1:Toggle({ Title = "Resize", Default = true, Callback = function(v) Window:SetResizable(v) end })
s1:Keybind({ Title = "Toggle Key", Callback = function(k) Window:SetToggleKey(Enum.KeyCode[k]) end })

Settings:Section({ Title = "Window" })
Settings:Button({ Title = "Fullscreen", Callback = function() Window:ToggleFullscreen() end })
Settings:Button({ Title = "Watermark", Callback = function()
    Window._wm = not Window._wm
    Window:ToggleWatermark(Window._wm ~= false)
end })
Settings:Button({ Title = "Center", Callback = function() Window:ToCenter() end })

Settings:Section({ Title = "User" })
Settings:Toggle({ Title = "Enabled", Default = true, Callback = function(v) Window:UserEnabled(v) end })
Settings:Toggle({ Title = "Anonymous", Default = true, Callback = function(v) Window:Anonymous(v) end })

local n1, n2 = 480, 360
Settings:Section({ Title = "Size" })
Settings:Slider({ Title = "X", Value = { Min = 410, Max = 700, Default = 480 }, Step = 1, Callback = function(v) n1 = v end })
Settings:Slider({ Title = "Y", Value = { Min = 280, Max = 700, Default = 360 }, Step = 1, Callback = function(v) n2 = v end })
Settings:Button({ Title = "Apply", Callback = function() Window:Resize(n1, n2) end })
Settings:Button({ Title = "Destroy", Callback = function() Window:Destroy() end })
