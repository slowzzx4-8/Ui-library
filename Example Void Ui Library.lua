--[[
    Example Void Ui Library.lua
    Todas as funções disponíveis + Confirm Modal, Stats/Profile, cores de texto/ícone
    Tema: Black | Open button: quadrado preto (esquerda, móvel)
]]

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Ui%20Library.lua"))()

-- =================
-- CreateWindow
-- =================
local Window = VoidUI:CreateWindow({
    Name = "Void Ui Example",
    Author = "By Slowzzx4",
    Icon = "layout-dashboard",
    Theme = "Black",
    Transparent = false,
    SideBarWidth = 170,
    ToggleKey = Enum.KeyCode.F,
    Resizable = true,
    AutoScale = true,
    User = {
        Enabled = true,
        Anonymous = false,
    },
})

-- =================
-- EditOpenButton (quadrado preto, lado esquerdo, móvel)
-- =================
Window:EditOpenButton({
    Icon = "layout-dashboard",
    Size = UDim2.new(0, 48, 0, 48),
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 1.2,
    BorderColor = Color3.fromRGB(40, 40, 40),
})

-- =================
-- Tag
-- =================
Window:Tag({
    Name = "v2.0",
    Color = Color3.fromRGB(220, 50, 55),
})

-- =================
-- 12 Abas (todas as funções)
-- =================
local Tab1  = Window:Tab({ Title = "Display",      Icon = "picture-in-picture", Border = true })
local Tab2  = Window:Tab({ Title = "Buttons",      Icon = "mouse-pointer-click", Border = true })
local Tab3  = Window:Tab({ Title = "Toggles",      Icon = "toggle-left", Border = true })
local Tab4  = Window:Tab({ Title = "Sliders",      Icon = "sliders-horizontal", Border = true })
local Tab5  = Window:Tab({ Title = "Dropdowns",    Icon = "chevrons-up-down", Border = true })
local Tab6  = Window:Tab({ Title = "Inputs",       Icon = "text-cursor-input", Border = true })
local Tab7  = Window:Tab({ Title = "Stats",        Icon = "user", Border = true })
local Tab8  = Window:Tab({ Title = "Confirm",      Icon = "shield-alert", Border = true })
local Tab9  = Window:Tab({ Title = "Advanced",     Icon = "layers", Border = true })
local Tab10 = Window:Tab({ Title = "Notify",       Icon = "bell", Border = true })
local Tab11 = Window:Tab({ Title = "Locked",       Icon = "lock-keyhole", Border = true })
local Tab12 = Window:Tab({ Title = "Settings",     Icon = "settings", Border = true })

Window:SelectTab(1)

-- ############################################################################
-- ABA 1 — Display
-- ############################################################################

-- =================
-- Section
-- =================
Tab1:Section({ Title = "Section", Icon = "hash" })

-- =================
-- Paragraph
-- =================
Tab1:Paragraph({
    Title = "Paragraph",
    Desc = "Descrição simples de um parágrafo.",
})

-- =================
-- Paragraph [ Icon + cores na linha ]
-- =================
Tab1:Paragraph({
    Title = "Texto <c:#ff4d6d>vermelho</c> e <c:#4ade80>verde</c> <smile>",
    Desc = "Use <c:#60a5fa>tags de cor</c> e ícones <star> na mesma linha.",
    Icon = "palette",
})

-- =================
-- Paragraph [ Thumbnail ]
-- =================
Tab1:Paragraph({
    Title = "Paragraph Thumbnail",
    Desc = "Com imagem de capa.",
    Thumbnail = "rbxassetid://78903626783621",
    Icon = "image",
})

Tab1:Devider()
Tab1:Space(6)

-- =================
-- Label
-- =================
Tab1:Label({ Title = "Label simples" })

-- =================
-- Badge
-- =================
Tab1:Badge({ Title = "Badge", Color = Color3.fromRGB(220, 50, 55) })

-- =================
-- KeyValue
-- =================
Tab1:KeyValue({
    Title = "Ping",
    Value = "32 ms",
})

-- =================
-- EmptyState
-- =================
Tab1:EmptyState({
    Title = "Empty State",
    Desc = "Nada por aqui ainda.",
    Icon = "inbox",
})

-- ############################################################################
-- ABA 2 — Buttons
-- ############################################################################

