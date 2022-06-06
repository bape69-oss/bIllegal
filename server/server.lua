TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterNetEvent("bIllegal:Buy")
AddEventHandler("bIllegal:Buy", function(_Label, _Name, _Price)
    local player = ESX.GetPlayerFromId(source)
    local dMoney = player.getAccount('black_money').money

    if dMoney >= _Price then
        player.removeAccountMoney('black_money', _Price)
        player.showNotification("~r~Vendeur~s~\nVous venez d'acheter une ~r~".._Label.."~s~ rejoins moi pour la prendre")
        TriggerClientEvent('bIllegal:StartMission', player.source, _Name)
    else
        player.showNotification("~r~Vendeur~s~\nNe t'avise plus de me niquer stp !")
    end
end)

RegisterNetEvent('bIllegal:giveitem')
AddEventHandler('bIllegal:giveitem', function (_Name)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if Config_Illegal.ArmesItem then
        xPlayer.addInventoryItem(_Name, 1)
    end
    if not Config_Illegal.ArmesItem then
        xPlayer.addWeapon(_Name, 255)
    end
end)

RegisterNetEvent('bIllegal:Sell')
AddEventHandler('bIllegal:Sell', function (_Label, _Name, _Price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if Config_Illegal.ArmesItem then
        xPlayer.removeInventoryItem(_Name, 1)
        xPlayer.addAccountMoney("black_money", _Price)
    end
    if not Config_Illegal.ArmesItem then
        xPlayer.removeWeapon(_Name, 1)
        xPlayer.addAccountMoney("black_money", _Price)
    end
end)