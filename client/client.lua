local QBCore = exports['qb-core']:GetCoreObject()
--Basic--
local PlayerLoaded = false
local PlayerJob = {}
local npcID = nil

function FloatNotify(PedEnt, entry)
	local uniqueNess = math.random(1,100000)
	Citizen.CreateThread(function()
		local timeInMs = 250
		while true do
			local pedCoords = GetEntityCoords(PedEnt)
			local x2,y2,z2 = table.unpack(pedCoords)
			local finalCoords = vector3(x2,y2,z2+0.9)
			AddTextEntry("nagodo_drugsale:Text"..uniqueNess, entry)
			Wait(1)
			timeInMs = timeInMs-1
			SetFloatingHelpTextWorldPosition(1, finalCoords)
			SetFloatingHelpTextStyle(1, 1, 64, -1, 3, 0)
			BeginTextCommandDisplayHelp("nagodo_drugsale:Text"..uniqueNess)
			EndTextCommandDisplayHelp(2, false, false, -1)
			if timeInMs <= 0 then
				break
			end
		end
	end)
end
function reformatInt(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
    .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    exports['qb-target']:RemoveTargetEntity(npcID, Config.Locale[Config.Lang].WhatsInBox)
    DeleteEntity(npcID)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	PlayerLoaded = true
end)

CreateThread(function()
    Wait(100)
    local hash = GetHashKey(Config.PedModel)
	RequestModel(hash) while not HasModelLoaded(hash) do  Wait(1) end
    local PedCoords = Config.PedCoords
	local ped = CreatePed(2, hash, PedCoords.x, PedCoords.y, PedCoords.z - 1, PedCoords.w, false, true)
	npcID = ped
	Citizen.Wait(1000)
	SetEntityHeading(ped, PedCoords.w)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped,"WORLD_HUMAN_JANITOR",0, false)
    exports['qb-target']:AddTargetEntity(npcID, { -- The specified entity number
        options = { -- This is your options table, in this table all the options will be specified for the target to accept
        { -- This is the first table with options, you can make as many options inside the options table as you want
            num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
            type = "client", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
            event = "odessa_blackMarket:client:1", -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
            icon = 'fas fa-example', -- This is the icon that will display next to this trigger option
            label = Config.Locale[Config.Lang].WhatsInBox, -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
            npcPed = ped
        }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })
    Wait(500)
    TriggerServerEvent("odessa_blackMarket:server:requestConf")
end)


local isConfigLoaded = false

RegisterNetEvent("odessa_blackMarket:client:Config", function(conf)
    isConfigLoaded = true
    Config.Items = conf
end)

RegisterNetEvent('odessa_blackMarket:client:1', function()
    local MenuOptions = {}
    if QBCore.Functions.GetPlayerData().gang.name ~= "none" then
        if isConfigLoaded then
            for k,v in pairs(Config.Items) do
                print(k)
                local itemData = QBCore.Shared.Items[k:lower()]
                if itemData == nil then
                    itemData = QBCore.Shared.Weapons[k:lower()]
                end
                if v.amount > 0 then
                    table.insert(MenuOptions,{
                        title = itemData.label, 
                        description = v.amount..Config.Locale[Config.Lang].StockPrice..reformatInt(v.price),
                        icon = 'check',
                        event = 'odessa_blackMarket:client:2',
                        arrow = true,
                            args = {
                                itemData = itemData,
                                itemName = k,
                                itemConf = v
                            }
                        })
                else
                    table.insert(MenuOptions,{
                        title = itemData.label,
                        description = Config.Locale[Config.Lang].OutOfStock,
                        icon = 'xmark',
                        disabled = true
                    })
                end
            end
            FloatNotify(npcID,Config.Locale[Config.Lang].Greetings)
            lib.registerContext({
                id = 'BM_MENU',
                title = Config.Locale[Config.Lang].NPCName,
                options = MenuOptions
            })
            lib.showContext('BM_MENU')
        end
    else
        FloatNotify(npcID,Config.Locale[Config.Lang].NoGang)
    end
end)
local wepEnt = nil
RegisterNetEvent('odessa_blackMarket:client:2', function(data)
    local price = data.itemConf.price
    local itemLabel = data.itemData.label
    local alert = lib.alertDialog({
        header = npcID, Config.Locale[Config.Lang].WonnaTrade,
        content = itemLabel..Config.Locale[Config.Lang].Is..reformatInt(price)..Config.Locale[Config.Lang].Currency,
        centered = true,
        cancel = true
    })
            
    if alert ~= "cancel" then
        FloatNotify(npcID,Config.Locale[Config.Lang].FindItForYou)
        ClearPedTasks(npcID)
        Wait(1000)
        SetEntityHeading(npcID,Config.LookH)
        FreezeEntityPosition(npcID, false)
        TaskStartScenarioInPlace(npcID,"PROP_HUMAN_BUM_BIN",0, false)
        Wait(5000)
        ClearPedTasks(npcID)
        Wait(3000)
        TaskTurnPedToFaceEntity(npcID,PlayerPedId(),-1)
        Wait(2000)
        ClearPedTasks(npcID)
        Wait(500)
        FreezeEntityPosition(npcID, true)
        TriggerServerEvent("odessa_blackMarket:server:try",data.itemName)
    else
        FloatNotify(npcID,Config.Locale[Config.Lang].RejectedBuy)
    end
end)

RegisterNetEvent('odessa_blackMarket:client:3', function()
    FloatNotify(npcID,Config.Locale[Config.Lang].Greetings)
    Wait(1000)
    TaskStartScenarioInPlace(ped,"WORLD_HUMAN_JANITOR",0, false)
end)
