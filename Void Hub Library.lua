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
    -- Cores pedidas + extras (Dark/Light intactos)
    Pink = {
        Name = "Pink",
        Background = Color3.fromHex("#1a0a12"),
        SideBar = Color3.fromHex("#2a1220"),
        Text = Color3.fromHex("#ffe4f1"),
        ElementColor = Color3.fromHex("#3a1a2c"),
        Outline = Color3.fromHex("#db2777"),
        Placeholder = Color3.fromHex("#f9a8d4"),
        IconColor = Color3.fromHex("#f472b6"),
    },
    Blue = {
        Name = "Blue",
        Background = Color3.fromHex("#0a1220"),
        SideBar = Color3.fromHex("#122038"),
        Text = Color3.fromHex("#e8f1ff"),
        ElementColor = Color3.fromHex("#1a2a48"),
        Outline = Color3.fromHex("#2563eb"),
        Placeholder = Color3.fromHex("#93c5fd"),
        IconColor = Color3.fromHex("#60a5fa"),
    },
    Purple = {
        Name = "Purple",
        Background = Color3.fromHex("#120a1c"),
        SideBar = Color3.fromHex("#1e1232"),
        Text = Color3.fromHex("#f3e8ff"),
        ElementColor = Color3.fromHex("#2a1a48"),
        Outline = Color3.fromHex("#7c3aed"),
        Placeholder = Color3.fromHex("#c4b5fd"),
        IconColor = Color3.fromHex("#a78bfa"),
    },
    Yellow = {
        Name = "Yellow",
        Background = Color3.fromHex("#1a1608"),
        SideBar = Color3.fromHex("#2a2210"),
        Text = Color3.fromHex("#fffbeb"),
        ElementColor = Color3.fromHex("#3a3218"),
        Outline = Color3.fromHex("#ca8a04"),
        Placeholder = Color3.fromHex("#fde68a"),
        IconColor = Color3.fromHex("#facc15"),
    },
    Green = {
        Name = "Green",
        Background = Color3.fromHex("#0a160e"),
        SideBar = Color3.fromHex("#122818"),
        Text = Color3.fromHex("#ecfdf5"),
        ElementColor = Color3.fromHex("#1a3824"),
        Outline = Color3.fromHex("#16a34a"),
        Placeholder = Color3.fromHex("#86efac"),
        IconColor = Color3.fromHex("#4ade80"),
    },
    Brown = {
        Name = "Brown",
        Background = Color3.fromHex("#16100a"),
        SideBar = Color3.fromHex("#261a12"),
        Text = Color3.fromHex("#faf5f0"),
        ElementColor = Color3.fromHex("#36281c"),
        Outline = Color3.fromHex("#92400e"),
        Placeholder = Color3.fromHex("#d6a57a"),
        IconColor = Color3.fromHex("#d97706"),
    },
    Red = {
        Name = "Red",
        Background = Color3.fromHex("#1a0808"),
        SideBar = Color3.fromHex("#2a1010"),
        Text = Color3.fromHex("#fef2f2"),
        ElementColor = Color3.fromHex("#3a1818"),
        Outline = Color3.fromHex("#dc2626"),
        Placeholder = Color3.fromHex("#fca5a5"),
        IconColor = Color3.fromHex("#f87171"),
    },
    Cyan = {
        Name = "Cyan",
        Background = Color3.fromHex("#08161a"),
        SideBar = Color3.fromHex("#102428"),
        Text = Color3.fromHex("#ecfeff"),
        ElementColor = Color3.fromHex("#183438"),
        Outline = Color3.fromHex("#0891b2"),
        Placeholder = Color3.fromHex("#67e8f9"),
        IconColor = Color3.fromHex("#22d3ee"),
    },
    Orange = {
        Name = "Orange",
        Background = Color3.fromHex("#1a1008"),
        SideBar = Color3.fromHex("#2a1a10"),
        Text = Color3.fromHex("#fff7ed"),
        ElementColor = Color3.fromHex("#3a2818"),
        Outline = Color3.fromHex("#ea580c"),
        Placeholder = Color3.fromHex("#fdba74"),
        IconColor = Color3.fromHex("#fb923c"),
    },
    Lime = {
        Name = "Lime",
        Background = Color3.fromHex("#0e1608"),
        SideBar = Color3.fromHex("#1a2810"),
        Text = Color3.fromHex("#f7fee7"),
        ElementColor = Color3.fromHex("#263818"),
        Outline = Color3.fromHex("#65a30d"),
        Placeholder = Color3.fromHex("#bef264"),
        IconColor = Color3.fromHex("#a3e635"),
    },
    Teal = {
        Name = "Teal",
        Background = Color3.fromHex("#081614"),
        SideBar = Color3.fromHex("#102822"),
        Text = Color3.fromHex("#f0fdfa"),
        ElementColor = Color3.fromHex("#183830"),
        Outline = Color3.fromHex("#0d9488"),
        Placeholder = Color3.fromHex("#5eead4"),
        IconColor = Color3.fromHex("#2dd4bf"),
    },
    Indigo = {
        Name = "Indigo",
        Background = Color3.fromHex("#0c0a1a"),
        SideBar = Color3.fromHex("#161232"),
        Text = Color3.fromHex("#eef2ff"),
        ElementColor = Color3.fromHex("#221e48"),
        Outline = Color3.fromHex("#4f46e5"),
        Placeholder = Color3.fromHex("#a5b4fc"),
        IconColor = Color3.fromHex("#818cf8"),
    },
    Violet = {
        Name = "Violet",
        Background = Color3.fromHex("#140a1c"),
        SideBar = Color3.fromHex("#221232"),
        Text = Color3.fromHex("#f5f3ff"),
        ElementColor = Color3.fromHex("#321a48"),
        Outline = Color3.fromHex("#8b5cf6"),
        Placeholder = Color3.fromHex("#c4b5fd"),
        IconColor = Color3.fromHex("#a78bfa"),
    },
    Magenta = {
        Name = "Magenta",
        Background = Color3.fromHex("#1a0816"),
        SideBar = Color3.fromHex("#2a1224"),
        Text = Color3.fromHex("#fdf4ff"),
        ElementColor = Color3.fromHex("#3a1a34"),
        Outline = Color3.fromHex("#c026d3"),
        Placeholder = Color3.fromHex("#e879f9"),
        IconColor = Color3.fromHex("#e879f9"),
    },
    Sky = {
        Name = "Sky",
        Background = Color3.fromHex("#08141c"),
        SideBar = Color3.fromHex("#102028"),
        Text = Color3.fromHex("#f0f9ff"),
        ElementColor = Color3.fromHex("#182e3a"),
        Outline = Color3.fromHex("#0284c7"),
        Placeholder = Color3.fromHex("#7dd3fc"),
        IconColor = Color3.fromHex("#38bdf8"),
    },
    Amber = {
        Name = "Amber",
        Background = Color3.fromHex("#1a1408"),
        SideBar = Color3.fromHex("#2a2010"),
        Text = Color3.fromHex("#fffbeb"),
        ElementColor = Color3.fromHex("#3a3018"),
        Outline = Color3.fromHex("#d97706"),
        Placeholder = Color3.fromHex("#fcd34d"),
        IconColor = Color3.fromHex("#fbbf24"),
    },
    Emerald = {
        Name = "Emerald",
        Background = Color3.fromHex("#081610"),
        SideBar = Color3.fromHex("#10281c"),
        Text = Color3.fromHex("#ecfdf5"),
        ElementColor = Color3.fromHex("#183828"),
        Outline = Color3.fromHex("#059669"),
        Placeholder = Color3.fromHex("#6ee7b7"),
        IconColor = Color3.fromHex("#34d399"),
    },
    Coral = {
        Name = "Coral",
        Background = Color3.fromHex("#1a0e0c"),
        SideBar = Color3.fromHex("#2a1814"),
        Text = Color3.fromHex("#fff5f3"),
        ElementColor = Color3.fromHex("#3a2420"),
        Outline = Color3.fromHex("#e11d48"),
        Placeholder = Color3.fromHex("#fda4af"),
        IconColor = Color3.fromHex("#fb7185"),
    },
    Gold = {
        Name = "Gold",
        Background = Color3.fromHex("#1a160a"),
        SideBar = Color3.fromHex("#2a2212"),
        Text = Color3.fromHex("#fffbeb"),
        ElementColor = Color3.fromHex("#3a321a"),
        Outline = Color3.fromHex("#b45309"),
        Placeholder = Color3.fromHex("#fcd34d"),
        IconColor = Color3.fromHex("#eab308"),
    },
    Silver = {
        Name = "Silver",
        Background = Color3.fromHex("#121214"),
        SideBar = Color3.fromHex("#1c1c20"),
        Text = Color3.fromHex("#f8fafc"),
        ElementColor = Color3.fromHex("#2a2a30"),
        Outline = Color3.fromHex("#94a3b8"),
        Placeholder = Color3.fromHex("#cbd5e1"),
        IconColor = Color3.fromHex("#e2e8f0"),
    },
    Navy = {
        Name = "Navy",
        Background = Color3.fromHex("#060e1a"),
        SideBar = Color3.fromHex("#0e1a2e"),
        Text = Color3.fromHex("#e8eef8"),
        ElementColor = Color3.fromHex("#162440"),
        Outline = Color3.fromHex("#1e3a8a"),
        Placeholder = Color3.fromHex("#93c5fd"),
        IconColor = Color3.fromHex("#3b82f6"),
    },
    Mint = {
        Name = "Mint",
        Background = Color3.fromHex("#0a1612"),
        SideBar = Color3.fromHex("#122820"),
        Text = Color3.fromHex("#f0fdf9"),
        ElementColor = Color3.fromHex("#1a382e"),
        Outline = Color3.fromHex("#10b981"),
        Placeholder = Color3.fromHex("#6ee7b7"),
        IconColor = Color3.fromHex("#34d399"),
    },
    Peach = {
        Name = "Peach",
        Background = Color3.fromHex("#1a120e"),
        SideBar = Color3.fromHex("#2a1e18"),
        Text = Color3.fromHex("#fff7ed"),
        ElementColor = Color3.fromHex("#3a2c24"),
        Outline = Color3.fromHex("#ea580c"),
        Placeholder = Color3.fromHex("#fdba74"),
        IconColor = Color3.fromHex("#fb923c"),
    },
    Lavender = {
        Name = "Lavender",
        Background = Color3.fromHex("#12101a"),
        SideBar = Color3.fromHex("#1e1a2e"),
        Text = Color3.fromHex("#f5f3ff"),
        ElementColor = Color3.fromHex("#2c2642"),
        Outline = Color3.fromHex("#8b5cf6"),
        Placeholder = Color3.fromHex("#c4b5fd"),
        IconColor = Color3.fromHex("#a78bfa"),
    },
    Crimson = {
        Name = "Crimson",
        Background = Color3.fromHex("#1c0606"),
        SideBar = Color3.fromHex("#450a0a"),
        Text = Color3.fromHex("#fef2f2"),
        ElementColor = Color3.fromRGB(50, 20, 20),
        Outline = Color3.fromHex("#991b1b"),
        Placeholder = Color3.fromHex("#d95353"),
        IconColor = Color3.fromHex("#f87171"),
    },
    Forest = {
        Name = "Forest",
        Background = Color3.fromRGB(12, 18, 14),
        SideBar = Color3.fromRGB(20, 30, 24),
        Text = Color3.fromRGB(225, 240, 225),
        ElementColor = Color3.fromRGB(32, 48, 38),
        Outline = Color3.fromRGB(60, 120, 80),
        Placeholder = Color3.fromRGB(100, 180, 120),
        IconColor = Color3.fromRGB(80, 200, 120),
    },
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromHex("#060810"),
        SideBar = Color3.fromHex("#0c101c"),
        Text = Color3.fromHex("#e8ecf8"),
        ElementColor = Color3.fromHex("#141a2c"),
        Outline = Color3.fromHex("#334155"),
        Placeholder = Color3.fromHex("#94a3b8"),
        IconColor = Color3.fromHex("#64748b"),
    },
    Neon = {
        Name = "Neon",
        Background = Color3.fromHex("#0a0a12"),
        SideBar = Color3.fromHex("#12121e"),
        Text = Color3.fromHex("#f0fff4"),
        ElementColor = Color3.fromHex("#1a1a2c"),
        Outline = Color3.fromHex("#22c55e"),
        Placeholder = Color3.fromHex("#86efac"),
        IconColor = Color3.fromHex("#39ff14"),
    },
    Sunset = {
        Name = "Sunset",
        Background = Color3.fromHex("#1a0c10"),
        SideBar = Color3.fromHex("#2a141c"),
        Text = Color3.fromHex("#fff5f0"),
        ElementColor = Color3.fromHex("#3a1e28"),
        Outline = Color3.fromHex("#f97316"),
        Placeholder = Color3.fromHex("#fdba74"),
        IconColor = Color3.fromHex("#fb7185"),
    },
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromHex("#061018"),
        SideBar = Color3.fromHex("#0e1c2a"),
        Text = Color3.fromHex("#e8f4ff"),
        ElementColor = Color3.fromHex("#162838"),
        Outline = Color3.fromHex("#0ea5e9"),
        Placeholder = Color3.fromHex("#7dd3fc"),
        IconColor = Color3.fromHex("#38bdf8"),
    },
    Grape = {
        Name = "Grape",
        Background = Color3.fromHex("#120816"),
        SideBar = Color3.fromHex("#1e1028"),
        Text = Color3.fromHex("#faf5ff"),
        ElementColor = Color3.fromHex("#2c183c"),
        Outline = Color3.fromHex("#9333ea"),
        Placeholder = Color3.fromHex("#d8b4fe"),
        IconColor = Color3.fromHex("#c084fc"),
    },

    -- WindUI-inspired themes (sem Rainbow)
    White = {
        Name = "White",
        Background = Color3.fromHex("#f8fafc"),
        SideBar = Color3.fromHex("#e2e8f0"),
        Text = Color3.fromHex("#0f172a"),
        ElementColor = Color3.fromHex("#ffffff"),
        Outline = Color3.fromHex("#cbd5e1"),
        Placeholder = Color3.fromHex("#64748b"),
        IconColor = Color3.fromHex("#334155"),
    },
    Gray = {
        Name = "Gray",
        Background = Color3.fromHex("#18181b"),
        SideBar = Color3.fromHex("#27272a"),
        Text = Color3.fromHex("#fafafa"),
        ElementColor = Color3.fromHex("#3f3f46"),
        Outline = Color3.fromHex("#52525b"),
        Placeholder = Color3.fromHex("#a1a1aa"),
        IconColor = Color3.fromHex("#d4d4d8"),
    },
    Stone = {
        Name = "Stone",
        Background = Color3.fromHex("#1c1917"),
        SideBar = Color3.fromHex("#292524"),
        Text = Color3.fromHex("#fafaf9"),
        ElementColor = Color3.fromHex("#44403c"),
        Outline = Color3.fromHex("#78716c"),
        Placeholder = Color3.fromHex("#a8a29e"),
        IconColor = Color3.fromHex("#d6d3d1"),
    },
    Zinc = {
        Name = "Zinc",
        Background = Color3.fromHex("#09090b"),
        SideBar = Color3.fromHex("#18181b"),
        Text = Color3.fromHex("#fafafa"),
        ElementColor = Color3.fromHex("#27272a"),
        Outline = Color3.fromHex("#3f3f46"),
        Placeholder = Color3.fromHex("#71717a"),
        IconColor = Color3.fromHex("#a1a1aa"),
    },
    Slate = {
        Name = "Slate",
        Background = Color3.fromHex("#0f172a"),
        SideBar = Color3.fromHex("#1e293b"),
        Text = Color3.fromHex("#f8fafc"),
        ElementColor = Color3.fromHex("#334155"),
        Outline = Color3.fromHex("#475569"),
        Placeholder = Color3.fromHex("#94a3b8"),
        IconColor = Color3.fromHex("#cbd5e1"),
    },
    Rose = {
        Name = "Rose",
        Background = Color3.fromHex("#1f0308"),
        SideBar = Color3.fromHex("#4c0519"),
        Text = Color3.fromHex("#fdf2f8"),
        ElementColor = Color3.fromHex("#881337"),
        Outline = Color3.fromHex("#be185d"),
        Placeholder = Color3.fromHex("#f9a8d4"),
        IconColor = Color3.fromHex("#fb7185"),
    },

}