-- =================
-- Button
-- =================
Tab2:Section({ Title = "Button", Icon = "mouse-pointer-click" })
Tab2:Button({
    Title = "Button",
    Desc = "Clique para print no console",
    Callback = function()
        print("[Button] clicked")
    end,
})

-- =================
-- Button [ com ícone no título ]
-- =================
Tab2:Button({
    Title = "Button Icon <bird>",
    Desc = "Ícone inline no título",
    Callback = function()
        print("[Button Icon] ok")
    end,
})

-- =================
-- PopupButton
-- =================
Tab2:PopupButton({
    Title = "Popup Button",
    Desc = "Abre um popup",
    Callback = function()
        Window:Popup({
            Title = "Popup",
            Content = "Conteúdo do popup.",
            Buttons = {
                { Title = "OK", Callback = function() print("OK") end },
            },
        })
    end,
})

-- ############################################################################
-- ABA 3 — Toggles (+ Confirm)
-- ############################################################################

-- =================
-- Toggle
-- =================
Tab3:Section({ Title = "Toggle", Icon = "toggle-left" })
Tab3:Toggle({
    Title = "Toggle simples",
    Desc = "Sem confirmação",
    Default = false,
    Callback = function(Value)
        print("[Toggle]", Value)
    end,
})

-- =================
-- Toggle [ Confirm ]
-- =================
Tab3:Toggle({
    Title = "Auto Hop",
    Desc = "Pede confirmação ao ativar",
    Default = false,
    Confirm = {
        Title = "Auto Hop",
        Warning = "WARNING",
        Desc = "Auto Hop keeps joining new servers to find eggs that match its filters. Turn it off to stop.",
        Note = '"Steal Then Hop" and "After A Rare Spawns" stop at night.',
        CancelText = "Cancel",
        ConfirmText = "Turn On",
    },
    Callback = function(Value)
        print("[Auto Hop]", Value)
    end,
})

-- =================
-- Toggle [ Confirm custom ]
-- =================
Tab3:Toggle({
    Title = "Farm Gold",
    Desc = "Confirm custom texts",
    Default = false,
    Confirm = {
        Title = "Farm Gold",
        Warning = "WARNING",
        Desc = "This will start farming gold automatically.",
        Note = "Works only while you are in the lobby.",
        CancelText = "Cancel",
        ConfirmText = "Start",
    },
    Callback = function(Value)
        print("[Farm Gold]", Value)
    end,
})

-- =================
-- Checkbox
-- =================
Tab3:Section({ Title = "Checkbox", Icon = "check-square" })
Tab3:Checkbox({
    Title = "Checkbox",
    Default = false,
    Callback = function(v)
        print("[Checkbox]", v)
    end,
})

-- =================
-- Radio
-- =================
Tab3:Section({ Title = "Radio", Icon = "circle-dot" })
Tab3:Radio({
    Title = "Radio",
    Option = { "Easy", "Normal", "Hard" },
    Value = "Normal",
    Callback = function(v)
        print("[Radio]", v)
    end,
})

-- ############################################################################
-- ABA 4 — Sliders / Progress
-- ############################################################################

-- =================
-- Slider
-- =================
Tab4:Section({ Title = "Slider", Icon = "sliders-horizontal" })
Tab4:Slider({
    Title = "Slider",
    Desc = "0 — 100",
    Value = { Min = 0, Max = 100, Default = 25 },
    Step = 1,
    Callback = function(Value)
        print("[Slider]", Value)
    end,
})

Tab4:Slider({
    Title = "WalkSpeed",
    Desc = "16 — 200",
    Value = { Min = 16, Max = 200, Default = 16 },
    Step = 1,
    Callback = function(Value)
        print("[WalkSpeed]", Value)
    end,
})

-- =================
-- ProgressBar
-- =================
Tab4:Section({ Title = "ProgressBar", Icon = "loader" })
Tab4:ProgressBar({
    Title = "Progress",
    Value = 0.35,
})

-- ############################################################################
-- ABA 5 — Dropdowns
-- ############################################################################

-- =================
-- Dropdown [ Single ]
-- =================
Tab5:Section({ Title = "Dropdown Single", Icon = "chevrons-up-down" })
Tab5:Dropdown({
    Title = "Dropdown",
    Desc = "Seleção única",
    Multi = false,
    Option = {
        "Option 1", "Option 2", "Option 3", "Option 4", "Option 5",
        "Option 6", "Option 7", "Option 8", "Option 9", "Option 10",
    },
    Value = "Option 1",
    Callback = function(Value)
        print("[Dropdown]", Value)
    end,
})

