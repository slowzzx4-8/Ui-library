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
task.wait(0.1)
Loader:SetProgress(1)
Loader:Close(0.08)

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
local ElementsTab = Window:Tab({ Title = "Elements", Icon = "sparkles", Border = true })
local ManagementTab = Window:Tab({ Title = "Management", Icon = "chart-no-axes-gantt", Border = true })
local InputTab = Window:Tab({ Title = "Input", Icon = "file-input", Border = true })
local NotifyTab = Window:Tab({ Title = "Notify", Icon = "message-square-dot", Border = true })
local AppearanceTab = Window:Tab({ Title = "Appearance", Icon = "palette", Border = true })
local DialogTab = Window:Tab({ Title = "Dialog", Icon = "message-circle", Border = true })
local BackgroundTab = Window:Tab({ Title = "Background", Icon = "image", Border = true })
local GroupTab = Window:Tab({ Title = "Group", Icon = "group", Border = true })
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
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c) ESP_Settings.Color = c UpdateAllESP() end
})
VisualsTab:Slider({
    Title = "Fill Transparency",
    Value = { Min = 0, Max = 100, Default = 50 },
    Step = 1,
    Callback = function(v)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("ESP_Highlight")
                if h then h.FillTransparency = v / 100 end
            end
        end
    end
})

-- Elements
ElementsTab:Section({ Title = "Progress / Check / Radio" })
local Progress = ElementsTab:ProgressBar({ Title = "Progress", Value = 35, Max = 100 })
ElementsTab:Button({ Title = "+10", Callback = function() Progress:Set(math.min(100, (Progress.Value or 0) + 10)) end })
ElementsTab:Button({ Title = "Reset", Callback = function() Progress:Set(0) end })
ElementsTab:Checkbox({ Title = "Feature", Default = false, Callback = function(v) print(v) end })
ElementsTab:Radio({ Title = "Mode", Option = {"Mouse", "Camera", "Silent"}, Value = "Mouse", Callback = function(v) print(v) end })
ElementsTab:Section({ Title = "Extra" })
ElementsTab:Badge({ Title = "Status", Text = "ONLINE", Color = Color3.fromRGB(40, 180, 80) })
ElementsTab:Label({ Title = "Label" })
ElementsTab:KeyValue({ Title = "Version", Value = "1.0.0" })
ElementsTab:Stepper({ Title = "Amount", Value = { Min = 0, Max = 50, Default = 5 }, Step = 1, Callback = function(v) print(v) end })
ElementsTab:EmptyState({ Title = "Empty", Desc = "No items", Icon = "search" })
ElementsTab:Discord({ Title = "Discord", URL = "https://discord.gg/your-invite" })


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
    Title = "Multi Dropdown",
    Multi = true,
    Option = {"Alpha", "Beta", "Gamma", "Delta", "Epsilon"},
    Value = "Alpha",
    Callback = function(v) print(unpack(v)) end
})
ManagementTab:Colorpicker({
    Title = "Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c) print(c) end
})

ManagementTab:Section({ Title = "More" })
ManagementTab:Button({ Title = "Notify Hello", Callback = function()
    VoidUI:Notification({ Title = "Hello", Desc = "From Management", Duration = 3 })
end })
ManagementTab:Toggle({ Title = "Watermark", Default = true, Callback = function(v)
    Window:ToggleWatermark(v)
end })
ManagementTab:Keybind({ Title = "UI Toggle Key", Callback = function(k)
    pcall(function() Window:SetToggleKey(Enum.KeyCode[k]) end)
end })
ManagementTab:Slider({ Title = "UI Scale", Value = { Min = 50, Max = 120, Default = 100 }, Step = 1, Callback = function(v)
    pcall(function() Window:SetUIScale(v / 100) end)
end })

-- Input
InputTab:Input({ Title = "Input", Callback = function(i) print(i) end })
InputTab:Input({ Title = "Limit 10", MaxSymbols = 10, Callback = function(i) print(i) end })
InputTab:Keybind({ Title = "Keybind", Callback = function(k) print(k) end })

-- Notify
NotifyTab:Button({
    Title = "Notify",
    Callback = function()
        VoidUI:Notification({ Title = "Void Hub", Desc = "Hello", Icon = "bird", Duration = 4 })
    end
})
NotifyTab:Button({
    Title = "Long Notify",
    Callback = function()
        VoidUI:Notification({ Title = "Info", Desc = "This is a longer notification message", Icon = "bell", Duration = 5 })
    end
})

