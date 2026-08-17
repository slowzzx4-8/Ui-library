--[[
    Void Hub Library — Example (corrigido)

    IMPORTANTE:
    - Se carregar do GitHub e as abas ficarem vazias, o arquivo remoto
      ainda é a versão antiga. Use o arquivo local atualizado:
        local VoidUI = loadstring(readfile("Void Hub Library.lua"))()
]]

local ok, VoidUI = pcall(function()
    if isfile and isfile("Void Hub Library.lua") then
        return loadstring(readfile("Void Hub Library.lua"))()
    end
    if isfile and isfile("VoidHubLibrary.lua") then
        return loadstring(readfile("VoidHubLibrary.lua"))()
    end
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()
end)

if not ok or not VoidUI then
    warn("[Void Hub Example] Falha ao carregar a library:", VoidUI)
    return
end

local Window = VoidUI:CreateWindow({
    Name = "Void Hub Example",
    Author = "By Slowzzx4",
    Icon = "door-open",
    Theme = "Dark",
    Transparent = false,
    SideBarWidth = 150,
    Size = UDim2.new(0, 520, 0, 400),
    ToggleKey = Enum.KeyCode.LeftControl,
    AutoScale = false,
    Resizable = true,
    User = { Enabled = true, Anonymous = false },
})

Window:EditOpenButton({
    Icon = "door-open",
    Size = 44,
    CornerRadius = UDim.new(0, 10),
    Transparency = 0.05,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home", Border = true })
local ControlsTab = Window:Tab({ Title = "Controls", Icon = "sliders-horizontal", Border = true })
local InputTab = Window:Tab({ Title = "Input", Icon = "keyboard", Border = true })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings", Border = true })

MainTab:Section({ Title = "Welcome" })
MainTab:Paragraph({
    Title = "Void Hub Library",
    Desc = "Se você vê este texto, as abas estão funcionando.",
})
MainTab:Button({
    Title = "Notification",
    Desc = "Teste de notificação",
    Callback = function()
        VoidUI:Notification({
            Title = "Void Hub",
            Desc = "OK!",
            Icon = "check",
            Duration = 3,
        })
    end,
})
MainTab:Toggle({
    Title = "Sample Toggle",
    Default = true,
    Callback = function(v) print("toggle", v) end,
})

ControlsTab:Section({ Title = "Controls" })
ControlsTab:Slider({
    Title = "Slider",
    Value = { Min = 0, Max = 100, Default = 25 },
    Step = 1,
    Callback = function(v) print("slider", v) end,
})
ControlsTab:Dropdown({
    Title = "Dropdown",
    Option = { "One", "Two", "Three", "Four" },
    Value = "One",
    Multi = false,
    Callback = function(v) print("drop", v) end,
})
ControlsTab:Dropdown({
    Title = "Multi Dropdown",
    Option = { "Red", "Green", "Blue" },
    Value = { "Red" },
    Multi = true,
    Callback = function(v) print("multi", v) end,
})
ControlsTab:Stepper({
    Title = "Stepper",
    Min = 0, Max = 10, Value = 1, Step = 1,
    Callback = function(v) print("step", v) end,
})

InputTab:Section({ Title = "Input" })
InputTab:Input({
    Title = "Text Input",
    Placeholder = "Type...",
    Callback = function(t) print("input", t) end,
})
InputTab:Keybind({
    Title = "Keybind",
    Callback = function(k) print("key", k) end,
})

SettingsTab:Section({ Title = "Window" })
SettingsTab:Dropdown({
    Title = "Theme",
    Option = { "Dark", "Light", "Pink", "Blue", "Purple", "Green", "Neon", "Ocean" },
    Value = "Dark",
    Callback = function(v) Window:SetTheme(v) end,
})
SettingsTab:Toggle({
    Title = "Transparent",
    Default = false,
    Callback = function(v) Window:SetTransparency(v and 0.15 or 0) end,
})
SettingsTab:Button({
    Title = "Center Window",
    Callback = function() Window:ToCenter() end,
})
SettingsTab:Button({
    Title = "Minimize",
    Callback = function() Window:Close() end,
})
SettingsTab:Button({
    Title = "Destroy",
    Callback = function() Window:Destroy() end,
})

task.defer(function()
    pcall(function() Window:SelectTab(1) end)
end)
task.delay(0.15, function()
    pcall(function() Window:SelectTab(1) end)
end)

print("[Void Hub Example] loaded")
