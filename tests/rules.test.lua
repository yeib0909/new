local Rules = require("../src/ReplicatedStorage/Rules")
local roles = {Presidente = true, Vicepresidente = true, Guardia = true, Policia = true, Medico = true, Tactico = true, Asaltante = true, Infiltrado = true}
local function checkRoster(roster)
    local assigned = Rules.assignRoles(roster, roles)
    if #roster < 3 then assert(assigned == nil); return end
    local counts = {Presidente = 0, Vicepresidente = 0, Attack = 0}
    for _, entry in ipairs(roster) do
        local role = assigned[entry.id]
        assert(roles[role], "Every player must receive a valid role")
        if role == "Presidente" or role == "Vicepresidente" then counts[role] += 1 end
        if role == "Asaltante" or role == "Infiltrado" then counts.Attack += 1 end
    end
    assert(counts.Presidente == 1 and counts.Vicepresidente == 1 and counts.Attack >= 1, "Required roles are missing or duplicated")
end
checkRoster({{id = 1, role = "Guardia"}, {id = 2, role = "Guardia"}})
checkRoster({{id = 1, role = "Guardia"}, {id = 2, role = "Guardia"}, {id = 3, role = "Guardia"}})
local selected = {{id = 1, role = "Infiltrado"}, {id = 2, role = "Presidente"}, {id = 3, role = "Vicepresidente"}, {id = 4, role = "Medico"}}
checkRoster(selected)
local result = Rules.assignRoles(selected, roles)
assert(result[1] == "Infiltrado" and result[2] == "Presidente" and result[3] == "Vicepresidente" and result[4] == "Medico")
checkRoster({{id = 1, role = "Presidente"}, {id = 2, role = "Presidente"}, {id = 3, role = "Vicepresidente"}, {id = 4, role = "Vicepresidente"}})
assert(Rules.result(true, true, 1) == nil)
assert(Rules.result(true, true, 0) == "Defensa")
assert(Rules.result(false, true, 50) == "Ataque")
assert(Rules.result(true, false, 50) == "Ataque")
assert(Rules.result(false, true, 0) == "Ataque")
print("Role assignment and victory rules passed")
local choices = Rules.topMaps({"Palacio", "Embajada", "Ciudad"}, {Palacio = 1, Embajada = 3, Ciudad = 3})
assert(#choices == 2 and choices[1] == "Embajada" and choices[2] == "Ciudad")
assert(#Rules.topMaps({"Palacio", "Ciudad"}, {}) == 2)
print("Map vote selection passed")
assert(Rules.leaderDeparture("Presidente", true) == "Promover")
assert(Rules.leaderDeparture("Presidente", false) == "Cancelada")
assert(Rules.leaderDeparture("Vicepresidente", true) == "Cancelada")
assert(Rules.leaderDeparture("Policia", true) == "Continuar")
-- A vacant vice position does not count as a death after succession.
assert(Rules.result(true, true, 1) == nil)
assert(Rules.result(true, true, 0) == "Defensa")
assert(Rules.result(false, true, 1) == "Ataque")
print("Succession and victory conditions passed")
