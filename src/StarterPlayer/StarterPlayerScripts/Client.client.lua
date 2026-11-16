local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local remote = ReplicatedStorage:WaitForChild("GameAction")
local state = ReplicatedStorage:WaitForChild("GameState")
local mouse = player:GetMouse()

local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "CaptureUI", false, true
gui.Parent = player:WaitForChild("PlayerGui")
local navy = Color3.fromRGB(17, 24, 47)
local panel = Color3.fromRGB(27, 37, 68)
local white = Color3.fromRGB(241, 246, 255)
local muted = Color3.fromRGB(167, 180, 204)
local yellow = Color3.fromRGB(255, 206, 89)
local function corner(object, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius); c.Parent = object
end
local function text(parent, value, size, color, font)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency, t.Text, t.TextColor3 = 1, value, color or white
    t.Font, t.TextSize, t.TextWrapped = font or Enum.Font.GothamMedium, size, true
    t.Parent = parent
    return t
end
local function button(parent, value, color)
    local b = Instance.new("TextButton")
    b.BackgroundColor3, b.Text, b.TextColor3 = color or panel, value, white
    b.Font, b.TextSize, b.AutoButtonColor = Enum.Font.GothamBold, 14, true
    corner(b, 10); b.Parent = parent
    return b
end
local function frame(parent, color)
    local f = Instance.new("Frame"); f.BackgroundColor3, f.BorderSizePixel = color or panel, 0; corner(f, 14); f.Parent = parent; return f
end
local hud = frame(gui, navy)
hud.AnchorPoint, hud.Position, hud.Size = Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 12), UDim2.new(0.7, 0, 0, 79)
local hudLimit = Instance.new("UISizeConstraint"); hudLimit.MaxSize = Vector2.new(610, 79); hudLimit.MinSize = Vector2.new(290, 79); hudLimit.Parent = hud
local score = text(hud, "PROTECCIÓN PRESIDENCIAL", 18, white, Enum.Font.GothamBlack)
score.Position, score.Size = UDim2.new(0, 8, 0, 6), UDim2.new(1, -16, 0, 26)
local status = text(hud, "Preparando partida", 13, muted)
status.Position, status.Size = UDim2.new(0, 8, 0, 34), UDim2.new(1, -16, 0, 20)
local bossStatus = text(hud, "", 12, yellow, Enum.Font.GothamBold)
bossStatus.Position, bossStatus.Size = UDim2.new(0, 8, 0, 55), UDim2.new(1, -16, 0, 18)
local menuButton = button(gui, "✦  ROLES Y TIENDA", Color3.fromRGB(82, 103, 228))
menuButton.AnchorPoint, menuButton.Position, menuButton.Size = Vector2.new(0, 1), UDim2.new(0, 16, 1, -20), UDim2.fromOffset(180, 48)
local coins = text(gui, "◆  0", 17, yellow, Enum.Font.GothamBlack)
coins.AnchorPoint, coins.Position, coins.Size = Vector2.new(1, 1), UDim2.new(1, -16, 1, -24), UDim2.fromOffset(130, 36)
coins.TextXAlignment = Enum.TextXAlignment.Right
local notice = text(gui, "", 16, white, Enum.Font.GothamBold)
notice.AnchorPoint, notice.Position, notice.Size = Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 100), UDim2.new(0.8, 0, 0, 42)
notice.TextStrokeTransparency = 0.3
local noticeId = 0
local function showNotice(message)
    noticeId += 1
    local current = noticeId
    notice.Text = message
    task.delay(4, function() if noticeId == current then notice.Text = "" end end)
