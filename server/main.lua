local players = {}
-- { identifier }

RegisterServerEvent('map-alias:fetchAlias')
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
            players[k] = {
                identifier = GetPlayerIdentifier(k, 0)
            }
        end
    end)
end

AddEventHandler('map-alias:getPlayers', function()
    TriggerClientEvent('map-alias:setPlayers', -1, players)
end)

RegisterCommand('alias', function(source, args)
    local _source = source
    if _source > 0 and args[1] and args[2] then
        local localPlayer = GetPlayerIdentifier(_source, 0)
        local target = GetPlayerIdentifier(args[1], 0)

        if target ~= nil then
            local res = MySQL.query.await('SELECT * FROM `alias` WHERE `target` = ? AND `identifier` = ?', { target, localPlayer })
            if res[1] == nil then
                MySQL.insert('INSERT INTO `alias` (`id`, `identifier`, `text`, `target`) VALUES (NULL, ?, ?, ?)', { localPlayer, tostring(args[2]), target }, function()
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
    if _source > 0 and args[1] then
        local target = GetPlayerIdentifier(args[1], 0)
        if target ~= nil then
            MySQL.update('DELETE FROM `alias` WHERE `target` = ? AND identifier = ?', { target, GetPlayerIdentifier(source, 0) }, function()
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