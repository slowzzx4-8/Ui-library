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
local NotifyTab = Window:Tab({ Title = "Notify", Icon = "bell" })
local EmptyTab = Window:Tab({ Title = "Empty", Icon = "folder" }) -- intentionally empty → "Not found"
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- ===================== MAIN =====================
Main:Section({ Title = "Elements" })
Main:Paragraph({
    Title = "VoidxHub",
    Desc = "Todas as funções da Void Hub · Search + Minimize / Fullscreen / Destroy no topbar",
})
Main:Button({
    Title = "Button",
    Desc = "Exemplo",
    Callback = function()
        print("btn")
        Window:Notify({ Title = "Button", Content = "Clicked!", Icon = "mouse-pointer-click", Duration = 2 })
    end,
})
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Toggle branco quando ativo",
    Default = false,
    Callback = function(v)
        print("Auto Farm:", v)
    end,
})
Main:Slider({
    Title = "WalkSpeed",
    Desc = "Slider estilo Void Hub",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end,
})
Main:Dropdown({
    Title = "Mode",
    Desc = "Nada selecionado por padrão",
    Option = { "Normal", "Rapido", "Seguro", "AFK" },
    Callback = print,
})
Main:Dropdown({
    Title = "Multi",
    Multi = true,
    Option = { "A", "B", "C" },
    Callback = function(v)
        print("Multi:", v)
    end,
})
Main:Input({ Title = "Input", Placeholder = "Ex: slowzzx", Callback = print })
Main:Keybind({ Title = "Keybind", Default = "E", Callback = print })
Main:Colorpicker({
    Title = "Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c)
        print("Color:", c)
    end,
})

-- ===================== PLAYER =====================
Player:Section({ Title = "Character" })
Player:Slider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end,
})
Player:Slider({
    Title = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            pcall(function() h.JumpPower = v end)
            pcall(function() h.JumpHeight = v / 7.2 end)
        end
    end,
})
Player:Toggle({
    Title = "Inf Jump",
    Default = false,
    Callback = function(v) print("Inf Jump:", v) end,
})
Player:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(v) print("Noclip:", v) end,
})

-- ===================== VISUALS =====================
Visuals:Section({ Title = "ESP" })
Visuals:Toggle({
    Title = "ESP",
    Default = false,
    Callback = function(v) print("ESP:", v) end,
})
Visuals:Colorpicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c) print("ESP Color:", c) end,
})
Visuals:Dropdown({
    Title = "ESP Mode",
    Option = { "Box", "Chams", "Highlight" },
    Callback = function(v) print("ESP Mode:", v) end,
})

-- ===================== NOTIFY =====================
NotifyTab:Section({ Title = "Notifications" })
NotifyTab:Button({
    Title = "Simple Notify",
    Desc = "Title + content",
    Callback = function()
        Window:Notify({
            Title = "VoidxHub",
            Content = "Hello from Notify tab!",
            Duration = 3,
        })
    end,
})
NotifyTab:Button({
    Title = "Notify with Icon",
    Desc = "Uses lucide icon",
    Callback = function()
        Window:Notify({
            Title = "Success",
            Content = "Action completed.",
            Icon = "check-circle",
            Duration = 4,
        })
    end,
})
NotifyTab:Button({
    Title = "Long Notify",
    Callback = function()
        Window:Notify({
            Title = "Info",
            Content = "This notification stays a bit longer so you can read it.",
            Icon = "info",
            Duration = 6,
        })
    end,
})
NotifyTab:Button({
    Title = "Library Notification",
    Desc = "Via Library:Notification",
    Callback = function()
        Library:Notification({
            Title = "Library API",
            Desc = "Same system, different entry point",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
NotifyTab:Section({ Title = "Window helpers" })
NotifyTab:Button({
    Title = "Show Tooltip",
    Callback = function()
        if Window.ShowTooltip then
            Window:ShowTooltip("Floating tooltip example", 2)
        end
    end,
})
NotifyTab:Button({
    Title = "Popup / Dialog style",
    Callback = function()
        if Window.Popup then
            Window:Popup({
                Title = "Popup",
                Content = "Example popup message",
            })
        else
            Window:Notify({ Title = "Popup", Content = "Fallback notify", Duration = 2 })
        end
    end,
})

-- EmptyTab intentionally has no elements → shows "Not found" with sad face

-- ===================== SETTINGS =====================
Settings:Section({ Title = "User" })
Settings:Toggle({
    Title = "Show User",
    Default = true,
    Callback = function(v)
        if Window.UserEnabled then Window:UserEnabled(v) end
    end,
})
Settings:Toggle({
    Title = "Anonymous",
    Default = false,
    Callback = function(v)
        if Window.Anonymous then Window:Anonymous(v) end
    end,
})

Settings:Section({ Title = "Theme" })
local themeNames = {}
for name in pairs(Window.Themes or {}) do
    table.insert(themeNames, name)
end
table.sort(themeNames)
Settings:Dropdown({
    Title = "Theme",
    Option = #themeNames > 0 and themeNames or { "Dark", "Light", "Purple", "Blue", "Pink" },
    Value = "Dark",
    Callback = function(v)
        Window:SetTheme(v)
        Window:Notify({ Title = "Theme", Content = "Selected: " .. tostring(v), Duration = 2 })
    end,
})
Settings:Toggle({
    Title = "Transparent",
    Default = false,
    Callback = function(v)
        if Window.SetTransparency then Window:SetTransparency(v) end
    end,
})
Settings:Toggle({
    Title = "Acrylic",
    Default = false,
    Callback = function(v)
        if Window.ToggleAcrylic then Window:ToggleAcrylic(v) end
    end,
})

Settings:Section({ Title = "Window" })
Settings:Toggle({
    Title = "Resizing",
    Default = true,
    Callback = function(v)
        if Window.SetResizable then Window:SetResizable(v) end
    end,
})
Settings:Button({
    Title = "To Center",
    Callback = function()
        if Window.ToCenter then Window:ToCenter() end
    end,
})
Settings:Button({
    Title = "Minimize",
    Callback = function()
        if Window.Minimize then Window:Minimize() end
    end,
})
Settings:Button({
    Title = "Fullscreen",
    Callback = function()
        if Window.ToggleFullscreen then Window:ToggleFullscreen() end
    end,
})
Settings:Button({
    Title = "Destroy",
    Callback = function()
        Window:Destroy()
    end,
})

Settings:Section({ Title = "Config" })
Settings:Button({
    Title = "Save Config",
    Callback = function()
        if Window.SaveConfig then Window:SaveConfig("VoidxHub") end
    end,
})
Settings:Button({
    Title = "Load Config",
    Callback = function()
        if Window.LoadConfig then Window:LoadConfig("VoidxHub") end
    end,
})

print("[VoidxHub] full Void Hub base loaded")
