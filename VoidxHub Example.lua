--[[
    VoidxHub — Example (estilo Kaitun)
    Coloque VoidxHub.lua no workspace do executor e rode este script.
]]

local VoidxHub
if isfile and isfile("VoidxHub.lua") then
    VoidxHub = loadstring(readfile("VoidxHub.lua"))()
else
    -- fallback: cole o path ou use HttpGet do seu repo
    VoidxHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/VoidxHub.lua"))()
end

local Window = VoidxHub:CreateWindow({
    Name = "VoidxHub",
    Author = "by slowzzx",
    Icon = "triangle",
    Size = UDim2.fromOffset(560, 420),
    ToggleKey = Enum.KeyCode.LeftControl,
})

local Home = Window:Tab({ Title = "Home", Icon = "house" })
local Player = Window:Tab({ Title = "Player", Icon = "user" })
local Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

local Farm = Window:BottomTab({ Title = "Farm", Icon = "sprout" })
local Shop = Window:BottomTab({ Title = "Shop", Icon = "shopping-cart" })

-- HOME (igual a imagem)
Home:Toggle({
    Title = "Toggle",
    Icon = "power",
    Label = "Auto Farm",
    Desc = "Ativa o farm automático.",
    Default = true,
    Callback = function(v) print("[Auto Farm]", v) end,
})

Home:Slider({
    Title = "Slider",
    Icon = "sliders-horizontal",
    Label = "WalkSpeed",
    Min = 16, Max = 100, Default = 50, Step = 1,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end,
})

Home:Dropdown({
    Title = "Dropdown",
    Icon = "list",
    Label = "Selecionar Modo",
    Option = { "Normal", "Rapido", "Seguro", "AFK" },
    Value = "Normal",
    Callback = function(v) print("[Mode]", v) end,
})

Home:Input({
    Title = "Input (Texto)",
    Icon = "pencil",
    Label = "Digite algo...",
    Placeholder = "Ex: slowzzx",
    Callback = function(t) print("[Input]", t) end,
})

-- PLAYER
Player:Slider({
    Title = "WalkSpeed", Label = "Speed", Min = 16, Max = 200, Default = 16,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end,
})
Player:Slider({
    Title = "JumpPower", Label = "Jump", Min = 50, Max = 200, Default = 50,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = v end
    end,
})
Player:Toggle({ Title = "Infinite Jump", Label = "Inf Jump", Desc = "Pulo infinito.", Default = false, Callback = print })
Player:Toggle({ Title = "Noclip", Label = "Noclip", Desc = "Atravessar paredes.", Default = false, Callback = print })

-- VISUALS
Visuals:Toggle({ Title = "ESP", Label = "ESP Enabled", Desc = "Ver jogadores.", Default = false })
Visuals:Toggle({ Title = "Team Check", Label = "Team Check", Desc = "Ignorar time.", Default = true })
Visuals:Dropdown({ Title = "ESP Mode", Label = "Modo", Option = {"Box","Chams","Highlight","Name"}, Value = "Box" })
Visuals:Slider({ Title = "Distance", Label = "Max Distance", Min = 50, Max = 2000, Default = 500, Step = 25 })

-- SETTINGS
Settings:Paragraph({ Title = "VoidxHub", Desc = "Dark card UI · Lucide icons · LeftControl = minimize" })
Settings:Button({ Title = "Discord", Desc = "Copiar convite", ButtonText = "Copy Invite", Callback = function()
    if setclipboard then setclipboard("https://discord.gg/example") end
end })
Settings:Button({ Title = "Minimize", Desc = "Minimizar", ButtonText = "Minimize", Callback = function() Window:Minimize() end })
Settings:Button({ Title = "Destroy", Desc = "Fechar UI", ButtonText = "Destroy UI", Callback = function() Window:Destroy() end })

-- FARM
Farm:Toggle({ Title = "Auto Farm", Label = "Enabled", Desc = "Farm principal.", Default = false, Callback = print })
Farm:Toggle({ Title = "Auto Collect", Label = "Collect", Desc = "Coletar drops.", Default = false })
Farm:Dropdown({ Title = "Farm Type", Label = "Tipo", Option = {"Coins","Gems","XP","All"}, Value = "Coins" })
Farm:Slider({ Title = "Delay", Label = "Delay (ms)", Min = 0, Max = 2000, Default = 250, Step = 50 })

-- SHOP
Shop:Paragraph({ Title = "Shop", Desc = "Compre itens e upgrades." })
Shop:Button({ Title = "Buy Speed", Desc = "Custa 100 coins", ButtonText = "Buy", Callback = function() print("buy speed") end })
Shop:Button({ Title = "Buy Jump", Desc = "Custa 150 coins", ButtonText = "Buy", Callback = function() print("buy jump") end })
Shop:Input({ Title = "Promo Code", Label = "Codigo", Placeholder = "XXXX-XXXX" })

print("[VoidxHub] Example loaded")
