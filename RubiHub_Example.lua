--[[
    Rubi Hub — UI Element Showcase
    Only demonstrates what the library can build (no game features).
]]

local Rubi = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/RubiHub.lua"))()

local Window = Rubi.CreateWindow({
    Title = "Rubi Hub",
    Size = UDim2.new(0, 520, 0, 380),
})

-- ════════════════════════════════════════
-- LEFT TAB: Demo of all controls
-- ════════════════════════════════════════
local Demo = Window:CreateTab("Demo")

local Sec1 = Demo:CreateSection("Toggles & Sliders")

Sec1:AddToggle({
    Name = "Rounded Toggle (ON)",
    Default = true,
    Callback = function(state)
        -- state = true / false
    end,
})

Sec1:AddToggle({
    Name = "Rounded Toggle (OFF)",
    Default = false,
    Callback = function(state) end,
})

Sec1:AddSlider({
    Name = "Rounded Slider",
    Min = 0,
    Max = 200,
    Default = 100,
    Suffix = "",
    Callback = function(value) end,
})

Sec1:AddSlider({
    Name = "With Suffix",
    Min = 50,
    Max = 150,
    Default = 90,
    Suffix = "%",
    Callback = function(value) end,
})

local Sec2 = Demo:CreateSection("Buttons")

Sec2:AddButton({
    Name = "Red Action Button",
    ButtonText = "Click",
    Callback = function() end,
})

Sec2:AddButton({
    Name = "Another Button",
    ButtonText = "Run",
    Callback = function() end,
})

local Sec3 = Demo:CreateSection("Dropdowns")

Sec3:AddDropdown({
    Name = "Single Select",
    Options = { "Option A", "Option B", "Option C", "Option D" },
    Multi = false,
    Default = "Option A",
    Callback = function(selected) end, -- string
})

Sec3:AddDropdown({
    Name = "Multi Select",
    Options = { "Red", "Green", "Blue", "Yellow", "Purple" },
    Multi = true,
    Default = { "Red", "Blue" },
    Callback = function(list) end, -- table of strings
})

local Sec4 = Demo:CreateSection("Labels")

Sec4:AddLabel("Simple dim label text")

Sec4:AddParagraph(
    "Paragraph Title",
    "Longer description text. Use this for notes, credits or help inside a section."
)

local Extra = Window:CreateTab("Extra")

local More = Extra:CreateSection("More Controls")
More:AddToggle({ Name = "Example Toggle", Default = false, Callback = function() end })
More:AddSlider({ Name = "Example Slider", Min = 1, Max = 10, Default = 5, Callback = function() end })
More:AddButton({ Name = "Example Button", ButtonText = "Go", Callback = function() end })
More:AddDropdown({
    Name = "Example Dropdown",
    Options = { "One", "Two", "Three" },
    Multi = false,
    Callback = function() end,
})

-- ════════════════════════════════════════
-- RIGHT SIDE TABS
-- ════════════════════════════════════════
local Info = Window:CreateTab("Info", true)

local About = Info:CreateSection("About")
About:AddParagraph("Rubi Hub", "UI library · red theme · rounded controls")
About:AddLabel("Search icon uses IconsV2 (lucide)")
About:AddLabel("FPS + ms counter top-right")

local Settings = Window:CreateTab("Settings", true)

local UI = Settings:CreateSection("Interface")
UI:AddSlider({ Name = "UI Size", Min = 80, Max = 150, Default = 100, Suffix = "%", Callback = function() end })
UI:AddToggle({ Name = "Notifications", Default = true, Callback = function() end })
UI:AddToggle({ Name = "Open On Launch", Default = true, Callback = function() end })

local Defaults = Settings:CreateSection("Defaults")
Defaults:AddButton({ Name = "Reset to Defaults", ButtonText = "Reset", Callback = function() end })
Defaults:AddButton({ Name = "Turn Off All", ButtonText = "Off", Callback = function() end })

local Config = Window:CreateTab("Config", true)

local Cfg = Config:CreateSection("Config")
Cfg:AddToggle({ Name = "Auto Save", Default = true, Callback = function() end })
Cfg:AddToggle({ Name = "Auto Load", Default = true, Callback = function() end })
Cfg:AddButton({ Name = "Save Config", ButtonText = "Save", Callback = function() end })
Cfg:AddButton({ Name = "Load Config", ButtonText = "Load", Callback = function() end })

local Imp = Config:CreateSection("Import / Export")
Imp:AddButton({ Name = "Export Config", ButtonText = "Export", Callback = function() end })
Imp:AddButton({ Name = "Import Config", ButtonText = "Import", Callback = function() end })
