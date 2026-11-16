local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local Rules = require(ReplicatedStorage:WaitForChild("Rules"))
local Progress = require(ReplicatedStorage:WaitForChild("Progress"))
local ProfileLease = require(ReplicatedStorage:WaitForChild("ProfileLease"))
local store = DataStoreService:GetDataStore("CaptureBoss_v1") -- Preserve existing cosmetic progress.
local remote = Instance.new("RemoteEvent")
remote.Name, remote.Parent = "GameAction", ReplicatedStorage
local state = Instance.new("Folder")
state.Name, state.Parent = "GameState", ReplicatedStorage
for key, value in pairs({Phase = "Lobby", Time = 0, President = "Por asignar", Vice = "Por asignar", Message = "Esperando jugadores", Result = "", Map = "Palacio"}) do state:SetAttribute(key, value) end

local function part(parent, name, size, cf, color, material)
    local p = Instance.new("Part")
    p.Name, p.Size, p.CFrame, p.Color = name, size, cf, color
    p.Material, p.Anchored = material or Enum.Material.SmoothPlastic, true
    p.TopSurface, p.BottomSurface, p.Parent = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth, parent
    return p
end
local function label(parent, value, color)
    local gui = Instance.new("BillboardGui")
    gui.Size, gui.StudsOffset, gui.AlwaysOnTop, gui.Parent = UDim2.fromOffset(230, 44), Vector3.new(0, 5, 0), true, parent
    local t = Instance.new("TextLabel")
    t.Size, t.BackgroundTransparency, t.Text, t.TextColor3 = UDim2.fromScale(1, 1), 1, value, color
    t.TextStrokeTransparency, t.Font, t.TextScaled, t.Parent = 0.2, Enum.Font.GothamBlack, true, gui
end
local world = Instance.new("Folder")
world.Name, world.Parent = "PresidentialWorld", workspace
workspace.FallenPartsDestroyHeight = -80
local lighting = game:GetService("Lighting")
lighting.ClockTime, lighting.Brightness = 15, 2
lighting.Ambient, lighting.OutdoorAmbient = Color3.fromRGB(105, 110, 135), Color3.fromRGB(140, 148, 168)
local dark, concrete = Color3.fromRGB(28, 36, 56), Color3.fromRGB(83, 91, 105)
local lobby = Vector3.new(0, 9, 290)
part(world, "LobbyFloor", Vector3.new(115, 2, 85), CFrame.new(0, 0, 290), dark, Enum.Material.Slate)
part(world, "LobbyCenter", Vector3.new(60, 1, 40), CFrame.new(0, 1.5, 290), Color3.fromRGB(43, 57, 91), Enum.Material.Metal)
local sign = part(world, "LobbySign", Vector3.new(32, 12, 2), CFrame.new(0, 9, 253), Color3.fromRGB(26, 38, 70), Enum.Material.Metal)
label(sign, "PROTECCIÓN PRESIDENCIAL", Color3.fromRGB(255, 213, 91))
for _, x in ipairs({-48, 48}) do for _, z in ipairs({257, 323}) do
    part(world, "LobbyPillar", Vector3.new(4, 20, 4), CFrame.new(x, 10, z), Color3.fromRGB(79, 212, 255), Enum.Material.Neon)
