--[[
    Void Ui — Example / Test Script
    Usa as funções disponíveis da biblioteca para validar a UI.
    Substitua o loadstring pela sua URL ou cole o return da lib localmente.
]]

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Ui%20Library.lua"))()
-- Se estiver testando local (Synapse/Script-Ware etc com readfile):
-- local VoidUI = loadstring(readfile("Void Ui Library.lua"))()

-- ========== LOADING (opcional) ==========
local Loading = VoidUI:LoadingScreen({
    Title = "Void Ui",
    Desc = "Carregando interface...",
    Icon = "loader",
})
Loading:SetProgress(0.25)
Loading:SetStatus("Preparando janela...")
task.wait(0.3)
Loading:SetProgress(0.7)
Loading:SetStatus("Quase pronto...")
task.wait(0.2)
Loading:SetProgress(1)
Loading:Close(0.15)

-- ========== WINDOW ==========
local Window = VoidUI:CreateWindow({
    Name = "Void Ui",
    Author = "By Test",
    Icon = "layout-dashboard",
    Theme = "Dark",
    Transparent = false,
    SideBarWidth = 160,
    Size = UDim2.new(0, 520, 0, 380),
    ToggleKey = Enum.KeyCode.RightControl,
    Resizable = true,
    AutoScale = true,
    User = {
        Enabled = true,
        Anonymous = false,
    },
    -- KeySystem = { ... } -- descomente se quiser testar key
})

Window:EditOpenButton({
    Title = "Open Void Ui",
    Icon = "layout-dashboard",
    Transparency = 0.2,
    StrokeThickness = 1,
    AutoRotation = true,
    Speed = 12,
    CornerRadius = UDim.new(0, 16),
})

Window:Tag({
    Name = "v1.0 Test",
    Color = Color3.fromRGB(80, 160, 255),
})

Window:SetWatermark("Void Ui • Test Mode")
Window:ShowTooltip("Interface carregada!", 2)

-- Topbar extras
VoidUI:CreateTopbarButton({
    Icon = "bell",
    Order = 1,
    Callback = function()
        VoidUI:Notification({
            Title = "Topbar",
            Desc = "Botão do topbar clicado",
            Icon = "bell",
            Duration = 3,
        })
    end,
})

VoidUI:CreateTopbarToggle({
    Icon = "moon",
    EnableIcon = "sun",
    DisableIcon = "moon",
    Order = 2,
    Default = false,
    Callback = function(v)
        print("[TopbarToggle]", v)
    end,
})

-- ========== TABS ==========
local Home = Window:Tab({ Title = "Home", Icon = "home", Border = true })
local Controls = Window:Tab({ Title = "Controls", Icon = "sliders-horizontal", Border = true })
local Inputs = Window:Tab({ Title = "Inputs", Icon = "text-cursor-input", Border = true })
local Extra = Window:Tab({ Title = "Extra", Icon = "sparkles", Border = true })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings", Border = true })

-- Abre sempre na primeira aba ao executar
Window:SelectTab(1)

-- ========== HOME ==========
Home:Section({ Title = "Welcome", Icon = "hand" })
Home:Paragraph({
    Title = "Void Ui Test",
    Desc = "Script de exemplo com os componentes principais. Minimize (botão −) e reabra: a aba selecionada deve ser mantida.",
    Icon = "info",
})
Home:Devider()
Home:Paragraph({
    Title = "Paragraph colorido",
    Desc = "Exemplo com cor custom",
    Color = "Cyan",
})
Home:EmptyState({
    Title = "Área vazia",
    Desc = "Exemplo de EmptyState",
    Icon = "inbox",
})
Home:Discord({
    Title = "Discord",
    Desc = "Entre no servidor",
    URL = "https://discord.gg/exemplo",
})

-- ========== CONTROLS ==========
Controls:Section({ Title = "Ações" })
Controls:Button({
    Title = "Botão simples",
    Desc = "Clique para notificar",
    Callback = function()
        VoidUI:Notification({
            Title = "Button",
            Desc = "Callback OK",
            Icon = "check",
            Duration = 2,
        })
    end,
})

