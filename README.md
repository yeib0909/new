<!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:53c34e292f08f66feebf0f00852981ff8d8c19885701bf546b801b43e44e4a7d -->

<!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:1591abc29dc36336b17688edfd9665279c7b56757173b868387023afe66da6a0 -->

# Protección Presidencial · versión extendida

Una partida de Roblox con ocho equipos de rol: presidente, vicepresidente, policía, guardia, médico, equipo táctico, asaltante e infiltrado. <!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:7a6833c657c8d1efcaa893ad3cfe9e43e0a81d4cd2f0220dcbddc797f57af37b -->

La defensa gana si los líderes que siguen en funciones sobreviven hasta el final del tiempo; los atacantes ganan si muere cualquiera de ellos.

<!-- /coderabbit-ai-generated:v1 --> La regla no cambia entre mapas.

## Contenido

- Tres mapas: Palacio, Embajada y Distrito urbano. Los jugadores votan en el lobby; los empates se resuelven al azar.
- Roles seleccionables, tres armas, curación para médicos, reaparición de combatientes y equipos aliados sin daño amistoso.
- Progreso por experiencia, nivel y victorias; el aspecto Héroe se desbloquea en el nivel 5.
- Regalo diario y misión diaria de tres rondas, que se reinician a medianoche UTC. Las rondas canceladas no cuentan.
- Tienda con aspectos por monedas y tres pases cosméticos opcionales: Estelar, Imperial y Espectro. Los pases tienen efectos visuales y no alteran las estadísticas.

Se necesitan tres jugadores. Presidente y vicepresidente tienen una plaza cada uno. Al comenzar, el servidor asigna los puestos esenciales que falten. Quien entra durante una ronda espera en el lobby. <!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:81afaa58561dc974e1a1aefd598ba8424ab30df11db266fe5c14277e422d4df1 -->

Si el presidente se desconecta, el vicepresidente asume la presidencia y su antigua plaza queda vacante; la ronda sigue y los atacantes ganan si el nuevo presidente muere. Si el vicepresidente se desconecta antes de la sucesión, si no queda sucesor cuando sale el presidente o si salen todos los atacantes, la ronda se cancela sin ganador.

<!-- /coderabbit-ai-generated:v1 --> La moneda de juego y la experiencia se conceden en el servidor.

## Abrir y publicar

1. Descarga `Proteccion-Presidencial-Extendido.rbxlx` y ábrelo en Roblox Studio. El mapa y la interfaz se generan al iniciar **Play**, por lo que el editor se verá vacío antes de jugar.
2. En **Test > Server & Clients**, inicia al menos tres jugadores. Prueba roles, votación de mapas, ambas condiciones de victoria, desconexiones, curación, recompensas y controles móviles.
3. Usa **File > Publish to Roblox** y configura nombre, descripción, icono y visibilidad desde Creator Dashboard.
4. Para probar el guardado en Studio, publica primero y activa **Game Settings > Security > Enable Studio Access to API Services**. Usa una experiencia de pruebas separada: Studio puede acceder a los mismos datos de la experiencia publicada.
5. El progreso se guarda periódicamente y al salir. Un bloqueo temporal evita que dos servidores escriban a la vez el mismo perfil. Si no se puede cargar el perfil o está ocupado, se avisa al jugador y esa sesión no se guarda. Si un servidor termina inesperadamente, el bloqueo puede tardar hasta tres minutos en caducar. Al actualizar una versión anterior, cierra los servidores antiguos para evitar escrituras simultáneas de código anterior.

## Configurar ventas

Crea tres pases distintos en Creator Dashboard, activa sus ventas y establece sus precios allí. En Studio abre `ReplicatedStorage > Config` y cambia cada cero en `Config.Passes` por el ID del pase correspondiente. Para conservar la configuración anterior, `Config.GamePassId` sigue siendo el ID alternativo de Estelar si `Config.Passes.Estelar` está en cero. Publica los cambios. Los pases sin ID aparecen como «Próximamente». Prueba compras y recuperación del pase con cuentas de prueba en la experiencia publicada.

## Ajustes y código

`Config.lua` define mapas, roles, armas, recompensas, precios en monedas e IDs de pases. `Rules.lua`, `Progress.lua` y `ProfileLease.lua` contienen reglas comprobables; `Game.server.lua` controla mapa, rondas, combate, tienda y guardado; `Client.client.lua` contiene la interfaz. Compila con `rojo build default.project.json -o Proteccion-Presidencial-Extendido.rbxlx`.

Prueba el lugar en Roblox Studio y en servidores publicados antes de abrirlo al público. Ajusta los precios y el balance según las pruebas.


<!-- /coderabbit-ai-generated:v1 --><!-- /coderabbit-ai-generated:v1 -->