ESX  = nil
ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback("ContextBank:getMoney", function(source, Callback)
    local player = ESX.GetPlayerFromId(source)
    Callback(player.getAccount('bank').money)
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