end
local shade = Instance.new("Frame")
shade.BackgroundColor3, shade.BackgroundTransparency, shade.Size, shade.Visible = Color3.new(0, 0, 0), 0.35, UDim2.fromScale(1, 1), false
shade.Parent = gui
local window = frame(shade, navy)
window.AnchorPoint, window.Position, window.Size = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5), UDim2.new(0.9, 0, 0.8, 0)
local limit = Instance.new("UISizeConstraint"); limit.MaxSize = Vector2.new(650, 540); limit.Parent = window
local title = text(window, "ROLES Y EQUIPO", 24, white, Enum.Font.GothamBlack)
title.Position, title.Size, title.TextXAlignment = UDim2.fromOffset(22, 14), UDim2.new(1, -80, 0, 32), Enum.TextXAlignment.Left
local close = button(window, "✕", panel)
close.Position, close.Size, close.AnchorPoint = UDim2.new(1, -16, 0, 14), UDim2.fromOffset(38, 38), Vector2.new(1, 0)
close.Activated:Connect(function() shade.Visible = false end)
menuButton.Activated:Connect(function() shade.Visible = true end)
local scroll = Instance.new("ScrollingFrame")
scroll.BackgroundTransparency, scroll.BorderSizePixel = 1, 0
scroll.Position, scroll.Size = UDim2.fromOffset(20, 105), UDim2.new(1, -40, 1, -120)
scroll.ScrollBarThickness, scroll.AutomaticCanvasSize, scroll.CanvasSize = 4, Enum.AutomaticSize.Y, UDim2.new()
scroll.Parent = window
local layout = Instance.new("UIListLayout")
layout.Padding, layout.SortOrder = UDim.new(0, 8), Enum.SortOrder.LayoutOrder
layout.Parent = scroll
local function heading(value, order)
    local t = text(scroll, value, 15, muted, Enum.Font.GothamBold)
    t.LayoutOrder, t.Size, t.TextXAlignment = order, UDim2.new(1, -8, 0, 26), Enum.TextXAlignment.Left
end
heading("ROLES · ELIGE EN EL LOBBY", 1)
local roleButtons = {}
local function updateRoles()
    local selected = player:GetAttribute("Role")
    for name, b in pairs(roleButtons) do
        local info = Config.Roles[name]
        b.Text = info.label .. "  ·  " .. info.side .. (name == selected and "  ✓" or "") .. "\n" .. info.description
        b.BackgroundColor3 = name == selected and Color3.fromRGB(62, 89, 170) or panel
    end
end
for index, name in ipairs(Config.RoleOrder) do
    local b = button(scroll, "", panel)
    b.Size, b.LayoutOrder, b.TextSize, b.TextWrapped = UDim2.new(1, -8, 0, 55), index + 1, 12, true
    roleButtons[name] = b
    b.Activated:Connect(function() remote:FireServer("Role", name) end)
end
player:GetAttributeChangedSignal("Role"):Connect(updateRoles)
updateRoles()
heading("ARMAS · ELIGE TU ESTILO", 20)
local weaponButtons = {}
local descriptions = {Blaster = "Equilibrada", Rapida = "Alta cadencia", Pesada = "Daño potente"}
for index, name in ipairs({"Blaster", "Rapida", "Pesada"}) do
    local b = button(scroll, name .. "   ·   " .. descriptions[name], panel)
    b.Size, b.LayoutOrder = UDim2.new(1, -8, 0, 42), index + 20
    weaponButtons[name] = b
    b.Activated:Connect(function() remote:FireServer("Weapon", name) end)
end
heading("ASPECTOS · SOLO COSMÉTICOS", 30)
local skinButtons = {}
for index, name in ipairs(Config.SkinOrder) do
    local b = button(scroll, name, panel)
    b.Size, b.LayoutOrder = UDim2.new(1, -8, 0, 42), index + 30
    skinButtons[name] = b
    b.Activated:Connect(function()
        local skin = Config.Skins[name]
        local passId = skin.pass and Config.Passes[skin.pass] or 0
        if skin.pass == "Estelar" and passId == 0 then passId = Config.GamePassId end
        if passId > 0 and not skinButtons[name]:GetAttribute("Owned") then
            MarketplaceService:PromptGamePassPurchase(player, passId)
        else remote:FireServer("Skin", name) end
    end)
end
local info = text(scroll, "Los pases son opcionales y solo cambian tu aspecto.", 12, muted)
info.LayoutOrder, info.Size = 45, UDim2.new(1, -8, 0, 42)
heading("PROGRESO Y RECOMPENSAS", 50)
local progressText = text(scroll, "Cargando progreso...", 14, white)
progressText.LayoutOrder, progressText.Size = 51, UDim2.new(1, -8, 0, 60)
local dailyButton = button(scroll, "RECOGER REGALO DIARIO", Color3.fromRGB(59, 119, 123))
dailyButton.LayoutOrder, dailyButton.Size = 52, UDim2.new(1, -8, 0, 48)
dailyButton.Activated:Connect(function() remote:FireServer("Daily", "claim") end)
local missionButton = button(scroll, "MISIÓN DIARIA", Color3.fromRGB(59, 119, 123))
missionButton.LayoutOrder, missionButton.Size = 53, UDim2.new(1, -8, 0, 48)
missionButton.Activated:Connect(function() remote:FireServer("Mission", "claim") end)
heading("VOTA EL PRÓXIMO MAPA", 70)
local mapButtons, selectedVote = {}, nil
for index, name in ipairs(Config.MapOrder) do
    local b = button(scroll, "", panel)
    b.Size, b.LayoutOrder, b.TextSize, b.TextWrapped = UDim2.new(1, -8, 0, 60), 70 + index, 12, true
    mapButtons[name] = b
    b.Activated:Connect(function()
        if state:GetAttribute("Phase") == "Lobby" then selectedVote = name end
        remote:FireServer("Vote", name)
    end)
