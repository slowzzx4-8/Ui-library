--[[
    VoidxHub Example
    Base completa = Void Hub (todas as funções)
    loadstring retorna VoidUI (alias VoidxHub)
]]

local Library
if isfile and isfile("VoidxHub.lua") then
    Library = loadstring(readfile("VoidxHub.lua"))()
else
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/VoidxHub.lua"))()
end

local Window = Library:CreateWindow({
    Name = "VoidxHub",
    Author = "By Slowzzx",
    Icon = "house",
    Theme = "Dark",
    Resizable = true,
    Transparent = false,
    Size = UDim2.fromOffset(500, 380),
    SideBarWidth = 160,
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

Main:Section({ Title = "Elements" })
Main:Paragraph({ Title = "VoidxHub", Desc = "Todas as funções da Void Hub · Search + Minimize / Fullscreen / Destroy no topbar" })
Main:Button({ Title = "Button", Desc = "Exemplo", Callback = function() print("btn") end })
Main:Toggle({ Title = "Auto Farm", Desc = "Toggle branco quando ativo", Default = false, Callback = print })
Main:Slider({ Title = "WalkSpeed", Desc = "Slider estilo Void Hub", Min = 16, Max = 100, Default = 16, Callback = function(v)
    local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end })
Main:Dropdown({
    Title = "Mode",
    Desc = "Nada selecionado por padrão",
    Option = { "Normal", "Rapido", "Seguro", "AFK" },
    -- Value omitido = vazio
    Callback = print,
})
Main:Dropdown({
    Title = "Multi",
    Multi = true,
    Option = { "A", "B", "C" },
    Callback = print,
})
Main:Input({ Title = "Input", Placeholder = "Ex: slowzzx", Callback = print })
Main:Keybind({ Title = "Keybind", Default = "E", Callback = print })
Main:Colorpicker({ Title = "Color", Default = Color3.fromRGB(255, 255, 255), Callback = print })

Player:Section({ Title = "Character" })
Player:Slider({ Title = "WalkSpeed", Min = 16, Max = 200, Default = 16 })
Player:Slider({ Title = "JumpPower", Min = 50, Max = 200, Default = 50 })
Player:Toggle({ Title = "Inf Jump", Default = false })
Player:Toggle({ Title = "Noclip", Default = false })

Visuals:Section({ Title = "ESP" })
Visuals:Toggle({ Title = "ESP", Default = false })
Visuals:Colorpicker({ Title = "ESP Color", Default = Color3.fromRGB(255, 255, 255) })
Visuals:Dropdown({ Title = "ESP Mode", Option = { "Box", "Chams", "Highlight" } })

Settings:Section({ Title = "User" })
Settings:Toggle({ Title = "Show User", Default = true, Callback = function(v)
    if Window.UserEnabled then Window:UserEnabled(v) end
end })
Settings:Toggle({ Title = "Anonymous", Default = false, Callback = function(v)
    if Window.Anonymous then Window:Anonymous(v) end
end })
Settings:Section({ Title = "Window" })
Settings:Toggle({ Title = "Resizing", Default = true, Callback = function(v)
    if Window.SetResizable then Window:SetResizable(v) end
end })
Settings:Button({ Title = "To Center", Callback = function() if Window.ToCenter then Window:ToCenter() end end })
Settings:Button({ Title = "Minimize", Callback = function() if Window.Minimize then Window:Minimize() end end })
Settings:Button({ Title = "Fullscreen", Callback = function() if Window.ToggleFullscreen then Window:ToggleFullscreen() end end })
Settings:Button({ Title = "Destroy", Callback = function() Window:Destroy() end })

print("[VoidxHub] full Void Hub base loaded")