end end
local arena
local function buildMap(mapName)
    if arena then arena:Destroy() end
    arena = Instance.new("Folder"); arena.Name, arena.Parent = "Arena", world
    local urban = mapName == "Ciudad"
    local embassy = mapName == "Embajada"
    local floorColor = urban and Color3.fromRGB(47, 50, 61) or embassy and Color3.fromRGB(107, 100, 85) or Color3.fromRGB(49, 57, 68)
    local palaceColor = embassy and Color3.fromRGB(211, 193, 157) or urban and Color3.fromRGB(145, 153, 170) or Color3.fromRGB(187, 191, 191)
    part(arena, "Floor", Vector3.new(340, 2, 220), CFrame.new(0, 0, 0), floorColor, Enum.Material.Concrete)
    for _, x in ipairs({-170, 170}) do part(arena, "Boundary", Vector3.new(4, 30, 220), CFrame.new(x, 15, 0), dark, Enum.Material.Metal) end
    for _, z in ipairs({-110, 110}) do part(arena, "Boundary", Vector3.new(340, 30, 4), CFrame.new(0, 15, z), dark, Enum.Material.Metal) end
    part(arena, "SafeFloor", Vector3.new(86, 2, 94), CFrame.new(-112, 2, 0), palaceColor, Enum.Material.Marble)
    part(arena, "SafeRoof", Vector3.new(86, 3, 94), CFrame.new(-112, 27, 0), palaceColor, Enum.Material.Concrete)
    for _, x in ipairs({-150, -74}) do for _, z in ipairs({-40, 40}) do
        part(arena, "SafeColumn", Vector3.new(5, 24, 5), CFrame.new(x, 15, z), Color3.fromRGB(218, 220, 218), Enum.Material.Marble)
    end end
    local palaceSign = part(arena, "SafeSign", Vector3.new(20, 2, 1), CFrame.new(-75, 23, 0), Color3.fromRGB(255, 209, 90), Enum.Material.Neon)
    label(palaceSign, string.upper(Config.Maps[mapName].label), Color3.fromRGB(255, 230, 140))
    part(arena, "AttackBase", Vector3.new(60, 2, 74), CFrame.new(135, 2, 0), Color3.fromRGB(116, 44, 53), Enum.Material.Metal)
    local attackSign = part(arena, "AttackSign", Vector3.new(12, 2, 2), CFrame.new(145, 13, 0), Color3.fromRGB(255, 85, 95), Enum.Material.Neon)
    label(attackSign, "BASE ATACANTE", Color3.fromRGB(255, 170, 170))
    if urban then
        for _, x in ipairs({-35, 25, 85}) do for _, z in ipairs({-70, 70}) do
            part(arena, "Building", Vector3.new(27, 28, 28), CFrame.new(x, 15, z), Color3.fromRGB(82, 94, 114), Enum.Material.Concrete)
            part(arena, "Windows", Vector3.new(1, 12, 18), CFrame.new(x - 14, 19, z), Color3.fromRGB(94, 196, 235), Enum.Material.Neon)
        end end
        for _, x in ipairs({-25, 30, 75}) do part(arena, "CarCover", Vector3.new(16, 5, 9), CFrame.new(x, 3.5, 0), Color3.fromRGB(42, 85, 119), Enum.Material.Metal) end
    elseif embassy then
        for _, x in ipairs({-42, 10, 62}) do for _, z in ipairs({-55, 0, 55}) do
            part(arena, "Planter", Vector3.new(12, 7, 20), CFrame.new(x, 4.5, z), Color3.fromRGB(150, 139, 115), Enum.Material.Concrete)
            part(arena, "Hedge", Vector3.new(10, 4, 17), CFrame.new(x, 10, z), Color3.fromRGB(53, 117, 79), Enum.Material.Grass)
        end end
    else
        for _, x in ipairs({-40, 0, 40, 80}) do for _, z in ipairs({-70, -30, 30, 70}) do
            local height = math.abs(z) == 30 and 9 or 14
            part(arena, "Cover", Vector3.new(10, height, 18), CFrame.new(x, height / 2 + 1, z), concrete, Enum.Material.Metal)
        end end
        for _, z in ipairs({-75, 75}) do part(arena, "Barricade", Vector3.new(24, 5, 4), CFrame.new(-60, 3.5, z), Color3.fromRGB(224, 179, 64), Enum.Material.Metal) end
    end
    state:SetAttribute("Map", mapName)
end
buildMap("Palacio")
local spawnPoints = {Defensa = Vector3.new(-120, 8, 0), Ataque = Vector3.new(135, 8, 0)}
for role, info in pairs(Config.Roles) do
    local team = Instance.new("Team")
    team.Name, team.TeamColor, team.AutoAssignable, team.Parent = role, BrickColor.new(info.color), false, Teams
