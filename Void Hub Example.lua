--[[
    Void Hub Library — Example
    Demonstra todas as funções disponíveis da UI.
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
    SideBarWidth = 160,
    Size = UDim2.new(0, 500, 0, 380),
    ToggleKey = Enum.KeyCode.LeftControl,
    AutoScale = true,
    Resizable = true,
    User = {
        Enabled = true,
        Anonymous = false,
    },
    -- KeySystem opcional:
    --[[
    KeySystem = {
        HubName = "Void Hub X",
        Note = "Keyless will be enabled every weekend.",
        Discord = "https://discord.gg/your-invite",
        KeyValidator = function(key)
            return key == "1234"
        end,
    },
    ]]
})

-- Botão de abrir/fechar (minimizado)
Window:EditOpenButton({
    Title = "Open Void Hub",
    Icon = "door-open",
    Transparency = 0.2,
    StrokeThickness = 1,
    AutoRotation = true,
    Speed = 12,
    CornerRadius = UDim.new(1, 0),
})

-- Tag no rodapé
Window:Tag({
    Name = "v1.0",
    Color = Color3.fromRGB(80, 160, 255),
    Icon = "tag",
})

-- Topbar extras
VoidUI:CreateTopbarButton({
    Icon = "bell",
    Order = 1,
    Callback = function()
        VoidUI:Notification({
            Title = "Topbar Button",
            Desc = "Clicou no botão da topbar",
            Icon = "bell",
            Duration = 3,
        })
    end,
})

VoidUI:CreateTopbarToggle({
    EnableIcon = "sun",
    DisableIcon = "moon",
    Default = false,
    Order = 2,
    Callback = function(v)
        print("Topbar toggle:", v)
    end,
})

-- =========================================================
-- TABS / SECTIONS
-- =========================================================
local DisplayTab = Window:Tab({ Title = "Display", Icon = "picture-in-picture", Border = true })
local ControlsTab = Window:Tab({ Title = "Controls", Icon = "sliders-horizontal", Border = true })
local InputTab = Window:Tab({ Title = "Input", Icon = "text-cursor-input", Border = true })
local ExtraTab = Window:Tab({ Title = "Extra", Icon = "sparkles", Border = true })
local GroupTab = Window:Tab({ Title = "Group", Icon = "layout-grid", Border = true })

local OtherSection = Window:Section({ Title = "Other", Icon = "hash", Opened = true })
local SettingsTab = OtherSection:Tab({ Title = "Settings", Icon = "settings", Border = true })

Window:SelectTab(1)

-- =========================================================
-- DISPLAY
-- =========================================================
DisplayTab:Section({ Title = "Text", Icon = "type" })

DisplayTab:Paragraph({
    Title = "Paragraph",
    Desc = "Texto descritivo simples.",
})

DisplayTab:Paragraph({
    Title = "Paragraph com ícone <smile>",
    Desc = "Suporta ícones no título via <nome>",
    Icon = "bird",
})

DisplayTab:Paragraph({
    Title = "Paragraph Thumbnail",
    Desc = "Com imagem em miniatura",
    Thumbnail = "rbxassetid://78903626783621",
    Icon = "image",
})

DisplayTab:Label({ Title = "Label simples" })

DisplayTab:KeyValue({
    Title = "Key / Value",
    Value = "42",
})

DisplayTab:Badge({
    Title = "Badge",
    Text = "NEW",
    Color = Color3.fromRGB(80, 160, 255),
})

DisplayTab:Devider()
DisplayTab:Space(6)

DisplayTab:EmptyState({
    Title = "Nothing here",
    Desc = "Estado vazio de exemplo",
    Icon = "inbox",
})

DisplayTab:Discord({
    Title = "Discord",
    Desc = "Entre no servidor",
    URL = "https://discord.gg/example",
})

-- =========================================================
-- CONTROLS
-- =========================================================
ControlsTab:Section({ Title = "Buttons & Toggles" })

ControlsTab:Button({
    Title = "Button",
    Desc = "Clique para notificar",
    Callback = function()
        VoidUI:Notification({
            Title = "Button",
            Desc = "Clicado!",
            Icon = "check",
            Duration = 2,
        })
    end,
})

ControlsTab:Toggle({
    Title = "Toggle",
    Desc = "Liga / desliga",
    Default = false,
    Callback = function(v)
        print("Toggle:", v)
    end,
})