Controls:Button({
    Title = "Dialog de confirmação",
    Desc = "Abre UI:Dialog",
    Callback = function()
        VoidUI:Dialog({
            Title = "Confirmar?",
            Desc = "Isso é só um teste de dialog.",
            Buttons = {
                { Text = "Cancelar", Callback = function() end },
                {
                    Text = "OK",
                    Callback = function()
                        VoidUI:Notification({ Title = "Dialog", Desc = "Confirmado", Duration = 2 })
                    end,
                },
            },
        })
    end,
})

Controls:Toggle({
    Title = "Toggle",
    Desc = "Liga / desliga",
    Default = false,
    Callback = function(v)
        print("[Toggle]", v)
    end,
})

Controls:Slider({
    Title = "Slider",
    Desc = "Valor de 0 a 100",
    Value = { Min = 0, Max = 100, Default = 40 },
    Step = 1,
    Callback = function(v)
        print("[Slider]", v)
    end,
})

Controls:Stepper({
    Title = "Stepper",
    Desc = "Incremento com + / −",
    Value = 5,
    Min = 0,
    Max = 20,
    Step = 1,
    Callback = function(v)
        print("[Stepper]", v)
    end,
})

Controls:ProgressBar({
    Title = "Progress",
    Value = 0.45,
})

Controls:Checkbox({
    Title = "Checkbox",
    Desc = "Marcar opção",
    Default = true,
    Callback = function(v)
        print("[Checkbox]", v)
    end,
})

Controls:Radio({
    Title = "Radio",
    Options = { "Opção A", "Opção B", "Opção C" },
    Value = "Opção A",
    Callback = function(v)
        print("[Radio]", v)
    end,
})

Controls:SegmentedControl({
    Title = "Segmented",
    Options = { "Day", "Week", "Month" },
    Value = "Day",
    Callback = function(v)
        print("[Segmented]", v)
    end,
})

Controls:ChipList({
    Title = "Chips",
    Options = { "FPS", "ESP", "Aim", "Speed" },
    Multi = true,
    Value = { "ESP" },
    Callback = function(v)
        print("[Chips]", v)
    end,
})

-- ========== INPUTS ==========
Inputs:Section({ Title = "Campos" })
Inputs:Input({
    Title = "Input",
    Desc = "Texto livre",
    Placeholder = "Digite algo...",
    Callback = function(text)
        print("[Input]", text)
    end,
})

Inputs:Input({
    Title = "Input com limite",
    MaxSymbols = 12,
    Desc = "Máx. 12 caracteres",
    Callback = function(text)
        print("[InputLimit]", text)
    end,
})

Inputs:Keybind({
    Title = "Keybind",
    Desc = "Pressione uma tecla",
    Callback = function(key)
        print("[Keybind]", key)
    end,
})

Inputs:Dropdown({
    Title = "Dropdown",
    Desc = "Seleção única",
    Multi = false,
    Option = { "Alpha", "Beta", "Gamma", "Delta", "Epsilon" },
    Value = "Alpha",
    Callback = function(v)
        print("[Dropdown]", v)
    end,
})

Inputs:Dropdown({
    Title = "Multi Dropdown",
    Desc = "Várias opções",
    Multi = true,
    Option = { "Red", "Green", "Blue", "Yellow", "Purple" },
    Value = { "Red" },
    Callback = function(v)
        print("[MultiDropdown]", typeof(v) == "table" and table.concat(v, ", ") or v)
    end,
})

Inputs:Colorpicker({
    Title = "Colorpicker",
    Desc = "Escolha uma cor",
    Default = Color3.fromRGB(80, 160, 255),
    Callback = function(c)
        print("[Color]", c)
    end,
})

-- ========== EXTRA ==========
Extra:Section({ Title = "Componentes extras" })
Extra:Badge({ Title = "Badge", Text = "NEW" })
Extra:Label({ Title = "Label simples", Text = "Texto de apoio" })
Extra:KeyValue({
    Title = "Key / Value",
    Items = {
        { Key = "Status", Value = "Online" },
        { Key = "Ping", Value = "32ms" },
        { Key = "FPS", Value = "60" },
    },
})

Extra:Code({
    Title = "Code (view)",
    Code = [[local msg = "Hello Void Ui"
print(msg)]],
    Height = 120,
    Editable = false,
})

