--[[
    Void Hub Example — Keyless
    Todos os elementos + Background + ESP
]]

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

local Loader = VoidUI:LoadingScreen({
    Title = "Void Hub",
    Desc = "Loading interface...",
})
Loader:SetProgress(0.3)
task.wait(0.25)
Loader:SetStatus("Building window...")
Loader:SetProgress(0.7)
task.wait(0.2)
Loader:SetProgress(1)
Loader:Close(0.15)

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
    CornerRadius = UDim.new(0,16),
})

Window:SetWatermark("Void Hub  •  " .. LocalPlayer.Name)

local VisualsTab = Window:Tab({Title = "Visuals", Icon = "eye", Border = true})
local NewElements = Window:Tab({Title = "New Elements", Icon = "sparkles", Border = true})
local DisplayElements = Window:Tab({Title = "Display", Icon = "picture-in-picture", Border = true})
local ManagementTab = Window:Tab({Title = "Management", Icon = "chart-no-axes-gantt", Border = true})
local InputTab = Window:Tab({Title = "Input", Icon = "file-input", Border = true})
local NotificationTab = Window:Tab({Title = "Notification", Icon = "message-square-dot", Border = true})
local LockedTab = Window:Tab({Title = "Locked", Icon = "lock-keyhole", Border = true})
local GroupTab = Window:Tab({Title = "Group", Icon = "group", Border = true})
local BackgroundTab = Window:Tab({Title = "Background", Icon = "image", Border = true})
Window:SelectTab(1)

local Section = Window:Section({ Title = "Other", Icon = "hash" })
local Settings = Section:Tab({ Title = "Settings", Icon = "settings", Border = true })

VisualsTab:Section({Title = "ESP Chams (Players)"})
VisualsTab:Toggle({
    Title = "Enable ESP Chams",
    Desc = "See players through walls",
    Default = false,
    Callback = function(Value)
        ESP_Settings.Enabled = Value
        UpdateAllESP()
    end
})
VisualsTab:Colorpicker({
    Title = "ESP Color",
    Desc = "Change ESP Chams color",
    Default = Color3.fromRGB(0, 255, 80),
    Callback = function(color)
        ESP_Settings.Color = color
        UpdateAllESP()
    end
})

NewElements:Section({Title = "Progress / Checkbox / Radio"})
local Progress = NewElements:ProgressBar({ Title = "Loading Progress", Desc = "Example progress bar", Value = 35, Max = 100 })
NewElements:Button({ Title = "Progress +10", Callback = function() Progress:Set(math.min(100, (Progress.Value or 0) + 10)) end })
NewElements:Checkbox({ Title = "Enable Feature", Desc = "Checkbox style WindUI", Default = false, Callback = function(v) print("Checkbox:", v) end })
NewElements:Radio({ Title = "Aim Mode", Desc = "Radio group", Option = {"Mouse", "Camera", "Silent"}, Value = "Mouse", Callback = function(v) print("Radio:", v) end })

NewElements:Section({Title = "Badge / Label / KeyValue / Stepper"})
NewElements:Badge({ Title = "Status", Text = "ONLINE", Color = Color3.fromRGB(40, 180, 80) })
NewElements:Label({ Title = "Info Label", Desc = "Simple text label element" })
NewElements:KeyValue({ Title = "Version", Value = "1.0.0" })
NewElements:Stepper({ Title = "Amount", Desc = "Stepper +/-", Value = { Min = 0, Max = 50, Default = 5 }, Step = 1, Callback = function(v) print("Stepper:", v) end })

NewElements:Section({Title = "Code / Empty / Discord"})
NewElements:Code({ Title = "Example Code", Code = "local VoidUI = loadstring(...)\nlocal Window = VoidUI:CreateWindow({...})" })
NewElements:EmptyState({ Title = "No results", Desc = "Try another search", Icon = "search" })
NewElements:Discord({ Title = "Discord Server", Desc = "Click to copy invite", URL = "https://discord.gg/your-invite" })

BackgroundTab:Section({Title = "Background System"})
BackgroundTab:Paragraph({ Title = "Background Support", Desc = "Image / Gradient / Color — digite o ID da imagem abaixo" })

