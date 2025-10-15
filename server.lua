-- Framework Detection
local Framework = nil
local FrameworkName = nil

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        FrameworkName = Config.Framework
        if FrameworkName == 'qbox' or FrameworkName == 'qbcore' then
            local success, result = pcall(function()
                return exports['qbx_core']:GetCoreObject()
            end)
            if success and result then
                Framework = result
            else
                success, result = pcall(function()
                    return exports['qb-core']:GetCoreObject()
                end)
                if success and result then
                    Framework = result
                end
            end
        elseif FrameworkName == 'esx' then
            local success, result = pcall(function()
                return exports['es_extended']:getSharedObject()
            end)
            if success and result then
                Framework = result
            end
        end
    else
        -- Auto-detect framework
        if GetResourceState('qbx_core') == 'started' then
            FrameworkName = 'qbox'
            local success, result = pcall(function()
                return exports['qbx_core']:GetCoreObject()
            end)
            if success and result then
                Framework = result
            end
        elseif GetResourceState('qb-core') == 'started' or GetResourceState('qb_core') == 'started' then
            FrameworkName = 'qbcore'
            local success, result = pcall(function()
                return exports['qb-core']:GetCoreObject()
            end)
            if success and result then
                Framework = result
            else
                success, result = pcall(function()
                    return exports['qb_core']:GetCoreObject()
                end)
                if success and result then
                    Framework = result
                end
            end
        elseif GetResourceState('es_extended') == 'started' then
            FrameworkName = 'esx'
            local success, result = pcall(function()
                return exports['es_extended']:getSharedObject()
            end)
            if success and result then
                Framework = result
            end
        end
    end
    
    if Config.Debug then
        print('^3[AmmoBox]^7 Framework detected: ^2' .. (FrameworkName or 'none') .. '^7')
    end
    
    if not Framework and FrameworkName then
        print('^3[AmmoBox]^7 ^1WARNING:^7 Framework "' .. FrameworkName .. '" detected but could not load core object. Notifications may not work.')
    end
end

-- Get output ammo item name from box name
local function GetOutputAmmo(boxName)
    local outputAmmo = boxName:gsub(Config.BoxSuffix .. '$', '')
    
    if Config.Debug then
        print('^3[AmmoBox]^7 Box: ' .. boxName .. ' -> Output: ' .. outputAmmo)
    end
    
    return outputAmmo
end

-- Get amount from item metadata or use default
local function GetAmmoAmount(metadata)
    if metadata and metadata.ammo_count then
        return metadata.ammo_count
    end
    return Config.DefaultAmount
end

-- Send Notification Function
local function SendNotification(source, message, type)
    if Config.UseOxLib and GetResourceState('ox_lib') == 'started' then
        TriggerClientEvent('ox_lib:notify', source, {
            description = message,
            type = type or 'info'
        })
    elseif Framework then
        if FrameworkName == 'qbox' or FrameworkName == 'qbcore' then
            TriggerClientEvent('QBCore:Notify', source, message, type or 'primary')
        elseif FrameworkName == 'esx' then
            TriggerClientEvent('esx:showNotification', source, message)
        end
    else
        if GetResourceState('ox_lib') == 'started' then
            TriggerClientEvent('ox_lib:notify', source, {
                description = message,
                type = type or 'info'
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 255, 255},
                multiline = true,
                args = {"AmmoBox", message}
            })
        end
    end
end

-- Main function to process ammo box
local function ProcessAmmoBox(source, itemName, metadata)
    local outputAmmo = GetOutputAmmo(itemName)
    local amount = GetAmmoAmount(metadata)
    
    local outputItem = exports.ox_inventory:Items(outputAmmo)
    if not outputItem then
        if Config.Debug then
            print('^3[AmmoBox]^7 ^1ERROR:^7 Output ammo "' .. outputAmmo .. '" does not exist in ox_inventory items!')
        end
        SendNotification(source, Config.Locale['error_no_output'], 'error')
        return false
    end
    
    -- Check if player can carry the ammo
    if not exports.ox_inventory:CanCarryItem(source, outputAmmo, amount) then
        SendNotification(source, Config.Locale['error_no_space'], 'error')
        return false
    end
    
    -- Remove the box
    if exports.ox_inventory:RemoveItem(source, itemName, 1) then
        -- Add the ammo
        if exports.ox_inventory:AddItem(source, outputAmmo, amount) then
            SendNotification(source, string.format(Config.Locale['success'], amount), 'success')
            
            if Config.Debug then
                print(string.format('^3[AmmoBox]^7 Player %s opened %s and received %s x%s', source, itemName, outputAmmo, amount))
            end
            return true
        else
            -- Failed to add, return the box
            exports.ox_inventory:AddItem(source, itemName, 1)
            SendNotification(source, Config.Locale['error_generic'], 'error')
            return false
        end
    else
        SendNotification(source, Config.Locale['error_generic'], 'error')
        return false
    end
end

-- Export for ox_inventory items.lua
exports('ammobox', function(event, item, inventory, slot, data)
    if event ~= 'usingItem' then return end
    
    local source = inventory.id
    
    -- Trigger animation on client if enabled
    if Config.EnableAnimations then
        TriggerClientEvent('fosty_ammo:client:playAnimation', source)
    end
    
    -- ox_inventory has its own progress bar (usetime in item definition)
    -- We only use our progress bar for ESX or if explicitly enabled
    if Config.UseProgressBar and GetResourceState('ox_lib') == 'started' then
        -- ESX mode - use custom progress bar
        TriggerClientEvent('fosty_ammo:client:progressBar', source, item.name, item.metadata)
    else
        -- ox_inventory mode - just wait for the animation/usetime
        local duration = Config.Animation.duration or 2500
        SetTimeout(duration, function()
            ProcessAmmoBox(source, item.name, item.metadata)
        end)
    end
end)

-- Process Box Event (called after progress bar completes)
RegisterServerEvent('fosty_ammo:server:processBox', function(itemName, metadata)
    local src = source
    ProcessAmmoBox(src, itemName, metadata)
end)

-- Initialize
CreateThread(function()
    DetectFramework()
    
    if not Framework then
        print('^3[AmmoBox]^7 ^3INFO:^7 No framework detected. Using ox_lib for notifications.')
        print('^3[AmmoBox]^7 ^3INFO:^7 Make sure ox_lib is installed for proper notifications.')
    end
    
    if GetResourceState('ox_inventory') ~= 'started' then
        print('^3[AmmoBox]^7 ^1ERROR:^7 ox_inventory is required but not started!')
        return
    end
    
    print('^3[AmmoBox]^7 ^2Successfully initialized!^7')
    print('^3[AmmoBox]^7 Any item ending with "' .. Config.BoxSuffix .. '" will be automatically handled')
    if Config.Debug then
        print('^3[AmmoBox]^7 Debug mode is ^2enabled^7')
    end
end)