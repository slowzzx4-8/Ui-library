local Utility = {}
local TweenService = game:GetService("TweenService")

function Utility:TweenObject(obj, properties, duration, ...)
    TweenService:Create(obj, TweenInfo.new(duration, ...), properties):Play() 
end

function Utility:Debounce(fn, cooldown)
    local locked = false
    return function(...)
        if locked then return end
        locked = true
        local args = {...}
        local ok, err = pcall(fn, unpack(args))
        if not ok then warn("[Debounce] " .. tostring(err)) end
        task.delay(cooldown, function() locked = false end)
    end
end

function Utility:GetNearest(origin, list, getPositionFn)
    getPositionFn = getPositionFn or function(item) return item.Position end
    local nearest, nearestDist = nil, math.huge
    for _, item in ipairs(list) do
        local ok, pos = pcall(getPositionFn, item)
        if ok and pos then
            local dist = (origin - pos).Magnitude
            if dist < nearestDist then
                nearest, nearestDist = item, dist
            end
        end
    end
    return nearest, nearestDist
end

local activeNotifs = 0
local UI, VoidUI = {
    Theme = nil,
    Themes = {},
    Notifications = 0,
    DefaultProps = {},
    IslandOpen = true,
    BlockDragging = false, -- usado pelo ColorPicker para não mover a janela
}, {
    Objects = {},
}

VoidUI.DefaultProps = {
    TextButton = {
        AutoButtonColor = false,
        TextTransparency = 1,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        ZIndex = 1,
    },
    TextLabel = {
        BorderSizePixel = 0,
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        TextSize = 12,
        ZIndex = 1,
    },
    ImageLabel = {
        BorderSizePixel = 0,
        ZIndex = 1,
    },
    Frame = {
        BorderSizePixel = 0,
        ZIndex = 1,
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 1,
    },
}

VoidUI.Themes = {
    Dark = {
        Name = "Dark",
        -- real dark (não cinza)
        Background = Color3.fromHex("#0a0a0a"),
        SideBar = Color3.fromHex("#0f0f0f"),
        Text = Color3.fromHex("#FFFFFF"),
        ElementColor = Color3.fromHex("#141414"),
        Outline = Color3.fromHex("#1f1f1f"),
        Placeholder = Color3.fromHex("#6b6b6b"),
        IconColor = Color3.fromHex("#c8c8c8"),
    },
    Light = {
        Name = "Light",
        Background = Color3.fromHex("#FFFFFF"),
        SideBar = Color3.fromHex("#efefef"),
        Text = Color3.fromHex("#000000"),
        ElementColor = Color3.fromHex("#ffffff"),
        Outline = Color3.fromRGB(200, 200, 200),
        Placeholder = Color3.fromHex("#555555"),
        IconColor = Color3.fromHex("#52525b"),
    },
    Forest = {
        Name = "Forest",
        Background = Color3.fromRGB(20, 24, 22),
        SideBar = Color3.fromRGB(28, 32, 30),
        Text = Color3.fromRGB(225, 235, 225),
        ElementColor = Color3.fromRGB(50, 60, 55),
        Outline = Color3.fromRGB(80, 95, 85),
        Placeholder = Color3.fromRGB(28, 32, 30),
        IconColor = Color3.fromRGB(225, 235, 225),
    },
    Amethyst = {
        Name = "Amethyst",
        Background = Color3.fromRGB(18, 14, 24),
        SideBar = Color3.fromRGB(27, 21, 36),
        Text = Color3.fromRGB(240, 235, 250),
        ElementColor = Color3.fromRGB(40, 32, 52),
        Outline = Color3.fromRGB(70, 55, 95),
        Placeholder = Color3.fromRGB(18, 14, 24),
        IconColor = Color3.fromRGB(170, 120, 230),
    },
    Crimson = {
        Name = "Crimson",
        -- cores alinhadas ao WindUI Red/Crimson
        Background = Color3.fromHex("#1c0606"),
        SideBar = Color3.fromHex("#450a0a"),
        Text = Color3.fromHex("#fef2f2"),
        ElementColor = Color3.fromRGB(50, 20, 20),
        Outline = Color3.fromHex("#991b1b"),
        Placeholder = Color3.fromHex("#d95353"),
        IconColor = Color3.fromHex("#f87171"),
    },
    DarkBlue = {
        Name = "DarkBlue",
        Background = Color3.fromRGB(12, 15, 22),
        SideBar = Color3.fromRGB(18, 24, 35),
        Text = Color3.fromRGB(230, 240, 255),
        ElementColor = Color3.fromRGB(25, 35, 50),
        Outline = Color3.fromRGB(45, 65, 95),
        Placeholder = Color3.fromRGB(12, 15, 22),
        IconColor = Color3.fromRGB(100, 160, 255),
    },
    Pink = {
        Name = "Pink",
        Background = Color3.fromRGB(22, 14, 18),
        SideBar = Color3.fromRGB(34, 21, 28),
        Text = Color3.fromRGB(255, 235, 245),
        ElementColor = Color3.fromRGB(50, 30, 40),
        Outline = Color3.fromRGB(90, 55, 75),
        Placeholder = Color3.fromRGB(22, 14, 18),
        IconColor = Color3.fromRGB(255, 120, 190),
    },
    Orange = {
        Name = "Orange",
        Background = Color3.fromRGB(22, 17, 12),
        SideBar = Color3.fromRGB(34, 26, 18),
        Text = Color3.fromRGB(255, 240, 225),
        ElementColor = Color3.fromRGB(50, 38, 25),
        Outline = Color3.fromRGB(90, 65, 45),
        Placeholder = Color3.fromRGB(22, 17, 12),
        IconColor = Color3.fromRGB(255, 150, 60),
    },
    -- Themes from WindUI / Main.lua
    Rose = {
        Name = "Rose",
        Background = Color3.fromHex("#1f0308"),
        SideBar = Color3.fromHex("#4c0519"),
        Text = Color3.fromHex("#fdf2f8"),
        ElementColor = Color3.fromHex("#381E23"),
        Outline = Color3.fromHex("#be185d"),
        Placeholder = Color3.fromHex("#d67aa6"),
        IconColor = Color3.fromHex("#fb7185"),
    },
    Plant = {
        Name = "Plant",
        Background = Color3.fromHex("#0a1b0f"),
        SideBar = Color3.fromHex("#052e16"),
        Text = Color3.fromHex("#f0fdf4"),
        ElementColor = Color3.fromHex("#28342A"),
        Outline = Color3.fromHex("#166534"),
        Placeholder = Color3.fromHex("#4fbf7a"),
        IconColor = Color3.fromHex("#4ade80"),
    },
    Red = {
        Name = "Red",
        Background = Color3.fromHex("#1c0606"),
        SideBar = Color3.fromHex("#450a0a"),
        Text = Color3.fromHex("#fef2f2"),
        ElementColor = Color3.fromRGB(50, 20, 20),
        Outline = Color3.fromHex("#991b1b"),
        Placeholder = Color3.fromHex("#d95353"),
        IconColor = Color3.fromHex("#f87171"),
    },
    Indigo = {
        Name = "Indigo",
        Background = Color3.fromHex("#0f0a1f"),
        SideBar = Color3.fromHex("#1e1b4b"),
        Text = Color3.fromHex("#eef2ff"),
        ElementColor = Color3.fromHex("#2e2a5a"),
        Outline = Color3.fromHex("#4338ca"),
        Placeholder = Color3.fromHex("#818cf8"),
        IconColor = Color3.fromHex("#a5b4fc"),
    },
    Sky = {
        Name = "Sky",
        Background = Color3.fromHex("#0c1929"),
        SideBar = Color3.fromHex("#0c4a6e"),
        Text = Color3.fromHex("#f0f9ff"),
        ElementColor = Color3.fromHex("#164e6a"),
        Outline = Color3.fromHex("#0284c7"),
        Placeholder = Color3.fromHex("#38bdf8"),
        IconColor = Color3.fromHex("#7dd3fc"),
    },
    Violet = {
        Name = "Violet",
        Background = Color3.fromHex("#14081f"),
        SideBar = Color3.fromHex("#2e1065"),
        Text = Color3.fromHex("#f5f3ff"),
        ElementColor = Color3.fromHex("#3b1d6e"),
        Outline = Color3.fromHex("#7c3aed"),
        Placeholder = Color3.fromHex("#a78bfa"),
        IconColor = Color3.fromHex("#c4b5fd"),
    },
    Amber = {
        Name = "Amber",
        Background = Color3.fromHex("#1c1408"),
        SideBar = Color3.fromHex("#451a03"),
        Text = Color3.fromHex("#fffbeb"),
        ElementColor = Color3.fromHex("#3d2a12"),
        Outline = Color3.fromHex("#d97706"),
        Placeholder = Color3.fromHex("#fbbf24"),
        IconColor = Color3.fromHex("#fcd34d"),
    },
    Emerald = {
        Name = "Emerald",
        Background = Color3.fromHex("#06140f"),
        SideBar = Color3.fromHex("#064e3b"),
        Text = Color3.fromHex("#ecfdf5"),
        ElementColor = Color3.fromHex("#0f3d2e"),
        Outline = Color3.fromHex("#059669"),
        Placeholder = Color3.fromHex("#34d399"),
        IconColor = Color3.fromHex("#6ee7b7"),
    },
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromHex("#0a0a12"),
        SideBar = Color3.fromHex("#12121f"),
        Text = Color3.fromHex("#e2e8f0"),
        ElementColor = Color3.fromHex("#1a1a2e"),
        Outline = Color3.fromHex("#334155"),
        Placeholder = Color3.fromHex("#64748b"),
        IconColor = Color3.fromHex("#94a3b8"),
    },
    ["Monokai Pro"] = {
        Name = "Monokai Pro",
        Background = Color3.fromHex("#191622"),
        SideBar = Color3.fromHex("#221f2e"),
        Text = Color3.fromHex("#fcfcfa"),
        ElementColor = Color3.fromHex("#323039"),
        Outline = Color3.fromHex("#49464e"),
        Placeholder = Color3.fromHex("#afafaf"),
        IconColor = Color3.fromHex("#a9dc76"),
    },
    ["Cotton Candy"] = {
        Name = "Cotton Candy",
        Background = Color3.fromHex("#1a0b2e"),
        SideBar = Color3.fromHex("#2d1b3d"),
        Text = Color3.fromHex("#fdf2f8"),
        ElementColor = Color3.fromHex("#312643"),
        Outline = Color3.fromHex("#ec4899"),
        Placeholder = Color3.fromHex("#8a5fd3"),
        IconColor = Color3.fromHex("#06b6d4"),
    },
    Mellowsi = {
        Name = "Mellowsi",
        Background = Color3.fromHex("#1C1002"),
        SideBar = Color3.fromHex("#291C13"),
        Text = Color3.fromHex("#F5EBDD"),
        ElementColor = Color3.fromHex("#33291E"),
        Outline = Color3.fromHex("#342A1E"),
        Placeholder = Color3.fromHex("#9C8A73"),
        IconColor = Color3.fromHex("#C9B79C"),
    },
    Cyber = {
        Name = "Cyber",
        Background = Color3.fromHex("#05070a"),
        SideBar = Color3.fromHex("#0a1018"),
        Text = Color3.fromHex("#e0f7ff"),
        ElementColor = Color3.fromHex("#101820"),
        Outline = Color3.fromHex("#00e5ff"),
        Placeholder = Color3.fromHex("#3a5a6a"),
        IconColor = Color3.fromHex("#00e5ff"),
    },
    Sunset = {
        Name = "Sunset",
        Background = Color3.fromHex("#1a0f0a"),
        SideBar = Color3.fromHex("#2a1810"),
        Text = Color3.fromHex("#fff5eb"),
        ElementColor = Color3.fromHex("#3a2418"),
        Outline = Color3.fromHex("#ff6b35"),
        Placeholder = Color3.fromHex("#a06040"),
        IconColor = Color3.fromHex("#ff9f43"),
    },
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromHex("#061018"),
        SideBar = Color3.fromHex("#0c1e2a"),
        Text = Color3.fromHex("#e8f4fc"),
        ElementColor = Color3.fromHex("#122a3a"),
        Outline = Color3.fromHex("#1e90ff"),
        Placeholder = Color3.fromHex("#4a7a9a"),
        IconColor = Color3.fromHex("#5dade2"),
    },
    Grape = {
        Name = "Grape",
        Background = Color3.fromHex("#12081c"),
        SideBar = Color3.fromHex("#1c0f2e"),
        Text = Color3.fromHex("#f3e8ff"),
        ElementColor = Color3.fromHex("#2a1840"),
        Outline = Color3.fromHex("#9b59b6"),
        Placeholder = Color3.fromHex("#6a4a80"),
        IconColor = Color3.fromHex("#c39bd3"),
    },
    Nord = {
        Name = "Nord",
        Background = Color3.fromHex("#2e3440"),
        SideBar = Color3.fromHex("#3b4252"),
        Text = Color3.fromHex("#eceff4"),
        ElementColor = Color3.fromHex("#434c5e"),
        Outline = Color3.fromHex("#88c0d0"),
        Placeholder = Color3.fromHex("#4c566a"),
        IconColor = Color3.fromHex("#81a1c1"),
    },
    Dracula = {
        Name = "Dracula",
        Background = Color3.fromHex("#282a36"),
        SideBar = Color3.fromHex("#21222c"),
        Text = Color3.fromHex("#f8f8f2"),
        ElementColor = Color3.fromHex("#44475a"),
        Outline = Color3.fromHex("#bd93f9"),
        Placeholder = Color3.fromHex("#6272a4"),
        IconColor = Color3.fromHex("#ff79c6"),
    },
    Catppuccin = {
        Name = "Catppuccin",
        Background = Color3.fromHex("#1e1e2e"),
        SideBar = Color3.fromHex("#181825"),
        Text = Color3.fromHex("#cdd6f4"),
        ElementColor = Color3.fromHex("#313244"),
        Outline = Color3.fromHex("#89b4fa"),
        Placeholder = Color3.fromHex("#6c7086"),
        IconColor = Color3.fromHex("#cba6f7"),
    },
    TokyoNight = {
        Name = "TokyoNight",
        Background = Color3.fromHex("#1a1b26"),
        SideBar = Color3.fromHex("#16161e"),
        Text = Color3.fromHex("#c0caf5"),
        ElementColor = Color3.fromHex("#24283b"),
        Outline = Color3.fromHex("#7aa2f7"),
        Placeholder = Color3.fromHex("#565f89"),
        IconColor = Color3.fromHex("#bb9af7"),
    },
    Gruvbox = {
        Name = "Gruvbox",
        Background = Color3.fromHex("#1d2021"),
        SideBar = Color3.fromHex("#282828"),
        Text = Color3.fromHex("#ebdbb2"),
        ElementColor = Color3.fromHex("#3c3836"),
        Outline = Color3.fromHex("#fabd2f"),
        Placeholder = Color3.fromHex("#928374"),
        IconColor = Color3.fromHex("#fe8019"),
    },
    Solarized = {
        Name = "Solarized",
        Background = Color3.fromHex("#002b36"),
        SideBar = Color3.fromHex("#073642"),
        Text = Color3.fromHex("#fdf6e3"),
        ElementColor = Color3.fromHex("#094554"),
        Outline = Color3.fromHex("#268bd2"),
        Placeholder = Color3.fromHex("#586e75"),
        IconColor = Color3.fromHex("#2aa198"),
    },
    Blood = {
        Name = "Blood",
        Background = Color3.fromHex("#0d0208"),
        SideBar = Color3.fromHex("#1a050a"),
        Text = Color3.fromHex("#ffe4e6"),
        ElementColor = Color3.fromHex("#2a0a12"),
        Outline = Color3.fromHex("#be123c"),
        Placeholder = Color3.fromHex("#9f1239"),
        IconColor = Color3.fromHex("#fb7185"),
    },
    Neon = {
        Name = "Neon",
        Background = Color3.fromHex("#050510"),
        SideBar = Color3.fromHex("#0a0a1a"),
        Text = Color3.fromHex("#e0ffff"),
        ElementColor = Color3.fromHex("#101028"),
        Outline = Color3.fromHex("#00ff9f"),
        Placeholder = Color3.fromHex("#3a3a6a"),
        IconColor = Color3.fromHex("#00f0ff"),
    },
    Mocha = {
        Name = "Mocha",
        Background = Color3.fromHex("#1c1410"),
        SideBar = Color3.fromHex("#2a1f18"),
        Text = Color3.fromHex("#f5e6d3"),
        ElementColor = Color3.fromHex("#3a2e24"),
        Outline = Color3.fromHex("#c4a484"),
        Placeholder = Color3.fromHex("#8b7355"),
        IconColor = Color3.fromHex("#d4a574"),
    },
    Arctic = {
        Name = "Arctic",
        Background = Color3.fromHex("#0f1419"),
        SideBar = Color3.fromHex("#151b23"),
        Text = Color3.fromHex("#e6edf3"),
        ElementColor = Color3.fromHex("#1c2430"),
        Outline = Color3.fromHex("#58a6ff"),
        Placeholder = Color3.fromHex("#6e7681"),
        IconColor = Color3.fromHex("#79c0ff"),
    },
    Matrix = {
        Name = "Matrix",
        Background = Color3.fromHex("#000a00"),
        SideBar = Color3.fromHex("#001400"),
        Text = Color3.fromHex("#00ff41"),
        ElementColor = Color3.fromHex("#002200"),
        Outline = Color3.fromHex("#00ff41"),
        Placeholder = Color3.fromHex("#003b00"),
        IconColor = Color3.fromHex("#00ff41"),
    },
}

UI.Theme = VoidUI.Themes["Dark"]

function VoidUI:Create(class, properties, children)
    local inst = Instance.new(class)

    local defaults = VoidUI.DefaultProps[class]
    if defaults then
        for prop, val in next, defaults do
            if properties[prop] == nil then
                properties[prop] = val
            end
        end
    end

    for property, Value in next, properties or {} do
        if property ~= "ThemeID" then
            inst[property] = Value
        end
    end

    for _, Child in next, children or {} do
        Child.Parent = inst
    end

    if properties.ThemeID then
        VoidUI:AddThemeObject(inst, properties.ThemeID)
    end
    return inst
end


function VoidUI:GetThemeProperty(property, theme, fallbackProperty)
    local function resolve(t, key)
        for _, part in ipairs(string.split(key, ".")) do
            if type(t) ~= "table" then return nil end
            t = t[part]
        end
        return t
    end

    return resolve(theme, property) 
        or resolve(VoidUI.Themes["Dark"], property)
        or (fallbackProperty and (resolve(theme, fallbackProperty) or resolve(VoidUI.Themes["Dark"], fallbackProperty)))
end

function VoidUI:AddThemeObject(object, properties)
    VoidUI.Objects[object] = { Object = object, Properties = properties }
    VoidUI:UpdateTheme(object, false)
    return object
end

function VoidUI:UpdateTheme(targetObject, isTween)
    local function ApplyTheme(objData)
        for property, colorKey in pairs(objData.Properties or {}) do
            local color = nil
            for _, key in ipairs(string.split(colorKey, "|")) do
                key = key:gsub("%s+", "")
                color = VoidUI:GetThemeProperty(key, UI.Theme)
                if color then break end
            end

            if color then
                if not isTween then
                    objData.Object[property] = color
                else
                    Utility:TweenObject(objData.Object, { [property] = color }, 0)
                end
            end
        end
    end

    if targetObject then
        local objData = VoidUI.Objects[targetObject]
        if objData then ApplyTheme(objData) end
    else
        for _, objData in pairs(VoidUI.Objects) do
            ApplyTheme(objData)
        end
    end
end

function VoidUI:SetTheme(themeName)
    local theme = VoidUI.Themes[themeName]
    if not theme then
        warn("Theme '" .. tostring(themeName) .. "' not found.")
        return
    end

    UI.Theme = theme
    VoidUI:UpdateTheme(nil, true)
end

function UI:AddTheme(i)
    VoidUI.Themes[i.Name] = i
    return i
end

function Utility:GlassStroke(themeKey, thickness)
    return VoidUI:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        LineJoinMode = "Round",
        Thickness = thickness or 0.6,
        ThemeID = { Color = themeKey or "Outline" }
    }, {
        VoidUI:Create("UIGradient", {
            Color = ColorSequence.new(
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(255, 255, 255)
            ),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.5, 1),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Rotation = -110
        })
    })
end

function Utility:Padding(a, b, c, d)
    if type(a) == "table" then
        return VoidUI:Create("UIPadding", {
            PaddingTop = UDim.new(0, a.top or 0),
            PaddingBottom = UDim.new(0, a.bottom or 0),
            PaddingLeft = UDim.new(0, a.left or 0),
            PaddingRight = UDim.new(0, a.right or 0),
        })
    end
    return VoidUI:Create("UIPadding", {
        PaddingTop = UDim.new(0, a or 0),
        PaddingBottom = UDim.new(0, b or a or 0),
        PaddingLeft = UDim.new(0, c or a or 0),
        PaddingRight = UDim.new(0, d or c or a or 0),
    })
end

function Utility:ListLayout(dir, padding, align)
    return VoidUI:Create("UIListLayout", {
        FillDirection = (dir == "H") and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, padding or 5),
        HorizontalAlignment = (align and dir == "H") and align or nil,
        VerticalAlignment = (align and dir == "V") and align or nil,
    })
end

function Utility:T(scope, prop, fallback)
    return scope .. "." .. prop .. "|" .. fallback
end

function Utility:Search(Window, cfg)
    table.insert(Window.SearchIndex, cfg)
end

function Utility:ElText(parent, title, desc, scope)
    -- right padding evita texto invadir toggle/slider/input
    local Title = Text(parent, title, {
        Size = UDim2.new(1, -72, 0, 5),
        AutomaticSize = "Y",
        ZIndex = 16,
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
        TextSize = 13,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        RichText = true,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeID = { TextColor3 = Utility:T(scope, "Text", "Text") }
    }, { Utility:Padding({ left = 10, right = 10 }) })
    Title.Position = UDim2.new(0, 0, 0, 0)

    local Desc = Text(parent, desc, {
        Size = UDim2.new(1, -72, 0, 5),
        AutomaticSize = "Y",
        ZIndex = 16,
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
        TextSize = 12,
        TextTransparency = 0.7,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        RichText = true,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = desc ~= nil,
        ThemeID = { TextColor3 = Utility:T(scope, "Text", "Text") }
    }, { Utility:Padding({ left = 10, right = 10 }) })

    return Title, Desc
end

function Utility:Element(RightScroll, ElementFrame, sizeY, scope)
    local Beeee = VoidUI:Create("Frame", {
        Parent = RightScroll,
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
        Size = UDim2.new(0, ElementFrame.Size.X.Offset - 10, 0, sizeY or 44),
        ZIndex = 15,
    })

    local Card = VoidUI:Create("Frame", {
        Parent = Beeee,
        AutomaticSize = "Y",
        ClipsDescendants = true,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 0, sizeY or 44),
        BorderSizePixel = 0,
        ZIndex = 15,
        ThemeID = { BackgroundColor3 = Utility:T(scope, "Background", "ElementColor") }
    }, {
        Utility:GlassStroke(),
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 12),
        }),
        Utility:Padding({ top = 6, bottom = 8 }),
    })

    local Inner = VoidUI:Create("Frame", {
        Parent = Card,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = "Y",
        ClipsDescendants = false,
        ZIndex = 16,
    }, {
        Utility:ListLayout("V", 2),
        Utility:Padding({ top = 6, bottom = 4 }),
    })

    return Beeee, Card, Inner
end

local IconsV2 = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
IconsV2.SetIconsType("lucide")

local function GetIcon(icon)
    if typeof(icon) == "string" and icon:find("rbxassetid://") then
        return icon
    end

    if typeof(icon) == "string" and icon:find(":") then
        local pack, name = icon:match("([^:]+):(.+)")
        if pack and name then
            IconsV2.SetIconsType(string.lower(pack))
            return IconsV2.GetIcon(name)
        end
    end
    
    IconsV2.SetIconsType("lucide")
    return IconsV2.GetIcon(icon)
end

local function ResolveIconImage(icon)
    local data = GetIcon(icon)
    if typeof(data) == "table" then
        return data.Image or data[1] or ""
    end
    return data or ""
end

local UserInputService = game:GetService("UserInputService")

-- handles: nil = whole frame; Instance or {Instance,...} = only those regions drag the frame
-- UI.BlockDragging = true bloqueia qualquer drag (usado no ColorPicker)
local function enableDragging(frame, handles)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        if UI.BlockDragging then return end
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    local function bindHandle(handle)
        if not handle then return end
        handle.InputBegan:Connect(function(input)
            if UI.BlockDragging then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
    end

    if handles == nil then
        bindHandle(frame)
    elseif typeof(handles) == "table" then
        for _, h in ipairs(handles) do
            bindHandle(h)
        end
    else
        bindHandle(handles)
    end

    UserInputService.InputChanged:Connect(function(input)
        if UI.BlockDragging then return end
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function LockedElm(Frame, Stat)
    local LockFrame = Frame:FindFirstChild("Lock")
    if not LockFrame then
        LockFrame = VoidUI:Create("Frame", {
            Name = "Lock",
            BackgroundTransparency = 0.2,
            AutomaticSize = "XY",
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 198,
            Parent = Frame,
            Active = true,
            ThemeID = {
                BackgroundColor3 = "Background"
            }
        },{
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0,12)
            })
        })
        VoidUI:Create("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0,20, 0,20),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            ZIndex = 199,
            Image = GetIcon("lock-keyhole"),
            Parent = LockFrame,
        })
    end
    LockFrame.Visible = Stat
    return LockFrame
end

