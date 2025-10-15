-- Client-side animation handling

local isProcessing = false

-- Stop Animation
local function StopAnimation()
    if not isProcessing then return end
    
    isProcessing = false
    local ped = PlayerPedId()
    
    ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
end

-- Play Animation
local function PlayAnimation()
    if not Config.EnableAnimations then return end
    if isProcessing then return end
    
    isProcessing = true
    
    local ped = PlayerPedId()
    local animDict = Config.Animation.dict
    local animName = Config.Animation.anim
    local duration = Config.Animation.duration or 2500
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
    
    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, duration, Config.Animation.flag or 16, 0, false, false, false)
    
    SetTimeout(duration, function()
        StopAnimation()
    end)
end

-- Animation Event (called from server when item is used)
RegisterNetEvent('fosty_ammo:client:playAnimation', function()
    PlayAnimation()
end)

-- Progress Bar Event (only used for ESX or when explicitly enabled)
RegisterNetEvent('fosty_ammo:client:progressBar', function(itemName, metadata)
    if not Config.UseProgressBar then
        -- ox_inventory handles its own progress, just play animation
        PlayAnimation()
        return
    end
    
    -- ESX or custom progress bar
    if lib then
        if lib.progressBar({
            duration = Config.Animation.duration,
            label = 'Opening ammo box...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = Config.Animation.dict,
                clip = Config.Animation.anim
            },
        }) then
            -- Success
            TriggerServerEvent('fosty_ammo:server:processBox', itemName, metadata)
        else
            -- Cancelled
            StopAnimation()
            if Config.UseOxLib then
                lib.notify({
                    description = Config.Locale['cancelled'],
                    type = 'error'
                })
            end
        end
    else
        -- Fallback without ox_lib - just use animation timer
        PlayAnimation()
        SetTimeout(Config.Animation.duration, function()
            TriggerServerEvent('fosty_ammo:server:processBox', itemName, metadata)
        end)
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    StopAnimation()
end)