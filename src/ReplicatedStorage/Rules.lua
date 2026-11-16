-- Pure round rules, independent of Roblox services, for testing.
local Rules = {}
function Rules.assignRoles(roster, roles)
    if #roster < 3 then return nil end
    local assigned, used = {}, {}
    local required = {"Presidente", "Vicepresidente", "Asaltante"}
    -- Preserve selected leaders and either attacker role whenever possible.
    for _, needed in ipairs(required) do
        for _, entry in ipairs(roster) do
            local matches = entry.role == needed or (needed == "Asaltante" and entry.role == "Infiltrado")
            if matches and not used[entry.id] then
                assigned[entry.id], used[entry.id] = entry.role, true
                break
            end
        end
    end
    local has = {Presidente = false, Vicepresidente = false, Asaltante = false}
    for _, role in pairs(assigned) do
        if role == "Infiltrado" then has.Asaltante = true else has[role] = true end
    end
    for _, needed in ipairs(required) do
        if not has[needed] then
            for _, entry in ipairs(roster) do
                if not used[entry.id] then assigned[entry.id], used[entry.id] = needed, true; break end
            end
        end
    end
    for _, entry in ipairs(roster) do
        if not used[entry.id] then
            local role = entry.role
            if not roles[role] or role == "Presidente" or role == "Vicepresidente" then role = "Guardia" end
            assigned[entry.id] = role
        end
    end
    return assigned
end
function Rules.result(presidentAlive, viceAlive, secondsLeft)
    if not presidentAlive or not viceAlive then return "Ataque" end
    if secondsLeft <= 0 then return "Defensa" end
    return nil
end
function Rules.leaderDeparture(role, viceAvailable)
    if role == "Presidente" then return viceAvailable and "Promover" or "Cancelada" end
    if role == "Vicepresidente" then return "Cancelada" end
    return "Continuar"
end
function Rules.topMaps(order, totals)
    local best, choices = -1, {}
    for _, name in ipairs(order) do
        local count = totals[name] or 0
        if count > best then best, choices = count, {name}
        elseif count == best then table.insert(choices, name) end
    end
    return choices
end
return Rules