local lastImageId = "131126436897551"
BackgroundTab:Input({
    Title = "Image Asset ID",
    Desc = "Digite o ID e pressione Enter para aplicar",
    Callback = function(text)
        lastImageId = tostring(text or ""):gsub("%D", "")
        if lastImageId ~= "" then
            Window:SetBackgroundImage("rbxassetid://" .. lastImageId, 0.4)
            VoidUI:Notification({ Title = "Background Image", Desc = "Applied ID: " .. lastImageId, Icon = "image", Duration = 2 })
        end
    end
})
BackgroundTab:Button({
    Title = "Apply Last Image ID",
    Callback = function()
        if lastImageId ~= "" then
            Window:SetBackgroundImage("rbxassetid://" .. lastImageId, 0.4)
        end
    end
})
BackgroundTab:Button({
    Title = "Set Background Gradient",
    Callback = function()
        Window:SetBackgroundGradient(ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 30)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 20, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15)),
        }), 45, 0.2)
        VoidUI:Notification({ Title = "Background", Desc = "Gradient applied", Icon = "palette", Duration = 2 })
    end
})
BackgroundTab:Colorpicker({ Title = "Background Solid Color", Default = Color3.fromRGB(16, 16, 16), Callback = function(color) Window:SetBackgroundColor(color) end })
BackgroundTab:Slider({ Title = "Image Transparency", Value = { Min = 0, Max = 100, Default = 40 }, Step = 1, Callback = function(Value) Window:SetBackgroundImageTransparency(Value / 100) end })
BackgroundTab:Button({ Title = "Clear Background", Callback = function() Window:ClearBackground(); VoidUI:Notification({ Title = "Background", Desc = "Cleared", Duration = 2 }) end })

DisplayElements:Section({Title = "Section"})
DisplayElements:Paragraph({ Title = "Paragraph", Desc = "This is a Paragraph" })
DisplayElements:Paragraph({ Title = "Paragraph Icon <smile>", Desc = "This is a Paragraph", Icon = "bird" })
DisplayElements:Devider()
DisplayElements:Paragraph({ Title = "Paragraph Thumbnail", Desc = "This is a Paragraph", Thumbnail = "rbxassetid://78903626783621", Icon = "solar:lock-keyhole-unlocked-broken" })

ManagementTab:Button({ Title = "Button", Desc = "This is a button", Callback = function() print("Click") end })
ManagementTab:Toggle({ Title = "Toggle", Desc = "This is a toggle", Callback = function(v) print(v) end })
ManagementTab:Slider({ Title = "Slider", Desc = "This is a slider", Value = { Min = 0, Max = 100, Default = 25 }, Step = 1, Callback = function(v) print(v) end })
ManagementTab:Dropdown({
    Title = "Dropdown", Desc = "Floating menu estilo WindUI", Multi = false,
    Option = {"Option 1","Option 2","Option 3","Option 4","Option 5","Option 6","Option 7","Option 8","Option 9","Option 10","Pisun"},
    Value = "Option 1", Callback = function(v) print(v) end
})
ManagementTab:Dropdown({
    Title = "Multi Dropdown", Desc = "Multi select", Multi = true,
    Option = {"Option 1","Option 2","Option 3","Option 4","Option 5","Option 6","Option 7","Option 8"},
    Value = "Option 1", Callback = function(v) print(unpack(v)) end
})
ManagementTab:Colorpicker({ Title = "Colorpicker Test", Desc = "Nao deve mover a UI ao arrastar", Default = Color3.fromRGB(100, 160, 255), Callback = function(c) print(c) end })

InputTab:Input({ Title = "Input", Desc = "This is an input", Callback = function(i) print(i) end })
InputTab:Input({ Title = "Input Limit", MaxSymbols = 10, Desc = "Max 10 chars", Callback = function(i) print(i) end })
InputTab:Keybind({ Title = "Keybind", Callback = function(k) print(k) end })

NotificationTab:Button({ Title = "Notification Icon", Callback = function() VoidUI:Notification({ Title = "Title", Icon = "bird", Desc = "Pisun", Duration = 5 }) end })
NotificationTab:Button({ Title = "Notification", Callback = function() VoidUI:Notification({ Title = "Title", Desc = "Pisun", Duration = 5 }) end })

