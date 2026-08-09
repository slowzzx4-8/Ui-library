--[[
    Void Hub Example Script
    Keyless | HTTPS Library
    Includes: ESP Chams + Background demo + All elements
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- LÓGICA DO ESP (CHAMS)
-- ==========================================
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
        if highlight then
            highlight.Enabled = false
        end
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

-- ==========================================
-- INTERFACE (UI) - KEYLESS
-- ==========================================
local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()

local Window = VoidUI:CreateWindow({
    Name = "Void Ui",
    Icon = "door-open",
    SideBarWidth = 160,
    Theme = "Dark",
    Transparent = true,
    Author = "By Slowzzx4",
    User = {
        Enabled = true,
        Anonymous = true,
    },
})

Window:EditOpenButton({
    Title = "Open Void Ui",
    Icon = "door-open",
    Transparency = 0.2,
    StrokeThickness = 1,
    Rotation = 0,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255))
    },
    AutoRotation = true,
    Speed = 15,
    CornerRadius = UDim.new(0,16),
})

-- ==========================================
-- ABAS
-- ==========================================
local VisualsTab = Window:Tab({Title = "Visuals", Icon = "eye", Border = true})
local DisplayElements = Window:Tab({Title = "Display Elements", Icon = "picture-in-picture", Border = true})
local ManagementTab = Window:Tab({Title = "Management", Icon = "chart-no-axes-gantt", Border = true})
local InputTab = Window:Tab({Title = "Input Elements", Icon = "file-input", Border = true})
local NotificationTab = Window:Tab({Title = "Notification", Icon = "message-square-dot", Border = true})
local LockedTab = Window:Tab({Title = "Locked Elements", Icon = "lock-keyhole", Border = true})
local GroupTab = Window:Tab({Title = "Group", Icon = "group", Border = true})
local BackgroundTab = Window:Tab({Title = "Background", Icon = "image", Border = true})

Window:SelectTab(1)

local Section = Window:Section({ Title = "Other", Icon = "hash" })
local Settings = Section:Tab({ Title = "Settings", Icon = "settings", Border = true })

-- ==========================================
-- ABA VISUALS (ESP)
-- ==========================================
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

-- ==========================================
-- ABA BACKGROUND (NOVO)
-- ==========================================
BackgroundTab:Section({Title = "Background Support"})

BackgroundTab:Paragraph({
    Title = "Background System",
    Desc = "Image / Gradient / Color — estilo WindUI",
})

BackgroundTab:Button({
    Title = "Set Background Image (example)",
    Desc = "Aplica uma imagem de fundo",
    Callback = function()
        Window:SetBackgroundImage("rbxassetid://131126436897551", 0.4)
        VoidUI:Notification({ Title = "Background", Desc = "Image applied", Icon = "image", Duration = 2 })
    end
})

BackgroundTab:Button({
    Title = "Set Background Gradient",
    Desc = "Aplica um gradiente",
    Callback = function()
        Window:SetBackgroundGradient(
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 30)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 20, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15)),
            }),
            45,
            0.2
        )
        VoidUI:Notification({ Title = "Background", Desc = "Gradient applied", Icon = "palette", Duration = 2 })
    end
})

BackgroundTab:Colorpicker({
    Title = "Background Solid Color",
    Desc = "Cor sólida de fundo",
    Default = Color3.fromRGB(16, 16, 16),
    Callback = function(color)
        Window:SetBackgroundColor(color)
    end
})

BackgroundTab:Slider({
    Title = "Image Transparency",
    Desc = "Transparência da imagem de fundo",
    Value = { Min = 0, Max = 100, Default = 40 },
    Step = 1,
    Callback = function(Value)
        Window:SetBackgroundImageTransparency(Value / 100)
    end
})

BackgroundTab:Button({
    Title = "Clear Background",
    Callback = function()
        Window:ClearBackground()
        VoidUI:Notification({ Title = "Background", Desc = "Cleared", Duration = 2 })
    end
})