Extra:Code({
    Title = "Code (editor)",
    Code = "-- edite aqui\nprint(123)",
    Height = 100,
    Editable = true,
})

Extra:Accordion({
    Title = "Accordion",
    Content = "Conteúdo expansível do accordion. Clique no título para abrir/fechar.",
    Open = false,
    Callback = function(open)
        print("[Accordion]", open)
    end,
})

Extra:Timeline({
    Title = "Timeline",
    Steps = { "Init", "Load", "Ready", "Done" },
    Index = 2,
})

Extra:Path2D({
    Title = "Chart",
    Values = { 0.2, 0.55, 0.35, 0.8, 0.6, 0.9 },
})

Extra:PopupButton({
    Title = "Abrir Popup",
    PopupTitle = "Popup",
    PopupContent = "Conteúdo do popup de teste.",
    Callback = function()
        print("[Popup] OK")
    end,
})

Extra:Space(8)
Extra:Section({ Title = "Grupo (lado a lado)" })
local grid = Extra:Group({})
grid:Toggle({ Title = "Aimbot", Default = false, Callback = function(v) print(v) end })
grid:Toggle({ Title = "ESP", Default = true, Callback = function(v) print(v) end })

-- ========== SETTINGS ==========
Settings:Section({ Title = "Tema & Janela" })

local themeNames = {}
for name in pairs(Window.Themes or {}) do
    table.insert(themeNames, name)
end
table.sort(themeNames)

Settings:Dropdown({
    Title = "Theme",
    Option = #themeNames > 0 and themeNames or { "Dark", "Light", "Pink", "Blue", "Purple", "Neon" },
    Value = Window:GetTheme() or "Dark",
    Callback = function(name)
        Window:SetTheme(name)
        VoidUI:Notification({ Title = "Theme", Desc = tostring(name), Duration = 2 })
    end,
})

Settings:Toggle({
    Title = "Transparent",
    Default = false,
    Callback = function(v)
        Window:SetTransparency(v)
    end,
})

Settings:Toggle({
    Title = "Acrylic",
    Default = false,
    Callback = function(v)
        Window:ToggleAcrylic(v)
    end,
})

Settings:Toggle({
    Title = "Resizable",
    Default = true,
    Callback = function(v)
        Window:SetResizable(v)
    end,
})

Settings:Toggle({
    Title = "User panel",
    Default = true,
    Callback = function(v)
        Window:UserEnabled(v)
    end,
})

Settings:Toggle({
    Title = "Anonymous",
    Default = false,
    Callback = function(v)
        Window:Anonymous(v)
    end,
})

Settings:Keybind({
    Title = "Toggle Key",
    Callback = function(key)
        local code = Enum.KeyCode[key]
        if code then
            Window:SetToggleKey(code)
            VoidUI:Notification({ Title = "Toggle Key", Desc = tostring(key), Duration = 2 })
        end
    end,
})

Settings:Section({ Title = "Utilidades" })
Settings:Button({
    Title = "To Center",
    Callback = function()
        Window:ToCenter()
    end,
})

Settings:Button({
    Title = "Fullscreen",
    Callback = function()
        Window:ToggleFullscreen()
    end,
})

Settings:Button({
    Title = "Lock All Elements",
    Callback = function()
        Window:LockAll()
    end,
})

Settings:Button({
    Title = "Unlock All Elements",
    Callback = function()
        Window:UnlockAll()
    end,
})

Settings:Button({
    Title = "Save Config",
    Callback = function()
        Window:SetConfig("demo", true)
        Window:SaveConfig("VoidUiTest")
    end,
})

Settings:Button({
    Title = "Load Config",
    Callback = function()
        Window:LoadConfig("VoidUiTest")
    end,
})

Settings:Dropdown({
    Title = "Language",
    Option = { "English", "Português", "Español", "Français", "Deutsch" },
    Value = "Português",
    Callback = function(lang)
        Window:SetLanguage(lang)
    end,
})

Settings:Section({ Title = "Perigo" })
Settings:Button({
    Title = "Destroy UI",
    Desc = "Fecha e remove a interface",
    Callback = function()
        Window:Destroy()
    end,
})

Window:OnDestroy(function()
    print("[Void Ui] Destroyed")
end)

print("[Void Ui] Example loaded — use RightControl para abrir/fechar")
