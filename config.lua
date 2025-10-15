Config = {}

-- Framework Settings
-- Set to 'auto' for automatic detection, or manually set to 'qbox', 'qbcore', or 'esx'
Config.Framework = 'auto'

-- Inventory System
Config.Inventory = 'ox_inventory' -- Only ox_inventory supported for this version

-- Notification Settings
Config.UseOxLib = true -- Use ox_lib for notifications (recommended for QBox)

-- Animation Settings
Config.EnableAnimations = true
Config.Animation = {
    dict = 'mp_common',
    anim = 'givetake1_a',
    flag = 49,
    duration = 2500 -- milliseconds
}

-- Progress Bar Settings
-- ox_inventory has built-in progress bars, so we disable ours when using it
-- Enable this only if you're using ESX without ox_inventory's native progress
Config.UseProgressBar = false

-- Ammo Box Detection Pattern
-- The script will automatically handle any item that matches this pattern
-- Default: any item ending with '-box' will be treated as an ammo box
-- The output ammo will be the same name without '-box'
-- Example: 'ammo-9-box' -> 'ammo-9'
Config.BoxSuffix = '-box'

-- Alternative: Use a prefix pattern
-- Config.BoxPattern = '^ammo%-(.+)%-box$' -- Regex pattern (advanced)

-- Default Amount if not specified in item metadata
Config.DefaultAmount = 50

-- Notification Messages
Config.Locale = {
    ['success'] = 'You opened the ammo box and received %s rounds',
    ['error_no_space'] = 'You don\'t have enough space in your inventory',
    ['error_generic'] = 'Something went wrong while opening the ammo box',
    ['error_no_output'] = 'Could not find output ammo for this box',
    ['cancelled'] = 'Action cancelled'
}

-- Debug Mode
Config.Debug = true