end
local mapInfo = text(scroll, "Vota durante el lobby. En caso de empate, el mapa se elige al azar.", 12, muted)
mapInfo.LayoutOrder, mapInfo.Size = 74, UDim2.new(1, -8, 0, 48)
heading("CÓMO JUGAR", 90)
local guide = text(scroll, "1. Elige tu rol y arma en el lobby.\n\n2. Vota un mapa y espera a que comience la ronda.\n\n3. La defensa protege al presidente y al vicepresidente hasta que termine el tiempo.\n\n4. Los atacantes ganan si eliminan a cualquiera de los líderes.\n\n5. El médico puede curar aliados cercanos. Las demás bajas reaparecen.\n\n6. Juega para ganar monedas y experiencia; revisa tus recompensas diarias.", 14, white)
guide.LayoutOrder, guide.Size, guide.TextYAlignment = 91, UDim2.new(1, -8, 0, 300), Enum.TextYAlignment.Top
local tabNames = {"ROLES", "ARMAS", "TIENDA", "PROGRESO", "MAPAS", "GUÍA"}
local tabs = {}
for index, name in ipairs(tabNames) do
    local b = button(window, name, panel)
    b.TextSize = 10
    b.Position, b.Size = UDim2.new((index - 1) / #tabNames, 6, 0, 59), UDim2.new(1 / #tabNames, -9, 0, 34)
    tabs[index] = b
end
local function switchTab(index)
    for i, b in ipairs(tabs) do b.BackgroundColor3 = i == index and Color3.fromRGB(62, 89, 170) or panel end
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("GuiObject") then
            local order = child.LayoutOrder
            local group = order < 20 and 1 or order < 30 and 2 or order < 50 and 3 or order < 70 and 4 or order < 90 and 5 or 6
            child.Visible = group == index
        end
    end
    scroll.CanvasPosition = Vector2.new(0, 0)
end
for index, b in ipairs(tabs) do b.Activated:Connect(function() switchTab(index) end) end
switchTab(1)
local function updateData(d)
    if type(d) ~= "table" then return end
    coins.Text = "◆  " .. tostring(d.coins or 0)
    for name, b in pairs(weaponButtons) do
        local selected = d.weapon == name
        b.Text = name .. "   ·   " .. descriptions[name] .. (selected and "   ✓" or "")
        b.BackgroundColor3 = selected and Color3.fromRGB(62, 89, 170) or panel
    end
    for name, b in pairs(skinButtons) do
        local owned = d.owned and d.owned[name]
        local selected = d.skin == name
        b:SetAttribute("Owned", owned == true)
        local skin = Config.Skins[name]
        local suffix
        if selected then suffix = "EQUIPADO ✓"
        elseif owned then suffix = "EQUIPAR"
        elseif skin.pass then suffix = d.passes and d.passes[skin.pass] and "PASE OPCIONAL" or "PRÓXIMAMENTE"
        elseif skin.level then suffix = "NIVEL " .. skin.level
        else suffix = tostring(skin.price) .. " MONEDAS" end
        b.Text = name .. "   ·   " .. suffix
        b.BackgroundColor3 = selected and Color3.fromRGB(62, 89, 170) or panel
    end
    progressText.Text = "Nivel " .. tostring(d.level or 1) .. "   ·   " .. tostring((d.xp or 0) % 100) .. "/100 XP\n" .. tostring(d.rounds or 0) .. " partidas   ·   " .. tostring(d.wins or 0) .. " victorias"
    dailyButton.Text = d.dailyClaimed and "REGALO DIARIO RECOGIDO" or ("REGALO DIARIO  ·  +" .. Config.DailyLoginCoins .. " MONEDAS")
    missionButton.Text = d.missionClaimed and "MISIÓN DIARIA COMPLETADA" or ("JUEGA " .. Config.DailyMissionRounds .. " RONDAS  ·  " .. math.min(d.dailyRounds or 0, Config.DailyMissionRounds) .. "/" .. Config.DailyMissionRounds .. "  ·  +" .. Config.DailyMissionCoins)
end
remote.OnClientEvent:Connect(function(action, value)
    if action == "Data" then updateData(value) elseif action == "Notice" then showNotice(value) end
end)
local healButton = button(gui, "+ CURAR ALIADOS", Color3.fromRGB(47, 153, 107))
healButton.AnchorPoint, healButton.Position, healButton.Size = Vector2.new(0, 1), UDim2.new(0, 16, 1, -76), UDim2.fromOffset(180, 42)
healButton.Activated:Connect(function() remote:FireServer("Heal") end)
local lastPhase
local function updateState()
    local currentPhase = state:GetAttribute("Phase")
    if currentPhase == "Lobby" and lastPhase ~= "Lobby" then selectedVote = nil end
    lastPhase = currentPhase
    for name, b in pairs(mapButtons) do
        local map = Config.Maps[name]
        b.Text = map.label .. "   ·   " .. tostring(state:GetAttribute("Votes_" .. name) or 0) .. " votos" .. (selectedVote == name and "  ✓" or "") .. "\n" .. map.description
        b.BackgroundColor3 = selectedVote == name and Color3.fromRGB(62, 89, 170) or panel
    end
    local seconds = state:GetAttribute("Time") or 0
    local role = Config.Roles[player:GetAttribute("Role")]
    score.Text = "PRES: " .. tostring(state:GetAttribute("President") or "—") .. "   ·   VP: " .. tostring(state:GetAttribute("Vice") or "—")
    status.Text = (state:GetAttribute("Phase") or "Preparando") .. "   ·   " .. string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60) .. "   ·   " .. (role and role.label or "Lobby")
    local map = Config.Maps[state:GetAttribute("Map")]
    bossStatus.Text = (map and map.label .. " · " or "") .. (state:GetAttribute("Message") or "")
    healButton.Visible = player:GetAttribute("Role") == "Medico" and state:GetAttribute("Phase") == "Partida"
