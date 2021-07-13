ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback("ContextBank:getMoney", function(source, Callback, type)
    local player = ESX.GetPlayerFromId(source)
    if player then
        if type == "bank" then
            Callback(player.getAccount('bank').money)
        elseif type == "money" then
            Callback(player.getMoney())
        else
            Callback(nil)
        end
    end
end)

RegisterServerEvent("ContextBank:ActionsMoney")
AddEventHandler("ContextBank:ActionsMoney", function(type, money)
    local player = ESX.GetPlayerFromId(source)
    if type == "depot" then
        player.addAccountMoney('bank', money)
        player.removeMoney(money)
    elseif type == "retrait" then
        player.removeAccountMoney('bank', money)
        player.addMoney(money)
    end
end)