end
local waitingTeam = Instance.new("Team")
waitingTeam.Name, waitingTeam.TeamColor, waitingTeam.AutoAssignable, waitingTeam.Parent = "Espectadores", BrickColor.new("Medium stone grey"), false, Teams

local data, ready, participants, lastShot, lastAction, lastHeal = {}, {}, {}, {}, {}, {}
local sessions, saving, votes = {}, {}, {}
local phase, outcome, president, vice = "Lobby", nil, nil, nil
local function announce(message) remote:FireAllClients("Notice", message) end
local function tell(player, message) remote:FireClient(player, "Notice", message) end
local function setPhase(value) phase = value; state:SetAttribute("Phase", value) end
local function setRole(player, role)
    player:SetAttribute("Role", role)
    player.Team = Teams:FindFirstChild(role) or waitingTeam
    player.Neutral = false
end
local function passId(name)
    local id = Config.Passes[name] or 0
    if name == "Estelar" and id == 0 then id = Config.GamePassId end
    return id
end
local function ownsPass(player, name)
    local id = passId(name)
    if id <= 0 then return false end
    local ok, result = pcall(function() return MarketplaceService:UserOwnsGamePassAsync(player.UserId, id) end)
    return ok and result
end
local function updateStats(player)
    local d, stats = data[player], player:FindFirstChild("leaderstats")
    if not d or not stats then return end
    stats.Monedas.Value = d.coins
    stats.Nivel.Value = Progress.level(d.xp)
    stats.Victorias.Value = d.wins
end
local function sendData(player)
    local d = data[player]
    if not d then return end
    Progress.refresh(d, os.time())
    local passes = {}
    for name in pairs(Config.Passes) do passes[name] = passId(name) > 0 end
    remote:FireClient(player, "Data", {coins = d.coins, weapon = d.weapon, skin = d.skin, owned = d.owned, passes = passes,
        xp = d.xp, level = Progress.level(d.xp), rounds = d.rounds, wins = d.wins, dailyRounds = d.dailyRounds,
        dailyClaimed = d.dailyClaimed, missionClaimed = d.missionClaimed})
end
local function releaseSession(key, session)
    pcall(function()
        store:UpdateAsync(key, function(old)
            return ProfileLease.release(old, session)
        end)
    end)
end
local function save(player, release)
    while saving[player] do task.wait(0.1) end
    local d, session = data[player], sessions[player]
    if not d or not ready[player] or not session then return end
    saving[player] = true
    local copy = {coins = d.coins, weapon = d.weapon, skin = d.skin, owned = table.clone(d.owned), xp = d.xp,
        rounds = d.rounds, wins = d.wins, dailyDay = d.dailyDay, dailyRounds = d.dailyRounds,
        dailyClaimed = d.dailyClaimed, missionClaimed = d.missionClaimed}
    local ok, result
    for attempt = 1, (release and 3 or 1) do
        ok, result = pcall(function()
            return store:UpdateAsync("p_" .. player.UserId, function(old)
                return ProfileLease.save(old, copy, session, os.time(), release)
            end)
        end)
        if ok then break end
        if release and attempt < 3 then task.wait(1) end
    end
    saving[player] = nil
    if not ok then warn("Could not save player data: " .. tostring(result))
    elseif result == nil then
        ready[player] = false
        if player.Parent then tell(player, "La sesión de datos expiró; vuelve a entrar para guardar progreso.") end
    end
