--[[
    Rubi Hub UI Library
    Style inspired by Chilli Hub (red theme, white details, rounded toggles/sliders)
    Pure UI library — no game features. Host on HTTPS and require from other scripts.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Rubi = {}
Rubi.__index = Rubi

-- ═══════════════════════════════════════════
-- THEME
-- ═══════════════════════════════════════════
local Theme = {
    Accent       = Color3.fromRGB(200, 35, 35),
    AccentDark   = Color3.fromRGB(150, 20, 20),
    AccentLight  = Color3.fromRGB(230, 50, 50),
    Background   = Color3.fromRGB(22, 22, 22),
    Background2  = Color3.fromRGB(28, 28, 28),
    Background3  = Color3.fromRGB(35, 35, 35),
    SectionBg    = Color3.fromRGB(30, 30, 30),
    Text         = Color3.fromRGB(255, 255, 255),
    TextDim      = Color3.fromRGB(180, 180, 180),
    TextDark     = Color3.fromRGB(120, 120, 120),
    ToggleOn     = Color3.fromRGB(50, 200, 80),
    ToggleOff    = Color3.fromRGB(60, 60, 60),
    SliderFill   = Color3.fromRGB(50, 200, 80),
    Stroke       = Color3.fromRGB(55, 55, 55),
    SearchBg     = Color3.fromRGB(25, 25, 25),
    SidebarBtn   = Color3.fromRGB(200, 35, 35),
    SidebarHover = Color3.fromRGB(230, 50, 50),
}

local function tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function pad(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.Parent = parent
    return p
end

-- ═══════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════
function Rubi:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "Rubi Hub"
    local size = opts.Size or UDim2.new(0, 520, 0, 380)

    if CoreGui:FindFirstChild("RubiHubGui") then
        CoreGui.RubiHubGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RubiHubGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- Main window
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = size
    Main.Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Parent = ScreenGui
    corner(Main, 8)
    stroke(Main, Color3.fromRGB(40, 40, 40), 1)

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 36)
    TitleBar.BackgroundColor3 = Theme.Accent
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    corner(TitleBar, 8)

    -- Fix bottom corners of title
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 10)
    titleFix.Position = UDim2.new(0, 0, 1, -10)
    titleFix.BackgroundColor3 = Theme.Accent
    titleFix.BorderSizePixel = 0
    titleFix.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 14, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.Text
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TitleBar
    corner(CloseBtn, 6)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Drag
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Sidebar (left)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 110, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Theme.Background2
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Theme.Accent
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.Parent = Main

    local SideList = Instance.new("UIListLayout")
    SideList.Padding = UDim.new(0, 4)
    SideList.SortOrder = Enum.SortOrder.LayoutOrder
    SideList.Parent = Sidebar
    pad(Sidebar, 8, 8, 6, 6)

    -- Right panel buttons
    local RightPanel = Instance.new("Frame")
    RightPanel.Name = "RightPanel"
    RightPanel.Size = UDim2.new(0, 110, 1, -36)
    RightPanel.Position = UDim2.new(1, -110, 0, 36)
    RightPanel.BackgroundColor3 = Theme.Background2
    RightPanel.BorderSizePixel = 0
    RightPanel.Parent = Main

    local RightList = Instance.new("UIListLayout")
    RightList.Padding = UDim.new(0, 4)
    RightList.SortOrder = Enum.SortOrder.LayoutOrder
    RightList.Parent = RightPanel
    pad(RightPanel, 8, 8, 6, 6)

    -- Content area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -220, 1, -70)
    Content.Position = UDim2.new(0, 110, 0, 36)
    Content.BackgroundColor3 = Theme.Background
    Content.BorderSizePixel = 0
    Content.ClipsDescendants = true
    Content.Parent = Main

    -- Search bar
    local SearchBar = Instance.new("Frame")
    SearchBar.Name = "SearchBar"
    SearchBar.Size = UDim2.new(1, -220, 0, 28)
    SearchBar.Position = UDim2.new(0, 110, 1, -32)
    SearchBar.BackgroundColor3 = Theme.SearchBg
    SearchBar.BorderSizePixel = 0
    SearchBar.Parent = Main
    corner(SearchBar, 6)
    stroke(SearchBar, Theme.Stroke, 1)

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -16, 1, 0)
    SearchBox.Position = UDim2.new(0, 8, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.PlaceholderText = "Search  Filter features..."
    SearchBox.PlaceholderColor3 = Theme.TextDark
    SearchBox.Text = ""
    SearchBox.TextColor3 = Theme.Text
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 12
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent = SearchBar

    -- FPS / MS counter (top right overlay style)
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Name = "Stats"
    StatsFrame.Size = UDim2.new(0, 120, 0, 22)
    StatsFrame.Position = UDim2.new(1, -130, 0, 8)
    StatsFrame.BackgroundTransparency = 1
    StatsFrame.Parent = ScreenGui

    local FpsLabel = Instance.new("TextLabel")
    FpsLabel.Size = UDim2.new(0.5, 0, 1, 0)
    FpsLabel.BackgroundTransparency = 1
    FpsLabel.Text = "60 FPS"
    FpsLabel.TextColor3 = Theme.Text
    FpsLabel.Font = Enum.Font.GothamBold
    FpsLabel.TextSize = 11
    FpsLabel.TextXAlignment = Enum.TextXAlignment.Right
    FpsLabel.Parent = StatsFrame

    local MsLabel = Instance.new("TextLabel")
    MsLabel.Size = UDim2.new(0.5, -4, 1, 0)
    MsLabel.Position = UDim2.new(0.5, 4, 0, 0)
    MsLabel.BackgroundTransparency = 1
    MsLabel.Text = "16 ms"
    MsLabel.TextColor3 = Theme.TextDim
    MsLabel.Font = Enum.Font.Gotham
    MsLabel.TextSize = 11
    MsLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsLabel.Parent = StatsFrame

    local frames, last = 0, tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - last >= 1 then
            local fps = frames
            frames = 0
            last = now
            FpsLabel.Text = fps .. " FPS"
            MsLabel.Text = math.floor(1000 / math.max(fps, 1)) .. " ms"
        end
    end)

    -- Window object
    local Window = {
        ScreenGui = ScreenGui,
        Main = Main,
        Sidebar = Sidebar,
        RightPanel = RightPanel,
        Content = Content,
        SearchBox = SearchBox,
        Tabs = {},
        CurrentTab = nil,
        _tabOrder = 0,
        _rightOrder = 0,
    }

    -- ═══════════════════════════════════════
    -- TAB
    -- ═══════════════════════════════════════
    function Window:CreateTab(name, isRight)
        self._tabOrder = self._tabOrder + 1
        local order = self._tabOrder
        local parent = isRight and self.RightPanel or self.Sidebar

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.Size = UDim2.new(1, 0, 0, 28)
        TabBtn.BackgroundColor3 = Theme.SidebarBtn
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.Text
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.LayoutOrder = order
        TabBtn.Parent = parent
        corner(TabBtn, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = self.Content

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 6)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = Page
        pad(Page, 8, 8, 8, 8)

        local Tab = {
            Name = name,
            Button = TabBtn,
            Page = Page,
            _sectionOrder = 0,
        }

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Page.Visible = false
                tween(t.Button, { BackgroundColor3 = Theme.SidebarBtn }, 0.15)
            end
            Page.Visible = true
            tween(TabBtn, { BackgroundColor3 = Theme.AccentLight }, 0.15)
            self.CurrentTab = Tab
        end)

        TabBtn.MouseEnter:Connect(function()
            if self.CurrentTab ~= Tab then
                tween(TabBtn, { BackgroundColor3 = Theme.SidebarHover }, 0.12)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if self.CurrentTab ~= Tab then
                tween(TabBtn, { BackgroundColor3 = Theme.SidebarBtn }, 0.12)
            end
        end)

        self.Tabs[name] = Tab

        if not self.CurrentTab and not isRight then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Theme.AccentLight
            self.CurrentTab = Tab
        end

        -- ═══════════════════════════════════
        -- SECTION (collapsible)
        -- ═══════════════════════════════════
        function Tab:CreateSection(sectionName)
            self._sectionOrder = self._sectionOrder + 1
            local sOrder = self._sectionOrder

            local Section = Instance.new("Frame")
            Section.Name = sectionName
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundColor3 = Theme.SectionBg
            Section.BorderSizePixel = 0
            Section.ClipsDescendants = true
            Section.LayoutOrder = sOrder
            Section.AutomaticSize = Enum.AutomaticSize.None
            Section.Parent = Page
            corner(Section, 6)

            local Header = Instance.new("TextButton")
            Header.Size = UDim2.new(1, 0, 0, 28)
            Header.BackgroundTransparency = 1
            Header.Text = ""
            Header.Parent = Section

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Position = UDim2.new(0, 6, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▾"
            Arrow.TextColor3 = Theme.TextDim
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14
            Arrow.Parent = Header

            local SecTitle = Instance.new("TextLabel")
            SecTitle.Size = UDim2.new(1, -30, 1, 0)
            SecTitle.Position = UDim2.new(0, 26, 0, 0)
            SecTitle.BackgroundTransparency = 1
            SecTitle.Text = sectionName
            SecTitle.TextColor3 = Theme.Text
            SecTitle.Font = Enum.Font.GothamBold
            SecTitle.TextSize = 13
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left
            SecTitle.Parent = Header

            local Body = Instance.new("Frame")
            Body.Name = "Body"
            Body.Size = UDim2.new(1, 0, 0, 0)
            Body.Position = UDim2.new(0, 0, 0, 28)
            Body.BackgroundTransparency = 1
            Body.BorderSizePixel = 0
            Body.Parent = Section

            local BodyList = Instance.new("UIListLayout")
            BodyList.Padding = UDim.new(0, 4)
            BodyList.SortOrder = Enum.SortOrder.LayoutOrder
            BodyList.Parent = Body
            pad(Body, 2, 6, 8, 8)

            local open = true
            local function refreshSize()
                task.defer(function()
                    local h = BodyList.AbsoluteContentSize.Y + 14
                    if open then
                        Section.Size = UDim2.new(1, 0, 0, 28 + h)
                        Body.Size = UDim2.new(1, 0, 0, h)
                    else
                        Section.Size = UDim2.new(1, 0, 0, 28)
                        Body.Size = UDim2.new(1, 0, 0, 0)
                    end
                end)
            end
            BodyList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshSize)

            Header.MouseButton1Click:Connect(function()
                open = not open
                Arrow.Text = open and "▾" or "▸"
                refreshSize()
            end)

            local Sec = { Frame = Section, Body = Body, _order = 0 }

            local function nextOrder()
                Sec._order = Sec._order + 1
                return Sec._order
            end

            -- ───────────── TOGGLE (rounded) ─────────────
            function Sec:AddToggle(opts)
                opts = opts or {}
                local flag = opts.Flag or opts.Name or "toggle"
                local default = opts.Default or false
                local callback = opts.Callback or function() end

                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, 0, 0, 28)
                Row.BackgroundTransparency = 1
                Row.LayoutOrder = nextOrder()
                Row.Parent = Body

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = opts.Name or "Toggle"
                Label.TextColor3 = Theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                -- Rounded pill toggle
                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(0, 40, 0, 20)
                Track.Position = UDim2.new(1, -40, 0.5, -10)
                Track.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
                Track.BorderSizePixel = 0
                Track.Parent = Row
                corner(Track, 10)

                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 16, 0, 16)
                Knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Knob.BackgroundColor3 = Theme.Text
                Knob.BorderSizePixel = 0
                Knob.Parent = Track
                corner(Knob, 8)

                local state = default
                local Hit = Instance.new("TextButton")
                Hit.Size = UDim2.new(1, 0, 1, 0)
                Hit.BackgroundTransparency = 1
                Hit.Text = ""
                Hit.Parent = Track

                Hit.MouseButton1Click:Connect(function()
                    state = not state
                    tween(Track, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.15)
                    tween(Knob, { Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }, 0.15)
                    callback(state)
                end)

                refreshSize()
                return {
                    Set = function(_, v)
                        state = v and true or false
                        Track.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
                        Knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                        callback(state)
                    end,
                    Get = function() return state end,
                }
            end

            -- ───────────── SLIDER (rounded) ─────────────
            function Sec:AddSlider(opts)
                opts = opts or {}
                local min = opts.Min or 0
                local max = opts.Max or 100
                local default = opts.Default or min
                local callback = opts.Callback or function() end
                local suffix = opts.Suffix or ""

                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, 0, 0, 42)
                Row.BackgroundTransparency = 1
                Row.LayoutOrder = nextOrder()
                Row.Parent = Body

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 0, 18)
                Label.BackgroundTransparency = 1
                Label.Text = opts.Name or "Slider"
                Label.TextColor3 = Theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0.4, 0, 0, 18)
                ValueLabel.Position = UDim2.new(0.6, 0, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default) .. suffix
                ValueLabel.TextColor3 = Theme.TextDim
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextSize = 12
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = Row

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 8)
                Track.Position = UDim2.new(0, 0, 0, 26)
                Track.BackgroundColor3 = Theme.ToggleOff
                Track.BorderSizePixel = 0
                Track.Parent = Row
                corner(Track, 4)

                local Fill = Instance.new("Frame")
                local pct = (default - min) / math.max(max - min, 1)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Fill.BackgroundColor3 = Theme.SliderFill
                Fill.BorderSizePixel = 0
                Fill.Parent = Track
                corner(Fill, 4)

                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 14, 0, 14)
                Knob.Position = UDim2.new(pct, -7, 0.5, -7)
                Knob.BackgroundColor3 = Theme.Text
                Knob.BorderSizePixel = 0
                Knob.ZIndex = 2
                Knob.Parent = Track
                corner(Knob, 7)

                local value = default
                local sliding = false

                local function setFromX(x)
                    local rel = math.clamp((x - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + rel * (max - min) + 0.5)
                    local p = (value - min) / math.max(max - min, 1)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Knob.Position = UDim2.new(p, -7, 0.5, -7)
                    ValueLabel.Text = tostring(value) .. suffix
                    callback(value)
                end

                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        setFromX(input.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        setFromX(input.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

                refreshSize()
                return {
                    Set = function(_, v)
                        value = math.clamp(v, min, max)
                        local p = (value - min) / math.max(max - min, 1)
                        Fill.Size = UDim2.new(p, 0, 1, 0)
                        Knob.Position = UDim2.new(p, -7, 0.5, -7)
                        ValueLabel.Text = tostring(value) .. suffix
                        callback(value)
                    end,
                    Get = function() return value end,
                }
            end

            -- ───────────── BUTTON ─────────────
            function Sec:AddButton(opts)
                opts = opts or {}
                local callback = opts.Callback or function() end

                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, 0, 0, 28)
                Row.BackgroundTransparency = 1
                Row.LayoutOrder = nextOrder()
                Row.Parent = Body

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -80, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = opts.Name or "Button"
                Label.TextColor3 = Theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(0, 70, 0, 24)
                Btn.Position = UDim2.new(1, -70, 0.5, -12)
                Btn.BackgroundColor3 = Theme.Accent
                Btn.Text = opts.ButtonText or "Click"
                Btn.TextColor3 = Theme.Text
                Btn.Font = Enum.Font.GothamBold
                Btn.TextSize = 11
                Btn.Parent = Row
                corner(Btn, 6)

                Btn.MouseButton1Click:Connect(function()
                    callback()
                end)
                Btn.MouseEnter:Connect(function()
                    tween(Btn, { BackgroundColor3 = Theme.AccentLight }, 0.12)
                end)
                Btn.MouseLeave:Connect(function()
                    tween(Btn, { BackgroundColor3 = Theme.Accent }, 0.12)
                end)

                refreshSize()
                return Btn
            end

            -- ───────────── DROPDOWN (single / multi) ─────────────
            function Sec:AddDropdown(opts)
                opts = opts or {}
                local options = opts.Options or {}
                local multi = opts.Multi or false
                local default = opts.Default
                local callback = opts.Callback or function() end

                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, 0, 0, 28)
                Row.BackgroundTransparency = 1
                Row.LayoutOrder = nextOrder()
                Row.ClipsDescendants = false
                Row.Parent = Body
                Row.ZIndex = 5

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.45, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = opts.Name or "Dropdown"
                Label.TextColor3 = Theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 5
                Label.Parent = Row

                local DropBtn = Instance.new("TextButton")
                DropBtn.Size = UDim2.new(0.55, 0, 0, 24)
                DropBtn.Position = UDim2.new(0.45, 0, 0.5, -12)
                DropBtn.BackgroundColor3 = Theme.Background3
                DropBtn.Text = ""
                DropBtn.ZIndex = 5
                DropBtn.Parent = Row
                corner(DropBtn, 6)
                stroke(DropBtn, Theme.Stroke, 1)

                local DropText = Instance.new("TextLabel")
                DropText.Size = UDim2.new(1, -22, 1, 0)
                DropText.Position = UDim2.new(0, 8, 0, 0)
                DropText.BackgroundTransparency = 1
                DropText.TextColor3 = Theme.TextDim
                DropText.Font = Enum.Font.Gotham
                DropText.TextSize = 11
                DropText.TextXAlignment = Enum.TextXAlignment.Left
                DropText.TextTruncate = Enum.TextTruncate.AtEnd
                DropText.ZIndex = 6
                DropText.Parent = DropBtn

                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 16, 1, 0)
                Arrow.Position = UDim2.new(1, -18, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "▾"
                Arrow.TextColor3 = Theme.TextDim
                Arrow.Font = Enum.Font.GothamBold
                Arrow.TextSize = 12
                Arrow.ZIndex = 6
                Arrow.Parent = DropBtn

                local selected = {}
                if multi then
                    if type(default) == "table" then
                        for _, v in ipairs(default) do selected[v] = true end
                    end
                else
                    if default then selected[default] = true end
                end

                local function updateText()
                    local list = {}
                    for k, v in pairs(selected) do if v then table.insert(list, k) end end
                    if #list == 0 then
                        DropText.Text = "None"
                    else
                        DropText.Text = table.concat(list, ", ")
                    end
                end
                updateText()

                local ListFrame = Instance.new("Frame")
                ListFrame.Size = UDim2.new(0.55, 0, 0, 0)
                ListFrame.Position = UDim2.new(0.45, 0, 1, 2)
                ListFrame.BackgroundColor3 = Theme.Background3
                ListFrame.BorderSizePixel = 0
                ListFrame.Visible = false
                ListFrame.ClipsDescendants = true
                ListFrame.ZIndex = 50
                ListFrame.Parent = Row
                corner(ListFrame, 6)
                stroke(ListFrame, Theme.Stroke, 1)

                local ListScroll = Instance.new("ScrollingFrame")
                ListScroll.Size = UDim2.new(1, 0, 1, 0)
                ListScroll.BackgroundTransparency = 1
                ListScroll.BorderSizePixel = 0
                ListScroll.ScrollBarThickness = 2
                ListScroll.ZIndex = 51
                ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
                ListScroll.Parent = ListFrame

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Parent = ListScroll

                local open = false
                local function toggleList()
                    open = not open
                    ListFrame.Visible = open
                    Arrow.Text = open and "▴" or "▾"
                    if open then
                        local h = math.min(#options * 24, 120)
                        ListFrame.Size = UDim2.new(0.55, 0, 0, h)
                    else
                        ListFrame.Size = UDim2.new(0.55, 0, 0, 0)
                    end
                end

                for i, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 24)
                    OptBtn.BackgroundColor3 = selected[opt] and Theme.Accent or Theme.Background3
                    OptBtn.Text = "  " .. tostring(opt)
                    OptBtn.TextColor3 = Theme.Text
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 11
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.LayoutOrder = i
                    OptBtn.ZIndex = 52
                    OptBtn.Parent = ListScroll

                    OptBtn.MouseButton1Click:Connect(function()
                        if multi then
                            selected[opt] = not selected[opt]
                            OptBtn.BackgroundColor3 = selected[opt] and Theme.Accent or Theme.Background3
                            updateText()
                            local list = {}
                            for k, v in pairs(selected) do if v then table.insert(list, k) end end
                            callback(list)
                        else
                            for k in pairs(selected) do selected[k] = nil end
                            selected[opt] = true
                            for _, c in ipairs(ListScroll:GetChildren()) do
                                if c:IsA("TextButton") then
                                    c.BackgroundColor3 = Theme.Background3
                                end
                            end
                            OptBtn.BackgroundColor3 = Theme.Accent
                            updateText()
                            toggleList()
                            callback(opt)
                        end
                    end)
                end

                DropBtn.MouseButton1Click:Connect(toggleList)

                refreshSize()
                return {
                    Set = function(_, v)
                        if multi and type(v) == "table" then
                            selected = {}
                            for _, x in ipairs(v) do selected[x] = true end
                        else
                            selected = { [v] = true }
                        end
                        updateText()
                    end,
                    Get = function()
                        if multi then
                            local list = {}
                            for k, v in pairs(selected) do if v then table.insert(list, k) end end
                            return list
                        else
                            for k, v in pairs(selected) do if v then return k end end
                            return nil
                        end
                    end,
                }
            end

            -- ───────────── LABEL ─────────────
            function Sec:AddLabel(text)
                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, 0, 0, 22)
                Row.BackgroundTransparency = 1
                Row.LayoutOrder = nextOrder()
                Row.Parent = Body

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text or ""
                Label.TextColor3 = Theme.TextDim
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = Row

                refreshSize()
                return Label
            end

            refreshSize()
            return Sec
        end

        return Tab
    end

    -- Search filter
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(SearchBox.Text or "")
        if not Window.CurrentTab then return end
        for _, child in ipairs(Window.CurrentTab.Page:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("Body") then
                if q == "" then
                    child.Visible = true
                else
                    local name = string.lower(child.Name)
                    local match = string.find(name, q, 1, true)
                    if not match then
                        for _, row in ipairs(child.Body:GetChildren()) do
                            if row:IsA("Frame") then
                                for _, d in ipairs(row:GetDescendants()) do
                                    if d:IsA("TextLabel") and string.find(string.lower(d.Text or ""), q, 1, true) then
                                        match = true
                                        break
                                    end
                                end
                            end
                            if match then break end
                        end
                    end
                    child.Visible = match and true or false
                end
            end
        end
    end)

    return Window
end

return Rubi
