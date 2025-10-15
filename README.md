# Fosty AmmoBox - QBox Edition

**Truly plug-and-play ammo box system for QBox/QBCore with ox_inventory**

## 🎯 The Smart Way

This script is **automatic** - you only need to add items to ox_inventory's items.lua!

### How It Works

1. **Name your box item ending with `-box`** (e.g., `ammo-9-box`)
2. **Add `server.export = 'fosty_ammo.ammobox'`** to the item
3. **Make sure the output ammo exists** (e.g., `ammo-9`)
4. **Done!** No config editing needed!

The script automatically:
- Detects any item ending with `-box`
- Removes `-box` from the name to find output ammo
- Gives the player the ammo with configurable amounts

## ✨ Features

✅ **Automatic Detection** - No need to define boxes in config
✅ **Framework Support** - Auto-detects QBox, QBCore, or ESX  
✅ **ox_inventory Native** - Uses proper exports and hooks
✅ **Animations** - Smooth opening animations with progress bars
✅ **Lightweight** - 0.00ms idle, minimal code
✅ **Flexible** - Easy to add new ammo types

## 📦 Installation

### 1. Copy Files
```
resources/[custom]/fosty_ammo/
├── fxmanifest.lua
├── config.lua
├── server/main.lua
└── client/main.lua
```

### 2. Add Items to ox_inventory

Open `ox_inventory/data/items.lua` and add:

```lua
['ammo-9-box'] = {
    label = '9mm Ammo Box',
    weight = 500,
    stack = true,
    close = true,
    description = 'Contains 50 rounds of 9mm ammo',
    server = {
        export = 'fosty_ammo.ammobox', -- This is the magic line!
    },
},

['ammo-9'] = { -- The output ammo (without '-box')
    label = '9mm Ammo',
    weight = 10,
    stack = true,
},
```

### 3. Add to server.cfg

```cfg
ensure ox_lib
ensure ox_inventory
ensure fosty_ammo
```

### 4. Restart

```bash
restart ox_inventory
ensure fosty_ammo
```

## 🎮 Usage

1. Get an ammo box: `/giveitem [id] ammo-9-box 1`
2. Open inventory and use the box
3. Receive 50 rounds of ammo automatically!

## ⚙️ Configuration

### Change Default Amount

In `config.lua`:
```lua
Config.DefaultAmount = 50 -- All boxes give 50 rounds by default
```

### Change Box Pattern

Want boxes to be named differently?

```lua
Config.BoxSuffix = '-crate' -- Now 'ammo-9-crate' -> 'ammo-9'
```

### Disable Animations

```lua
Config.EnableAnimations = false
Config.UseProgressBar = false
```

## 🆕 Adding New Ammo Types

### Example: Adding Musket Ammo

**1. Add to ox_inventory/data/items.lua:**

```lua
['ammo-musket-box'] = {
    label = 'Musket Ball Box',
    weight = 400,
    stack = true,
    close = true,
    description = 'A box of ye olde musket balls',
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

['ammo-musket'] = {
    label = 'Musket Balls',
    weight = 8,
    stack = true,
},
```

**2. Restart:**
```bash
restart ox_inventory
```

**That's it!** No config editing needed!

## 🏪 Adding to Shops

### ox_inventory Shop

Edit `ox_inventory/data/shops.lua`:

```lua
Ammunation = {
    name = 'Ammunation',
    inventory = {
        { name = 'ammo-9-box', price = 150 },
        { name = 'ammo-45-box', price = 175 },
        { name = 'ammo-rifle-box', price = 200 },
    },
    locations = {
        vec3(-662.180, -934.961, 21.829),
    },
},
```

### qb-shops

```lua
["weapons"] = {
    [1] = { name = "ammo-9-box", price = 150, amount = 50, info = {}, type = "item", slot = 1 },
}
```

## 🔧 Advanced Features

### Per-Item Amount Override

Want a specific box to give different amounts?

```lua
['ammo-sniper-box'] = {
    label = 'Sniper Ammo Box',
    -- ... other properties
    metadata = {
        ammo_count = 25 -- This box gives 25 rounds instead of default
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},
```

### Custom Output Mapping

Want `special-ammo-box` to output `ammo-special` instead?

The script automatically removes `-box`, so:
- `ammo-9-box` → `ammo-9` ✅
- `special-ammo-box` → `special-ammo` ✅
- `rifle-rounds-box` → `rifle-rounds` ✅

Just name your items logically!

## 🐛 Troubleshooting

### Box doesn't work

**Check:**
1. Does the box name end with `-box`?
2. Is `server.export = 'fosty_ammo.ammobox'` present?
3. Does the output ammo exist? (box name without `-box`)
4. Did you restart ox_inventory?

**Enable debug:**
```lua
Config.Debug = true
```

### Framework not detected

```lua
Config.Framework = 'qbox' -- Manually set
```

## 📊 Performance

- **Idle**: 0.00ms
- **Opening**: ~0.01ms  
- **Memory**: ~0.3MB

## 💡 Pro Tips

1. **Naming Convention**: Use `ammo-X-box` format for consistency
2. **Economics**: Price boxes slightly cheaper than buying individual rounds
3. **Weight**: Make boxes heavier to prevent hoarding
4. **Shops**: Add boxes to gun stores, not general stores

## 🎨 Item Images

Add images to `ox_inventory/web/images/`:
- `ammo-9-box.png`
- `ammo-45-box.png`
- etc.

Recommended size: 256x256px PNG with transparency

## 📋 Complete Example

```lua
-- In ox_inventory/data/items.lua

-- THE BOX (what players use)
['ammo-9-box'] = {
    label = '9mm Ammo Box',
    weight = 500,
    stack = true,
    close = true,
    description = 'Contains 50 rounds of 9mm ammunition',
    client = {
        image = 'ammo-9-box.png',
    },
    server = {
        export = 'fosty_ammo.ammobox', -- Connect to script
    },
},

-- THE OUTPUT AMMO (what they receive)
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
```

## 🆘 Support

1. Enable debug mode: `Config.Debug = true`
2. Check console for errors
3. Verify item names match exactly
4. Make sure ox_inventory is updated

## 📜 Credits

- **Original**: Fosty
- **QBox Conversion**: Simplified and enhanced for modern standards

## 📝 Changelog

### v2.0.0 - Smart Edition
- ✨ Automatic item detection (no config needed!)
- ✨ ox_inventory native integration
- ✨ QBox/QBCore/ESX support
- ✨ Animations & progress bars
- ✨ Debug mode

### v1.0.0
- Initial ESX release

## 📄 License

Free to use and modify!
