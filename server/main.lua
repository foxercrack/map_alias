local players = {}
-- { identifier }

RegisterServerEvent('map-alias:fetchAlias')
RegisterServerEvent('map-alias:setServerIdentifier')
RegisterServerEvent('map-alias:getPlayers')

AddEventHandler('map-alias:fetchAlias', function()
    fetchAlias(source)
end)

function fetchAlias(source)
    local identifier = GetPlayerIdentifier(source)
    local _source = source
    MySQL.query('SELECT * FROM `alias` WHERE identifier = ?', { identifier }, function(result)
        TriggerClientEvent('map-alias:setAlias', _source, result)

        for k,_ in pairs(GetPlayers()) do
            players[k] = {}
        end
    
        getIdentifiers()
    end)
end

function getIdentifiers()
    for k,v in pairs(players) do
        players[k].identifier = GetPlayerIdentifier(k)
    end
end

AddEventHandler('map-alias:getPlayers', function()
    TriggerClientEvent('map-alias:setPlayers', -1, players)
end)

RegisterCommand('alias', function(source, args)
    local _source = source
    if _source > 0 then
        local localPlayer = GetPlayerIdentifier(_source)
        local target = GetPlayerIdentifier(args[1])
        if args[2] == nil then return end
        if target ~= nil then
            local res = MySQL.query.await('SELECT * FROM `alias` WHERE `target` = ?', { target })
            if res[1] == nil then
                MySQL.insert('INSERT INTO `alias` (`identifier`, `text`, `target`) VALUES (?, ?, ?)', { localPlayer, args[2], target }, function()
                    notify(_source, Config.Locale["successfullyAlias"])
                    fetchAlias(_source)
                end)
            else
                notify(_source, Config.Locale["alreadyHaveAlias"])
            end
        else
            notify(_source, Config.Locale["doesntExist"])
        end
    end
end)


RegisterCommand('removealias', function(source, args)
    local _source = source
    if _source > 0 then
        local target = GetPlayerIdentifier(args[1])
        if target ~= nil then
            MySQL.update('DELETE FROM `alias` WHERE `target` = ?', { target }, function()
                notify(_source, Config.Locale["aliasRemoved"])
                fetchAlias(_source)
            end)
        else
            notify(_source, Config.Locale["doesntExist"])
        end
    end
end)

function notify(source, text)
    TriggerClientEvent("chat:addMessage", source, {
        args = { text },
    })
end