ControlsTab:Checkbox({
    Title = "Checkbox",
    Default = true,
    Callback = function(v)
        print("Checkbox:", v)
    end,
})

ControlsTab:Radio({
    Title = "Radio",
    Options = { "Alpha", "Beta", "Gamma" },
    Value = "Alpha",
    Callback = function(v)
        print("Radio:", v)
    end,
})

ControlsTab:Section({ Title = "Sliders & Steppers" })

ControlsTab:Slider({
    Title = "Slider",
    Desc = "0 a 100",
    Value = { Min = 0, Max = 100, Default = 40 },
    Step = 1,
    Callback = function(v)
        print("Slider:", v)
    end,
})

ControlsTab:Stepper({
    Title = "Stepper",
    Min = 0,
    Max = 10,
    Step = 1,
    Value = 3,
    Callback = function(v)
        print("Stepper:", v)
    end,
})

ControlsTab:ProgressBar({
    Title = "Progress",
    Value = 0.65,
})

ControlsTab:Section({ Title = "Dropdowns" })

ControlsTab:Dropdown({
    Title = "Dropdown",
    Desc = "Seleção única",
    Multi = false,
    Option = { "Option 1", "Option 2", "Option 3", "Option 4", "Option 5" },
    Value = "Option 1",
    Callback = function(v)
        print("Dropdown:", v)
    end,
})

ControlsTab:Dropdown({
    Title = "Multi Dropdown",
    Desc = "Seleção múltipla",
    Multi = true,
    Option = { "Red", "Green", "Blue", "Yellow", "Purple" },
    Value = {},
    Callback = function(v)
        print("Multi:", table.concat(v, ", "))
    end,
})

ControlsTab:ChipList({
    Title = "Chips",
    Options = { "A", "B", "C", "D" },
    Multi = true,
    Value = { "A" },
    Callback = function(v)
        print("Chips:", v)
    end,
})

ControlsTab:SegmentedControl({
    Title = "Segmented",
    Options = { "Day", "Week", "Month" },
    Value = "Day",
    Callback = function(v)
        print("Segment:", v)
    end,
})

-- =========================================================
-- INPUT
-- =========================================================
InputTab:Section({ Title = "Text & Keys" })

InputTab:Input({
    Title = "Input",
    Desc = "Digite algo",
    Placeholder = "Type here...",
    Callback = function(t)
        print("Input:", t)
    end,
})

InputTab:Input({
    Title = "Input com limite",
    MaxSymbols = 12,
    Placeholder = "Max 12 chars",
    Callback = function(t)
        print("Limited:", t)
    end,
})

InputTab:Keybind({
    Title = "Keybind",
    Callback = function(key)
        print("Keybind:", key)
    end,
})

InputTab:Colorpicker({
    Title = "Colorpicker",
    Default = Color3.fromRGB(80, 160, 255),
    Callback = function(c)
        print("Color:", c)
    end,
})

-- =========================================================
-- EXTRA (componentes avançados)
-- =========================================================
ExtraTab:Section({ Title = "Advanced" })

ExtraTab:Accordion({
    Title = "Accordion",
    Content = "Conteúdo expansível do accordion.",
    Open = false,
    Callback = function(open)
        print("Accordion open:", open)
    end,
})

ExtraTab:Timeline({
    Title = "Timeline",
    Steps = { "Start", "Build", "Test", "Ship" },
    Index = 2,
})

ExtraTab:Viewport({
    Title = "Viewport",
    Image = "rbxassetid://78903626783621",
})

ExtraTab:Path2D({
    Title = "Chart",
    Values = { 0.2, 0.5, 0.35, 0.8, 0.6, 0.9 },
})

ExtraTab:PopupButton({
    Title = "Open Popup",
    PopupTitle = "Popup",
    PopupContent = "Conteúdo do popup / dialog.",
    Callback = function()
        print("Popup OK")
    end,
})

ExtraTab:TabBox({
    Title = "TabBox",
    Tabs = {
        { Title = "A", Content = "Conteúdo da aba A" },
        { Title = "B", Content = "Conteúdo da aba B" },
        { Title = "C", Content = "Conteúdo da aba C" },
    },
})

ExtraTab:Section({ Title = "Notify / Dialog" })

