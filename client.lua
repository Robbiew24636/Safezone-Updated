local safezones = {
    { coords = vec3(140.96, -3092.31, 5.9), radius = 50.0 },
    { coords = vec3(129.46, -1075.94, 29.19), radius = 30.0 },
    { coords = vec3(-451.58, -334.7, 34.36), radius = 60.0 },
    { coords = vec3(1467.82, 6357.97, 23.8), radius = 50.0 },
    { coords = vec3(-43.86, -1097.93, 26.42), radius = 40.0 },
    { coords = vec3(-1703.3, -1135.83, 13.15), radius = 30.0 },
    { coords = vec3(1070.72, 2310.45, 45.51), radius = 50.0 },
}

local inSafezone = false

function disableCombatControls()
    local ped = PlayerPedId()
    DisablePlayerFiring(ped, true)
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 257, true) -- Melee attack
    DisableControlAction(0, 263, true) -- Weapon select
    DisableControlAction(0, 140, true) -- Melee light attack
    DisableControlAction(0, 141, true) -- Melee heavy attack
    DisableControlAction(0, 142, true) -- Melee alternate attack
    DisableControlAction(0, 143, true) -- Enter cover
    DisableControlAction(0, 303, true) -- Disable U key
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
end

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local isInZone = false
        for _, zone in pairs(safezones) do
            if #(pos - zone.coords) <= zone.radius then
                isInZone = true
                break
            end
        end

        if isInZone then
            sleep = 0
            if not inSafezone then
                inSafezone = true
                SendNUIMessage({ action = "show" })
            end
            disableCombatControls()
        else
            if inSafezone then
                inSafezone = false
                SendNUIMessage({ action = "hide" })
            end
        end

        Wait(sleep)
    end
end)
