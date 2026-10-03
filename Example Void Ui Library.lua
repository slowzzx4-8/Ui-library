--[[
    Example Void Ui Library.lua
    Load + Status tempo real + Confirm + cores (ícones / nomes)
]]

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Ui%20Library.lua"))()

-- =================
-- CreateWindow
-- =================
local Window = VoidUI:CreateWindow({
    Name = "Void Ui",
    Author = "By Slowzzx4",
    Icon = "layout-dashboard",
    Theme = "Black",
    Transparent = false,
    SideBarWidth = 160,
    ToggleKey = Enum.KeyCode.F,
    Resizable = true,
    AutoScale = true,
    User = {
        Enabled = true,
        Anonymous = false,
    },
})

-- =================
-- Open Button (quadrado preto, esquerda, mais alto)
-- =================
Window:EditOpenButton({
    Icon = "layout-dashboard",
    Size = UDim2.new(0, 48, 0, 48),
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 1.2,
    BorderColor = Color3.fromRGB(40, 40, 40),
})

-- =================
-- Status
-- =================
local StatusTab = Window:Tab({ Title = "Status", Icon = "activity", Border = true })

StatusTab:Section({ Title = "Player Status", Icon = "user" })

local PlayerStats = StatusTab:StatsFrame({
    Title = "Player Status",
    Desc = "Valores aleatórios + cores",
    Icon = "user",
    Rows = {
        {
            Label = "Username",
            Value = "...",
            Icon = "user",
            LabelColor = Color3.fromRGB(180, 180, 190),
            ValueColor = Color3.fromRGB(96, 165, 250),
            IconColor = Color3.fromRGB(96, 165, 250),
        },
        {
            Label = "Health",
            Value = "100 / 100",
            Icon = "heart",
            LabelColor = Color3.fromRGB(180, 180, 190),
            ValueColor = Color3.fromRGB(74, 222, 128),
            IconColor = Color3.fromRGB(74, 222, 128),
        },
        {
            Label = "Cash",
            Value = "$0",
            Icon = "coins",
            LabelColor = Color3.fromRGB(180, 180, 190),
            ValueColor = Color3.fromRGB(250, 204, 21),
            IconColor = Color3.fromRGB(250, 204, 21),
        },
        {
            Label = "Kills",
            Value = "0",
            Icon = "swords",
            LabelColor = Color3.fromRGB(180, 180, 190),
            ValueColor = Color3.fromRGB(248, 113, 113),
            IconColor = Color3.fromRGB(248, 113, 113),
        },
        {
            Label = "Level",
            Value = "1",
            Icon = "star",
            LabelColor = Color3.fromRGB(180, 180, 190),
            ValueColor = Color3.fromRGB(192, 132, 252),
            IconColor = Color3.fromRGB(192, 132, 252),
        },
        {
            Label = "Luck",
            Value = "0%",
            Icon = "dices",
            LabelColor = Color3.fromRGB(180, 180, 190),
            ValueColor = Color3.fromRGB(251, 146, 60),
            IconColor = Color3.fromRGB(251, 146, 60),
        },
        {
            Label = "Server Time",
            Value = "--:--:--",
            Icon = "clock",
            LabelColor = Color3.fromRGB(180, 180, 190),
            ValueColor = Color3.fromRGB(244, 114, 182),
            IconColor = Color3.fromRGB(244, 114, 182),
        },
    },
})

StatusTab:Section({ Title = "Profile", Icon = "circle-user" })

local Profile = StatusTab:ProfileFrame({
    Title = "Profile",
    Icon = "circle-user",
    Rows = {
        {
            Label = "Status",
            Value = "Online",
            Icon = "circle",
            ValueColor = Color3.fromRGB(74, 222, 128),
            IconColor = Color3.fromRGB(74, 222, 128),
        },
        {
            Label = "Region",
            Value = "BR",
            Icon = "globe",
            ValueColor = Color3.fromRGB(96, 165, 250),
            IconColor = Color3.fromRGB(96, 165, 250),
        },
        {
            Label = "Roll",
            Value = "—",
            Icon = "sparkles",
            ValueColor = Color3.fromRGB(250, 204, 21),
            IconColor = Color3.fromRGB(250, 204, 21),
        },
    },
})