function Text(parent, text, textProps, children)
    local container = VoidUI:Create("Frame", {
        BackgroundTransparency = textProps.BackgroundTransparency or 1,
        AutomaticSize = textProps.AutomaticSize or "XY",
        Size = textProps.Size or UDim2.new(),
        LayoutOrder = textProps.LayoutOrder,
        Position = textProps.Position,
        ZIndex = textProps.ZIndex,
        Visible = textProps.Visible ~= false,
        Parent = textProps.Parent or parent,
    }, {
        VoidUI:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
        })
    })

    if children then
        for _, child in ipairs(children) do
            child.Parent = container
        end
    end

    local imgTheme = nil
    if textProps.ThemeID and textProps.ThemeID.TextColor3 then
        imgTheme = { ImageColor3 = textProps.ThemeID.TextColor3 }
    end

    local function CreateText(str, layoutOrder, parentRow)
        return VoidUI:Create("TextLabel", {
            BackgroundTransparency = 1,
            AutomaticSize = "XY",
            Size = UDim2.new(),
            LayoutOrder = layoutOrder,
            Text = str,
            RichText = textProps.RichText or false,
            TextSize = textProps.TextSize or 13,
            FontFace = textProps.FontFace or Font.new("rbxasset://fonts/families/GothamSSm.json"),
            TextColor3 = textProps.TextColor3 or Color3.fromRGB(255, 255, 255),
            TextTransparency = textProps.TextTransparency or 0,
            TextWrapped = textProps.TextWrapped or false,
            TextXAlignment = textProps.TextXAlignment or Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = textProps.ZIndex,
            Parent = parentRow,
            ThemeID = textProps.ThemeID,
        })
    end

    local function CreateIcon(name, layoutOrder, parentRow)
        if not icon then
            --warn("IconsV2: Icon Not Found — " .. name)
        end

        local img = VoidUI:Create("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, textProps.TextSize or 13, 0, textProps.TextSize or 13),
            LayoutOrder = layoutOrder,
            ScaleType = Enum.ScaleType.Fit,
            ImageColor3 = textProps.TextColor3 or Color3.fromRGB(255, 255, 255),
            ImageTransparency = textProps.TextTransparency or 0,
            ZIndex = textProps.ZIndex,
            Image = "",
            ThemeID = imgTheme,
            Parent = parentRow,
        })

        if typeof(IconsV2.GetIcon(name)) == "table" then
            img.Image = GetIcon(name).Image or ""
            if IconsV2.GetIcon(name).ImageRectOffset then
                img.ImageRectOffset = GetIcon(name).ImageRectOffset
            end
            if IconsV2.GetIcon(name).ImageRectSize then
                img.ImageRectSize = GetIcon(name).ImageRectSize
            end
        elseif typeof(IconsV2.GetIcon(name)) == "string" then
            img.Image = GetIcon(name)
        end
        return img
    end

    local function Render(newText)
        for _, child in ipairs(container:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end

        newText = (newText or ""):gsub("\n", "\\n")

        for lineIndex, line in ipairs(string.split(newText, "\\n")) do
            local row = VoidUI:Create("Frame", {
                BackgroundTransparency = 1,
                AutomaticSize = "XY",
                ClipsDescendants = true,
                Size = UDim2.new(),
                LayoutOrder = lineIndex,
                Parent = container,
            }, {
                VoidUI:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                })
            })

            local order = 0
            local lastPos = 1

            for before, iconName in line:gmatch("(.-)<([%w_%-]+)>") do
                if #before:gsub("%s", "") > 0 then
                    order += 1
                    CreateText(before, order, row)
                end

                order += 1
                CreateIcon(iconName, order, row)

                lastPos = lastPos + #before + #iconName + 2
            end
            local rest = line:sub(lastPos)
            if #rest:gsub("%s", "") > 0 then
                order += 1
                CreateText(rest, order, row)
            end
        end
    end
    Render(text)
    return {
        Frame = container,
        SetText = Render,
        UIPadding = container:FindFirstChildOfClass("UIPadding"),
    }
end

    local UIScreen = VoidUI:Create("ScreenGui", {
        Parent = game:GetService("CoreGui"),
        --ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })

    -- Island desativado (removido a linha preta no topo acima do botão open/close)
    local Island = VoidUI:Create("Frame", {
        Parent = UIScreen,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 0, 0),
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 1,
    })

    -- Holder de notificações (estilo WindUI / Main.lua — canto superior direito)
    local NotificationHolder = VoidUI:Create("Frame", {
        Parent = UIScreen,
        Name = "NotificationHolder",
        Position = UDim2.new(1, -29, 0, 56),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 300, 1, -156),
        BackgroundTransparency = 1,
        ZIndex = 400,
    }, {
        VoidUI:Create("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8),
        }),
        VoidUI:Create("UIPadding", {
            PaddingBottom = UDim.new(0, 29),
        }),
    })
    UI.NotificationHolder = NotificationHolder

