--[[
    VoidxHub UI Library
    Estilo Void Hub: sidebar, search, resize, colorpicker, user/anonymous
    Icons: Footagesus Lucide
    by slowzzx
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

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

local function T(o, p, d)
    local tw = TweenService:Create(o, TweenInfo.new(d or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p)
    tw:Play()
    return tw
end

local function N(class, props, kids)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    for _, c in ipairs(kids or {}) do c.Parent = i end
    return i
end

-- Cores iguais à Void Hub Dark
local Theme = {
    Background = Color3.fromHex("#0a0a0a"),
    SideBar = Color3.fromHex("#0f0f0f"),
    Text = Color3.fromHex("#FFFFFF"),
    ElementColor = Color3.fromHex("#141414"),
    Outline = Color3.fromHex("#1f1f1f"),
    Placeholder = Color3.fromHex("#6b6b6b"),
    IconColor = Color3.fromHex("#c8c8c8"),
    Accent = Color3.fromRGB(80, 160, 255),
}

local VoidxHub = {}
local ActiveDropdownClose

local function CloseDropdown()
    if ActiveDropdownClose then
        local f = ActiveDropdownClose
        ActiveDropdownClose = nil
        pcall(f)
    end
end

function VoidxHub:CreateWindow(cfg)
    cfg = cfg or {}
    local SideBarWidth = cfg.SideBarWidth or 160
    local WinSize = cfg.Size or UDim2.fromOffset(500, 380)
    local TopH = 42

    local W = {
        Name = cfg.Name or "VoidxHub",
        Author = cfg.Author or "By Slowzzx",
        Icon = cfg.Icon or "triangle",
        ToggleKey = cfg.ToggleKey or Enum.KeyCode.LeftControl,
        SideBarWidth = SideBarWidth,
        Size = WinSize,
        Resizable = cfg.Resizable ~= false,
        User = cfg.User or { Enabled = true, Anonymous = false },
        Tabs = {},
        SearchEntries = {},
        Open = true,
    }

    local gui = N("ScreenGui", {
        Name = "VoidxHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui()) or CoreGui,
    })

    local Main = N("Frame", {
        Parent = gui,
        Size = WinSize,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 1,
    })
    N("UICorner", { Parent = Main, CornerRadius = UDim.new(0, 14) })
    N("UIStroke", { Parent = Main, Color = Theme.Outline, Thickness = 1, Transparency = 0.2 })

    -- ========== TOPBAR ==========
    local Topbar = N("Frame", {
        Parent = Main,
        Size = UDim2.new(1, 0, 0, TopH),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 10,
    })

    local Logo = N("ImageLabel", {
        Parent = Topbar, Size = UDim2.fromOffset(22, 22),
        Position = UDim2.new(0, 14, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1, ImageColor3 = Theme.IconColor, ZIndex = 11,
    })
    ApplyIcon(Logo, W.Icon)

    local TitleLbl = N("TextLabel", {
        Parent = Topbar, Size = UDim2.new(0, 140, 0, 16),
        Position = UDim2.new(0, 42, 0, 6), BackgroundTransparency = 1,
        Text = W.Name, Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
    })
    local AuthorLbl = N("TextLabel", {
        Parent = Topbar, Size = UDim2.new(0, 140, 0, 12),
        Position = UDim2.new(0, 42, 0, 24), BackgroundTransparency = 1,
        Text = W.Author, Font = Enum.Font.Gotham, TextSize = 10,
        TextColor3 = Theme.Placeholder, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
    })

    -- Search
    local SearchBox = N("Frame", {
        Parent = Topbar, Size = UDim2.new(0, 150, 0, 28),
        Position = UDim2.new(1, -148, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Theme.ElementColor, ZIndex = 12,
    })
    N("UICorner", { Parent = SearchBox, CornerRadius = UDim.new(0, 8) })
    N("UIStroke", { Parent = SearchBox, Color = Theme.Outline, Thickness = 1, Transparency = 0.4 })
    local SearchIcon = N("ImageLabel", {
        Parent = SearchBox, Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1, ImageColor3 = Theme.Placeholder, ZIndex = 13,
    })
    ApplyIcon(SearchIcon, "search")
    local SearchInput = N("TextBox", {
        Parent = SearchBox, Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 26, 0, 0),
        BackgroundTransparency = 1, Text = "", PlaceholderText = "Search...",
        PlaceholderColor3 = Theme.Placeholder, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 13,
    })

    -- Window buttons (right of search, push search left)
    SearchBox.Position = UDim2.new(1, -148 - 100, 0.5, 0)

    local function topBtn(icon, x, cb)
        local b = N("TextButton", {
            Parent = Topbar, Size = UDim2.fromOffset(28, 28),
            Position = UDim2.new(1, x, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.ElementColor, BackgroundTransparency = 0.3, Text = "",
            AutoButtonColor = false, ZIndex = 14,
        })
        N("UICorner", { Parent = b, CornerRadius = UDim.new(0, 7) })
        local ic = N("ImageLabel", {
            Parent = b, Size = UDim2.fromOffset(13, 13), Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ImageColor3 = Theme.IconColor, ZIndex = 15,
        })
        ApplyIcon(ic, icon)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    -- Drag by topbar
    do
        local drag, start, spos
        Topbar.InputBegan:Connect(function(input)
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

    -- ========== SIDEBAR (esquerda, igual Void Hub) ==========
    local SideBar = N("Frame", {
        Parent = Main,
        Size = UDim2.new(0, SideBarWidth, 1, -TopH),
        Position = UDim2.new(0, 0, 0, TopH),
        BackgroundColor3 = Theme.SideBar,
        BorderSizePixel = 0,
        ZIndex = 5,
    })
    N("UICorner", { Parent = SideBar, CornerRadius = UDim.new(0, 12) })
    -- cover right corners of sidebar
    N("Frame", {
        Parent = SideBar, Size = UDim2.new(0, 12, 1, 0), Position = UDim2.new(1, -12, 0, 0),
        BackgroundColor3 = Theme.SideBar, BorderSizePixel = 0, ZIndex = 5,
    })

    local TabScroll = N("ScrollingFrame", {
        Parent = SideBar,
        Size = UDim2.new(1, -10, 1, W.User.Enabled and -56 or -10),
        Position = UDim2.new(0, 5, 0, 6),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 6,
    })
    N("UIListLayout", {
        Parent = TabScroll, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
    })

    -- User frame (bottom sidebar)
    local UserFrame = N("Frame", {
        Parent = SideBar,
        Size = UDim2.new(1, -16, 0, 40),
        Position = UDim2.new(0.5, 0, 1, -8),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Theme.Background,
        Visible = W.User.Enabled == true,
        ZIndex = 8,
    })
    N("UICorner", { Parent = UserFrame, CornerRadius = UDim.new(0, 10) })
    local UserImg = N("ImageLabel", {
        Parent = UserFrame, Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.ElementColor, ZIndex = 9,
    })
    N("UICorner", { Parent = UserImg, CornerRadius = UDim.new(1, 0) })
    pcall(function()
        local uid = W.User.Anonymous and 1 or LocalPlayer.UserId
        UserImg.Image = Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    local UserName = N("TextLabel", {
        Parent = UserFrame, Size = UDim2.new(1, -44, 0, 14),
        Position = UDim2.new(0, 40, 0, 6), BackgroundTransparency = 1,
        Text = W.User.Anonymous and "Anonymous" or LocalPlayer.DisplayName,
        Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 9,
    })
    local UserSub = N("TextLabel", {
        Parent = UserFrame, Size = UDim2.new(1, -44, 0, 12),
        Position = UDim2.new(0, 40, 0, 22), BackgroundTransparency = 1,
        Text = W.User.Anonymous and "@hidden" or ("@" .. LocalPlayer.Name),
        Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.Placeholder,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 9,
    })

    -- ========== CONTENT ==========
    local ContentHost = N("Frame", {
        Parent = Main,
        Size = UDim2.new(1, -SideBarWidth - 10, 1, -TopH - 12),
        Position = UDim2.new(0, SideBarWidth + 5, 0, TopH + 6),
        BackgroundColor3 = Theme.SideBar,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 4,
    })
    N("UICorner", { Parent = ContentHost, CornerRadius = UDim.new(0, 12) })

    local Content = N("ScrollingFrame", {
        Parent = ContentHost,
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65),
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 5,
    })
    N("UIListLayout", {
        Parent = Content, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
    })
    N("UIPadding", {
        Parent = Content, PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
    })

    local function clearContent()
        for _, c in ipairs(Content:GetChildren()) do
            if not (c:IsA("UIListLayout") or c:IsA("UIPadding")) then c:Destroy() end
        end
    end

    -- ========== SEARCH ==========
    local function applySearch(term)
        term = string.lower(term or "")
        if term == "" then
            if W.Current then W.Current:Show() end
            return
        end
        clearContent()
        for _, e in ipairs(W.SearchEntries) do
            local hay = string.lower((e.Title or "") .. " " .. (e.Desc or "") .. " " .. (e.Tab or ""))
            if string.find(hay, term, 1, true) then
                -- show matching element card
                if e.Build then e.Build() end
            end
        end
    end
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        applySearch(SearchInput.Text)
    end)

    -- ========== ELEMENT BUILDERS ==========
    local function elCard(parent)
        local f = N("Frame", {
            Parent = parent or Content,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.ElementColor,
            BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
            ZIndex = 6,
        })
        N("UICorner", { Parent = f, CornerRadius = UDim.new(0, 10) })
        N("UIStroke", { Parent = f, Color = Theme.Outline, Thickness = 0.8, Transparency = 0.35 })
        N("UIPadding", {
            Parent = f, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
        })
        return f
    end

    local function elTitle(parent, title, desc)
        local t = N("TextLabel", {
            Parent = parent, Size = UDim2.new(1, -8, 0, 15), BackgroundTransparency = 1,
            Text = title or "", Font = Enum.Font.GothamMedium, TextSize = 13,
            TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
        })
        if desc and desc ~= "" then
            N("TextLabel", {
                Parent = parent, Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 0, 0, 16),
                BackgroundTransparency = 1, Text = desc, Font = Enum.Font.Gotham, TextSize = 11,
                TextColor3 = Theme.Placeholder, TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true, ZIndex = 7,
            })
            return 34
        end
        return 18
    end

    local function makeBuilders(page)
        local function reg(title, desc, buildFn)
            table.insert(W.SearchEntries, {
                Title = title, Desc = desc, Tab = page.Title, Build = buildFn,
            })
            table.insert(page.Items, buildFn)
            if W.Current == page then buildFn() end
        end

        function page:Section(c)
            c = c or {}
            reg(c.Title, nil, function()
                local f = N("Frame", {
                    Parent = Content, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, ZIndex = 6,
                })
                N("TextLabel", {
                    Parent = f, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                    Text = c.Title or "Section", Font = Enum.Font.GothamBold, TextSize = 12,
                    TextColor3 = Theme.Placeholder, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
                })
            end)
            return page
        end

        function page:Paragraph(c)
            c = c or {}
            reg(c.Title, c.Desc, function()
                local f = elCard()
                local h = elTitle(f, c.Title or "Paragraph", c.Desc)
                f.Size = UDim2.new(1, 0, 0, h + 12)
            end)
            return page
        end

        function page:Button(c)
            c = c or {}
            reg(c.Title, c.Desc, function()
                local f = elCard()
                local h = elTitle(f, c.Title or "Button", c.Desc)
                local btn = N("TextButton", {
                    Parent = f, Size = UDim2.new(0, 72, 0, 28),
                    Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Theme.Background, Text = c.ButtonText or "Run",
                    Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Text,
                    AutoButtonColor = false, ZIndex = 8,
                })
                N("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 7) })
                N("UIStroke", { Parent = btn, Color = Theme.Outline, Thickness = 1, Transparency = 0.4 })
                btn.MouseButton1Click:Connect(function()
                    if c.Callback then task.spawn(c.Callback) end
                end)
                f.Size = UDim2.new(1, 0, 0, math.max(h, 28) + 12)
            end)
            return page
        end

        function page:Toggle(c)
            c = c or {}
            reg(c.Title, c.Desc, function()
                local state = c.Default == true
                local f = elCard()
                local h = elTitle(f, c.Title or "Toggle", c.Desc)
                local track = N("Frame", {
                    Parent = f, Size = UDim2.fromOffset(40, 22),
                    Position = UDim2.new(1, 0, 0, 2), AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = state and Theme.Accent or Theme.Outline, ZIndex = 8,
                })
                N("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })
                local knob = N("Frame", {
                    Parent = track, Size = UDim2.fromOffset(16, 16),
                    Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.Text, ZIndex = 9,
                })
                N("UICorner", { Parent = knob, CornerRadius = UDim.new(1, 0) })
                local hit = N("TextButton", {
                    Parent = track, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 10,
                })
                hit.MouseButton1Click:Connect(function()
                    state = not state
                    T(track, { BackgroundColor3 = state and Theme.Accent or Theme.Outline })
                    T(knob, { Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
                    if c.Callback then task.spawn(c.Callback, state) end
                end)
                f.Size = UDim2.new(1, 0, 0, math.max(h, 24) + 12)
            end)
            return page
        end

        function page:Slider(c)
            c = c or {}
            local min = c.Min or (c.Value and c.Value.Min) or 0
            local max = c.Max or (c.Value and c.Value.Max) or 100
            local step = c.Step or 1
            local value = c.Default or (c.Value and c.Value.Default) or min
            value = math.clamp(value, min, max)
            reg(c.Title, c.Desc, function()
                local f = elCard()
                local h = elTitle(f, c.Title or "Slider", c.Desc)
                local valL = N("TextLabel", {
                    Parent = f, Size = UDim2.new(0, 40, 0, 14),
                    Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1, Text = tostring(value),
                    Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 8,
                })
                local y = h + 6
                local track = N("Frame", {
                    Parent = f, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, y),
                    BackgroundColor3 = Theme.Outline, ZIndex = 7,
                })
                N("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })
                local fill = N("Frame", {
                    Parent = track, Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent, ZIndex = 8,
                })
                N("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })
                local knob = N("Frame", {
                    Parent = track, Size = UDim2.fromOffset(12, 12),
                    Position = UDim2.new((value - min) / math.max(max - min, 1), 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Text, ZIndex = 9,
                })
                N("UICorner", { Parent = knob, CornerRadius = UDim.new(1, 0) })
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
                f.Size = UDim2.new(1, 0, 0, y + 16)
            end)
            return page
        end

        function page:Dropdown(c)
            c = c or {}
            local options = c.Option or c.Options or {}
            local multi = c.Multi == true
            local value = c.Value
            if multi then
                if type(value) ~= "table" then value = value and { value } or {} end
            else
                if type(value) == "table" then value = value[1] end
                value = value or options[1] or ""
            end
            reg(c.Title, c.Desc, function()
                local f = elCard()
                local h = elTitle(f, c.Title or "Dropdown", c.Desc)
                local function disp()
                    if multi then
                        local t = table.concat(value, ", ")
                        return t ~= "" and t or "Select..."
                    end
                    return tostring(value)
                end
                local box = N("TextButton", {
                    Parent = f, Size = UDim2.new(0, 140, 0, 28),
                    Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Theme.Background, Text = "", AutoButtonColor = false, ZIndex = 8,
                })
                N("UICorner", { Parent = box, CornerRadius = UDim.new(0, 7) })
                N("UIStroke", { Parent = box, Color = Theme.Outline, Thickness = 1, Transparency = 0.4 })
                local boxT = N("TextLabel", {
                    Parent = box, Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency = 1, Text = disp(), Font = Enum.Font.Gotham, TextSize = 11,
                    TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 9,
                })
                local chev = N("ImageLabel", {
                    Parent = box, Size = UDim2.fromOffset(12, 12), Position = UDim2.new(1, -6, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, ImageColor3 = Theme.IconColor, ZIndex = 9,
                })
                ApplyIcon(chev, "chevron-down")
                local menu
                local function close()
                    if menu then menu:Destroy() menu = nil end
                    if ActiveDropdownClose == close then ActiveDropdownClose = nil end
                    T(chev, { Rotation = 0 })
                end
                box.MouseButton1Click:Connect(function()
                    if menu then close() return end
                    CloseDropdown()
                    ActiveDropdownClose = close
                    T(chev, { Rotation = 180 })
                    local mh = math.min(180, #options * 28 + 36)
                    menu = N("Frame", {
                        Parent = Main, Size = UDim2.fromOffset(160, mh),
                        BackgroundColor3 = Theme.Background, ZIndex = 80, ClipsDescendants = true,
                    })
                    N("UICorner", { Parent = menu, CornerRadius = UDim.new(0, 10) })
                    N("UIStroke", { Parent = menu, Color = Theme.Outline, Thickness = 1, Transparency = 0.25 })
                    -- search inside dropdown
                    local sFrame = N("Frame", {
                        Parent = menu, Size = UDim2.new(1, -10, 0, 26), Position = UDim2.new(0, 5, 0, 5),
                        BackgroundColor3 = Theme.ElementColor, ZIndex = 81,
                    })
                    N("UICorner", { Parent = sFrame, CornerRadius = UDim.new(0, 6) })
                    local sBox = N("TextBox", {
                        Parent = sFrame, Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 4, 0, 0),
                        BackgroundTransparency = 1, Text = "", PlaceholderText = "Search...",
                        PlaceholderColor3 = Theme.Placeholder, Font = Enum.Font.Gotham, TextSize = 11,
                        TextColor3 = Theme.Text, ClearTextOnFocus = false, ZIndex = 82,
                    })
                    local sc = N("ScrollingFrame", {
                        Parent = menu, Size = UDim2.new(1, -8, 1, -38), Position = UDim2.new(0, 4, 0, 34),
                        BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0, 0, 0, 0),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 81,
                    })
                    N("UIListLayout", { Parent = sc, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

                    local function rebuild(filter)
                        for _, ch in ipairs(sc:GetChildren()) do
                            if ch:IsA("TextButton") then ch:Destroy() end
                        end
                        filter = string.lower(filter or "")
                        for i, opt in ipairs(options) do
                            if filter ~= "" and not string.find(string.lower(tostring(opt)), filter, 1, true) then
                                -- skip
                            else
                                local sel = multi and (function()
                                    for _, v in ipairs(value) do if v == opt then return true end end
                                    return false
                                end)() or value == opt
                                local it = N("TextButton", {
                                    Parent = sc, Size = UDim2.new(1, 0, 0, 26),
                                    BackgroundTransparency = sel and 0.85 or 1, BackgroundColor3 = Theme.Accent,
                                    Text = "  " .. tostring(opt), Font = Enum.Font.Gotham, TextSize = 12,
                                    TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left,
                                    AutoButtonColor = false, LayoutOrder = i, ZIndex = 82,
                                })
                                N("UICorner", { Parent = it, CornerRadius = UDim.new(0, 5) })
                                it.MouseButton1Click:Connect(function()
                                    if multi then
                                        local found
                                        for j = #value, 1, -1 do
                                            if value[j] == opt then table.remove(value, j) found = true break end
                                        end
                                        if not found then table.insert(value, opt) end
                                        boxT.Text = disp()
                                        rebuild(sBox.Text)
                                        if c.Callback then task.spawn(c.Callback, value) end
                                    else
                                        value = opt
                                        boxT.Text = disp()
                                        if c.Callback then task.spawn(c.Callback, opt) end
                                        close()
                                    end
                                end)
                            end
                        end
                    end
                    sBox:GetPropertyChangedSignal("Text"):Connect(function() rebuild(sBox.Text) end)
                    rebuild("")
                    task.defer(function()
                        if not menu then return end
                        local bp, mp = box.AbsolutePosition, Main.AbsolutePosition
                        local bs = box.AbsoluteSize
                        menu.Position = UDim2.new(0, bp.X - mp.X + bs.X - 160, 0, bp.Y - mp.Y + bs.Y + 4)
                    end)
                end)
                f.Size = UDim2.new(1, 0, 0, math.max(h, 28) + 12)
            end)
            return page
        end

        function page:Input(c)
            c = c or {}
            reg(c.Title, c.Desc, function()
                local f = elCard()
                local h = elTitle(f, c.Title or "Input", c.Desc)
                local box = N("Frame", {
                    Parent = f, Size = UDim2.new(0, 140, 0, 28),
                    Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Theme.Background, ZIndex = 8,
                })
                N("UICorner", { Parent = box, CornerRadius = UDim.new(0, 7) })
                N("UIStroke", { Parent = box, Color = Theme.Outline, Thickness = 1, Transparency = 0.4 })
                local tb = N("TextBox", {
                    Parent = box, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 6, 0, 0),
                    BackgroundTransparency = 1, Text = c.Default or "", PlaceholderText = c.Placeholder or "...",
                    PlaceholderColor3 = Theme.Placeholder, Font = Enum.Font.Gotham, TextSize = 12,
                    TextColor3 = Theme.Text, ClearTextOnFocus = false, ZIndex = 9,
                })
                tb.FocusLost:Connect(function()
                    if c.Callback then task.spawn(c.Callback, tb.Text) end
                end)
                f.Size = UDim2.new(1, 0, 0, math.max(h, 28) + 12)
            end)
            return page
        end

        function page:Keybind(c)
            c = c or {}
            local key = c.Default or "None"
            reg(c.Title, c.Desc, function()
                local f = elCard()
                local h = elTitle(f, c.Title or "Keybind", c.Desc)
                local box = N("TextButton", {
                    Parent = f, Size = UDim2.new(0, 80, 0, 28),
                    Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Theme.Background, Text = tostring(key),
                    Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.Text,
                    AutoButtonColor = false, ZIndex = 8,
                })
                N("UICorner", { Parent = box, CornerRadius = UDim.new(0, 7) })
                N("UIStroke", { Parent = box, Color = Theme.Outline, Thickness = 1, Transparency = 0.4 })
                local listening = false
                box.MouseButton1Click:Connect(function()
                    listening = true
                    box.Text = "..."
                end)
                local conn
                conn = UserInputService.InputBegan:Connect(function(input, gp)
                    if not listening then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode.Name
                        box.Text = key
                        listening = false
                        if c.Callback then task.spawn(c.Callback, key) end
                    end
                end)
                f.Size = UDim2.new(1, 0, 0, math.max(h, 28) + 12)
            end)
            return page
        end

        function page:Colorpicker(c)
            c = c or {}
            local col = c.Default or Color3.fromRGB(255, 255, 255)
            local h, s, v = Color3.toHSV(col)
            reg(c.Title, c.Desc, function()
                local f = elCard()
                local th = elTitle(f, c.Title or "Colorpicker", c.Desc)
                local preview = N("TextButton", {
                    Parent = f, Size = UDim2.fromOffset(28, 28),
                    Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = col, Text = "", AutoButtonColor = false, ZIndex = 8,
                })
                N("UICorner", { Parent = preview, CornerRadius = UDim.new(0, 7) })
                N("UIStroke", { Parent = preview, Color = Theme.Outline, Thickness = 1, Transparency = 0.3 })

                local dialog
                local function openPicker()
                    if dialog then dialog:Destroy() dialog = nil return end
                    dialog = N("Frame", {
                        Parent = Main, Size = UDim2.fromOffset(260, 220),
                        Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Theme.Background, ZIndex = 90,
                    })
                    N("UICorner", { Parent = dialog, CornerRadius = UDim.new(0, 12) })
                    N("UIStroke", { Parent = dialog, Color = Theme.Outline, Thickness = 1 })

                    local sat = N("ImageButton", {
                        Parent = dialog, Size = UDim2.fromOffset(160, 140), Position = UDim2.new(0, 12, 0, 12),
                        BackgroundColor3 = Color3.fromHSV(h, 1, 1), AutoButtonColor = false, ZIndex = 91,
                        Image = "rbxassetid://4155801252",
                    })
                    N("UICorner", { Parent = sat, CornerRadius = UDim.new(0, 8) })
                    local cursor = N("Frame", {
                        Parent = sat, Size = UDim2.fromOffset(10, 10),
                        Position = UDim2.new(s, 0, 1 - v, 0), AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 92,
                    })
                    N("UICorner", { Parent = cursor, CornerRadius = UDim.new(1, 0) })
                    N("UIStroke", { Parent = cursor, Color = Color3.new(0, 0, 0), Thickness = 1 })

                    local hue = N("Frame", {
                        Parent = dialog, Size = UDim2.fromOffset(16, 140), Position = UDim2.new(0, 184, 0, 12),
                        BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 91,
                    })
                    N("UICorner", { Parent = hue, CornerRadius = UDim.new(0, 6) })
                    N("UIGradient", {
                        Parent = hue,
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
                        }),
                        Rotation = 90,
                    })
                    local hueC = N("Frame", {
                        Parent = hue, Size = UDim2.new(1, 4, 0, 4), Position = UDim2.new(0.5, 0, h, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Text, ZIndex = 92,
                    })
                    N("UICorner", { Parent = hueC, CornerRadius = UDim.new(1, 0) })

                    local prev = N("Frame", {
                        Parent = dialog, Size = UDim2.fromOffset(40, 40), Position = UDim2.new(0, 212, 0, 12),
                        BackgroundColor3 = col, ZIndex = 91,
                    })
                    N("UICorner", { Parent = prev, CornerRadius = UDim.new(0, 8) })

                    local hexBox = N("TextBox", {
                        Parent = dialog, Size = UDim2.fromOffset(40, 22), Position = UDim2.new(0, 212, 0, 58),
                        BackgroundColor3 = Theme.ElementColor, Text = "#" .. col:ToHex(),
                        Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Center, ClearTextOnFocus = false, ZIndex = 91,
                    })
                    N("UICorner", { Parent = hexBox, CornerRadius = UDim.new(0, 5) })

                    local function update(skipHex)
                        col = Color3.fromHSV(h, s, v)
                        sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        cursor.Position = UDim2.new(s, 0, 1 - v, 0)
                        hueC.Position = UDim2.new(0.5, 0, h, 0)
                        prev.BackgroundColor3 = col
                        preview.BackgroundColor3 = col
                        if not skipHex and not hexBox:IsFocused() then
                            hexBox.Text = "#" .. col:ToHex()
                        end
                        if c.Callback then task.spawn(c.Callback, col) end
                    end

                    local function parseHex(str)
                        str = tostring(str or ""):gsub("%s+", ""):gsub("^#", "")
                        if #str == 3 then str = str:sub(1,1):rep(2)..str:sub(2,2):rep(2)..str:sub(3,3):rep(2) end
                        if #str ~= 6 then return nil end
                        local r, g, b = tonumber(str:sub(1,2),16), tonumber(str:sub(3,4),16), tonumber(str:sub(5,6),16)
                        if r and g and b then return Color3.fromRGB(r, g, b) end
                    end
                    hexBox.FocusLost:Connect(function()
                        local nc = parseHex(hexBox.Text)
                        if nc then h, s, v = Color3.toHSV(nc); update(true); hexBox.Text = "#" .. nc:ToHex()
                        else hexBox.Text = "#" .. col:ToHex() end
                    end)
                    hexBox:GetPropertyChangedSignal("Text"):Connect(function()
                        if not hexBox:IsFocused() then return end
                        local nc = parseHex(hexBox.Text)
                        if nc then h, s, v = Color3.toHSV(nc); update(true) end
                    end)

                    local function dragSat(input)
                        local relX = math.clamp((input.Position.X - sat.AbsolutePosition.X) / sat.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - sat.AbsolutePosition.Y) / sat.AbsoluteSize.Y, 0, 1)
                        s, v = relX, 1 - relY
                        update()
                    end
                    local function dragHue(input)
                        h = math.clamp((input.Position.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
                        update()
                    end
                    local ds, dh
                    sat.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            ds = true; dragSat(input)
                        end
                    end)
                    hue.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dh = true; dragHue(input)
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if ds then dragSat(input) end
                        if dh then dragHue(input) end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            ds, dh = false, false
                        end
                    end)

                    local closeB = N("TextButton", {
                        Parent = dialog, Size = UDim2.new(1, -24, 0, 30), Position = UDim2.new(0, 12, 1, -40),
                        BackgroundColor3 = Theme.ElementColor, Text = "Close", Font = Enum.Font.GothamMedium,
                        TextSize = 12, TextColor3 = Theme.Text, AutoButtonColor = false, ZIndex = 91,
                    })
                    N("UICorner", { Parent = closeB, CornerRadius = UDim.new(0, 8) })
                    closeB.MouseButton1Click:Connect(function()
                        dialog:Destroy(); dialog = nil
                    end)
                end
                preview.MouseButton1Click:Connect(openPicker)
                f.Size = UDim2.new(1, 0, 0, math.max(th, 28) + 12)
            end)
            return page
        end

        return page
    end

    -- ========== TAB ==========
    function W:Tab(cfg)
        cfg = cfg or {}
        local page = {
            Title = cfg.Title or "Tab",
            Icon = cfg.Icon or "circle",
            Items = {},
        }

        local btn = N("TextButton", {
            Parent = TabScroll, Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
            LayoutOrder = #W.Tabs + 1, ZIndex = 7,
        })
        N("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 8) })
        local ic = N("ImageLabel", {
            Parent = btn, Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1, ImageColor3 = Theme.Placeholder, ZIndex = 8,
        })
        ApplyIcon(ic, page.Icon)
        local lb = N("TextLabel", {
            Parent = btn, Size = UDim2.new(1, -36, 1, 0), Position = UDim2.new(0, 32, 0, 0),
            BackgroundTransparency = 1, Text = page.Title, Font = Enum.Font.GothamMedium,
            TextSize = 13, TextColor3 = Theme.Placeholder, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8,
        })

        function page:Show()
            CloseDropdown()
            for _, t in ipairs(W.Tabs) do
                t._btn.BackgroundTransparency = 1
                t._lb.TextColor3 = Theme.Placeholder
                t._ic.ImageColor3 = Theme.Placeholder
            end
            btn.BackgroundTransparency = 0.5
            btn.BackgroundColor3 = Theme.ElementColor
            lb.TextColor3 = Theme.Text
            ic.ImageColor3 = Theme.IconColor
            W.Current = page
            clearContent()
            for _, build in ipairs(page.Items) do
                pcall(build)
            end
        end

        page._btn = btn; page._lb = lb; page._ic = ic
        btn.MouseButton1Click:Connect(function() page:Show() end)

        makeBuilders(page)
        table.insert(W.Tabs, page)
        if #W.Tabs == 1 then task.defer(function() page:Show() end) end
        return page
    end

    -- User API
    function W:UserEnabled(v)
        W.User.Enabled = v and true or false
        UserFrame.Visible = W.User.Enabled
        TabScroll.Size = UDim2.new(1, -10, 1, W.User.Enabled and -56 or -10)
    end
    function W:Anonymous(v)
        W.User.Anonymous = v and true or false
        UserName.Text = W.User.Anonymous and "Anonymous" or LocalPlayer.DisplayName
        UserSub.Text = W.User.Anonymous and "@hidden" or ("@" .. LocalPlayer.Name)
        pcall(function()
            local uid = W.User.Anonymous and 1 or LocalPlayer.UserId
            UserImg.Image = Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
    end

    -- Resize
    local function applySize(w, h)
        w = math.clamp(w, 420, 900)
        h = math.clamp(h, 280, 700)
        W.Size = UDim2.fromOffset(w, h)
        Main.Size = W.Size
        SideBar.Size = UDim2.new(0, SideBarWidth, 1, -TopH)
        ContentHost.Size = UDim2.new(1, -SideBarWidth - 10, 1, -TopH - 12)
        ContentHost.Position = UDim2.new(0, SideBarWidth + 5, 0, TopH + 6)
    end
    function W:Resize(w, h) applySize(w, h) end
    function W:SetResizable(v) W.Resizable = v and true or false; resizeHandle.Visible = W.Resizable end

    local resizeHandle = N("Frame", {
        Parent = Main, Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -2, 1, -2), AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1, ZIndex = 50, Visible = W.Resizable,
    })
    do
        local resizing, start, startSize
        resizeHandle.InputBegan:Connect(function(input)
            if not W.Resizable then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true; start = input.Position; startSize = Main.AbsoluteSize
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then resizing = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - start
                applySize(startSize.X + d.X, startSize.Y + d.Y)
            end
        end)
    end

    -- Minimize / Destroy
    local mini
    function W:Minimize()
        Main.Visible = false; W.Open = false
        if not mini then
            mini = N("TextButton", {
                Parent = gui, Size = UDim2.fromOffset(44, 44), Position = UDim2.new(0, 12, 0, 72),
                BackgroundColor3 = Theme.Background, Text = "", AutoButtonColor = false, ZIndex = 100,
            })
            N("UICorner", { Parent = mini, CornerRadius = UDim.new(0, 10) })
            N("UIStroke", { Parent = mini, Color = Theme.Outline, Thickness = 1, Transparency = 0.3 })
            local ic = N("ImageLabel", {
                Parent = mini, Size = UDim2.fromOffset(20, 20), Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ImageColor3 = Theme.IconColor, ZIndex = 101,
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
    function W:Show() Main.Visible = true; W.Open = true; if mini then mini.Visible = false end end
    function W:Destroy() gui:Destroy() end
    function W:ToCenter() Main.Position = UDim2.fromScale(0.5, 0.5) end
    function W:SetToggleKey(k) W.ToggleKey = k end

    topBtn("minus", -44, function() W:Minimize() end)
    topBtn("x", -12, function() W:Destroy() end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == W.ToggleKey then
            if W.Open then W:Minimize() else W:Show() end
        end
    end)

    return W
end

return VoidxHub
