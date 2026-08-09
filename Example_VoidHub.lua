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

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()

local Loader = VoidUI:LoadingScreen({ Title = "Void Hub", Desc = "Loading..." })
Loader:SetProgress(0.5)
task.wait(0.12)
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
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255)),
    },
    AutoRotation = true,
    Speed = 15,
    CornerRadius = UDim.new(0, 16),
})

Window:SetWatermark("Void Hub  •  " .. LocalPlayer.Name)
Window:SetBackgroundImage("rbxassetid://84152360484913", 0.45)

local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye", Border = true })
local NewTab = Window:Tab({ Title = "Elements", Icon = "sparkles", Border = true })
local ManagementTab = Window:Tab({ Title = "Management", Icon = "chart-no-axes-gantt", Border = true })
local InputTab = Window:Tab({ Title = "Input", Icon = "file-input", Border = true })
local NotifyTab = Window:Tab({ Title = "Notify", Icon = "message-square-dot", Border = true })
local AppearanceTab = Window:Tab({ Title = "Appearance", Icon = "palette", Border = true })
local DialogTab = Window:Tab({ Title = "Dialog", Icon = "message-circle", Border = true })
local BackgroundTab = Window:Tab({ Title = "Background", Icon = "image", Border = true })
local LockedTab = Window:Tab({ Title = "Locked", Icon = "lock-keyhole", Border = true })
Window:SelectTab(1)

local Section = Window:Section({ Title = "Other", Icon = "hash" })
local Settings = Section:Tab({ Title = "Settings", Icon = "settings", Border = true })

-- Visuals
VisualsTab:Section({ Title = "ESP" })
VisualsTab:Toggle({
    Title = "ESP Chams",
    Default = false,
    Callback = function(v) ESP_Settings.Enabled = v UpdateAllESP() end
})
VisualsTab:Colorpicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(0, 255, 80),
    Callback = function(c) ESP_Settings.Color = c UpdateAllESP() end
})

-- Elements
NewTab:Section({ Title = "Progress / Check / Radio" })
local Progress = NewTab:ProgressBar({ Title = "Progress", Value = 35, Max = 100 })
NewTab:Button({ Title = "+10", Callback = function() Progress:Set(math.min(100, (Progress.Value or 0) + 10)) end })
NewTab:Checkbox({ Title = "Feature", Default = false, Callback = function(v) print(v) end })
NewTab:Radio({ Title = "Mode", Option = {"Mouse", "Camera", "Silent"}, Value = "Mouse", Callback = function(v) print(v) end })
NewTab:Section({ Title = "Extra" })
NewTab:Badge({ Title = "Status", Text = "ON", Color = Color3.fromRGB(40, 180, 80) })
NewTab:Label({ Title = "Label" })
NewTab:KeyValue({ Title = "Version", Value = "1.0.0" })
NewTab:Stepper({ Title = "Amount", Value = { Min = 0, Max = 50, Default = 5 }, Step = 1, Callback = function(v) print(v) end })
NewTab:Code({ Title = "Code", Code = "print('Void')" })
NewTab:EmptyState({ Title = "Empty", Desc = "No items", Icon = "search" })
NewTab:Discord({ Title = "Discord", URL = "https://discord.gg/your-invite" })

-- Management
ManagementTab:Button({ Title = "Button", Callback = function() print("Click") end })
ManagementTab:Toggle({ Title = "Toggle", Callback = function(v) print(v) end })
ManagementTab:Slider({ Title = "Slider", Value = { Min = 0, Max = 100, Default = 25 }, Step = 1, Callback = function(v) print(v) end })
ManagementTab:Dropdown({
    Title = "Dropdown",
    Multi = false,
    Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8"},
    Value = "Option 1",
    Callback = function(v) print(v) end
})
ManagementTab:Dropdown({
    Title = "Multi",
    Multi = true,
    Option = {"A", "B", "C", "D", "E"},
    Value = "A",
    Callback = function(v) print(unpack(v)) end
})
ManagementTab:Colorpicker({ Title = "Color", Default = Color3.fromRGB(100, 160, 255), Callback = function(c) print(c) end })

-- Input
InputTab:Input({ Title = "Input", Callback = function(i) print(i) end })
InputTab:Input({ Title = "Limit", MaxSymbols = 10, Callback = function(i) print(i) end })
InputTab:Keybind({ Title = "Keybind", Callback = function(k) print(k) end })

-- Notify
NotifyTab:Button({
    Title = "Notify",
    Callback = function()
        VoidUI:Notification({ Title = "Void Hub", Desc = "Hello", Icon = "bird", Duration = 4 })
    end
})

