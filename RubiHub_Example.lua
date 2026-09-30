--[[
    Rubi Hub — Example Usage
    Load the library, then build tabs / sections / controls.
    You can host RubiHub.lua on a paste/raw URL and loadstring it.
]]

-- ── Load library (local or HTTPS) ──
local Rubi = loadstring(game:HttpGet("YOUR_HTTPS_LINK_TO_RubiHub.lua"))()
-- Or if in the same environment:
-- local Rubi = require(path.to.RubiHub)  -- or loadfile

local Window = Rubi:CreateWindow({
    Title = "Rubi Hub",
    Size = UDim2.new(0, 520, 0, 380),
})

-- ═══════════════ LEFT TABS ═══════════════

local PlayerTab = Window:CreateTab("Player")

local Movement = PlayerTab:CreateSection("Movement")

Movement:AddToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(state)
        print("Speed Boost:", state)
        -- your code here
    end,
})

Movement:AddSlider({
    Name = "Boost Speed",
    Min = 16,
    Max = 500,
    Default = 155,
    Suffix = "",
    Callback = function(val)
        print("Boost Speed:", val)
    end,
})

Movement:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        print("Fly:", state)
    end,
})

Movement:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 300,
    Default = 80,
    Callback = function(val)
        print("Fly Speed:", val)
    end,
})

Movement:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        print("Noclip:", state)
    end,
})

Movement:AddToggle({
    Name = "Infinite Jump",
    Default = true,
    Callback = function(state)
        print("Infinite Jump:", state)
    end,
})

Movement:AddToggle({
    Name = "Jump Boost",
    Default = false,
    Callback = function(state)
        print("Jump Boost:", state)
    end,
})

local Camera = PlayerTab:CreateSection("Camera")

Camera:AddToggle({
    Name = "Custom FOV",
    Default = false,
    Callback = function(state)
        print("Custom FOV:", state)
    end,
})

Camera:AddSlider({
    Name = "Field Of View",
    Min = 30,
    Max = 120,
    Default = 90,
    Callback = function(val)
        print("FOV:", val)
    end,
})

Camera:AddToggle({
    Name = "Unlock Zoom",
    Default = false,
    Callback = function(state)
        print("Unlock Zoom:", state)
    end,
})

local Character = PlayerTab:CreateSection("Character")

Character:AddButton({
    Name = "Reset Character",
    ButtonText = "Reset",
    Callback = function()
        print("Reset Character")
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end,
})

Character:AddButton({
    Name = "Sit Down",
    ButtonText = "Sit",
    Callback = function()
        print("Sit")
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Sit = true end
        end
    end,
})

-- ── Players tab ──
local PlayersTab = Window:CreateTab("Players")

local Target = PlayersTab:CreateSection("Target Player")

Target:AddDropdown({
    Name = "Select Player",
    Options = { "Player1", "Player2", "Player3" }, -- replace with live list
    Multi = false,
    Default = nil,
    Callback = function(selected)
        print("Selected player:", selected)
    end,
})

Target:AddButton({
    Name = "Teleport To Player",
    ButtonText = "Teleport",
    Callback = function()
        print("Teleport to player")
    end,
})

Target:AddToggle({
    Name = "Spectate Player",
    Default = false,
    Callback = function(state)
        print("Spectate:", state)
    end,
})

Target:AddButton({
    Name = "Copy Username",
    ButtonText = "Copy",
    Callback = function()
        print("Copy username")
    end,
})

Target:AddButton({
    Name = "Refresh Player List",
    ButtonText = "Refresh",
    Callback = function()
        print("Refresh list")
    end,
})

local ESP = PlayersTab:CreateSection("ESP")

ESP:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(state)
        print("ESP Players:", state)
    end,
})

ESP:AddToggle({
    Name = "ESP Highlight",
    Default = true,
    Callback = function(state)
        print("ESP Highlight:", state)
    end,
})

ESP:AddSlider({
    Name = "ESP Max Distance",
    Min = 100,
    Max = 5000,
    Default = 2000,
    Callback = function(val)
        print("ESP Distance:", val)
    end,
})

-- ── Vehicles tab ──
local VehiclesTab = Window:CreateTab("Vehicles")

local Driving = VehiclesTab:CreateSection("Driving")

Driving:AddToggle({
    Name = "Vehicle Speed Boost",
    Default = false,
    Callback = function(state) print("Vehicle Speed Boost:", state) end,
})

Driving:AddSlider({
    Name = "Vehicle Speed",
    Min = 50,
    Max = 500,
    Default = 150,
    Callback = function(val) print("Vehicle Speed:", val) end,
})

Driving:AddToggle({
    Name = "Fly Vehicle",
    Default = false,
    Callback = function(state) print("Fly Vehicle:", state) end,
})

Driving:AddSlider({
    Name = "Vehicle Fly Speed",
    Min = 50,
    Max = 400,
    Default = 120,
    Callback = function(val) print("Vehicle Fly Speed:", val) end,
})

