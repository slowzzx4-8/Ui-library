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
task.wait(0.05)
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
Window:SetBackgroundImage("rbxassetid://84152360484913", 0.25)

local count = 0
local function n()
    count = count + 1
    return count
end


local Tabs = {}
Tabs["Visuals"] = Window:Tab({ Title = "Visuals", Icon = "eye", Border = true })
Tabs["Elements"] = Window:Tab({ Title = "Elements", Icon = "sparkles", Border = true })
Tabs["Management"] = Window:Tab({ Title = "Management", Icon = "chart-no-axes-gantt", Border = true })
Tabs["Input"] = Window:Tab({ Title = "Input", Icon = "file-input", Border = true })
Tabs["Notify"] = Window:Tab({ Title = "Notify", Icon = "message-square-dot", Border = true })
Tabs["Appearance"] = Window:Tab({ Title = "Appearance", Icon = "palette", Border = true })
Tabs["Dialog"] = Window:Tab({ Title = "Dialog", Icon = "message-circle", Border = true })
Tabs["Demo"] = Window:Tab({ Title = "Demo", Icon = "layout-list", Border = true })
Tabs["Advanced"] = Window:Tab({ Title = "Advanced", Icon = "blocks", Border = true })
Tabs["Farm"] = Window:Tab({ Title = "Farm", Icon = "sprout", Border = true })
Tabs["Player"] = Window:Tab({ Title = "Player", Icon = "user", Border = true })
Tabs["Misc"] = Window:Tab({ Title = "Misc", Icon = "box", Border = true })
Tabs["Settings"] = Window:Tab({ Title = "Settings", Icon = "settings", Border = true })

-- Visuals / ESP
Tabs.Visuals:TabSection({ Title = "ESP" })
Tabs.Visuals:Toggle({ Title = "ESP Chams", Default = false, Callback = function(v) ESP_Settings.Enabled = v UpdateAllESP() end })
Tabs.Visuals:Colorpicker({ Title = "ESP Color", Default = ESP_Settings.Color, Callback = function(c) ESP_Settings.Color = c UpdateAllESP() end })
Tabs.Visuals:Toggle({ Title = "Team Check", Default = true, Callback = function(v) print("Team", v) end })
Tabs.Visuals:Slider({ Title = "Fill Transparency", Value = { Min = 0, Max = 1, Default = 0.5 }, Step = 0.05, Callback = function(v) print(v) end })
Tabs.Visuals:Dropdown({ Title = "ESP Mode", Option = { "Box", "Chams", "Highlight", "Name" }, Value = "Chams", Callback = function(v) print(v) end })

Tabs.Demo:TabSection({ Title = "Animals" })
Tabs.Demo:Dropdown({ Title = "Select Pet", Option = { "Kiwi", "Blood Kiwi", "Owl", "Panda", "Spotted Deer", "Golden Lab", "Frog", "Red Dragon", "Cow", "Cat", "Dog", "Fox", "Bear", "Rabbit", "Eagle", "Lion", "Tiger", "Wolf", "Shark", "Whale" }, Value = "Kiwi", Callback = function(v) print(v) end })
Tabs.Demo:TabSection({ Title = "Controls" })
Tabs.Demo:Toggle({ Title = "Auto Farm", Default = false, Callback = function(v) print(v) end })
Tabs.Demo:Toggle({ Title = "Show ESP", Default = true, Callback = function(v) print(v) end })
Tabs.Demo:Button({ Title = "Refresh List", Callback = function() Window:Notify({ Title = "Demo", Content = "Refreshed", Duration = 2 }) end })
Tabs.Demo:Button({ Title = "Reset", Callback = function() Window:Notify({ Title = "Demo", Content = "Reset", Duration = 2 }) end })
Tabs.Demo:Dropdown({ Title = "Fruits", Multi = true, Option = { "Apple", "Banana", "Orange", "Mango", "Grape", "Kiwi" }, Value = { "Apple" }, Callback = function(v) print(v) end })