-- Appearance
AppearanceTab:Section({ Title = "Colors" })
AppearanceTab:Colorpicker({
    Title = "Icon Color",
    Default = Color3.fromRGB(200, 200, 200),
    Callback = function(c)
        local _t = VoidUI.Theme
        if VoidUI.Theme then VoidUI.Theme.IconColor = c end
        Window:SetTheme(Window:GetTheme() or "Dark")
    end
})
AppearanceTab:Colorpicker({
    Title = "Text Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c)
        if VoidUI.Theme then VoidUI.Theme.Text = c end
        Window:SetTheme(Window:GetTheme() or "Dark")
    end
})
AppearanceTab:Section({ Title = "Transparency" })
AppearanceTab:Toggle({
    Title = "UI Transparent",
    Default = true,
    Callback = function(v) Window:SetTransparency(v) end
})
AppearanceTab:Slider({
    Title = "BG Transparency",
    Value = { Min = 0, Max = 90, Default = 45 },
    Step = 1,
    Callback = function(v) Window:SetBackgroundImageTransparency(v / 100) end
})
AppearanceTab:Section({ Title = "Font / Lang" })
AppearanceTab:Dropdown({
    Title = "Font",
    Option = {"Default", "Gotham", "SourceSans"},
    Value = "Default",
    Callback = function(v)
        if v == "Default" then
            Window:SetFont("rbxassetid://12187365364")
        elseif v == "Gotham" then
            Window:SetFont("rbxasset://fonts/families/GothamSSm.json")
        else
            Window:SetFont("rbxasset://fonts/families/SourceSansPro.json")
        end
    end
})
AppearanceTab:Dropdown({
    Title = "Language",
    Option = {"en", "pt", "es"},
    Value = "pt",
    Callback = function(v) Window:SetLanguage(v) end
})

-- Dialog / Paragraph colors
DialogTab:Section({ Title = "Paragraph Colors" })
local Colors = {"Red", "Coral", "Orange", "Yellow", "Green", "Mint", "Cyan", "Blue", "Purple", "Pink"}
for _, name in ipairs(Colors) do
    DialogTab:Paragraph({ Title = name, Color = name })
end
DialogTab:Section({ Title = "Dialog" })
DialogTab:Button({
    Title = "Open Dialog",
    Callback = function()
        VoidUI:Dialog({
            Title = "Dialog",
            Desc = "Example dialog",
            Buttons = {
                { Text = "Cancel", Callback = function() end },
                { Text = "OK", Callback = function()
                    VoidUI:Notification({ Title = "OK", Duration = 2 })
                end },
            }
        })
    end
})

-- Background
BackgroundTab:Section({ Title = "Image / Video" })
local lastId = "84152360484913"
BackgroundTab:Input({
    Title = "Asset ID",
    Callback = function(t)
        lastId = tostring(t or ""):gsub("%D", "")
        if lastId ~= "" then
            Window:SetBackgroundImage("rbxassetid://" .. lastId, 0.45)
        end
    end
})
BackgroundTab:Button({
    Title = "Apply Image",
    Callback = function()
        if lastId ~= "" then Window:SetBackgroundImage("rbxassetid://" .. lastId, 0.45) end
    end
})
BackgroundTab:Button({
    Title = "Apply Video",
    Callback = function()
        if lastId ~= "" then Window:SetBackgroundVideo(lastId, 0.4) end
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
BackgroundTab:Colorpicker({
    Title = "Solid",
    Default = Color3.fromRGB(10, 10, 10),
    Callback = function(c) Window:SetBackgroundColor(c) end
})
BackgroundTab:Button({ Title = "Clear", Callback = function() Window:ClearBackground() end })

-- Locked
local LockBtn = LockedTab:Button({ Title = "Button", Locked = true, Callback = function() end })
local LockTog = LockedTab:Toggle({ Title = "Toggle", Locked = true, Callback = function() end })
LockedTab:Toggle({
    Title = "Unlock",
    Default = true,
    Callback = function(v)
        if v then LockBtn:Lock() LockTog:Lock() else LockBtn:UnLock() LockTog:UnLock() end
    end
})
LockedTab:Button({ Title = "LockAll", Callback = function() Window:LockAll() end })
LockedTab:Button({ Title = "UnlockAll", Callback = function() Window:UnlockAll() end })

-- Settings
Settings:Section({ Title = "Theme" })
local AllThemes = {
    "Dark","Light","Forest","Amethyst","Crimson","DarkBlue","Pink","Orange",
    "Rose","Plant","Red","Indigo","Sky","Violet","Amber","Emerald","Midnight",
    "Monokai Pro","Cotton Candy","Mellowsi","Cyber","Sunset","Ocean","Grape",
    "Nord","Dracula","Catppuccin","TokyoNight","Gruvbox","Solarized",
    "Blood","Neon","Mocha","Arctic","Matrix"
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
Settings:Section({ Title = "Window" })
Settings:Button({ Title = "Fullscreen", Callback = function() Window:ToggleFullscreen() end })
Settings:Button({ Title = "Center", Callback = function() Window:ToCenter() end })
Settings:Toggle({ Title = "User", Default = true, Callback = function(v) Window:UserEnabled(v) end })
Settings:Toggle({ Title = "Anonymous", Default = true, Callback = function(v) Window:Anonymous(v) end })
local n1, n2 = 480, 360
Settings:Slider({ Title = "X", Value = { Min = 410, Max = 700, Default = 480 }, Step = 1, Callback = function(v) n1 = v end })
Settings:Slider({ Title = "Y", Value = { Min = 280, Max = 700, Default = 360 }, Step = 1, Callback = function(v) n2 = v end })
Settings:Button({ Title = "Apply Size", Callback = function() Window:Resize(n1, n2) end })
Settings:Button({ Title = "Destroy", Callback = function() Window:Destroy() end })
