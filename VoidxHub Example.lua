--[[
    VoidxHub Example — estilo Void Hub (sidebar + search + resize)
]]

local VoidxHub
if isfile and isfile("VoidxHub.lua") then
    VoidxHub = loadstring(readfile("VoidxHub.lua"))()
else
    VoidxHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/VoidxHub.lua"))()
end

local Window = VoidxHub:CreateWindow({
    Name = "VoidxHub",
    Author = "By Slowzzx",
    Icon = "triangle",
    SideBarWidth = 160,
    Size = UDim2.fromOffset(500, 380),
    Resizable = true,
    ToggleKey = Enum.KeyCode.LeftControl,
    User = {
        Enabled = true,
        Anonymous = false,
    },
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Player = Window:Tab({ Title = "Player", Icon = "user" })
local Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- MAIN
Main:Section({ Title = "Welcome" })
Main:Paragraph({
    Title = "VoidxHub",
    Desc = "Mesmo estilo Void Hub: sidebar, search, resize, colorpicker, user.",
})
Main:Button({
    Title = "Notify Test",
    Desc = "Botão de exemplo",
    ButtonText = "Click",
    Callback = function() print("clicked") end,
})
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Ativa o farm automático.",
    Default = true,
    Callback = function(v) print("farm", v) end,
})
Main:Slider({
    Title = "WalkSpeed",
    Desc = "16 — 100",
    Min = 16, Max = 100, Default = 50, Step = 1,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end,
})
Main:Dropdown({
    Title = "Mode",
    Desc = "Selecionar modo",
    Option = { "Normal", "Rapido", "Seguro", "AFK" },
    Value = "Normal",
    Callback = function(v) print(v) end,
})
Main:Dropdown({
    Title = "Multi Select",
    Multi = true,
    Option = { "A", "B", "C", "D" },
    Value = { "A" },
    Callback = function(v) print(v) end,
})
Main:Input({
    Title = "Username",
    Placeholder = "Ex: slowzzx",
    Callback = function(t) print(t) end,
})

-- PLAYER
Player:Section({ Title = "Movement" })
Player:Slider({ Title = "WalkSpeed", Min = 16, Max = 200, Default = 16, Callback = function(v)
    local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end })
Player:Slider({ Title = "JumpPower", Min = 50, Max = 200, Default = 50, Callback = function(v)
    local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = v end
end })
Player:Toggle({ Title = "Infinite Jump", Default = false })
Player:Toggle({ Title = "Noclip", Default = false })
Player:Keybind({ Title = "Panic Key", Default = "X", Callback = function(k) print("key", k) end })

-- VISUALS
Visuals:Section({ Title = "ESP" })
Visuals:Toggle({ Title = "ESP Enabled", Default = false })
Visuals:Toggle({ Title = "Team Check", Default = true })
Visuals:Dropdown({ Title = "ESP Mode", Option = { "Box", "Chams", "Highlight", "Name" }, Value = "Box" })
Visuals:Colorpicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(0, 255, 80),
    Callback = function(c) print(c) end,
})
Visuals:Slider({ Title = "Distance", Min = 50, Max = 2000, Default = 500, Step = 25 })

-- SETTINGS
Settings:Section({ Title = "User" })
Settings:Toggle({
    Title = "Show User",
    Default = true,
    Callback = function(v) Window:UserEnabled(v) end,
})
Settings:Toggle({
    Title = "Anonymous",
    Default = false,
    Callback = function(v) Window:Anonymous(v) end,
})

Settings:Section({ Title = "Window" })
Settings:Toggle({
    Title = "Resizing",
    Default = true,
    Callback = function(v) Window:SetResizable(v) end,
})
Settings:Keybind({
    Title = "Toggle UI Key",
    Default = "LeftControl",
    Callback = function(k)
        if Enum.KeyCode[k] then Window:SetToggleKey(Enum.KeyCode[k]) end
    end,
})
Settings:Button({ Title = "To Center", ButtonText = "Center", Callback = function() Window:ToCenter() end })
Settings:Button({ Title = "Minimize", ButtonText = "Min", Callback = function() Window:Minimize() end })
Settings:Button({ Title = "Destroy UI", ButtonText = "Destroy", Callback = function() Window:Destroy() end })
Settings:Colorpicker({
    Title = "Accent Preview",
    Default = Color3.fromRGB(80, 160, 255),
    Callback = function() end,
})

print("[VoidxHub] loaded — LeftControl minimize")