end
local function applySkin(player)
    local char, d = player.Character, data[player]
    if not char or not d then return end
    for _, name in ipairs({"CaptureGlow", "CaptureEffects"}) do
        local existing = char:FindFirstChild(name)
        if existing then existing:Destroy() end
    end
    local oldHead = char:FindFirstChild("Head")
    if oldHead then
        for _, name in ipairs({"CaptureTrailA", "CaptureTrailB"}) do
            local attachment = oldHead:FindFirstChild(name)
            if attachment then attachment:Destroy() end
        end
    end
    local skin = Config.Skins[d.skin]
    if d.skin ~= "Clasico" and skin then
        local h = Instance.new("Highlight")
        h.Name, h.FillColor, h.OutlineColor = "CaptureGlow", skin.color, skin.color
        h.FillTransparency, h.OutlineTransparency, h.DepthMode = 0.88, 0.15, Enum.HighlightDepthMode.Occluded
        h.Parent = char
    end
    if skin and skin.pass then
        local head = char:FindFirstChild("Head")
        if not head then return end
        local effects = Instance.new("Folder"); effects.Name, effects.Parent = "CaptureEffects", char
        local halo = Instance.new("Part")
        halo.Name, halo.Size, halo.Color, halo.Material = "Halo", Vector3.new(2.5, 0.25, 2.5), skin.color, Enum.Material.Neon
        halo.Transparency, halo.CanCollide, halo.CanTouch, halo.CanQuery, halo.Massless = 0.15, false, false, false, true
        halo.CFrame, halo.Parent = head.CFrame * CFrame.new(0, 1.6, 0), effects
        local weld = Instance.new("WeldConstraint"); weld.Part0, weld.Part1, weld.Parent = head, halo, halo
        if skin.pass == "Imperial" then
            for _, x in ipairs({-0.9, 0, 0.9}) do
                local spike = Instance.new("Part")
                spike.Name, spike.Size, spike.Color, spike.Material = "CrownSpike", Vector3.new(0.35, 0.85, 0.35), skin.color, Enum.Material.Neon
                spike.CanCollide, spike.CanTouch, spike.CanQuery, spike.Massless = false, false, false, true
                spike.CFrame, spike.Parent = head.CFrame * CFrame.new(x, 2, -0.8), effects
                local link = Instance.new("WeldConstraint"); link.Part0, link.Part1, link.Parent = head, spike, spike
            end
        elseif skin.pass == "Espectro" then
            local a = Instance.new("Attachment"); a.Name, a.Position, a.Parent = "CaptureTrailA", Vector3.new(-1, 0, 0), head
            local b = Instance.new("Attachment"); b.Name, b.Position, b.Parent = "CaptureTrailB", Vector3.new(1, 0, 0), head
            local trail = Instance.new("Trail")
            trail.Attachment0, trail.Attachment1, trail.Color = a, b, ColorSequence.new(skin.color)
            trail.Lifetime, trail.LightEmission, trail.FaceCamera, trail.Parent = 0.35, 0.8, true, effects
        end
        local sparks = Instance.new("ParticleEmitter")
        sparks.Color, sparks.LightEmission = ColorSequence.new(skin.color), 0.8
        sparks.Rate, sparks.Lifetime, sparks.Speed = 5, NumberRange.new(0.5, 0.9), NumberRange.new(0.3, 0.8)
        sparks.Size, sparks.Parent = NumberSequence.new(0.18), halo
    end
end
local function giveWeapon(player)
    local backpack, d = player:FindFirstChildOfClass("Backpack"), data[player]
    if not backpack or not d then return end
    for _, container in ipairs({backpack, player.Character}) do
        if container then for _, item in ipairs(container:GetChildren()) do if item:IsA("Tool") and Config.Weapons[item.Name] then item:Destroy() end end end
    end
    if not participants[player] or (phase ~= "Preparando" and phase ~= "Partida") then return end
    local tool = Instance.new("Tool")
    tool.Name, tool.ToolTip, tool.CanBeDropped = d.weapon, "Apunta y dispara", false
    local handle = Instance.new("Part")
    handle.Name, handle.Size, handle.Color, handle.Material = "Handle", Vector3.new(1, 1, 3), Config.Weapons[d.weapon].color, Enum.Material.Metal
    handle.CanCollide, handle.Massless = false, true
    handle.Parent, tool.Parent = tool, backpack
end
local function teleport(player)
    local character, role = player.Character, participants[player]
    if not character then return end
    local target = role and (phase == "Preparando" or phase == "Partida") and spawnPoints[Config.Roles[role].side] or lobby
    character:PivotTo(CFrame.new(target + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))))
