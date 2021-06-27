--- Contributor : Dako, Shazuub le BG, Latex, AigleIsRetour, Noky, Sex

local ESX = nil
local HistoriqueTransactions = {}

CreateThread(function()
    while ESX == nil do
        ESX = exports.es_extended:getSharedObject()
        Wait(1)
        while not ESX.IsPlayerLoaded() do  Wait(1) end 
    end
end)

local KeyboardInput = function(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
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

local ContextATM = ContextUI:CreateMenu(3, "ATM") 
local HistoriqueMenu = ContextUI:CreateSubMenu(ContextATM, "Transaction") 

ContextUI:IsVisible(ContextATM, function(Entity)
    if Entity.Model == -870868698 or Entity.Model == -1126237515 or Entity.Model == -1364697528 or Entity.Model == 506770882 then
        ContextUI:Button("Solde ~g~$" ..tostring(PlayerMoney).. "~s~", nil, function() end)

        ContextUI:Button("Déposer de l'argent", nil, function(Selected)
            if (Selected) then
                getPlayerMoney()
                local BoardMoney = KeyboardInput("Montant du dépot", "", 6)
                if tonumber(PlayerMoney) >= tonumber(BoardMoney) then
                    TriggerServerEvent("ContextBank:ActionsMoney", "depot", tonumber(BoardMoney))
                    table.insert(HistoriqueTransactions, {
                        money = BoardMoney,
                        type = "Dépôt",
                        hours = GetClockHours(),
                        minutes = GetClockMinutes(),
                    })
                    getPlayerMoney()
                    ESX.ShowNotification("Vous avez déposer "..tostring(BoardMoney).."~g~$")
                else
                    ESX.ShowNotification("~r~Vous n'avez pas autant d'argent.")
                end
            end
        end)

        ContextUI:Button("Retirer de l'argent", nil, function(Selected)
            if (Selected) then
                getPlayerMoney()
                local BoardMoney = KeyboardInput("Montant du retrait", "", 6)
                if tonumber(PlayerMoney) >= tonumber(BoardMoney) then
                    TriggerServerEvent("ContextBank:ActionsMoney", "retrait", tonumber(BoardMoney))
                    table.insert(HistoriqueTransactions, {
                        money = BoardMoney,
                        type = "Retrait",
                        hours = GetClockHours(),
                        minutes = GetClockMinutes(),
                    })
                    getPlayerMoney()
                    ESX.ShowNotification("Vous avez retirer "..tostring(BoardMoney).."~g~$")
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
            ContextUI:Button(HistoriqueTransactions[i].type.." "..tostring(HistoriqueTransactions[i].money).."~g~$", "à "..HistoriqueTransactions[i].hours..":"..HistoriqueTransactions[i].minutes, function(Selected) 
            end)
        end
    else
        ContextUI:Button("~r~Aucune transaction(s)", nil, function() end)
    end    
end)

getPlayerMoney = function()
    ESX.TriggerServerCallback("ContextBank:getMoney", function(money) 
        PlayerMoney = money
    end)
end

Keys.Register("LMENU", "LMENU", "BankMenu", function()
    getPlayerMoney()
    ContextUI.Focus = not ContextUI.Focus;
end)