Tabs.Advanced:TabSection({ Title = "Wind-like" })
Tabs.Advanced:Accordion({ Title = "Info Accordion", Content = "Extra details go here. Click header to expand.", Open = false })
Tabs.Advanced:Timeline({ Title = "Progress", Steps = { "Load", "Auth", "Ready", "Done" }, Index = 2 })
Tabs.Advanced:ChipList({ Title = "Tags", Options = { "PvP", "Farm", "Safe", "VIP" }, Value = { "Farm" }, Callback = function(v) print(v) end })
Tabs.Advanced:SegmentedControl({ Title = "Mode", Options = { "Easy", "Normal", "Hard" }, Value = "Normal", Callback = function(v) print(v) end })
Tabs.Advanced:Path2D({ Title = "Stats Chart", Values = { 0.3, 0.5, 0.4, 0.9, 0.6, 0.7 } })
Tabs.Advanced:Viewport({ Title = "Preview", Image = "84152360484913" })
Tabs.Advanced:PopupButton({ Title = "Open Popup", PopupTitle = "Hello", PopupContent = "Popup via Dialog", Callback = function() print("ok") end })
Tabs.Advanced:Button({ Title = "Show Tooltip", Callback = function() Window:ShowTooltip("This is a tooltip", 2) end })
Tabs.Advanced:Button({ Title = "Toggle Acrylic", Callback = function() Window:ToggleAcrylic(not Window.Acrylic) end })
Tabs.Advanced:Button({ Title = "Save Config", Callback = function() Window:SetConfig("demo", true) Window:SaveConfig("VoidHub") end })
Tabs.Advanced:Button({ Title = "Load Config", Callback = function() Window:LoadConfig("VoidHub") end })

