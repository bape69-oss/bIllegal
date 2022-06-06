ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Wait(1)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)



------------------------------------------------------------------------------------------------------------------------------------------------

local function OpenShop(Cat, List)
    local Menu = RageUI.CreateMenu(Config_Illegal.ServerName, "Que voulez-vous faire ?")

    RageUI.Visible(Menu, true)
    CreateThread(function()
        while Menu do
            Wait(0)
            RageUI.IsVisible(Menu, function()
                if index == nil then index = 1 end
                RageUI.List("Filtre", Cat, index, nil, {}, true, {
                    onListChange = function(i) index = i end
                })


                if index == 1 then
                    for k,v in pairs(List.weapon_fire) do
                        RageUI.Button(v.Label, nil, {RightLabel = "~r~"..GroupDigits(v.Price)}, true, {
                            onSelected = function()
                                TriggerServerEvent('bIllegal:Buy', v.Label, v.Name, v.Price)
                            end
                        })
                    end
                elseif index == 2 then
                    for k,v in pairs(List.weapon_meler) do
                        RageUI.Button(v.Label, nil, {RightLabel = "~r~"..GroupDigits(v.Price)}, true, {
                            onSelected = function()
                                TriggerServerEvent('bIllegal:Buy', v.Label, v.Name, v.Price)
                            end
                        })
                    end
                elseif index == 3 then
                    for k,v in pairs(List.weapon_lourd) do
                        RageUI.Button(v.Label, nil, {RightLabel = "~r~"..GroupDigits(v.Price)}, true, {
                            onSelected = function()
                                TriggerServerEvent('bIllegal:Buy', v.Label, v.Name, v.Price)
                            end
                        })
                    end
                elseif index == 4 then
                    for k,v in pairs(List.sell) do
                        ESX.PlayerData = ESX.GetPlayerData()
                        for i = 1, #ESX.PlayerData.inventory do
                            if ESX.PlayerData.inventory[i].count > 0 then
                                if ESX.PlayerData.inventory[i].name == v.Name then
                                    RageUI.Button(v.Label.." ("..ESX.PlayerData.inventory[i].count..")", nil, {RightLabel = "~o~"..GroupDigits(v.Price)}, true, {
                                        onSelected = function()
                                            TriggerServerEvent('bIllegal:Sell', v.Label, v.Name, v.Price)
                                        end
                                    })
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('bIllegal:StartMission')
AddEventHandler('bIllegal:StartMission', function(_Name)
    local pos = Config_Illegal.Zone.Livery[math.random(1, #Config_Illegal.Zone.Livery)]
    ESX.ShowNotification("~r~Vendeur~s~\nRejoins-moi ici")

    local gun_blip = AddBlipForCoord(pos)
    SetBlipSprite(gun_blip, 280)
    SetBlipColour(gun_blip, 75)
    SetBlipShrink(gun_blip, true)
    SetBlipScale(gun_blip, 0.90)
    SetBlipPriority(gun_blip, 50)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Contact illégal")
    EndTextCommandSetBlipName(gun_blip)

    SetBlipRoute(gun_blip, true)
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)

    RequestModel("cs_andreas")
    while not HasModelLoaded("cs_andreas") do RequestModel('cs_andreas') Wait(10) end
    local Peds = CreatePed(1, "cs_andreas", pos.x, pos.y, pos.z-1, 0.0, false, true)
    local Peds2 = CreatePed(1, "cs_andreas", pos.x, pos.y, pos.z-1, 0.0, false, true)
    SetHostilePed(Peds)
    SetHostilePed(Peds2)


    local caise = CreateObject(GetHashKey("prop_box_wood02a_pu"), pos, 1, 0, 1)
    PlaceObjectOnGroundProperly(caise)
    Wait(10)

    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        if #(coords - pos) <= 2.5 and DoesEntityExist(caise) then
            ESX.ShowFloatingHelpNotification("Appuyez sur E pour ouvrir la ~p~caisse", vector3(pos.x, pos.y, pos.z + 1.20))
            if IsControlJustPressed(1, 51) then
                ApplyForceToEntity(caise, 2, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                TriggerServerEvent('bIllegal:giveitem', _Name)
                DeleteEntity(caise)
                SetModelAsNoLongerNeeded(caise)
                RemoveBlip(gun_blip)
            end
        end
    end
end)



------------------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local inZone = false
        local coords = GetEntityCoords(PlayerPedId())

        for k,v in pairs(Config_Illegal.Setting) do
            if #(coords - v.Position) <= 2.0 then
                inZone = true
                ESX.ShowHelpNotification("Appuyez sur E pour parler avec ~r~vendeur")
                DrawMarker(23, v.Position.x, v.Position.y, v.Position.z - 0.98, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 155, 0, 0, 0, 0, 0, 0, 0)
                if IsControlJustPressed(1, 51) then
                    OpenShop(v.Categorie, v.List)
                end
            end
        end

        if not inZone then
            Wait(1500)
        else
            Wait(1)
        end
    end
end)


------------------------------------------------------------------------------------------------------------------------------------------------
function GroupDigits(value)
    local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right.."$"
end

function SetHostilePed(ped)
    GiveWeaponToPed(ped, "weapon_carbinerifle", 255, false, true)
    TaskShootAtEntity(ped, PlayerPedId(), 60, 0xD6FF6D61);
    TaskCombatPed(ped, PlayerPedId(), 0, 16)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 15.0)
    SetPedSeeingRange(ped, 15.0)
    SetPedAlertness(ped, 15.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
end
