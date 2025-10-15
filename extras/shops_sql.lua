-- Example SQL for adding ammo boxes to shops (if your server uses database-based shops)
-- Adjust table names and columns according to your specific shop system

-- Example for ox_inventory shops (if using database)
-- Usually ox_inventory uses Lua configs, but some servers use databases

-- Example for qb-shops or similar systems
INSERT INTO `shop_items` (`shop`, `item`, `price`, `amount`) VALUES
    ('ammunation', 'ammo-9-box', 150, 50),
    ('ammunation', 'ammo-45-box', 175, 50),
    ('ammunation', 'ammo-rifle-box', 200, 50),
    ('ammunation', 'ammo-rifle2-box', 250, 50),
    ('ammunation', 'ammo-shotgun-box', 225, 25),
    ('ammunation', 'ammo-sniper-box', 300, 25),
    ('ammunation', 'ammo-22-box', 100, 100),
    ('ammunation', 'ammo-50-box', 500, 20);

-- Example for ESX shops (esx_shops)
INSERT INTO `shops` (`store`, `item`, `price`) VALUES
    ('Ammunation', 'ammo-9-box', 150),
    ('Ammunation', 'ammo-45-box', 175),
    ('Ammunation', 'ammo-rifle-box', 200),
    ('Ammunation', 'ammo-rifle2-box', 250),
    ('Ammunation', 'ammo-shotgun-box', 225),
    ('Ammunation', 'ammo-sniper-box', 300),
    ('Ammunation', 'ammo-22-box', 100),
    ('Ammunation', 'ammo-50-box', 500);

-- Note: Most modern servers use Lua-based shop configs instead of SQL
-- Check your shop system's documentation for the correct method