-- =================
-- Dropdown [ Multi ]
-- =================
Tab5:Section({ Title = "Dropdown Multi", Icon = "list-checks" })
Tab5:Dropdown({
    Title = "Multi Dropdown",
    Desc = "Seleção múltipla",
    Multi = true,
    Option = { "A", "B", "C", "D", "E", "F", "G" },
    Value = { "A", "C" },
    Callback = function(Value)
        if type(Value) == "table" then
            print("[Multi]", table.concat(Value, ", "))
        else
            print("[Multi]", Value)
        end
    end,
})

-- =================
-- ChipList
-- =================
Tab5:Section({ Title = "ChipList", Icon = "tags" })
Tab5:ChipList({
    Title = "Chips",
    Options = { "Pvp", "Farm", "Trade", "Quest" },
    Value = { "Farm" },
    Multi = true,
    Callback = function(Value)
        print("[Chips]", Value)
    end,
})

-- =================
-- SegmentedControl
-- =================
Tab5:Section({ Title = "SegmentedControl", Icon = "columns-2" })
Tab5:SegmentedControl({
    Title = "Mode",
    Options = { "Day", "Night", "Auto" },
    Value = "Auto",
    Callback = function(Value)
        print("[Segment]", Value)
    end,
})

-- ############################################################################
-- ABA 6 — Inputs / Keybind / Colorpicker
-- ############################################################################

-- =================
-- Input
-- =================
Tab6:Section({ Title = "Input", Icon = "text-cursor-input" })
Tab6:Input({
    Title = "Input",
    Desc = "Digite algo",
    Callback = function(text)
        print("[Input]", text)
    end,
})

-- =================
-- Input [ MaxSymbols ]
-- =================
Tab6:Input({
    Title = "Input Limit",
    MaxSymbols = 12,
    Desc = "Máximo 12 caracteres",
    Callback = function(text)
        print("[Input Limit]", text)
    end,
})

-- =================
-- Keybind
-- =================
Tab6:Section({ Title = "Keybind", Icon = "keyboard" })
Tab6:Keybind({
    Title = "Keybind",
    Callback = function(key)
        print("[Keybind]", key)
    end,
})

-- =================
-- Colorpicker
-- =================
Tab6:Section({ Title = "Colorpicker", Icon = "pipette" })
Tab6:Colorpicker({
    Title = "Colorpicker",
    Desc = "Escolha uma cor",
    Default = Color3.fromRGB(220, 50, 55),
    Callback = function(color)
        print("[Color]", color)
    end,
})

-- ############################################################################
-- ABA 7 — Stats / Profile / Stat Rows
-- ############################################################################

-- =================
-- Stats Frame / Player Stats
-- =================
Tab7:Section({ Title = "Player Stats", Icon = "user" })
local Stats = Tab7:StatsFrame({
    Title = "Player Stats",
    Desc = "Informações do jogador",
    Icon = "user",
    Rows = {
        {
            Label = "Username",
            Value = "Player1",
            Icon = "user",
            ValueColor = Color3.fromRGB(96, 165, 250),
        },
        {
            Label = "Level",
            Value = "42",
            Icon = "star",
            LabelColor = Color3.fromRGB(250, 204, 21),
            ValueColor = Color3.fromRGB(250, 204, 21),
        },
        {
            Label = "Cash",
            Value = "$12,500",
            Icon = "coins",
            ValueColor = Color3.fromRGB(74, 222, 128),
        },
        {
            Label = "Kills",
            Value = "128",
            Icon = "swords",
            ValueColor = Color3.fromRGB(248, 113, 113),
        },
        {
            Label = "Deaths",
            Value = "34",
            Icon = "skull",
            ValueColor = Color3.fromRGB(161, 161, 170),
        },
    },
})

Tab7:Button({
    Title = "Update Level +1",
    Callback = function()
        Stats:SetRow(2, "43")
    end,
})

Tab7:Button({
    Title = "Add Row Wins",
    Callback = function()
        Stats:AddRow({
            Label = "Wins",
            Value = "10",
            Icon = "trophy",
            ValueColor = Color3.fromRGB(250, 204, 21),
        })
    end,
})