local LockBtn = LockedTab:Button({ Title = "Button", Locked = true, Callback = function() end })
local LockTog = LockedTab:Toggle({ Title = "Toggle", Locked = true, Callback = function() end })
local LockSlider = LockedTab:Slider({ Title = "Slider", Locked = true, Value = { Min = 0, Max = 100, Default = 25 }, Step = 1, Callback = function() end })
local LockDrop = LockedTab:Dropdown({ Title = "Dropdown", Locked = true, Multi = false, Option = {"A","B","C"}, Value = "A", Callback = function() end })
local LockInp = LockedTab:Input({ Title = "Input", Locked = true, Callback = function() end })
local LockKey = LockedTab:Keybind({ Title = "Keybind", Locked = true, Callback = function() end })
LockedTab:Toggle({
    Title = "Lock / UnLock", Default = true,
    Callback = function(Value)
        if Value then LockBtn:Lock(); LockTog:Lock(); LockSlider:Lock(); LockDrop:Lock(); LockInp:Lock(); LockKey:Lock()
        else LockBtn:UnLock(); LockTog:UnLock(); LockSlider:UnLock(); LockDrop:UnLock(); LockInp:UnLock(); LockKey:UnLock() end
    end
})
LockedTab:Button({ Title = "Lock All Elements", Callback = function() Window:LockAll() end })
LockedTab:Button({ Title = "Unlock All Elements", Callback = function() Window:UnlockAll() end })

GroupTab:Section({Title = "Group"})
local grid = GroupTab:Group({})
grid:Toggle({ Title = "One Element", Callback = function(v) print(v) end })
grid = GroupTab:Group({})
grid:Toggle({ Title = "Aimbot", Callback = function(v) print(v) end })
grid:Toggle({ Title = "Triggerbot", Callback = function(v) print(v) end })

Settings:Section({Title = "Window"})
local AllThemes = {
    "Dark","Light","Forest","Amethyst","Crimson","DarkBlue","Pink","Orange",
    "Rose","Plant","Red","Indigo","Sky","Violet","Amber","Emerald","Midnight",
    "Monokai Pro","Cotton Candy","Mellowsi","Cyber","Sunset","Ocean","Grape",
    "Nord","Dracula","Catppuccin","TokyoNight","Gruvbox","Solarized",
    "Blood","Neon","Mocha","Arctic","Matrix"
}
Settings:Dropdown({
    Title = "Theme", Option = AllThemes, Value = "Dark",
    Callback = function(Value)
        Window:SetTheme(Value)
        VoidUI:Notification({ Title = "Theme: " .. Value, Icon = "bird", Duration = 2 })
    end
})
Settings:Toggle({ Title = "Transparent", Default = true, Callback = function(Value) Window:SetTransparency(Value) end })
local Settings1 = Settings:Group({})
Settings1:Toggle({ Title = "Resizing", Default = true, Callback = function(Value) Window:SetResizable(Value) end })
Settings1:Keybind({ Title = "Toggle Key", Callback = function(key) Window:SetToggleKey(Enum.KeyCode[key]) end })

Settings:Section({Title = "Window Controls"})
Settings:Button({ Title = "Toggle Fullscreen", Callback = function() Window:ToggleFullscreen() end })
Settings:Button({
    Title = "Toggle Watermark",
    Callback = function()
        Window._wmVisible = not Window._wmVisible
        Window:ToggleWatermark(Window._wmVisible ~= false)
    end
})
Settings:Button({ Title = "To Center", Callback = function() Window:ToCenter() end })

Settings:Section({Title = "User"})
Settings:Toggle({ Title = "Enabled", Default = true, Callback = function(v) Window:UserEnabled(v) end })
Settings:Toggle({ Title = "Anonymous", Default = true, Callback = function(v) Window:Anonymous(v) end })

local n1, n2 = 480, 360
Settings:Section({Title = "Window Size"})
Settings:Slider({ Title = "X", Value = { Min = 410, Max = 700, Default = 480 }, Step = 1, Callback = function(v) n1 = v end })
Settings:Slider({ Title = "Y", Value = { Min = 280, Max = 700, Default = 360 }, Step = 1, Callback = function(v) n2 = v end })
Settings:Button({ Title = "Apply Size", Callback = function() Window:Resize(n1, n2) end })
Settings:Section({Title = "Danger"})
Settings:Button({ Title = "Destroy UI", Callback = function() Window:Destroy() end })
