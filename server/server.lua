local QBCore = exports['qb-core']:GetCoreObject()
local itemsRestock = {}
local originalConfig = Config.Items
local currentlyRepairing = false
local currentWeapon = nil
local currentWeaponData = nil
local timeLeft = Config.RepairTime
local repairId = 0
local RepairCheck = {}
local busy = false
RegisterNetEvent('odessa_blackMarket:server:requestConf', function()
   local src = source
   TriggerClientEvent("odessa_blackMarket:client:Config", src, Config.Items)
end)

function reformatInt(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
    .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

RegisterNetEvent('odessa_blackMarket:server:try', function(item)
    local src = source
    if not busy then 
        busy = true
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local confItem = nil
        for k, v in pairs(Config.Items) do
            if k == item then
                if v.amount > 0 then
                    confItem = v
                end
            end
        end
        local qbItem = QBCore.Shared.Items[item:lower()]
        if qbItem == nil then qbItem = QBCore.Shared.Weapons[item:lower()] end
        if confItem ~= nil then
            if xPlayer.Functions.RemoveMoney('cash', confItem.price, "black-market") then
                if xPlayer.Functions.AddItem(item, 1) then
                    TriggerClientEvent("inventory:client:ItemBox", source, qbItem, "add")
                    Config.Items[item].amount = Config.Items[item].amount-1
                    table.insert(itemsRestock,{timer = Config.Items[item].restockTimer, name = item})
                    TriggerClientEvent("odessa_blackMarket:client:Config", src, Config.Items)
                    TriggerClientEvent("QBCore:Notify", src,Config.Locale[Config.Lang].Boughta..qbItem.label..Config.Locale[Config.Lang].For..reformatInt(confItem.price)..Config.Locale[Config.Lang].Currency, "success", 5000)
                else
                    TriggerClientEvent("QBCore:Notify", src, Config.Locale[Config.Lang].NotEnoughSpace, "error", 5000)
                    xPlayer.Functions.AddMoney('cash', confItem.price, "black-market-return")
                end
            else
                TriggerClientEvent("QBCore:Notify", src,Config.Locale[Config.Lang].NotEnoughCash, "error", 5000)
            end
        end
        Wait(5000)
        busy = false
    else
        TriggerClientEvent("QBCore:Notify", src,Config.Locale[Config.Lang].Busy, "error", 5000)
    end 
    TriggerClientEvent("odessa_blackMarket:client:3", src)
    TriggerClientEvent("odessa_blackMarket:client:Config", -1, Config.Items)
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(itemsRestock) do
            if v ~= nil then
                v.timer = v.timer-1
                if v.timer < 1 then
                    Config.Items[v.name].amount = Config.Items[v.name].amount+1
                    itemsRestock[k] = nil
                    TriggerClientEvent("odessa_blackMarket:client:Config", -1, Config.Items)
                end
            end
        end
        Wait(60000*60)
    end
end)

