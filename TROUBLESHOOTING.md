# 🔧 Troubleshooting Guide - Fosty AmmoBox

## 📋 Quick Diagnostics

Before diving into specific issues, run these checks:

### 1. Enable Debug Mode
```lua
-- In config.lua
Config.Debug = true
```
This will show detailed logs in your server console.

### 2. Check Dependencies
```bash
# In server console
ensure ox_inventory
ensure ox_lib
ensure fosty_ammo
```

### 3. Verify Resource State
```bash
# Check if resources are running
status ox_inventory
status fosty_ammo
```

---

## 🚫 Common Issues & Solutions

### Issue #1: "No such export GetCoreObject"

**Error Message:**
```
SCRIPT ERROR: @fosty_ammobox/server.lua:20: No such export GetCoreObject in resource qb_core
```

**Causes:**
- Framework resource name mismatch
- Framework not started before script

**Solutions:**

1. **Check your framework resource name:**
```bash
# In server console
status qbx_core    # For QBox
status qb-core     # For QBCore
status qb_core     # Alternative QBCore name
```

2. **Manually set framework in config.lua:**
```lua
Config.Framework = 'qbox'  -- or 'qbcore', 'esx'
```

3. **Ensure correct load order in server.cfg:**
```cfg
# Framework must load first
ensure qbx_core
ensure ox_inventory
ensure ox_lib
ensure fosty_ammo
```

4. **If using a fork/custom framework:**
```lua
-- In config.lua, manually set:
Config.Framework = 'auto'  -- Let it try auto-detect
-- Or disable framework entirely (ox_lib will handle notifications)
```

---

### Issue #2: Animation Won't Stop / Loops Forever

**Symptoms:**
- Character keeps playing animation indefinitely
- Can't move or interact after using box

**Solutions:**

1. **Check animation flag in config.lua:**
```lua
Config.Animation = {
    dict = 'mp_common',
    anim = 'givetake1_a',
    flag = 16,  -- Should be 16, NOT 49!
    duration = 2500
}
```

2. **Disable animations temporarily:**
```lua
Config.EnableAnimations = false
```

3. **Clear stuck animation manually:**
```lua
-- Add this command for testing
RegisterCommand('clearanim', function()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
end, false)
```

4. **Restart client script:**
```bash
restart fosty_ammo
```

---

### Issue #3: Duplicate Progress Bars

**Symptoms:**
- Two progress bars appear when using ammo box
- One from ox_inventory, one from script

**Solution:**

**In config.lua:**
```lua
Config.UseProgressBar = false  -- Disable script's progress bar
```

**In ox_inventory/data/items.lua:**
```lua
['ammo-9-box'] = {
    -- ...
    client = {
        usetime = 2500,  -- This creates ox_inventory's progress bar
    },
}
```

**Note:** Only set `Config.UseProgressBar = true` if you're using ESX without ox_inventory's native progress.

---

### Issue #4: Invalid Animation Dictionary

**Error Message:**
```
attempted to load invalid animDict 'anim@scripted@...'
```

**Solution:**

1. **Use the default reliable animation:**
```lua
Config.Animation = {
    dict = 'mp_common',
    anim = 'givetake1_a',
    flag = 16,
    duration = 2500
}
```

2. **Or disable animations:**
```lua
Config.EnableAnimations = false
```

3. **Test animation before using:**
```lua
RegisterCommand('testanim', function()
    local ped = PlayerPedId()
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Wait(10)
    end
    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, 2500, 16, 0, false, false, false)
end)
```

---

### Issue #5: Box Doesn't Work / Nothing Happens

**Symptoms:**
- Click box, nothing happens
- No errors in console
- No progress bar appears

**Diagnostic Steps:**

1. **Check item definition in ox_inventory/data/items.lua:**
```lua
['ammo-9-box'] = {
    label = '9mm Ammo Box',
    weight = 500,
    stack = true,
    close = true,
    description = 'Contains 50 rounds',
    client = {
        image = 'ammo-9-box.png',
        usetime = 2500,  -- REQUIRED for progress
    },
    server = {
        export = 'fosty_ammo.ammobox',  -- REQUIRED - must be exact
    },
},
```

2. **Verify export name is correct:**
- Must be: `fosty_ammo.ammobox`
- Check your resource folder name matches `fosty_ammo`
- If different, change export to match: `your-folder-name.ammobox`

3. **Check if resource is registered:**
```bash
# In server console
refresh
ensure fosty_ammo
```