-- =================
-- Profile Frame
-- =================
Tab7:Section({ Title = "Profile Frame", Icon = "circle-user" })
Tab7:ProfileFrame({
    Title = "Profile",
    Rows = {
        {
            Label = "Status",
            Value = "Online",
            Icon = "circle",
            ValueColor = Color3.fromRGB(74, 222, 128),
        },
        {
            Label = "Server",
            Value = "US-East",
            Icon = "server",
            ValueColor = Color3.fromRGB(165, 180, 252),
        },
        {
            Label = "Role",
            Value = "Admin",
            Icon = "shield",
            ValueColor = Color3.fromRGB(251, 113, 133),
        },
    },
})

-- =================
-- Stat Rows
-- =================
Tab7:Section({ Title = "Stat Rows", Icon = "list" })
Tab7:StatRows({
    Title = "Match Stats",
    Rows = {
        { Label = "Damage", Value = "9,402", Icon = "flame", ValueColor = Color3.fromRGB(251, 146, 60) },
        { Label = "Healing", Value = "2,110", Icon = "heart", ValueColor = Color3.fromRGB(244, 114, 182) },
    },
})

-- ############################################################################
-- ABA 8 — Confirm Modal / Dialog
-- ############################################################################

-- =================
-- Confirmation Modal
-- =================
Tab8:Section({ Title = "Confirmation Modal", Icon = "shield-alert" })
Tab8:Paragraph({
    Title = "Como usar",
    Desc = "O modal aparece no centro da UI, a janela não se move. Ideal para toggles perigosos.",
})

Tab8:Button({
    Title = "Confirm (igual imagem Auto Hop)",
    Desc = "Cancel + Turn On",
    Callback = function()
        Window:Confirm({
            Title = "Auto Hop",
            Warning = "WARNING",
            Desc = "Auto Hop keeps joining new servers to find eggs that match its filters. Turn it off to stop.",
            Note = '"Steal Then Hop" and "After A Rare Spawns" stop at night.',
            CancelText = "Cancel",
            ConfirmText = "Turn On",
            OnCancel = function()
                print("[Confirm] Cancel")
            end,
            OnConfirm = function()
                print("[Confirm] Turn On")
            end,
        })
    end,
})

-- =================
-- Dialog [ custom buttons ]
-- =================
Tab8:Button({
    Title = "Dialog 3 botões",
    Callback = function()
        Window:Dialog({
            Title = "Custom Dialog",
            Desc = "Escolha uma opção.",
            Note = "Você controla os textos e callbacks.",
            Buttons = {
                { Text = "No", Style = "Cancel", Callback = function() print("No") end },
                { Text = "Maybe", Style = "Cancel", Callback = function() print("Maybe") end },
                { Text = "Yes", Style = "Confirm", Callback = function() print("Yes") end },
            },
        })
    end,
})

-- =================
-- Dialog [ destroy style ]
-- =================
Tab8:Button({
    Title = "Dialog Destroy style",
    Callback = function()
        Window:Dialog({
            Title = "Close UI?",
            Desc = "Are you sure you want to destroy this window?",
            Buttons = {
                { Text = "Cancel", Style = "Cancel", Callback = function() end },
                {
                    Text = "Destroy",
                    Style = "Confirm",
                    Callback = function()
                        print("[Dialog] Destroy confirmed (não destruiu no example)")
                    end,
                },
            },
        })
    end,
})

-- ############################################################################
-- ABA 9 — Advanced
-- ############################################################################

-- =================
-- Group
-- =================
Tab9:Section({ Title = "Group", Icon = "layout-grid" })
local g1 = Tab9:Group({})
g1:Toggle({ Title = "Aimbot", Callback = function(v) print("[Aimbot]", v) end })
g1:Toggle({ Title = "Triggerbot", Callback = function(v) print("[Trigger]", v) end })

local g2 = Tab9:Group({})
g2:Toggle({ Title = "ESP", Callback = function(v) print("[ESP]", v) end })
g2:Toggle({ Title = "Box", Callback = function(v) print("[Box]", v) end })
g2:Toggle({ Title = "Name", Callback = function(v) print("[Name]", v) end })

-- =================
-- Accordion
-- =================
Tab9:Section({ Title = "Accordion", Icon = "chevrons-down-up" })
Tab9:Accordion({
    Title = "Accordion",
    Open = true,
    Content = "Conteúdo expansível do accordion.",
})