-- =================
-- Confirm demo
-- =================
StatusTab:Section({ Title = "Confirm Modal", Icon = "shield-alert" })
StatusTab:Toggle({
    Title = "Auto Hop",
    Desc = "Abre confirm no centro da UI",
    Default = false,
    Confirm = {
        Title = "Auto Hop",
        Warning = "WARNING",
        Desc = "Auto Hop keeps joining new servers to find eggs that match its filters. Turn it off to stop.",
        Note = '"Steal Then Hop" and "After A Rare Spawns" stop at night.',
        CancelText = "Cancel",
        ConfirmText = "Turn On",
    },
    Callback = function(v)
        print("[Auto Hop]", v)
    end,
})

StatusTab:Button({
    Title = "Abrir Confirm manual",
    Callback = function()
        Window:Confirm({
            Title = "Auto Hop",
            Warning = "WARNING",
            Desc = "Auto Hop keeps joining new servers to find eggs that match its filters. Turn it off to stop.",
            Note = '"Steal Then Hop" and "After A Rare Spawns" stop at night.',
            CancelText = "Cancel",
            ConfirmText = "Turn On",
            OnCancel = function() print("Cancel") end,
            OnConfirm = function() print("Turn On") end,
        })
    end,
})

-- =================
-- Cores da UI (ícones + nomes)
-- =================
StatusTab:Section({ Title = "UI Colors", Icon = "palette" })
StatusTab:Button({
    Title = "Ícones verdes + texto azul",
    Callback = function()
        Window:SetIconColor("#4ade80")
        Window:SetTextColor("#60a5fa")
    end,
})
StatusTab:Button({
    Title = "Ícones rosa + texto branco",
    Callback = function()
        Window:SetIconColor("#fb7185")
        Window:SetTextColor("#FFFFFF")
    end,
})
StatusTab:Button({
    Title = "Reset cores",
    Callback = function()
        Window:SetIconColor("#c8c8c8")
        Window:SetTextColor("#FFFFFF")
    end,
})

Window:SelectTab(1)

-- =================
-- Loop aleatório
-- =================
local function rand(a, b)
    return math.random(a, b)
end

local names = { "Shadow", "Nova", "Rex", "Luna", "Kai", "Mira", "Zero", "Ash" }
local regions = { "BR", "US-East", "EU", "JP", "AU" }
local statuses = {
    { "Online",  Color3.fromRGB(74, 222, 128) },
    { "Idle",    Color3.fromRGB(250, 204, 21) },
    { "Busy",    Color3.fromRGB(251, 146, 60) },
    { "Offline", Color3.fromRGB(161, 161, 170) },
}
local rolls = { "Common", "Rare", "Epic", "Legendary", "Mythic" }
local rollColors = {
    Common    = Color3.fromRGB(200, 200, 210),
    Rare      = Color3.fromRGB(96, 165, 250),
    Epic      = Color3.fromRGB(192, 132, 252),
    Legendary = Color3.fromRGB(250, 204, 21),
    Mythic    = Color3.fromRGB(248, 113, 113),
}

task.spawn(function()
    while task.wait(0.8) do
        PlayerStats:SetRow(1, names[rand(1, #names)] .. rand(10, 99), Color3.fromRGB(96, 165, 250))

        local hp = rand(5, 100)
        local hpColor = Color3.fromRGB(74, 222, 128)
        if hp < 30 then
            hpColor = Color3.fromRGB(248, 113, 113)
        elseif hp < 60 then
            hpColor = Color3.fromRGB(250, 204, 21)
        end
        PlayerStats:SetRow(2, string.format("%d / 100", hp), hpColor)

        PlayerStats:SetRow(3, "$" .. tostring(rand(100, 99999)), Color3.fromRGB(250, 204, 21))
        PlayerStats:SetRow(4, tostring(rand(0, 250)), Color3.fromRGB(248, 113, 113))
        PlayerStats:SetRow(5, tostring(rand(1, 100)), Color3.fromRGB(192, 132, 252))

        local luck = rand(0, 100)
        local luckColor = (luck > 80) and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(251, 146, 60)
        PlayerStats:SetRow(6, luck .. "%", luckColor)

        local t = os.date("*t")
        PlayerStats:SetRow(7, string.format("%02d:%02d:%02d", t.hour, t.min, t.sec), Color3.fromRGB(244, 114, 182))

        local st = statuses[rand(1, #statuses)]
        Profile:SetRow(1, st[1], st[2])
        Profile:SetRow(2, regions[rand(1, #regions)], Color3.fromRGB(96, 165, 250))

        local roll = rolls[rand(1, #rolls)]
        Profile:SetRow(3, roll, rollColors[roll])
    end
end)

print("[Void Ui Example] OK — F abre/fecha | confirm no centro da UI")
