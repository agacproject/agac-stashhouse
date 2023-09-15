QBCore = exports['qb-core']:GetSharedObject()

local currentHouseIn = nil
local currentHouseUp = nil
local inhouse = false

RegisterCommand('stashraid', function()
    if QBCore.Functions.GetPlayerData().job.name == "police" then
        local closestStash = GetClosestStash()
        if closestStash ~= nil then
            data1 = GetDataByStashId(closestStash)
            data = json.decode(data1[1].data)
            if data.sold == true then
                
                exports['deniz-powerplant']:OpenMinigame(function(success)
                    if success then
                        local plyloc = GetEntityCoords(PlayerPedId())
                        currentHouseUp = plyloc
                        QBCore.Functions.Notify(closestStash.." numaralı stashhouse'u raidledin.", "success")
                        -- local generator = {x = curHouseCoords["x"], y = curHouseCoords["y"], z = curHouseCoords["z"]}
                        curHouseCoords = {x = plyloc.x, y = plyloc.y, z = plyloc.z-16}
                        buildBasicHouse({x = plyloc.x, y = plyloc.y, z = plyloc.z-16}, closestStash)
                        inhouse = true
                        while inhouse do
                            Citizen.Wait(0)
                            local playerCoords = GetEntityCoords(PlayerPedId(), true) 
                            if GetDistanceBetweenCoords(playerCoords, curHouseCoords.x-4.3, curHouseCoords.y-5, curHouseCoords.z+1, true) < 3 then
                                DrawText3Ds(curHouseCoords.x-4.3, curHouseCoords.y-5, curHouseCoords.z+1,"~g~E~s~ - Dolap ")
                                if IsControlJustPressed(0, 38) then
                                    --print('dolap')
                                end
                            end
                            if GetDistanceBetweenCoords(playerCoords, curHouseCoords.x+7, curHouseCoords.y-0.4, curHouseCoords.z+1, true) < 3 then
                                DrawText3Ds(curHouseCoords.x+7, curHouseCoords.y-0.4, curHouseCoords.z+1,"~g~E~s~ - Depo ")
                                if IsControlJustPressed(0, 38) then
                                    TriggerEvent("inventory:client:openhousestash", closestStash.."stashhouse")
                                    TriggerServerEvent("inventory:server:OpenInventory", "stash", closestStash.."stashhouse", {maxweight = 1000000,slots = 50})
                                end
                            end
                        end
                    else
                        QBCore.Functions.Notify('Başaramadın.', 'error')
                    end
                end, 1, 15)

            end
        else
            QBCore.Functions.Notify('Yakınlarda stash yok.', 'error')
        end
    end
end)

RegisterCommand('newstash', function(source, args)
    local ply = PlayerPedId()
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name ~= 'stashhouse' then 
        QBCore.Functions.Notify('Stashhouse oluşturma iznin yok.', 'error')
        return 
    end
    -- local keyboard = exports["ld-keyboard"]:KeyboardInput({
    --     header = "Stashhouse Oluştur",
    --     rows = {
    --         {
    --             id = 0,
    --             txt = "Fiyat",
    --             icon = "fa-solid fa-hand-holding-dollar"
    --         },
    --         {
    --             id = 1,
    --             txt = "Stashhouse Türü (deaktif)",
    --             icon = "fa-solid fa-book"
    --         },
    --     }
    -- })
    --stprice = tonumber(keyboard[1].input)
    -- acctype = tonumber(keyboard[2].input)

    local interiors = {
        { id = "normal", name = "Normal" },
        -- { id = "vip", name = "VIP" },
    }

    local keyboard, stprice, sttype = exports["almez-keyboard"]:Keyboard({
        header = "Stashhouse", 
        rows = {
            {label = "Fiyat", type = "number", icon = "fa-solid fa-hand-holding-dollar"},
            {label = "Tür", type = "select", options = interiors, icon = "fa-solid fa-book"},
        -- {label = "Departman", type = "select", options = departments, icon = "fas fa-building"},
        },
    })

    if stprice ~= nil and sttype ~= nil then
        stashData = {
            coords = GetEntityCoords(ply),
            data = {
                price = stprice,
                sold = false,
                password = 1234
            }
        }
        if stashData.data.price ~= nil then
            QBCore.Functions.TriggerCallback('deniz-stashhouse:createStashhouse', function(result)
                if result then
                    QBCore.Functions.Notify('Stashhouse oluşturuldu.', 'success')
                else
                    QBCore.Functions.Notify('Stashhouse oluşturulamadı.', 'error')
                end
            end, stashData)
        end
    end
end)

function getAllStashhouses()
    local callback = promise:new()
    QBCore.Functions.TriggerCallback('deniz-stashhouse:getStashhouses', function(result)
        callback:resolve(result)
    end)
    return Citizen.Await(callback)
end

function GetClosestStash()
    local all = getAllStashhouses()
    local plyloc = GetEntityCoords(PlayerPedId())
    Citizen.Wait(100)
    for k,v in pairs(all) do
        data = json.decode(v.coords)
        local plydistance = GetDistanceBetweenCoords(plyloc.x, plyloc.y, plyloc.z, data.x, data.y, data.z, true)
        if plydistance < 3 then 
            --print(v.id)
            return v.id
            -- break
        end 
    end