Tabs.Elements:Button({ Title = "Action 1", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 1", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 2", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 2", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 3", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 3", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 4", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 4", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 5", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 5", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 6", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 6", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 7", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 7", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 8", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 8", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 9", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 9", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 10", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 10", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 11", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 11", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 12", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 12", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 13", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 13", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 14", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 14", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 15", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 15", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 16", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 16", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 17", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 17", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 18", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 18", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 19", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 19", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 20", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 20", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 21", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 21", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 22", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 22", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 23", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 23", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 24", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 24", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 25", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 25", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 26", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 26", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 27", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 27", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 28", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 28", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 29", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 29", Duration = 1.5 }) end })
Tabs.Elements:Button({ Title = "Action 30", Callback = function() Window:Notify({ Title = "Btn", Content = "Action 30", Duration = 1.5 }) end })
Tabs.Elements:Toggle({ Title = "Option 1", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 2", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 3", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 4", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 5", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 6", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 7", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 8", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 9", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 10", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 11", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 12", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 13", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 14", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 15", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 16", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 17", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 18", Default = true, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 19", Default = false, Callback = function(v) end })
Tabs.Elements:Toggle({ Title = "Option 20", Default = true, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 1", Value = { Min = 0, Max = 100, Default = 5 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 2", Value = { Min = 0, Max = 100, Default = 10 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 3", Value = { Min = 0, Max = 100, Default = 15 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 4", Value = { Min = 0, Max = 100, Default = 20 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 5", Value = { Min = 0, Max = 100, Default = 25 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 6", Value = { Min = 0, Max = 100, Default = 30 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 7", Value = { Min = 0, Max = 100, Default = 35 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 8", Value = { Min = 0, Max = 100, Default = 40 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 9", Value = { Min = 0, Max = 100, Default = 45 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 10", Value = { Min = 0, Max = 100, Default = 50 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 11", Value = { Min = 0, Max = 100, Default = 55 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 12", Value = { Min = 0, Max = 100, Default = 60 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 13", Value = { Min = 0, Max = 100, Default = 65 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 14", Value = { Min = 0, Max = 100, Default = 70 }, Step = 1, Callback = function(v) end })
Tabs.Elements:Slider({ Title = "Value 15", Value = { Min = 0, Max = 100, Default = 75 }, Step = 1, Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 1", Option = { "A1", "B1", "C1", "D1" }, Value = "A1", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 2", Option = { "A2", "B2", "C2", "D2" }, Value = "A2", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 3", Option = { "A3", "B3", "C3", "D3" }, Value = "A3", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 4", Option = { "A4", "B4", "C4", "D4" }, Value = "A4", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 5", Option = { "A5", "B5", "C5", "D5" }, Value = "A5", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 6", Option = { "A6", "B6", "C6", "D6" }, Value = "A6", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 7", Option = { "A7", "B7", "C7", "D7" }, Value = "A7", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 8", Option = { "A8", "B8", "C8", "D8" }, Value = "A8", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 9", Option = { "A9", "B9", "C9", "D9" }, Value = "A9", Callback = function(v) end })
Tabs.Farm:Dropdown({ Title = "Select 10", Option = { "A10", "B10", "C10", "D10" }, Value = "A10", Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 1", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 2", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 3", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 4", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 5", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 6", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 7", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 8", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 9", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 10", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 11", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 12", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 13", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 14", Default = false, Callback = function(v) end })
Tabs.Player:Toggle({ Title = "Player Flag 15", Default = false, Callback = function(v) end })
Tabs.Misc:Button({ Title = "Misc 1", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 2", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 3", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 4", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 5", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 6", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 7", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 8", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 9", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Misc:Button({ Title = "Misc 10", Icon = "mouse-pointer-click", Callback = function() end })
Tabs.Management:Paragraph({ Title = "Note 1", Desc = "Description line 1" })
Tabs.Management:Paragraph({ Title = "Note 2", Desc = "Description line 2" })
Tabs.Management:Paragraph({ Title = "Note 3", Desc = "Description line 3" })
Tabs.Management:Paragraph({ Title = "Note 4", Desc = "Description line 4" })
Tabs.Management:Paragraph({ Title = "Note 5", Desc = "Description line 5" })
Tabs.Management:Paragraph({ Title = "Note 6", Desc = "Description line 6" })
Tabs.Management:Paragraph({ Title = "Note 7", Desc = "Description line 7" })
Tabs.Management:Paragraph({ Title = "Note 8", Desc = "Description line 8" })
Tabs.Management:Paragraph({ Title = "Note 9", Desc = "Description line 9" })
Tabs.Management:Paragraph({ Title = "Note 10", Desc = "Description line 10" })
Tabs.Input:Input({ Title = "Field 1", Placeholder = "Type 1...", Callback = function(v) end })
Tabs.Input:Input({ Title = "Field 2", Placeholder = "Type 2...", Callback = function(v) end })
Tabs.Input:Input({ Title = "Field 3", Placeholder = "Type 3...", Callback = function(v) end })
Tabs.Input:Input({ Title = "Field 4", Placeholder = "Type 4...", Callback = function(v) end })
Tabs.Input:Input({ Title = "Field 5", Placeholder = "Type 5...", Callback = function(v) end })
Tabs.Input:Input({ Title = "Field 6", Placeholder = "Type 6...", Callback = function(v) end })
Tabs.Input:Input({ Title = "Field 7", Placeholder = "Type 7...", Callback = function(v) end })
Tabs.Input:Keybind({ Title = "Bind 1", Callback = function(k) print(k) end })
Tabs.Input:Keybind({ Title = "Bind 2", Callback = function(k) print(k) end })
Tabs.Input:Keybind({ Title = "Bind 3", Callback = function(k) print(k) end })
Tabs.Input:Keybind({ Title = "Bind 4", Callback = function(k) print(k) end })
Tabs.Input:Keybind({ Title = "Bind 5", Callback = function(k) print(k) end })
Tabs.Notify:Button({ Title = "Notify 1", Callback = function() Window:Notify({ Title = "N1", Content = "Message 1", Duration = 2 }) end })
Tabs.Notify:Button({ Title = "Notify 2", Callback = function() Window:Notify({ Title = "N2", Content = "Message 2", Duration = 2 }) end })
Tabs.Notify:Button({ Title = "Notify 3", Callback = function() Window:Notify({ Title = "N3", Content = "Message 3", Duration = 2 }) end })
Tabs.Notify:Button({ Title = "Notify 4", Callback = function() Window:Notify({ Title = "N4", Content = "Message 4", Duration = 2 }) end })
Tabs.Notify:Button({ Title = "Notify 5", Callback = function() Window:Notify({ Title = "N5", Content = "Message 5", Duration = 2 }) end })

Tabs.Appearance:TabSection({ Title = "Theme" })
local AllThemes = {
    "Dark","Light","Pink","Blue","Purple","Yellow","Green","Brown","Red",
    "Cyan","Orange","Lime","Teal","Indigo","Violet","Magenta","Sky",
    "Amber","Emerald","Coral","Gold","Silver","Navy","Mint","Peach",
    "Lavender","Crimson","Forest","Midnight","Neon","Sunset","Ocean","Grape"
}
Tabs.Appearance:Dropdown({
    Title = "Theme",
    Option = AllThemes,
    Value = "Dark",
    Callback = function(v) Window:SetTheme(v) end,
})
Tabs.Appearance:Slider({
    Title = "UI Transparency",
    Value = { Min = 0, Max = 1, Default = 0.15 },
    Step = 0.05,
    Callback = function(v) Window:SetTransparency(v) end,
})
Tabs.Appearance:TabSection({ Title = "Background" })
Tabs.Appearance:Input({
    Title = "Image ID",
    Placeholder = "rbxassetid://...",
    Callback = function(v) if v and v ~= "" then Window:SetBackgroundImage(v, 0.25) end end,
})
Tabs.Appearance:Input({
    Title = "Video ID",
    Placeholder = "rbxassetid://...",
    Callback = function(v) if v and v ~= "" then Window:SetBackgroundVideo(v, 0.3) end end,
})
Tabs.Appearance:Dropdown({
    Title = "Language",
    Option = {
        "English","Português","Español","Français","Deutsch","Italiano",
        "Русский","日本語","中文","한국어","Polish","Turkish","Dutch","Swedish",
        "Arabic","Hindi","Thai","Vietnamese","Indonesian","Romanian","Czech",
        "Greek","Hungarian","Finnish","Norwegian","Danish","Ukrainian","Hebrew",
        "Malay","Filipino",
    },
    Value = "English",
    Callback = function(v)
        local map = {
            English="English",["Português"]="Portuguese",["Español"]="Spanish",
            ["Français"]="French",Deutsch="German",Italiano="Italian",
            ["Русский"]="Russian",["日本語"]="Japanese",["中文"]="Chinese",
            ["한국어"]="Korean",
        }
        Window:SetLanguage(map[v] or v)
    end,
})

Tabs.Dialog:Button({
    Title = "Sample Dialog",
    Callback = function()
        Window:Dialog({
            Title = "Confirm",
            Content = "Do you want to continue?",
            Buttons = {
                { Title = "Yes", Callback = function() print("yes") end },
                { Title = "No", Callback = function() end },
            },
        })
    end,
})
Tabs.Dialog:Button({ Title = "Popup API", Callback = function() Window:Popup({ Title = "Popup", Content = "Hello from Popup" }) end })

Tabs.Settings:TabSection({ Title = "Window" })
Tabs.Settings:Toggle({ Title = "Resizing", Default = true, Callback = function(v) Window:SetResizable(v) end })
Tabs.Settings:Button({ Title = "To Center", Callback = function() Window:ToCenter() end })
Tabs.Settings:Button({ Title = "Fullscreen", Callback = function() Window:ToggleFullscreen() end })
Tabs.Settings:Button({ Title = "Destroy UI", Callback = function() Window:Destroy() end })
Tabs.Settings:TabSection({ Title = "Lock" })
Tabs.Settings:Button({ Title = "Lock Window", Callback = function() Window:LockAll() end })
Tabs.Settings:Button({ Title = "Unlock Window", Callback = function() Window:UnlockAll() end })

print("[Void Hub Example] elements roughly generated")