Driving:AddButton({
    Name = "Unflip Vehicle",
    ButtonText = "Unflip",
    Callback = function() print("Unflip") end,
})

Driving:AddButton({
    Name = "Exit Vehicle",
    ButtonText = "Exit",
    Callback = function() print("Exit vehicle") end,
})

-- ── World tab ──
local WorldTab = Window:CreateTab("World")

local Locations = WorldTab:CreateSection("Locations")

Locations:AddDropdown({
    Name = "Location",
    Options = {
        "Animal Rescue", "Bank", "Church", "Club Brooks",
        "Day Care", "Fire House", "Grocery Store", "Hospital",
        "Jetts", "Jurassic Park", "Police", "Spawn",
    },
    Multi = false,
    Default = "Church",
    Callback = function(selected)
        print("Location:", selected)
    end,
})

Locations:AddButton({
    Name = "Teleport To Location",
    ButtonText = "Teleport",
    Callback = function() print("TP Location") end,
})

Locations:AddButton({
    Name = "Refresh Locations",
    ButtonText = "Refresh",
    Callback = function() print("Refresh locations") end,
})

local Waypoints = WorldTab:CreateSection("Waypoints")

Waypoints:AddButton({
    Name = "Save Position",
    ButtonText = "Save",
    Callback = function() print("Save waypoint") end,
})

Waypoints:AddDropdown({
    Name = "Saved Waypoints",
    Options = { "None" },
    Multi = false,
    Callback = function(selected) print("Waypoint:", selected) end,
})

Waypoints:AddButton({
    Name = "Go To Waypoint",
    ButtonText = "Teleport",
    Callback = function() print("Go to waypoint") end,
})

-- ── Multi dropdown example ──
local MiscTab = Window:CreateTab("Misc")

local Filters = MiscTab:CreateSection("Filters")

Filters:AddDropdown({
    Name = "Categories",
    Options = { "Combat", "Farm", "Visual", "Utility", "Troll" },
    Multi = true, -- multi-select
    Default = { "Combat", "Visual" },
    Callback = function(list)
        print("Selected categories:", table.concat(list, ", "))
    end,
})

Filters:AddLabel("This is a description label. Multi dropdown lets you pick several options.")

-- ═══════════════ RIGHT SIDE BUTTONS ═══════════════

local DiscordTab = Window:CreateTab("Discord", true) -- true = right panel

local Community = DiscordTab:CreateSection("Community")

Community:AddLabel("Rubi Hub — Official Discord")
Community:AddButton({
    Name = "Copy Discord Link",
    ButtonText = "Click",
    Callback = function()
        print("Copy Discord invite")
        -- setclipboard("https://discord.gg/yourinvite")
    end,
})

local SettingsTab = Window:CreateTab("Settings", true)

local Interface = SettingsTab:CreateSection("Interface")

Interface:AddSlider({
    Name = "UI Size",
    Min = 80,
    Max = 150,
    Default = 100,
    Suffix = "%",
    Callback = function(val) print("UI Size:", val) end,
})

Interface:AddToggle({
    Name = "Notifications",
    Default = true,
    Callback = function(state) print("Notifications:", state) end,
})

Interface:AddToggle({
    Name = "Open On Launch",
    Default = true,
    Callback = function(state) print("Open On Launch:", state) end,
})

local Defaults = SettingsTab:CreateSection("Defaults")

Defaults:AddButton({
    Name = "Reset to Defaults",
    ButtonText = "Reset",
    Callback = function() print("Reset defaults") end,
})

Defaults:AddButton({
    Name = "Turn Off All Toggles",
    ButtonText = "Turn Off",
    Callback = function() print("Turn off all") end,
})

local ConfigTab = Window:CreateTab("Config", true)

local ConfigSec = ConfigTab:CreateSection("Config")

ConfigSec:AddToggle({
    Name = "Auto Save Config",
    Default = true,
    Callback = function(state) print("Auto Save:", state) end,
})

ConfigSec:AddToggle({
    Name = "Auto Load Config",
    Default = true,
    Callback = function(state) print("Auto Load:", state) end,
})

ConfigSec:AddButton({
    Name = "Save Config",
    ButtonText = "Save",
    Callback = function() print("Save config") end,
})

ConfigSec:AddButton({
    Name = "Load Config",
    ButtonText = "Load",
    Callback = function() print("Load config") end,
})

local ImportExport = ConfigTab:CreateSection("Import / Export")

ImportExport:AddButton({
    Name = "Export Config",
    ButtonText = "Export",
    Callback = function() print("Export") end,
})

ImportExport:AddButton({
    Name = "Import Config Text",
    ButtonText = "Import",
    Callback = function() print("Import") end,
})

-- Other empty tabs matching the video layout (optional)
Window:CreateTab("Roleplay")
Window:CreateTab("Items")
Window:CreateTab("Music")
Window:CreateTab("Protection")
Window:CreateTab("Server")
Window:CreateTab("Quick & Keys", true)