end
exports("GetClosestStash", GetClosestStash)

function GetDataByStashId(stashid)
    local callback = promise:new()
    QBCore.Functions.TriggerCallback('deniz-stashhouse:getStashhouse:byId', function(result)
        callback:resolve(result)
    end, stashid)
    return Citizen.Await(callback)
end

RegisterNetEvent('deniz-stashhouse:in', function()
    local closestStash = GetClosestStash()
    if closestStash ~= nil then
        data1 = GetDataByStashId(closestStash)
        data = json.decode(data1[1].data)
        if data.sold == true then
            exports['deniz-keypad']:PasswordInput(tonumber(data.password), function(result)
                --print(result.status, result.given, data.password)
                if result.status == true and result.given ~= nil and tonumber(data.password) ~= nil and tonumber(result.given) == tonumber(data.password) then
                    local plyloc = GetEntityCoords(PlayerPedId())
                    currentHouseUp = plyloc
                    QBCore.Functions.Notify(closestStash.." numaralı stashhouse'a girdin.", "success")
                    -- local generator = {x = curHouseCoords["x"], y = curHouseCoords["y"], z = curHouseCoords["z"]}
                    curHouseCoords = {x = plyloc.x, y = plyloc.y, z = plyloc.z-16}
                    buildBasicHouse({x = plyloc.x, y = plyloc.y, z = plyloc.z-16}, closestStash)
                    inhouse = true
                    while inhouse do
                        Citizen.Wait(0)
                        local playerCoords = GetEntityCoords(PlayerPedId(), true) 
                        if GetDistanceBetweenCoords(playerCoords, curHouseCoords.x-4.3, curHouseCoords.y-5, curHouseCoords.z+1, true) < 3 then
                            DrawText3Ds(curHouseCoords.x-4.3, curHouseCoords.y-5, curHouseCoords.z+1,"~g~E~s~ - Dolap ")
                            if IsControlJustPressed(0, 38) then
                                --print('dolap')
                            end
                        end
                        if GetDistanceBetweenCoords(playerCoords, curHouseCoords.x+7, curHouseCoords.y-0.4, curHouseCoords.z+1, true) < 3 then
                            DrawText3Ds(curHouseCoords.x+7, curHouseCoords.y-0.4, curHouseCoords.z+1,"~g~E~s~ - Depo ")
                            if IsControlJustPressed(0, 38) then
                                TriggerEvent("inventory:client:openhousestash", closestStash.."stashhouse")
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", closestStash.."stashhouse", {maxweight = 1000000,slots = 50})
                            end
                        end
                    end
                else 
                    TriggerServerEvent('keypad:maymun', GetPlayerServerId(PlayerPedId()))
                end
            end)
        else
            TriggerEvent("qb-menu:sendMenu", {
                {
                    id = 1,
                    header = "Stashhouse Satın Al",
                    txt = "$"..data.price.." | Numara: "..closestStash,
                    icon = 'fas fa-warehouse',
                    params = {
                        event = "deniz-stashhouse:buyst",
                        args = {
                            id = closestStash,
                            price = data.price
                        }
                    }
                }
            })
        end
    end
end)

RegisterNetEvent('deniz-stashhouse:buyst', function(data)
    local id, price = data.id, data.price
    exports['deniz-keypad']:PasswordInput('setpass', function(status)
        --print(status.status, status.given)
        if status.status == true and status.given ~= nil then
            --print(status.status, status.given)
            QBCore.Functions.TriggerCallback('deniz-stashhouse:buyStash', function(result)
                --print(result)
                if result == true then
                    QBCore.Functions.Notify('Stashhouse satın alındı.', 'success')
                else 
                    QBCore.Functions.Notify('Stashhouse almak için yeterli paran yok. (Banka)', 'error')
                end
            end, price, status.given, id)
        end
    end)
end)

local building = nil

function buildBasicHouse(generator, id)
    currentHouseIn = {generator, id}
    TriggerServerEvent('deniz-stashhouse:newBucket', id)
    DoScreenFadeOut(100)
    Citizen.Wait(3000)
    FreezeEntityPosition(PlayerPedId(), true)
    building = CreateObject(GetHashKey("shell_v16mid"), generator.x, generator.y-0.05, generator.z, false, false, false)
    FreezeEntityPosition(building, true)
    SetEntityCoords(PlayerPedId(), generator.x+1.3, generator.y-14, generator.z)
    SetEntityHeading(PlayerPedId(), 357.106)
    DoScreenFadeIn(100)
    Citizen.Wait(200)
    FreezeEntityPosition(PlayerPedId(),false)
end

RegisterNetEvent('deniz-stashhouse:out', function()
    if inhouse == true then 
        inhouse = false
        DoScreenFadeOut(100)
        Citizen.Wait(200)
        DeleteObject(building)
        Citizen.Wait(800)
        TriggerServerEvent('deniz-stashhouse:defaultBucket')
        SetEntityCoords(PlayerPedId(), currentHouseUp.x, currentHouseUp.y, currentHouseUp.z-1)
        Citizen.Wait(2000)
        DoScreenFadeIn(100)
    end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 100)
end

function isInStash()
    return inhouse
end

exports('isInStash', isInStash)