--[[
    VoidxHub UI Library
    Dark card hub UI · Lucide icons (Footagesus)
    by slowzzx
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Lucide / Footagesus
local IconsV2
pcall(function()
    IconsV2 = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    if IconsV2 and IconsV2.SetIconsType then IconsV2.SetIconsType("lucide") end
end)

local function ApplyIcon(img, name)
    if not img or not name then return end
    if typeof(name) == "number" then img.Image = "rbxassetid://"..name return end
    if typeof(name) == "string" and (name:find("rbxassetid://") or name:match("^%d+$")) then
        img.Image = name:match("^%d+$") and ("rbxassetid://"..name) or name
        return
    end
    if not IconsV2 then return end
    local ok, data = pcall(function()
        if IconsV2.SetIconsType then IconsV2.SetIconsType("lucide") end
        return IconsV2.GetIcon(name)
    end)
    if not ok or not data then return end
    if type(data) == "table" then
        img.Image = data.Image or ""
        if data.ImageRectOffset then img.ImageRectOffset = data.ImageRectOffset end
        if data.ImageRectSize then img.ImageRectSize = data.ImageRectSize end
    elseif type(data) == "string" then
        img.Image = data
    end
end

local function T(obj, props, d)
    local tw = TweenService:Create(obj, TweenInfo.new(d or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function New(class, props, kids)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    for _, c in ipairs(kids or {}) do c.Parent = i end
    return i
end

local Theme = {
    Bg = Color3.fromRGB(12, 12, 14),
    Surface = Color3.fromRGB(18, 18, 22),
    Card = Color3.fromRGB(22, 22, 26),
    Text = Color3.fromRGB(240, 240, 245),
    Dim = Color3.fromRGB(150, 150, 160),
    Muted = Color3.fromRGB(100, 100, 110),
    Outline = Color3.fromRGB(45, 45, 52),
    Input = Color3.fromRGB(16, 16, 20),
    ToggleOn = Color3.fromRGB(230, 230, 235),
    ToggleOff = Color3.fromRGB(50, 50, 58),
    Track = Color3.fromRGB(40, 40, 48),
    Fill = Color3.fromRGB(220, 220, 230),
}

local VoidxHub = {}

function VoidxHub:CreateWindow(cfg)
    cfg = cfg or {}
    local W = {
        Name = cfg.Name or "VoidxHub",
        Author = cfg.Author or "by slowzzx",
        Icon = cfg.Icon or "triangle",
        ToggleKey = cfg.ToggleKey or Enum.KeyCode.LeftControl,
        Pages = {}, -- all pages (top + bottom)
        Current = nil,
    }

    local gui = New("ScreenGui", {
        Name = "VoidxHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui()) or CoreGui,
    })

    local Main = New("Frame", {
        Parent = gui,
        Size = cfg.Size or UDim2.fromOffset(560, 420),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    New("UICorner", { Parent = Main, CornerRadius = UDim.new(0, 16) })
    New("UIStroke", { Parent = Main, Color = Theme.Outline, Thickness = 1, Transparency = 0.25 })

    -- Header
    local Header = New("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, ZIndex = 10,
    })
    local Logo = New("ImageLabel", {
        Parent = Header, Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(0, 18, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1, ImageColor3 = Theme.Text, ZIndex = 11,
    })
    ApplyIcon(Logo, W.Icon)

    New("TextLabel", {
        Parent = Header, Size = UDim2.new(0, 200, 0, 18), Position = UDim2.new(0, 52, 0, 10),
        BackgroundTransparency = 1, Text = string.upper(W.Name), Font = Enum.Font.GothamBold,
        TextSize = 15, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
    })
    New("TextLabel", {
        Parent = Header, Size = UDim2.new(0, 200, 0, 14), Position = UDim2.new(0, 52, 0, 28),
        BackgroundTransparency = 1, Text = W.Author, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = Theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
    })

    local function winBtn(icon, xOff, cb)
        local b = New("TextButton", {
            Parent = Header, Size = UDim2.fromOffset(32, 32),
            Position = UDim2.new(1, xOff, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.3, Text = "", AutoButtonColor = false, ZIndex = 12,
        })
        New("UICorner", { Parent = b, CornerRadius = UDim.new(0, 8) })
        New("UIStroke", { Parent = b, Color = Theme.Outline, Thickness = 1, Transparency = 0.4 })
        local ic = New("ImageLabel", {
            Parent = b, Size = UDim2.fromOffset(14, 14), Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ImageColor3 = Theme.Dim, ZIndex = 13,
        })
        ApplyIcon(ic, icon)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    -- Drag
    do
        local drag, start, spos
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = true; start = input.Position; spos = Main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then drag = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - start
                Main.Position = UDim2.new(spos.X.Scale, spos.X.Offset + d.X, spos.Y.Scale, spos.Y.Offset + d.Y)
            end
        end)
    end

    -- Top tabs
    local TopBar = New("Frame", {
        Parent = Main, Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0, 14, 0, 52),
        BackgroundTransparency = 1, ZIndex = 10,
    })
    New("UIListLayout", {
        Parent = TopBar, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
    })

    -- Content
    local Content = New("ScrollingFrame", {
        Parent = Main, Size = UDim2.new(1, -28, 1, -152), Position = UDim2.new(0, 14, 0, 98),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70), CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 5,
    })
    New("UIGridLayout", {
        Parent = Content, CellSize = UDim2.new(0.5, -6, 0, 118), CellPadding = UDim2.new(0, 12, 0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder, FillDirectionMaxCells = 2,
    })
    New("UIPadding", {
        Parent = Content, PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2),
    })

    -- Bottom bar
    local Bottom = New("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 54), Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.15, ZIndex = 10,
    })
    New("Frame", {
        Parent = Bottom, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Outline,
        BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 11,
    })
    local BottomList = New("Frame", { Parent = Bottom, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 11 })
    New("UIListLayout", {
        Parent = BottomList, FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local function clearContent()
        for _, c in ipairs(Content:GetChildren()) do
            if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
        end
    end

    -- ========== PAGE / ELEMENTS ==========
    local function makePage(opts)
        opts = opts or {}
        local page = {
            Title = opts.Title or "Page",
            Icon = opts.Icon or "circle",
            Items = {}, -- {type, cfg}
            IsBottom = opts.Bottom == true,
        }

        local buildOne
        local function add(typ, c)
            table.insert(page.Items, { t = typ, c = c or {} })
            if W.Current == page then
                buildOne(typ, c or {})
            end
            return page
        end

        -- Element builders
        buildOne = function(typ, c)
            local function card(icon, title)
                local f = New("Frame", { Parent = Content, BackgroundColor3 = Theme.Card, BorderSizePixel = 0, ZIndex = 6 })
                New("UICorner", { Parent = f, CornerRadius = UDim.new(0, 14) })
                New("UIStroke", { Parent = f, Color = Theme.Outline, Thickness = 1, Transparency = 0.4 })
                New("UIPadding", {
                    Parent = f, PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14),
                    PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
                })
                local head = New("Frame", { Parent = f, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, ZIndex = 7 })
                New("UIListLayout", {
                    Parent = head, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                })
                local ic = New("ImageLabel", {
                    Parent = head, Size = UDim2.fromOffset(15, 15), BackgroundTransparency = 1,
                    ImageColor3 = Theme.Dim, ZIndex = 8,
                })
                ApplyIcon(ic, icon)
                New("TextLabel", {
                    Parent = head, Size = UDim2.new(1, -24, 1, 0), BackgroundTransparency = 1,
                    Text = title, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8,
                })
                return f
            end

            if typ == "Toggle" then
                local state = c.Default == true
                local f = card(c.Icon or "power", c.Title or "Toggle")
                New("TextLabel", {
                    Parent = f, Size = UDim2.new(1, -56, 0, 16), Position = UDim2.new(0, 0, 0, 32),
                    BackgroundTransparency = 1, Text = c.Label or c.Name or "Option",
                    Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
                })
                if c.Desc then
                    New("TextLabel", {
                        Parent = f, Size = UDim2.new(1, -56, 0, 28), Position = UDim2.new(0, 0, 0, 50),
                        BackgroundTransparency = 1, Text = c.Desc, Font = Enum.Font.Gotham, TextSize = 11,
                        TextColor3 = Theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 7,
                    })
                end
                local track = New("Frame", {
                    Parent = f, Size = UDim2.fromOffset(42, 24), Position = UDim2.new(1, 0, 0, 42),
                    AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff, ZIndex = 8,
                })
                New("UICorner", { Parent = track, CornerRadius = UDim.new(0, 12) })
                local knob = New("Frame", {
                    Parent = track, Size = UDim2.fromOffset(18, 18),
                    Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = state and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(220, 220, 230), ZIndex = 9,
                })
                New("UICorner", { Parent = knob, CornerRadius = UDim.new(0, 9) })
                local btn = New("TextButton", {
                    Parent = track, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 10,
                })
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    T(track, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff })
                    T(knob, {
                        Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                        BackgroundColor3 = state and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(220, 220, 230),
                    })
                    if c.Callback then task.spawn(c.Callback, state) end
                end)

            elseif typ == "Slider" then
                local min = c.Min or (c.Value and c.Value.Min) or 0
                local max = c.Max or (c.Value and c.Value.Max) or 100
                local step = c.Step or 1
                local value = c.Default or (c.Value and c.Value.Default) or min
                value = math.clamp(value, min, max)
                local f = card(c.Icon or "sliders-horizontal", c.Title or "Slider")
                New("TextLabel", {
                    Parent = f, Size = UDim2.new(1, -50, 0, 16), Position = UDim2.new(0, 0, 0, 32),
                    BackgroundTransparency = 1, Text = c.Label or c.Name or "Value",
                    Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
                })
                local valL = New("TextLabel", {
                    Parent = f, Size = UDim2.new(0, 48, 0, 16), Position = UDim2.new(1, 0, 0, 32),
                    AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = tostring(value),
                    Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 7,
                })
                local track = New("Frame", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 68),
                    BackgroundColor3 = Theme.Track, ZIndex = 7,
                })
                New("UICorner", { Parent = track, CornerRadius = UDim.new(0, 2) })
                local fill = New("Frame", {
                    Parent = track, Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
                    BackgroundColor3 = Theme.Fill, ZIndex = 8,
                })
                New("UICorner", { Parent = fill, CornerRadius = UDim.new(0, 2) })
                local knob = New("Frame", {
                    Parent = track, Size = UDim2.fromOffset(14, 14),
                    Position = UDim2.new((value - min) / math.max(max - min, 1), 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Text, ZIndex = 9,
                })
                New("UICorner", { Parent = knob, CornerRadius = UDim.new(0, 7) })
                New("TextLabel", {
                    Parent = f, Size = UDim2.new(0, 40, 0, 12), Position = UDim2.new(0, 0, 0, 80),
                    BackgroundTransparency = 1, Text = tostring(min), Font = Enum.Font.Gotham, TextSize = 10,
                    TextColor3 = Theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
                })
                New("TextLabel", {
                    Parent = f, Size = UDim2.new(0, 40, 0, 12), Position = UDim2.new(1, 0, 0, 80),
                    AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = tostring(max),
                    Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 7,
                })
                local sliding = false
                local function setX(x)
                    local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                    value = math.clamp(math.floor((min + (max - min) * rel) / step + 0.5) * step, min, max)
                    local p = (value - min) / math.max(max - min, 1)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, 0, 0.5, 0)
                    valL.Text = tostring(value)
                    if c.Callback then task.spawn(c.Callback, value) end
                end
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true; setX(input.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        setX(input.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

            elseif typ == "Dropdown" then
                local options = c.Option or c.Options or {}
                local value = c.Value or options[1] or ""
                local f = card(c.Icon or "list", c.Title or "Dropdown")
                New("TextLabel", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 32),
                    BackgroundTransparency = 1, Text = c.Label or c.Desc or "Selecionar",
                    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
                })
                local box = New("TextButton", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 54),
                    BackgroundColor3 = Theme.Input, Text = "", AutoButtonColor = false, ZIndex = 8,
                })
                New("UICorner", { Parent = box, CornerRadius = UDim.new(0, 8) })
                New("UIStroke", { Parent = box, Color = Theme.Outline, Thickness = 1, Transparency = 0.35 })
                local boxText = New("TextLabel", {
                    Parent = box, Size = UDim2.new(1, -32, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1, Text = tostring(value), Font = Enum.Font.GothamMedium,
                    TextSize = 12, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 9,
                })
                local chev = New("ImageLabel", {
                    Parent = box, Size = UDim2.fromOffset(14, 14), Position = UDim2.new(1, -10, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, ImageColor3 = Theme.Dim, ZIndex = 9,
                })
                ApplyIcon(chev, "chevron-down")
                local menu
                local function close()
                    if menu then menu:Destroy() menu = nil end
                    T(chev, { Rotation = 0 })
                end
                box.MouseButton1Click:Connect(function()
                    if menu then close() return end
                    T(chev, { Rotation = 180 })
                    menu = New("Frame", {
                        Parent = Main, Size = UDim2.fromOffset(math.max(160, box.AbsoluteSize.X), math.min(168, #options * 30 + 8)),
                        BackgroundColor3 = Theme.Card, ZIndex = 60, ClipsDescendants = true,
                    })
                    New("UICorner", { Parent = menu, CornerRadius = UDim.new(0, 10) })
                    New("UIStroke", { Parent = menu, Color = Theme.Outline, Thickness = 1, Transparency = 0.3 })
                    local sc = New("ScrollingFrame", {
                        Parent = menu, Size = UDim2.new(1, -6, 1, -6), Position = UDim2.new(0, 3, 0, 3),
                        BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0, 0, 0, 0),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 61,
                    })
                    New("UIListLayout", { Parent = sc, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
                    for i, opt in ipairs(options) do
                        local it = New("TextButton", {
                            Parent = sc, Size = UDim2.new(1, 0, 0, 28),
                            BackgroundTransparency = opt == value and 0.85 or 1, BackgroundColor3 = Theme.Text,
                            Text = "  " .. tostring(opt), Font = Enum.Font.GothamMedium, TextSize = 12,
                            TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left,
                            AutoButtonColor = false, LayoutOrder = i, ZIndex = 62,
                        })
                        New("UICorner", { Parent = it, CornerRadius = UDim.new(0, 6) })
                        it.MouseButton1Click:Connect(function()
                            value = opt; boxText.Text = tostring(opt)
                            if c.Callback then task.spawn(c.Callback, opt) end
                            close()
                        end)
                    end
                    task.defer(function()
                        if not menu then return end
                        local bp, mp = box.AbsolutePosition, Main.AbsolutePosition
                        local bs = box.AbsoluteSize
                        menu.Position = UDim2.new(0, bp.X - mp.X, 0, bp.Y - mp.Y + bs.Y + 4)
                    end)
                end)

            elseif typ == "Input" then
                local f = card(c.Icon or "pencil", c.Title or "Input")
                New("TextLabel", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 32),
                    BackgroundTransparency = 1, Text = c.Label or c.Desc or "Digite algo...",
                    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
                })
                local box = New("Frame", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 54),
                    BackgroundColor3 = Theme.Input, ZIndex = 8,
                })
                New("UICorner", { Parent = box, CornerRadius = UDim.new(0, 8) })
                New("UIStroke", { Parent = box, Color = Theme.Outline, Thickness = 1, Transparency = 0.35 })
                local tb = New("TextBox", {
                    Parent = box, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = c.Default or "", PlaceholderText = c.Placeholder or "Ex: slowzzx",
                    PlaceholderColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextSize = 12,
                    TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 9,
                })
                tb.FocusLost:Connect(function()
                    if c.Callback then task.spawn(c.Callback, tb.Text) end
                end)

            elseif typ == "Button" then
                local f = card(c.Icon or "mouse-pointer-click", c.Title or "Button")
                if c.Desc then
                    New("TextLabel", {
                        Parent = f, Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 32),
                        BackgroundTransparency = 1, Text = c.Desc, Font = Enum.Font.Gotham, TextSize = 11,
                        TextColor3 = Theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
                    })
                end
                local btn = New("TextButton", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 1, -34),
                    AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = Theme.Surface,
                    Text = c.ButtonText or "Run", Font = Enum.Font.GothamMedium, TextSize = 12,
                    TextColor3 = Theme.Text, AutoButtonColor = false, ZIndex = 8,
                })
                New("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 8) })
                New("UIStroke", { Parent = btn, Color = Theme.Outline, Thickness = 1, Transparency = 0.35 })
                btn.MouseButton1Click:Connect(function()
                    if c.Callback then task.spawn(c.Callback) end
                end)

            elseif typ == "Paragraph" then
                local f = card(c.Icon or "info", c.Title or "Info")
                New("TextLabel", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 0, 34),
                    BackgroundTransparency = 1, Text = c.Desc or c.Content or "", Font = Enum.Font.Gotham,
                    TextSize = 12, TextColor3 = Theme.Dim, TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 7,
                })
            end
        end

        function page:Toggle(c) add("Toggle", c) return page end
        function page:Slider(c) add("Slider", c) return page end
        function page:Dropdown(c) add("Dropdown", c) return page end
        function page:Input(c) add("Input", c) return page end
        function page:Button(c) add("Button", c) return page end
        function page:Paragraph(c) add("Paragraph", c) return page end

        function page:Show()
            -- deselect all
            for _, p in ipairs(W.Pages) do
                if p._btn then
                    if p.IsBottom then
                        p._label.TextColor3 = Theme.Muted
                        p._icon.ImageColor3 = Theme.Muted
                        if p._line then p._line.BackgroundTransparency = 1 end
                    else
                        p._btn.BackgroundTransparency = 1
                        p._label.TextColor3 = Theme.Muted
                        p._icon.ImageColor3 = Theme.Muted
                        if p._line then p._line.BackgroundTransparency = 1 end
                    end
                end
            end
            if page.IsBottom then
                page._label.TextColor3 = Theme.Text
                page._icon.ImageColor3 = Theme.Text
                if page._line then page._line.BackgroundTransparency = 0 end
            else
                page._btn.BackgroundTransparency = 0.35
                page._btn.BackgroundColor3 = Theme.Surface
                page._label.TextColor3 = Theme.Text
                page._icon.ImageColor3 = Theme.Text
                if page._line then page._line.BackgroundTransparency = 0 end
            end
            W.Current = page
            clearContent()
            for _, item in ipairs(page.Items) do
                buildOne(item.t, item.c)
            end
        end

        -- UI button
        if opts.Bottom then
            local cell = New("TextButton", {
                Parent = BottomList, Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1,
                Text = "", AutoButtonColor = false, LayoutOrder = #W.Pages + 1, ZIndex = 12,
            })
            local ic = New("ImageLabel", {
                Parent = cell, Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0.5, 0, 0, 10),
                AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, ImageColor3 = Theme.Muted, ZIndex = 13,
            })
            ApplyIcon(ic, page.Icon)
            local lb = New("TextLabel", {
                Parent = cell, Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 30),
                BackgroundTransparency = 1, Text = page.Title, Font = Enum.Font.GothamMedium,
                TextSize = 11, TextColor3 = Theme.Muted, ZIndex = 13,
            })
            local line = New("Frame", {
                Parent = cell, Size = UDim2.new(0, 40, 0, 2), Position = UDim2.new(0.5, 0, 1, -4),
                AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = Theme.Text, BackgroundTransparency = 1,
                BorderSizePixel = 0, ZIndex = 13,
            })
            New("UICorner", { Parent = line, CornerRadius = UDim.new(0, 2) })
            page._btn = cell; page._icon = ic; page._label = lb; page._line = line
            cell.MouseButton1Click:Connect(function() page:Show() end)
        else
            local btn = New("TextButton", {
                Parent = TopBar, Size = UDim2.new(0, 0, 0, 34), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = #W.Pages + 1, ZIndex = 11,
            })
            New("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 10) })
            New("UIPadding", {
                Parent = btn, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
            })
            local row = New("Frame", {
                Parent = btn, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 12,
            })
            New("UIListLayout", {
                Parent = row, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 7),
                VerticalAlignment = Enum.VerticalAlignment.Center,
            })
            local ic = New("ImageLabel", {
                Parent = row, Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = Theme.Muted, ZIndex = 13,
            })
            ApplyIcon(ic, page.Icon)
            local lb = New("TextLabel", {
                Parent = row, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Text = page.Title, Font = Enum.Font.GothamMedium,
                TextSize = 13, TextColor3 = Theme.Muted, ZIndex = 13,
            })
            local line = New("Frame", {
                Parent = btn, Size = UDim2.new(1, -16, 0, 2), Position = UDim2.new(0.5, 0, 1, -2),
                AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = Theme.Text, BackgroundTransparency = 1,
                BorderSizePixel = 0, ZIndex = 13,
            })
            New("UICorner", { Parent = line, CornerRadius = UDim.new(0, 2) })
            page._btn = btn; page._icon = ic; page._label = lb; page._line = line
            btn.MouseButton1Click:Connect(function() page:Show() end)
        end

        table.insert(W.Pages, page)
        if not W.Current and not opts.Bottom then
            task.defer(function() page:Show() end)
        end
        return page
    end

    function W:Tab(cfg)
        return makePage({ Title = cfg.Title, Icon = cfg.Icon, Bottom = false })
    end
    function W:BottomTab(cfg)
        return makePage({ Title = cfg.Title, Icon = cfg.Icon, Bottom = true })
    end

    -- Minimize
    local mini
    function W:Minimize()
        Main.Visible = false
        if not mini then
            mini = New("TextButton", {
                Parent = gui, Size = UDim2.fromOffset(44, 44), Position = UDim2.new(0, 12, 0, 72),
                BackgroundColor3 = Theme.Bg, Text = "", AutoButtonColor = false, ZIndex = 100,
            })
            New("UICorner", { Parent = mini, CornerRadius = UDim.new(0, 10) })
            New("UIStroke", { Parent = mini, Color = Theme.Outline, Thickness = 1, Transparency = 0.3 })
            local ic = New("ImageLabel", {
                Parent = mini, Size = UDim2.fromOffset(20, 20), Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ImageColor3 = Theme.Text, ZIndex = 101,
            })
            ApplyIcon(ic, W.Icon)
            mini.MouseButton1Click:Connect(function() W:Show() end)
            local d, s, sp
            mini.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    d = true; s = input.Position; sp = mini.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then d = false end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if d and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - s
                    mini.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
                end
            end)
        end
        mini.Visible = true
    end
    function W:Show()
        Main.Visible = true
        if mini then mini.Visible = false end
    end
    function W:Destroy() gui:Destroy() end

    winBtn("minus", -50, function() W:Minimize() end)
    winBtn("x", -12, function() W:Destroy() end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == W.ToggleKey then
            if Main.Visible then W:Minimize() else W:Show() end
        end
    end)

    return W
end

return VoidxHub