-- Appearance
AppearanceTab:Section({ Title = "Theme Colors" })
AppearanceTab:Colorpicker({
    Title = "Icon Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c)
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
AppearanceTab:Section({ Title = "Font" })
AppearanceTab:Dropdown({
    Title = "Font Family",
    Option = {
        "Builder Sans (Default)", "Gotham", "Gotham Black", "Source Sans Pro",
        "Roboto", "Roboto Mono", "Roboto Condensed", "Montserrat", "Nunito",
        "Oswald", "Ubuntu", "Merriweather", "Playfair Display", "Raleway",
        "Poppins", "Inter", "Open Sans", "Lato", "PT Sans", "Noto Sans",
        "Work Sans", "Fira Sans", "Josefin Sans", "Cabin", "Bebas Neue",
        "Inconsolata", "Space Mono", "Press Start 2P", "Indie Flower",
        "Permanent Marker", "Patrick Hand", "Comic Neue", "Arial", "Titillium Web",
        "Quicksand", "Mulish", "Barlow",
    },
    Value = "Builder Sans (Default)",
    Callback = function(v)
        local map = {
            ["Builder Sans (Default)"] = "rbxassetid://12187365364",
            ["Gotham"] = "rbxasset://fonts/families/GothamSSm.json",
            ["Gotham Black"] = "rbxasset://fonts/families/GothamSSm.json",
            ["Source Sans Pro"] = "rbxasset://fonts/families/SourceSansPro.json",
            ["Roboto"] = "rbxasset://fonts/families/Roboto.json",
            ["Roboto Mono"] = "rbxasset://fonts/families/RobotoMono.json",
            ["Roboto Condensed"] = "rbxasset://fonts/families/RobotoCondensed.json",
            ["Montserrat"] = "rbxasset://fonts/families/Montserrat.json",
            ["Nunito"] = "rbxasset://fonts/families/Nunito.json",
            ["Oswald"] = "rbxasset://fonts/families/Oswald.json",
            ["Ubuntu"] = "rbxasset://fonts/families/Ubuntu.json",
            ["Merriweather"] = "rbxasset://fonts/families/Merriweather.json",
            ["Playfair Display"] = "rbxasset://fonts/families/PlayfairDisplay.json",
            ["Raleway"] = "rbxasset://fonts/families/Raleway.json",
            ["Poppins"] = "rbxasset://fonts/families/Poppins.json",
            ["Inter"] = "rbxasset://fonts/families/Inter.json",
            ["Open Sans"] = "rbxasset://fonts/families/OpenSans.json",
            ["Lato"] = "rbxasset://fonts/families/Lato.json",
            ["PT Sans"] = "rbxasset://fonts/families/PTSans.json",
            ["Noto Sans"] = "rbxasset://fonts/families/NotoSans.json",
            ["Work Sans"] = "rbxasset://fonts/families/WorkSans.json",
            ["Fira Sans"] = "rbxasset://fonts/families/FiraSans.json",
            ["Josefin Sans"] = "rbxasset://fonts/families/JosefinSans.json",
            ["Cabin"] = "rbxasset://fonts/families/Cabin.json",
            ["Bebas Neue"] = "rbxasset://fonts/families/BebasNeue.json",
            ["Inconsolata"] = "rbxasset://fonts/families/Inconsolata.json",
            ["Space Mono"] = "rbxasset://fonts/families/SpaceMono.json",
            ["Press Start 2P"] = "rbxasset://fonts/families/PressStart2P.json",
            ["Indie Flower"] = "rbxasset://fonts/families/IndieFlower.json",
            ["Permanent Marker"] = "rbxasset://fonts/families/PermanentMarker.json",
            ["Patrick Hand"] = "rbxasset://fonts/families/PatrickHand.json",
            ["Comic Neue"] = "rbxasset://fonts/families/ComicNeue.json",
            ["Arial"] = "rbxasset://fonts/families/Arial.json",
            ["Titillium Web"] = "rbxasset://fonts/families/TitilliumWeb.json",
            ["Quicksand"] = "rbxasset://fonts/families/Quicksand.json",
            ["Mulish"] = "rbxasset://fonts/families/Mulish.json",
            ["Barlow"] = "rbxasset://fonts/families/Barlow.json",
        }
        Window:SetFont(map[v] or map["Builder Sans (Default)"])
    end
})
AppearanceTab:Section({ Title = "Language" })
AppearanceTab:Dropdown({
    Title = "Language",
    Option = {
        "English",
        "Português",
        "Español",
        "Français",
        "Deutsch",
        "Italiano",
        "Русский",
        "日本語",
        "中文",
        "한국어",
    },
    Value = "Português",
    Callback = function(v) Window:SetLanguage(v) end
})

-- Dialog colors
DialogTab:Section({ Title = "Paragraph Colors" })
for _, name in ipairs({"Red", "Coral", "Orange", "Yellow", "Green", "Mint", "Cyan", "Blue", "Purple", "Pink"}) do
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
BackgroundTab:Button({ Title = "Apply Image", Callback = function()
    if lastId ~= "" then Window:SetBackgroundImage("rbxassetid://" .. lastId, 0.45) end
end })
BackgroundTab:Input({
    Title = "Video ID",
    Callback = function(t)
        lastId = tostring(t or ""):gsub("%D", "")
    end
})
BackgroundTab:Button({ Title = "Apply Video", Callback = function()
    if lastId ~= "" then Window:SetBackgroundVideo(lastId, 0.4) end
end })
BackgroundTab:Button({ Title = "Gradient", Callback = function()
    Window:SetBackgroundGradient(ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15)),
    }), 45, 0.2)
end })
BackgroundTab:Colorpicker({
    Title = "Solid",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c) Window:SetBackgroundColor(c) end
})
BackgroundTab:Button({ Title = "Clear", Callback = function() Window:ClearBackground() end })

-- Group
GroupTab:Section({ Title = "Group" })
local g = GroupTab:Group({})
g:Toggle({ Title = "One", Callback = function() end })
g = GroupTab:Group({})
g:Toggle({ Title = "Aimbot", Callback = function() end })
g:Toggle({ Title = "Trigger", Callback = function() end })
g = GroupTab:Group({})
g:Toggle({ Title = "A", Callback = function() end })
g:Toggle({ Title = "B", Callback = function() end })
g:Toggle({ Title = "C", Callback = function() end })

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
    "Dark","Light",
    "Rosa","Blue","Roxo","Amarelo","Verde","Marrom","Vermelho",
    "Cyan","Laranja","Lime","Teal","Indigo","Violet","Magenta","Sky",
    "Amber","Emerald","Coral","Gold","Silver","Navy","Mint","Peach",
    "Lavender","Crimson","Forest","Midnight","Neon","Sunset","Ocean","Grape"
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
