-- Ammo Box Items for ox_inventory
-- Add these to your ox_inventory/data/items.lua file
-- The script will AUTOMATICALLY handle any item ending with '-box'
-- No need to define them in config.lua!

-- 9mm Ammo Box
['ammo-9-box'] = {
    label = '9mm Ammo Box',
    weight = 500,
    stack = true,
    close = true,
    description = 'A sealed box containing 50 rounds of 9mm ammunition',
    client = {
        image = 'ammo-9-box.png',
        usetime = 2500, -- This creates ox_inventory's built-in progress bar
    },
    server = {
        export = 'fosty_ammo.ammobox', -- This connects to the script automatically
    },
    metadata = { ammo_count = 12 } -- Optional: Override default amount (50) by adding metadata
},

-- Here is other default examples.

-- .45 ACP Ammo Box
['ammo-45-box'] = {
    label = '.45 ACP Ammo Box',
    weight = 550,
    stack = true,
    close = true,
    description = 'A sealed box containing 50 rounds of .45 ACP ammunition',
    client = {
        image = 'ammo-45-box.png',
        usetime = 2500,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

-- Rifle Ammo Box
['ammo-rifle-box'] = {
    label = 'Rifle Ammo Box',
    weight = 600,
    stack = true,
    close = true,
    description = 'A sealed box containing 50 rounds of rifle ammunition',
    client = {
        image = 'ammo-rifle-box.png',
        usetime = 2500,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

-- Advanced Rifle Ammo Box
['ammo-rifle2-box'] = {
    label = 'Advanced Rifle Ammo Box',
    weight = 620,
    stack = true,
    close = true,
    description = 'A sealed box containing 50 rounds of advanced rifle ammunition',
    client = {
        image = 'ammo-rifle2-box.png',
        usetime = 2500,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

-- Shotgun Shell Box
['ammo-shotgun-box'] = {
    label = 'Shotgun Shell Box',
    weight = 700,
    stack = true,
    close = true,
    description = 'A sealed box containing 25 shotgun shells',
    client = {
        image = 'ammo-shotgun-box.png',
        usetime = 2500,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

-- Sniper Ammo Box  
['ammo-sniper-box'] = {
    label = 'Sniper Ammo Box',
    weight = 800,
    stack = true,
    close = true,
    description = 'A sealed box containing 25 rounds of sniper ammunition',
    client = {
        image = 'ammo-sniper-box.png',
        usetime = 2500,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

-- .22 LR Ammo Box
['ammo-22-box'] = {
    label = '.22 LR Ammo Box',
    weight = 300,
    stack = true,
    close = true,
    description = 'A sealed box containing 100 rounds of .22 LR ammunition',
    client = {
        image = 'ammo-22-box.png',
        usetime = 2500,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

-- .50 Cal Ammo Box
['ammo-50-box'] = {
    label = '.50 Cal Ammo Box',
    weight = 1000,
    stack = true,
    close = true,
    description = 'A sealed box containing 20 rounds of .50 caliber ammunition',
    client = {
        image = 'ammo-50-box.png',
        usetime = 2500,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

--[[
    ========================================
    HOW IT WORKS:
    ========================================
    
    1. ANY item ending with '-box' will automatically be handled
    2. The script removes '-box' from the name to find output ammo
    3. Example: 'ammo-9-box' -> outputs 'ammo-9'
    
    TO ADD A NEW AMMO BOX:
    ----------------------
    1. Add the box item (name MUST end with '-box')
    2. Add 'usetime' in client table (for ox_inventory progress bar)
    3. Add server.export = 'fosty_ammo.ammobox'
    4. Make sure the output ammo exists (without '-box')
    5. Done! No config.lua editing needed!
    
    PROGRESS BAR & ANIMATIONS:
    --------------------------
    - 'usetime' creates ox_inventory's native progress bar
    - The script handles animations separately via config.lua
    - DON'T add 'anim' in the item - it conflicts with the script
    - metadata alters the ammo given by the ammobox
    
    EXAMPLE - Adding Musket Ammo:
    ----------------------
    
    ['ammo-musket-box'] = {
        label = 'Musket Ball Box',
        weight = 400,
        stack = true,
        close = true,
        description = 'A box of musket balls',
        client = {
            usetime = 2500,
        },
        server = {
            export = 'fosty_ammo.ammobox',
        },
    },
    
    ['ammo-musket'] = {  -- Output ammo (without '-box')
        label = 'Musket Balls',
        weight = 8,
        stack = true,
    },
]]

--[[
    ========================================
    AMMO ITEMS (Output items)
    ========================================
    Make sure these exist and match your weapon system!
]]

['ammo-9'] = {
    label = '9mm Ammo',
    weight = 10,
    stack = true,
    close = false,
    description = '9mm ammunition rounds',
    client = {
        image = 'ammo-9.png',
    },
},

['ammo-45'] = {
    label = '.45 ACP Ammo',
    weight = 11,
    stack = true,
    close = false,
    description = '.45 ACP ammunition rounds',
    client = {
        image = 'ammo-45.png',
    },
},

['ammo-rifle'] = {
    label = 'Rifle Ammo',
    weight = 12,
    stack = true,
    close = false,
    description = 'Rifle ammunition rounds',
    client = {
        image = 'ammo-rifle.png',
    },
},

['ammo-rifle2'] = {
    label = 'Advanced Rifle Ammo',
    weight = 12,
    stack = true,
    close = false,
    description = 'Advanced rifle ammunition rounds',
    client = {
        image = 'ammo-rifle2.png',
    },
},

['ammo-shotgun'] = {
    label = 'Shotgun Shells',
    weight = 14,
    stack = true,
    close = false,
    description = 'Shotgun shell ammunition',
    client = {
        image = 'ammo-shotgun.png',
    },
},

['ammo-sniper'] = {
    label = 'Sniper Ammo',
    weight = 16,
    stack = true,
    close = false,
    description = 'Sniper rifle ammunition rounds',
    client = {
        image = 'ammo-sniper.png',
    },
},

['ammo-22'] = {
    label = '.22 LR Ammo',
    weight = 6,
    stack = true,
    close = false,
    description = '.22 Long Rifle ammunition rounds',
    client = {
        image = 'ammo-22.png',
    },
},

['ammo-50'] = {
    label = '.50 Cal Ammo',
    weight = 20,
    stack = true,
    close = false,
    description = '.50 caliber ammunition rounds',
    client = {
        image = 'ammo-50.png',
    },
},