--[[
    Void Hub Library — Example
    Demonstra as funções principais da UI.

    Carrega a library do GitHub. Para testar local, troque o loadstring
    pelo arquivo Void Hub Library.lua que você baixou.
]]

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()

-- =========================================================
-- WINDOW
-- =========================================================
local Window = VoidUI:CreateWindow({
    Name = "Void Hub Example",
    Author = "By Slowzzx4",
    Icon = "door-open",
    Theme = "Dark",
    Transparent = false,
    SideBarWidth = 150,
    Size = UDim2.new(0, 520, 0, 400),
    ToggleKey = Enum.KeyCode.LeftControl,
    AutoScale = false, -- evita UI "sumir" em telas pequenas
    Resizable = true,
    User = {
        Enabled = true,
        Anonymous = false,
    },
})

-- Botão open/close (quadrado preto, lado direito)
Window:EditOpenButton({
    Icon = "door-open",
    Size = 44,
    CornerRadius = UDim.new(0, 10),
    Transparency = 0.05,
})

Window:Tag({
    Name = "v1.0",
    Color = Color3.fromRGB(80, 160, 255),
})

-- =========================================================
-- TABS
-- =========================================================
local MainTab = Window:Tab({ Title = "Main", Icon = "home", Border = true })
local ControlsTab = Window:Tab({ Title = "Controls", Icon = "sliders-horizontal", Border = true })
local InputTab = Window:Tab({ Title = "Input", Icon = "text-cursor-input", Border = true })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings", Border = true })

-- Seleciona a primeira aba (mostra o conteúdo)
Window:SelectTab(1)

-- =========================================================
-- MAIN
-- =========================================================
MainTab:Section({ Title = "Welcome" })

MainTab:Paragraph({
    Title = "Void Hub Library",
    Desc = "Example com componentes principais. Use a sidebar para trocar de aba.",
})

MainTab:Label({ Title = "Status: Online" })

MainTab:Button({
    Title = "Test Notification",
    Desc = "Clique para notificar",
    Callback = function()
        VoidUI:Notification({
            Title = "Void Hub",
            Desc = "Funcionando!",
            Icon = "check",
            Duration = 3,
        })
    end,
})

MainTab:Button({
    Title = "Test Dialog",
    Callback = function()
        VoidUI:Dialog({
            Title = "Confirm?",
            Desc = "Dialog de exemplo.",
            Buttons = {
                { Text = "Cancel", Callback = function() end },
                {
                    Text = "OK",
                    Callback = function()
                        VoidUI:Notification({ Title = "OK", Duration = 2 })
                    end,
                },
            },
        })
    end,
})

MainTab:Discord({
    Title = "Discord",
    Desc = "Join the community",
    URL = "https://discord.gg/example",
})

-- =========================================================
-- CONTROLS
-- =========================================================
ControlsTab:Section({ Title = "Toggles & Buttons" })

ControlsTab:Toggle({
    Title = "Enable Feature",
    Desc = "Liga / desliga",
    Default = false,
    Callback = function(v)
        print("Toggle:", v)
    end,
})

ControlsTab:Checkbox({
    Title = "Accept Terms",
    Default = true,
    Callback = function(v)
        print("Checkbox:", v)
    end,
})

ControlsTab:Slider({
    Title = "Volume",
    Desc = "0 — 100",
    Value = { Min = 0, Max = 100, Default = 50 },
    Step = 1,
    Callback = function(v)
        print("Slider:", v)
    end,
})

ControlsTab:Stepper({
    Title = "Amount",
    Min = 0,
    Max = 10,
    Step = 1,
    Value = 2,
    Callback = function(v)
        print("Stepper:", v)
    end,
})

ControlsTab:Section({ Title = "Dropdowns" })

ControlsTab:Dropdown({
    Title = "Single Dropdown",
    Desc = "Escolha uma opção",
    Multi = false,
    Option = { "Apple", "Banana", "Cherry", "Dragonfruit", "Elderberry" },
    Value = "Apple",
    Callback = function(v)
        print("Dropdown:", v)
    end,
})

ControlsTab:Dropdown({
    Title = "Multi Dropdown",
    Desc = "Várias opções",
    Multi = true,
    Option = { "Red", "Green", "Blue", "Yellow" },
    Value = { "Red" },
    Callback = function(v)
        print("Multi:", table.concat(v, ", "))
    end,
})

ControlsTab:SegmentedControl({
    Title = "View Mode",
    Options = { "Day", "Week", "Month" },
    Value = "Day",
    Callback = function(v)
        print("Segment:", v)
    end,
})

-- =========================================================
-- INPUT
-- =========================================================
InputTab:Section({ Title = "Fields" })

InputTab:Input({
    Title = "Username",
    Placeholder = "Type here...",
    Callback = function(t)
        print("Input:", t)
    end,
})

InputTab:Keybind({
    Title = "Hotkey",
    Callback = function(key)
        print("Key:", key)
    end,
})

InputTab:Colorpicker({
    Title = "Accent Color",
    Default = Color3.fromRGB(80, 160, 255),
    Callback = function(c)
        print("Color:", c)
    end,
})

-- =========================================================
-- SETTINGS
-- =========================================================
SettingsTab:Section({ Title = "Appearance" })

local themeNames = { "Dark", "Light", "Pink", "Blue", "Purple", "Green", "Red", "Cyan", "Neon", "Ocean", "Midnight" }

SettingsTab:Dropdown({
    Title = "Theme",
    Option = themeNames,
    Value = "Dark",
    Callback = function(v)
        Window:SetTheme(v)
        VoidUI:Notification({ Title = "Theme", Desc = tostring(v), Duration = 2 })
    end,
})

SettingsTab:Toggle({
    Title = "Transparent",
    Default = false,
    Callback = function(v)
        Window:SetTransparency(v and 0.15 or 0)
    end,
})

SettingsTab:Toggle({
    Title = "Acrylic",
    Default = false,
    Callback = function(v)
        Window:ToggleAcrylic(v)
    end,
})

SettingsTab:Section({ Title = "Window" })

SettingsTab:Button({
    Title = "To Center",
    Callback = function()
        Window:ToCenter()
    end,
})

SettingsTab:Button({
    Title = "Fullscreen",
    Callback = function()
        Window:ToggleFullscreen()
    end,
})

SettingsTab:Button({
    Title = "Minimize",
    Callback = function()
        Window:Close()
    end,
})

SettingsTab:Keybind({
    Title = "Toggle Key",
    Callback = function(key)
        if Enum.KeyCode[key] then
            Window:SetToggleKey(Enum.KeyCode[key])
        end
    end,
})

SettingsTab:Section({ Title = "Danger" })

SettingsTab:Button({
    Title = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end,
})

-- Garante conteúdo visível após tudo criar
task.defer(function()
    Window:SelectTab(1)
end)

print("[Void Hub Example] Loaded — LeftControl para abrir/fechar")