UI.Theme = VoidUI.Themes["Dark"]
UI._ActiveDropdownClose = nil
function UI:CloseActiveDropdown()
    if UI._ActiveDropdownClose then
        local fn = UI._ActiveDropdownClose
        UI._ActiveDropdownClose = nil
        pcall(fn)
    end
end

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
        -- tema completo estilo WindUI (cores da UI + ícones)
        UI.Theme = {
            Name = theme.Name or themeName,
            Background = theme.Background,
            SideBar = theme.SideBar,
            Text = theme.Text,
            ElementColor = theme.ElementColor,
            Outline = theme.Outline,
            Placeholder = theme.Placeholder,
            IconColor = theme.IconColor or theme.Text,
        }
        VoidUI:UpdateTheme(nil, true)
        local iconCol = UI.Theme.IconColor
        local function paintIcons(root)
            if not root then return end
            for _, d in ipairs(root:GetDescendants()) do
                if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                    pcall(function() d.ImageColor3 = iconCol end)
                end
            end
        end
        pcall(function() paintIcons(Main) end)
        pcall(function() paintIcons(OpenButtonHolder) end)
        -- restaura acrylic se estava ativo
        if Window.Acrylic then
            pcall(function() Main.BackgroundTransparency = 0.55 end)
        end
        UI:CloseActiveDropdown()
        for _, el in ipairs(Window.AllElements or {}) do
            if type(el) == "table" and el.RefreshTheme then
                pcall(el.RefreshTheme)
            end
        end
        return Window
    end

    Window:SetTheme(Window.Theme)

    --UIMinimized / Open Button (estilo WindUI / Main.lua — arrastável)
    local Main

    -- =========================================================
    -- Open/Close button: quadrado preto no LADO ESQUERDO
    -- posição salva + nunca sai da tela
    -- =========================================================
    local OPEN_BTN_SIZE = 44
    local OPEN_BTN_MARGIN = 8
    local OpenBtnConfigPath = "VoidHub_OpenButtonPos.json"

    local function clampOpenButtonPos(x, y, btnSize)
        btnSize = btnSize or OPEN_BTN_SIZE
        local cam = workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
        local maxX = math.max(OPEN_BTN_MARGIN, vp.X - btnSize - OPEN_BTN_MARGIN)
        local maxY = math.max(OPEN_BTN_MARGIN, vp.Y - btnSize - OPEN_BTN_MARGIN)
        x = math.clamp(x, OPEN_BTN_MARGIN, maxX)
        y = math.clamp(y, OPEN_BTN_MARGIN, maxY)
        return x, y
    end

    local function getDefaultOpenButtonPos()
        -- lado esquerdo, centro vertical
        local cam = workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
        local x = OPEN_BTN_MARGIN + 4
        local y = math.floor(vp.Y * 0.5 - OPEN_BTN_SIZE * 0.5)
        return clampOpenButtonPos(x, y)
    end

    local function loadOpenButtonPos()
        if isfile and isfile(OpenBtnConfigPath) then
            local ok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(OpenBtnConfigPath))
            end)
            if ok and type(data) == "table" and data.x and data.y then
                return clampOpenButtonPos(tonumber(data.x) or 0, tonumber(data.y) or 0)
            end
        end
        return getDefaultOpenButtonPos()
    end

    local function saveOpenButtonPos(x, y)
        if not writefile then return end
        pcall(function()
            writefile(OpenBtnConfigPath, game:GetService("HttpService"):JSONEncode({ x = x, y = y }))
        end)
    end

    local savedX, savedY = loadOpenButtonPos()

    local OpenButtonHolder = VoidUI:Create("Frame", {
        Parent = UIScreen,
        Size = UDim2.new(0, OPEN_BTN_SIZE, 0, OPEN_BTN_SIZE),
        Position = UDim2.new(0, savedX, 0, savedY),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 200,
        Active = true,
    })

    local OpenButton = VoidUI:Create("Frame", {
        Parent = OpenButtonHolder,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        BackgroundTransparency = 0.05,
        ZIndex = 201,
        Active = true,
        ThemeID = { BackgroundColor3 = "Background" },
    }, {
        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        VoidUI:Create("UIStroke", {
            Thickness = 1,
            Color = Color3.fromRGB(40, 40, 40),
            ThemeID = { Color = "Outline" },
        }),
    })

    local OpenClickBtn = VoidUI:Create("TextButton", {
        Parent = OpenButton,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 203,
    })

    local OpenBtnIcon = VoidUI:Create("ImageLabel", {
        Parent = OpenButton,
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = ResolveIconImage(Window.Icon or "door-open"),
        ZIndex = 202,
        ThemeID = { ImageColor3 = "IconColor" },
    })
    do
        local d = GetIcon(Window.Icon or "door-open")
        if typeof(d) == "table" then
            OpenBtnIcon.Image = d.Image or OpenBtnIcon.Image
            if d.ImageRectOffset then OpenBtnIcon.ImageRectOffset = d.ImageRectOffset end
            if d.ImageRectSize then OpenBtnIcon.ImageRectSize = d.ImageRectSize end
        elseif typeof(d) == "string" then
            OpenBtnIcon.Image = d
        end
    end

    Window._OpenBtnUserMoved = false
    do
        local dragging, dragStart, startAbs, moved
        OpenClickBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startAbs = OpenButtonHolder.AbsolutePosition
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if moved then
                            local pos = OpenButtonHolder.AbsolutePosition
                            local x, y = clampOpenButtonPos(pos.X, pos.Y, OpenButtonHolder.AbsoluteSize.X)
                            OpenButtonHolder.Position = UDim2.new(0, x, 0, y)
                            saveOpenButtonPos(x, y)
                            Window._OpenBtnUserMoved = true
                        end
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                if delta.Magnitude > 4 then moved = true end
                local nx, ny = clampOpenButtonPos(startAbs.X + delta.X, startAbs.Y + delta.Y, OPEN_BTN_SIZE)
                OpenButtonHolder.AnchorPoint = Vector2.new(0, 0)
                OpenButtonHolder.Position = UDim2.new(0, nx, 0, ny)
            end
        end)
        -- re-clamp on viewport resize
        if workspace.CurrentCamera then
            workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                local pos = OpenButtonHolder.AbsolutePosition
                local x, y = clampOpenButtonPos(pos.X, pos.Y, OpenButtonHolder.AbsoluteSize.X)
                OpenButtonHolder.Position = UDim2.new(0, x, 0, y)
            end)
        end
    end

    local MinzUI = OpenButtonHolder
    local UIIcon = OpenBtnIcon
    local OpenBtnTitle = { Text = Window.Name }

    function Window:EditOpenButton(Config)
        Config = Config or {}
        local Edit = {
            Title = Config.Title or Window.Name,
            Icon = Config.Icon or Window.Icon,
            Image = Config.Image or Config.IconImage,
            Transparency = Config.Transparency,
            CornerRadius = Config.CornerRadius or UDim.new(0, 10),
            Size = Config.Size or OPEN_BTN_SIZE,
            Color = Config.Color,
        }
        OpenBtnTitle.Text = Edit.Title
        if OpenButton:FindFirstChildOfClass("UICorner") then
            OpenButton.UICorner.CornerRadius = Edit.CornerRadius
        end
        if typeof(Edit.Transparency) == "number" then
            OpenButton.BackgroundTransparency = Edit.Transparency
        end
        if typeof(Edit.Size) == "number" then
            OpenButtonHolder.Size = UDim2.new(0, Edit.Size, 0, Edit.Size)
            local pos = OpenButtonHolder.AbsolutePosition
            local x, y = clampOpenButtonPos(pos.X, pos.Y, Edit.Size)
            OpenButtonHolder.Position = UDim2.new(0, x, 0, y)
        end
        local img = Edit.Image
        if not img and Edit.Icon then
            local iconData = GetIcon(Edit.Icon)
            if typeof(iconData) == "table" then
                img = iconData.Image
                if iconData.ImageRectOffset then OpenBtnIcon.ImageRectOffset = iconData.ImageRectOffset end
                if iconData.ImageRectSize then OpenBtnIcon.ImageRectSize = iconData.ImageRectSize end
            elseif typeof(iconData) == "string" then
                img = iconData
            end
        end
        if typeof(img) == "number" then img = "rbxassetid://" .. tostring(img) end
        if typeof(img) == "string" and img ~= "" then OpenBtnIcon.Image = img end
        UIIcon = OpenBtnIcon
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
        Position = UDim2.new(0.5, 0, 0.48, 0), -- um pouco acima do centro
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
        if BackgroundVideo then
            pcall(function()
                BackgroundVideo:Pause()
                BackgroundVideo.Visible = false
            end)
        end
        local img = image
        if typeof(img) == "number" then
            img = "rbxassetid://" .. tostring(img)
        elseif typeof(img) == "string" then
            img = img:gsub("%s+", "")
            local digits = img:match("%d+")
            if digits then
                if not img:find("rbxassetid://") and not img:find("http") then
                    img = "rbxassetid://" .. digits
                end
            end
        else
            img = ""
        end
        if typeof(img) ~= "string" or img == "" or not img:match("%d+") then
            warn("[Void Ui] SetBackgroundImage: invalid id")
            return Window
        end
        BackgroundImage.Visible = true
        BackgroundImage.Image = img
        BackgroundLayer.Visible = true
        local t = transparency
        if t == nil then t = Window.BackgroundImageTransparency or 0.25 end
        t = math.clamp(tonumber(t) or 0.25, 0, 1)
        Window.BackgroundImageTransparency = t
        BackgroundImage.ZIndex = 0
        BackgroundLayer.ZIndex = 0
        Main.BackgroundTransparency = math.clamp(0.55 + t * 0.35, 0.45, 0.92)
        BackgroundImage.ImageTransparency = math.clamp(t, 0.05, 0.75)
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
    TopBarF1.Size = UDim2.new(0,Window.Size.X.Offset - 5 - 5 - 5- 220,0,Window.Topbar.Height)

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
        Size = UDim2.new(0, 220, 0, Window.Topbar.Height),
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
        TopBarF1.Size = UDim2.new(0,Window.Size.X.Offset - 5 - 5 - 5 - 5 -TopBarF2.Size.X.Offset - 220,0,35)
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
        TopBarF1.Size = UDim2.new(0,Window.Size.X.Offset - 5 - 5 - 5 - 5 -TopBarF2.Size.X.Offset - 220,0,35)

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
        Size = UDim2.new(0, 78, 0, 25),
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Active = true,
        LayoutOrder = 2,
        Position = UDim2.new(0, 36, 0.5, 0),
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
        Size = UDim2.new(0, 86, 0, 32),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Active = true,
        LayoutOrder = 4,
        Position = UDim2.new(1, -6, 0.5, 0),
        BorderSizePixel = 0,
        ZIndex = 100,
    },{
        VoidUI:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
        }),
        VoidUI:Create("UIPadding", {
            PaddingRight = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 4),
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
        UI:CloseActiveDropdown()
        i = tonumber(i) or 1
        local tab = Window.TabList and Window.TabList[i]
        if tab and tab.Select then
            tab.Select()
            Window.SelectedTabIndex = i
        end
        return Window
    end

    function Window:SelectFirstTab()
        return Window:SelectTab(1)
    end

    function Window:Tab(Config, type)
        local Tab = {
            Title = Config.Title or "Tab",
            Icon = Config.Icon or nil,
            Border = Config.Border or false,
            Callback = Config.Callback or function() end,
            Elements = {},
        }
        function Tab:LockAll()
            for _, el in ipairs(Tab.Elements) do
                if el and el.Lock then pcall(function() el:Lock() end) end
            end
            return Tab
        end
        function Tab:UnlockAll()
            for _, el in ipairs(Tab.Elements) do
                if el and el.UnLock then pcall(function() el:UnLock() end) end
            end
            return Tab
        end
        local function registerElement(el)
            table.insert(Window.AllElements, el)
            table.insert(Tab.Elements, el)
            return el
        end

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
            UI:CloseActiveDropdown()
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

            -- animação ao clicar (scale + fade)
            local function pressAnim(down)
                pcall(function()
                    if down then
                        Utility:TweenObject(ButtonFrame, { BackgroundTransparency = 0.15 }, 0.08)
                        Utility:TweenObject(Beeee, { Size = UDim2.new(1, -4, 0, (Button.SizeY or 40) - 2) }, 0.08)
                    else
                        Utility:TweenObject(ButtonFrame, { BackgroundTransparency = 0 }, 0.12)
                        Utility:TweenObject(Beeee, { Size = UDim2.new(1, -7, 0, Button.SizeY or 40) }, 0.12)
                    end
                end)
            end
            ButtonTRG.MouseButton1Down:Connect(function()
                if not Button.Locked then pressAnim(true) end
            end)
            ButtonTRG.MouseButton1Up:Connect(function()
                if not Button.Locked then pressAnim(false) end
            end)
            ButtonTRG.MouseLeave:Connect(function()
                if not Button.Locked then pressAnim(false) end
            end)

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
            registerElement(Button)
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
                local iconCol = (UI.Theme and UI.Theme.IconColor) or Color3.fromRGB(200, 200, 200)
                local elCol = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(45, 45, 48)
                local trackOff = elCol
                local trackOn = iconCol
                if newValue then
                    Utility:TweenObject(ToggleV, {BackgroundColor3 = trackOn}, 0.18)
                    Utility:TweenObject(knob, {
                        Position = UDim2.new(0, 29, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0,
                    }, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                else
                    Utility:TweenObject(ToggleV, {BackgroundColor3 = trackOff}, 0.18)
                    Utility:TweenObject(knob, {
                        Position = UDim2.new(0, 11, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(160, 160, 165),
                        BackgroundTransparency = 0,
                    }, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                end

                spawn(function()
                    pcall(Togglee.Callback, Val)
                end)
                return Togglee
            end

            function Togglee:RefreshTheme()
                local fire = Togglee.Callback
                Togglee.Callback = function() end
                Togglee:SetValue(Val)
                Togglee.Callback = fire
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
            registerElement(Togglee)
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
            registerElement(Slider)
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
                BackgroundColor3 = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 0.35,
                Size = UDim2.new(0, 119, 0, 25),
                ZIndex = 15,
                ThemeID = {
                    BackgroundColor3 = "ElementColor"
                }
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                VoidUI:Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.8,
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
            local dropFollowConn = nil

            local function rebuildItemsInto(parentScroll)
                for _, child in ipairs(parentScroll:GetChildren()) do
                    if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
                end
                local items = Dropdown.Option or {}
                local txtCol = (UI.Theme and UI.Theme.Text) or Color3.fromRGB(255, 255, 255)
                for idx, Item in ipairs(items) do
                    local selected = false
                    if Dropdown.Multi then
                        for _, v in ipairs(Dropdown.Options or {}) do
                            if v == Item then selected = true break end
                        end
                    else
                        selected = (Dropdown.Value == Item)
                    end

                    -- estilo WindUI: fundo mais claro no selecionado / hover
                    local elCol = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(40, 40, 44)
                    local row = VoidUI:Create("TextButton", {
                        Parent = parentScroll,
                        Size = UDim2.new(1, -8, 0, 32),
                        BackgroundTransparency = selected and 0.15 or 1,
                        BackgroundColor3 = elCol,
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
                        Size = UDim2.new(1, -16, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        BackgroundTransparency = 1,
                        Text = tostring(Item),
                        TextTransparency = selected and 0 or 0.25,
                        TextSize = 13,
                        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
                        TextColor3 = txtCol,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        ZIndex = 921,
                    })

                    row.MouseEnter:Connect(function()
                        if not selected then
                            row.BackgroundTransparency = 0.45
                        end
                    end)
                    row.MouseLeave:Connect(function()
                        local still = (Dropdown.Value == Item)
                        if Dropdown.Multi then
                            still = false
                            for _, ov in ipairs(Dropdown.Options or {}) do
                                if ov == Item then still = true break end
                            end
                        end
                        row.BackgroundTransparency = still and 0.15 or 1
                    end)

                    local function pick()
                        if Dropdown.Locked then return end
                        selectingItem = true
                        -- highlight claro no clique (estilo Wind)
                        row.BackgroundTransparency = 0.05
                        label.TextTransparency = 0
                        if not Dropdown.Multi then
                            Dropdown.Value = Item
                            DropOptionBox.Text = tostring(Item)
                            task.spawn(Dropdown.Callback, Item)
                            task.delay(0.08, closeDropdown)
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
                                        r.BackgroundTransparency = isSel and 0.15 or 1
                                        lab.TextTransparency = isSel and 0 or 0.25
                                    end
                                end
                            end
                            task.spawn(Dropdown.Callback, Dropdown.Options)
                        end
                        task.delay(0.05, function() selectingItem = false end)
                    end
                    row.MouseButton1Click:Connect(pick)
                end
            end

            local function stopDropFollow()
                if dropFollowConn then
                    dropFollowConn:Disconnect()
                    dropFollowConn = nil
                end
            end

            local function placeMenuInsideMain(menu, menuW, menuH)
                if not menu or not Main then return end
                local mainPos = Main.AbsolutePosition
                local mainSize = Main.AbsoluteSize
                local trigger = DropValueFrame.AbsolutePosition
                local triggerSize = DropValueFrame.AbsoluteSize
                -- se não couber embaixo, sobe o scroll da Right para caber DENTRO da UI
                local spaceBelow = mainSize.Y - ((trigger.Y - mainPos.Y) + triggerSize.Y + 8)
                if spaceBelow < menuH and RightScroll then
                    local need = menuH - spaceBelow + 16
                    RightScroll.CanvasPosition = Vector2.new(
                        RightScroll.CanvasPosition.X,
                        RightScroll.CanvasPosition.Y + need
                    )
                    -- atualiza após scroll
                    trigger = DropValueFrame.AbsolutePosition
                    triggerSize = DropValueFrame.AbsoluteSize
                    mainPos = Main.AbsolutePosition
                    mainSize = Main.AbsoluteSize
                end
                local rightEdge = mainPos.X + mainSize.X - 6
                local leftLimit = mainPos.X + (Window.SideBarWidth or 160) + 6
                local preferX = trigger.X + triggerSize.X - menuW
                if preferX < leftLimit then preferX = trigger.X end
                if preferX + menuW > rightEdge then preferX = rightEdge - menuW end
                if preferX < leftLimit then preferX = leftLimit end
                local relX = preferX - mainPos.X
                local relY = (trigger.Y + triggerSize.Y + 6) - mainPos.Y
                relX = math.clamp(relX, 4, math.max(4, mainSize.X - menuW - 4))
                if relY + menuH > mainSize.Y - 4 then
                    menuH = math.max(80, mainSize.Y - relY - 8)
                end
                menu.Position = UDim2.new(0, relX, 0, relY)
                menu.Size = UDim2.new(0, menuW, 0, menuH)
            end

            local DropBlocker = nil

            local function closeDropdown()
                if not DropOpen and not FloatingMenu then return end
                DropOpen = false
                stopDropFollow()
                if UI._ActiveDropdownClose == closeDropdown then
                    UI._ActiveDropdownClose = nil
                end
                pcall(function() DropIcon.Rotation = 0 end)
                if SearchBox then
                    lastDropSearch = SearchBox.Text or lastDropSearch
                end
                if DropBlocker then
                    pcall(function() DropBlocker:Destroy() end)
                    DropBlocker = nil
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
                UI:CloseActiveDropdown()
                DropOpen = true
                openTick = tick()
                UI._ActiveDropdownClose = closeDropdown
                destroyFloating()
                stopDropFollow()

                task.defer(function()
                    if not DropOpen then return end
                    -- largura ponta a ponta do RightScroll, com margem (não encosta)
                    -- largura = campo do dropdown (não estoura a Right)
                    local absSize = DropValueFrame.AbsoluteSize
                    local mainSize = Main and Main.AbsoluteSize or Vector2.new(480, 360)
                    local maxW = math.max(120, mainSize.X - (Window.SideBarWidth or 160) - 24)
                    local menuW = math.clamp(math.max(absSize.X, 140), 120, maxW)
                    local itemCount = #(Dropdown.Option or {})
                    local menuH = math.min(math.max(itemCount * 34 + 48, 100), math.min(280, mainSize.Y - 24))

                    local themeBg = (UI.Theme and UI.Theme.Background) or Color3.fromRGB(18, 18, 20)
                    local themeOutline = (UI.Theme and UI.Theme.Outline) or Color3.fromRGB(70, 70, 75)
                    local themeText = (UI.Theme and UI.Theme.Text) or Color3.fromRGB(255, 255, 255)

                    -- bloqueia interação com a UI (só dropdown fica ativo)
                    DropBlocker = VoidUI:Create("TextButton", {
                        Parent = UIScreen,
                        Name = "VoidDropBlocker",
                        Size = UDim2.new(1, 0, 1, 0),
                        Position = UDim2.new(0, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 850,
                        Active = true,
                    })
                    DropBlocker.MouseButton1Click:Connect(function()
                        closeDropdown()
                    end)

                    FloatingMenu = VoidUI:Create("Frame", {
                        Parent = Main,
                        Name = "VoidDropdownMenu",
                        Size = UDim2.new(0, menuW, 0, menuH),
                        BackgroundColor3 = themeBg,
                        BackgroundTransparency = Window.Transparent and 0.06 or 0,
                        ZIndex = 900,
                        ClipsDescendants = true,
                        Active = true,
                    }, {
                        VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 14) }),
                        VoidUI:Create("UIStroke", {
                            Color = themeOutline,
                            Thickness = 1,
                            Transparency = 0.35,
                        }),
                    })
                    placeMenuInsideMain(FloatingMenu, menuW, menuH)
                    dropFollowConn = game:GetService("RunService").RenderStepped:Connect(function()
                        if not DropOpen or not FloatingMenu then stopDropFollow() return end
                        placeMenuInsideMain(FloatingMenu, menuW, menuH)
                    end)

                    local themeEl = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(28, 28, 30)
                    local searchRow = VoidUI:Create("Frame", {
                        Parent = FloatingMenu,
                        Size = UDim2.new(1, -12, 0, 32),
                        Position = UDim2.new(0, 6, 0, 6),
                        BackgroundColor3 = themeEl,
                        BackgroundTransparency = 0.25,
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
                        ImageColor3 = (UI.Theme and UI.Theme.IconColor) or Color3.fromRGB(200, 200, 200),
                        ImageTransparency = 0.2,
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
                        TextColor3 = themeText,
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
                        ScrollBarThickness = 2,
                        ScrollBarImageTransparency = 0.5,
                        ZIndex = 901,
                        Active = true,
                    }, {
                        VoidUI:Create("UIPadding", {
                            PaddingTop = UDim.new(0, 4),
                            PaddingBottom = UDim.new(0, 8),
                            PaddingLeft = UDim.new(0, 2),
                            PaddingRight = UDim.new(0, 2),
                        }),
                    })

                    ListLayout = VoidUI:Create("UIListLayout", {
                        Parent = ScrollingFrame,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 2),
                    })

                    rebuildItemsInto(ScrollingFrame)
                    DropIcon.Rotation = 180

                    local function filterList()
                        if not ScrollingFrame or not SearchBox then return end
                        lastDropSearch = SearchBox.Text or ""
                        local q = string.lower(lastDropSearch)
                        for _, v in ipairs(ScrollingFrame:GetChildren()) do
                            if v:IsA("TextButton") then
                                local lab = v:FindFirstChildOfClass("TextLabel")
                                local t = lab and lab.Text or ""
                                if q == "" then
                                    v.Visible = true
                                else
                                    v.Visible = string.find(string.lower(t), q, 1, true) ~= nil
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
            registerElement(Dropdown)
            return Dropdown
        end

        function Tab:Input(Config)
            local Input = {
                Title = Config.Title or "Input",
                Desc = Config.Desc or nil,
                Value = Config.Value or "",
                Placeholder = Config.Placeholder or "Type...",
                Locked = Config.Locked or false,
                MaxSymbols = Config.MaxSymbols or nil,
                Callback = Config.Callback or function() end,
                SizeY = 44
            }
            local Beeee, InputElement, Inner = Utility:Element(RightScroll, ElementFrame, Input.SizeY, "Input")
            local Title, Desc = Utility:ElText(Inner, Input.Title, Input.Desc, "Button")
            
            -- Input estilo WindUI (caixa maior, padding, stroke suave)
            local InputFrame = VoidUI:Create("Frame", {
                Parent = InputElement,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundColor3 = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(28, 28, 32),
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                Size = UDim2.new(0, Input.MaxSymbols and 150 or 150, 0, 30),
                ZIndex = 15,
                ThemeID = { BackgroundColor3 = "ElementColor" }
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                VoidUI:Create("UIStroke", {
                    Color = (UI.Theme and UI.Theme.Outline) or Color3.fromRGB(60, 60, 65),
                    Thickness = 1,
                    Transparency = 0.35,
                    ThemeID = { Color = "Outline" }
                }),
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                }),
            })

            local InputBox = VoidUI:Create("TextBox", {
                Parent = InputFrame,
                BackgroundTransparency = 1,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, Input.MaxSymbols and -28 or 0, 1, 0),
                Text = Input.Value,
                PlaceholderText = Input.Placeholder,
                PlaceholderColor3 = Color3.fromRGB(120, 120, 125),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
                TextSize = 12,
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
                Input.Value = val
                task.spawn(Input.Callback, val)
            end

            -- grava valor sempre (não só com Enter)
            InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                if Input.Locked then return end
                Input.Value = InputBox.Text
            end)

            InputBox.FocusLost:Connect(function()
                if Input.Locked then return end
                fireCallback()
            end)

            function Input:GetValue()
                return InputBox.Text or Input.Value or ""
            end

            function Input:SetValue(Val)
                InputBox.Text = tostring(Val or "")
                Input.Value = InputBox.Text
                task.spawn(Input.Callback, Input.Value)
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
            registerElement(Input)
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
            registerElement(Keybind)
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
            registerElement(Colorpicker)
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
            registerElement(PB)
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
            registerElement(CB)
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
            registerElement(RD)
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
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingTop = UDim.new(0, 2),
                    PaddingBottom = UDim.new(0, 2),
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
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                ZIndex = 19,
            })
            -- força centro vertical/horizontal
            pcall(function()
                PillText.AnchorPoint = Vector2.new(0.5, 0.5)
                PillText.Position = UDim2.new(0.5, 0, 0.5, 0)
            end)

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
                Height = Config.Height or 160,
                Editable = Config.Editable == true,
                MaxLines = math.clamp(Config.MaxLines or 999999, 1, 999999),
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, CD.Height + 44, "Code")
            local Title = Utility:ElText(Inner, CD.Title, nil, "Code")

            -- cores Lua/Luau vivas
            local function highlightLua(src)
                local esc = tostring(src or "")
                    :gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                local keywords = {
                    "and","break","do","else","elseif","end","false","for","function",
                    "if","in","local","nil","not","or","repeat","return","then","true",
                    "until","while","task","game","workspace","script","pairs","ipairs",
                    "pcall","xpcall","typeof","tostring","tonumber","print","require",
                    "export","type","continue","Enum","Color3","UDim2","Vector3","CFrame",
                    "Instance","TweenInfo","math","string","table","coroutine","wait","spawn",
                }
                esc = esc:gsub('(%b"")', function(s) return '<font color="#FF9B6A">' .. s .. '</font>' end)
                esc = esc:gsub("(%b'')", function(s) return '<font color="#FF9B6A">' .. s .. '</font>' end)
                esc = esc:gsub("(%-%-[^\n]*)", function(s) return '<font color="#6FCF7A">' .. s .. '</font>' end)
                esc = esc:gsub("(%f[%w%d_]%d[%d%.xXa-fA-F]*)", function(s) return '<font color="#B8F28A">' .. s .. '</font>' end)
                for _, kw in ipairs(keywords) do
                    esc = esc:gsub("(%f[%w_])(" .. kw .. ")(%f[^%w_])", '%1<font color="#5CB8FF"><b>%2</b></font>%3')
                end
                return esc
            end

            local function lineNumbers(src)
                local n = 1
                for _ in tostring(src or ""):gmatch("\n") do n = n + 1 end
                n = math.min(n, CD.MaxLines)
                local lines = {}
                for i = 1, n do lines[i] = tostring(i) end
                return table.concat(lines, "\n"), n
            end

            local Header = VoidUI:Create("Frame", {
                Parent = Card,
                Size = UDim2.new(1, -16, 0, 22),
                Position = UDim2.new(0, 8, 0, 28),
                BackgroundTransparency = 1,
                ZIndex = 18,
            })

            local ModeLabel = VoidUI:Create("TextLabel", {
                Parent = Header,
                Size = UDim2.new(0, 80, 1, 0),
                BackgroundTransparency = 1,
                Text = CD.Editable and "Editor" or "View",
                TextSize = 11,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = Color3.fromRGB(140, 140, 150),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 19,
            })

            local CopyBtn = VoidUI:Create("TextButton", {
                Parent = Header,
                Size = UDim2.new(0, 72, 0, 22),
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(30, 30, 34),
                Text = "Copy!",
                TextSize = 12,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = Color3.fromRGB(240, 240, 245),
                AutoButtonColor = false,
                ZIndex = 19,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                }),
            })

            local Body = VoidUI:Create("Frame", {
                Parent = Card,
                Size = UDim2.new(1, -16, 0, CD.Height - 8),
                Position = UDim2.new(0, 8, 0, 50),
                BackgroundColor3 = Color3.fromRGB(10, 10, 12),
                BackgroundTransparency = 0.05,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = 17,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            })

            local Scroll = VoidUI:Create("ScrollingFrame", {
                Parent = Body,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 4,
                ScrollingDirection = Enum.ScrollingDirection.XY,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.XY,
                ZIndex = 18,
            }, {
                VoidUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                }),
            })

            local LineBox = VoidUI:Create("TextLabel", {
                Parent = Scroll,
                Size = UDim2.new(0, 28, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Position = UDim2.new(0, 2, 0, 0),
                BackgroundTransparency = 1,
                Text = select(1, lineNumbers(CD.Code)),
                TextSize = 12,
                FontFace = Font.new([[rbxasset://fonts/families/RobotoMono.json]], Enum.FontWeight.Medium),
                TextColor3 = Color3.fromRGB(90, 90, 100),
                TextXAlignment = Enum.TextXAlignment.Right,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = false,
                RichText = false,
                ZIndex = 19,
            })

            local Box
            local HighlightOverlay = nil
            if CD.Editable then
                -- overlay com cores (em tempo real)
                HighlightOverlay = VoidUI:Create("TextLabel", {
                    Parent = Scroll,
                    Size = UDim2.new(0, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Position = UDim2.new(0, 34, 0, 0),
                    BackgroundTransparency = 1,
                    Text = highlightLua(CD.Code),
                    TextSize = 12,
                    FontFace = Font.new([[rbxasset://fonts/families/RobotoMono.json]], Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(230, 230, 235),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = false,
                    RichText = true,
                    ZIndex = 18,
                })
                Box = VoidUI:Create("TextBox", {
                    Parent = Scroll,
                    Size = UDim2.new(0, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Position = UDim2.new(0, 34, 0, 0),
                    BackgroundTransparency = 1,
                    Text = CD.Code,
                    MultiLine = true,
                    ClearTextOnFocus = false,
                    TextSize = 12,
                    FontFace = Font.new([[rbxasset://fonts/families/RobotoMono.json]], Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextTransparency = 0.72,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = false,
                    RichText = false,
                    ZIndex = 20,
                })
                Box:GetPropertyChangedSignal("Text"):Connect(function()
                    local text = Box.Text or ""
                    local lines = 1
                    for _ in text:gmatch("\n") do lines = lines + 1 end
                    if lines > CD.MaxLines then
                        local kept = {}
                        local i = 0
                        for line in (text .. "\n"):gmatch("(.-)\n") do
                            i = i + 1
                            if i > CD.MaxLines then break end
                            kept[#kept + 1] = line
                        end
                        Box.Text = table.concat(kept, "\n")
                        return
                    end
                    CD.Code = text
                    LineBox.Text = select(1, lineNumbers(text))
                    if HighlightOverlay then
                        HighlightOverlay.Text = highlightLua(text)
                    end
                    -- desce o scroll conforme escreve
                    task.defer(function()
                        if Scroll and Scroll.AbsoluteWindowSize.Y > 0 then
                            local maxY = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteWindowSize.Y)
                            Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, maxY)
                        end
                    end)
                end)
            else
                Box = VoidUI:Create("TextLabel", {
                    Parent = Scroll,
                    Size = UDim2.new(0, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Position = UDim2.new(0, 34, 0, 0),
                    BackgroundTransparency = 1,
                    Text = highlightLua(CD.Code),
                    TextSize = 12,
                    FontFace = Font.new([[rbxasset://fonts/families/RobotoMono.json]], Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(230, 230, 235),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = false,
                    RichText = true,
                    ZIndex = 19,
                })
            end

            CopyBtn.MouseButton1Click:Connect(function()
                local text = CD.Code
                if CD.Editable and Box and Box:IsA("TextBox") then
                    text = Box.Text
                    CD.Code = text
                end
                local ok = pcall(function()
                    if setclipboard then setclipboard(text) end
                end)
                if not ok then
                    pcall(function()
                        if toclipboard then toclipboard(text) end
                    end)
                end
                CopyBtn.Text = "Copied!"
                task.delay(1.2, function()
                    if CopyBtn then CopyBtn.Text = "Copy!" end
                end)
            end)

            function CD:Set(code)
                CD.Code = code
                LineBox.Text = select(1, lineNumbers(code))
                if CD.Editable and Box:IsA("TextBox") then
                    Box.Text = code
                    if HighlightOverlay then
                        HighlightOverlay.Text = highlightLua(code)
                    end
                else
                    Box.Text = highlightLua(code)
                end
            end
            function CD:Get()
                if CD.Editable and Box:IsA("TextBox") then
                    return Box.Text
                end
                return CD.Code
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
                Size = UDim2.new(0, 88, 0, 30),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(88, 101, 242),
                Text = "Join Discord",
                TextTransparency = 0,
                TextSize = 11,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold),
                TextColor3 = Color3.new(1, 1, 1),
                TextTruncate = Enum.TextTruncate.None,
                AutoButtonColor = false,
                ZIndex = 18,
            }, {
                VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                VoidUI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                }),
            })

            Btn.MouseButton1Click:Connect(function()
                pcall(function()
                    if setclipboard then setclipboard(DC.URL) end
                end)
                Btn.Text = "Copied!"
                task.delay(1.2, function()
                    if Btn and Btn.Parent then Btn.Text = "Join Discord" end
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
            registerElement(ST)
            return ST
        end

        -- ========== COMPONENTES AVANÇADOS (estilo WindUI) ==========

        function Tab:Tooltip(Config)
            -- helper: retorna texto; tooltip real via Window:ShowTooltip
            return Config and (Config.Text or Config.Title) or ""
        end

        function Tab:Accordion(Config)
            local Acc = {
                Title = Config.Title or "Accordion",
                Open = Config.Open ~= false,
                Content = Config.Content or "",
                Callback = Config.Callback or function() end,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, Acc.Open and 90 or 40, "Accordion")
            local Title = Utility:ElText(Inner, Acc.Title, nil, "Accordion")
            local Body = VoidUI:Create("TextLabel", {
                Parent = Card,
                Size = UDim2.new(1, -20, 0, 40),
                Position = UDim2.new(0, 10, 0, 38),
                BackgroundTransparency = 1,
                Text = Acc.Content,
                TextWrapped = true,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Visible = Acc.Open,
                ZIndex = 16,
                ThemeID = { TextColor3 = "Text" },
            })
            local Chevron = VoidUI:Create("ImageLabel", {
                Parent = Card,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -24, 0, 12),
                BackgroundTransparency = 1,
                Image = ResolveIconImage("chevron-down"),
                Rotation = Acc.Open and 180 or 0,
                ZIndex = 17,
                ThemeID = { ImageColor3 = "IconColor" },
            })
            local Hit = VoidUI:Create("TextButton", {
                Parent = Beeee, Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = "", ZIndex = 25,
            })
            Hit.MouseButton1Click:Connect(function()
                Acc.Open = not Acc.Open
                Body.Visible = Acc.Open
                Chevron.Rotation = Acc.Open and 180 or 0
                Utility:TweenObject(Beeee, { Size = UDim2.new(1, -7, 0, Acc.Open and 90 or 40) }, 0.18)
                task.spawn(Acc.Callback, Acc.Open)
            end)
            function Acc:SetOpen(v) Acc.Open = v; Body.Visible = v; Chevron.Rotation = v and 180 or 0 end
            registerElement(Acc)
            return Acc
        end

        function Tab:Timeline(Config)
            local TL = {
                Title = Config.Title or "Timeline",
                Steps = Config.Steps or { "Start", "Middle", "End" },
                Index = Config.Index or 1,
            }
            local h = 28 + (#TL.Steps * 28)
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, h, "Timeline")
            Utility:ElText(Inner, TL.Title, nil, "Timeline")
            for i, step in ipairs(TL.Steps) do
                local row = VoidUI:Create("Frame", {
                    Parent = Card, Size = UDim2.new(1, -16, 0, 26), Position = UDim2.new(0, 8, 0, 28 + (i - 1) * 28),
                    BackgroundTransparency = 1, ZIndex = 16,
                })
                local dot = VoidUI:Create("Frame", {
                    Parent = row, Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 4, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = (i <= TL.Index) and ((UI.Theme and UI.Theme.IconColor) or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(80, 80, 85),
                    ZIndex = 17,
                }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                VoidUI:Create("TextLabel", {
                    Parent = row, Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 22, 0, 0),
                    BackgroundTransparency = 1, Text = tostring(step), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 17, ThemeID = { TextColor3 = "Text" },
                })
            end
            function TL:SetIndex(i) TL.Index = i end
            registerElement(TL)
            return TL
        end

        function Tab:ChipList(Config)
            local CL = {
                Title = Config.Title or "Chips",
                Options = Config.Options or { "A", "B", "C" },
                Value = Config.Value or {},
                Multi = Config.Multi ~= false,
                Callback = Config.Callback or function() end,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 70, "ChipList")
            Utility:ElText(Inner, CL.Title, nil, "ChipList")
            local holder = VoidUI:Create("Frame", {
                Parent = Card, Size = UDim2.new(1, -12, 0, 28), Position = UDim2.new(0, 6, 0, 34),
                BackgroundTransparency = 1, ZIndex = 16,
            }, { VoidUI:Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }) })
            local selected = {}
            if type(CL.Value) == "table" then
                for _, v in ipairs(CL.Value) do selected[v] = true end
            elseif CL.Value then selected[CL.Value] = true end
            for i, opt in ipairs(CL.Options) do
                local on = selected[opt]
                local chip = VoidUI:Create("TextButton", {
                    Parent = holder, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 24),
                    BackgroundColor3 = on and ((UI.Theme and UI.Theme.IconColor) or Color3.fromRGB(80, 160, 255)) or ((UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(40, 40, 44)),
                    Text = "  " .. tostring(opt) .. "  ", TextSize = 12, AutoButtonColor = false, ZIndex = 17,
                    ThemeID = { TextColor3 = "Text" }, LayoutOrder = i,
                }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
                chip.MouseButton1Click:Connect(function()
                    if CL.Multi then
                        selected[opt] = not selected[opt]
                    else
                        for k in pairs(selected) do selected[k] = false end
                        selected[opt] = true
                    end
                    chip.BackgroundColor3 = selected[opt] and ((UI.Theme and UI.Theme.IconColor) or Color3.fromRGB(80, 160, 255)) or ((UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(40, 40, 44))
                    local list = {}
                    for _, o in ipairs(CL.Options) do if selected[o] then table.insert(list, o) end end
                    task.spawn(CL.Callback, CL.Multi and list or list[1])
                end)
            end
            registerElement(CL)
            return CL
        end

        function Tab:SegmentedControl(Config)
            local SC = {
                Title = Config.Title or "Segmented",
                Options = Config.Options or { "One", "Two", "Three" },
                Value = Config.Value or (Config.Options and Config.Options[1]) or "One",
                Callback = Config.Callback or function() end,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 70, "Segmented")
            Utility:ElText(Inner, SC.Title, nil, "Segmented")
            local bar = VoidUI:Create("Frame", {
                Parent = Card, Size = UDim2.new(1, -16, 0, 28), Position = UDim2.new(0, 8, 0, 34),
                BackgroundColor3 = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(30, 30, 34),
                ZIndex = 16,
            }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }), VoidUI:Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 2) }) })
            local buttons = {}
            local optCount = math.max(#SC.Options, 1)
            for i, opt in ipairs(SC.Options) do
                local on = (opt == SC.Value)
                local b = VoidUI:Create("TextButton", {
                    Parent = bar, Size = UDim2.new(1 / optCount, -2, 1, -2), BackgroundTransparency = on and 0 or 1,
                    BackgroundColor3 = (UI.Theme and UI.Theme.IconColor) or Color3.fromRGB(70, 70, 75),
                    Text = tostring(opt), TextSize = 12, AutoButtonColor = false, ZIndex = 17,
                    ThemeID = { TextColor3 = "Text" },
                }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 7) }) })
                buttons[opt] = b
                b.MouseButton1Click:Connect(function()
                    SC.Value = opt
                    for k, btn in pairs(buttons) do
                        btn.BackgroundTransparency = (k == opt) and 0 or 1
                    end
                    task.spawn(SC.Callback, opt)
                end)
            end
            function SC:Set(v)
                SC.Value = v
                for k, btn in pairs(buttons) do btn.BackgroundTransparency = (k == v) and 0 or 1 end
            end
            registerElement(SC)
            return SC
        end

        function Tab:Viewport(Config)
            local VP = {
                Title = Config.Title or "Viewport",
                Image = Config.Image or Config.Asset or "",
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 140, "Viewport")
            Utility:ElText(Inner, VP.Title, nil, "Viewport")
            local img = tostring(VP.Image)
            if img ~= "" and not img:find("rbxassetid://") then img = "rbxassetid://" .. img:gsub("%D", "") end
            VoidUI:Create("ImageLabel", {
                Parent = Card, Size = UDim2.new(1, -16, 0, 100), Position = UDim2.new(0, 8, 0, 32),
                BackgroundColor3 = Color3.fromRGB(20, 20, 24), BackgroundTransparency = 0.2,
                Image = img, ScaleType = Enum.ScaleType.Fit, ZIndex = 16,
            }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
            registerElement(VP)
            return VP
        end

        function Tab:Path2D(Config)
            local P = {
                Title = Config.Title or "Chart",
                Values = Config.Values or { 0.2, 0.5, 0.3, 0.8, 0.6 },
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 120, "Path2D")
            Utility:ElText(Inner, P.Title, nil, "Path2D")
            local chart = VoidUI:Create("Frame", {
                Parent = Card, Size = UDim2.new(1, -16, 0, 70), Position = UDim2.new(0, 8, 0, 36),
                BackgroundTransparency = 1, ZIndex = 16, ClipsDescendants = true,
            })
            local n = #P.Values
            for i, v in ipairs(P.Values) do
                local h = math.clamp(tonumber(v) or 0, 0, 1)
                VoidUI:Create("Frame", {
                    Parent = chart,
                    Size = UDim2.new(1 / n, -4, h, 0),
                    Position = UDim2.new((i - 1) / n, 2, 1 - h, 0),
                    BackgroundColor3 = (UI.Theme and UI.Theme.IconColor) or Color3.fromRGB(80, 160, 255),
                    ZIndex = 17,
                }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })
            end
            registerElement(P)
            return P
        end

        function Tab:PopupButton(Config)
            local PB = {
                Title = Config.Title or "Open Popup",
                PopupTitle = Config.PopupTitle or "Popup",
                PopupContent = Config.PopupContent or "Content",
                Callback = Config.Callback or function() end,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 40, "PopupButton")
            local Title = Utility:ElText(Inner, PB.Title, nil, "PopupButton")
            local Hit = VoidUI:Create("TextButton", {
                Parent = Beeee, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 25,
            })
            Hit.MouseButton1Click:Connect(function()
                Utility:TweenObject(Card, { BackgroundTransparency = 0.2 }, 0.08)
                task.delay(0.1, function() Utility:TweenObject(Card, { BackgroundTransparency = 0 }, 0.12) end)
                if Window.Dialog then
                    Window:Dialog({
                        Title = PB.PopupTitle,
                        Content = PB.PopupContent,
                        Buttons = {
                            { Title = "OK", Callback = function() task.spawn(PB.Callback) end },
                            { Title = "Cancel", Callback = function() end },
                        },
                    })
                else
                    Window:Notify({ Title = PB.PopupTitle, Content = PB.PopupContent, Duration = 3 })
                    task.spawn(PB.Callback)
                end
            end)
            registerElement(PB)
            return PB
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
        -- alias estilo WindUI
        function Tab:TabSection(Config)
            return Tab:Section(Config)
        end

        function Tab:TabBox(Config)
            local TB = {
                Title = Config.Title or "TabBox",
                Tabs = Config.Tabs or { { Title = "A" }, { Title = "B" } },
                Index = 1,
            }
            local Beeee, Card, Inner = Utility:Element(RightScroll, ElementFrame, 120, "TabBox")
            Utility:ElText(Inner, TB.Title, nil, "TabBox")
            local header = VoidUI:Create("Frame", {
                Parent = Card, Size = UDim2.new(1, -12, 0, 28), Position = UDim2.new(0, 6, 0, 32),
                BackgroundTransparency = 1, ZIndex = 16,
            }, {
                VoidUI:Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }),
            })
            local body = VoidUI:Create("Frame", {
                Parent = Card, Size = UDim2.new(1, -12, 0, 50), Position = UDim2.new(0, 6, 0, 64),
                BackgroundColor3 = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(30, 30, 34),
                BackgroundTransparency = 0.3, ZIndex = 16,
            }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
            local bodyLabel = VoidUI:Create("TextLabel", {
                Parent = body, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1, Text = TB.Tabs[1] and (TB.Tabs[1].Content or TB.Tabs[1].Title) or "",
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                ZIndex = 17, ThemeID = { TextColor3 = "Text" },
            })
            local tabButtons = {}
            for i, tabInfo in ipairs(TB.Tabs) do
                local on = (i == 1)
                local b = VoidUI:Create("TextButton", {
                    Parent = header, Size = UDim2.new(0, 70, 1, 0),
                    BackgroundTransparency = on and 0.2 or 0.7,
                    BackgroundColor3 = (UI.Theme and UI.Theme.ElementColor) or Color3.fromRGB(40, 40, 44),
                    Text = tostring(tabInfo.Title or ("Tab"..i)), TextSize = 11,
                    AutoButtonColor = false, ZIndex = 17, ThemeID = { TextColor3 = "Text" },
                }, { VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
                tabButtons[i] = b
                b.MouseButton1Click:Connect(function()
                    TB.Index = i
                    for j, btn in ipairs(tabButtons) do
                        btn.BackgroundTransparency = (j == i) and 0.2 or 0.7
                    end
                    bodyLabel.Text = tabInfo.Content or tabInfo.Title or ""
                    if tabInfo.Callback then task.spawn(tabInfo.Callback) end
                end)
            end
            registerElement(TB)
            return TB
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

        -- sem animação (evita lag)
        Main.Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset)
        Main.Visible = true
        Main.Frame.Visible = true
        Main.Frame.Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset - 8)
        local uiScale = Main:FindFirstChildOfClass("UIScale")
        if uiScale then uiScale.Scale = 1 end

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

        if LeftScroll.UIListLayout then
            LeftScroll.CanvasSize = UDim2.new(0, 0, 0, LeftScroll.UIListLayout.AbsoluteContentSize.Y + 20)
        end

        -- restaura aba que estava aberta (não força a primeira)
        local idx = tonumber(Window.SelectedTabIndex) or 1
        if not (Window.TabList and Window.TabList[idx]) then idx = 1 end
        pcall(function() Window:SelectTab(idx) end)

        -- restaura Acrylic / Transparency salvos
        if Window.Acrylic then
            Main.BackgroundTransparency = 0.55
        elseif Window._SavedTransparency ~= nil then
            Main.BackgroundTransparency = Window._SavedTransparency
        else
            Main.BackgroundTransparency = (Window.Transparent and 0.1 or 0)
        end

        if Window.Resizable and ResizeHandle then
            ResizeHandle.Visible = true
        end
        OpenButtonHolder.Visible = false
        isToggling = false
    end

    function Window:Close()
        if isToggling then return end
        isToggling = true
        if ResizeHandle then ResizeHandle.Visible = false end
        Window.IslandOpen = false
        Window.Default = "Minimize"
        UI:CloseActiveDropdown()

        -- salva estado atual (aba + transparência + acrylic)
        Window._SavedTransparency = Main.BackgroundTransparency
        -- SelectedTabIndex já é atualizado no SelectTab

        -- sem animação / sem delay (evita freeze de ~2s)
        Main.Visible = false
        Main.Frame.Visible = false
        local uiScale = Main:FindFirstChildOfClass("UIScale")
        if uiScale then uiScale.Scale = 1 end
        Main.Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset)
        TabFrame.Size = UDim2.new(0, Window.SideBarWidth, 0, 0)
        -- restaura posição salva (lado esquerdo por padrão) e mantém dentro da tela
        do
            local x, y = loadOpenButtonPos()
            OpenButtonHolder.AnchorPoint = Vector2.new(0, 0)
            OpenButtonHolder.Position = UDim2.new(0, x, 0, y)
        end
        OpenButtonHolder.Visible = true
        isToggling = false
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
        Utility:TweenObject(Main, {Position = UDim2.new(0.5, 0, 0.48, 0)}, 0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end

    function Window:SetTransparency(Value)
        local t
        if typeof(Value) == "number" then
            t = math.clamp(Value, 0, 1)
        else
            t = Value and 0.1 or 0
        end
        Window._SavedTransparency = t
        if not Window.Acrylic then
            Main.BackgroundTransparency = t
        end
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

        -- TopBarF3 (Search + minimize/fullscreen/destroy)
        local f2w = (TopBarF2.Visible and TopBarF2.Size.X.Offset) or 0
        local f3w = 220
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
            -- fullscreen: um pouco acima do centro
            Utility:TweenObject(Main, {
                Position = UDim2.new(0.5, 0, 0.46, 0)
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

    -- Lock / Unlock all elements (janela inteira)
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

    -- ConfigManager (salvar/carregar JSON simples)
    Window.Config = Window.Config or {}
    function Window:SetConfig(key, value)
        Window.Config[key] = value
        return Window
    end
    function Window:GetConfig(key, default)
        if Window.Config[key] ~= nil then return Window.Config[key] end
        return default
    end
    function Window:SaveConfig(folderName)
        local name = folderName or Window.Name or "VoidHub"
        local ok, encoded = pcall(function()
            return game:GetService("HttpService"):JSONEncode(Window.Config)
        end)
        if ok and writefile then
            pcall(function()
                if isfolder and not isfolder(name) then makefolder(name) end
                writefile(name .. "/config.json", encoded)
            end)
            Window:Notify({ Title = "Config", Content = "Saved", Duration = 2 })
        end
        return Window
    end
    function Window:LoadConfig(folderName)
        local name = folderName or Window.Name or "VoidHub"
        if readfile and isfile and isfile(name .. "/config.json") then
            local ok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(name .. "/config.json"))
            end)
            if ok and type(data) == "table" then
                Window.Config = data
                Window:Notify({ Title = "Config", Content = "Loaded", Duration = 2 })
            end
        end
        return Window
    end

    -- Tooltip flutuante
    local TooltipFrame = nil
    function Window:ShowTooltip(text, duration)
        duration = duration or 2
        if TooltipFrame then pcall(function() TooltipFrame:Destroy() end) end
        TooltipFrame = VoidUI:Create("Frame", {
            Parent = UIScreen,
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundColor3 = Color3.fromRGB(30, 30, 34),
            ZIndex = 2000,
            Position = UDim2.new(0.5, 0, 0.12, 0),
            AnchorPoint = Vector2.new(0.5, 0),
        }, {
            VoidUI:Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            VoidUI:Create("UIPadding", {
                PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
            }),
            VoidUI:Create("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                Text = tostring(text or ""),
                TextSize = 12,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium),
                TextColor3 = Color3.new(1, 1, 1),
                ZIndex = 2001,
            }),
        })
        task.delay(duration, function()
            if TooltipFrame then pcall(function() TooltipFrame:Destroy() end) TooltipFrame = nil end
        end)
        return Window
    end

    -- Acrylic simulado (transparência forte) — persiste após minimize
    function Window:ToggleAcrylic(enabled)
        Window.Acrylic = enabled ~= false
        if Window.Acrylic then
            Main.BackgroundTransparency = 0.55
            Window._SavedTransparency = 0.55
        else
            local t = Window.Transparent and 0.15 or 0
            Main.BackgroundTransparency = t
            Window._SavedTransparency = t
        end
        return Window
    end

    function Window:SetMotionPreset(name)
        Window.MotionPreset = name or "Default"
        return Window
    end

    function Window:Popup(Config)
        Config = Config or {}
        if Window.Dialog then
            return Window:Dialog({
                Title = Config.Title or "Popup",
                Content = Config.Content or Config.Text or "",
                Buttons = Config.Buttons or {
                    { Title = "OK", Callback = Config.Callback or function() end },
                },
            })
        end
        Window:Notify({ Title = Config.Title or "Popup", Content = Config.Content or "", Duration = 3 })
        return Window
    end

    -- Background Video
    local BackgroundVideo = nil
    function Window:SetBackgroundVideo(videoId, transparency)
        BackgroundGradientFrame.Visible = false
        BackgroundImage.Visible = false
        local id = tostring(videoId or ""):gsub("%s+", "")
        local digits = id:match("%d+")
        if not digits then
            warn("[Void Ui] SetBackgroundVideo: invalid id")
            return Window
        end
        if not id:find("rbxassetid://") then
            id = "rbxassetid://" .. digits
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
        BackgroundLayer.Visible = true
        BackgroundVideo.Visible = true
        pcall(function() BackgroundVideo.Video = id end)
        local t = transparency
        if t == nil then t = Window.BackgroundImageTransparency or 0.3 end
        t = math.clamp(tonumber(t) or 0.3, 0, 1)
        BackgroundVideo.BackgroundTransparency = 1
        Main.BackgroundTransparency = math.clamp(0.55 + t * 0.3, 0.4, 0.9)
        pcall(function() BackgroundVideo:Play() end)
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

    local LangPacks = {
        English = {
            Search = "Search...", Open = "Open", Close = "Close", Settings = "Settings",
            Theme = "Theme", Transparent = "Transparent", Notify = "Notification",
            Destroy = "Destroy", Fullscreen = "Fullscreen", Center = "Center",
            Apply = "Apply", Clear = "Clear", Copy = "Copy", Copied = "Copied",
        },
        ["Português"] = {
            Search = "Pesquisar...", Open = "Abrir", Close = "Fechar", Settings = "Configurações",
            Theme = "Tema", Transparent = "Transparente", Notify = "Notificação",
            Destroy = "Destruir", Fullscreen = "Tela cheia", Center = "Centralizar",
            Apply = "Aplicar", Clear = "Limpar", Copy = "Copiar", Copied = "Copiado",
        },
        ["Español"] = {
            Search = "Buscar...", Open = "Abrir", Close = "Cerrar", Settings = "Ajustes",
            Theme = "Tema", Transparent = "Transparente", Notify = "Notificación",
            Destroy = "Destruir", Fullscreen = "Pantalla completa", Center = "Centrar",
            Apply = "Aplicar", Clear = "Limpiar", Copy = "Copiar", Copied = "Copiado",
        },
        ["Français"] = {
            Search = "Rechercher...", Open = "Ouvrir", Close = "Fermer", Settings = "Paramètres",
            Theme = "Thème", Transparent = "Transparent", Notify = "Notification",
            Destroy = "Détruire", Fullscreen = "Plein écran", Center = "Centrer",
            Apply = "Appliquer", Clear = "Effacer", Copy = "Copier", Copied = "Copié",
        },
        Deutsch = {
            Search = "Suchen...", Open = "Öffnen", Close = "Schließen", Settings = "Einstellungen",
            Theme = "Thema", Transparent = "Transparent", Notify = "Benachrichtigung",
            Destroy = "Zerstören", Fullscreen = "Vollbild", Center = "Zentrieren",
            Apply = "Anwenden", Clear = "Löschen", Copy = "Kopieren", Copied = "Kopiert",
        },
        Italiano = {
            Search = "Cerca...", Open = "Apri", Close = "Chiudi", Settings = "Impostazioni",
            Theme = "Tema", Transparent = "Trasparente", Notify = "Notifica",
            Destroy = "Distruggi", Fullscreen = "Schermo intero", Center = "Centra",
            Apply = "Applica", Clear = "Pulisci", Copy = "Copia", Copied = "Copiato",
        },
        ["Русский"] = {
            Search = "Поиск...", Open = "Открыть", Close = "Закрыть", Settings = "Настройки",
            Theme = "Тема", Transparent = "Прозрачность", Notify = "Уведомление",
            Destroy = "Удалить", Fullscreen = "Полный экран", Center = "По центру",
            Apply = "Применить", Clear = "Очистить", Copy = "Копировать", Copied = "Скопировано",
        },
        ["日本語"] = {
            Search = "検索...", Open = "開く", Close = "閉じる", Settings = "設定",
            Theme = "テーマ", Transparent = "透明", Notify = "通知",
            Destroy = "破棄", Fullscreen = "全画面", Center = "中央",
            Apply = "適用", Clear = "クリア", Copy = "コピー", Copied = "コピー済み",
        },
        ["中文"] = {
            Search = "搜索...", Open = "打开", Close = "关闭", Settings = "设置",
            Theme = "主题", Transparent = "透明", Notify = "通知",
            Destroy = "销毁", Fullscreen = "全屏", Center = "居中",
            Apply = "应用", Clear = "清除", Copy = "复制", Copied = "已复制",
        },
        ["한국어"] = {
            Search = "검색...", Open = "열기", Close = "닫기", Settings = "설정",
            Theme = "테마", Transparent = "투명", Notify = "알림",
            Destroy = "삭제", Fullscreen = "전체 화면", Center = "가운데",
            Apply = "적용", Clear = "지우기", Copy = "복사", Copied = "복사됨",
        },

        Polish = {
            Search = "Szukaj...", Open = "Otwórz", Close = "Zamknij", Settings = "Ustawienia",
            Theme = "Motyw", Transparent = "Przezroczystość", Notify = "Powiadomienie",
            Destroy = "Zniszcz", Fullscreen = "Pełny ekran", Center = "Wyśrodkuj",
            Apply = "Zastosuj", Clear = "Wyczyść", Copy = "Kopiuj", Copied = "Skopiowano",
        },
        Turkish = {
            Search = "Ara...", Open = "Aç", Close = "Kapat", Settings = "Ayarlar",
            Theme = "Tema", Transparent = "Şeffaf", Notify = "Bildirim",
            Destroy = "Yok et", Fullscreen = "Tam ekran", Center = "Ortala",
            Apply = "Uygula", Clear = "Temizle", Copy = "Kopyala", Copied = "Kopyalandı",
        },
        Dutch = {
            Search = "Zoeken...", Open = "Openen", Close = "Sluiten", Settings = "Instellingen",
            Theme = "Thema", Transparent = "Transparant", Notify = "Melding",
            Destroy = "Vernietigen", Fullscreen = "Volledig scherm", Center = "Centreren",
            Apply = "Toepassen", Clear = "Wissen", Copy = "Kopiëren", Copied = "Gekopieerd",
        },
        Swedish = {
            Search = "Sök...", Open = "Öppna", Close = "Stäng", Settings = "Inställningar",
            Theme = "Tema", Transparent = "Transparent", Notify = "Avisering",
            Destroy = "Förstör", Fullscreen = "Helskärm", Center = "Centrera",
            Apply = "Verkställ", Clear = "Rensa", Copy = "Kopiera", Copied = "Kopierat",
        },
        Arabic = {
            Search = "...بحث", Open = "فتح", Close = "إغلاق", Settings = "الإعدادات",
            Theme = "السمة", Transparent = "شفاف", Notify = "إشعار",
            Destroy = "تدمير", Fullscreen = "ملء الشاشة", Center = "توسيط",
            Apply = "تطبيق", Clear = "مسح", Copy = "نسخ", Copied = "تم النسخ",
        },
        Hindi = {
            Search = "खोजें...", Open = "खोलें", Close = "बंद करें", Settings = "सेटिंग्स",
            Theme = "थीम", Transparent = "पारदर्शी", Notify = "सूचना",
            Destroy = "नष्ट करें", Fullscreen = "पूर्ण स्क्रीन", Center = "केंद्र",
            Apply = "लागू करें", Clear = "साफ़ करें", Copy = "कॉपी", Copied = "कॉपी किया",
        },
        Thai = {
            Search = "ค้นหา...", Open = "เปิด", Close = "ปิด", Settings = "การตั้งค่า",
            Theme = "ธีม", Transparent = "โปร่งใส", Notify = "การแจ้งเตือน",
            Destroy = "ทำลาย", Fullscreen = "เต็มหน้าจอ", Center = "กึ่งกลาง",
            Apply = "ใช้", Clear = "ล้าง", Copy = "คัดลอก", Copied = "คัดลอกแล้ว",
        },
        Vietnamese = {
            Search = "Tìm kiếm...", Open = "Mở", Close = "Đóng", Settings = "Cài đặt",
            Theme = "Chủ đề", Transparent = "Trong suốt", Notify = "Thông báo",
            Destroy = "Hủy", Fullscreen = "Toàn màn hình", Center = "Giữa",
            Apply = "Áp dụng", Clear = "Xóa", Copy = "Sao chép", Copied = "Đã sao chép",
        },
        Indonesian = {
            Search = "Cari...", Open = "Buka", Close = "Tutup", Settings = "Pengaturan",
            Theme = "Tema", Transparent = "Transparan", Notify = "Notifikasi",
            Destroy = "Hancurkan", Fullscreen = "Layar penuh", Center = "Tengah",
            Apply = "Terapkan", Clear = "Hapus", Copy = "Salin", Copied = "Disalin",
        },
        Romanian = {
            Search = "Caută...", Open = "Deschide", Close = "Închide", Settings = "Setări",
            Theme = "Temă", Transparent = "Transparent", Notify = "Notificare",
            Destroy = "Distruge", Fullscreen = "Ecran complet", Center = "Centru",
            Apply = "Aplică", Clear = "Șterge", Copy = "Copiază", Copied = "Copiat",
        },
        Czech = {
            Search = "Hledat...", Open = "Otevřít", Close = "Zavřít", Settings = "Nastavení",
            Theme = "Motiv", Transparent = "Průhledné", Notify = "Oznámení",
            Destroy = "Zničit", Fullscreen = "Celá obrazovka", Center = "Na střed",
            Apply = "Použít", Clear = "Vymazat", Copy = "Kopírovat", Copied = "Zkopírováno",
        },
        Greek = {
            Search = "Αναζήτηση...", Open = "Άνοιγμα", Close = "Κλείσιμο", Settings = "Ρυθμίσεις",
            Theme = "Θέμα", Transparent = "Διαφάνεια", Notify = "Ειδοποίηση",
            Destroy = "Καταστροφή", Fullscreen = "Πλήρης οθόνη", Center = "Κέντρο",
            Apply = "Εφαρμογή", Clear = "Καθαρισμός", Copy = "Αντιγραφή", Copied = "Αντιγράφηκε",
        },
        Hungarian = {
            Search = "Keresés...", Open = "Megnyitás", Close = "Bezárás", Settings = "Beállítások",
            Theme = "Téma", Transparent = "Átlátszó", Notify = "Értesítés",
            Destroy = "Megsemmisít", Fullscreen = "Teljes képernyő", Center = "Közép",
            Apply = "Alkalmaz", Clear = "Törlés", Copy = "Másolás", Copied = "Másolva",
        },
        Finnish = {
            Search = "Haku...", Open = "Avaa", Close = "Sulje", Settings = "Asetukset",
            Theme = "Teema", Transparent = "Läpinäkyvä", Notify = "Ilmoitus",
            Destroy = "Tuhoa", Fullscreen = "Koko näyttö", Center = "Keskitä",
            Apply = "Käytä", Clear = "Tyhjennä", Copy = "Kopioi", Copied = "Kopioitu",
        },
        Norwegian = {
            Search = "Søk...", Open = "Åpne", Close = "Lukk", Settings = "Innstillinger",
            Theme = "Tema", Transparent = "Gjennomsiktig", Notify = "Varsling",
            Destroy = "Ødelegg", Fullscreen = "Fullskjerm", Center = "Sentrer",
            Apply = "Bruk", Clear = "Tøm", Copy = "Kopier", Copied = "Kopiert",
        },
        Danish = {
            Search = "Søg...", Open = "Åbn", Close = "Luk", Settings = "Indstillinger",
            Theme = "Tema", Transparent = "Gennemsigtig", Notify = "Notifikation",
            Destroy = "Ødelæg", Fullscreen = "Fuld skærm", Center = "Centrer",
            Apply = "Anvend", Clear = "Ryd", Copy = "Kopiér", Copied = "Kopieret",
        },
        Ukrainian = {
            Search = "Пошук...", Open = "Відкрити", Close = "Закрити", Settings = "Налаштування",
            Theme = "Тема", Transparent = "Прозорість", Notify = "Сповіщення",
            Destroy = "Знищити", Fullscreen = "Повний екран", Center = "По центру",
            Apply = "Застосувати", Clear = "Очистити", Copy = "Копіювати", Copied = "Скопійовано",
        },
        Hebrew = {
            Search = "...חיפוש", Open = "פתח", Close = "סגור", Settings = "הגדרות",
            Theme = "ערכת נושא", Transparent = "שקוף", Notify = "התראה",
            Destroy = "השמד", Fullscreen = "מסך מלא", Center = "מרכז",
            Apply = "החל", Clear = "נקה", Copy = "העתק", Copied = "הועתק",
        },
        Malay = {
            Search = "Cari...", Open = "Buka", Close = "Tutup", Settings = "Tetapan",
            Theme = "Tema", Transparent = "Lutsinar", Notify = "Pemberitahuan",
            Destroy = "Musnahkan", Fullscreen = "Skrin penuh", Center = "Tengah",
            Apply = "Guna", Clear = "Kosongkan", Copy = "Salin", Copied = "Disalin",
        },
        Filipino = {
            Search = "Maghanap...", Open = "Buksan", Close = "Isara", Settings = "Mga Setting",
            Theme = "Tema", Transparent = "Transparent", Notify = "Abiso",
            Destroy = "Sirain", Fullscreen = "Buong screen", Center = "Gitna",
            Apply = "Ilapat", Clear = "I-clear", Copy = "Kopyahin", Copied = "Nakopya",
        },
    }

    function Window:SetLanguage(lang)
        local key = lang or "English"
        -- aceita código curto também
        local alias = {
            en = "English", pt = "Português", es = "Español", fr = "Français",
            de = "Deutsch", it = "Italiano", ru = "Русский", ja = "日本語",
            zh = "中文", ko = "한국어",
        }
        key = alias[key] or key
        Window.Language = key
        local pack = LangPacks[key] or LangPacks.English
        Window.Lang = pack
        -- aplica no Search
        pcall(function()
            if SearchBox then
                SearchBox.PlaceholderText = pack.Search or "Search..."
            end
        end)
        -- notifica mudança
        pcall(function()
            UI:Notification({
                Title = pack.Settings or "Language",
                Desc = tostring(key),
                Duration = 2,
            })
        end)
        return Window
    end

    function Window:T(key)
        local pack = Window.Lang or LangPacks.English
        return (pack and pack[key]) or key
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
