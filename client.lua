--- Contributor : DakoM, Shazuub, Yatox, AigleIsBack, Noky
local ESX = nil
local HistoriqueTransactions = {}

CreateThread(function()
    while ESX == nil do
        ESX = exports.es_extended:getSharedObject()
        Wait(1)
        while not ESX.IsPlayerLoaded() do  Wait(1) end 
        print("Contributor: DakoM, Shazuub, Yatox, AigleIsBack, Noky")
    end
end)

local KeyboardInput = function(display, text, InBoxText, maxCaracters)
    AddTextEntry(display, text)
    DisplayOnscreenKeyboard(1, display, "", InBoxText, "", "", "", maxCaracters)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(1.0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

local ContextATM = ContextUI:CreateMenu(3, "Objets") 
local HistoriqueMenu = ContextUI:CreateSubMenu(ContextATM, "Transactions") 

ContextUI:IsVisible(ContextATM, function(Entity)
    if Entity.Model == -870868698 or Entity.Model == -1126237515 or Entity.Model == -1364697528 or Entity.Model == 506770882 then
        ContextUI:Button("Solde", "1. Solde personnel ~g~$" ..tostring(PlayerMoney).. "~s~\n2. Solde bancaire ~b~$" ..tostring(PlayerBank).. "~s~", function() end)  
        ContextUI:Button("Déposer de l'argent", nil, function(Selected)
            if (Selected) then
                local BoardDepot = KeyboardInput("DEPOT_BANKING", "Montant du dépot", "", 6)
                local year ,month ,day ,hour ,minute ,second  = GetPosixTime() 
                if month < 10 then
                    month = "0"..month
                end
                if tonumber(PlayerMoney) >= tonumber(BoardDepot) then
                    TriggerServerEvent("ContextBank:ActionsMoney", "depot", tonumber(BoardDepot))
                    table.insert(HistoriqueTransactions, {
                        money = BoardDepot,
                        type = "Dépôt",
                        time = day.."/"..month,
                    })
                    getPlayerMoney("money")
                    getPlayerMoney("bank")
                    ESX.ShowNotification("Vous avez déposé -"..tostring(BoardDepot).."~g~$")
                else
                    ESX.ShowNotification("~r~Vous n'avez pas autant d'argent.")
                end
            end
        end)

        ContextUI:Button("Retirer de l'argent", nil, function(Selected)
            if (Selected) then
                local BoardRetrait = KeyboardInput("RETRAIT_BANKING", "Montant du retrait", "", 6)
                local year ,month ,day  = GetPosixTime() 
                if month < 10 then
                    month = "0"..month
                end
                if tonumber(PlayerBank) >= tonumber(BoardRetrait) then
                    TriggerServerEvent("ContextBank:ActionsMoney", "retrait", tonumber(BoardRetrait))
                    table.insert(HistoriqueTransactions, {
                        money = BoardRetrait,
                        type = "Retrait",
                        time = day.."/"..month
                    }) 
                    getPlayerMoney("bank")
                    getPlayerMoney("money")
                    ESX.ShowNotification("Vous avez retiré +"..tostring(BoardRetrait).."~g~$")
                else
                    ESX.ShowNotification("~r~Vous n'avez pas autant d'argent sur le compte.")
                end
            end
        end)

        ContextUI:Button("Historique des Transactions", "Rendez-vous ici pour voir vos transactions les plus récentes.", function()
        end, HistoriqueMenu)
    end
end)

ContextUI:IsVisible(HistoriqueMenu, function(Entity)
    if #HistoriqueTransactions > 0 then
        ContextUI:Button("Clear les Transactions", nil, function(Selected) 
            if (Selected) then
                HistoriqueTransactions = {}
            end
        end)
        for i=1, #HistoriqueTransactions, 1 do
            ContextUI:Button(HistoriqueTransactions[i].type.." "..tostring(HistoriqueTransactions[i].money).."~g~$", "le "..HistoriqueTransactions[i].time, function(Selected) 
            end)
        end
    else
        ContextUI:Button("~r~Aucune transaction(s)", nil, function() end)
    end    
end)

getPlayerMoney = function(type)
    ESX.TriggerServerCallback("ContextBank:getMoney", function(money) 
        if type == "bank" then 
            PlayerBank = money
        elseif type == "money" then 
            PlayerMoney = money
        end
    end, type)
end

Keys.Register("LMENU", "LMENU", "BankMenu", function()
    getPlayerMoney("bank")
    getPlayerMoney("money")
    ContextUI.Focus = not ContextUI.Focus;
end)
