--[[
    Void Ui — Theme Example (minimal)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Hub%20Library.lua"))()

local Window = VoidUI:CreateWindow({
    Name = "Void Ui",
    Icon = "door-open",
    SideBarWidth = 160,
    Theme = "Dark",
    Transparent = true,
    Author = "By Slowzzx4",
    User = { Enabled = true, Anonymous = true },
})

Window:EditOpenButton({
    Title = "Open Void Ui",
    Icon = "door-open",
    Transparency = 0.2,
    StrokeThickness = 1,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255)),
    },
    AutoRotation = true,
    Speed = 15,
    CornerRadius = UDim.new(0, 16),
})

pcall(function()
    Window:SetWatermark("Void Ui  •  " .. LocalPlayer.Name)
end)

local SelectedTheme = "Dark"
local IconColor = Color3.fromRGB(200, 200, 200)

local ThemeTab = Window:Tab({ Title = "Theme", Icon = "palette", Border = true })

ThemeTab:TabSection({ Title = "Theme" })

ThemeTab:Dropdown({
    Title = "Theme",
    Option = { "Dark", "Light" },
    Value = "Dark",
    Callback = function(v)
        SelectedTheme = v
    end,
})

pcall(function()
    ThemeTab:Colorpicker({
        Title = "Icon Color",
        Default = IconColor,
        Callback = function(c)
            IconColor = c
        end,
    })
end)

ThemeTab:Button({
    Title = "Apply Theme / Icons",
    Callback = function()
        pcall(function()
            if VoidUI.Themes and VoidUI.Themes[SelectedTheme] then
                VoidUI.Themes[SelectedTheme].IconColor = IconColor
            end
            Window:SetTheme(SelectedTheme)
        end)
        Window:Notify({
            Title = "Theme",
            Content = "Applied: " .. tostring(SelectedTheme),
            Duration = 2,
        })
    end,
})

ThemeTab:TabSection({ Title = "Background" })

-- guarda referência do Input para ler o texto no Apply (sem depender de Enter)
local ImageInput = ThemeTab:Input({
    Title = "Image ID",
    Placeholder = "rbxassetid:// ou só o número",
    Callback = function() end,
})

ThemeTab:Button({
    Title = "Apply Image Background",
    Callback = function()
        local id = ""
        if ImageInput and ImageInput.GetValue then
            id = tostring(ImageInput:GetValue() or "")
        elseif ImageInput and ImageInput.Value then
            id = tostring(ImageInput.Value)
        end
        id = id:gsub("%s+", "")
        if id == "" then
            Window:Notify({ Title = "Background", Content = "Digite o ID da imagem", Duration = 2 })
            return
        end
        local ok, err = pcall(function()
            Window:SetBackgroundImage(id, 0.25)
        end)
        if ok then
            Window:Notify({ Title = "Background", Content = "Imagem aplicada", Duration = 2 })
        else
            Window:Notify({ Title = "Background", Content = "Erro: " .. tostring(err), Duration = 3 })
        end
    end,
})

local VideoInput = ThemeTab:Input({
    Title = "Video ID",
    Placeholder = "rbxassetid:// ou só o número",
    Callback = function() end,
})

ThemeTab:Button({
    Title = "Apply Video Background",
    Callback = function()
        local id = ""
        if VideoInput and VideoInput.GetValue then
            id = tostring(VideoInput:GetValue() or "")
        elseif VideoInput and VideoInput.Value then
            id = tostring(VideoInput.Value)
        end
        id = id:gsub("%s+", "")
        if id == "" then
            Window:Notify({ Title = "Background", Content = "Digite o ID do vídeo", Duration = 2 })
            return
        end
        local ok, err = pcall(function()
            Window:SetBackgroundVideo(id, 0.3)
        end)
        if ok then
            Window:Notify({ Title = "Background", Content = "Vídeo aplicado", Duration = 2 })
        else
            Window:Notify({ Title = "Background", Content = "Erro: " .. tostring(err), Duration = 3 })
        end
    end,
})

ThemeTab:TabSection({ Title = "Window" })

ThemeTab:Toggle({
    Title = "Resizing",
    Default = true,
    Callback = function(v)
        pcall(function() Window:SetResizable(v) end)
    end,
})

ThemeTab:Slider({
    Title = "Acrylic",
    Value = { Min = 0, Max = 1, Default = 0 },
    Step = 0.05,
    Callback = function(v)
        pcall(function()
            Window:ToggleAcrylic(v > 0.05)
            Window:SetTransparency(v)
        end)
    end,
})

ThemeTab:Slider({
    Title = "UI Transparency",
    Value = { Min = 0, Max = 1, Default = 0.15 },
    Step = 0.05,
    Callback = function(v)
        pcall(function() Window:SetTransparency(v) end)
    end,
})

ThemeTab:TabSection({ Title = "User" })

ThemeTab:Toggle({
    Title = "User",
    Default = true,
    Callback = function(v)
        pcall(function() Window:UserEnabled(v) end)
    end,
})

ThemeTab:Toggle({
    Title = "Anonymous",
    Default = true,
    Callback = function(v)
        pcall(function() Window:Anonymous(v) end)
    end,
})

ThemeTab:Keybind({
    Title = "Toggle UI Key",
    Default = "F",
    Callback = function(k)
        pcall(function()
            if typeof(k) == "string" and Enum.KeyCode[k] then
                Window:SetToggleKey(Enum.KeyCode[k])
            else
                Window:SetToggleKey(Enum.KeyCode.F)
            end
        end)
    end,
})

pcall(function() Window:SetToggleKey(Enum.KeyCode.F) end)

task.wait(0.05)
pcall(function() Window:SelectFirstTab() end)
pcall(function() Window:Open() end)

print("[Void Ui] Theme example — Toggle: F")