end
local function onCharacter(player, char)
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum or not player.Parent or player.Character ~= char then return end
    hum.Died:Connect(function()
        if phase == "Partida" and participants[player] and player.Character == char and not outcome and (player == president or player == vice) then
            outcome = "Ataque"
            state:SetAttribute("Message", (player == president and "El presidente" or "El vicepresidente") .. " ha caído")
        end
    end)
    local role = participants[player]
    if role and (phase == "Preparando" or phase == "Partida") then hum.MaxHealth = Config.Roles[role].health; hum.Health = hum.MaxHealth end
    task.wait(0.15)
    if player.Parent and player.Character == char then teleport(player); applySkin(player); giveWeapon(player) end
end
local function loadPlayer(player)
    setRole(player, "Guardia")
    local key, session = "p_" .. player.UserId, HttpService:GenerateGUID(false)
    local ok, saved = pcall(function()
        return store:UpdateAsync(key, function(old)
            return ProfileLease.acquire(old, session, os.time())
        end)
    end)
    local acquired = ok and type(saved) == "table" and type(saved._lease) == "table" and saved._lease.id == session
    if not player.Parent then if acquired then releaseSession(key, session) end; return end
    ready[player] = acquired
    if acquired then sessions[player] = session end
    saved = acquired and saved or {}
    local owned = {Clasico = true}
    if type(saved.owned) == "table" then
        for name, value in pairs(saved.owned) do if value == true and Config.Skins[name] and not Config.Skins[name].pass and not Config.Skins[name].level then owned[name] = true end end
    end
    for name, skin in pairs(Config.Skins) do if skin.pass and ownsPass(player, skin.pass) then owned[name] = true end end
    if not player.Parent then if acquired then releaseSession(key, session) end; sessions[player], ready[player] = nil, nil; return end
    local function number(value, maximum)
        if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then return 0 end
        return math.clamp(math.floor(value), 0, maximum)
    end
    local coins = number(saved.coins, 100000000)
    local xp = number(saved.xp, 100000000)
    if Progress.level(xp) >= 5 then owned.Heroe = true end
    data[player] = {coins = coins, weapon = Config.Weapons[saved.weapon] and saved.weapon or "Blaster", skin = owned[saved.skin] and saved.skin or "Clasico", owned = owned,
        xp = xp, rounds = number(saved.rounds, 100000000), wins = number(saved.wins, 100000000), dailyDay = number(saved.dailyDay, 100000000),
        dailyRounds = number(saved.dailyRounds, 100000000), dailyClaimed = saved.dailyClaimed == true, missionClaimed = saved.missionClaimed == true}
    Progress.refresh(data[player], os.time())
    local leaderstats = Instance.new("Folder"); leaderstats.Name, leaderstats.Parent = "leaderstats", player
    local stat = Instance.new("IntValue"); stat.Name, stat.Value, stat.Parent = "Monedas", coins, leaderstats
    local level = Instance.new("IntValue"); level.Name, level.Value, level.Parent = "Nivel", Progress.level(xp), leaderstats
    local wins = Instance.new("IntValue"); wins.Name, wins.Value, wins.Parent = "Victorias", data[player].wins, leaderstats
    player.CharacterAdded:Connect(function(char) onCharacter(player, char) end)
    if player.Character then task.spawn(onCharacter, player, player.Character) end
    sendData(player)
    if not acquired then tell(player, "No se pudieron cargar tus datos (o están en uso); esta sesión no se guardará.") end
    if phase ~= "Lobby" then tell(player, "Estás en el lobby. Participarás en la siguiente ronda.") end
end
local function reward(player, amount)
    local d = data[player]
    if not d then return end
    d.coins += amount
    updateStats(player)
    sendData(player)