ExtraTab:Button({
    Title = "Notification",
    Callback = function()
        VoidUI:Notification({
            Title = "Hello",
            Desc = "Notificação de exemplo",
            Icon = "info",
            Duration = 4,
        })
    end,
})

ExtraTab:Button({
    Title = "Dialog",
    Callback = function()
        VoidUI:Dialog({
            Title = "Confirm?",
            Desc = "Isso é um dialog de exemplo.",
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

ExtraTab:Button({
    Title = "Tooltip",
    Callback = function()
        Window:ShowTooltip("Tooltip flutuante", 2)
    end,
})

-- =========================================================
-- GROUP (elementos lado a lado)
-- =========================================================
GroupTab:Section({ Title = "Grid Group" })

local g1 = GroupTab:Group({})
g1:Toggle({ Title = "Aimbot", Callback = function(v) print(v) end })
g1:Toggle({ Title = "Trigger", Callback = function(v) print(v) end })

local g2 = GroupTab:Group({})
g2:Toggle({ Title = "A", Callback = function() end })
g2:Toggle({ Title = "B", Callback = function() end })
g2:Toggle({ Title = "C", Callback = function() end })

-- =========================================================
-- SETTINGS (Window API)
-- =========================================================
SettingsTab:Section({ Title = "Theme" })

local themeNames = {}
for name in pairs(Window.Themes or {}) do
    table.insert(themeNames, name)
end
table.sort(themeNames)
if #themeNames == 0 then
    themeNames = { "Dark", "Light", "Pink", "Blue", "Purple", "Green", "Red", "Cyan", "Neon", "Ocean" }
end

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
        Window:SetTransparency(v)
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

SettingsTab:Toggle({
    Title = "Resizable",
    Default = true,
    Callback = function(v)
        Window:SetResizable(v)
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
    Title = "Open / Close",
    Callback = function()
        if Window.IslandOpen then
            Window:Close()
        else
            Window:Open()
        end
    end,
})

SettingsTab:Section({ Title = "User" })

SettingsTab:Toggle({
    Title = "User Enabled",
    Default = true,
    Callback = function(v)
        Window:UserEnabled(v)
    end,
})

SettingsTab:Toggle({
    Title = "Anonymous",
    Default = false,
    Callback = function(v)
        Window:Anonymous(v)
    end,
})

SettingsTab:Section({ Title = "Background" })

SettingsTab:Button({
    Title = "Set Background Color",
    Callback = function()
        Window:SetBackgroundColor(Color3.fromRGB(20, 24, 40))
    end,
})

SettingsTab:Button({
    Title = "Clear Background",
    Callback = function()
        Window:ClearBackground()
    end,
})

SettingsTab:Section({ Title = "Config / Misc" })

SettingsTab:Button({
    Title = "Save Config",
    Callback = function()
        Window:SetConfig("demo", true)
        Window:SaveConfig("VoidHubExample")
    end,
})

SettingsTab:Button({
    Title = "Load Config",
    Callback = function()
        Window:LoadConfig("VoidHubExample")
    end,
})

SettingsTab:Button({
    Title = "Watermark ON",
    Callback = function()
        Window:SetWatermark("Void Hub • Example")
    end,
})

SettingsTab:Button({
    Title = "Watermark OFF",
    Callback = function()
        Window:SetWatermark(false)
    end,
})

SettingsTab:Dropdown({
    Title = "Language",
    Option = { "English", "Português", "Español", "Français", "Deutsch", "Русский", "日本語", "中文" },
    Value = "English",
    Callback = function(v)
        Window:SetLanguage(v)
    end,
})

SettingsTab:Button({
    Title = "Lock All",
    Callback = function()
        Window:LockAll()
    end,
})

SettingsTab:Button({
    Title = "Unlock All",
    Callback = function()
        Window:UnlockAll()
    end,
})

SettingsTab:Button({
    Title = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end,
})

-- Loading screen de exemplo (opcional — fecha sozinho)
--[[
local loading = VoidUI:LoadingScreen({
    Title = "Void Hub",
    Desc = "Loading modules...",
})
loading:SetProgress(0.3)
task.wait(0.4)
loading:SetProgress(0.7)
loading:SetStatus("Almost done...")
task.wait(0.4)
loading:SetProgress(1)
loading:Close(0.3)
]]

print("[Void Hub Example] Loaded — pressione LeftControl para abrir/fechar")