4. **Enable debug and check console:**
```lua
Config.Debug = true
```

5. **Restart ox_inventory:**
```bash
restart ox_inventory
restart fosty_ammo
```

---

### Issue #6: "Output ammo does not exist"

**Error in console:**
```
[AmmoBox] ERROR: Output ammo "ammo-9" does not exist in ox_inventory items!
```

**Solution:**

1. **Make sure output ammo exists in items.lua:**
```lua
-- Box item
['ammo-9-box'] = {
    label = '9mm Ammo Box',
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

-- Output ammo (MUST EXIST)
['ammo-9'] = {  -- Name without '-box'
    label = '9mm Ammo',
    weight = 10,
    stack = true,
},
```

2. **Verify naming convention:**
- Box: `ammo-9-box`
- Output: `ammo-9` (just remove `-box`)

3. **Check for typos:**
- `ammo-9-box` → `ammo-9` ✅
- `ammo-9-box` → `ammo9` ❌
- `ammo-9-box` → `ammo_9` ❌

---

### Issue #7: "You don't have enough space"

**Symptoms:**
- Box consumed but no ammo received
- Error message about inventory space

**Solutions:**

1. **Check player inventory weight:**
```lua
-- In config.lua, adjust box/ammo weights
['ammo-9-box'] = {
    weight = 500,  -- Box weight
}

['ammo-9'] = {
    weight = 10,  -- Each bullet weight (50 bullets = 500 total)
}
```

2. **Verify ox_inventory weight limits:**
- Check player max weight in ox_inventory config
- Default is usually 30000 (30kg)

3. **Test with empty inventory:**
- Clear inventory and try again

4. **Check stack limits:**
```lua
['ammo-9'] = {
    stack = true,  -- Make sure this is true
    close = false,
}
```

---

### Issue #8: Box Opens But No Ammo Given

**Symptoms:**
- Progress bar completes
- Box is consumed
- No ammo added to inventory
- No error messages

**Diagnostic Steps:**

1. **Enable debug mode:**
```lua
Config.Debug = true
```

2. **Check server console for:**
```
[AmmoBox] Player X opened ammo-9-box and received ammo-9 x50
```

3. **If you see the message but no ammo:**
- Check if ammo was added elsewhere (different inventory slot)
- Verify ammo item is visible (not hidden by inventory filters)

4. **Check ox_inventory exports:**
```lua
-- Test manually in server console
exports.ox_inventory:AddItem(1, 'ammo-9', 50)
```

5. **Verify metadata isn't blocking:**
```lua
-- In items.lua, remove any metadata requirements
['ammo-9'] = {
    label = '9mm Ammo',
    weight = 10,
    stack = true,
    -- No metadata requirements
}
```

---

### Issue #9: Script Not Loading

**Error Message:**
```
Could not load resource fosty_ammo
```

**Solutions:**

1. **Check folder structure:**
```
resources/
└── [custom]/
    └── fosty_ammo/    ← Folder name
        ├── fxmanifest.lua
        ├── config.lua
        ├── server/
        │   └── main.lua
        └── client/
            └── main.lua
```

2. **Verify fxmanifest.lua:**
```lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}
```

3. **Check for syntax errors:**
```bash
# In server console
restart fosty_ammo
# Look for red error messages
```

4. **Ensure dependencies exist:**
```cfg
# In server.cfg
ensure ox_lib
ensure ox_inventory
ensure fosty_ammo
```

---

### Issue #10: Framework Notifications Not Working

**Symptoms:**
- Everything works but no notifications appear
- Or notifications use chat instead of UI

**Solutions:**

1. **Force ox_lib notifications:**
```lua
Config.UseOxLib = true
```

2. **Check ox_lib is loaded:**
```bash
ensure ox_lib
```

3. **Test notification manually:**
```lua
-- In client console
lib.notify({description = 'Test', type = 'success'})
```

4. **Fallback to framework notifications:**
```lua
Config.UseOxLib = false
```

5. **Check QBCore notification event:**
```lua
-- Should be 'QBCore:Notify' for most versions
-- Some older versions use 'QBCore:Client:Notify'
```

---

### Issue #11: Custom Ammo Amount Not Working

**Symptoms:**
- Always gives default amount (50)
- Custom amounts ignored

**Solutions:**

1. **Change default in config.lua:**
```lua
Config.DefaultAmount = 100  -- All boxes give 100 unless specified
```

2. **Per-item amounts via item name:**
- Not currently supported
- All boxes of same type give same amount

