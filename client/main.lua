local players = {}
local alias = {}

RegisterNetEvent('map-alias:setPlayers')
RegisterNetEvent('map-alias:setAlias')

AddEventHandler('map-alias:setPlayers', function(data)
    players = data
end)

AddEventHandler('map-alias:setAlias', function(res)
    alias = res
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    TriggerServerEvent('map-alias:fetchAlias')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        TriggerServerEvent('map-alias:getPlayers')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)   
        for k,v in pairs(alias) do
            local player = getPlayerFromIdentifier(v.target)
            if player then
                local pedCoords = GetEntityCoords(player)
                if Config.MaskCheck and GetPedDrawableVariation(player, 1) ~= 0 then

                    if Config.Mask3d then
                        DrawText3Ds(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, Config.Locale["mask"])
                    end

                else
                    local text = v.text
                    if text ~= nil then
                        DrawText3Ds(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, text)
                    end

                end
            else
                Citizen.Wait(500)
            end
        end
    end
end)

function getPlayerFromIdentifier(identifier)
    local localPed = PlayerPedId()
    for k,v in pairs(players) do
        if identifier == v.identifier then
            local ped = GetPlayerPed(GetPlayerFromServerId(k))
            if ped ~= localPed then
                if #(GetEntityCoords(localPed) - GetEntityCoords(ped)) < Config.Distance then
                    return ped
                end
            end
        end
    end

    return nil
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end