end
state.AttributeChanged:Connect(updateState)
player:GetAttributeChangedSignal("Role"):Connect(updateState)
updateState()
local watched = {}
local function watchTool(tool)
    if not tool:IsA("Tool") or not Config.Weapons[tool.Name] or watched[tool] then return end
    watched[tool] = true
    tool.Activated:Connect(function() remote:FireServer("Shoot", mouse.Hit.Position) end)
    tool.Destroying:Connect(function() watched[tool] = nil end)
end
local function watchContainer(container)
    for _, child in ipairs(container:GetChildren()) do watchTool(child) end
    container.ChildAdded:Connect(watchTool)
end
watchContainer(player:WaitForChild("Backpack"))
player.CharacterAdded:Connect(watchContainer)
if player.Character then watchContainer(player.Character) end

local loading = Instance.new("Frame")
loading.Name, loading.Size, loading.BackgroundColor3, loading.BorderSizePixel = "Loading", UDim2.fromScale(1, 1), navy, 0
loading.Parent = gui
local eyebrow = text(loading, "UNA MISIÓN · MUCHOS ROLES", 14, Color3.fromRGB(112, 198, 255), Enum.Font.GothamBold)
eyebrow.AnchorPoint, eyebrow.Position, eyebrow.Size = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, -74), UDim2.new(0.9, 0, 0, 25)
local logo = text(loading, "PROTECCIÓN\nPRESIDENCIAL", 36, white, Enum.Font.GothamBlack)
logo.AnchorPoint, logo.Position, logo.Size = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.48), UDim2.new(0.9, 0, 0, 110)
local tagline = text(loading, "Protege a los líderes o ataca antes de que termine el tiempo.", 15, muted)
tagline.AnchorPoint, tagline.Position, tagline.Size = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 72), UDim2.new(0.9, 0, 0, 35)
local bar = frame(loading, panel)
bar.AnchorPoint, bar.Position, bar.Size = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 115), UDim2.fromOffset(200, 6)
local fill = frame(bar, yellow); fill.Size = UDim2.fromScale(0, 1)
TweenService:Create(fill, TweenInfo.new(2), {Size = UDim2.fromScale(1, 1)}):Play()
task.delay(2.3, function() loading:Destroy(); remote:FireServer("Sync", "now") end)