-- =================
-- Timeline
-- =================
Tab9:Section({ Title = "Timeline", Icon = "git-commit-horizontal" })
Tab9:Timeline({
    Title = "Updates",
    Items = {
        { Title = "v2.0", Desc = "Confirm modal + Stats" },
        { Title = "v1.5", Desc = "Open button quadrado" },
        { Title = "v1.0", Desc = "Release" },
    },
})

-- =================
-- Stepper
-- =================
Tab9:Section({ Title = "Stepper", Icon = "list-ordered" })
Tab9:Stepper({
    Title = "Setup",
    Steps = { "Account", "Key", "Finish" },
    Value = 1,
    Callback = function(step)
        print("[Stepper]", step)
    end,
})

-- =================
-- TabBox
-- =================
Tab9:Section({ Title = "TabBox", Icon = "folder" })
Tab9:TabBox({
    Title = "TabBox",
    Tabs = { "One", "Two", "Three" },
    Callback = function(name)
        print("[TabBox]", name)
    end,
})

-- =================
-- Discord
-- =================
Tab9:Section({ Title = "Discord", Icon = "message-circle" })
Tab9:Discord({
    Title = "Join Discord",
    Desc = "Comunidade Void Ui",
    URL = "https://discord.gg/example",
})

-- =================
-- Viewport / Path2D
-- =================
pcall(function()
    Tab9:Section({ Title = "Viewport / Path2D", Icon = "box" })
    Tab9:Viewport({ Title = "Viewport" })
    Tab9:Path2D({ Title = "Path2D" })
end)

-- ############################################################################
-- ABA 10 — Notifications / Tooltip
-- ############################################################################

-- =================
-- Notification
-- =================
Tab10:Section({ Title = "Notification", Icon = "bell" })
Tab10:Button({
    Title = "Notification com ícone",
    Callback = function()
        VoidUI:Notification({
            Title = "Title",
            Icon = "bell",
            Desc = "Descrição da notificação",
            Duration = 4,
        })
    end,
})

Tab10:Button({
    Title = "Window:Notify",
    Callback = function()
        Window:Notify({
            Title = "Notify",
            Content = "Via Window:Notify",
            Duration = 3,
        })
    end,
})

-- =================
-- Tooltip
-- =================
Tab10:Section({ Title = "Tooltip", Icon = "message-square" })
Tab10:Button({
    Title = "Show Tooltip",
    Callback = function()
        Window:ShowTooltip("Tooltip flutuante no topo", 2.5)
    end,
})

-- ############################################################################
-- ABA 11 — Locked elements
-- ############################################################################

-- =================
-- Locked Elements
-- =================
Tab11:Section({ Title = "Locked", Icon = "lock-keyhole" })

local LockBtn = Tab11:Button({
    Title = "Button locked",
    Locked = true,
    Callback = function()
        print("locked btn")
    end,
})

local LockTog = Tab11:Toggle({
    Title = "Toggle locked",
    Locked = true,
    Callback = function(v)
        print(v)
    end,
})

local LockSlider = Tab11:Slider({
    Title = "Slider locked",
    Locked = true,
    Value = { Min = 0, Max = 100, Default = 50 },
    Step = 1,
    Callback = function(v)
        print(v)
    end,
})

local LockDrop = Tab11:Dropdown({
    Title = "Dropdown locked",
    Locked = true,
    Multi = false,
    Option = { "A", "B", "C" },
    Value = "A",
    Callback = function(v)
        print(v)
    end,
})

Tab11:Toggle({
    Title = "Lock / Unlock all above",
    Default = true,
    Callback = function(Value)
        if Value then
            LockBtn:Lock()
            LockTog:Lock()
            LockSlider:Lock()
            LockDrop:Lock()
        else
            LockBtn:UnLock()
            LockTog:UnLock()
            LockSlider:UnLock()
            LockDrop:UnLock()
        end
    end,
})

Tab11:Button({
    Title = "Window:LockAll",
    Callback = function()
        Window:LockAll()
    end,
})
Tab11:Button({
    Title = "Window:UnlockAll",
    Callback = function()
        Window:UnlockAll()
    end,
})

-- ############################################################################
-- ABA 12 — Settings (Window API)
-- ############################################################################

-- =================
-- Theme / Text & Icon colors
-- =================
Tab12:Section({ Title = "Colors", Icon = "palette" })
Tab12:Paragraph({
    Title = "Tema Black",
    Desc = "Único tema. Personalize só letras e ícones.",
})

