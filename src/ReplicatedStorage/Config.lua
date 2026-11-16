-- Replace with your own published pass ID to enable the optional cosmetic.
local Config = {}
Config.Title = "PROTECCIÓN PRESIDENCIAL"
Config.GamePassId = 0
Config.Intermission = 25
Config.RoundLength = 240
Config.MinimumPlayers = 3
Config.DailyLoginCoins = 75
Config.DailyMissionCoins = 175
Config.DailyMissionRounds = 3
-- Create these passes in Creator Dashboard and replace each 0 with its ID.
-- GamePassId is kept for compatibility with the earlier Estelar configuration.
Config.Passes = {Estelar = 0, Imperial = 0, Espectro = 0}
Config.Maps = {
    Palacio = {label = "Palacio presidencial", description = "Jardines y barricadas en el centro."},
    Embajada = {label = "Embajada", description = "Patio cerrado y accesos protegidos."},
    Ciudad = {label = "Distrito urbano", description = "Calles con edificios y múltiples coberturas."},
}
Config.MapOrder = {"Palacio", "Embajada", "Ciudad"}
Config.Weapons = {
    Blaster = {damage = 20, cooldown = 0.30, range = 180, color = Color3.fromRGB(65, 201, 255)},
    Rapida = {damage = 12, cooldown = 0.14, range = 150, color = Color3.fromRGB(255, 200, 77)},
    Pesada = {damage = 35, cooldown = 0.70, range = 160, color = Color3.fromRGB(255, 97, 110)},
}
Config.Skins = {
    Clasico = {price = 0, color = Color3.fromRGB(235, 242, 255)},
    Neon = {price = 250, color = Color3.fromRGB(82, 255, 191)},
    Solar = {price = 500, color = Color3.fromRGB(255, 195, 59)},
    Oceano = {price = 350, color = Color3.fromRGB(68, 192, 255)},
    Carmesi = {price = 450, color = Color3.fromRGB(255, 85, 100)},
    Aurora = {price = 800, color = Color3.fromRGB(116, 250, 220)},
    Heroe = {level = 5, color = Color3.fromRGB(255, 246, 155)},
    Estelar = {pass = "Estelar", color = Color3.fromRGB(210, 115, 255)},
    Imperial = {pass = "Imperial", color = Color3.fromRGB(255, 190, 55)},
    Espectro = {pass = "Espectro", color = Color3.fromRGB(90, 232, 255)},
}
Config.SkinOrder = {"Clasico", "Neon", "Oceano", "Carmesi", "Solar", "Aurora", "Heroe", "Estelar", "Imperial", "Espectro"}
Config.Roles = {
    Presidente = {label = "Presidente", side = "Defensa", health = 140, color = "Bright yellow", description = "Protégelo: si cae, ganan los atacantes."},
    Vicepresidente = {label = "Vicepresidente", side = "Defensa", health = 130, color = "Bright orange", description = "Protégelo: si cae, ganan los atacantes."},
    Policia = {label = "Policía", side = "Defensa", health = 120, color = "Bright blue", description = "Vigila el perímetro y protege a los líderes."},
    Guardia = {label = "Guardia presidencial", side = "Defensa", health = 150, color = "Dark blue", description = "Primera línea de protección."},
    Medico = {label = "Médico", side = "Defensa", health = 100, color = "Lime green", description = "Cura a los aliados cercanos con tu habilidad."},
    Tactico = {label = "Equipo táctico", side = "Defensa", health = 160, color = "Dark green", description = "Refuerza la defensa con más resistencia."},
    Asaltante = {label = "Asaltante", side = "Ataque", health = 120, color = "Bright red", description = "Ataca a cualquiera de los dos líderes."},
    Infiltrado = {label = "Infiltrado", side = "Ataque", health = 105, color = "Royal purple", description = "Penetra el perímetro y ataca a los líderes."},
}
Config.RoleOrder = {"Presidente", "Vicepresidente", "Policia", "Guardia", "Medico", "Tactico", "Asaltante", "Infiltrado"}
return Config