-- ==========================================
-- DISPLAY ELEMENTS
-- ==========================================
DisplayElements:Section({Title = "Section"})
DisplayElements:Paragraph({
    Title = "Paragraph",
    Desc = "This is a Paragraph",
})
DisplayElements:Paragraph({
    Title = "Paragraph Icon <smile>",
    Desc = "This is a Paragraph",
    Icon = "bird"
})
DisplayElements:Devider()
DisplayElements:Paragraph({
    Title = "Paragraph Thumbnail",
    Desc = "This is a Paragraph",
    Thumbnail = "rbxassetid://78903626783621",
    Icon = "solar:lock-keyhole-unlocked-broken"
})
DisplayElements:Section({Title = "Color Paragraph", Icon = "paintbrush"})
local Colors = {"Red", "Coral", "Orange", "Yellow", "Green", "Mint", "Cyan", "Blue", "Purple", "Pink"}
for i = 1, 10 do
    DisplayElements:Paragraph({Title = Colors[i], Color = Colors[i]})
end

-- ==========================================
-- MANAGEMENT
-- ==========================================
ManagementTab:Button({
    Title = "Button",
    Desc = "This is a button",
    Callback = function()
        print("Click")
    end
})
ManagementTab:Button({
    Title = "Test Text Icon <bird> bebebe",
    Desc = "This is a button <bird> bebebe",
    Callback = function()
        print("Click")
    end
})
ManagementTab:Toggle({
    Title = "Toggle <toggle-left>",
    Desc = "This is a toggle",
    Callback = function(Value)
        print(Value)
    end
})
ManagementTab:Slider({
    Title = "Slider <settings-2>",
    Desc = "This is a slider",
    Value = { Min = 0, Max = 100, Default = 25 },
    Step = 1,
    Callback = function(Value)
        print(Value)
    end
})
ManagementTab:Dropdown({
    Title = "Dropdown <layout-template>",
    Desc = "This is a dropdown",
    Multi = false,
    Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"},
    Value = "Option 1",
    Callback = function(Value)
        print(Value)
    end
})
ManagementTab:Dropdown({
    Title = "Multi Dropdown <layout-template>",
    Desc = "This is a multi dropdown",
    Multi = true,
    Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"},
    Value = "Option 1",
    Callback = function(Value)
        print(unpack(Value))
    end
})
ManagementTab:Colorpicker({
    Title = "Colorpicker Test",
    Desc = "Teste o picker (não deve mover a UI)",
    Default = Color3.fromRGB(100, 160, 255),
    Callback = function(color)
        print(color)
    end
})

-- ==========================================
-- INPUT
-- ==========================================
InputTab:Input({
    Title = "Input <text-cursor-input>",
    Desc = "This is an input",
    Callback = function(input)
        print(input)
    end
})
InputTab:Input({
    Title = "Input Limit",
    MaxSymbols = 10,
    Desc = "This is an input",
    Callback = function(input)
        print(input)
    end
})
InputTab:Keybind({
    Title = "Keybind",
    Callback = function(key)
        print(key)
    end
})

-- ==========================================
-- NOTIFICATION
-- ==========================================
NotificationTab:Button({
    Title = "Notification Icon",
    Callback = function()
        VoidUI:Notification({
            Title = "Title",
            Icon = "bird",
            Desc = "Pisun",
            Duration = 5
        })
    end
})
NotificationTab:Button({
    Title = "Notification",
    Callback = function()
        VoidUI:Notification({
            Title = "Title",
            Desc = "Pisun",
            Duration = 5
        })
    end
})

-- ==========================================
-- LOCKED
-- ==========================================
local LockBtn = LockedTab:Button({
    Title = "Button",
    Locked = true,
    Callback = function() print("Pisun") end
})
local LockTog = LockedTab:Toggle({
    Title = "Toggle",
    Locked = true,
    Callback = function(Value) print(Value) end
})
local LockSlider = LockedTab:Slider({
    Title = "Slider",
    Locked = true,
    Value = { Min = 0, Max = 100, Default = 25 },
    Step = 1,
    Callback = function(Value) print(Value) end
})
local LockDrop = LockedTab:Dropdown({
    Title = "Dropdown",
    Locked = true,
    Multi = false,
    Option = {"Option 1", "Option 2", "Option 3"},
    Value = "Option 1",
    Callback = function(Value) print(Value) end
})
local LockInp = LockedTab:Input({
    Title = "Input",
    Locked = true,
    Callback = function(input) print(input) end
})
local LockKey = LockedTab:Keybind({
    Title = "Keybind",
    Locked = true,
    Callback = function(key) print(key) end
})