Tab12:Button({
    Title = "Text color azul",
    Callback = function()
        Window:SetTextColor("#60a5fa")
    end,
})
Tab12:Button({
    Title = "Icon color verde",
    Callback = function()
        Window:SetIconColor("#4ade80")
    end,
})
Tab12:Button({
    Title = "Reset cores",
    Callback = function()
        Window:SetTextColor("#FFFFFF")
        Window:SetIconColor("#c8c8c8")
    end,
})

-- =================
-- Window options
-- =================
Tab12:Section({ Title = "Window", Icon = "app-window" })
Tab12:Toggle({
    Title = "Transparent",
    Callback = function(Value)
        Window:SetTransparency(Value)
    end,
})
Tab12:Toggle({
    Title = "Acrylic",
    Callback = function(Value)
        Window:ToggleAcrylic(Value)
    end,
})
Tab12:Toggle({
    Title = "Resizing",
    Default = true,
    Callback = function(Value)
        Window:SetResizable(Value)
    end,
})
Tab12:Keybind({
    Title = "Toggle Key (default F)",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end,
})

local sizeX, sizeY = 480, 360
Tab12:Slider({
    Title = "Width",
    Value = { Min = 410, Max = 700, Default = 480 },
    Step = 1,
    Callback = function(v) sizeX = v end,
})
Tab12:Slider({
    Title = "Height",
    Value = { Min = 280, Max = 700, Default = 360 },
    Step = 1,
    Callback = function(v) sizeY = v end,
})
Tab12:Button({
    Title = "Apply Size",
    Callback = function()
        Window:Resize(sizeX, sizeY)
    end,
})

-- =================
-- User
-- =================
Tab12:Section({ Title = "User", Icon = "circle-user" })
Tab12:Toggle({
    Title = "User Enabled",
    Default = true,
    Callback = function(Value)
        Window:UserEnabled(Value)
    end,
})
Tab12:Toggle({
    Title = "Anonymous",
    Callback = function(Value)
        Window:Anonymous(Value)
    end,
})

-- =================
-- Watermark / Center / Fullscreen / Config
-- =================
Tab12:Section({ Title = "Extras", Icon = "sparkles" })
Tab12:Button({
    Title = "To Center",
    Callback = function()
        Window:ToCenter()
    end,
})
Tab12:Button({
    Title = "Fullscreen",
    Callback = function()
        Window:ToggleFullscreen()
    end,
})
Tab12:Button({
    Title = "Set Watermark",
    Callback = function()
        Window:SetWatermark("Void Ui • Example")
    end,
})
Tab12:Button({
    Title = "Toggle Watermark",
    Callback = function()
        Window:ToggleWatermark(true)
    end,
})
Tab12:Button({
    Title = "Save Config",
    Callback = function()
        Window:SetConfig("demo", true)
        Window:SaveConfig("VoidUiExample")
    end,
})
Tab12:Button({
    Title = "Load Config",
    Callback = function()
        Window:LoadConfig("VoidUiExample")
    end,
})
Tab12:Dropdown({
    Title = "Language",
    Option = { "English", "Português", "Español", "Français", "Deutsch" },
    Value = "English",
    Callback = function(lang)
        Window:SetLanguage(lang)
    end,
})

Tab12:Section({ Title = "Danger", Icon = "triangle-alert" })
Tab12:Button({
    Title = "Destroy UI",
    Callback = function()
        Window:Confirm({
            Title = "Destroy UI",
            Warning = "WARNING",
            Desc = "This will destroy the entire interface.",
            CancelText = "Cancel",
            ConfirmText = "Destroy",
            OnConfirm = function()
                Window:Destroy()
            end,
        })
    end,
})

-- =================
-- Topbar extras
-- =================
pcall(function()
    VoidUI:CreateTopbarButton({
        Order = 4,
        Icon = "bird",
        Callback = function()
            print("[Topbar Button]")
        end,
    })
    VoidUI:CreateTopbarToggle({
        Order = 5,
        EnableIcon = "eye",
        DisableIcon = "eye-off",
        Callback = function(Value)
            print("[Topbar Toggle]", Value)
        end,
    })
end)

print("[Void Ui Example] Loaded — F para abrir/fechar | arraste o quadrado preto na esquerda")