function UI:CreateWindow(Config)
    local Window = {
        Name = Config.Name or "void ui",
        Author = Config.Author or nil,
        Icon = Config.Icon or nil,
        ToggleKey = Config.ToggleKey or Enum.KeyCode.F,
        Transparent = Config.Transparent or false,
        Theme = Config.Theme or "Dark",
        Folder = Config.Folder,
        KeySystem = Config.KeySystem,
        Default = Config.Default or "Default",
        AutoScale = Config.AutoScale or true,
        Resizable = Config.Resizable or true,
        Topbar = {
            Height = Config.Height or 35,
        },
        OnDestroy = Config.OnDestroy or function() end,
        Themes = VoidUI.Themes,
        Size = Config.Size and UDim2.new(
            0, math.clamp(Config.Size.X.Offset, 420, 580),
            0, math.clamp(Config.Size.Y.Offset, 280, 450)
        ) or UDim2.new(0, 480, 0, 360),
        SideBarWidth = Config.SideBarWidth or 160,
        User = Config.User or {},
        Tabs = {},
        AllElements = {},
        CurrentTab = {},
        TabOrder = {},
        SearchIndex = {},
    }
    Window.IslandOpen = true

    function Window:SetTheme(themeName)
        Window.Theme = themeName
        local theme = VoidUI.Themes[themeName]
        if not theme then
            warn("Theme '" .. tostring(themeName) .. "' not found.")
            return
        end
        
        UI.Theme = theme
        VoidUI:UpdateTheme(nil, true)
    end

    Window:SetTheme(Window.Theme)

    --UIMinimized / Open Button (estilo WindUI / Main.lua — arrastável)
    local Main

    local OpenButtonHolder = VoidUI:Create("Frame", {
        Parent = UIScreen,
        Size = UDim2.new(0, 0, 0, 44),
        AutomaticSize = "X",
        -- Posição igual imagem 3: topo central da tela
        Position = UDim2.new(0.5, 0, 0, 8),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 200,
        Active = true,
    })

    local OpenButton = VoidUI:Create("Frame", {
        Parent = OpenButtonHolder,
        Size = UDim2.new(0, 0, 0, 44),
        AutomaticSize = "X",
        BackgroundTransparency = 0.25,
        BackgroundColor3 = Color3.new(0, 0, 0),
        ZIndex = 201,
        Active = true,
        ThemeID = { BackgroundColor3 = "Background" },
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        VoidUI:Create("UIStroke", {
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0,
        }, {
            VoidUI:Create("UIGradient", {
                Color = ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff")),
            }),
        }),
        VoidUI:Create("UIListLayout", {
            Padding = UDim.new(0, 4),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
        }),
    })

    -- Handle de arraste (move)
    local DragHandle = VoidUI:Create("Frame", {
        Parent = OpenButton,
        Size = UDim2.new(0, 36, 0, 36),
        BackgroundTransparency = 1,
        Name = "Drag",
        ZIndex = 202,
        LayoutOrder = 1,
    }, {
        VoidUI:Create("ImageLabel", {
            Image = ResolveIconImage("move"),
            Size = UDim2.new(0, 18, 0, 18),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ImageTransparency = 0.3,
            ZIndex = 203,
            ThemeID = { ImageColor3 = "IconColor" },
        }),
    })

    local DividerLine = VoidUI:Create("Frame", {
        Parent = OpenButton,
        Size = UDim2.new(0, 1, 1, -12),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.9,
        LayoutOrder = 2,
        ZIndex = 202,
    })

    local OpenClickBtn = VoidUI:Create("TextButton", {
        Parent = OpenButton,
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 36),
        Text = "",
        TextTransparency = 1,
        AutoButtonColor = false,
        LayoutOrder = 3,
        ZIndex = 202,
    }, {
        VoidUI:Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 11),
        }),
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    })

    local OpenBtnIcon = nil
    if Window.Icon then
        local _iconData = GetIcon(Window.Icon)
        OpenBtnIcon = VoidUI:Create("ImageLabel", {
            Parent = OpenClickBtn,
            Size = UDim2.new(0, 22, 0, 22),
            BackgroundTransparency = 1,
            Image = (typeof(_iconData) == "table" and (_iconData.Image or "")) or (typeof(_iconData) == "string" and _iconData) or "",
            LayoutOrder = 1,
            ZIndex = 203,
            ThemeID = { ImageColor3 = "IconColor" },
        })
        if typeof(_iconData) == "table" then
            if _iconData.ImageRectOffset then OpenBtnIcon.ImageRectOffset = _iconData.ImageRectOffset end
            if _iconData.ImageRectSize then OpenBtnIcon.ImageRectSize = _iconData.ImageRectSize end
        end
    end

    local OpenBtnTitle = VoidUI:Create("TextLabel", {
        Parent = OpenClickBtn,
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        Text = Window.Name,
        TextSize = 17,
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        LayoutOrder = 2,
        ZIndex = 203,
        ThemeID = { TextColor3 = "Text" },
    })

    -- Arrastar pelo handle
    do
        local dragging, dragStart, startPos
        DragHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = OpenButtonHolder.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                OpenButtonHolder.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- Alias para compatibilidade com código antigo
    local MinzUI = OpenButtonHolder
    local UIIcon = OpenBtnIcon

    function Window:EditOpenButton(Config)
        local Edit = {
            Title = Config.Title or Window.Name,
            Icon = Config.Icon or Window.Icon,
            Color = Config.Color or nil,
            Transparency = Config.Transparency or 0.25,
            Rotation = Config.Rotation or 0,
            AutoRotation = Config.AutoRotation or false,
            Speed = Config.Speed or 15,
            StrokeThickness = Config.StrokeThickness or 1,
            CornerRadius = Config.CornerRadius or UDim.new(1, 0),
        }
        OpenBtnTitle.Text = Edit.Title
        OpenButton.UICorner.CornerRadius = Edit.CornerRadius
        OpenButton.BackgroundTransparency = Edit.Transparency

        if Edit.Icon then
            local iconData = GetIcon(Edit.Icon)
            if not OpenBtnIcon then
                OpenBtnIcon = VoidUI:Create("ImageLabel", {
                    Parent = OpenClickBtn,
                    Size = UDim2.new(0, 22, 0, 22),
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    ZIndex = 203,
                    ThemeID = { ImageColor3 = "IconColor" },
                })
            end
            if typeof(iconData) == "table" then
                OpenBtnIcon.Image = iconData.Image or ""
                if iconData.ImageRectOffset then OpenBtnIcon.ImageRectOffset = iconData.ImageRectOffset end
                if iconData.ImageRectSize then OpenBtnIcon.ImageRectSize = iconData.ImageRectSize end
            elseif typeof(iconData) == "string" then
                OpenBtnIcon.Image = iconData
            end
            UIIcon = OpenBtnIcon
        end

        if Edit.Color then
            local stroke = OpenButton:FindFirstChildOfClass("UIStroke")
            if stroke and stroke:FindFirstChildOfClass("UIGradient") then
                stroke.UIGradient.Color = Edit.Color
                stroke.UIGradient.Rotation = Edit.Rotation
            end
        end
        local stroke = OpenButton:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Thickness = Edit.StrokeThickness
            if stroke:FindFirstChildOfClass("UIGradient") then
                stroke.UIGradient.Rotation = Edit.Rotation
            end
        end
        if Edit.AutoRotation then
            coroutine.wrap(function()
                local strokeGrad = OpenButton:FindFirstChildOfClass("UIStroke")
                strokeGrad = strokeGrad and strokeGrad:FindFirstChildOfClass("UIGradient")
                while Edit.AutoRotation and OpenButton and OpenButton.Parent and strokeGrad do
                    strokeGrad.Rotation = (strokeGrad.Rotation + Edit.Speed * task.wait()) % 360
                end
            end)()
        end
        return Window, Edit
    end

    if Window.KeySystem and Window.KeySystem.KeyValidator then
        local KeyConfig = Window.KeySystem
        local KeyNote = KeyConfig.Note or "Keyless will be enabled every weekend."
        local DiscordURL = KeyConfig.Discord or "https://discord.gg/"

        local KeyFrame = VoidUI:Create("Frame", {
            Parent = UIScreen,
            Size = UDim2.new(0, 350, 0, 320),
            ClipsDescendants = true,
            Active = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(16, 16, 16),
            ZIndex = 200,
            ThemeID = { BackgroundColor3 = "Background" }
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 14) }),
            VoidUI:Create("UIStroke", {
                Color = Color3.fromRGB(48, 48, 48),
                Thickness = 1,
            }),
        })

        -- Header
        local Header = VoidUI:Create("Frame", {
            Parent = KeyFrame,
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundTransparency = 1,
            ZIndex = 201,
        })

        local LockIcon = VoidUI:Create("ImageLabel", {
            Parent = Header,
            Size = UDim2.new(0, 15, 0, 15),
            Position = UDim2.new(0, 16, 0, 14),
            BackgroundTransparency = 1,
            Image = GetIcon("lock"),
            ImageColor3 = Color3.fromRGB(175, 175, 175),
            ZIndex = 202,
        })

        local HeaderLabel = VoidUI:Create("TextLabel", {
            Parent = Header,
            Size = UDim2.new(0, 110, 0, 18),
            Position = UDim2.new(0, 36, 0, 13),
            BackgroundTransparency = 1,
            Text = "KEY SYSTEM",
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
            TextSize = 11,
            TextColor3 = Color3.fromRGB(175, 175, 175),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 202,
        })

        local CloseBtn = VoidUI:Create("ImageButton", {
            Parent = Header,
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(1, -40, 0, 8),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Image = GetIcon("x"),
            ImageColor3 = Color3.fromRGB(210, 210, 210),
            ZIndex = 202,
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            VoidUI:Create("UIStroke", {
                Color = Color3.fromRGB(50, 50, 50),
                Thickness = 1,
            }),
        })
        CloseBtn.MouseButton1Click:Connect(function()
            UIScreen:Destroy()
        end)

        -- Main Title
        local MainTitle = VoidUI:Create("TextLabel", {
            Parent = KeyFrame,
            Size = UDim2.new(1, -32, 0, 58),
            Position = UDim2.new(0, 16, 0, 46),
            BackgroundTransparency = 1,
            Text = "Welcome to\n" .. (KeyConfig.HubName or "Void Hub X"),
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold),
            TextSize = 24,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 201,
        })

        -- Input Container
        local InputContainer = VoidUI:Create("Frame", {
            Parent = KeyFrame,
            Size = UDim2.new(1, -32, 0, 40),
            Position = UDim2.new(0, 16, 0, 116),
            BackgroundColor3 = Color3.fromRGB(26, 26, 26),
            ZIndex = 201,
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        })

        local KeyBoxStroke = VoidUI:Create("UIStroke", {
            Parent = InputContainer,
            Color = Color3.fromRGB(45, 45, 45),
            Thickness = 1.15,
        })

        local KeyBox = VoidUI:Create("TextBox", {
            Parent = InputContainer,
            Size = UDim2.new(1, -46, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = "",
            PlaceholderText = "Enter your key...",
            PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
            TextSize = 13,
            TextColor3 = Color3.fromRGB(240, 240, 240),
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            ZIndex = 202,
        }, {
            VoidUI:Create("UIPadding", {
                PaddingLeft = UDim.new(0, 14),
                PaddingRight = UDim.new(0, 6),
            }),
        })

        -- Status badge (filled circle)
        local StatusBadge = VoidUI:Create("Frame", {
            Parent = InputContainer,
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(1, -31, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(40, 180, 80),
            Visible = false,
            ZIndex = 203,
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        })

        local StatusIcon = VoidUI:Create("ImageLabel", {
            Parent = StatusBadge,
            Size = UDim2.new(0, 13, 0, 13),
            Position = UDim2.new(0.5, -6.5, 0.5, -6.5),
            BackgroundTransparency = 1,
            Image = GetIcon("check"),
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ZIndex = 204,
        })

        -- Status message (error = red, success = green)
        local StatusLabel = VoidUI:Create("TextLabel", {
            Parent = KeyFrame,
            Size = UDim2.new(1, -32, 0, 18),
            Position = UDim2.new(0, 16, 0, 160),
            BackgroundTransparency = 1,
            Text = "",
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
            TextSize = 12,
            TextColor3 = Color3.fromRGB(255, 70, 70),
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = false,
            ZIndex = 202,
        })

        -- Load saved key
        if not isfolder("VoidUI/" .. (Window.Folder or "Temp")) then
            makefolder("VoidUI/" .. (Window.Folder or "Temp"))
        end
        if isfile("VoidUI/" .. (Window.Folder or "Temp") .. "/key.json") then
            local ok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile("VoidUI/" .. (Window.Folder or "Temp") .. "/key.json"))
            end)
            if ok and data and data.key then
                KeyBox.Text = data.key
            end
        end

        -- Submit Button (TextTransparency = 0 is critical - DefaultProps sets it to 1)
        local SubmitBtn = VoidUI:Create("TextButton", {
            Parent = KeyFrame,
            Size = UDim2.new(1, -32, 0, 42),
            Position = UDim2.new(0, 16, 0, 186),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Text = "Submit Key  >",
            TextTransparency = 0,
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false,
            ZIndex = 202,
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        })

        -- Discord Link
        local DiscordRow = VoidUI:Create("Frame", {
            Parent = KeyFrame,
            Size = UDim2.new(1, -32, 0, 22),
            Position = UDim2.new(0, 16, 0, 242),
            BackgroundTransparency = 1,
            ZIndex = 201,
        })

        local DiscordFull = VoidUI:Create("TextButton", {
            Parent = DiscordRow,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextTransparency = 1,
            AutoButtonColor = false,
            ZIndex = 202,
        })

        local DiscordPrefix = VoidUI:Create("TextLabel", {
            Parent = DiscordFull,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(0.5, -2, 0.5, 0),
            BackgroundTransparency = 1,
            Text = "Need support? ",
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
            TextSize = 12,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 203,
        })

        local DiscordLink = VoidUI:Create("TextLabel", {
            Parent = DiscordFull,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0.5, 2, 0.5, 0),
            BackgroundTransparency = 1,
            Text = "Join the Discord",
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
            TextSize = 12,
            TextColor3 = Color3.fromRGB(140, 120, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 203,
        })

        DiscordFull.MouseButton1Click:Connect(function()
            pcall(function() setclipboard(DiscordURL) end)
            DiscordLink.Text = "Link copied!"
            DiscordLink.TextColor3 = Color3.fromRGB(90, 200, 110)
            task.wait(1.2)
            DiscordLink.Text = "Join the Discord"
            DiscordLink.TextColor3 = Color3.fromRGB(140, 120, 255)
        end)

        -- Footer
        local Footer = VoidUI:Create("Frame", {
            Parent = KeyFrame,
            Size = UDim2.new(1, -32, 0, 42),
            Position = UDim2.new(0, 16, 1, -48),
            BackgroundTransparency = 1,
            ZIndex = 201,
        })

        local InfoIcon = VoidUI:Create("ImageLabel", {
            Parent = Footer,
            Size = UDim2.new(0, 13, 0, 13),
            Position = UDim2.new(0, 0, 0, 4),
            BackgroundTransparency = 1,
            Image = GetIcon("info"),
            ImageColor3 = Color3.fromRGB(115, 115, 115),
            ZIndex = 202,
        })

        local NoteLabel = VoidUI:Create("TextLabel", {
            Parent = Footer,
            Size = UDim2.new(0.55, 0, 0, 30),
            Position = UDim2.new(0, 18, 0, 1),
            BackgroundTransparency = 1,
            Text = KeyNote,
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
            TextSize = 10,
            TextColor3 = Color3.fromRGB(115, 115, 115),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            ZIndex = 202,
        })

        local BrandLabel = VoidUI:Create("TextLabel", {
            Parent = Footer,
            Size = UDim2.new(0.42, 0, 0, 32),
            Position = UDim2.new(0.58, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = (KeyConfig.HubName or "Void Hub X") .. "\nby Slowzzx4",
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
            TextSize = 10,
            TextColor3 = Color3.fromRGB(130, 130, 130),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 202,
        })

        -- Status helper
        local function SetStatus(state)
            if state == "success" then
                StatusBadge.Visible = true
                StatusBadge.BackgroundColor3 = Color3.fromRGB(40, 175, 75)
                StatusIcon.Image = GetIcon("check")
                StatusIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                KeyBoxStroke.Color = Color3.fromRGB(40, 160, 70)
            elseif state == "error" then
                StatusBadge.Visible = true
                StatusBadge.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
                StatusIcon.Image = GetIcon("x")
                StatusIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                KeyBoxStroke.Color = Color3.fromRGB(190, 50, 50)
            else
                StatusBadge.Visible = false
                KeyBoxStroke.Color = Color3.fromRGB(45, 45, 45)
            end
        end

        -- Submit Logic
        local thread = coroutine.running()
        SubmitBtn.MouseButton1Click:Connect(function()
            local inputKey = KeyBox.Text:gsub("%s+", "")
            if inputKey == "" then
                StatusLabel.Text = "⚠  Invalid key. Please check and try again."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
                StatusLabel.Visible = true
                SetStatus("error")
                SubmitBtn.Text = "Submit Key  >"
                SubmitBtn.TextTransparency = 0
                SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(175, 40, 40)
                task.wait(1.5)
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                SetStatus(nil)
                StatusLabel.Visible = false
                return
            end

            SubmitBtn.Text = "Submit Key  >"
            SubmitBtn.TextTransparency = 0
            StatusLabel.Visible = false
            SetStatus(nil)

            local valid = false
            if KeyConfig.KeyValidator then
                local ok, result = pcall(KeyConfig.KeyValidator, inputKey)
                valid = ok and result == true
            end

            if valid then
                writefile("VoidUI/" .. (Window.Folder or "Temp") .. "/key.json",
                    game:GetService("HttpService"):JSONEncode({ key = inputKey })
                )
                -- Success state
                SubmitBtn.Text = "Submit Key  >"
                SubmitBtn.TextTransparency = 0
                SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(42, 135, 62)
                StatusLabel.Text = "✓  Key accepted! Loading..."
                StatusLabel.TextColor3 = Color3.fromRGB(70, 200, 100)
                StatusLabel.Visible = true
                SetStatus("success")
                KeyBox.TextColor3 = Color3.fromRGB(240, 240, 240)
                task.wait(0.85)
                KeyFrame:Destroy()
                coroutine.resume(thread)
            else
                -- Error state
                SubmitBtn.Text = "Submit Key  >"
                SubmitBtn.TextTransparency = 0
                SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(175, 40, 40)
                StatusLabel.Text = "⚠  Invalid key. Please check and try again."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
                StatusLabel.Visible = true
                SetStatus("error")
                KeyBox.TextColor3 = Color3.fromRGB(240, 240, 240)
                task.wait(1.5)
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                SetStatus(nil)
                StatusLabel.Visible = false
            end
        end)

        coroutine.yield()
    end

    local Main = VoidUI:Create("Frame", {
        Name = Window.Name,
        Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset),
        ClipsDescendants = false, -- Permite que o botão de resize fique fora da UI
        Active = true,
        BorderColor3 = Color3.new(0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0), -- centro (PC / Android / iPhone)
        BackgroundTransparency = (Window.Transparent and 0.1 or 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Parent = UIScreen,
        ThemeID = {
            BackgroundColor3 = "Background"
        }
    }, {
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("Frame", {
            Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset-8),--Window.Topbar.Height),
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            --Active = true,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 8),
            BorderSizePixel = 0,
            ZIndex = 2,
        }, {
            VoidUI:Create("UIPadding", {
                PaddingLeft = UDim.new(0, 5),
            }),
            VoidUI:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
            }),
        }),
        VoidUI:Create("UIScale", {
            Scale = 1,
        }),
    })

    -- ============ BACKGROUND (estilo WindUI) ============
    local BackgroundLayer = VoidUI:Create("Frame", {
        Name = "BackgroundLayer",
        Parent = Main,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 0,
        ClipsDescendants = true,
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
    })

    local BackgroundImage = VoidUI:Create("ImageLabel", {
        Name = "BackgroundImage",
        Parent = BackgroundLayer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 0,
        Visible = false,
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
    })

    local BackgroundGradientFrame = VoidUI:Create("Frame", {
        Name = "BackgroundGradient",
        Parent = BackgroundLayer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        ZIndex = 0,
        Visible = false,
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
        VoidUI:Create("UIGradient", {
            Name = "Grad",
            Rotation = 45,
            Color = ColorSequence.new(Color3.fromRGB(30, 30, 40), Color3.fromRGB(10, 10, 15)),
        }),
    })

    Window.BackgroundImageTransparency = 0.35

    function Window:SetBackgroundImage(image, transparency)
        BackgroundGradientFrame.Visible = false
        BackgroundImage.Visible = true
        local img = image
        if typeof(img) == "number" then
            img = "rbxassetid://" .. tostring(img)
        elseif typeof(img) == "string" then
            local digits = img:match("%d+")
            if digits and not img:find("rbxassetid://") and not img:find("http") then
                img = "rbxassetid://" .. digits
            end
        end
        if typeof(img) == "string" and img ~= "" then
            BackgroundImage.Image = img
        end
        local t = transparency
        if t == nil then t = Window.BackgroundImageTransparency or 0.35 end
        Window.BackgroundImageTransparency = t
        -- deixa o fundo do Main mais transparente para a imagem aparecer
        Utility:TweenObject(Main, { BackgroundTransparency = math.clamp(0.55 + t * 0.3, 0.4, 0.85) }, 0.2)
        BackgroundImage.ImageTransparency = 1
        BackgroundImage.ZIndex = 0
        BackgroundLayer.ZIndex = 0
        Utility:TweenObject(BackgroundImage, { ImageTransparency = t }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        return Window
    end

    function Window:SetBackgroundGradient(colorSeq, rotation, transparency)
        BackgroundImage.Visible = false
        BackgroundGradientFrame.Visible = true
        local grad = BackgroundGradientFrame:FindFirstChild("Grad")
        if grad then
            if colorSeq then grad.Color = colorSeq end
            if rotation then grad.Rotation = rotation end
        end
        local t = transparency
        if t == nil then t = 0.15 end
        BackgroundGradientFrame.BackgroundTransparency = 1
        Utility:TweenObject(BackgroundGradientFrame, { BackgroundTransparency = t }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        return Window
    end

    function Window:SetBackgroundColor(color)
        BackgroundImage.Visible = false
        BackgroundGradientFrame.Visible = false
        if typeof(color) == "Color3" then
            Utility:TweenObject(Main, { BackgroundColor3 = color }, 0.2)
        end
        return Window
    end

    function Window:ClearBackground()
        BackgroundImage.Visible = false
        BackgroundGradientFrame.Visible = false
        BackgroundImage.Image = ""
        BackgroundImage.ImageTransparency = 1
        BackgroundGradientFrame.BackgroundTransparency = 1
        Utility:TweenObject(Main, {
            BackgroundTransparency = (Window.Transparent and 0.1 or 0)
        }, 0.2)
        return Window
    end

    function Window:SetBackgroundImageTransparency(t)
        Window.BackgroundImageTransparency = t
        if BackgroundImage.Visible then
            Utility:TweenObject(BackgroundImage, { ImageTransparency = t }, 0.15)
        end
        return Window
    end
    -- ============ FIM BACKGROUND ============

    -- Linha branca embaixo da UI (estilo WindUI / Main.lua) para mover a janela
    local WindowDragBar = VoidUI:Create("Frame", {
        Parent = Main,
        Name = "WindowDragBar",
        Size = UDim2.new(0, 56, 0, 5),
        Position = UDim2.new(0.5, 0, 1, 8),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ZIndex = 500,
        Active = true,
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        VoidUI:Create("TextButton", {
            Name = "Hit",
            Size = UDim2.new(1, 24, 1, 20),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Text = "",
            TextTransparency = 1,
            ZIndex = 501,
        }),
    })
    WindowDragBar.MouseEnter:Connect(function()
        Utility:TweenObject(WindowDragBar, {BackgroundTransparency = 0.3}, 0.1)
    end)
    WindowDragBar.MouseLeave:Connect(function()
        Utility:TweenObject(WindowDragBar, {BackgroundTransparency = 0.75}, 0.15)
    end)

    local TopBarF1 = VoidUI:Create("Frame", {
        Parent = Main.Frame,
        Size = UDim2.new(0, Window.Size.X.Offset - 182 + 133 + 5, 0, Window.Topbar.Height), --Window.Size.X.Offset - 10 + 133 + 5
        --ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        BackgroundTransparency = 0.1,
        LayoutOrder = 1,
        Position = UDim2.new(0, 0, 0, 8),
        BorderSizePixel = 0,
        ZIndex = 3,
        ThemeID = {
            BackgroundColor3 = "SideBar"
        }
    }, {
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = "Round",
            Thickness = 0.6,
            ThemeID = {
                Color = "Outline"
            }
        },{
            VoidUI:Create("UIGradient", {
                Color = ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), 
                    Color3.fromRGB(255, 255, 255)
                ),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = -110
            })
        }),
        VoidUI:Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            --ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(33, 33, 33),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Position = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 3,
        }, {
            VoidUI:Create("UIPadding", {
                --PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 0),
                PaddingTop = UDim.new(0, 0),
            }),
        }),
    })
    TopBarF1.Size = UDim2.new(0,Window.Size.X.Offset - 5 - 5 - 5- 187,0,Window.Topbar.Height)

    local LibName = VoidUI:Create("TextLabel", {
        Parent = TopBarF1.Frame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        RichText = true,
        Size = UDim2.new(1, 0, 0, 35),
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Text = Window.Name,
        AutomaticSize = "Y",
        TextSize = 13,
        ZIndex = 5,
        TextWrapped = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Window.Author and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        ThemeID = {
            TextColor3 = "Text"
        }
    }, {
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, Window.Icon and 45 or 12),
            PaddingTop = Window.Author and UDim.new(0, 6) or UDim.new(0, 0),
        })
    })

    local LibAuthor = VoidUI:Create("TextLabel", {
        Parent = TopBarF1.Frame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        RichText = true,
        Size = UDim2.new(1, 0, 0, 35),
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Text = Window.Author or "",
        AutomaticSize = "Y",
        TextTransparency = 0.5,
        TextSize = 13,
        ZIndex = 5,
        TextWrapped = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = Window.Author,
        ThemeID = {
            TextColor3 = "Text"
        }
    }, {
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, Window.Icon and 45 or 12),
            PaddingTop = UDim.new(0, 13),
        })
    })

    if Window.Icon then
        local UIIcon = VoidUI:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Image = GetIcon(Window.Icon),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 25, 0, 25),
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = TopBarF1,
            ThemeID = { ImageColor3 = "IconColor"}
        })
    end

    local TopBarF2 = VoidUI:Create("Frame", {
        Parent = Main.Frame,
        Size = UDim2.new(0, 133, 0, Window.Topbar.Height),
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        Visible = false,
        LayoutOrder = 2,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(0, 0, 0, 8),
        BorderSizePixel = 0,
        ZIndex = 3,
        ThemeID = {
            BackgroundColor3 = "SideBar"
        }
    }, {
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = "Round",
            Thickness = 0.6,
            ThemeID = {
                Color = "Outline"
            }
        },{
            VoidUI:Create("UIGradient", {
                Color = ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), 
                    Color3.fromRGB(255, 255, 255)
                ),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = -110
            })
        }),
        VoidUI:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = "Right",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
        }),
        VoidUI:Create("UIPadding", {
            --PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 4),
        }),
    })

    local TopBarF3 = VoidUI:Create("Frame", {
        Parent = Main.Frame,
        Size = UDim2.new(0, 187, 0, Window.Topbar.Height),
        --ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        LayoutOrder = 3,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(0, 0, 0, 8),
        BorderSizePixel = 0,
        ZIndex = 3,
        ThemeID = {
            BackgroundColor3 = "SideBar"
        }
    }, {
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = "Round",
            Thickness = 0.6,
            ThemeID = {
                Color = "Outline"
            }
        },{
            VoidUI:Create("UIGradient", {
                Color = ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), 
                    Color3.fromRGB(255, 255, 255)
                ),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = -110
            })
        }),
    })

    -- Arrastar só pelo topbar e pela linha branca (não a janela inteira)
    enableDragging(Main, {TopBarF1, TopBarF3, WindowDragBar, WindowDragBar.Hit})

    function UI:Dialog(Config)

        local Dialog = {
            Title = Config.Title or "Dialog",
            Desc = Config.Desc or nil,
            Buttons = Config.Buttons or {},
            Image = Config.Image or nil,
            ImageSizeY = Config.ImageSizeY or 60,
            Count = 0,
        }

        local Overlay = VoidUI:Create("Frame", {
            Parent = Main,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.1,
            Active = true,
            ZIndex = 1000,
            ThemeID = {
                BackgroundColor3 = "Background"
            }
        }, {
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, 16),
            }),
        })

        local DialogFrame = VoidUI:Create("Frame", {
            Parent = Overlay,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 190, 0, 0),
            ClipsDescendants = true,
            --AutomaticSize = "Y",
            Active = true,
            ZIndex = 1001,
            ThemeID = {
                BackgroundColor3 = "Dialog.Background|SideBar"
            }
        }, {
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, 16),
            }),
            VoidUI:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
            }),
            VoidUI:Create("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
            }),
        })
        DialogFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Utility:TweenObject(DialogFrame, {Size = UDim2.new(0, 200, 0, DialogFrame.UIListLayout.AbsoluteContentSize.Y + 20)}, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end)

        local Image
        if Dialog.Image then
            Image = VoidUI:Create("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 180, 0, Dialog.ImageSizeY),
                ZIndex = 1002,
                ScaleType = "Crop",
                Parent = DialogFrame,
            }, {
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(0, 16),
                }),
            })
            Image.Image = Dialog.Image
        end

        Text(DialogFrame, Dialog.Title, {
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            RichText = true,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = "Y",
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            Text = Dialog.Title,
            TextSize = 14,
            ZIndex = 1002,
            TextWrapped = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            ThemeID = {
                TextColor3 = "Dialog.Text|Text"
            }
        })

        if Dialog.Desc then
            Text(DialogFrame, Dialog.Desc, {
                Parent = DialogFrame,
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                RichText = true,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = "Y",
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                TextSize = 12,
                TextTransparency = 0.5,
                ZIndex = 1002,
                TextWrapped = true,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Dialog.Text|Text"
                }
            })
        end

        if Dialog.Buttons then
            local ButtonsFrame = VoidUI:Create("Frame", {
                Parent = DialogFrame,
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex = 1002,
            }, {
                VoidUI:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6),
                }),
            })

            local Rows = {}
            for i = 1, #Dialog.Buttons, 2 do
                table.insert(Rows, {Dialog.Buttons[i], Dialog.Buttons[i + 1]})
            end

            for rowIndex, Row in ipairs(Rows) do
                local RowFrame = VoidUI:Create("Frame", {
                    Parent = ButtonsFrame,
                    LayoutOrder = rowIndex,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    ZIndex = 1002,
                }, {
                    VoidUI:Create("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 6),
                    }),
                })

                local ButtonsInRow = 0
                for _, cfg in ipairs(Row) do
                    if cfg then
                        ButtonsInRow = ButtonsInRow + 1
                    end
                end

                for colIndex, ButtonConfig in ipairs(Row) do
                    Dialog.Count = Dialog.Count + 1

                    local Width
                    if ButtonsInRow == 1 then
                        Width = UDim2.new(1, 0, 1, 0)
                    else
                        Width = UDim2.new(0.5, -3, 1, 0)
                    end

                    local Button = VoidUI:Create("TextButton", {
                        Parent = RowFrame,
                        LayoutOrder = colIndex,
                        Size = Width,
                        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                        AutoButtonColor = false,
                        Text = "",
                        ZIndex = 1002,
                        ThemeID = {
                            BackgroundColor3 = "Dialog.Button|ElementColor"
                        }
                    }, {
                        VoidUI:Create("UICorner", {
                            CornerRadius = UDim.new(0, 10),
                        }),
                        VoidUI:Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 1, 0),
                            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                            Text = ButtonConfig.Text or "Button",
                            TextSize = 14,
                            ZIndex = 1002,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextXAlignment = Enum.TextXAlignment.Center,
                            ThemeID = {
                                TextColor3 = "Text"
                            }
                        }),
                    })

                    Button.MouseButton1Click:Connect(function()
                        if ButtonConfig.Callback then
                            ButtonConfig.Callback()
                        end
                        Utility:TweenObject(Overlay, {Transparency = 1}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        Utility:TweenObject(DialogFrame, {Size = UDim2.new(0, 200, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        task.wait(0.2)
                        Overlay:Destroy()
                    end)
                end
            end
        end
        return Dialog
    end
    local TopBarBC = 0
    function UI:CreateTopbarButton(Config)
        TopBarF2.Visible = true
        TopBarBC += 1

        if TopBarBC > 4 then
            TopBarBC = 4
        end
        TopBarF2.Size = UDim2.new(0, (37 * TopBarBC) + (-5 * (TopBarBC - 1)), 0, 35)
        TopBarF1.Size = UDim2.new(0,Window.Size.X.Offset - 5 - 5 - 5 - 5 -TopBarF2.Size.X.Offset - 187,0,35)
        --TopBarF2.Size = UDim2.new(0, (37 * TopBarBC) + (-5 * (TopBarBC - 1)), 0, 35)
        --Window.Size.X.Offset - 173 + 133 + 5
        --TopBarF1.Size = UDim2.new(0, Window.Size.X.Offset - 208 - TopBarF2.Size.X.Offset, 0, 35)
        --TopBarF1.Size = UDim2.new(0, 270 - TopBarF2.Size.X.Offset, 0, 35)

        local TopBarButton = {
            Icon = Config.Icon or "bird",
            Callback = Config.Callback or function() end,
            Order = Config.Order or 1,
        }
        local TopButton = VoidUI:Create("Frame", {
            Parent = TopBarF2,
            Size = UDim2.new(0, 27, 0, 27),
            BackgroundTransparency = 0.6,
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(44, 44, 44),
            Active = true,
            LayoutOrder = TopBarButton.Order,
            Position = UDim2.new(0, 0, 0, 8),
            BorderSizePixel = 0,
            ZIndex = 3,
            ThemeID = {
                BackgroundColor3 = "Background"
            }
        }, {
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),
            VoidUI:Create("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                LineJoinMode = "Round",
                Thickness = 0.6,
                ThemeID = {
                    Color = "Outline"
                }
            },{
                VoidUI:Create("UIGradient", {
                    Color = ColorSequence.new(
                        Color3.fromRGB(255, 255, 255), 
                        Color3.fromRGB(255, 255, 255)
                    ),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.1),
                        NumberSequenceKeypoint.new(0.5, 1),
                        NumberSequenceKeypoint.new(1, 1)
                    }),
                    Rotation = -110
                })
            }),
        })
        local Icon = VoidUI:Create("ImageButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = GetIcon(TopBarButton.Icon),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 16, 0, 16),
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = TopButton,
            ThemeID = {
                ImageColor3 = "IconColor"
            }
        })

        Icon.MouseButton1Click:Connect(function()
            spawn(function() pcall(TopBarButton.Callback) end)
            Utility:TweenObject(TopButton, {Transparency = 0}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            task.wait(0.1)
            Utility:TweenObject(TopButton, {Transparency = 0.6}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end)
    end
    function UI:CreateTopbarToggle(Config)
        TopBarF2.Visible = true
        TopBarBC += 1
        if TopBarBC > 4 then
            TopBarBC = 4
        end
        TopBarF2.Size = UDim2.new(0, (37 * TopBarBC) + (-5 * (TopBarBC - 1)), 0, 35)
        TopBarF1.Size = UDim2.new(0,Window.Size.X.Offset - 5 - 5 - 5 - 5 -TopBarF2.Size.X.Offset - 187,0,35)

        local TopBarToggle = {
            Icon = Config.Icon or "bird",
            Callback = Config.Callback or function() end,
            Order = Config.Order or 1,
            Default = Config.Default or false,
            EnableIcon = Config.EnableIcon or Config.Icon,
            DisableIcon = Config.DisableIcon or Config.Icon,
            EnableBackground = Config.EnableBackground or nil,
            DisableBackground = Config.DisableBackground or nil,
        }
        local TopToggle = VoidUI:Create("Frame", {
            Parent = TopBarF2,
            Size = UDim2.new(0, 27, 0, 27),
            BackgroundTransparency = 0.6,
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(44, 44, 44),
            Active = true,
            LayoutOrder = TopBarToggle.Order,
            Position = UDim2.new(0, 0, 0, 8),
            BorderSizePixel = 0,
            ZIndex = 3,
            ThemeID = {
                BackgroundColor3 = "Background"
            }
        }, {
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),
            VoidUI:Create("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                LineJoinMode = "Round",
                Thickness = 0.6,
                ThemeID = {
                    Color = "Outline"
                }
            },{
                VoidUI:Create("UIGradient", {
                    Color = ColorSequence.new(
                        Color3.fromRGB(255, 255, 255), 
                        Color3.fromRGB(255, 255, 255)
                    ),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.1),
                        NumberSequenceKeypoint.new(0.5, 1),
                        NumberSequenceKeypoint.new(1, 1)
                    }),
                    Rotation = -110
                })
            }),
        })
        local Icon = VoidUI:Create("ImageButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = GetIcon(TopBarToggle.Icon),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 16, 0, 16),
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = TopToggle,
            ThemeID = {
                ImageColor3 = "IconColor"
            }
        })

		local function updateToggleState()
    		Utility:TweenObject(TopToggle, {BackgroundTransparency = TopBarToggle.Default and 0 or 0.6}, 0.2)
            Utility:TweenObject(TopToggle, {BackgroundColor3 = (TopBarToggle.Default and TopBarToggle.EnableBackground and TopBarToggle.EnableBackground or Color3.fromRGB(44, 44, 44) or TopBarToggle.DisableBackground and TopBarToggle.DisableBackground or Color3.fromRGB(44, 44, 44))}, 0.2)
            Icon.Image = not TopBarToggle.Default and GetIcon(TopBarToggle.EnableIcon) or GetIcon(TopBarToggle.DisableIcon)
    		--Utility:TweenObject(ToggleScroll, {BackgroundColor3 = Toggle.Default and UI.Theme.ToggleModule.ScrollNew or UI.Theme.ToggleModule.Scroll}, 0.2)
    		task.spawn(function()
        		pcall(TopBarToggle.Callback, TopBarToggle.Default)
    		end)
		end

		updateToggleState()

		Icon.MouseButton1Click:Connect(function()
    		TopBarToggle.Default = not TopBarToggle.Default
    		updateToggleState()
		end)
		return TopBarToggle
    end
    local Tags = 0
    function Window:Tag(Config)
        Tags = Tags + 1

        local TagFrame = Main:FindFirstChild("TagFrame")
        if not TagFrame and Tags > 0 then
            TagFrame = VoidUI:Create("Frame", {
                Name = "TagFrame",
                Parent = Main,
                AnchorPoint = Vector2.new(.97, 1),
                Position = UDim2.new(.97, 0, 1, -5),
                Size = UDim2.new(0, Window.Size.X.Offset-Window.SideBarWidth-8, 0, 35),
                ClipsDescendants = true,
                Active = true,
                ZIndex = 200,
                ThemeID = {
                    BackgroundColor3 = "SideBar"
                },
            },{
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(0,16)
                }),
                VoidUI:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = "Left",
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 5)
                }),
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 5),
                })
            })
        end

        local Tag = {
            Name = Config.Name or "Tag",
            Icon = Config.Icon,
            Color = Config.Color,
            Corner = Config.Corner or 16,
        }
        local TagF = VoidUI:Create("Frame", {
            Parent = TagFrame,
            Size = UDim2.new(0, 20, 0, 25),
            AutomaticSize = "X",
            ClipsDescendants = true,
            Active = true,
            ZIndex = 201,
            BackgroundColor3 = Tag.Color or Color3.fromRGB(255, 255, 255),
        },{
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, Tag.Corner)
            }),
            VoidUI:Create("UIPadding", {
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5)
            })
        })
        local Title = VoidUI:Create("TextLabel", {
            Size = UDim2.new(0, 0, 0, 13),
            Parent = TagF,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            AutomaticSize = "X",
            BackgroundTransparency = 1,
            ZIndex = 203,
            Text = Tag.Name,
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            TextSize = 12,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            RichText = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ThemeID = {
                TextColor3 = "Tag.Text|Text"
            }
        }, {
            VoidUI:Create("UIPadding", {
                PaddingLeft = UDim.new(0, 0)
            })
        })
        local Icon
        if Tag.Icon then
            Icon = VoidUI:Create("ImageLabel", {
                AnchorPoint = Vector2.new(.04, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(.04, 0, 0.5, 0),
                Image = GetIcon(Tag.Icon),
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(0, 15, 0, 15),
                ZIndex = 202,
                Parent = TagF,
                ImageTransparency = 0,
                ThemeID = {
                    ImageColor3 = "Tag.Icon|IconColor"
                }
            })
            Title.UIPadding.PaddingLeft = UDim.new(0,22)
        end
        function Tag:SetTitle(i)
            Title.Text = i
        end
        function Tag:SetColor(i)
            TagF.BackgroundColor3 = i
        end
        function Tag:SetCorner(i)
            TagF.UICorner.CornerRadius = UDim.new(0, i)
        end
        return Tag
    end
    local SearchF1 = VoidUI:Create("Frame", {
        Parent = TopBarF3,
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 27, 0, 25),
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Active = true,
        LayoutOrder = 3,
        Position = UDim2.new(0, 7, 0.5, 0),
        BorderSizePixel = 0,
        ZIndex = 3,
        ThemeID = {
            BackgroundColor3 = "Search.Background|Background"
        },
    }, {
        VoidUI:Create("Frame", {
            Size = UDim2.new(0, 16, 0, 25),
            AnchorPoint = Vector2.new(1, 0.5),
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Active = true,
            LayoutOrder = 3,
            Position = UDim2.new(1, 0, 0.5, 0),
            BorderSizePixel = 0,
            ZIndex = 3,
            ThemeID = {
                BackgroundColor3 = "Search.Background|Background"
            },
        }),
        VoidUI:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Image = IconsV2.GetIcon("search"),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Position = UDim2.new(0, 6, 0.5, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 15, 0, 15),
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = TopBarF1,
            ThemeID = {
                ImageColor3 = "IconColor"
            }
        }),
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = "Round",
            Thickness = 0.6,
            ThemeID = {
                Color = "Outline"
            }
        },{
            VoidUI:Create("UIGradient", {
                Color = ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), 
                    Color3.fromRGB(255, 255, 255)
                ),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = -110
            })
        }),
    })

    local SearchF2 = VoidUI:Create("Frame", {
        Parent = TopBarF3,
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 75, 0, 25),
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Active = true,
        LayoutOrder = 3,
        Position = UDim2.new(0, 38, 0.5, 0),
        BorderSizePixel = 0,
        ZIndex = 3,
        ThemeID = {
            BackgroundColor3 = "Search.Background|Background"
        }
    }, {
        VoidUI:Create("Frame", {
            Size = UDim2.new(0, 16, 0, 25),
            AnchorPoint = Vector2.new(0, 0.5),
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Active = true,
            LayoutOrder = 3,
            Position = UDim2.new(0, 0, 0.5, 0),
            BorderSizePixel = 0,
            ZIndex = 3,
            ThemeID = {
                BackgroundColor3 = "Search.Background|Background"
            }
        }),
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = "Round",
            Thickness = 0.6,
            ThemeID = {
                Color = "Outline"
            }
        },{
            VoidUI:Create("UIGradient", {
                Color = ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), 
                    Color3.fromRGB(255, 255, 255)
                ),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = -110
            })
        }),
    })

    local WinElements = VoidUI:Create("Frame", {
        Parent = TopBarF3,
        Size = UDim2.new(0, 96, 0, 35),
        AnchorPoint = Vector2.new(0.98, 0.5),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Active = true,
        LayoutOrder = 3,
        Position = UDim2.new(0.98, 0, 0.5, 0),
        BorderSizePixel = 0,
        ZIndex = 100,
    },{
        VoidUI:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = "Right",
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
        }),
        VoidUI:Create("UIPadding", {
            PaddingRight = UDim.new(0, 4),
        }),
        VoidUI:Create("ImageButton", {
            Name = "Cross",
            AnchorPoint = Vector2.new(0, 0.5),
            Image = IconsV2.GetIcon("x"),
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.new(0, 22, 0, 22),
            BorderSizePixel = 0,
            ZIndex = 101,
            ThemeID = {
                ImageColor3 = "IconColor"
            }
        }),
        VoidUI:Create("ImageButton", {
            Name = "Fullscreen",
            AnchorPoint = Vector2.new(0, 0.5),
            Image = IconsV2.GetIcon("maximize") or ResolveIconImage("maximize"),
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.new(0, 20, 0, 20),
            BorderSizePixel = 0,
            ZIndex = 101,
            ThemeID = {
                ImageColor3 = "IconColor"
            }
        }),
        VoidUI:Create("ImageButton", {
            Name = "Minimize",
            AnchorPoint = Vector2.new(0, 0.5),
            Image = IconsV2.GetIcon("minus"),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.new(0, 22, 0, 22),
            BorderSizePixel = 0,
            ZIndex = 101,
            ThemeID = {
                ImageColor3 = "IconColor"
            }
        }),
        VoidUI:Create("UIPadding", {
            --PaddingLeft = UDim.new(0, 5),
            --PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 4),
        }),
    })

    local SearchBox = VoidUI:Create("TextBox", {
        Parent = SearchF2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ClearTextOnFocus = false,
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Color3.fromRGB(140, 140, 140),
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 11,
        ZIndex = 101,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeID = {
            TextColor3 = "Search.Text|Text",
        }
    },{
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
        })
    })

    local SearchFrame = VoidUI:Create("Frame", {
            Parent = TopBarF3,
            Size = UDim2.new(1, 0, 0, 0),
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0, 25),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Active = true,
            LayoutOrder = 3,
            BorderSizePixel = 0,
            ZIndex = 200,
            BackgroundTransparency = 1,
            ThemeID = {
                BackgroundColor3 = "Search.Background|Background"
            }
    },{
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = "Round",
            Thickness = 0,
            ThemeID = {
                Color = "Outline"
            }
        },{
            VoidUI:Create("UIGradient", {
                Color = ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), 
                    Color3.fromRGB(255, 255, 255)
                ),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = -110
            })
        }),
    })
    local SearchScroll = VoidUI:Create("ScrollingFrame", {
        Parent = SearchFrame,
        Active = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticCanvasSize = "Y",
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0.96, 0),
        ZIndex = 250,
        ScrollBarThickness = 0
    },{
        VoidUI:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        }),
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 10),
        })
    })

    function ClearSearchResults()
        for _, v in ipairs(SearchScroll:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                v:Destroy()
            end
        end
    end

    SearchScroll.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SearchScroll.CanvasSize = UDim2.new(0, 0, 0, SearchScroll.UIListLayout.AbsoluteContentSize.Y)
    end)
    function CreateSearchRow(entry)
        local Row = VoidUI:Create("TextButton", {
            Parent = SearchScroll,
            Size = UDim2.new(1, -10, 0, 32),
            BackgroundTransparency = 0.2,
            BackgroundColor3 = Color3.fromRGB(40,40,40),
            Active = true,
            Text = "",
            ZIndex = 251,
            ThemeID = {
                BackgroundColor3 = "Seach.Background|ElementColor"
            }
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
            VoidUI:Create("UIPadding", { PaddingTop = UDim.new(0, 10) }),
        })

        local Icon = VoidUI:Create("ImageLabel", {
            Parent = Row,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 10, 0, -2),
            BackgroundTransparency = 1,
            ZIndex = 252,
            Image = GetIcon(entry.Icon or "circle"),
            ThemeID = {
                ImageColor3 = "Search.Icon|IconColor"
            }
        })

        Text(Row, entry.Title, {
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            ZIndex = 252,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextXAlignment = Enum.TextXAlignment.Left,
            ThemeID = {
                TextColor3 = "Search.Text|Text"
            }
        })

        Row.MouseButton1Click:Connect(function()
            entry.SelectFn()
            SearchBox.Text = ""
            ClearSearchResults()
        end)
    end


    local function RenderSearch(query)
        ClearSearchResults()

        local q = string.lower(query)

        for _, entry in ipairs(Window.SearchIndex) do
            local haystack = string.lower(entry.Title .. " " .. (entry.Desc or ""))

            if q ~= "" and string.find(haystack, q, 1, true) then
                CreateSearchRow(entry)
            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        RenderSearch(SearchBox.Text)
    end)

    SearchBox.Focused:Connect(function()
        Utility:TweenObject(SearchFrame, {BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 135), Position = UDim2.new(0, 0, 0, Window.Topbar.Height + 5)}, 0.2)
        Utility:TweenObject(SearchFrame.UIStroke, {Thickness = 0.6}, 0.1)
        --Utility:TweenObject(SearchFrame, {Size = UDim2.new(1, 0, 0, 200)}, 0.2)
        SearchBox.TextTransparency = 0
    end)

    SearchBox.FocusLost:Connect(function()
        task.wait(0.1)
        Utility:TweenObject(SearchFrame, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 25)}, 0.2)
        Utility:TweenObject(SearchFrame.UIStroke, {Thickness = 0}, 0.1)
        -- mantém o texto digitado (não apaga)
        SearchBox.TextTransparency = 0
        if (SearchBox.Text or "") == "" then
            ClearSearchResults()
        end
    end)

    local TabFrame = VoidUI:Create("Frame", {
        Size = UDim2.new(0, Window.SideBarWidth, 0, Window.Size.Y.Offset - Window.Topbar.Height - 13),
        ClipsDescendants = true,
        Active = true,
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0, 0, 0, Window.Topbar.Height+13),
        BorderSizePixel = 0,
        ZIndex = 3,
        BackgroundTransparency = (Window.Transparent and 1 or 0),
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        Parent = Main,
        ThemeID = {
            BackgroundColor3 = "SideBar"
        }
    },{
        VoidUI:Create("Frame", {
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = (Window.Transparent and 1 or 0),
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundColor3 = Color3.fromRGB(33, 33, 33),
            BorderSizePixel = 0,
            ZIndex = 4,
            ThemeID = {
                BackgroundColor3 = "SideBar"
            }
        }),
        VoidUI:Create("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = (Window.Transparent and 1 or 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundColor3 = Color3.fromRGB(33, 33, 33),
            BorderSizePixel = 0,
            ZIndex = 4,
            ThemeID = {
                BackgroundColor3 = "SideBar"
            }
        }),
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
    })

    --USER
    local UserFrame = VoidUI:Create("Frame", {
        Parent = TabFrame,
        AnchorPoint = Vector2.new(0.5, 0.96),
        Position = UDim2.new(0.5, 0, 0.96, 0),
        BorderColor3 = Color3.new(0, 0, 0),
        ClipsDescendants = true,
        Size = UDim2.new(0, Window.SideBarWidth - 20, 0, 40),
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        ZIndex = 10,
        ThemeID = {
            BackgroundColor3 = "Background"
        }
    },{
        VoidUI:Create("UICorner", {
            CornerRadius = UDim.new(0, 16),
        }),
        VoidUI:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.075, 0.5),
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0.075, 0, 0.5, 0),
            Size = UDim2.new(0, 25, 0, 25),
            ZIndex = 11,
            Image = (function()
                return game:GetService("Players"):GetUserThumbnailAsync(Window.User.Anonymous and 1 or game.Players.LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
            end)(),
        },{
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, 64),
            }),
        }),
        VoidUI:Create("TextButton", {
            Visible = Window.User.Callback and true or false,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextTransparency = 1,
            ZIndex = 100,
        }),
    })
    UserFrame.TextButton.MouseButton1Click:Connect(function()
        task.spawn(Window.User.Callback)
    end)
    local function TruncateName(str, maxLen)
        str = tostring(str or "")
        maxLen = maxLen or 14
        if #str > maxLen then
            return string.sub(str, 1, maxLen - 1) .. "…"
        end
        return str
    end

    local UserTitle = VoidUI:Create("TextLabel", {
        Parent = UserFrame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        RichText = false,
        Size = UDim2.new(1, -8, 1, 0),
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Text = Window.User.Anonymous and "Anonymous" or TruncateName(game.Players.LocalPlayer.DisplayName, 14),
        TextTransparency = 0,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 11,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = Window.Author,
        ThemeID = {
            TextColor3 = "User.Text|Text"
        }
    }, {
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0,40),
            PaddingBottom = UDim.new(0,15)
        })
    })
    local UserSub = VoidUI:Create("TextLabel", {
        Parent = UserFrame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        RichText = false,
        Size = UDim2.new(1, -8, 1, 0),
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Text = Window.User.Anonymous and "@Anonymous" or "@"..TruncateName(game.Players.LocalPlayer.Name, 12),
        TextTransparency = 0.6,
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 11,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = Window.Author,
        ThemeID = {
            TextColor3 = "User.Text|Text"
        }
    }, {
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0,40),
            PaddingTop = UDim.new(0,15)
        })
    })

    UserFrame.Visible = Window.User.Enabled or false
    --endUser

    local LeftScroll = VoidUI:Create("ScrollingFrame", {
        Parent = TabFrame,
        Active = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0., 0),
        Size = UDim2.new(1, 0, 1, (Window.User.Enabled and -50) or -10),
        ScrollBarThickness = 0
    },{
        VoidUI:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        }),
        VoidUI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 10),
        })
    })
    LeftScroll.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        -- Atualiza o tamanho do Canvas para caber todas as abas + um pequeno espaço no final (20 pixels)
        LeftScroll.CanvasSize = UDim2.new(0, 0, 0, LeftScroll.UIListLayout.AbsoluteContentSize.Y + 20)
    end)

    local ElementFolder = VoidUI:Create("Folder", {
        Parent = Main,
    })

    Window.TabList = Window.TabList or {}
    function Window:SelectTab(i)
        if Window.TabList[i] and Window.TabList[i].Select then
            Window.TabList[i].Select()
        end
    end

    function Window:Tab(Config, type)
        local Tab = {
            Title = Config.Title or "Tab",
            Icon = Config.Icon or nil,
            Border = Config.Border or false,
            Callback = Config.Callback or function() end
        }

        local TabBack = VoidUI:Create("Frame", {
            Parent = type or LeftScroll,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            AutomaticSize = "Y",
            BorderColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = Tab.Border and 0.6 or 1,
            Size = UDim2.new(0, Window.SideBarWidth - 10, 0, 25),
            BackgroundColor3 = Color3.fromRGB(59, 59, 59),
            BorderSizePixel = 0,
            ZIndex = 4,
            ThemeID = {
                BackgroundColor3 = "Tab.Background|ElementColor"
            }
        },{
            VoidUI:Create("TextButton", {
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 6,
            }),
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),
            VoidUI:Create("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                LineJoinMode = "Round",
                Thickness = 0.6,
                ThemeID = {
                    Color = "Outline"
                }
            },{
                VoidUI:Create("UIGradient", {
                    Color = ColorSequence.new(
                        Color3.fromRGB(255, 255, 255), 
                        Color3.fromRGB(255, 255, 255)
                    ),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.1),
                        NumberSequenceKeypoint.new(0.5, 1),
                        NumberSequenceKeypoint.new(1, 1)
                    }),
                    Rotation = -110
                })
            }),
            VoidUI:Create("UIPadding", {
                PaddingBottom = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5),
            })
        })
        local TabTitle = VoidUI:Create("TextLabel", {
            Parent = TabBack,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            RichText = true,
            Size = UDim2.new(1, 0, 0, 25),
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            Text = Tab.Title,
            AutomaticSize = "Y",
            TextTransparency = 0,
            TextSize = 13,
            ZIndex = 5,
            TextWrapped = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = Window.Author,
            ThemeID = {
                TextColor3 = "Tab.Text|Text"
            }
        }, {
            VoidUI:Create("UIPadding", {
                PaddingLeft = UDim.new(0,10)
            })
        })
        local TabIcon
        if Tab.Icon then
            TabIcon = VoidUI:Create("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Image = GetIcon(Tab.Icon),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0.5, 0),
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(0, 19, 0, 19),
                BorderSizePixel = 0,
                ZIndex = 5,
                Parent = TabBack,
                ThemeID = {
                    ImageColor3 = "Tab.IconColor|IconColor"
                }
            })
            TabTitle.UIPadding.PaddingLeft = UDim.new(0,31)
        end
        TabBack.BackgroundTransparency = 1
        TabTitle.TextTransparency = 0.5
        TabBack.UIStroke.Transparency = 1
        if TabIcon then
            TabIcon.ImageTransparency = 0.5
        end
        
        local ElementFrame = VoidUI:Create("Frame", {
            Parent = ElementFolder,
            AnchorPoint = Vector2.new(.97, 0),
            Position = UDim2.new(.97, 0, 0, Window.Topbar.Height+13),
            BorderColor3 = Color3.new(0, 0, 0),
            ClipsDescendants = true,
            BackgroundTransparency = 0.6,
            Size = UDim2.new(1, Window.Size.X.Offset-Window.SideBarWidth-8, 0, 0),
            BackgroundColor3 = Color3.fromRGB(33, 33, 33),
            ZIndex = 4,
            ThemeID = {
                BackgroundColor3 = "SideBar"
            }
        },{
            VoidUI:Create("UICorner", {
                CornerRadius = UDim.new(0, 16),
            }),
        })
        local RightScroll = VoidUI:Create("ScrollingFrame", {
            Parent = ElementFrame,
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            CanvasSize = UDim2.new(0,0,0,0),
            Position = UDim2.new(0,0,0,5),
            Size = UDim2.new(1, 0, 0.95, 0),
            ScrollBarThickness = 3,
            ZIndex = 10,
            --AutomaticSize = Y
        },{
            VoidUI:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4)
            }),
            VoidUI:Create("UIPadding", {
                --PaddingTop = UDim.new(0,5),
                PaddingBottom = UDim.new(0,5),
                PaddingLeft = UDim.new(0,5)
            })
        })

        RightScroll.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            RightScroll.CanvasSize = UDim2.new(0, RightScroll.UIListLayout.AbsoluteContentSize.X, 0, RightScroll.UIListLayout.AbsoluteContentSize.Y)
        end)
       local function SelectTab()
            for i, v in next, ElementFolder:GetChildren() do
                if v:IsA("GuiObject") then
                    v.Visible = false
                    v.Size = UDim2.new(0, Window.Size.X.Offset-Window.SideBarWidth-8, 0, 0)
                end
            end
            ElementFrame.Visible = true
            RightScroll.Visible = true
            Window.ActiveElementFrame = ElementFrame
            Utility:TweenObject(ElementFrame, {Size = UDim2.new(0, Window.Size.X.Offset-Window.SideBarWidth-8, 0, Window.Size.Y.Offset - Window.Topbar.Height-20 - (Tags > 0 and 37 or 0))}, 0.15)
            Utility:TweenObject(ElementFrame, {BackgroundTransparency = 0.2}, 0.2)
            for _, v in next, Window.Tabs do
                Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2)
                for _, obj in ipairs(v:GetChildren()) do
                    if obj:IsA("TextLabel") then
                        Utility:TweenObject(obj, {TextTransparency = 0.5}, 0.2)
                    elseif obj:IsA("UIStroke") then
                        Utility:TweenObject(obj, {Transparency = 1}, 0.2)
                    elseif obj:IsA("ImageLabel") then
                        Utility:TweenObject(obj, {ImageTransparency = 0.5}, 0.2)
                    end
                end
            end
            Utility:TweenObject(TabBack, {BackgroundTransparency = (Tab.Border and 0.6 or 1)}, 0.2)
            Utility:TweenObject(TabBack.UIStroke, {Transparency = (Tab.Border and 0 or 1)}, 0.2)
            Utility:TweenObject(TabTitle, {TextTransparency = 0}, 0.2)
            if TabIcon then
                Utility:TweenObject(TabIcon, {ImageTransparency = 0}, 0.2)
            end
            Tab.Callback()
        end

        TabBack.TextButton.MouseButton1Click:Connect(function()
            SelectTab()
        end)
        Tab.Select = SelectTab

        table.insert(Window.Tabs, TabBack)
        table.insert(Window.TabOrder, Tab.Title)
        table.insert(Window.TabList, Tab)
        --Window.SearchIndex[Tab.Title] = {}

        --print(Config.Parent)
        function Tab:Paragraph(Config,type)
            local Paragraph = {
                Title = Config.Title or "Paragraph",
                Desc = Config.Desc or nil,
                Icon = Config.Icon or nil,
                Color = Config.Color,
                Thumbnail = Config.Thumbnail,
                ThumbnailPos = Config.ThumbnailPos or "Up",
                ScaleType = Config.ScaleType or "Crop",
                ThumbnailSize = Config.ThumbnailSize or 100,
                SizeY = 40
            }
            local Colors = {
                Red    = Color3.fromRGB(255, 45, 85),
                Green  = Color3.fromRGB(52, 255, 130),
                Blue   = Color3.fromRGB(64, 156, 255),
                Orange = Color3.fromRGB(255, 159, 10),
                Purple = Color3.fromRGB(191, 90, 255),
                Yellow = Color3.fromRGB(255, 224, 20),
                Pink   = Color3.fromRGB(255, 55, 130),
                Cyan   = Color3.fromRGB(50, 220, 255),
                Mint   = Color3.fromRGB(50, 255, 200),
                Coral  = Color3.fromRGB(255, 100, 60),
            }
            local ResolvedColor = nil
            if typeof(Paragraph.Color) == "Color3" then
                ResolvedColor = Paragraph.Color
            elseif typeof(Paragraph.Color) == "string" then
                ResolvedColor = Colors[Paragraph.Color]
                if not ResolvedColor then
                    warn("VoidUI: Unknown color name '" .. Paragraph.Color .. "'")
                end
            end
            local ParagraphThemeID = nil
            if not ResolvedColor then
                ParagraphThemeID = {BackgroundColor3 = "Paragraph.Background|ElementColor"}
            end
            local StrokeThemeID = nil
            if not ResolvedColor then
                StrokeThemeID = {Color = "Outline"}
            end
            local ParagraphFrame = VoidUI:Create("Frame", {
                Parent = RightScroll,
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BorderColor3 = Color3.new(0, 0, 0),
                AutomaticSize = "Y",
                ClipsDescendants = true,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(0, ElementFrame.Size.X.Offset - 10, 0, Paragraph.SizeY),
                BackgroundColor3 = Color3.fromRGB(43, 43, 43),
                BorderSizePixel = 0,
                ZIndex = 15,
                BackgroundColor3 = ResolvedColor,
                ThemeID = ParagraphThemeID
            },{
                VoidUI:Create("UIStroke", {
                    Color = ResolvedColor,
                    LineJoinMode = "Round",
                    Thickness = 0.6,
                    ThemeID = StrokeThemeID
                },{
                    VoidUI:Create("UIGradient", {
                        Color = ColorSequence.new(
                            Color3.fromRGB(255, 255, 255), 
                            Color3.fromRGB(255, 255, 255)
                        ),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = -110
                    })
                }),
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(0, 12),
                }),
                VoidUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0,5),
                    PaddingLeft = UDim.new(0,5),
                    PaddingBottom = UDim.new(0,5)
                }),
                VoidUI:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 1)
                }),
                VoidUI:Create("Frame", {
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Size = UDim2.new(1, 0, 0, 0),
                    LayoutOrder = 2,
                    ClipsDescendants = true,
                    ZIndex = 16,
                },{
                    VoidUI:Create("Frame", {
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Size = UDim2.new(1, 0, 0, 0),
                        ClipsDescendants = true,
                        ZIndex = 16,
                    },{
                        VoidUI:Create("UIListLayout", {
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            Padding = UDim.new(0, 1)
                        }),
                        VoidUI:Create("UIPadding", {
                            PaddingTop = UDim.new(0,9),
                        })
                    })
                }),
            })

            local Thumbnail
            if Paragraph.Thumbnail then
                Thumbnail = VoidUI:Create("ImageLabel", {
                    AnchorPoint = Vector2.new(0.1, 0.5),
                    Image = Paragraph.Thumbnail,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.1, 0, 0.5, 0),
                    BorderColor3 = Color3.new(0, 0, 0),
                    Size = UDim2.new(1, -5, 0, Paragraph.ThumbnailSize),
                    ScaleType = Paragraph.ScaleType,
                    ZIndex = 17,
                    LayoutOrder = (Paragraph.ThumbnailPos == "Up") and 1 or 3,
                    Parent = ParagraphFrame,
                    ImageTransparency = 0,
                    ThemeID = {
                        ImageColor3 = "Paragraph.IconColor|IconColor"
                    },
                },{
                    VoidUI:Create("UICorner", {
                        CornerRadius = UDim.new(0, 16),
                    }),
                })
            end

            local Title = Text(ParagraphFrame.Frame.Frame, Paragraph.Title, {
                Size = UDim2.new(0, 0, 0, 5),
                AutomaticSize = "XY",
                ZIndex = 16,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                TextSize = 13,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                RichText = true,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Paragraph.Text|Text"
                }
            }, {
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 5)
                })
            })
            Title.Position = UDim2.new(0, 0, 0, 0)
            local Desc = Text(ParagraphFrame.Frame.Frame, Paragraph.Desc, {
                Size = UDim2.new(0, 0, 0, 5),
                AutomaticSize = "XY",
                ZIndex = 16,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                TextSize = 12,
                TextTransparency = 0.7,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                RichText = true,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = Paragraph.Desc ~= nil,
                ThemeID = {
                    TextColor3 = "Paragraph.Text|Text"
                }
            }, {
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 5)
                })
            })
            local Icon
            if Paragraph.Icon then
                Icon = VoidUI:Create("ImageLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = GetIcon(Paragraph.Icon),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0.5, 0),
                    BorderColor3 = Color3.new(0, 0, 0),
                    Size = UDim2.new(0, 22, 0, 22),
                    ZIndex = 17,
                    Parent = ParagraphFrame.Frame,
                    ImageTransparency = 0,
                    ThemeID = {
                        ImageColor3 = "Paragraph.IconColor|IconColor"
                    }
                })
                Title.UIPadding.PaddingLeft = UDim.new(0,35)
                Desc.UIPadding.PaddingLeft = UDim.new(0,35)
            end

            function Paragraph:SetTitle(Text)
                Title.SetText(Text)
            end
            function Paragraph:SetThumbnail(v)
                if Paragraph.Thumbnail then Paragraph.Thumbnail.Image = v else warn("Thumbnail Not Found In Paragraph!") end
            end

            function Paragraph:SetPos(v)
                if Paragraph.Thumbnail then Paragraph.Thumbnail.LayoutOrder = (v == "Up") and 1 or 3 else warn("Thumbnail Not Found In Paragraph!") end
            end

            function Paragraph:SetThumbnailSize(v)
                if Paragraph.Thumbnail then Paragraph.Thumbnail.Size = UDim2.new(1, -5, 0, v) else warn("Thumbnail Not Found In Paragraph!") end
            end

            table.insert(Window.SearchIndex, {
                Title = Paragraph.Title, Desc = Paragraph.Desc, Icon = Paragraph.Icon,
                Type = "Paragraph", TabTitle = Tab.Title,
                SelectFn = SelectTab, Frame = ParagraphFrame, RightScroll = RightScroll,
            })
            return Paragraph
        end

        function Tab:Button(Config)
            local Button = {
                Title = Config.Title or "Button",
                Desc = Config.Desc,
                Icon = Config.Icon or "mouse-pointer-click",
                Locked = Config.Locked,
                SizeY = Config.SizeY or 40,
                Callback = Config.Callback or function() end
            }

            local Beeee, ButtonFrame, Inner = Utility:Element(RightScroll, ElementFrame, Button.SizeY, "Button")
            local ButtonTRG = VoidUI:Create("TextButton", {
                Parent = Beeee,
                Size = UDim2.new(1,0,1,0),
                TextTransparency = 1,
                BackgroundTransparency = 1,
                ZIndex = 25,
            })
            local Title, Desc = Utility:ElText(Inner, Button.Title, Button.Desc, "Button")

            local Icon
            if Button.Icon then
                Icon = VoidUI:Create("ImageLabel", {
                    AnchorPoint = Vector2.new(.96, 0.5),
                    Image = GetIcon(Button.Icon),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(.96, 0, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    ZIndex = 16,
                    Parent = ButtonFrame,
                    ThemeID = { ImageColor3 = "Button.Text|Text"}
                })
            end

            function Button:Lock()
                Button.Locked = true
                LockedElm(Beeee, true)
                end
            function Button:UnLock()
                Button.Locked = false
                LockedElm(Beeee, false)
            end

            if Button.Locked then Button:Lock() end

            function Button:SetTitle(t)
                Title.SetText(t) 
            end
            function Button:SetDesc(t)
                Desc.Visible = true
                Desc.SetText(t)
            end
            function Button:Close() 
                Beeee:Destroy()
            end
            if Button.Desc then 
                Button:SetDesc(Button.Desc)
            end

            ButtonTRG.MouseEnter:Connect(function() 
                Utility:TweenObject(ButtonFrame, {BackgroundTransparency = 0.6}, 0.1) 
            end)
            ButtonTRG.MouseLeave:Connect(function()
                Utility:TweenObject(ButtonFrame, {BackgroundTransparency = 0.5}, 0.1) 
            end)
            ButtonTRG.MouseButton1Click:Connect(function()
                if Button.Locked then return end
                spawn(function() pcall(Button.Callback) end)
                Utility:TweenObject(ButtonFrame, {BackgroundTransparency = 0}, 0.1)
                wait(0.1)
                Utility:TweenObject(ButtonFrame, {BackgroundTransparency = 0.5}, 0.1)
            end)

            Utility:Search(Window, {Title = Button.Title, Desc = Button.Desc, Icon = "mouse-pointer-click",Type = "Button", TabTitle = Tab.Title, SelectFn = SelectTab, Frame = Beeee, RightScroll = RightScroll,})
            table.insert(Window.AllElements, Button)
            return Button
        end

        function Tab:Toggle(Config,type)
            local Togglee = {
                Title = Config.Title or "Toggle",
                Desc = Config.Desc,
                Icon = Config.Icon or "mouse-pointer-click",
                Default = Config.Default or false,
                SizeY = Config.SizeY or 40,
                Locked = Config.Locked,
                Callback = Config.Callback or function() end
            }
            local Beeee, ToggleFrame, Inner = Utility:Element(RightScroll, ElementFrame, Togglee.SizeY, "Toggle")
            local ToggleTRG = VoidUI:Create("TextButton", {
                Parent = Beeee,
                Size = UDim2.new(1, 0, 1, 0),
                TextTransparency = 1,
                BackgroundTransparency = 1,
                ZIndex = 25,
            })
            local Title, Desc = Utility:ElText(Inner, Togglee.Title, Togglee.Desc, "Button")

            -- Toggle estilo WindUI / imagem 2 (dark)
            local ToggleV = VoidUI:Create("Frame", {
                Parent = ToggleFrame,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                ClipsDescendants = true,
                BackgroundTransparency = 0,
                BackgroundColor3 = Color3.fromRGB(45, 45, 48),
                Size = UDim2.new(0, 40, 0, 22),
                ZIndex = 15,
            },{
                VoidUI:Create("Frame", {
                    Name = "Knob",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, 11, 0.5, 0),
                    ClipsDescendants = true,
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Color3.fromRGB(120, 120, 125),
                    Size = UDim2.new(0, 16, 0, 16),
                    ZIndex = 16,
                },{
                    VoidUI:Create("UICorner", {
                        CornerRadius = UDim.new(1, 0),
                    }),
                }),
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                }),
            })

            function Togglee:Lock()
                Togglee.Locked = true
                LockedElm(Beeee,true)
            end
            function Togglee:UnLock()
                Togglee.Locked = false
                LockedElm(Beeee,false)
            end
            if Togglee.Locked then
                Togglee:Lock()
            end
            function Togglee:SetTitle(Text)
                Title.SetText(Text)
            end

            function Togglee:SetDesc(Text)
                Desc.Visible = true
                Desc.SetText(Text)
            end

            function Togglee:Close()
                Togglee:Destroy()
            end

            if Togglee.Desc then
                Togglee:SetDesc(Togglee.Desc)
            end

            local Val = Togglee.Default

            function Togglee:SetValue(newValue)
                Val = newValue
                local knob = ToggleV:FindFirstChild("Knob") or ToggleV.Frame
                -- Dark fixo (imagem 2)
                if newValue then
                    Utility:TweenObject(ToggleV, {BackgroundColor3 = Color3.fromRGB(70, 70, 75)}, 0.18)
                    Utility:TweenObject(knob, {
                        Position = UDim2.new(0, 29, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0,
                    }, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                else
                    Utility:TweenObject(ToggleV, {BackgroundColor3 = Color3.fromRGB(45, 45, 48)}, 0.18)
                    Utility:TweenObject(knob, {
                        Position = UDim2.new(0, 11, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(120, 120, 125),
                        BackgroundTransparency = 0,
                    }, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                end

                spawn(function()
                    pcall(Togglee.Callback, Val)
                end)
                return Togglee
            end

            Togglee:SetValue(Val)
            local function pressKnob(pressed)
                local knob = ToggleV:FindFirstChild("Knob") or ToggleV.Frame
                Utility:TweenObject(knob, {
                    Size = pressed and UDim2.new(0, 16, 0, 12) or UDim2.new(0, 16, 0, 16)
                }, 0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            end
            ToggleTRG.MouseButton1Down:Connect(function() pressKnob(true) end)
            ToggleTRG.MouseButton1Up:Connect(function() pressKnob(false) end)
            ToggleTRG.MouseLeave:Connect(function() pressKnob(false) end)
            ToggleTRG.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    pressKnob(false)
                end
            end)
            ToggleTRG.MouseButton1Click:Connect(function()
                if Togglee.Locked then return end
                Val = not Val
                Togglee:SetValue(Val)
            end)
            Utility:Search(Window, {Title = Togglee.Title, Desc = Togglee.Desc, Icon = "toggle-left",Type = "Toggle", TabTitle = Tab.Title, SelectFn = SelectTab, Frame = Beeee, RightScroll = RightScroll,})
            table.insert(Window.AllElements, Togglee)
            return Togglee
        end
        function Tab:Slider(Config)
            local Slider = {
                Title = Config.Title or "Slider",
                Desc = Config.Desc or nil,
                Locked = Config.Locked or false,
                Step = Config.Step or 1,
                Value = Config.Value or { Min = 0, Max = 100, Default = 50 },
                Callback = Config.Callback or function() end,
                Locked = Config.Locked,
                SizeY = Config.SizeY or 40,
            }
            local Beeee, SliderElement, Inner = Utility:Element(RightScroll, ElementFrame, Slider.SizeY, "Slider")
            local Title, Desc = Utility:ElText(Inner, Slider.Title, Slider.Desc, "Button")

            local TextContainer = VoidUI:Create("Frame", {
                Parent = SliderElement,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ClipsDescendants = true,
                ZIndex = 16,
            }, {
                VoidUI:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 1),
                }),
                VoidUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 9),
                }),
            })

            local ValueFrame = VoidUI:Create("Frame", {
                Parent = SliderElement,
                AnchorPoint = Vector2.new(0.96, 0.5),
                Position = UDim2.new(0.96, -40, 0.5, 0),
                ClipsDescendants = true,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(0, 110, 0, 16),
                BorderSizePixel = 0,
                ZIndex = 15,
                ThemeID = {
                    BackgroundColor3 = "Slider.Placeholder|Placeholder"
                }
            }, {
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(0, 12),
                }),
                VoidUI:Create("UIStroke", {
                    LineJoinMode = "Round",
                    Thickness = 0.6,
                    ThemeID = {
                        Color = "Outline"
                    }
                }, {
                    VoidUI:Create("UIGradient", {
                        Color = ColorSequence.new(
                            Color3.fromRGB(255, 255, 255),
                            Color3.fromRGB(255, 255, 255)
                        ),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = -100
                    })
                }),
            })

            local DropValue = VoidUI:Create("Frame", {
                Parent = ValueFrame,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 16,
                ThemeID = {
                    BackgroundColor3 = "Slider.SliderPart|Text"
                }
            }, {
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(0, 12),
                }),
            })

            local BGFrame = VoidUI:Create("Frame", {
                Parent = SliderElement,
                AnchorPoint = Vector2.new(0.96, 0.5),
                Position = UDim2.new(0.96, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 0.5,
                Size = UDim2.new(0, 29, 0, 22),
                ClipsDescendants = true,
                BorderSizePixel = 0,
                ZIndex = 15,
                ThemeID = {
                    BackgroundColor3 = "Slider.Placeholder|Placeholder"
                }
            }, {
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                }),
                VoidUI:Create("UIStroke", {
                    LineJoinMode = "Round",
                    Thickness = 0.6,
                    ThemeID = {
                        Color = "Outline"
                    }
                }, {
                    VoidUI:Create("UIGradient", {
                        Color = ColorSequence.new(
                            Color3.fromRGB(255, 255, 255),
                            Color3.fromRGB(255, 255, 255)
                        ),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = -110
                    })
                }),
            })

            local SliderTRG = VoidUI:Create("TextButton", {
                Parent = ValueFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextTransparency = 1,
                ZIndex = 25,
            })

            local BGBox = VoidUI:Create("TextBox", {
                Parent = BGFrame,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                TextTransparency = 0,
                ZIndex = 16,
                Size = UDim2.new(1, 0, 1, 0),
                Text = tostring(Slider.Value.Default or 0),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                TextSize = 10,
                ThemeID = {
                    TextColor3 = "Slider.Text|Text"
                }
            })

            local ScrollFrame = VoidUI:Create("Frame", {
                Parent = DropValue,
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 0, -1.5, -5),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 35, 0, 20),
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 30,
                ThemeID = {
                    BackgroundColor3 = "Slider.Placeholder|Placeholder"
                }
            }, {
                VoidUI:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                }),
                VoidUI:Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextTransparency = 1,
                    TextSize = 11,
                    ZIndex = 31,
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                    ThemeID = {
                        TextColor3 = "Slider.Text|Text"
                    }
                }),
            })

            function Slider:Lock()
                Slider.Locked = true
                LockedElm(Beeee,true)
            end
            function Slider:UnLock()
                Slider.Locked = false
                LockedElm(Beeee,false)
            end
            if Slider.Locked then
                Slider:Lock()
            end

            local Value
            local moveconnection
            local releaseconnection
            local isTouch = false
            local isFocusing = false

            BGBox.Focused:Connect(function()
                isFocusing = true
            end)

            BGBox.FocusLost:Connect(function()
                if Slider.Locked then return end
                isFocusing = false
                if tonumber(BGBox.Text) then
                    local inputValue = tonumber(BGBox.Text)
                    local clampedValue = math.clamp(inputValue, Slider.Value.Min, Slider.Value.Max)
                    local roundedValue = math.round(clampedValue / Slider.Step) * Slider.Step
                    Value = roundedValue
                    BGBox.Text = tostring(Value)
                    DropValue.Size = UDim2.new(
                        (roundedValue - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min),
                        0, 1, 0
                    )
                    task.spawn(Slider.Callback, roundedValue)
                end
            end)

            local clampedDefault = math.clamp(Slider.Value.Default, Slider.Value.Min, Slider.Value.Max)
            Value = clampedDefault
            DropValue.Size = UDim2.new(
                (clampedDefault - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min),
                0, 1, 0
            )
            BGBox.Text = tostring(clampedDefault)
            task.spawn(Slider.Callback, clampedDefault)

            SliderTRG.InputBegan:Connect(function(input)
                if Slider.Locked then return end
                if not isFocusing and not HoldingSlider and (
                    input.UserInputType == Enum.UserInputType.MouseButton1 or
                    input.UserInputType == Enum.UserInputType.Touch
                ) then
                    isTouch = (input.UserInputType == Enum.UserInputType.Touch)
                    HoldingSlider = true

                    ScrollFrame.Visible = true
                    Utility:TweenObject(ScrollFrame, { BackgroundTransparency = 0.1 }, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    Utility:TweenObject(ScrollFrame:FindFirstChildOfClass("TextLabel"), { TextTransparency = 0 }, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                    if moveconnection then moveconnection:Disconnect() end
                    if releaseconnection then releaseconnection:Disconnect() end

                    moveconnection = game:GetService("RunService").RenderStepped:Connect(function()
                        local inputPosition
                        if isTouch then
                            inputPosition = input.Position.X
                        else
                            inputPosition = game:GetService("UserInputService"):GetMouseLocation().X
                        end

                        local delta = math.clamp(
                            (inputPosition - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X,
                            0, 1
                        )
                        Value = math.floor(
                            (Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min)) / Slider.Step + 0.5
                        ) * Slider.Step

                        Utility:TweenObject(DropValue, { Size = UDim2.new(delta, 0, 1, 0) }, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                        BGBox.Text = tostring(Value)
                        ScrollFrame:FindFirstChildOfClass("TextLabel").Text = tostring(Value)
                        ScrollFrame.Position = UDim2.new(delta, 0, -1.5, -5)

                        task.spawn(Slider.Callback, Value)
                    end)

                    releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(endInput)
                        if (
                            endInput.UserInputType == Enum.UserInputType.MouseButton1 or
                            endInput.UserInputType == Enum.UserInputType.Touch
                        ) and input == endInput then
                            if moveconnection then moveconnection:Disconnect() moveconnection = nil end
                            if releaseconnection then releaseconnection:Disconnect() releaseconnection = nil end
                            HoldingSlider = false

                            Utility:TweenObject(ScrollFrame, { BackgroundTransparency = 1 }, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                            Utility:TweenObject(ScrollFrame:FindFirstChildOfClass("TextLabel"), { TextTransparency = 1 }, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                            task.wait(0.1)
                            ScrollFrame.Visible = false
                        end
                    end)
                end
            end)

            function Slider:SetValue(val)
                local clamped = math.clamp(val, Slider.Value.Min, Slider.Value.Max)
                local rounded = math.round(clamped / Slider.Step) * Slider.Step
                Value = rounded
                BGBox.Text = tostring(rounded)
                Utility:TweenObject(DropValue, {Size = UDim2.new((rounded - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min),0, 1, 0)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                task.spawn(Slider.Callback, rounded)
            end

            function Slider:SetDesc(val)
                Desc.Frame.Visible = true
                Desc.SetText(val)
            end

            function Slider:Close()
                Beeee:Destroy()
            end
            Utility:Search(Window, {Title = Slider.Title, Desc = Slider.Desc, Icon = "settings-2",Type = "Slider", TabTitle = Tab.Title, SelectFn = SelectTab, Frame = Beeee, RightScroll = RightScroll,})
            table.insert(Window.AllElements, Slider)
            return Slider
        end
        function Tab:Dropdown(Config)
            local Dropdown = {
                Title = Config.Title or "Dropdown",
                Desc = Config.Desc,
                Value = Config.Value or "",
                Locked = Config.Locked or false,
                Multi = Config.Multi or false,
                Option = Config.Option or {},
                Options = {},
                Locked = Config.Locked,
                Callback = Config.Callback or function() end,
                ASpeed = 0.2
            }

            local DropDownElement = VoidUI:Create("Frame", {
                Parent = RightScroll,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutomaticSize = "Y",
                Size = UDim2.new(0, ElementFrame.Size.X.Offset - 10, 0, 40),
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                VoidUI:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 0)
                })
            })

            local DropFrame = VoidUI:Create("Frame", {
                Parent = DropDownElement,
                BackgroundColor3 = Color3.fromRGB(43, 43, 43),
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                ZIndex = 15,
                ThemeID = {
                    BackgroundColor3 = "Dropdown.Background|ElementColor"
                }
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 12) }),
                VoidUI:Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    LineJoinMode = "Round",
                    Thickness = 0.6,
                    ThemeID = { Color = "Outline" }
                }, {
                    VoidUI:Create("UIGradient", {
                        Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = -110
                    })
                }),
                VoidUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0,0),--5
                    PaddingBottom = UDim.new(0,0)--5
                }),
                VoidUI:Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ClipsDescendants = true,
                    ZIndex = 16,
                },{
                    VoidUI:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 1)
                    }),
                    VoidUI:Create("UIPadding", {
                        PaddingTop = UDim.new(0,9),
                    })
                })
            })

            local Title = Text(DropFrame.Frame, Dropdown.Title, {
                Size = UDim2.new(1, 0, 1, 0),
                AutomaticSize = "Y",
                ZIndex = 16,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                TextSize = 13,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                RichText = true,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Dropdown.Text|Text"
                }
            }, {
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    PaddingTop = UDim.new(0,5)
                }),
            })

            local Desc = Text(DropFrame, Dropdown.Desc, {
                Size = UDim2.new(1, -130, 0, 0),
                AutomaticSize = "Y",
                Position = UDim2.new(0, 10, 0, 22),
                ZIndex = 16,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                TextSize = 12,
                TextTransparency = 0.7,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                RichText = true,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Dropdown.Text|Text"
                }
            }, {
                VoidUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0,5)
                }),
            })

            local DropValueFrame = VoidUI:Create("Frame", {
                Parent = DropFrame,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 0.5,
                Size = UDim2.new(0, 119, 0, 25),
                ZIndex = 15,
                ThemeID = {
                    BackgroundColor3 = "Dropdown.Placeholder|Placeholder"
                }
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 12) }),
                VoidUI:Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.6,
                    ThemeID = { Color = "Outline" }
                }, {
                    VoidUI:Create("UIGradient", {
                        Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = -110
                    })
                })
            })

            local DropIcon = VoidUI:Create("ImageLabel", {
                Parent = DropValueFrame,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -4, 0.5, 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 17, 0, 17),
                Image = ResolveIconImage("chevron-down"),
                ZIndex = 16,
                ThemeID = {
                    ImageColor3 = "Dropdown.IconColor|IconColor"
                }
            })

            local DropOptionBox = VoidUI:Create("TextBox", {
                Parent = DropValueFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = tostring(Dropdown.Value or ""),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextSize = 10,
                ClipsDescendants = true,
                ClearTextOnFocus = false,
                TextEditable = false,
                ZIndex = 100,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ThemeID = {
                    TextColor3 = "Dropdown.Text|Text"
                }
            })

            local DropDownTRG = VoidUI:Create("TextButton", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 120,
            })

            -- Dropdown flutuante (estilo WindUI)
            local DropOpen = false
            local openTick = 0
            local FloatingMenu = nil
            local ScrollingFrame = nil
            local ListLayout = nil
            local SearchBox = nil
            local DropElementFrame = nil
            local lastDropSearch = ""

            local function destroyFloating()
                if FloatingMenu then
                    pcall(function() FloatingMenu:Destroy() end)
                    FloatingMenu = nil
                    ScrollingFrame = nil
                    ListLayout = nil
                    SearchBox = nil
                end
            end

            local selectingItem = false

            local function rebuildItemsInto(parentScroll)
                for _, child in ipairs(parentScroll:GetChildren()) do
                    if child:IsA("Frame") then child:Destroy() end
                end
                local items = Dropdown.Option or {}
                for idx, Item in ipairs(items) do
                    local selected = false
                    if Dropdown.Multi then
                        for _, v in ipairs(Dropdown.Options or {}) do
                            if v == Item then selected = true break end
                        end
                    else
                        selected = (Dropdown.Value == Item)
                    end

                    local row = VoidUI:Create("TextButton", {
                        Parent = parentScroll,
                        Size = UDim2.new(1, -6, 0, 30),
                        BackgroundTransparency = selected and 0.15 or 0.35,
                        BackgroundColor3 = selected and Color3.fromRGB(55, 55, 60) or Color3.fromRGB(28, 28, 30),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 920,
                        LayoutOrder = idx,
                        Active = true,
                    }, {
                        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                    })

                    local label = VoidUI:Create("TextLabel", {
                        Parent = row,
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1,
                        Text = tostring(Item),
                        TextTransparency = selected and 0 or 0.25,
                        TextSize = 13,
                        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 921,
                    })

                    local function pick()
                        if Dropdown.Locked then return end
                        selectingItem = true
                        if not Dropdown.Multi then
                            Dropdown.Value = Item
                            DropOptionBox.Text = tostring(Item)
                            task.spawn(Dropdown.Callback, Item)
                            closeDropdown()
                        else
                            local found = false
                            for i = #Dropdown.Options, 1, -1 do
                                if Dropdown.Options[i] == Item then
                                    table.remove(Dropdown.Options, i)
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                table.insert(Dropdown.Options, Item)
                            end
                            DropOptionBox.Text = table.concat(Dropdown.Options, ", ")
                            for _, r in ipairs(parentScroll:GetChildren()) do
                                if r:IsA("TextButton") then
                                    local lab = r:FindFirstChildOfClass("TextLabel")
                                    if lab then
                                        local isSel = false
                                        for _, ov in ipairs(Dropdown.Options) do
                                            if ov == lab.Text then isSel = true break end
                                        end
                                        r.BackgroundTransparency = isSel and 0.15 or 0.35
                                        r.BackgroundColor3 = isSel and Color3.fromRGB(55, 55, 60) or Color3.fromRGB(28, 28, 30)
                                        lab.TextTransparency = isSel and 0 or 0.25
                                    end
                                end
                            end
                            task.spawn(Dropdown.Callback, Dropdown.Options)
                        end
                        task.delay(0.05, function() selectingItem = false end)
                    end
                    row.MouseButton1Click:Connect(pick)
                    row.Activated:Connect(pick)
                end
            end

            local function closeDropdown()
                if not DropOpen and not FloatingMenu then return end
                DropOpen = false
                pcall(function()
                    Utility:TweenObject(DropIcon, {Rotation = 0}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                end)
                if SearchBox then
                    lastDropSearch = SearchBox.Text or lastDropSearch
                end
                if FloatingMenu then
                    local fm = FloatingMenu
                    FloatingMenu = nil
                    ScrollingFrame = nil
                    ListLayout = nil
                    SearchBox = nil
                    pcall(function() fm:Destroy() end)
                end
            end

            local function openDropdown()
                if Dropdown.Locked or DropOpen then return end
                DropOpen = true
                openTick = tick()
                destroyFloating()

                task.defer(function()
                    if not DropOpen then return end
                    local absPos = DropValueFrame.AbsolutePosition
                    local absSize = DropValueFrame.AbsoluteSize
                    local cam = workspace.CurrentCamera
                    local vw = cam and cam.ViewportSize.X or 800
                    local menuW = math.clamp(math.max(absSize.X + 50, 200), 160, math.min(320, vw - 20))
                    local menuH = math.min(math.max(#(Dropdown.Option or {}) * 32 + 48, 90), 240)

                    local posX = absPos.X + absSize.X - menuW
                    posX = math.clamp(posX, 8, math.max(8, vw - menuW - 8))
                    local posY = absPos.Y + absSize.Y + 6

                    FloatingMenu = VoidUI:Create("Frame", {
                        Parent = UIScreen,
                        Name = "VoidDropdownMenu",
                        Size = UDim2.new(0, menuW, 0, menuH),
                        Position = UDim2.new(0, posX, 0, posY),
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20),
                        BackgroundTransparency = 0.05,
                        ZIndex = 900,
                        ClipsDescendants = true,
                        Active = true,
                    }, {
                        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 12) }),
                        VoidUI:Create("UIStroke", {
                            Color = Color3.fromRGB(70, 70, 75),
                            Thickness = 1.2,
                        }),
                    })

                    local searchRow = VoidUI:Create("Frame", {
                        Parent = FloatingMenu,
                        Size = UDim2.new(1, -12, 0, 32),
                        Position = UDim2.new(0, 6, 0, 6),
                        BackgroundColor3 = UI.Theme.ElementColor,
                        BackgroundTransparency = Window.Transparent and 0.4 or 0.25,
                        ZIndex = 901,
                    }, {
                        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                    })

                    VoidUI:Create("ImageLabel", {
                        Parent = searchRow,
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new(0, 8, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Image = ResolveIconImage("search"),
                        ImageTransparency = 0.35,
                        ZIndex = 902,
                    })

                    SearchBox = VoidUI:Create("TextBox", {
                        Parent = searchRow,
                        Size = UDim2.new(1, -34, 1, 0),
                        Position = UDim2.new(0, 28, 0, 0),
                        BackgroundTransparency = 1,
                        Text = lastDropSearch or "",
                        PlaceholderText = "Search...",
                        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                        TextColor3 = UI.Theme.Text,
                        TextSize = 12,
                        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ClearTextOnFocus = false,
                        ZIndex = 902,
                    })

                    ScrollingFrame = VoidUI:Create("ScrollingFrame", {
                        Parent = FloatingMenu,
                        Position = UDim2.new(0, 4, 0, 42),
                        Size = UDim2.new(1, -8, 1, -48),
                        BackgroundTransparency = 1,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollBarThickness = 3,
                        ZIndex = 901,
                        Active = true,
                    }, {
                        VoidUI:Create("UIPadding", {
                            PaddingTop = UDim.new(0, 2),
                            PaddingBottom = UDim.new(0, 4),
                            PaddingLeft = UDim.new(0, 2),
                            PaddingRight = UDim.new(0, 2),
                        }),
                    })

                    ListLayout = VoidUI:Create("UIListLayout", {
                        Parent = ScrollingFrame,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 4),
                    })

                    rebuildItemsInto(ScrollingFrame)
                    Utility:TweenObject(DropIcon, {Rotation = 180}, 0.15)

                    local function filterList()
                        if not ScrollingFrame or not SearchBox then return end
                        lastDropSearch = SearchBox.Text or ""
                        local q = string.lower(lastDropSearch)
                        for _, v in ipairs(ScrollingFrame:GetChildren()) do
                            if v:IsA("Frame") then
                                local btn = v:FindFirstChildOfClass("TextButton")
                                if q == "" then
                                    v.Visible = true
                                else
                                    v.Visible = btn and string.find(string.lower(btn.Text), q, 1, true) ~= nil
                                end
                            end
                        end
                    end
                    SearchBox:GetPropertyChangedSignal("Text"):Connect(filterList)
                    if lastDropSearch ~= "" then filterList() end
                end)
            end

            UserInputService.InputBegan:Connect(function(input)
                if not DropOpen then return end
                if selectingItem then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                if tick() - openTick < 0.25 then return end
                task.delay(0.08, function()
                    if not DropOpen or not FloatingMenu or selectingItem then return end
                    local pos = input.Position
                    local ap = FloatingMenu.AbsolutePosition
                    local as = FloatingMenu.AbsoluteSize
                    local insideMenu = pos.X >= ap.X - 4 and pos.X <= ap.X + as.X + 4 and pos.Y >= ap.Y - 4 and pos.Y <= ap.Y + as.Y + 4
                    local vp = DropFrame.AbsolutePosition
                    local vs = DropFrame.AbsoluteSize
                    local insideDrop = pos.X >= vp.X and pos.X <= vp.X + vs.X and pos.Y >= vp.Y and pos.Y <= vp.Y + vs.Y
                    if not insideMenu and not insideDrop then
                        closeDropdown()
                    end
                end)
            end)

            function Dropdown:Lock()
                Dropdown.Locked = true
                LockedElm(DropFrame, true)
                closeDropdown()
            end
            function Dropdown:UnLock()
                Dropdown.Locked = false
                LockedElm(DropFrame, false)
            end
            if Dropdown.Locked then Dropdown:Lock() end

            local function onDropClick()
                if Dropdown.Locked then return end
                if DropOpen then
                    if tick() - openTick < 0.18 then return end
                    closeDropdown()
                else
                    openDropdown()
                end
            end
            DropDownTRG.MouseButton1Click:Connect(onDropClick)

            function Dropdown:Refresh(options)
                Dropdown.Option = options or Dropdown.Option
                if DropOpen and ScrollingFrame then
                    rebuildItemsInto(ScrollingFrame)
                end
                return Dropdown
            end

            function Dropdown:Close()
                DropDownElement:Destroy()
            end

            function Dropdown:SetTitle(Value)
                Title.Text = Value
            end

            function Dropdown:SetDesc(Text)
                Desc.Visible = true
                Desc.SetText(Text)
            end

            if Dropdown.Desc then
                Dropdown:SetDesc(Dropdown.Desc)
            end

            function Dropdown:SetValue(Value)
                DropOptionBox.Text = Value
                Dropdown.Value = Value
            end

            Dropdown:Refresh(Dropdown.Option)
            Utility:Search(Window, {Title = Dropdown.Title, Desc = Dropdown.Desc, Icon = "list",Type = "Dropdown", TabTitle = Tab.Title, SelectFn = SelectTab, Frame = DropDownElement, RightScroll = RightScroll,})
            table.insert(Window.AllElements, Dropdown)
            return Dropdown
        end

        function Tab:Input(Config)
            local Input = {
                Title = Config.Title or "Input",
                Desc = Config.Desc or nil,
                Value = Config.Value or "",
                Locked = Config.Locked or false,
                MaxSymbols = Config.MaxSymbols or nil,
                Callback = Config.Callback or function() end,
                SizeY = 40
            }
            local Beeee, InputElement, Inner = Utility:Element(RightScroll, ElementFrame, Input.SizeY, "Input")
            local Title, Desc = Utility:ElText(Inner, Input.Title, Input.Desc, "Button")
            
            local InputFrame = VoidUI:Create("Frame", {
                Parent = InputElement,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Size = UDim2.new(0, Input.MaxSymbols and 130 or 130, 0, 25),
                ZIndex = 15,
                ThemeID = { BackgroundColor3 = "Input.Placeholder|Placeholder" }
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 12) }),
                VoidUI:Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.6,
                    ThemeID = { Color = "Outline" }
                }, {
                    VoidUI:Create("UIGradient", {
                        Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = -110
                    })
                })
            })

            local InputBox = VoidUI:Create("TextBox", {
                Parent = InputFrame,
                BackgroundTransparency = 1,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, Input.MaxSymbols and -36 or -8, 1, 0),
                Text = Input.Value,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextSize = 10,
                ZIndex = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = { TextColor3 = "Text" }
            }, {
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 4)
                })
            })

            local MaxLabel
            if Input.MaxSymbols then
                MaxLabel = VoidUI:Create("TextLabel", {
                    Parent = InputFrame,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 30, 0, 17),
                    Text = "0/" .. Input.MaxSymbols,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                    TextSize = 9,
                    ZIndex = 16,
                    ThemeID = { TextColor3 = "Text" }
                })

                InputBox.Changed:Connect(function(prop)
                    if prop == "Text" then
                        if #InputBox.Text > Input.MaxSymbols then
                            InputBox.Text = string.sub(InputBox.Text, 1, Input.MaxSymbols)
                        end
                        MaxLabel.Text = #InputBox.Text .. "/" .. Input.MaxSymbols
                    end
                end)
            end

            function Input:Lock()
                Input.Locked = true
                LockedElm(Beeee,true)
            end
            function Input:UnLock()
                Input.Locked = false
                LockedElm(Beeee,false)
            end

            function Input:SetDesc(Value)
                Desc.Visible = true
                Desc.Text = Value
            end

            if Input.Desc then Input:SetDesc(Input.Desc) end

            local function fireCallback()
                local val = Input.MaxSymbols
                    and string.sub(InputBox.Text, 1, Input.MaxSymbols)
                    or InputBox.Text
                task.spawn(Input.Callback, val)
            end

            if Input.Locked then
                Input:Lock()
            else
                fireCallback()
            end

            InputBox.FocusLost:Connect(function(enterPressed)
                if Input.Locked then return end
                if not enterPressed then return end
                fireCallback()
            end)

            function Input:SetValue(Val)
                InputBox.Text = Val
                task.spawn(Input.Callback, Val)
            end

            function Input:SetTitle(Value)
                TitleLabel.Text = Value
            end

            if Input.Desc then
                Input:SetDesc(Input.Desc)
            end

            function Input:SetMaxSymbols(number)
                Input.MaxSymbols = number
                InputBox.MaxVisibleGraphemes = number
                if MaxLabel then
                    MaxLabel.Text = #InputBox.Text .. "/" .. number
                end
            end

            function Input:Close()
                InputElement:Destroy()
            end
            Utility:Search(Window, {Title = Input.Title, Desc = Input.Desc, Icon = "text-cursor-input",Type = "Input", TabTitle = Tab.Title, SelectFn = SelectTab, Frame = Beeee, RightScroll = RightScroll,})
            table.insert(Window.AllElements, Input)
            return Input
        end
        function Tab:Keybind(Config)
            local Keybind = {
                Title = Config.Title or "Keybind",
                Desc = Config.Desc or nil,
                Value = Config.Value or "F",
                Locked = Config.Locked,
                Callback = Config.Callback or function() end,
                SizeY = 40
            }
            local Beeee, KeybindElement, Inner = Utility:Element(RightScroll, ElementFrame, Keybind.SizeY, "Keybind")
            local Title, Desc = Utility:ElText(Inner, Keybind.Title, Keybind.Desc, "Keybind")

            local KeyFrame = VoidUI:Create("TextButton", {
                Parent = KeybindElement,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 28, 0, 20),
                TextTransparency = 0,
                ZIndex = 17,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                Text = Keybind.Value,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 11,
                ThemeID = {
                    BackgroundColor3 = "Keybind.Placeholder|Placeholder",
                    TextColor3 = "Keybind.Text|Text"
                }
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                VoidUI:Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.6,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    ThemeID = { Color = "Outline" }
                }, {
                    VoidUI:Create("UIGradient", {
                        Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = -110
                    })
                })
            })
            local listening = false

            function Keybind:Lock()
                Keybind.Locked = true
                LockedElm(Beeee,true)
            end
            function Keybind:UnLock()
                Keybind.Locked = false
                LockedElm(Beeee,false)
            end
            if Keybind.Locked then
                Keybind:Lock()
            end

            KeyFrame.MouseButton1Click:Connect(function()
                if Keybind.Locked then return end
                if listening then return end
                listening = true
                KeyFrame.Text = "..."

                local conn
                conn = game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        conn:Disconnect()
                        listening = false
                        local keyName = input.KeyCode.Name
                        KeyFrame.Text = keyName
                        Keybind.Value = keyName
                        task.spawn(Keybind.Callback, keyName)
                    end
                end)
            end)

            function Keybind:SetDesc(Value)
                Desc.Visible = true
                Desc.Text = Value
            end

            if Keybind.Desc then Keybind:SetDesc(Keybind.Desc) end

            function Keybind:SetValue(Val)
                KeyFrame.Text = Val
                Keybind.Value = Val
                task.spawn(Keybind.Callback, Val)
            end

            function Keybind:SetTitle(Value)
                Title.Text = Value
            end

            function Keybind:Close()
                Beeee:Destroy()
            end

            task.spawn(Keybind.Callback, Keybind.Value)
            Utility:Search(Window, {Title = Keybind.Title, Desc = Keybind.Desc, Icon = "keyboard",Type = "Keybind", TabTitle = Tab.Title, SelectFn = SelectTab, Frame = Beeee, RightScroll = RightScroll,})
            table.insert(Window.AllElements, Keybind)
            return Keybind
        end

        function Tab:Colorpicker(Config)
            local Colorpicker = {
                Title = Config.Title or "Colorpicker",
                Desc = Config.Desc,
                Default = Config.Default or Color3.fromRGB(255, 255, 255),
                Transparency = Config.Transparency,
                Locked = Config.Locked or false,
                Callback = Config.Callback or function() end,
            }

            local currentColor = Colorpicker.Default
            local h, s, v = Color3.toHSV(currentColor)
            local currentTransparency = Colorpicker.Transparency or 0

            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 42, "Colorpicker")
            local Title, Desc = Utility:ElText(Inner, Colorpicker.Title, Colorpicker.Desc, "Colorpicker")

            local Preview = VoidUI:Create("TextButton", {
                Parent = Card,
                Size = UDim2.new(0, 26, 0, 26),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                BackgroundColor3 = currentColor,
                Text = "",
                TextTransparency = 1,
                AutoButtonColor = false,
                ZIndex = 18,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                VoidUI:Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 1.4,
                    Transparency = 0.35,
                }),
            })

            local dialogOpen = false

            local function OpenColorDialog()
                if dialogOpen or Colorpicker.Locked then return end
                dialogOpen = true

                -- Sem tela preta (estilo WindUI / Main.lua): dialog flutuante no Main
                local Dialog = VoidUI:Create("Frame", {
                    Parent = Main,
                    Size = UDim2.new(0, 320, 0, 340),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundColor3 = UI.Theme.Background,
                    BackgroundTransparency = Window.Transparent and 0.12 or 0,
                    ZIndex = 301,
                    ThemeID = { BackgroundColor3 = "Background" },
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 14) }),
                    VoidUI:Create("UIStroke", {
                        Color = UI.Theme.Outline,
                        Thickness = 1,
                        ThemeID = { Color = "Outline" },
                    }),
                })
                -- Title bar (só ela arrasta o dialog — evita conflito com o picker)
                local TitleBar = VoidUI:Create("Frame", {
                    Parent = Dialog,
                    Size = UDim2.new(1, 0, 0, 42),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    ZIndex = 302,
                    Active = true,
                })

                VoidUI:Create("TextLabel", {
                    Parent = TitleBar,
                    Size = UDim2.new(1, -48, 0, 28),
                    Position = UDim2.new(0, 12, 0, 10),
                    BackgroundTransparency = 1,
                    Text = Colorpicker.Title,
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                    TextSize = 16,
                    TextColor3 = UI.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 302,
                    ThemeID = { TextColor3 = "Text" },
                })

                -- Linha branca embaixo do color picker (estilo Main.lua) para arrastar
                local CPDragBar = VoidUI:Create("Frame", {
                    Parent = Dialog,
                    Size = UDim2.new(0, 56, 0, 5),
                    Position = UDim2.new(0.5, 0, 1, 8),
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 0.75,
                    BorderSizePixel = 0,
                    ZIndex = 305,
                    Active = true,
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    VoidUI:Create("TextButton", {
                        Size = UDim2.new(1, 24, 1, 20),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Text = "",
                        TextTransparency = 1,
                        ZIndex = 306,
                    }),
                })
                CPDragBar.MouseEnter:Connect(function()
                    Utility:TweenObject(CPDragBar, {BackgroundTransparency = 0.3}, 0.1)
                end)
                CPDragBar.MouseLeave:Connect(function()
                    Utility:TweenObject(CPDragBar, {BackgroundTransparency = 0.75}, 0.15)
                end)

                enableDragging(Dialog, {TitleBar, CPDragBar, CPDragBar.TextButton})

                local CloseX = VoidUI:Create("ImageButton", {
                    Parent = Dialog,
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = UDim2.new(1, -30, 0, 12),
                    BackgroundTransparency = 1,
                    Image = ResolveIconImage("x"),
                    ImageColor3 = UI.Theme.IconColor,
                    ZIndex = 310,
                    ThemeID = { ImageColor3 = "IconColor" },
                })

                local SatVibMap = VoidUI:Create("ImageLabel", {
                    Parent = Dialog,
                    Size = UDim2.new(0, 200, 0, 180),
                    Position = UDim2.new(0, 14, 0, 48),
                    Image = "rbxassetid://4155801252",
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    ZIndex = 302,
                    Active = true,
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                })

                local Cursor = VoidUI:Create("Frame", {
                    Parent = SatVibMap,
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(s, 0, 1 - v, 0),
                    BackgroundColor3 = currentColor,
                    ZIndex = 303,
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    VoidUI:Create("UIStroke", {
                        Color = Color3.fromRGB(255, 255, 255),
                        Thickness = 2,
                    }),
                })

                local HueBar = VoidUI:Create("Frame", {
                    Parent = Dialog,
                    Size = UDim2.new(0, 18, 0, 180),
                    Position = UDim2.new(0, 226, 0, 48),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    ZIndex = 302,
                    Active = true,
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    VoidUI:Create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
                        }),
                    }),
                })

                local HueCursor = VoidUI:Create("Frame", {
                    Parent = HueBar,
                    Size = UDim2.new(1, 4, 0, 6),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, h, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    ZIndex = 303,
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 3) }),
                    VoidUI:Create("UIStroke", {
                        Color = Color3.fromRGB(40, 40, 40),
                        Thickness = 1,
                    }),
                })

                local PreviewBox = VoidUI:Create("Frame", {
                    Parent = Dialog,
                    Size = UDim2.new(0, 54, 0, 54),
                    Position = UDim2.new(0, 258, 0, 48),
                    BackgroundColor3 = currentColor,
                    ZIndex = 302,
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                    VoidUI:Create("UIStroke", {
                        Color = UI.Theme.Outline,
                        Thickness = 1,
                        ThemeID = { Color = "Outline" },
                    }),
                })

                local HexLabel = VoidUI:Create("TextLabel", {
                    Parent = Dialog,
                    Size = UDim2.new(0, 54, 0, 20),
                    Position = UDim2.new(0, 258, 0, 110),
                    BackgroundTransparency = 1,
                    Text = "#" .. currentColor:ToHex(),
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
                    TextSize = 11,
                    TextColor3 = UI.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 302,
                    ThemeID = { TextColor3 = "Text" },
                })

                local function UpdateDisplay()
                    local col = Color3.fromHSV(h, s, v)
                    currentColor = col
                    SatVibMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    Cursor.BackgroundColor3 = col
                    HueCursor.Position = UDim2.new(0.5, 0, h, 0)
                    PreviewBox.BackgroundColor3 = col
                    HexLabel.Text = "#" .. col:ToHex()
                end

                local dragging = nil

                local function applySat(input)
                    local abs = SatVibMap.AbsolutePosition
                    local size = SatVibMap.AbsoluteSize
                    if size.X <= 0 or size.Y <= 0 then return end
                    local mx = math.clamp(input.Position.X, abs.X, abs.X + size.X)
                    local my = math.clamp(input.Position.Y, abs.Y, abs.Y + size.Y)
                    s = math.clamp((mx - abs.X) / size.X, 0, 1)
                    v = math.clamp(1 - ((my - abs.Y) / size.Y), 0, 1)
                    UpdateDisplay()
                end
                local function applyHue(input)
                    local abs = HueBar.AbsolutePosition
                    local size = HueBar.AbsoluteSize
                    if size.Y <= 0 then return end
                    local my = math.clamp(input.Position.Y, abs.Y, abs.Y + size.Y)
                    h = math.clamp((my - abs.Y) / size.Y, 0, 1)
                    UpdateDisplay()
                end

                local function startColorDrag(kind, input)
                    dragging = kind
                    UI.BlockDragging = true
                    if kind == "sat" then applySat(input) else applyHue(input) end
                end
                local function endColorDrag()
                    dragging = nil
                    UI.BlockDragging = false
                end

                SatVibMap.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        startColorDrag("sat", input)
                    end
                end)
                HueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        startColorDrag("hue", input)
                    end
                end)

                local connChanged = UserInputService.InputChanged:Connect(function(input)
                    if not dragging then return end
                    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                    if dragging == "sat" then
                        applySat(input)
                    elseif dragging == "hue" then
                        applyHue(input)
                    end
                end)

                local connEnded = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        endColorDrag()
                    end
                end)

                -- limpa conexões ao fechar o dialog
                Dialog.Destroying:Connect(function()
                    endColorDrag()
                    pcall(function() connChanged:Disconnect() end)
                    pcall(function() connEnded:Disconnect() end)
                end)

                local CancelBtn = VoidUI:Create("TextButton", {
                    Parent = Dialog,
                    Size = UDim2.new(0.5, -16, 0, 36),
                    Position = UDim2.new(0, 12, 1, -48),
                    BackgroundColor3 = UI.Theme.ElementColor,
                    Text = "Cancel",
                    TextTransparency = 0,
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                    TextSize = 13,
                    TextColor3 = UI.Theme.Text,
                    AutoButtonColor = false,
                    ZIndex = 302,
                    ThemeID = {
                        BackgroundColor3 = "ElementColor",
                        TextColor3 = "Text",
                    },
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 9) }),
                })

                local ApplyBtn = VoidUI:Create("TextButton", {
                    Parent = Dialog,
                    Size = UDim2.new(0.5, -16, 0, 36),
                    Position = UDim2.new(0.5, 4, 1, -48),
                    BackgroundColor3 = Color3.fromRGB(42, 135, 62),
                    Text = "Apply",
                    TextTransparency = 0,
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                    TextSize = 13,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    AutoButtonColor = false,
                    ZIndex = 302,
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 9) }),
                })

                local function closeDialog()
                    dialogOpen = false
                    if Dialog then Dialog:Destroy() end
                end

                CloseX.MouseButton1Click:Connect(closeDialog)
                CancelBtn.MouseButton1Click:Connect(closeDialog)

                ApplyBtn.MouseButton1Click:Connect(function()
                    Preview.BackgroundColor3 = currentColor
                    Colorpicker.Default = currentColor
                    task.spawn(function()
                        pcall(Colorpicker.Callback, currentColor, currentTransparency)
                    end)
                    closeDialog()
                end)
            end

            Preview.MouseButton1Click:Connect(OpenColorDialog)

            function Colorpicker:Lock()
                Colorpicker.Locked = true
                LockedElm(Beeee, true)
            end
            function Colorpicker:UnLock()
                Colorpicker.Locked = false
                LockedElm(Beeee, false)
            end
            if Colorpicker.Locked then Colorpicker:Lock() end

            function Colorpicker:Set(color, transparency)
                currentColor = color
                h, s, v = Color3.toHSV(color)
                if transparency then currentTransparency = transparency end
                Preview.BackgroundColor3 = color
            end
            function Colorpicker:SetTitle(t) Title.SetText(t) end
            function Colorpicker:SetDesc(t)
                Desc.Visible = true
                Desc.SetText(t)
            end
            function Colorpicker:Close() Beeee:Destroy() end

            if Colorpicker.Desc then Colorpicker:SetDesc(Colorpicker.Desc) end

            Utility:Search(Window, {
                Title = Colorpicker.Title,
                Desc = Colorpicker.Desc,
                Icon = "palette",
                Type = "Colorpicker",
                TabTitle = Tab.Title,
                SelectFn = SelectTab,
                Frame = Beeee,
                RightScroll = RightScroll,
            })
            table.insert(Window.AllElements, Colorpicker)
            return Colorpicker
        end

        -- ========== NOVOS ELEMENTOS (estilo WindUI) ==========

        function Tab:ProgressBar(Config)
            local PB = {
                Title = Config.Title or "Progress",
                Desc = Config.Desc,
                Value = Config.Value or Config.Default or 0,
                Max = Config.Max or 100,
                ShowValue = Config.ShowValue ~= false,
                Locked = Config.Locked or false,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 56, "ProgressBar")
            local Title, Desc = Utility:ElText(Inner, PB.Title, PB.Desc, "ProgressBar")

            local BarRow = VoidUI:Create("Frame", {
                Parent = Inner,
                Size = UDim2.new(1, -16, 0, 18),
                BackgroundTransparency = 1,
                LayoutOrder = 10,
                ZIndex = 17,
            }, {
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                }),
            })

            local Track = VoidUI:Create("Frame", {
                Parent = BarRow,
                Size = UDim2.new(1, PB.ShowValue and -40 or 0, 0, 8),
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(40, 40, 42),
                ZIndex = 17,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
            })

            local Fill = VoidUI:Create("Frame", {
                Parent = Track,
                Size = UDim2.new(math.clamp(PB.Value / math.max(PB.Max, 1), 0, 1), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220),
                ZIndex = 18,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
            })

            local ValueLabel = VoidUI:Create("TextLabel", {
                Parent = BarRow,
                Size = UDim2.new(0, 36, 1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = PB.ShowValue and (tostring(math.floor(PB.Value / math.max(PB.Max, 1) * 100)) .. "%") or "",
                TextSize = 11,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = UI.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 18,
                ThemeID = { TextColor3 = "Text" },
            })

            function PB:Set(v)
                PB.Value = math.clamp(tonumber(v) or 0, 0, PB.Max)
                local ratio = PB.Value / math.max(PB.Max, 1)
                Utility:TweenObject(Fill, { Size = UDim2.new(ratio, 0, 1, 0) }, 0.2)
                if PB.ShowValue then
                    ValueLabel.Text = tostring(math.floor(ratio * 100)) .. "%"
                end
            end
            function PB:SetTitle(t) Title.SetText(t) end
            function PB:Lock() PB.Locked = true; LockedElm(Beeee, true) end
            function PB:UnLock() PB.Locked = false; LockedElm(Beeee, false) end
            function PB:Close() Beeee:Destroy() end
            if PB.Locked then PB:Lock() end
            table.insert(Window.AllElements, PB)
            return PB
        end

        function Tab:Checkbox(Config)
            local CB = {
                Title = Config.Title or "Checkbox",
                Desc = Config.Desc,
                Default = Config.Default == true,
                Locked = Config.Locked or false,
                Callback = Config.Callback or function() end,
            }
            local Value = CB.Default
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 40, "Checkbox")
            local Title, Desc = Utility:ElText(Inner, CB.Title, CB.Desc, "Checkbox")

            local Box = VoidUI:Create("Frame", {
                Parent = Card,
                Size = UDim2.new(0, 22, 0, 22),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                BackgroundColor3 = Value and UI.Theme.IconColor or UI.Theme.ElementColor,
                ZIndex = 18,
                ThemeID = { BackgroundColor3 = Value and "IconColor" or "ElementColor" },
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                VoidUI:Create("UIStroke", {
                    Color = UI.Theme.Outline,
                    Thickness = 1,
                    ThemeID = { Color = "Outline" },
                }),
            })

            local Check = VoidUI:Create("ImageLabel", {
                Parent = Box,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = ResolveIconImage("check"),
                ImageTransparency = Value and 0 or 1,
                ZIndex = 19,
                ThemeID = { ImageColor3 = "Text" },
            })

            local Hit = VoidUI:Create("TextButton", {
                Parent = Card,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 20,
            })

            local function setVal(v, fire)
                Value = v == true
                Utility:TweenObject(Box, { BackgroundColor3 = Value and UI.Theme.IconColor or UI.Theme.ElementColor }, 0.12)
                Utility:TweenObject(Check, { ImageTransparency = Value and 0 or 1 }, 0.12)
                if fire ~= false then task.spawn(CB.Callback, Value) end
            end

            Hit.MouseButton1Click:Connect(function()
                if CB.Locked then return end
                setVal(not Value)
            end)

            function CB:Set(v) setVal(v) end
            function CB:Get() return Value end
            function CB:SetTitle(t) Title.SetText(t) end
            function CB:Lock() CB.Locked = true; LockedElm(Beeee, true) end
            function CB:UnLock() CB.Locked = false; LockedElm(Beeee, false) end
            function CB:Close() Beeee:Destroy() end
            if CB.Locked then CB:Lock() end
            table.insert(Window.AllElements, CB)
            return CB
        end

        function Tab:Radio(Config)
            local RD = {
                Title = Config.Title or "Radio",
                Desc = Config.Desc,
                Option = Config.Option or Config.Options or {},
                Value = Config.Value or Config.Default,
                Locked = Config.Locked or false,
                Callback = Config.Callback or function() end,
            }
            if not RD.Value and #RD.Option > 0 then RD.Value = RD.Option[1] end

            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 40, "Radio")
            local Title, Desc = Utility:ElText(Inner, RD.Title, RD.Desc, "Radio")

            local Row = VoidUI:Create("Frame", {
                Parent = Card,
                Size = UDim2.new(1, -16, 0, 0),
                AutomaticSize = "Y",
                Position = UDim2.new(0, 8, 0, 28),
                BackgroundTransparency = 1,
                ZIndex = 17,
            }, {
                VoidUI:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Wraps = true,
                }),
            })

            local buttons = {}
            local function selectOpt(opt)
                RD.Value = opt
                for name, data in pairs(buttons) do
                    local on = name == opt
                    Utility:TweenObject(data.Dot, {
                        BackgroundTransparency = on and 0 or 1,
                        Size = on and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 0, 0, 0),
                    }, 0.12)
                end
                task.spawn(RD.Callback, opt)
            end

            for i, opt in ipairs(RD.Option) do
                local item = VoidUI:Create("TextButton", {
                    Parent = Row,
                    AutomaticSize = "XY",
                    BackgroundTransparency = 1,
                    Text = "",
                    LayoutOrder = i,
                    ZIndex = 18,
                }, {
                    VoidUI:Create("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 6),
                    }),
                })

                local circle = VoidUI:Create("Frame", {
                    Parent = item,
                    Size = UDim2.new(0, 18, 0, 18),
                    BackgroundColor3 = UI.Theme.ElementColor,
                    ZIndex = 19,
                    ThemeID = { BackgroundColor3 = "ElementColor" },
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    VoidUI:Create("UIStroke", {
                        Color = UI.Theme.Outline,
                        Thickness = 1.2,
                        ThemeID = { Color = "Outline" },
                    }),
                })

                local dot = VoidUI:Create("Frame", {
                    Parent = circle,
                    Size = (RD.Value == opt) and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = UI.Theme.IconColor,
                    BackgroundTransparency = (RD.Value == opt) and 0 or 1,
                    ZIndex = 20,
                    ThemeID = { BackgroundColor3 = "IconColor" },
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                })

                VoidUI:Create("TextLabel", {
                    Parent = item,
                    AutomaticSize = "XY",
                    BackgroundTransparency = 1,
                    Text = tostring(opt),
                    TextSize = 12,
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                    TextColor3 = UI.Theme.Text,
                    ZIndex = 19,
                    ThemeID = { TextColor3 = "Text" },
                })

                buttons[opt] = { Dot = dot }
                item.MouseButton1Click:Connect(function()
                    if RD.Locked then return end
                    selectOpt(opt)
                end)
            end

            function RD:Set(v) if buttons[v] then selectOpt(v) end end
            function RD:Get() return RD.Value end
            function RD:Lock() RD.Locked = true; LockedElm(Beeee, true) end
            function RD:UnLock() RD.Locked = false; LockedElm(Beeee, false) end
            function RD:Close() Beeee:Destroy() end
            if RD.Locked then RD:Lock() end
            table.insert(Window.AllElements, RD)
            return RD
        end

        function Tab:Badge(Config)
            local BD = {
                Title = Config.Title or "Badge",
                Text = Config.Text or Config.Value or "NEW",
                Color = Config.Color or UI.Theme.IconColor,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 36, "Badge")
            local Title = Utility:ElText(Inner, BD.Title, nil, "Badge")

            local Pill = VoidUI:Create("Frame", {
                Parent = Card,
                AutomaticSize = "X",
                Size = UDim2.new(0, 0, 0, 22),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                BackgroundColor3 = BD.Color,
                ZIndex = 18,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                }),
            })

            local PillText = VoidUI:Create("TextLabel", {
                Parent = Pill,
                AutomaticSize = "XY",
                BackgroundTransparency = 1,
                Text = tostring(BD.Text),
                TextSize = 11,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold),
                TextColor3 = Color3.new(1, 1, 1),
                ZIndex = 19,
            })

            function BD:Set(t)
                BD.Text = t
                PillText.Text = tostring(t)
            end
            function BD:SetColor(c)
                BD.Color = c
                Pill.BackgroundColor3 = c
            end
            function BD:Close() Beeee:Destroy() end
            return BD
        end

        function Tab:Label(Config)
            local LB = {
                Title = Config.Title or Config.Text or "Label",
                Desc = Config.Desc,
                Color = Config.Color,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 36, "Label")
            local Title, Desc = Utility:ElText(Inner, LB.Title, LB.Desc, "Label")
            if LB.Color and Title and Title.Frame then
                -- keep theme, optional accent via paragraph-like
            end
            function LB:SetTitle(t) Title.SetText(t) end
            function LB:SetDesc(t) if Desc then Desc.Visible = true; Desc.SetText(t) end end
            function LB:Close() Beeee:Destroy() end
            return LB
        end

        function Tab:KeyValue(Config)
            local KV = {
                Title = Config.Title or Config.Key or "Key",
                Value = Config.Value or "—",
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 36, "KeyValue")
            local Title = Utility:ElText(Inner, KV.Title, nil, "KeyValue")

            local Val = VoidUI:Create("TextLabel", {
                Parent = Card,
                AutomaticSize = "XY",
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                BackgroundTransparency = 1,
                Text = tostring(KV.Value),
                TextSize = 12,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = UI.Theme.IconColor,
                ZIndex = 18,
                ThemeID = { TextColor3 = "IconColor" },
            })

            function KV:Set(v)
                KV.Value = v
                Val.Text = tostring(v)
            end
            function KV:SetTitle(t) Title.SetText(t) end
            function KV:Close() Beeee:Destroy() end
            return KV
        end

        function Tab:Code(Config)
            local CD = {
                Title = Config.Title or "Code",
                Code = Config.Code or Config.Text or "-- code",
                Height = Config.Height or 140,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, CD.Height + 36, "Code")
            local Title = Utility:ElText(Inner, CD.Title, nil, "Code")

            local function highlightLua(src)
                local esc = tostring(src or "")
                    :gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                local keywords = {
                    "and","break","do","else","elseif","end","false","for","function",
                    "if","in","local","nil","not","or","repeat","return","then","true",
                    "until","while","task","game","workspace","script","pairs","ipairs",
                    "pcall","typeof","tostring","tonumber","print","require","export","type",
                }
                -- strings
                esc = esc:gsub('(%b"")', function(s) return '<font color="#ce9178">' .. s .. '</font>' end)
                esc = esc:gsub("(%b'')", function(s) return '<font color="#ce9178">' .. s .. '</font>' end)
                -- comments
                esc = esc:gsub("(%-%-[^\n]*)", function(s) return '<font color="#6a9955">' .. s .. '</font>' end)
                -- numbers
                esc = esc:gsub("(%f[%w%d_]%d[%d%.]*)", function(s) return '<font color="#b5cea8">' .. s .. '</font>' end)
                -- keywords
                for _, kw in ipairs(keywords) do
                    esc = esc:gsub("(%f[%w_])(" .. kw .. ")(%f[^%w_])", '%1<font color="#569cd6">%2</font>%3')
                end
                return esc
            end

            local Scroll = VoidUI:Create("ScrollingFrame", {
                Parent = Card,
                Size = UDim2.new(1, -16, 0, CD.Height),
                Position = UDim2.new(0, 8, 0, 30),
                BackgroundColor3 = Color3.fromRGB(12, 12, 14),
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                ScrollBarThickness = 4,
                ScrollingDirection = Enum.ScrollingDirection.XY,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.XY,
                ZIndex = 17,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                VoidUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                }),
            })

            local Box = VoidUI:Create("TextLabel", {
                Parent = Scroll,
                Size = UDim2.new(0, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                Text = highlightLua(CD.Code),
                TextSize = 12,
                FontFace = Font.new([[rbxasset://fonts/families/RobotoMono.json]], Enum.FontWeight.Medium),
                TextColor3 = Color3.fromRGB(212, 212, 212),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = false,
                RichText = true,
                ZIndex = 18,
            })

            function CD:Set(code)
                CD.Code = code
                Box.Text = highlightLua(code)
            end
            function CD:Close() Beeee:Destroy() end
            return CD
        end

        function Tab:EmptyState(Config)
            local ES = {
                Title = Config.Title or "Nothing here",
                Desc = Config.Desc or "No items to display",
                Icon = Config.Icon or "inbox",
            }
            local Beeee = VoidUI:Create("Frame", {
                Parent = RightScroll,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, ElementFrame.Size.X.Offset - 10, 0, 120),
                ZIndex = 15,
            })
            local icon = VoidUI:Create("ImageLabel", {
                Parent = Beeee,
                Size = UDim2.new(0, 36, 0, 36),
                Position = UDim2.new(0.5, 0, 0.25, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = ResolveIconImage(ES.Icon),
                ImageTransparency = 0.4,
                ZIndex = 16,
                ThemeID = { ImageColor3 = "IconColor" },
            })
            VoidUI:Create("TextLabel", {
                Parent = Beeee,
                Size = UDim2.new(1, -20, 0, 22),
                Position = UDim2.new(0, 10, 0.5, 0),
                BackgroundTransparency = 1,
                Text = ES.Title,
                TextSize = 14,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = UI.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 16,
                ThemeID = { TextColor3 = "Text" },
            })
            VoidUI:Create("TextLabel", {
                Parent = Beeee,
                Size = UDim2.new(1, -20, 0, 18),
                Position = UDim2.new(0, 10, 0.65, 0),
                BackgroundTransparency = 1,
                Text = ES.Desc,
                TextSize = 12,
                TextTransparency = 0.45,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
                TextColor3 = UI.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 16,
                ThemeID = { TextColor3 = "Text" },
            })
            function ES:Close() Beeee:Destroy() end
            return ES
        end

        function Tab:Discord(Config)
            local DC = {
                Title = Config.Title or "Discord",
                Desc = Config.Desc or "Join our community",
                URL = Config.URL or Config.Invite or "https://discord.gg/",
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 52, "Discord")
            local Title, Desc = Utility:ElText(Inner, DC.Title, DC.Desc, "Discord")

            local Btn = VoidUI:Create("TextButton", {
                Parent = Card,
                Size = UDim2.new(0, 70, 0, 28),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(88, 101, 242),
                Text = "Join",
                TextTransparency = 0,
                TextSize = 12,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = Color3.new(1, 1, 1),
                AutoButtonColor = false,
                ZIndex = 18,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            })

            Btn.MouseButton1Click:Connect(function()
                pcall(function() setclipboard(DC.URL) end)
                Btn.Text = "Copied!"
                task.delay(1.2, function()
                    if Btn and Btn.Parent then Btn.Text = "Join" end
                end)
            end)

            function DC:Close() Beeee:Destroy() end
            return DC
        end

        function Tab:Stepper(Config)
            local ST = {
                Title = Config.Title or "Stepper",
                Desc = Config.Desc,
                Value = Config.Value or Config.Default or 0,
                Min = (Config.Min ~= nil and Config.Min) or (Config.Value and Config.Value.Min) or 0,
                Max = (Config.Max ~= nil and Config.Max) or (Config.Value and Config.Value.Max) or 100,
                Step = Config.Step or 1,
                Locked = Config.Locked or false,
                Callback = Config.Callback or function() end,
            }
            if typeof(Config.Value) == "table" then
                ST.Min = Config.Value.Min or ST.Min
                ST.Max = Config.Value.Max or ST.Max
                ST.Value = Config.Value.Default or ST.Value
            end

            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 42, "Stepper")
            local Title, Desc = Utility:ElText(Inner, ST.Title, ST.Desc, "Stepper")

            local Holder = VoidUI:Create("Frame", {
                Parent = Card,
                Size = UDim2.new(0, 110, 0, 28),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundTransparency = 1,
                ZIndex = 18,
            }, {
                VoidUI:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 4),
                }),
            })

            local function mkBtn(txt)
                return VoidUI:Create("TextButton", {
                    Parent = Holder,
                    Size = UDim2.new(0, 28, 0, 28),
                    BackgroundColor3 = UI.Theme.ElementColor,
                    Text = txt,
                    TextTransparency = 0,
                    TextSize = 16,
                    FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold),
                    TextColor3 = UI.Theme.Text,
                    AutoButtonColor = false,
                    ZIndex = 19,
                    ThemeID = { BackgroundColor3 = "ElementColor", TextColor3 = "Text" },
                }, {
                    VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                })
            end

            local Minus = mkBtn("−")
            local ValLabel = VoidUI:Create("TextLabel", {
                Parent = Holder,
                Size = UDim2.new(0, 40, 0, 28),
                BackgroundTransparency = 1,
                Text = tostring(ST.Value),
                TextSize = 13,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = UI.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 19,
                ThemeID = { TextColor3 = "Text" },
            })
            local Plus = mkBtn("+")

            local function setV(v, fire)
                ST.Value = math.clamp(v, ST.Min, ST.Max)
                ValLabel.Text = tostring(ST.Value)
                if fire ~= false then task.spawn(ST.Callback, ST.Value) end
            end

            Minus.MouseButton1Click:Connect(function()
                if ST.Locked then return end
                setV(ST.Value - ST.Step)
            end)
            Plus.MouseButton1Click:Connect(function()
                if ST.Locked then return end
                setV(ST.Value + ST.Step)
            end)

            function ST:Set(v) setV(tonumber(v) or ST.Value) end
            function ST:Get() return ST.Value end
            function ST:Lock() ST.Locked = true; LockedElm(Beeee, true) end
            function ST:UnLock() ST.Locked = false; LockedElm(Beeee, false) end
            function ST:Close() Beeee:Destroy() end
            if ST.Locked then ST:Lock() end
            table.insert(Window.AllElements, ST)
            return ST
        end

        -- ========== FIM NOVOS ELEMENTOS ==========

        function Tab:Devider()
            local Devider = VoidUI:Create("Frame", {
                Parent = RightScroll,
                ZIndex = 20,
                Size = UDim2.new(1, -7, 0, 1),
                ThemeID = {
                    BackgroundColor3 = "Outline"
                },
            },{
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 100) }),
            })
        end
        function Tab:Space(Value)
            local Space = VoidUI:Create("Frame", {
                Parent = RightScroll,
                ZIndex = 20,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -7, 0, Value or 2),
            })
        end
        function Tab:Section(Config)
            local Section = {
                Title = Config.Title or "Section",
                Icon = Config.Icon,
                TextSize = Config.TextSize or 18,
                UIPadding = Config.UIPadding or UDim.new(0, 0),
            }
            local SectionElement = VoidUI:Create("Frame", {
                Parent = RightScroll,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                ZIndex = 20,
                Position = UDim2.new(0, 0, 0.3038, 0),
                Size = UDim2.new(0, ElementFrame.Size.X.Offset - 10, 0, 30),
            })

            local SectionLabel = VoidUI:Create("TextLabel", {
                Parent = SectionElement,
                BackgroundTransparency = 1,
                RichText = true,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                Text = Section.Title,
                TextSize = Section.TextSize,
                ZIndex = 20,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Section.Text|Text"
                },
            },{
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 0),
                })
            })

            local Icon
            if Section.Icon then
            SectionLabel.UIPadding.PaddingLeft = Section.UIPadding + UDim.new(0, 22)
                local Icon = VoidUI:Create("ImageLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    --Image = IconsV2.GetIcon(Window.Icon),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    ZIndex = 20,
                    Parent = SectionElement,
                    ThemeID = {
                        ImageColor3 = "Section.Icon|IconColor"
                    }
                })
                if Section.Icon and IconsV2.Icon(Section.Icon) then
                    Icon.Image = IconsV2.GetIcon(Section.Icon)
                elseif Section.Icon and string.find(Section.Icon, "rbxassetid://") then
                    Icon.Image = SectionIcon
                end
            end

            function Section:Close()
                SectionElement:Destroy()
            end

            function Section:SetTitle(Value)
                SectionLabel.Text = Value
            end
            function Section:SetTextSize(V)
                SectionLabel.TextSize = V
            end
            return Section
        end
        function Window:UserEnabled(Value)
            Window.User.Enabled = Value
            UserFrame.Visible = Value
            if Value then
                UserFrame.BackgroundTransparency = 0
                UserTitle.TextTransparency = 0
                UserSub.TextTransparency = 0.6
                if UserFrame:FindFirstChild("ImageLabel") then
                    UserFrame.ImageLabel.ImageTransparency = 0
                    UserFrame.ImageLabel.BackgroundTransparency = 0.7
                end
            else
                UserFrame.BackgroundTransparency = 1
                UserTitle.TextTransparency = 1
                UserSub.TextTransparency = 1
                if UserFrame:FindFirstChild("ImageLabel") then
                    UserFrame.ImageLabel.ImageTransparency = 1
                    UserFrame.ImageLabel.BackgroundTransparency = 1
                end
            end
            -- Mantém o LeftScroll sempre com o offset correto para não invadir o User
            LeftScroll.Size = UDim2.new(1, 0, 1, Value and -50 or -10)
            task.defer(function()
                if LeftScroll.UIListLayout then
                    LeftScroll.CanvasSize = UDim2.new(0, 0, 0, LeftScroll.UIListLayout.AbsoluteContentSize.Y + 20)
                end
            end)
        end
        function Window:Anonymous(Value)
            UserTitle.Text = Value and "Anonymous" or TruncateName(game.Players.LocalPlayer.DisplayName, 14)
            UserSub.Text = Value and "@Anonymous" or "@"..TruncateName(game.Players.LocalPlayer.Name, 12)
            UserFrame.ImageLabel.Image = (function()
                return game:GetService("Players"):GetUserThumbnailAsync(Value and 1 or game.Players.LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
            end)()
        end
        function Tab:Group(Config)
            Config = Config or {}
            local Padding = Config.Padding or 5

            local GroupFrame = VoidUI:Create("Frame", {
                Parent = RightScroll,
                BackgroundTransparency = 1,
                AutomaticSize = "Y",
                Size = UDim2.new(0, ElementFrame.Size.X.Offset - 10, 0, 0),
                ZIndex = 15,
            }, {
                VoidUI:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Top,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, Padding),
                })
            })

            local CellScale, CellOffset

            local function Size()
                local count = 0
                for _, child in ipairs(GroupFrame:GetChildren()) do
                    if child:IsA("Frame") then
                        count += 1
                    end
                end
                CellScale = 1 / math.max(1, count)
                CellOffset = -(Padding * (math.max(1, count) - 1) / math.max(1, count))
                for _, child in ipairs(GroupFrame:GetChildren()) do
                    if child:IsA("Frame") then
                        child.Size = UDim2.new(CellScale, CellOffset, 0, child.Size.Y.Offset)
                    end
                end
            end

            local Group = {}

            setmetatable(Group, {
                __index = function(_, methodName)
                    return function(_, ItemConfig)
                        local Element = Tab[methodName](Tab, ItemConfig)
                        Window.SearchIndex[#Window.SearchIndex].Frame.Parent = GroupFrame
                        Size()
                        return Element
                    end
                end
            })

            return Group
        end

        return Tab
    end

    function Window:Section(Config)
        local Section = {
            Title = Config.Title or "Section",
            Icon = Config.Icon or nil,
            Opened = Config.Opened or true,
        }

        local isOpen = Section.Opened

        local SectionFrame = VoidUI:Create("Frame", {
            Parent = LeftScroll,
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, Window.SideBarWidth - 5, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 5,
        }, {
            VoidUI:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
            }),
        })

        local SectionBTN = VoidUI:Create("TextButton", {
            Parent = SectionFrame,
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            TextTransparency = 1,
            ZIndex = 50,
        },{
            VoidUI:Create("UIPadding", {
                PaddingTop = UDim.new(0, 9),
            }),
            VoidUI:Create("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 12, 0, 12),
                Image = IconsV2.GetIcon("chevron-down"),
                Rotation = isOpen and -180 or 0,
                ZIndex = 16,
                ThemeID = { ImageColor3 = "Text" }
            })
        })

        --[[SectionBTN.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            --SectionRoll.Visible = isOpen
            Utility:TweenObject(SectionBTN.ImageLabel, {Rotation = isOpen and 0 or -180}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        end)--]]

        local SecTitle = Text(SectionBTN, Section.Title, {
            Size = UDim2.new(1, 0, 1, 0),
            AutomaticSize = "Y",
            ZIndex = 16,
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            RichText = true,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 49,
            ThemeID = { TextColor3 = "Text" }
        }, {
            VoidUI:Create("UIPadding", { PaddingLeft = UDim.new(0, 12) })
        })
        SecTitle.Position = UDim2.new(0, 0, 0, 0)

        local Icon
        if Section.Icon then
            Icon = VoidUI:Create("ImageLabel", {
                AnchorPoint = Vector2.new(.02, 0.5),
                --Image = IconsV2.GetIcon(Window.Icon),
                BackgroundTransparency = 1,
                Position = UDim2.new(.02, 0, 0.5, 0),
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(0, 15, 0, 15),
                BorderSizePixel = 0,
                ZIndex = 49,
                Parent = SectionBTN,
                ThemeID = {
                    ImageColor3 = "IconColor"
                }
            })
            SecTitle.UIPadding.PaddingLeft = UDim.new(0,20)
            if Section.Icon and IconsV2.Icon(Section.Icon) then
                Icon.Image = IconsV2.GetIcon(Section.Icon)
            elseif Section.Icon and string.find(Section.Icon, "rbxassetid://") then
                Icon.Image = Section.Icon
            end
        end

        local SectionRoll = VoidUI:Create("Frame", {
            Parent = SectionFrame,
            AutomaticSize = "Y",
            ClipsDescendants = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, Window.SideBarWidth, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 5,
        }, {
            VoidUI:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
            }),
        })

        SectionBTN.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            Utility:TweenObject(SectionBTN.ImageLabel, {Rotation = isOpen and -180 or 0}, 0.16)
            SectionRoll.Size = UDim2.new(1, 0, 0, SectionRoll.AbsoluteSize.Y)
            SectionRoll.AutomaticSize = Enum.AutomaticSize.None
            if isOpen then
                Utility:TweenObject(SectionRoll, {Size = UDim2.new(1, 0, 0, SectionRoll.UIListLayout.AbsoluteContentSize.Y)}, 0.2)
            else
                Utility:TweenObject(SectionRoll, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            end
        end)

        function Section:Tab(Config)
            return Window:Tab(Config, SectionRoll.UIListLayout and SectionRoll or SectionRoll)
        end
        return Section
    end
    local isToggling = false -- debounce para evitar bugs no botão open/close

    function Window:Open()
        if isToggling then return end
        isToggling = true

        Window.IslandOpen = true
        Window.Default = "Default"

        Main.Visible = true
        Main.Frame.Visible = true
        local targetBg = (Window.Transparent and 0.1 or 0)
        Main.BackgroundTransparency = 1
        Main.Size = UDim2.new(0, Window.Size.X.Offset, 0, math.max(40, Window.Size.Y.Offset * 0.4))
        Main.Frame.Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset - 8)
        local uiScale = Main:FindFirstChildOfClass("UIScale")
        if uiScale then
            uiScale.Scale = 0.92
            Utility:TweenObject(uiScale, {Scale = 1}, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
        Utility:TweenObject(Main, {
            Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset),
            BackgroundTransparency = targetBg,
        }, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        TabFrame.Size = UDim2.new(0, Window.SideBarWidth, 0, Window.Size.Y.Offset - Window.Topbar.Height - 13)
        TabFrame.BackgroundTransparency = (Window.Transparent and 1 or 0)

        local scrollOffset = (Window.User.Enabled and -50) or -10
        LeftScroll.Size = UDim2.new(1, 0, 1, scrollOffset)

        if Window.User.Enabled then
            UserFrame.Visible = true
            UserFrame.BackgroundTransparency = 0
            UserTitle.TextTransparency = 0
            UserSub.TextTransparency = 0.6
        else
            UserFrame.Visible = false
        end

        task.defer(function()
            if LeftScroll.UIListLayout then
                LeftScroll.CanvasSize = UDim2.new(0, 0, 0, LeftScroll.UIListLayout.AbsoluteContentSize.Y + 20)
            end
        end)

        if Window.Resizable and ResizeHandle then
            ResizeHandle.Visible = true
        end

        -- Esconde o botão open (estilo WindUI)
        OpenButtonHolder.Visible = false

        task.wait(0.05)
        isToggling = false
    end

    function Window:Close()
        if isToggling then return end
        isToggling = true

        if ResizeHandle then ResizeHandle.Visible = false end

        Window.IslandOpen = false
        Window.Default = "Minimize"

        local uiScale = Main:FindFirstChildOfClass("UIScale")
        if uiScale then
            Utility:TweenObject(uiScale, {Scale = 0.92}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        end
        Utility:TweenObject(Main, {
            Size = UDim2.new(0, Window.Size.X.Offset, 0, math.max(40, Window.Size.Y.Offset * 0.35)),
            BackgroundTransparency = 1,
        }, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

        task.delay(0.22, function()
            Main.Visible = false
            Main.Frame.Visible = false
            if uiScale then uiScale.Scale = 1 end
            Main.Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset)
            TabFrame.Size = UDim2.new(0, Window.SideBarWidth, 0, 0)
            TabFrame.BackgroundTransparency = 1
            LeftScroll.Size = UDim2.new(1, 0, 0, 0)
            -- sempre topo centro (estilo WindUI)
            OpenButtonHolder.Position = UDim2.new(0.5, 0, 0, 8)
            OpenButtonHolder.AnchorPoint = Vector2.new(0.5, 0)
            OpenButtonHolder.Visible = true
            isToggling = false
        end)
    end

    local minBtn = WinElements:FindFirstChild("Minimize") or WinElements:FindFirstChild("ImageButton")
    if minBtn then
        minBtn.MouseButton1Click:Connect(function()
            if Window.IslandOpen and not isToggling then
                Window:Close()
            end
        end)
    end

    local fsBtn = WinElements:FindFirstChild("Fullscreen")
    if fsBtn then
        fsBtn.MouseButton1Click:Connect(function()
            Window:ToggleFullscreen()
        end)
    end

    OpenClickBtn.MouseButton1Click:Connect(function()
        if not Window.IslandOpen and not isToggling then
            Window:Open()
        end
    end)

    function Window:OnDestroy(Callback)
        Window.OnDestroy = Callback or function() end
    end
    WinElements.Cross.MouseButton1Click:Connect(function()
        UI:Dialog({
            Title = "Close UI?",
            Desc = "Are you sure you want to destroy this window?",
            Buttons = {
                {
                    Text = "Cancel",
                    Callback = function() end
                },
                {
                    Text = "Destroy",
                    Callback = function()
                        Window.IslandOpen = false
                        spawn(function() pcall(Window.OnDestroy) end)
                        local scale = Main:FindFirstChildOfClass("UIScale")
                        if scale then
                            Utility:TweenObject(scale, {Scale = 0.85}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                        end
                        Utility:TweenObject(Main, {BackgroundTransparency = 1}, 0.18)
                        task.delay(0.2, function()
                            pcall(function() UIScreen:Destroy() end)
                        end)
                    end
                },
            }
        })
    end)

    function Window:Destroy()
        Window.IslandOpen = false
        spawn(function() pcall(Window.OnDestroy) end)
        -- Destroy sem animação (instantâneo)
        UIScreen:Destroy()
    end

    local TogValue = true
    game:GetService("UserInputService").InputBegan:Connect(function(input, i)
        if not i then
            if input.KeyCode == Window.ToggleKey then
                if not Window.IslandOpen then
                    Window:Open()
                else
                    Window:Close()
                end
            end
        end
    end)

    function Window:SetToggleKey(Value)
        Window.ToggleKey = Value
        return Window
    end

    function Window:SetTitle(v)
        LibName.Text = v
    end

    function Window:SetAuthor(v)
        LibName.LibAuthor = v
    end

    function Window:ToCenter()
        Utility:TweenObject(Main, {Position = UDim2.new(0.5,0,0.5,0)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    end

    function Window:SetTransparency(Value)
        Utility:TweenObject(Main, {Transparency = Value and 0.1 or 0}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        Utility:TweenObject(TabFrame, {Transparency = Value and 1 or 0}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        Utility:TweenObject(TabFrame.Frame, {Transparency = Value and 1 or 0}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        return Window
    end

    function Window:GetTheme()
        return Window.Theme
    end

	function Window:GetUIScale()
		return Window.Size
	end

    function Window:SetUIScale(v)
        Utility:TweenObject(Main.UIScale, {Scale = v}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        return Window
    end

    if Window.AutoScale then
        local Camera = workspace.CurrentCamera

        local AvailableWidth = Camera.ViewportSize.X - (40 * 2)
        local AvailableHeight = Camera.ViewportSize.Y - (40 * 2)

        local ScaleX = AvailableWidth / Window.Size.X.Offset
        local ScaleY = AvailableHeight / Window.Size.Y.Offset

        local MinScale = 0.3
        local MaxScale = 1.0

        Window:SetUIScale(math.clamp(math.min(ScaleX, ScaleY), MinScale, MaxScale))
    end

    function Window:Resize(sizeX, sizeY, isDrag)
        sizeX = math.clamp(sizeX, 410, 900)
        sizeY = math.clamp(sizeY, 280, 700)
        local TagFrame = Main:FindFirstChild("TagFrame")
        Window.Size = UDim2.new(0, sizeX, 0, sizeY)

        -- TopBarF3 (Search + minimize/destroy) fica com largura fixa 187
        local f2w = (TopBarF2.Visible and TopBarF2.Size.X.Offset) or 0
        local f3w = 187
        local f1w = math.max(120, sizeX - 20 - f2w - f3w)
        TopBarF3.Size = UDim2.new(0, f3w, 0, Window.Topbar.Height)

        if isDrag then
            Main.Size = UDim2.new(0, sizeX, 0, sizeY)
            Main.Frame.Size = UDim2.new(0, sizeX, 0, sizeY - 8)
            TopBarF1.Size = UDim2.new(0, f1w, 0, Window.Topbar.Height)
            TabFrame.Size = UDim2.new(0, Window.SideBarWidth, 0, sizeY - Window.Topbar.Height - 13)
        else
            Utility:TweenObject(Main, {Size = UDim2.new(0, sizeX, 0, sizeY)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Utility:TweenObject(Main.Frame, {Size = UDim2.new(0, sizeX, 0, sizeY - 8)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Utility:TweenObject(TopBarF1, {Size = UDim2.new(0, f1w, 0, Window.Topbar.Height)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Utility:TweenObject(TabFrame, {Size = UDim2.new(0, Window.SideBarWidth, 0, sizeY - Window.Topbar.Height - 13)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end

        -- Corrige o espaço para a aba não invadir o UserFrame
        local userOffset = (Window.User.Enabled and 50 or 13)
        
        for _, EF in ipairs(ElementFolder:GetChildren()) do
            if EF:IsA("Frame") then
                EF.Size = UDim2.new(0, sizeX - Window.SideBarWidth - 8, 0, (Window.ActiveElementFrame == EF) and sizeY - Window.Topbar.Height - 20 - (Tags > 0 and 37 or 0) or EF.Size.Y.Offset)
                local Scroll = EF:FindFirstChildOfClass("ScrollingFrame")
                if Scroll then
                    for _, item in ipairs(Scroll:GetChildren()) do
                        if item:IsA("Frame") then
                            item.Size = UDim2.new(0, sizeX - Window.SideBarWidth - 8 - 10, 0, item.Size.Y.Offset)
                        end
                    end
                end
            end
        end

        -- Atualiza o LeftScroll dinamicamente para respeitar o espaço do usuário
        if LeftScroll then
            LeftScroll.Size = UDim2.new(1, 0, 1, Window.User.Enabled and -50 or -10)
        end

        if TagFrame then
            TagFrame.Size = UDim2.new(0, sizeX - Window.SideBarWidth - 8, 0, 35)
            TagFrame.Position = UDim2.new(.97, 0, 1, -5)
        end
    end
    
    local ResizeHandle = VoidUI:Create("Frame", {
        Parent = Main,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -4, 1, -4),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 499,
        Active = true,
    }, {
        VoidUI:Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://97284127540888",
            Position = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0, 0),
            ImageTransparency = 0.8,
            Rotation = 0,
            ThemeID = {
                ImageColor3 = "IconColor"
            }
        }),
    })

    ResizeHandle.Visible = Window.Resizable

    local resizing, startPos, startSize

    ResizeHandle.MouseEnter:Connect(function()
        Utility:TweenObject(ResizeHandle.ImageLabel, {ImageTransparency = 0.35}, 0.15)
    end)
    ResizeHandle.MouseLeave:Connect(function()
        if not resizing then
            Utility:TweenObject(ResizeHandle.ImageLabel, {ImageTransparency = 0.8}, 0.15)
        end
    end)

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startPos = input.Position
            startSize = Window.Size
            Utility:TweenObject(ResizeHandle.ImageLabel, {ImageTransparency = 0}, 0.1)
        end
    end)

    ResizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
            Utility:TweenObject(ResizeHandle.ImageLabel, {ImageTransparency = 0.8}, 0.15)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            -- *2 porque Main tem AnchorPoint (0.5, 0.5) — igual WindUI/Main.lua
            Window:Resize(startSize.X.Offset + delta.X * 2, startSize.Y.Offset + delta.Y * 2, true)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            resizing = false
            Utility:TweenObject(ResizeHandle.ImageLabel, {ImageTransparency = 0.8}, 0.15)
        end
    end)

    function Window:SetResizable(v)
        ResizeHandle.Visible = v
    end

    -- Fullscreen (estilo WindUI)
    Window.IsFullscreen = false
    local _fsPos, _fsSize
    function Window:ToggleFullscreen()
        if Window.IsFullscreen then
            Window.IsFullscreen = false
            if _fsSize then
                Window:Resize(_fsSize.X.Offset, _fsSize.Y.Offset)
            end
            if _fsPos then
                Utility:TweenObject(Main, { Position = _fsPos }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end
            if Window.Resizable then
                ResizeHandle.Visible = true
            end
        else
            Window.IsFullscreen = true
            _fsPos = Main.Position
            _fsSize = Window.Size
            local cam = workspace.CurrentCamera
            local vw, vh = cam.ViewportSize.X, cam.ViewportSize.Y
            local scale = (Main:FindFirstChild("UIScale") and Main.UIScale.Scale) or 1
            Window:Resize(math.floor((vw - 24) / scale), math.floor((vh - 48) / scale))
            -- centraliza no meio da tela
            Utility:TweenObject(Main, {
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            ResizeHandle.Visible = false
        end
        return Window
    end

    -- Watermark
    local WatermarkFrame = nil
    function Window:SetWatermark(text)
        if text == false or text == nil then
            if WatermarkFrame then WatermarkFrame:Destroy(); WatermarkFrame = nil end
            return Window
        end
        if not WatermarkFrame then
            WatermarkFrame = VoidUI:Create("Frame", {
                Parent = UIScreen,
                AutomaticSize = "XY",
                Position = UDim2.new(0, 12, 0, 12),
                BackgroundColor3 = UI.Theme.Background,
                BackgroundTransparency = 0.15,
                ZIndex = 600,
                ThemeID = { BackgroundColor3 = "Background" },
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                VoidUI:Create("UIStroke", {
                    Color = UI.Theme.Outline,
                    Thickness = 1,
                    ThemeID = { Color = "Outline" },
                }),
                VoidUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                }),
            })
            VoidUI:Create("TextLabel", {
                Name = "Text",
                Parent = WatermarkFrame,
                AutomaticSize = "XY",
                BackgroundTransparency = 1,
                Text = tostring(text),
                TextSize = 12,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = UI.Theme.Text,
                ZIndex = 601,
                ThemeID = { TextColor3 = "Text" },
            })
        else
            local t = WatermarkFrame:FindFirstChild("Text")
            if t then t.Text = tostring(text) end
        end
        return Window
    end
    function Window:ToggleWatermark(v)
        if WatermarkFrame then
            WatermarkFrame.Visible = v ~= false
        end
        return Window
    end

    -- Lock / Unlock all elements
    function Window:LockAll()
        for _, el in ipairs(Window.AllElements or {}) do
            if el and el.Lock then pcall(function() el:Lock() end) end
        end
        return Window
    end
    function Window:UnlockAll()
        for _, el in ipairs(Window.AllElements or {}) do
            if el and el.UnLock then pcall(function() el:UnLock() end) end
        end
        return Window
    end

    -- Background Video
    local BackgroundVideo = nil
    function Window:SetBackgroundVideo(videoId, transparency)
        BackgroundGradientFrame.Visible = false
        BackgroundImage.Visible = false
        local id = tostring(videoId or "")
        if not id:find("rbxassetid://") then
            id = "rbxassetid://" .. id:gsub("%D", "")
        end
        if not BackgroundVideo then
            BackgroundVideo = Instance.new("VideoFrame")
            BackgroundVideo.Name = "BackgroundVideo"
            BackgroundVideo.Size = UDim2.new(1, 0, 1, 0)
            BackgroundVideo.BackgroundTransparency = 1
            BackgroundVideo.ZIndex = 0
            BackgroundVideo.Looped = true
            BackgroundVideo.Volume = 0
            BackgroundVideo.Parent = BackgroundLayer
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = BackgroundVideo
        end
        BackgroundVideo.Visible = true
        BackgroundVideo.Video = id
        local t = transparency
        if t == nil then t = Window.BackgroundImageTransparency or 0.35 end
        BackgroundVideo.BackgroundTransparency = 1
        pcall(function() BackgroundVideo:Play() end)
        Utility:TweenObject(Main, { BackgroundTransparency = math.clamp(0.55 + t * 0.3, 0.4, 0.85) }, 0.2)
        return Window
    end

    function Window:SetFont(fontId)
        fontId = fontId or "rbxassetid://12187365364"
        VoidUI.DefaultProps.TextLabel.FontFace = Font.new(fontId, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        for _, objData in pairs(VoidUI.Objects) do
            local o = objData.Object
            if o and o:IsA("TextLabel") or (o and o:IsA("TextButton")) or (o and o:IsA("TextBox")) then
                pcall(function()
                    o.FontFace = Font.new(fontId, o.FontFace.Weight, o.FontFace.Style)
                end)
            end
        end
        return Window
    end

    function Window:SetLanguage(lang)
        Window.Language = lang or "en"
        return Window
    end

    UI.Window = Window
    return Window
end

-- Loading Screen simples
function UI:LoadingScreen(Config)
    Config = Config or {}
    local Title = Config.Title or "Loading"
    local Desc = Config.Desc or "Please wait..."
    local Icon = Config.Icon or "loader"

    local Holder = VoidUI:Create("Frame", {
        Parent = game:GetService("CoreGui"),
        Name = "VoidLoading",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(8, 8, 10),
        BackgroundTransparency = 0.15,
        ZIndex = 9999,
    })

    local Card = VoidUI:Create("Frame", {
        Parent = Holder,
        Size = UDim2.new(0, 280, 0, 140),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = UI.Theme and UI.Theme.Background or Color3.fromRGB(16, 16, 16),
        ZIndex = 10000,
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 14) }),
    })

    VoidUI:Create("TextLabel", {
        Parent = Card,
        Size = UDim2.new(1, -24, 0, 28),
        Position = UDim2.new(0, 12, 0, 24),
        BackgroundTransparency = 1,
        Text = Title,
        TextSize = 18,
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10001,
    })

    local Status = VoidUI:Create("TextLabel", {
        Parent = Card,
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 56),
        BackgroundTransparency = 1,
        Text = Desc,
        TextSize = 13,
        TextTransparency = 0.4,
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10001,
    })

    local Track = VoidUI:Create("Frame", {
        Parent = Card,
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 1, -28),
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        ZIndex = 10001,
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    })

    local Fill = VoidUI:Create("Frame", {
        Parent = Track,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(80, 160, 255),
        ZIndex = 10002,
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    })

    local api = {}
    function api:SetStatus(t) Status.Text = tostring(t or "") end
    function api:SetProgress(p)
        p = math.clamp(tonumber(p) or 0, 0, 1)
        Utility:TweenObject(Fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.2)
    end
    function api:Close(delay)
        task.delay(delay or 0, function()
            if Holder then Holder:Destroy() end
        end)
    end
    return api
end

function UI:Notification(Config)
    coroutine.wrap(function()
        local Notification = {
            Title = Config.Title or "Notification",
            Desc = Config.Desc or Config.Content or nil,
            Icon = Config.Icon or nil,
            Duration = Config.Duration or 5,
            CanClose = Config.CanClose ~= false,
        }

        local Holder = UI.NotificationHolder
        if not Holder then return end

        local Wrapper = VoidUI:Create("Frame", {
            Parent = Holder,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = false,
            ZIndex = 401,
        })

        local Card = VoidUI:Create("Frame", {
            Parent = Wrapper,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = "Y",
            Position = UDim2.new(2, 0, 1, 0),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = UI.Theme.Background,
            BackgroundTransparency = 0.05,
            ClipsDescendants = true,
            ZIndex = 402,
            ThemeID = { BackgroundColor3 = "Background" },
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 14) }),
            VoidUI:Create("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                Thickness = 0.8,
                Transparency = 0.75,
                ThemeID = { Color = "Outline" },
            }),
        })

        local Inner = VoidUI:Create("Frame", {
            Parent = Card,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            ZIndex = 403,
        }, {
            VoidUI:Create("UIPadding", {
                PaddingTop = UDim.new(0, 14),
                PaddingBottom = UDim.new(0, 14),
                PaddingLeft = UDim.new(0, 14),
                PaddingRight = UDim.new(0, 14),
            }),
            VoidUI:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
        })

        if Notification.Icon then
            local iconData = GetIcon(Notification.Icon)
            local iconImg = VoidUI:Create("ImageLabel", {
                Parent = Inner,
                Size = UDim2.new(0, 26, 0, 26),
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                ZIndex = 404,
                ThemeID = { ImageColor3 = "IconColor" },
            })
            if typeof(iconData) == "table" then
                iconImg.Image = iconData.Image or ""
                if iconData.ImageRectOffset then iconImg.ImageRectOffset = iconData.ImageRectOffset end
                if iconData.ImageRectSize then iconImg.ImageRectSize = iconData.ImageRectSize end
            elseif typeof(iconData) == "string" then
                iconImg.Image = iconData
            end
        end

        local TextCol = VoidUI:Create("Frame", {
            Parent = Inner,
            Size = UDim2.new(1, Notification.Icon and -36 or 0, 0, 0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 404,
        }, {
            VoidUI:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
        })

        VoidUI:Create("TextLabel", {
            Parent = TextCol,
            Size = UDim2.new(1, Notification.CanClose and -24 or 0, 0, 0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            Text = Notification.Title,
            TextSize = 16,
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
            TextColor3 = UI.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            RichText = true,
            LayoutOrder = 1,
            ZIndex = 405,
            ThemeID = { TextColor3 = "Text" },
        })

        if Notification.Desc then
            VoidUI:Create("TextLabel", {
                Parent = TextCol,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = "Y",
                BackgroundTransparency = 1,
                Text = Notification.Desc,
                TextSize = 14,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
                TextColor3 = UI.Theme.Text,
                TextTransparency = 0.4,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                RichText = true,
                LayoutOrder = 2,
                ZIndex = 405,
                ThemeID = { TextColor3 = "Text" },
            })
        end

        local closed = false
        local function CloseNotif()
            if closed then return end
            closed = true
            Utility:TweenObject(Card, {Position = UDim2.new(2, 0, 1, 0)}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            Utility:TweenObject(Wrapper, {Size = UDim2.new(1, 0, 0, -8)}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            task.wait(0.25)
            Wrapper:Destroy()
        end

        if Notification.CanClose then
            local CloseBtn = VoidUI:Create("ImageButton", {
                Parent = Card,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -14, 0, 14),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Image = ResolveIconImage("x"),
                ImageTransparency = 0.4,
                ZIndex = 410,
                ThemeID = { ImageColor3 = "Text" },
            })
            CloseBtn.MouseButton1Click:Connect(CloseNotif)
        end

        -- Barra de duração (100% dentro do card)
        local DurTrack = VoidUI:Create("Frame", {
            Parent = Card,
            Size = UDim2.new(1, -16, 0, 3),
            Position = UDim2.new(0.5, 0, 1, -6),
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 406,
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        })
        local DurBar = VoidUI:Create("Frame", {
            Parent = DurTrack,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 407,
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        })

        task.wait()
        local h = math.max(Card.AbsoluteSize.Y + 4, 52)
        Utility:TweenObject(Wrapper, {Size = UDim2.new(1, 0, 0, h)}, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Utility:TweenObject(Card, {Position = UDim2.new(0, 0, 1, 0)}, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        if Notification.Duration and Notification.Duration > 0 then
            Utility:TweenObject(DurBar, {Size = UDim2.new(0, 0, 1, 0)}, Notification.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            task.wait(Notification.Duration)
            CloseNotif()
        end
    end)()
end


return UI

--[[local VoidUI = UI

local Window = VoidUI:CreateWindow({
    Name = "void ui",
    Icon = "door-open",
    SideBarWidth = 160,
    Theme = "Dark",
    Transparent = true,
    Author = "By Slowzzx4",
    User = {
        Enabled = true,
        Anonymous = true,
    },
    KeySystem = {
        HubName = "Void Hub X",
        Title = "Welcome to Void Hub X",
        Note = "Keyless will be enabled every weekend.",
        Discord = "https://discord.gg/your-invite",
        KeyValidator = function(key)
            return key == "1234"
        end,
        URL = "https://link-para-sua-key.com", -- fallback se Providers não for passado
        Providers = {
            { Name = "LootLabs", URL = "https://lootlabs.gg/...", Image = "rbxassetid://136873032740635" },
            { Name = "Linkvertise", URL = "https://linkvertise.com/...", Image = "rbxassetid://123672470195625" },
            { Name = "Work.ink", URL = "https://work.ink/...", Image = "rbxassetid://91939244392940" },
        },
    },
})

Window:EditOpenButton({
    Title = "Open void ui",
    Icon = "door-open",
    Transparency = 0.2,
    StrokeThickness = 1,
    Rotation = 0,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255))
    },
    AutoRotation = true,
    Speed = 15,
    CornerRadius = UDim.new(0,16),
})

VoidUI:CreateTopbarButton({
    Order = 4,
    Callback = function()
        print("Pisun")
    end
})
VoidUI:CreateTopbarToggle({
    Order = 4,
    EnableIcon = "banana",
    DisableIcon = "at-sign",
    Callback = function(Value)
        print(Value)
    end
})

Window:Tag({
    Name = "Version 1.0.6",
    Color = Color3.fromRGB(255, 45, 85)
})

local DisplayElements = Window:Tab({Title = "Display Elements",Icon = "picture-in-picture",Border = true,})
local ManagementTab = Window:Tab({Title = "Management", Icon = "chart-no-axes-gantt",Border = true,})
local InputTab = Window:Tab({Title = "Input Elements", Icon = "file-input",Border = true,})
local NotificationTab = Window:Tab({Title = "Notification", Icon = "message-square-dot",Border = true,})
local LockedTab = Window:Tab({Title = "Locked Elements", Icon = "lock-keyhole",Border = true,})
local GroupTab = Window:Tab({Title = "Group", Icon = "group",Border = true,})
Window:SelectTab(1)
local Section = Window:Section({ Title = "Other", Icon = "hash" })
local Settings = Section:Tab({ Title = "Settings", Icon = "settings",Border = true})

DisplayElements:Section({Title = "Section"})
DisplayElements:Paragraph({
    Title = "Paragraph",
    Desc = "This is a Paragraph",
})
DisplayElements:Paragraph({
    Title = "Paragraph Icon <smile>",
    Desc = "This is a Paragraph",
    Icon = "bird"
})
DisplayElements:Devider()
DisplayElements:Paragraph({
    Title = "Paragraph Thumbnail",
    Desc = "This is a Paragraph",
    Thumbnail = "rbxassetid://78903626783621",
    Icon = "solar:lock-keyhole-unlocked-broken"
})
DisplayElements:Section({Title = "Color Paragraph", Icon = "paintbrush"})
local Colors = {"Red", "Coral", "Orange", "Yellow", "Green", "Mint", "Cyan", "Blue", "Purple", "Pink"}
local ColorCount = 0
for i = 1, 10 do
    ColorCount = ColorCount + 1
    DisplayElements:Paragraph({Title = Colors[ColorCount],Color = Colors[ColorCount]})
end

--#ManagementTab
ManagementTab:Button({
    Title = "Button",
    Desc = "This is a button",
    Callback = function()
        print("Click")
    end
})
ManagementTab:Button({
    Title = "Test Text Icon <bird> bebebe",
    Desc = "This is a button <bird> bebebe",
    Callback = Utility:Debounce(function()
        print("bebebe")
    end, 10)
})
ManagementTab:Toggle({
    Title = "Toggle <toggle-left>",
    Desc = "This is a toggle",
    Callback = function(Value)
        print(Value)
    end
})
ManagementTab:Slider({
    Title = "Slider <settings-2>",
    Desc = "This is a slider",
    Value = {
        Min = 0,
        Max = 100,
        Default = 25,
    },
    Step = 1,
    Callback = function(Value)
        print(Value)
    end
})

ManagementTab:Dropdown({
	Title = "Dropdown <layout-template>",
    Desc = "This is a dropdown",
	Multi = false,
	Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10", "Option 11", "Option 12",
			"Option 13", "Option 14", "Option 15", "Option 16", "Option 17", "Option 18", "Option 19", "Option 20", "Option 21", "Option 22", "Option 23", "Option 24",
			"Option 25", "Option 26", "Option 27", "Option 28", "Option 29", "Option 30", "Pisun"},
	Value = "Option 1",
	Callback = function(Value)
		print(Value)
	end
})

ManagementTab:Dropdown({
	Title = "Multi Dropdown <layout-template>",
    Desc = "This is a multi dropdown",
	Multi = true,
	Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10", "Option 11", "Option 12",
			"Option 13", "Option 14", "Option 15", "Option 16", "Option 17", "Option 18", "Option 19", "Option 20", "Option 21", "Option 22", "Option 23", "Option 24",
			"Option 25", "Option 26", "Option 27", "Option 28", "Option 29", "Option 30", "Pisun"},
	Value = "Option 1",
	Callback = function(Value)
		print(unpack(Value))
	end
})

--#InputTab
local Input = InputTab:Input({
    Title = "Input <text-cursor-input>",
    Desc = "This is an input",
    Callback = function(input)
        print(input)
    end
})

local Input = InputTab:Input({
    Title = "Input Limit",
    MaxSymbols = 10,
    Desc = "This is an input",
    Callback = function(input)
        print(input)
    end
})

local Keybind = InputTab:Keybind({
    Title = "Keybind",
    Callback = function(key)
        print(key)
    end
})

NotificationTab:Button({
    Title = "Notification Icon",
    Callback = function()
        VoidUI:Notification({
            Title = "Title",
            Icon = "bird",
            Desc = "Pisun",
            Duration = 5
        })
    end
})
NotificationTab:Button({
    Title = "Notification",
    Callback = function()
        VoidUI:Notification({
            Title = "Title",
            Desc = "Pisun",
            Duration = 5
        })
    end
})

local LockBtn = LockedTab:Button({
    Title = "Button",
    Locked = true,
    Callback = function()
        print("Pisun")
    end
})

local LockTog = LockedTab:Toggle({
    Title = "Toggle",
    Locked = true,
    Callback = function(Value)
        print(Value)
    end
})

local LockSlider = LockedTab:Slider({
    Title = "Slider",
    Locked = true,
    Value = {
        Min = 0,
        Max = 100,
        Default = 25,
    },
    Step = 1,
    Callback = function(Value)
        print(Value)
    end
})

local LockDrop = LockedTab:Dropdown({
	Title = "Dropdown",
    Locked = true,
	Multi = false,
	Option = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10", "Option 11", "Option 12",
			"Option 13", "Option 14", "Option 15", "Option 16", "Option 17", "Option 18", "Option 19", "Option 20", "Option 21", "Option 22", "Option 23", "Option 24",
			"Option 25", "Option 26", "Option 27", "Option 28", "Option 29", "Option 30", "Pisun"},
	Value = "Option 1",
	Callback = function(Value)
		print(Value)
	end
})

local LockInp = LockedTab:Input({
    Title = "Input",
    Locked = true,
    Callback = function(input)
        print(input)
    end
})

local LockKey = LockedTab:Keybind({
    Title = "Keybind",
    Locked = true,
    Callback = function(key)
        print(key)
    end
})

LockedTab:Toggle({
    Title = "Lock / UnLock",
    Default = true,
    Callback = function(Value)
        if Value then
            LockBtn:Lock()
            LockTog:Lock()
            LockSlider:Lock()
            LockDrop:Lock()
            LockInp:Lock()
            LockKey:Lock()
        else
            LockBtn:UnLock()
            LockTog:UnLock()
            LockSlider:UnLock()
            LockDrop:UnLock()
            LockInp:UnLock()
            LockKey:UnLock()
        end
    end
})

GroupTab:Section({Title = "Group"})
local grid = GroupTab:Group({})
grid:Toggle({ Title = "One Element", Callback = function(v) print(v) end })
local grid = GroupTab:Group({})
grid:Toggle({ Title = "Aimbot", Callback = function(v) print(v) end })
grid:Toggle({ Title = "Triggerbot", Callback = function(v) print(v) end })
local grid = GroupTab:Group({})
grid:Toggle({ Title = "Test", Callback = function(v) print(v) end })
grid:Toggle({ Title = "Test", Callback = function(v) print(v) end })
grid:Toggle({ Title = "Test", Callback = function(v) print(v) end })

GroupTab:Section({Title = "Locked"})
local grid = GroupTab:Group({})
grid:Toggle({ Title = "Toggle", Locked = true,Callback = function(v) print(v) end })
grid:Toggle({ Title = "Toggle", Locked = true,Callback = function(v) print(v) end })
local grid = GroupTab:Group({})
grid:Toggle({ Title = "Toggle", Locked = true,Callback = function(v) print(v) end })
grid:Toggle({ Title = "Toggle", Locked = false,Callback = function(v) print(v) end })


Settings:Section({Title = "Window"})
Settings:Dropdown({
	Title = "Theme",
	Option = {"Dark","Light","Forest","Amethyst","Crimson","DarkBlue","Pink","Orange"},
	Value = "Dark",
	Callback = function(Value)
		Window:SetTheme(Value)
        VoidUI:Notification({
            Title = "Selected Theme: " .. Value,
            Icon = "bird",
            Duration = 2
        })
	end
})
Settings:Toggle({
    Title = "Transparent",
    Callback = function(Value)
        Window:SetTransparency(Value)
    end
})
local Settings1 = Settings:Group({})
Settings1:Toggle({
    Title = "Resizing",
    Default = true,
    Callback = function(Value)
        Window:SetResizable(Value)
    end
})
Settings1:Keybind({
    Title = "Toggle Key Window",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
Settings:Section({Title = "User"})
Settings:Toggle({
    Title = "Enabled",
    Callback = function(Value)
        Window:UserEnabled(Value)
    end
})
Settings:Toggle({
    Title = "Anonymous",
    Callback = function(Value)
        Window:Anonymous(Value)
    end
})

local n1 = 0
local n2 = 0
Settings:Section({Title = "Window Size"})
Settings:Slider({
    Title = "X",
    Value = {
        Min = 410,
        Max = 700,
        Default = 480,
    },
    Step = 1,
    Callback = function(Value)
        n1 = Value
    end
})
Settings:Slider({
    Title = "Z",
    Value = {
        Min = 280,
        Max = 700,
        Default = 360,
    },
    Step = 1,
    Callback = function(Value)
        n2 = Value
    end
})
Settings:Button({
    Title = "Apply",
    Callback = function()
        Window:Resize(n1,n2)
    end
})
Settings:Section({Title = "Other"})
Settings:Button({
    Title = "To Center",
    Callback = function()
        Window:ToCenter()
    end
})
Settings:Button({
    Title = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})
--]]