LockedTab:Toggle({
    Title = "Lock / UnLock",
    Default = true,
    Callback = function(Value)
        if Value then
            LockBtn:Lock(); LockTog:Lock(); LockSlider:Lock()
            LockDrop:Lock(); LockInp:Lock(); LockKey:Lock()
        else
            LockBtn:UnLock(); LockTog:UnLock(); LockSlider:UnLock()
            LockDrop:UnLock(); LockInp:UnLock(); LockKey:UnLock()
        end
    end
})

-- ==========================================
-- GROUP
-- ==========================================
GroupTab:Section({Title = "Group"})
local grid = GroupTab:Group({})
grid:Toggle({ Title = "One Element", Callback = function(v) print(v) end })
grid = GroupTab:Group({})
grid:Toggle({ Title = "Aimbot", Callback = function(v) print(v) end })
grid:Toggle({ Title = "Triggerbot", Callback = function(v) print(v) end })
grid = GroupTab:Group({})
grid:Toggle({ Title = "Test", Callback = function(v) print(v) end })
grid:Toggle({ Title = "Test", Callback = function(v) print(v) end })
grid:Toggle({ Title = "Test", Callback = function(v) print(v) end })

GroupTab:Section({Title = "Locked"})
grid = GroupTab:Group({})
grid:Toggle({ Title = "Toggle", Locked = true, Callback = function(v) print(v) end })
grid:Toggle({ Title = "Toggle", Locked = true, Callback = function(v) print(v) end })
grid = GroupTab:Group({})
grid:Toggle({ Title = "Toggle", Locked = true, Callback = function(v) print(v) end })
grid:Toggle({ Title = "Toggle", Locked = false, Callback = function(v) print(v) end })

-- ==========================================
-- SETTINGS
-- ==========================================
Settings:Section({Title = "Window"})

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
    Callback = function(Value)
        Window:SetTheme(Value)
        VoidUI:Notification({
            Title = "Selected Theme: " .. Value,
            Icon = "bird",
            Duration = 2
        })
    end
})

Settings:Toggle({
    Title = "Transparent",
    Default = true,
    Callback = function(Value)
        Window:SetTransparency(Value)
    end
})

local Settings1 = Settings:Group({})
Settings1:Toggle({
    Title = "Resizing",
    Default = true,
    Callback = function(Value)
        Window:SetResizable(Value)
    end
})
Settings1:Keybind({
    Title = "Toggle Key Window",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})

Settings:Section({Title = "User"})
Settings:Toggle({
    Title = "Enabled",
    Default = true,
    Callback = function(Value)
        Window:UserEnabled(Value)
    end
})
Settings:Toggle({
    Title = "Anonymous",
    Default = true,
    Callback = function(Value)
        Window:Anonymous(Value)
    end
})

local n1, n2 = 480, 360
Settings:Section({Title = "Window Size"})
Settings:Slider({
    Title = "X",
    Value = { Min = 410, Max = 700, Default = 480 },
    Step = 1,
    Callback = function(Value) n1 = Value end
})
Settings:Slider({
    Title = "Y",
    Value = { Min = 280, Max = 700, Default = 360 },
    Step = 1,
    Callback = function(Value) n2 = Value end
})
Settings:Button({
    Title = "Apply",
    Callback = function()
        Window:Resize(n1, n2)
    end
})

Settings:Section({Title = "Other"})
Settings:Button({
    Title = "To Center",
    Callback = function()
        Window:ToCenter()
    end
})
Settings:Button({
    Title = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})
