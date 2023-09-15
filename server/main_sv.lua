QBCore = exports['qb-core']:GetSharedObject()

QBCore.Functions.CreateCallback('deniz-stashhouse:createStashhouse', function(source, cb, data)
    if data then
        local newData = data
        exports.ghmattimysql:execute('INSERT INTO stashhouse (`coords`, `data`) VALUES (@coords, @data)',{
            ['@coords'] = json.encode(newData.coords),
            ['@data'] = json.encode(newData.data)
        }) 
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('deniz-stashhouse:getStashhouses', function(source, cb)
    local all = exports.ghmattimysql:executeSync('SELECT * FROM stashhouse',{
        ['@price'] = 0
    })
    cb(all)
end)

QBCore.Functions.CreateCallback('deniz-stashhouse:getStashhouse:byId', function(source, cb, data)
    local housepass = exports.ghmattimysql:executeSync('SELECT data FROM stashhouse WHERE id = @id',{
        ['@id'] = data
    })
    cb(housepass)
end)

QBCore.Functions.CreateCallback('deniz-stashhouse:buyStash', function(source, cb, pricedata, passdata, id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    --print(pricedata, passdata, id)
    if Player.Functions.RemoveMoney('bank', pricedata, 'Stashhouse satın alındı.') then
        local oldData = exports.ghmattimysql:executeSync('SELECT data FROM stashhouse WHERE id = @id',{
            ['@id'] = data
        })
        local newData = {
            price = pricedata,
            password = passdata,
            sold = true
        }
        exports.ghmattimysql:executeSync('UPDATE stashhouse SET data = @data WHERE id = @id', {
            ['@data'] = json.encode(newData),
            ['@id'] = id
        })
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("deniz-stashhouse:newBucket")
AddEventHandler("deniz-stashhouse:newBucket", function(id)
    local src = source
    --local bucket = math.random(1000, 10000)
    SetPlayerRoutingBucket(src, id)
end)


RegisterServerEvent("deniz-stashhouse:defaultBucket")
AddEventHandler("deniz-stashhouse:defaultBucket", function()
    local src = source
    --local bucket = math.random(1000, 10000)
    SetPlayerRoutingBucket(src, 0)
end)