3. **Workaround - Create separate box types:**
```lua
['ammo-9-box-small'] = {  -- 25 rounds
    -- Config.DefaultAmount will be used
}

['ammo-9-box-large'] = {  -- 100 rounds
    -- Would need custom logic
}
```

---

## 🔍 Advanced Debugging

### Enable Full Debug Output

```lua
-- config.lua
Config.Debug = true
```

### Check Item Registration

```lua
-- Server console
lua exports.ox_inventory:Items('ammo-9-box')
lua exports.ox_inventory:Items('ammo-9')
```

### Test Export Manually

```lua
-- Server console
lua exports['fosty_ammo']:ammobox('usingItem', {name = 'ammo-9-box', metadata = {}}, {id = 1}, 1, {})
```

### Monitor Events

```lua
-- Add to client/main.lua for testing
RegisterNetEvent('fosty_ammo:client:playAnimation', function()
    print('Animation event received!')
end)
```

### Check Inventory Space

```lua
-- Server console
lua exports.ox_inventory:CanCarryItem(1, 'ammo-9', 50)
```

---

## 📞 Getting Help

If you're still stuck after trying these solutions:

### 1. Gather Information

```bash
# Enable debug mode
Config.Debug = true

# Check versions
status ox_inventory
status qbx_core  # or qb-core
status ox_lib

# Get error messages from console
```

### 2. Provide Details

When asking for help, include:
- [ ] Full error message from console
- [ ] Your framework (QBox, QBCore, ESX)
- [ ] Config.lua settings
- [ ] Item definition from items.lua
- [ ] What you've already tried

### 3. Common Questions Answered

**Q: Can I use this without a framework?**
A: Yes! It works with just ox_inventory + ox_lib.

**Q: Does this work with qs-inventory?**
A: No, only ox_inventory is supported.

**Q: Can I have different amounts per box?**
A: Currently, all boxes use `Config.DefaultAmount`. You'd need to create different box types.

**Q: Why do I need the output ammo item?**
A: The script automatically removes `-box` from the name to find what to give. If `ammo-9` doesn't exist, it can't give you anything.

**Q: Can I change the naming pattern?**
A: Yes! Change `Config.BoxSuffix = '-box'` to something else like `'-crate'`. Remember to do the same in `ox_inventory/data/items.lua`.

---

## ✅ Checklist Before Going Live

- [ ] Debug mode disabled (`Config.Debug = false`)
- [ ] All box items have correct export
- [ ] All output ammo items exist
- [ ] Tested opening at least one box type
- [ ] Tested with full inventory (error handling)
- [ ] Animations work and stop properly
- [ ] Notifications appear correctly
- [ ] No console errors
- [ ] Proper prices set in shops
- [ ] Images added (or placeholders work)

---

## 🎯 Performance Issues?

### Script Running Slow?

1. **Check idle performance:**
```bash
resmon
# fosty_ammo should be 0.00ms idle
```

2. **Disable animations if needed:**
```lua
Config.EnableAnimations = false
```

3. **Reduce animation duration:**
```lua
Config.Animation = {
    duration = 1500  -- Faster
}
```

### Server Lag When Opening Boxes?

- This shouldn't happen, the script is event-driven
- Check for conflicts with other inventory scripts
- Enable debug to see what's happening

---

## 🆘 Last Resort Solutions

### Nuclear Option 1: Fresh Install

1. Delete fosty_ammo folder
2. Re-download/copy all files
3. Fresh config.lua with defaults
4. Restart ox_inventory
5. Ensure fosty_ammo

### Nuclear Option 2: Minimal Config

```lua
-- Absolute minimal config
Config.Framework = 'auto'
Config.Inventory = 'ox_inventory'
Config.UseOxLib = true
Config.EnableAnimations = false  -- Disable everything
Config.UseProgressBar = false
Config.BoxSuffix = '-box'
Config.DefaultAmount = 50
Config.Debug = true  -- See what's happening
```

### Nuclear Option 3: Test Item

Create a super simple test item:
```lua
['test-box'] = {
    label = 'Test Box',
    weight = 100,
    stack = true,
    close = true,
    client = {
        usetime = 1000,
    },
    server = {
        export = 'fosty_ammo.ammobox',
    },
},

['test'] = {
    label = 'Test Item',
    weight = 1,
    stack = true,
}
```

If this works, your setup is fine and the issue is with specific items.

---


**Still having issues? The problem might be unique to your setup. Enable debug mode and check the console output carefully!**