end
local function shoot(player, target)
    if phase ~= "Partida" or not participants[player] or typeof(target) ~= "Vector3" or target.X ~= target.X or target.Y ~= target.Y or target.Z ~= target.Z then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local tool = char and char:FindFirstChildOfClass("Tool")
    local weapon = tool and Config.Weapons[tool.Name]
    if not root or not humanoid or humanoid.Health <= 0 or not weapon or not data[player] or tool.Name ~= data[player].weapon then return end
    local now = os.clock()
    if now - (lastShot[player] or 0) < weapon.cooldown then return end
    lastShot[player] = now
    local origin = root.Position + Vector3.new(0, 1.5, 0)
    local direction = target - origin
    if direction.Magnitude < 0.1 or direction.Magnitude == math.huge then return end
    direction = direction.Unit * math.min(direction.Magnitude, weapon.range)
    local params = RaycastParams.new()
    params.FilterType, params.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, {char}
    local result = workspace:Raycast(origin, direction, params)
    local endpoint = result and result.Position or origin + direction
    local beam = part(world, "Shot", Vector3.new(0.18, 0.18, (endpoint - origin).Magnitude), CFrame.lookAt((origin + endpoint) / 2, endpoint), weapon.color, Enum.Material.Neon)
    beam.CanCollide, beam.CanQuery = false, false
    Debris:AddItem(beam, 0.09)
    if result then
        local model = result.Instance:FindFirstAncestorOfClass("Model")
        local victim = model and Players:GetPlayerFromCharacter(model)
        local victimHumanoid = model and model:FindFirstChildOfClass("Humanoid")
        if victim and participants[victim] and Config.Roles[participants[victim]].side ~= Config.Roles[participants[player]].side and victimHumanoid then victimHumanoid:TakeDamage(weapon.damage) end
    end
end
local function heal(player)
    if phase ~= "Partida" or participants[player] ~= "Medico" or os.clock() - (lastHeal[player] or 0) < 15 then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    lastHeal[player] = os.clock()
    local count = 0
    for ally, role in pairs(participants) do
        local ac = ally.Character
        local ar = ac and ac:FindFirstChild("HumanoidRootPart")
        local ah = ac and ac:FindFirstChildOfClass("Humanoid")
        if Config.Roles[role].side == "Defensa" and ar and ah and ah.Health > 0 and (ar.Position - root.Position).Magnitude <= 24 then
            ah.Health = math.min(ah.MaxHealth, ah.Health + 30); count += 1
        end
    end
    tell(player, "Curación aplicada a " .. count .. " aliado(s). Recarga: 15 s.")
end
local function updateVotes()
    local totals = {}
    for _, name in ipairs(Config.MapOrder) do totals[name] = 0 end
    for player, name in pairs(votes) do
        if player.Parent and totals[name] then totals[name] += 1 end
    end
    for name, count in pairs(totals) do state:SetAttribute("Votes_" .. name, count) end
    return totals
end
local function winningMap()
    local choices = Rules.topMaps(Config.MapOrder, updateVotes())
    return choices[math.random(1, #choices)]
end
remote.OnServerEvent:Connect(function(player, action, value)
    if action == "Shoot" then shoot(player, value); return end
    if action == "Heal" then heal(player); return end
    if type(action) ~= "string" or type(value) ~= "string" or #value > 32 or not data[player] then return end
    if os.clock() - (lastAction[player] or 0) < 0.2 then return end
    lastAction[player] = os.clock()
    local d = data[player]
    if action == "Role" and Config.Roles[value] then
        if phase ~= "Lobby" then tell(player, "Elige tu rol durante el lobby para la próxima ronda."); return end
        if value == "Presidente" or value == "Vicepresidente" then
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= player and other:GetAttribute("Role") == value then tell(player, "Ese puesto ya está ocupado."); return end
            end
        end
        setRole(player, value); tell(player, "Rol seleccionado: " .. Config.Roles[value].label)
    elseif action == "Weapon" and Config.Weapons[value] then
        d.weapon = value; giveWeapon(player); sendData(player); tell(player, "Arma equipada: " .. value)
    elseif action == "Vote" and Config.Maps[value] then
        if phase ~= "Lobby" then tell(player, "La votación está disponible en el lobby."); return end
        votes[player] = value; updateVotes(); tell(player, "Votaste por " .. Config.Maps[value].label)
    elseif action == "Daily" then
        if Progress.claimDaily(d, os.time(), Config.DailyLoginCoins) then
            updateStats(player); sendData(player); tell(player, "Recompensa diaria: +" .. Config.DailyLoginCoins .. " monedas")
        else sendData(player); tell(player, "Ya recogiste la recompensa de hoy.") end
    elseif action == "Mission" then
        if Progress.claimMission(d, os.time(), Config.DailyMissionRounds, Config.DailyMissionCoins) then
            updateStats(player); sendData(player); tell(player, "Misión completada: +" .. Config.DailyMissionCoins .. " monedas")
        else sendData(player); tell(player, "Completa la misión diaria o vuelve mañana.") end
    elseif action == "Skin" and Config.Skins[value] then
        local skin = Config.Skins[value]
        if skin.pass and not d.owned[value] then
            if ownsPass(player, skin.pass) then d.owned[value] = true else tell(player, "Necesitas el pase " .. skin.pass .. " para este aspecto."); return end
        elseif skin.level and not d.owned[value] then
            if Progress.level(d.xp) >= skin.level then d.owned[value] = true else tell(player, "Necesitas el nivel " .. skin.level .. "."); return end
        elseif not d.owned[value] then
            if d.coins < skin.price then tell(player, "Necesitas más monedas para este aspecto."); return end
            d.coins -= skin.price; d.owned[value] = true; updateStats(player)
        end
        d.skin = value; applySkin(player); sendData(player); tell(player, "Aspecto equipado: " .. value)
    elseif action == "Sync" then sendData(player) end
end)
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, id, purchased)
    if not purchased or not data[player] then return end
    for name, skin in pairs(Config.Skins) do
        if skin.pass and passId(skin.pass) > 0 and id == passId(skin.pass) and ownsPass(player, skin.pass) and data[player] then
            data[player].owned[name], data[player].skin = true, name
            applySkin(player); sendData(player); tell(player, "¡Aspecto " .. name .. " equipado!")
            break
        end
    end
end)
Players.PlayerAdded:Connect(loadPlayer)
for _, player in ipairs(Players:GetPlayers()) do task.spawn(loadPlayer, player) end
Players.PlayerRemoving:Connect(function(player)
    if (phase == "Partida" or phase == "Preparando") and participants[player] and (player == president or player == vice) and not outcome then
        local successor = vice
        local available = successor and successor.Parent and participants[successor] == "Vicepresidente"
        if available and phase == "Partida" then
            local char = successor.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            available = hum and hum.Health > 0
        end
        local departingRole = player == president and "Presidente" or "Vicepresidente"
        if Rules.leaderDeparture(departingRole, available) == "Promover" then
            participants[player] = nil
            president, vice = successor, nil
            participants[successor] = "Presidente"
            setRole(successor, "Presidente")
            local char = successor.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local health = hum.Health
                hum.MaxHealth = Config.Roles.Presidente.health
                hum.Health = math.min(health, hum.MaxHealth)
            end
            state:SetAttribute("President", successor.DisplayName)
            state:SetAttribute("Vice", "Vacante")
            state:SetAttribute("Message", "El vicepresidente ahora es presidente")
            announce(successor.DisplayName .. " asume la presidencia. ¡La ronda continúa!")
        else
            outcome = "Cancelada"; state:SetAttribute("Message", "Un líder salió: ronda cancelada")
        end
    end
    participants[player] = nil
    votes[player] = nil; updateVotes()
    save(player, true); data[player], ready[player], sessions[player], lastShot[player], lastAction[player], lastHeal[player] = nil, nil, nil, nil, nil, nil
end)
game:BindToClose(function()
    local pending = 0
    for _, player in ipairs(Players:GetPlayers()) do
        pending += 1
        task.spawn(function() save(player, true); pending -= 1 end)
    end
    while pending > 0 do task.wait(0.1) end
end)
task.spawn(function()
    while true do
        task.wait(60)
        for _, player in ipairs(Players:GetPlayers()) do task.spawn(save, player, false) end
    end
end)

local function alive(player)
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return player and player.Parent and participants[player] and hum and hum.Health > 0
end
local function eligible()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do if data[player] then table.insert(list, player) end end
    return list
end
while true do
    participants, president, vice, outcome = {}, nil, nil, nil
    setPhase("Lobby")
    votes = {}; updateVotes()
    state:SetAttribute("President", "Por asignar"); state:SetAttribute("Vice", "Por asignar"); state:SetAttribute("Result", "")
    for _, player in ipairs(Players:GetPlayers()) do teleport(player); giveWeapon(player) end
    while #eligible() < Config.MinimumPlayers do
        state:SetAttribute("Time", 0)
        state:SetAttribute("Message", "Esperando al menos " .. Config.MinimumPlayers .. " jugadores")
        task.wait(1)
    end
    state:SetAttribute("Message", "Elige rol, arma y aspecto en el lobby")
    local seconds = Config.Intermission
    while seconds > 0 and #eligible() >= Config.MinimumPlayers do
        state:SetAttribute("Time", seconds); task.wait(1); seconds -= 1
    end
    if #eligible() >= Config.MinimumPlayers then
        local players = eligible()
        local roster = {}
        for _, p in ipairs(players) do table.insert(roster, {id = p.UserId, role = p:GetAttribute("Role")}) end
        local assigned = Rules.assignRoles(roster, Config.Roles)
        setPhase("Preparando")
        local map = winningMap()
        buildMap(map)
        announce("Mapa elegido: " .. Config.Maps[map].label)
        for _, p in ipairs(players) do
            local role = assigned[p.UserId]
            participants[p] = role; setRole(p, role)
            if role == "Presidente" then president = p elseif role == "Vicepresidente" then vice = p end
        end
        state:SetAttribute("President", president.DisplayName); state:SetAttribute("Vice", vice.DisplayName)
        state:SetAttribute("Message", "Preparando equipos y posiciones")
        for _, p in ipairs(players) do
            if p.Parent and participants[p] then
                local loaded = pcall(function() p:LoadCharacter() end)
                if not loaded then
                    task.wait(0.2) -- Allow a departure event to update the leadership first.
                    if p.Parent and participants[p] then outcome = "Cancelada" end
                end
            end
        end
        local deadline = os.clock() + 12
        repeat task.wait(0.25) until (alive(president) and (not vice or alive(vice))) or outcome or os.clock() >= deadline
        if not alive(president) or (vice and not alive(vice)) then outcome = "Cancelada" end
        if not outcome then
            setPhase("Partida")
            state:SetAttribute("Message", "Protege a los líderes hasta que termine el tiempo")
            announce("¡Comienza la ronda! Defiende a los líderes o elimínalos.")
            local endTime = os.clock() + Config.RoundLength
            while not outcome do
                local remaining = math.max(0, math.ceil(endTime - os.clock()))
                state:SetAttribute("Time", remaining)
                if not president or not president.Parent or (vice and not vice.Parent) then outcome = "Cancelada"
                elseif not alive(president) or (vice and not alive(vice)) then outcome = Rules.result(alive(president), not vice or alive(vice), remaining)
                else
                    local attackers = 0
                    for p, role in pairs(participants) do if p.Parent and Config.Roles[role].side == "Ataque" then attackers += 1 end end
                    if attackers == 0 then outcome = "Cancelada"; state:SetAttribute("Message", "Todos los atacantes salieron: ronda cancelada")
                    else outcome = Rules.result(true, true, remaining) end
                end
                if not outcome then task.wait(0.2) end
            end
        end
        setPhase("Resultados")
        local message = outcome == "Cancelada" and "Ronda cancelada" or (outcome == "Ataque" and "¡Ganan los atacantes!" or "¡Gana la defensa!")
        state:SetAttribute("Result", message); state:SetAttribute("Message", message)
        for player, role in pairs(participants) do
            if outcome ~= "Cancelada" and player.Parent then
                local amount = Config.Roles[role].side == outcome and 100 or 45
                local d = data[player]
                if d then
                    Progress.finishRound(d, Config.Roles[role].side == outcome, os.time())
                    if Progress.level(d.xp) >= 5 then d.owned.Heroe = true end
                    reward(player, amount)
                end
                tell(player, message .. " · +" .. amount .. " monedas y experiencia")
            end
        end
        announce(message)
        task.wait(7)
    end
end
