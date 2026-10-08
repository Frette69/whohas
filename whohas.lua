--[[
* whohas - Ashita v4 addon for HorizonXI
*
* Shows an on-screen box, whenever an item is highlighted in an item menu, listing
* which of your characters hold that item, in which container, and how many.
*
* How it works:
*   - Every time a character's inventory finishes loading or changes, the addon takes a
*     snapshot of every container (Inventory, Safe, Storage, Locker, Satchel, Sack, Case,
*     Wardrobes, Safe 2) and writes it to disk under:
*         <Ashita>\config\addons\whohas\chars\<CharacterName>.lua
*   - When you highlight an item, the addon reads the client's "selected item" id (the same
*     value the HorizonXI-approved PriceCheck addon uses) and looks it up across every
*     character file, plus the live inventory of the character you are on.
*   - Storage slips (Porter Moogle) are decoded from each slip's Extra data using your
*     server's bit order (slips.lua carries LandSandBoat's order for HorizonXI and the retail
*     order from Windower's resources; pick one with /whohas server), so items stored on a
*     slip show up as "Storage Slip 04 (Safe)", and any item that fits a slip shows which slip
*     and which characters hold that slip.
*   - The box opens with an OWNED / Not owned status line, and flags when another version of the
*     item (+1, -1, or the NQ) is held by any character, loose or on a slip, so you can skip lotting
*     or buying a piece you already have or have already upgraded. hqpairs.lua extends that to
*     NQ/HQ pairs whose names differ (Crimson -> Blood, Koenig -> Kaiser, Adaman -> Armada), the
*     cursed piece and abjuration behind each sky/sea item, and a few drop pairs (Leaping -> Bounding).
*   - The addon is read-only: it never sends packets, moves items, or automates anything.
*
* Commands:
*   /whohas                    Toggle the overlay on/off.
*   /whohas on | off           Enable or disable the overlay.
*   /whohas find <text>        Search every character for an item name (prints to chat).
*   /whohas list               List known characters and how old their data is.
*   /whohas files              Show the data folder and the files found there (troubleshooting).
*   /whohas reload             Re-read the character files from disk.
*   /whohas scan               Force a snapshot of the current character right now.
*   /whohas pin | unpin        Keep the box up for the last item even after closing menus.
*   /whohas current on | off   Include or exclude the logged-in character in the box.
*   /whohas filter on | off    Only show inside item menus (on), or whenever an item is selected (off).
*   /whohas menu               Print the name of the game menu that is open right now.
*   /whohas menus              Show the menu keyword filter.
*   /whohas menus add <kw>     Add a keyword to the menu filter.
*   /whohas menus remove <kw>  Remove a keyword from the menu filter.
*   /whohas lock | unlock      Lock or unlock the box position.
*   /whohas pos <x> <y>        Move the box to a screen position.
*   /whohas alpha <0.1-1.0>    Set the box background opacity.
*   /whohas slip [n]           List storage slips on file, or everything stored on slip n.
*   /whohas slipfit on | off   Show which storage slip the selected item can be stored on.
*   /whohas slipitems on | off When a slip is selected, list what is stored on it.
*   /whohas server horizon | retail  Which server you play on: selects the slip bit order and shop list.
*   /whohas variants on | off  Show other versions (+1, -1, NQ) of the selected item that anyone holds.
*   /whohas forget <name>      Delete the stored data for a character.
*   /whohas debug              Print the selected item id, index, and menu name.
*   /whohas help               Show this list.
--]]

addon.name    = 'whohas';
addon.author  = 'Frette';
addon.version = '1.4.0';
addon.desc    = 'Shows which of your characters hold the selected item, and how many, across all storage.';
addon.link    = '';

require('common');
local chat     = require('chat');
local imgui    = require('imgui');
local settings = require('settings');
local slips    = require('slips');
-- Optional: NQ / HQ / cursed / abjuration relations whose names differ (hqpairs.lua, generated
-- from LandSandBoat data). Without it only +1 / -1 style names are matched.
local hqpairs_ok, hqpairs = pcall(require, 'hqpairs');
if (not hqpairs_ok or type(hqpairs) ~= 'table' or type(hqpairs.related) ~= 'function') then
    hqpairs = nil;
end

-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------
local defaults = T{
    enabled           = true,
    show_current      = true,
    menu_filter       = true,
    -- Comma-separated substrings matched (case-insensitive) against the open menu name.
    menus             = 'inv,bank,equip,shop,auc,delivery,loot,moneyctr,item,stor,safe,lock,satch,sack,case,ward,mog,trade,craft',
    show_missing      = true,
    show_age          = true,
    show_slip_fit     = true,   -- show which slip the selected item can be stored on
    show_slip_items   = true,   -- when a slip is selected, list what this character has stored on it
    show_variants     = true,   -- show +1 / -1 / NQ versions of the selected item that any character holds
    locked            = false,
    opacity           = 0.85,
    pos_x             = 100,
    pos_y             = 100,
    include_temporary = false,
    server            = 'horizon',   -- 'horizon' or 'retail': storage slip bit order and which slips the Porter Moogle sells
};

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local CONTAINER_NAMES = {
    [0]  = 'Inventory',
    [1]  = 'Safe',
    [2]  = 'Storage',
    [3]  = 'Temporary',
    [4]  = 'Locker',
    [5]  = 'Satchel',
    [6]  = 'Sack',
    [7]  = 'Case',
    [8]  = 'Wardrobe',
    [9]  = 'Safe 2',
    [10] = 'Wardrobe 2',
    [11] = 'Wardrobe 3',
    [12] = 'Wardrobe 4',
    [13] = 'Wardrobe 5',
    [14] = 'Wardrobe 6',
    [15] = 'Wardrobe 7',
    [16] = 'Wardrobe 8',
};
local MAX_CONTAINER   = 16;
local GIL_ID          = 65535;
local SNAPSHOT_DELAY  = 2;   -- seconds of inventory quiet before a snapshot is written
local LOAD_DELAY      = 3;   -- seconds after addon load before the first snapshot
local READY_FALLBACK  = 20;  -- seconds after zone-in to trust containers even without packet 0x1D

-- Character names are letters only (FFXI allows 3 to 15). Everything that becomes part of a file
-- path goes through this, so a tampered index or character file can never point outside the
-- data folder.
local function valid_name(n)
    return type(n) == 'string' and #n >= 1 and #n <= 20 and n:match('^%a+$') ~= nil;
end

-- Runs a data file as plain data: the chunk gets an empty environment, so a file that is not
-- just 'return { ... }' cannot call anything (io, os, AshitaCore, ...) and fails harmlessly.
local function run_data_file(path)
    local chunk = loadfile(path);
    if (chunk == nil) then return nil; end
    if (setfenv ~= nil) then setfenv(chunk, { }); end
    return chunk();
end

-------------------------------------------------------------------------------
-- State
-------------------------------------------------------------------------------
local whohas = T{
    settings     = settings.load(defaults),
    data_path    = nil,
    chars        = { },      -- name -> { name, server_id, updated, items = { [id] = { [cid] = count } } }
    me           = nil,      -- name of the logged-in character
    ready        = false,    -- inventory fully loaded for the logged-in character
    dirty        = false,
    dirty_at     = 0,
    last_counter = -1,
    data_version = 0,
    rows_version = -1,
    last_item    = 0,
    item_name    = '',
    rows         = { },
    total        = 0,
    fits         = { },      -- slips the selected item can be stored on: { slip_id, name, sold, holders = { {name, where} } }
    slip_rows    = { },      -- when the selected item is a slip: { {name, count, names = { ... }} }
    variants     = { },      -- other versions (+1, -1, NQ) of the selected item: { {id, name, rows, total} }
    owned_all    = 0,        -- copies of the selected item across every character, current included
    name_index   = nil,      -- base name -> { [item id] = display name } for every item any character holds
    name_index_version = -1,
    pinned       = false,
    pinned_item  = 0,
    warned_menu  = false,
    force_pos    = false,
    zoned_at     = 0,        -- os.time() of the last zone-in packet
};

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------
local function msg(s)
    print(chat.header(addon.name) .. chat.message(s));
end
local function msg_ok(s)
    print(chat.header(addon.name) .. chat.success(s));
end
local function msg_err(s)
    print(chat.header(addon.name) .. chat.error(s));
end

local function age_str(ts)
    if (ts == nil or ts == 0) then return '?'; end
    local d = os.time() - ts;
    if (d < 0) then d = 0; end
    if (d < 60) then return 'now'; end
    if (d < 3600) then return string.format('%dm', math.floor(d / 60)); end
    if (d < 86400) then return string.format('%dh', math.floor(d / 3600)); end
    return string.format('%dd', math.floor(d / 86400));
end

local function age_phrase(ts)
    local a = age_str(ts);
    if (a == 'now') then return 'just now'; end
    return a .. ' ago';
end

local function container_name(cid)
    return CONTAINER_NAMES[cid] or ('Container ' .. tostring(cid));
end

local function item_display_name(id)
    local item = AshitaCore:GetResourceManager():GetItemById(id);
    if (item ~= nil and item.Name ~= nil and item.Name[1] ~= nil and #item.Name[1] > 0) then
        return item.Name[1];
    end
    return 'Item #' .. tostring(id);
end

-- "Fighter's Mask +1" / "Abyss Burgeonet -1" -> "fighter's mask" / "abyss burgeonet", so NQ, HQ (+1)
-- and -1 versions of the same piece can be matched to each other.
local function base_name(name)
    local b = tostring(name or ''):gsub('%s*[%+%-]%d+$', '');
    return b:lower();
end

-- The "+1" / "-1" part of a name, or "NQ" when there is none.
local function name_suffix(name)
    local suf = tostring(name or ''):match('([%+%-]%d+)$');
    return suf or 'NQ';
end

-- Full (log) name when the client has one, since short names can be abbreviated differently for
-- the NQ and HQ of the same piece; falls back to the short display name.
local function item_match_name(id)
    local item = AshitaCore:GetResourceManager():GetItemById(id);
    if (item ~= nil and item.LogNameSingular ~= nil and item.LogNameSingular[1] ~= nil and #item.LogNameSingular[1] > 0) then
        return item.LogNameSingular[1];
    end
    return item_display_name(id);
end

local function get_me()
    local player = GetPlayerEntity();
    if (player == nil) then return nil, 0; end
    local name = player.Name;
    if (not valid_name(name)) then return nil, 0; end
    return name, (player.ServerId or 0);
end

local function is_logged_in()
    return AshitaCore:GetMemoryManager():GetPlayer():GetLoginStatus() == 2;
end

-------------------------------------------------------------------------------
-- Menu detection (signature courtesy of Thorny, as used by PriceCheck)
-------------------------------------------------------------------------------
local pGameMenu = ashita.memory.find('FFXiMain.dll', 0, '8B480C85C974??8B510885D274??3B05', 16, 0);

local function get_menu_name()
    if (pGameMenu == nil or pGameMenu == 0) then return nil; end
    local ok, name = pcall(function ()
        local subPointer = ashita.memory.read_uint32(pGameMenu);
        if (subPointer == 0) then return ''; end
        local subValue = ashita.memory.read_uint32(subPointer);
        if (subValue == 0) then return ''; end
        local menuHeader = ashita.memory.read_uint32(subValue + 4);
        if (menuHeader == 0) then return ''; end
        local menuName = ashita.memory.read_string(menuHeader + 0x46, 16);
        if (menuName == nil) then return ''; end
        return (menuName:gsub('%z', ''));
    end);
    if (not ok or type(name) ~= 'string') then return ''; end
    return name;
end

local function in_item_menu()
    if (not whohas.settings.menu_filter) then return true; end
    local name = get_menu_name();
    if (name == nil) then
        -- Signature scan failed on this client build; fall back to no filtering.
        if (not whohas.warned_menu) then
            whohas.warned_menu = true;
            msg_err('Menu signature not found; showing whenever an item is selected. (/whohas filter off to silence)');
        end
        return true;
    end
    if (#name == 0) then return false; end
    name = name:lower();
    for kw in whohas.settings.menus:gmatch('[^,%s]+') do
        if (name:find(kw:lower(), 1, true)) then return true; end
    end
    return false;
end

-------------------------------------------------------------------------------
-- Data files
-------------------------------------------------------------------------------
local function ensure_dirs()
    local base = AshitaCore:GetInstallPath();
    local paths = {
        string.format('%s\\config\\', base),
        string.format('%s\\config\\addons\\', base),
        string.format('%s\\config\\addons\\%s\\', base, addon.name),
        string.format('%s\\config\\addons\\%s\\chars\\', base, addon.name),
    };
    for _, p in ipairs(paths) do
        if (not ashita.fs.exists(p)) then
            ashita.fs.create_dir(p);
        end
    end
    whohas.data_path = paths[4];
end

local function char_file(name)
    return whohas.data_path .. name .. '.lua';
end

local function serialize_char(c)
    local out = { };
    table.insert(out, '-- whohas character snapshot (auto-generated; safe to delete)\n');
    table.insert(out, 'return {\n');
    table.insert(out, string.format('    name = %q,\n', c.name));
    table.insert(out, string.format('    server_id = %d,\n', c.server_id or 0));
    table.insert(out, string.format('    updated = %d,\n', c.updated or 0));
    table.insert(out, '    items = {\n');
    local ids = { };
    for id, _ in pairs(c.items) do table.insert(ids, id); end
    table.sort(ids);
    for _, id in ipairs(ids) do
        local cids = { };
        for cid, _ in pairs(c.items[id]) do table.insert(cids, cid); end
        table.sort(cids);
        local parts = { };
        for _, cid in ipairs(cids) do
            table.insert(parts, string.format('[%d] = %d', cid, c.items[id][cid]));
        end
        table.insert(out, string.format('        [%d] = { %s },\n', id, table.concat(parts, ', ')));
    end
    table.insert(out, '    },\n');
    -- Storage slips: slip item id -> container + the item ids stored on it.
    table.insert(out, '    slips = {\n');
    local sids = { };
    for sid, _ in pairs(c.slips or { }) do table.insert(sids, sid); end
    table.sort(sids);
    for _, sid in ipairs(sids) do
        local s = c.slips[sid];
        local ids2 = { };
        for _, v in ipairs(s.items or { }) do table.insert(ids2, tostring(v)); end
        table.insert(out, string.format('        [%d] = { container = %d, items = { %s } },\n', sid, s.container or 0, table.concat(ids2, ', ')));
    end
    table.insert(out, '    },\n};\n');
    return table.concat(out);
end

-- Builds c.slip_index: item id -> list of { slip = slip_id, container = cid } for items stored on slips.
local function index_char(c)
    local idx = { };
    for sid, s in pairs(c.slips or { }) do
        for _, item_id in ipairs(s.items or { }) do
            local t = idx[item_id];
            if (t == nil) then t = { }; idx[item_id] = t; end
            table.insert(t, { slip = sid, container = s.container or 0 });
        end
    end
    c.slip_index = idx;
    return c;
end

-- The index file lists every character that has a snapshot on disk. It is the primary way
-- files are found at load time, so nothing depends on how ashita.fs.get_directory reports names.
local function index_file()
    return whohas.data_path .. 'index.lua';
end

local function read_index()
    local names = { };
    if (not ashita.fs.exists(index_file())) then return names; end
    local ok, data = pcall(run_data_file, index_file());
    if (ok and type(data) == 'table') then
        for _, n in ipairs(data) do
            if (valid_name(n)) then table.insert(names, n); end
        end
    end
    return names;
end

local function write_index(names)
    table.sort(names);
    local f = io.open(index_file(), 'w+');
    if (f == nil) then return false; end
    f:write('-- whohas character index (auto-generated; safe to delete)\nreturn {\n');
    for _, n in ipairs(names) do f:write(string.format('    %q,\n', n)); end
    f:write('};\n');
    f:close();
    return true;
end

local function index_add(name)
    local names = read_index();
    for _, n in ipairs(names) do
        if (n == name) then return true; end
    end
    table.insert(names, name);
    return write_index(names);
end

local function index_remove(name)
    local names = read_index();
    local keep = { };
    for _, n in ipairs(names) do
        if (n ~= name) then table.insert(keep, n); end
    end
    return write_index(keep);
end

local function save_char(c)
    local f = io.open(char_file(c.name), 'w+');
    if (f == nil) then
        msg_err('Could not write ' .. char_file(c.name));
        return false;
    end
    f:write(serialize_char(c));
    f:close();
    index_add(c.name);
    return true;
end

-- Names of character files found by listing the data folder. Tolerates the listing returning
-- bare names or full paths, and ignores index.lua and anything that is not a <Name>.lua file.
local function scan_folder_names()
    local names = { };
    local seen = { };
    local entries = nil;
    local ok, res = pcall(function () return ashita.fs.get_directory(whohas.data_path); end);
    if (ok and type(res) == 'table') then entries = res; end
    if (entries == nil or next(entries) == nil) then
        ok, res = pcall(function () return ashita.fs.get_directory(whohas.data_path, '.*', false); end);
        if (ok and type(res) == 'table') then entries = res; end
    end
    if (entries ~= nil) then
        for _, entry in pairs(entries) do
            if (type(entry) == 'string') then
                local name = entry:match('([%a]+)%.[Ll][Uu][Aa]$');
                if (name ~= nil and name:lower() ~= 'index' and not seen[name]) then
                    seen[name] = true;
                    table.insert(names, name);
                end
            end
        end
    end
    return names;
end

local function load_char_file(path)
    if (not ashita.fs.exists(path)) then return nil; end
    local ok, data = pcall(run_data_file, path);
    if (ok and type(data) == 'table' and valid_name(data.name) and type(data.items) == 'table') then
        if (type(data.slips) ~= 'table') then data.slips = { }; end
        return index_char(data);
    end
    return nil;
end

-- Loads every character file on disk. Returns loaded count, index count, folder-scan count.
local function load_all_chars()
    local loaded = 0;
    local candidates = { };
    local seen = { };
    local from_index = read_index();
    for _, n in ipairs(from_index) do
        if (not seen[n]) then seen[n] = true; table.insert(candidates, n); end
    end
    local from_scan = scan_folder_names();
    for _, n in ipairs(from_scan) do
        if (not seen[n]) then seen[n] = true; table.insert(candidates, n); end
    end
    local index_dirty = false;
    local index_has = { };
    for _, n in ipairs(from_index) do index_has[n] = true; end
    for _, name in ipairs(candidates) do
        local data = load_char_file(char_file(name));
        if (data ~= nil) then
            whohas.chars[data.name] = data;
            loaded = loaded + 1;
            if (not index_has[data.name]) then index_dirty = true; end
        elseif (index_has[name]) then
            -- Listed in the index but the file is missing or not valid data: drop the entry.
            index_dirty = true;
        end
    end
    -- Rewrite the index when the folder scan found files it did not know about, or when it
    -- listed something that did not load.
    if (index_dirty) then
        local names = { };
        for n, _ in pairs(whohas.chars) do table.insert(names, n); end
        write_index(names);
    end
    whohas.data_version = whohas.data_version + 1;
    return loaded, #from_index, #from_scan;
end

-------------------------------------------------------------------------------
-- Live inventory snapshot
-------------------------------------------------------------------------------
local function scan_live()
    local inv = AshitaCore:GetMemoryManager():GetInventory();
    local res = AshitaCore:GetResourceManager();
    local items = { };
    local found_slips = { };
    local slots = 0;
    for cid = 0, MAX_CONTAINER do
        if (cid ~= 3 or whohas.settings.include_temporary) then
            local max = inv:GetContainerCountMax(cid);
            if (max ~= nil and max > 0) then
                for idx = 0, max do
                    local entry = inv:GetContainerItem(cid, idx);
                    if (entry ~= nil and entry.Id ~= nil and entry.Id > 0 and entry.Id ~= GIL_ID) then
                        local q = 1;
                        local item = res:GetItemById(entry.Id);
                        if (item ~= nil and item.StackSize ~= nil and item.StackSize > 1
                            and entry.Count ~= nil and entry.Count > 0) then
                            q = entry.Count;
                        end
                        local per = items[entry.Id];
                        if (per == nil) then
                            per = { };
                            items[entry.Id] = per;
                        end
                        per[cid] = (per[cid] or 0) + q;
                        slots = slots + 1;
                        -- Storage slip: decode which items are stored on it.
                        if (slips.is_slip(entry.Id)) then
                            local ok, stored = pcall(slips.decode, entry.Id, entry.Extra);
                            if (not ok or type(stored) ~= 'table') then stored = { }; end
                            local prev = found_slips[entry.Id];
                            if (prev == nil) then
                                found_slips[entry.Id] = { container = cid, items = stored };
                            else
                                -- Same slip in two containers should not happen; keep the fuller one.
                                if (#stored > #prev.items) then
                                    found_slips[entry.Id] = { container = cid, items = stored };
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return items, slots, found_slips;
end

local function snapshot(announce)
    local name, sid = get_me();
    if (name == nil) then
        if (announce) then msg_err('No character is logged in.'); end
        return false;
    end
    local items, slots, found_slips = scan_live();
    if (slots == 0) then
        if (announce) then msg_err('Inventory looks empty or not loaded yet; nothing saved.'); end
        return false;
    end
    local c = index_char({ name = name, server_id = sid, updated = os.time(), items = items, slips = found_slips });
    whohas.chars[name] = c;
    whohas.me = name;
    whohas.data_version = whohas.data_version + 1;
    local saved = save_char(c);
    if (announce) then
        local unique = 0;
        for _ in pairs(items) do unique = unique + 1; end
        local nslips, nstored = 0, 0;
        for _, s in pairs(found_slips) do nslips = nslips + 1; nstored = nstored + #s.items; end
        msg_ok(string.format('Snapshot saved for %s: %d slots, %d unique items, %d slip(s) holding %d item(s).', name, slots, unique, nslips, nstored));
    end
    return saved;
end

local function tick_snapshot()
    if (not is_logged_in()) then return; end
    local now = os.time();
    if (not whohas.ready) then
        -- Safety net: if no inventory-finished packet shows up within a while of zoning in,
        -- start trusting the containers anyway (any later change re-snapshots).
        if (whohas.zoned_at > 0 and (now - whohas.zoned_at) >= READY_FALLBACK) then
            whohas.ready = true;
            whohas.dirty = true;
            whohas.dirty_at = now;
        else
            return;
        end
    end
    local counter = AshitaCore:GetMemoryManager():GetInventory():GetContainerUpdateCounter();
    if (counter ~= whohas.last_counter) then
        whohas.last_counter = counter;
        whohas.dirty = true;
        whohas.dirty_at = now;
    end
    if (whohas.dirty and (now - whohas.dirty_at) >= SNAPSHOT_DELAY) then
        whohas.dirty = false;
        snapshot(false);
    end
end

-------------------------------------------------------------------------------
-- Lookup
-------------------------------------------------------------------------------
local function build_rows(id, include_current)
    if (include_current == nil) then include_current = whohas.settings.show_current; end
    local rows = { };
    local total = 0;
    local names = { };
    for name, _ in pairs(whohas.chars) do table.insert(names, name); end
    table.sort(names, function (a, b)
        if (a == whohas.me) then return true; end
        if (b == whohas.me) then return false; end
        return a < b;
    end);
    for _, name in ipairs(names) do
        local c = whohas.chars[name];
        local is_me = (name == whohas.me);
        if (not is_me or include_current) then
            local per = c.items[id];
            local char_total = 0;
            local where = { };
            if (per ~= nil) then
                local cids = { };
                for cid, _ in pairs(per) do table.insert(cids, cid); end
                table.sort(cids);
                for _, cid in ipairs(cids) do
                    char_total = char_total + per[cid];
                    local label = string.format('%s x%d', container_name(cid), per[cid]);
                    -- If the item itself is a storage slip, say how much is on it.
                    if (slips.is_slip(id) and c.slips[id] ~= nil and c.slips[id].container == cid) then
                        label = string.format('%s (%d stored)', label, #c.slips[id].items);
                    end
                    table.insert(where, label);
                end
            end
            -- Copies of the item sitting on storage slips this character holds.
            local on_slips = (c.slip_index or { })[id];
            if (on_slips ~= nil) then
                for _, s in ipairs(on_slips) do
                    char_total = char_total + 1;
                    table.insert(where, string.format('%s (%s)', slips.name(s.slip), container_name(s.container)));
                end
            end
            if (char_total > 0) then
                total = total + char_total;
                table.insert(rows, {
                    name    = name,
                    where   = table.concat(where, ', '),
                    count   = char_total,
                    updated = c.updated,
                    current = is_me,
                });
            end
        end
    end
    return rows, total;
end

-- Which storage slip(s) the item can be stored on, and who holds those slips.
local function build_fits(id)
    local fits = { };
    local slip_ids = slips.slip_for[id];
    if (slip_ids == nil) then return fits; end
    for _, sid in ipairs(slip_ids) do
        local holders = { };
        local names = { };
        for name, _ in pairs(whohas.chars) do table.insert(names, name); end
        table.sort(names, function (a, b)
            if (a == whohas.me) then return true; end
            if (b == whohas.me) then return false; end
            return a < b;
        end);
        for _, name in ipairs(names) do
            local c = whohas.chars[name];
            local per = c.items[sid];
            if (per ~= nil) then
                local cids = { };
                for cid, _ in pairs(per) do table.insert(cids, cid); end
                table.sort(cids);
                local places = { };
                for _, cid in ipairs(cids) do table.insert(places, container_name(cid)); end
                local stored = (c.slips[sid] ~= nil) and #c.slips[sid].items or 0;
                table.insert(holders, { name = name, where = table.concat(places, ', '), stored = stored, current = (name == whohas.me) });
            end
        end
        table.insert(fits, { slip = sid, name = slips.name(sid), sold = slips.sold_here(sid), holders = holders });
    end
    return fits;
end

-- When the selected item is a storage slip: what each character has stored on it.
local function build_slip_rows(id)
    local rows = { };
    if (not slips.is_slip(id)) then return rows; end
    local names = { };
    for name, _ in pairs(whohas.chars) do table.insert(names, name); end
    table.sort(names, function (a, b)
        if (a == whohas.me) then return true; end
        if (b == whohas.me) then return false; end
        return a < b;
    end);
    for _, name in ipairs(names) do
        local c = whohas.chars[name];
        local s = c.slips[id];
        if (s ~= nil) then
            local labels = { };
            for _, item_id in ipairs(s.items) do table.insert(labels, item_display_name(item_id)); end
            table.sort(labels);
            table.insert(rows, { name = name, count = #s.items, names = labels, current = (name == whohas.me) });
        end
    end
    return rows;
end

-- Index every item any character holds (loose or on a slip) by base name, so other versions
-- of the selected item (+1, -1, NQ) can be found without scanning the whole item database.
local function rebuild_name_index()
    local idx = { };
    local function add(item_id)
        local nm = item_display_name(item_id);
        local b = base_name(item_match_name(item_id));
        local t = idx[b];
        if (t == nil) then t = { }; idx[b] = t; end
        t[item_id] = nm;
    end
    for _, c in pairs(whohas.chars) do
        for item_id, _ in pairs(c.items or { }) do add(item_id); end
        for _, sl in pairs(c.slips or { }) do
            for _, item_id in ipairs(sl.items or { }) do add(item_id); end
        end
    end
    whohas.name_index = idx;
    whohas.name_index_version = whohas.data_version;
end

-- Other versions of the selected item that at least one character holds, e.g. the +1 of an NQ
-- relic piece sitting on another character's storage slip. Current character always included.
local function build_variants(id)
    local out = { };
    if (whohas.name_index == nil or whohas.name_index_version ~= whohas.data_version) then
        rebuild_name_index();
    end
    local b = base_name(item_match_name(id));
    if (#b == 0) then return out; end
    local seen = { [id] = true };
    local group = whohas.name_index[b];
    if (group ~= nil) then
        for vid, vname in pairs(group) do
            if (not seen[vid]) then
                seen[vid] = true;
                local rows, total = build_rows(vid, true);
                if (total > 0) then
                    table.insert(out, { id = vid, name = vname, suffix = name_suffix(vname), rows = rows, total = total });
                end
            end
        end
    end
    -- Relations whose names differ (Crimson -> Blood, cursed piece, abjuration, ...).
    if (hqpairs ~= nil) then
        local ok, rel = pcall(hqpairs.related, id);
        if (ok and type(rel) == 'table') then
            for _, r in ipairs(rel) do
                if (not seen[r.id]) then
                    seen[r.id] = true;
                    local rows, total = build_rows(r.id, true);
                    if (total > 0) then
                        table.insert(out, { id = r.id, name = item_display_name(r.id), suffix = r.role, rows = rows, total = total });
                    end
                end
            end
        end
    end
    table.sort(out, function (x, y) return x.name < y.name; end);
    return out;
end

local function refresh_rows(id)
    if (id ~= whohas.last_item or whohas.rows_version ~= whohas.data_version) then
        whohas.rows, whohas.total = build_rows(id);
        local _, owned_all   = build_rows(id, true);
        whohas.owned_all    = owned_all;
        whohas.variants     = build_variants(id);
        whohas.fits         = build_fits(id);
        whohas.slip_rows    = build_slip_rows(id);
        whohas.last_item    = id;
        whohas.rows_version = whohas.data_version;
        whohas.item_name    = item_display_name(id);
    end
end

-------------------------------------------------------------------------------
-- Overlay
-------------------------------------------------------------------------------
local function draw_box(id)
    refresh_rows(id);
    local has_fit = (whohas.settings.show_slip_fit and #whohas.fits > 0);
    local has_var = (whohas.settings.show_variants and #whohas.variants > 0);
    if (#whohas.rows == 0 and not has_fit and not has_var and not whohas.settings.show_missing and not whohas.pinned) then return; end

    local flags = bit.bor(
        ImGuiWindowFlags_NoTitleBar,
        ImGuiWindowFlags_AlwaysAutoResize,
        ImGuiWindowFlags_NoFocusOnAppearing,
        ImGuiWindowFlags_NoNav,
        ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoScrollbar
    );
    if (whohas.settings.locked) then
        flags = bit.bor(flags, ImGuiWindowFlags_NoMove);
    end

    imgui.SetNextWindowBgAlpha(whohas.settings.opacity);
    if (whohas.force_pos) then
        whohas.force_pos = false;
        imgui.SetNextWindowPos({ whohas.settings.pos_x, whohas.settings.pos_y }, ImGuiCond_Always);
    else
        imgui.SetNextWindowPos({ whohas.settings.pos_x, whohas.settings.pos_y }, ImGuiCond_FirstUseEver);
    end

    if (imgui.Begin('whohas', true, flags)) then
        -- Track the position so it can be saved on unload..
        local px, py = imgui.GetWindowPos();
        if (px ~= nil and py ~= nil) then
            whohas.settings.pos_x = px;
            whohas.settings.pos_y = py;
        end

        imgui.TextColored({ 1.0, 0.85, 0.4, 1.0 }, whohas.item_name);
        imgui.SameLine();
        imgui.TextDisabled(string.format('[%d]', id));
        if (whohas.pinned) then
            imgui.SameLine();
            imgui.TextColored({ 0.6, 0.8, 1.0, 1.0 }, '(pinned)');
        end

        -- One-glance status: do I already have this, or a +1 / -1 of it?
        if (whohas.owned_all > 0) then
            imgui.TextColored({ 0.55, 1.0, 0.55, 1.0 }, string.format('OWNED x%d', whohas.owned_all));
        else
            imgui.TextDisabled('Not owned by any character');
        end
        if (has_var) then
            for _, v in ipairs(whohas.variants) do
                imgui.SameLine();
                imgui.TextColored({ 1.0, 0.75, 0.3, 1.0 }, string.format('| %s owned x%d', v.suffix, v.total));
            end
        end
        imgui.Separator();

        if (#whohas.rows == 0) then
            if (whohas.owned_all > 0) then
                imgui.TextDisabled('Only the current character has it (hidden; /whohas current on).');
            else
                imgui.TextDisabled('Not stored on any known character.');
            end
        else
            local tflags = bit.bor(ImGuiTableFlags_SizingFixedFit, ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersInnerV);
            if (imgui.BeginTable('whohas_tbl', 3, tflags)) then
                imgui.TableSetupColumn('Character', ImGuiTableColumnFlags_WidthFixed);
                imgui.TableSetupColumn('Where', ImGuiTableColumnFlags_WidthFixed);
                imgui.TableSetupColumn('Qty', ImGuiTableColumnFlags_WidthFixed);
                imgui.TableHeadersRow();
                for _, r in ipairs(whohas.rows) do
                    imgui.TableNextRow();
                    imgui.TableNextColumn();
                    if (r.current) then
                        imgui.TextColored({ 0.55, 1.0, 0.55, 1.0 }, r.name);
                    else
                        imgui.Text(r.name);
                    end
                    if (whohas.settings.show_age and not r.current) then
                        imgui.SameLine();
                        imgui.TextDisabled('(' .. age_str(r.updated) .. ')');
                    end
                    imgui.TableNextColumn();
                    imgui.Text(r.where);
                    imgui.TableNextColumn();
                    imgui.Text(tostring(r.count));
                end
                imgui.EndTable();
            end
            if (#whohas.rows > 1) then
                imgui.Separator();
                imgui.Text(string.format('Total: %d across %d characters', whohas.total, #whohas.rows));
            end
        end

        -- Other versions of this item (NQ / +1 / -1) and who holds them.
        if (has_var) then
            imgui.Separator();
            for _, v in ipairs(whohas.variants) do
                imgui.TextColored({ 1.0, 0.75, 0.3, 1.0 }, v.name);
                imgui.SameLine();
                imgui.TextDisabled(string.format('[%d]', v.id));
                for _, r in ipairs(v.rows) do
                    imgui.SameLine();
                    if (r.current) then
                        imgui.TextColored({ 0.55, 1.0, 0.55, 1.0 }, string.format('%s (%s)', r.name, r.where));
                    else
                        imgui.Text(string.format('%s (%s)', r.name, r.where));
                    end
                end
            end
        end

        -- Which slip this item fits on, and who holds that slip.
        if (has_fit) then
            imgui.Separator();
            for _, f in ipairs(whohas.fits) do
                imgui.TextColored({ 0.6, 0.8, 1.0, 1.0 }, 'Fits ' .. f.name);
                if (not f.sold) then
                    imgui.SameLine();
                    imgui.TextDisabled('(not sold on this server)');
                end
                if (#f.holders == 0) then
                    imgui.SameLine();
                    imgui.TextDisabled('- no character has this slip');
                else
                    for _, h in ipairs(f.holders) do
                        imgui.SameLine();
                        if (h.current) then
                            imgui.TextColored({ 0.55, 1.0, 0.55, 1.0 }, string.format('%s (%s, %d stored)', h.name, h.where, h.stored));
                        else
                            imgui.Text(string.format('%s (%s, %d stored)', h.name, h.where, h.stored));
                        end
                    end
                end
            end
        end

        -- The selected item is a storage slip: list what is stored on it.
        if (whohas.settings.show_slip_items and #whohas.slip_rows > 0) then
            imgui.Separator();
            for _, r in ipairs(whohas.slip_rows) do
                if (r.current) then
                    imgui.TextColored({ 0.55, 1.0, 0.55, 1.0 }, string.format('%s: %d stored', r.name, r.count));
                else
                    imgui.Text(string.format('%s: %d stored', r.name, r.count));
                end
                if (r.count > 0) then
                    local shown = { };
                    local limit = 40;
                    for i = 1, math.min(#r.names, limit) do table.insert(shown, r.names[i]); end
                    local text = table.concat(shown, ', ');
                    if (#r.names > limit) then
                        text = text .. string.format(', +%d more', #r.names - limit);
                    end
                    imgui.PushTextWrapPos(560.0);
                    imgui.TextDisabled(text);
                    imgui.PopTextWrapPos();
                end
            end
        end
    end
    imgui.End();
end

-------------------------------------------------------------------------------
-- Chat search (findall-style)
-------------------------------------------------------------------------------
local function find_items(text)
    local needle = AshitaCore:GetChatManager():ParseAutoTranslate(text, false) or text;
    needle = needle:lower();
    local res = AshitaCore:GetResourceManager();
    local hits = { };
    local name_cache = { };
    for cname, c in pairs(whohas.chars) do
        for id, per in pairs(c.items) do
            local iname = name_cache[id];
            if (iname == nil) then
                local item = res:GetItemById(id);
                iname = (item ~= nil and item.Name ~= nil and item.Name[1]) or '';
                name_cache[id] = iname;
            end
            if (#iname > 0 and iname:lower():find(needle, 1, true)) then
                local cids = { };
                for cid, _ in pairs(per) do table.insert(cids, cid); end
                table.sort(cids);
                local where = { };
                local count = 0;
                for _, cid in ipairs(cids) do
                    count = count + per[cid];
                    table.insert(where, string.format('%s x%d', container_name(cid), per[cid]));
                end
                table.insert(hits, { item = iname, char = cname, count = count, where = table.concat(where, ', ') });
            end
        end
        -- Items stored on this character's storage slips.
        for sid, s in pairs(c.slips or { }) do
            for _, id in ipairs(s.items or { }) do
                local iname = name_cache[id];
                if (iname == nil) then
                    local item = res:GetItemById(id);
                    iname = (item ~= nil and item.Name ~= nil and item.Name[1]) or '';
                    name_cache[id] = iname;
                end
                if (#iname > 0 and iname:lower():find(needle, 1, true)) then
                    table.insert(hits, { item = iname, char = cname, count = 1, where = string.format('%s in %s', slips.name(sid), container_name(s.container or 0)) });
                end
            end
        end
    end
    table.sort(hits, function (a, b)
        if (a.item ~= b.item) then return a.item < b.item; end
        return a.char < b.char;
    end);
    if (#hits == 0) then
        msg(string.format('No character has anything matching "%s".', text));
        return;
    end
    msg(string.format('Matches for "%s":', text));
    for _, h in ipairs(hits) do
        print(chat.header(addon.name) .. chat.color1(6, h.item) .. chat.message(string.format(' x%d on ', h.count)) .. chat.color1(5, h.char) .. chat.message(' (' .. h.where .. ')'));
    end
end

local function list_chars()
    local names = { };
    for name, _ in pairs(whohas.chars) do table.insert(names, name); end
    table.sort(names);
    if (#names == 0) then
        msg('No character data yet. Log in on each character once (or /whohas scan).');
        return;
    end
    msg(string.format('Known characters (%d), data folder: %s', #names, tostring(whohas.data_path)));
    for _, name in ipairs(names) do
        local c = whohas.chars[name];
        local unique = 0;
        local slots = 0;
        for _, per in pairs(c.items) do
            unique = unique + 1;
            for _, n in pairs(per) do slots = slots + n; end
        end
        local tag = (name == whohas.me) and ' (this character, live)' or '';
        msg(string.format('  %s: %d unique items, %d total, updated %s%s', name, unique, slots, age_phrase(c.updated), tag));
    end
end

local function forget_char(name)
    if (name == nil or #name == 0) then
        msg_err('Usage: /whohas forget <name>');
        return;
    end
    local found = nil;
    for cname, _ in pairs(whohas.chars) do
        if (cname:lower() == name:lower()) then found = cname; end
    end
    if (found == nil) then
        msg_err('No stored data for "' .. name .. '".');
        return;
    end
    if (not valid_name(found)) then
        msg_err('Refusing to touch a file for an invalid character name.');
        return;
    end
    whohas.chars[found] = nil;
    whohas.data_version = whohas.data_version + 1;
    local path = char_file(found);
    if (ashita.fs.exists(path)) then
        os.remove(path);
    end
    index_remove(found);
    msg_ok('Forgot ' .. found .. '.');
end

-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------
local function print_help()
    msg('Commands:');
    msg('  /whohas               Toggle the overlay');
    msg('  /whohas on|off        Enable or disable the overlay');
    msg('  /whohas find <text>   Search all characters for an item');
    msg('  /whohas list          List known characters');
    msg('  /whohas files         Show the data folder and what is on disk');
    msg('  /whohas reload        Re-read the character files');
    msg('  /whohas scan          Snapshot this character now');
    msg('  /whohas pin|unpin     Keep the box up for the last item');
    msg('  /whohas current on|off  Include the logged-in character');
    msg('  /whohas filter on|off   Only show inside item menus');
    msg('  /whohas menu          Print the open menu name');
    msg('  /whohas menus [add|remove <kw>]  Menu keyword filter');
    msg('  /whohas lock|unlock   Lock the box position');
    msg('  /whohas pos <x> <y>   Move the box');
    msg('  /whohas alpha <0.1-1> Background opacity');
    msg('  /whohas slip [n]      List storage slips on file, or what is on slip n');
    msg('  /whohas slipfit on|off   Show which slip an item fits');
    msg('  /whohas slipitems on|off Show slip contents when a slip is selected');
    msg('  /whohas server horizon|retail  Which server you play on (slip bit order, shop list)');
    msg('  /whohas variants on|off  Show +1 / -1 / NQ versions anyone holds');
    msg('  /whohas forget <name> Delete a character\'s data');
    msg('  /whohas debug         Show selected item + menu info');
end

local function on_off(v)
    if (v == nil) then return nil; end
    v = v:lower();
    if (v == 'on' or v == '1' or v == 'true') then return true; end
    if (v == 'off' or v == '0' or v == 'false') then return false; end
    return nil;
end

ashita.events.register('command', 'whohas_command_cb', function (e)
    local args = e.command:args();
    if (#args == 0) then return; end
    local cmd = args[1]:lower();
    if (cmd ~= '/whohas' and cmd ~= '/wh') then return; end
    e.blocked = true;

    local sub = (args[2] or ''):lower();

    if (sub == '') then
        whohas.settings.enabled = not whohas.settings.enabled;
        settings.save();
        msg(whohas.settings.enabled and 'Overlay enabled.' or 'Overlay disabled.');
        return;
    end

    if (sub == 'on' or sub == 'off') then
        whohas.settings.enabled = (sub == 'on');
        settings.save();
        msg(whohas.settings.enabled and 'Overlay enabled.' or 'Overlay disabled.');
        return;
    end

    if (sub == 'help') then
        print_help();
        return;
    end

    if (sub == 'find' or sub == 'search') then
        local text = e.command:match('^/%S+%s+%S+%s+(.+)$');
        if (text == nil or #text == 0) then
            msg_err('Usage: /whohas find <item name>');
            return;
        end
        find_items(text);
        return;
    end

    if (sub == 'list') then
        list_chars();
        return;
    end

    if (sub == 'scan' or sub == 'save') then
        snapshot(true);
        return;
    end

    if (sub == 'reload') then
        local n, ni, ns = load_all_chars();
        msg_ok(string.format('Reloaded %d character file(s) from %s (index lists %d, folder scan found %d).', n, tostring(whohas.data_path), ni, ns));
        return;
    end

    if (sub == 'files') then
        -- What is actually on disk right now, for troubleshooting persistence.
        msg('Data folder: ' .. tostring(whohas.data_path));
        msg('  folder exists: ' .. tostring(ashita.fs.exists(whohas.data_path)));
        local idx = read_index();
        msg(string.format('  index.lua: %s (%d name(s))', tostring(ashita.fs.exists(index_file())), #idx));
        for _, n in ipairs(idx) do
            msg(string.format('    %s.lua exists=%s', n, tostring(ashita.fs.exists(char_file(n)))));
        end
        local scan = scan_folder_names();
        msg(string.format('  folder scan: %d character file(s)%s', #scan, (#scan > 0) and (': ' .. table.concat(scan, ', ')) or ''));
        local raw_ok, raw = pcall(function () return ashita.fs.get_directory(whohas.data_path); end);
        if (raw_ok and type(raw) == 'table') then
            local n = 0;
            local sample = { };
            for _, e in pairs(raw) do n = n + 1; if (#sample < 3) then table.insert(sample, tostring(e)); end end
            msg(string.format('  get_directory returned %d entr%s%s', n, (n == 1) and 'y' or 'ies', (#sample > 0) and (', e.g. ' .. table.concat(sample, ' | ')) or ''));
        else
            msg('  get_directory returned nothing (' .. tostring(raw) .. ')');
        end
        return;
    end

    if (sub == 'pin') then
        local id = AshitaCore:GetMemoryManager():GetInventory():GetSelectedItemId();
        if (id == nil or id == 0 or id == GIL_ID) then
            msg_err('Select an item first.');
            return;
        end
        whohas.pinned = true;
        whohas.pinned_item = id;
        msg_ok('Pinned ' .. item_display_name(id) .. '. /whohas unpin to release.');
        return;
    end

    if (sub == 'unpin') then
        whohas.pinned = false;
        whohas.pinned_item = 0;
        msg('Unpinned.');
        return;
    end

    if (sub == 'current') then
        local v = on_off(args[3]);
        if (v == nil) then msg_err('Usage: /whohas current on|off'); return; end
        whohas.settings.show_current = v;
        whohas.data_version = whohas.data_version + 1;
        settings.save();
        msg(v and 'Including the logged-in character.' or 'Hiding the logged-in character.');
        return;
    end

    if (sub == 'filter') then
        local v = on_off(args[3]);
        if (v == nil) then msg_err('Usage: /whohas filter on|off'); return; end
        whohas.settings.menu_filter = v;
        settings.save();
        msg(v and 'Showing only inside item menus.' or 'Showing whenever an item is selected.');
        return;
    end

    if (sub == 'missing') then
        local v = on_off(args[3]);
        if (v == nil) then msg_err('Usage: /whohas missing on|off'); return; end
        whohas.settings.show_missing = v;
        settings.save();
        msg(v and 'Box shows even when no character has the item.' or 'Box hidden when no character has the item.');
        return;
    end

    if (sub == 'age') then
        local v = on_off(args[3]);
        if (v == nil) then msg_err('Usage: /whohas age on|off'); return; end
        whohas.settings.show_age = v;
        settings.save();
        msg(v and 'Showing data age.' or 'Hiding data age.');
        return;
    end

    if (sub == 'menu') then
        local name = get_menu_name();
        if (name == nil) then
            msg_err('Menu signature not found on this client.');
        else
            msg(string.format('Current menu: "%s"%s', name, (#name == 0) and ' (none open)' or ''));
        end
        return;
    end

    if (sub == 'menus') then
        local action = (args[3] or ''):lower();
        local kw = (args[4] or ''):lower();
        if (action == 'add' and #kw > 0) then
            local list = { };
            for k in whohas.settings.menus:gmatch('[^,%s]+') do
                if (k:lower() ~= kw) then table.insert(list, k); end
            end
            table.insert(list, kw);
            whohas.settings.menus = table.concat(list, ',');
            settings.save();
            msg_ok('Added menu keyword "' .. kw .. '".');
        elseif ((action == 'remove' or action == 'del') and #kw > 0) then
            local list = { };
            local removed = false;
            for k in whohas.settings.menus:gmatch('[^,%s]+') do
                if (k:lower() ~= kw) then table.insert(list, k); else removed = true; end
            end
            whohas.settings.menus = table.concat(list, ',');
            settings.save();
            msg(removed and ('Removed menu keyword "' .. kw .. '".') or ('Keyword "' .. kw .. '" was not in the list.'));
        elseif (action == 'reset') then
            whohas.settings.menus = defaults.menus;
            settings.save();
            msg_ok('Menu keywords reset to defaults.');
        else
            msg('Menu keywords: ' .. whohas.settings.menus);
            msg('Use /whohas menus add <kw>, remove <kw>, or reset.');
        end
        return;
    end

    if (sub == 'lock' or sub == 'unlock') then
        whohas.settings.locked = (sub == 'lock');
        settings.save();
        msg(whohas.settings.locked and 'Box position locked.' or 'Box position unlocked.');
        return;
    end

    if (sub == 'pos') then
        local x = tonumber(args[3]);
        local y = tonumber(args[4]);
        if (x == nil or y == nil) then msg_err('Usage: /whohas pos <x> <y>'); return; end
        whohas.settings.pos_x = x;
        whohas.settings.pos_y = y;
        whohas.force_pos = true;
        settings.save();
        msg_ok(string.format('Box will move to %d, %d the next time it is shown.', x, y));
        return;
    end

    if (sub == 'alpha' or sub == 'opacity') then
        local a = tonumber(args[3]);
        if (a == nil or a < 0.1 or a > 1.0) then msg_err('Usage: /whohas alpha <0.1-1.0>'); return; end
        whohas.settings.opacity = a;
        settings.save();
        msg_ok(string.format('Opacity set to %.2f.', a));
        return;
    end

    if (sub == 'server') then
        local v = (args[3] or ''):lower();
        if (v == 'horizon' or v == 'retail') then
            whohas.settings.server = v;
            settings.save();
            slips.set_server(v);
            whohas.data_version = whohas.data_version + 1;
            msg_ok(string.format('Server set to %s: storage slip bit order and the Porter Moogle shop list now follow %s.', v, v));
            msg('Slip contents already on file were decoded with the previous order; /whohas scan on each character (or log in on them) refreshes them.');
            return;
        end
        msg(string.format('Server: %s (slip bit order and shop list). Use /whohas server horizon|retail.', whohas.settings.server));
        return;
    end

    if (sub == 'forget') then
        forget_char(args[3]);
        return;
    end

    if (sub == 'slip' or sub == 'slips') then
        local n = tonumber(args[3]);
        if (n == nil) then
            -- No number: summarise every slip anyone holds.
            local lines = { };
            for cname, c in pairs(whohas.chars) do
                for sid, s in pairs(c.slips or { }) do
                    table.insert(lines, { sid = sid, text = string.format('%s: %s (%s) holds %d item(s)', slips.name(sid), cname, container_name(s.container or 0), #s.items) });
                end
            end
            if (#lines == 0) then msg('No character has a storage slip on file.'); return; end
            table.sort(lines, function (a, b) if (a.sid ~= b.sid) then return a.sid < b.sid; end return a.text < b.text; end);
            msg('Storage slips on file:');
            for _, l in ipairs(lines) do msg('  ' .. l.text); end
            msg('Use /whohas slip <number> to list what is on one.');
            return;
        end
        local sid = 29311 + n;
        if (not slips.is_slip(sid)) then msg_err(string.format('No such slip. Use 1-%d.', #slips.ids)); return; end
        local any = false;
        for cname, c in pairs(whohas.chars) do
            local s = (c.slips or { })[sid];
            if (s ~= nil) then
                any = true;
                msg(string.format('%s: %s (%s), %d item(s) stored', slips.name(sid), cname, container_name(s.container or 0), #s.items));
                local labels = { };
                for _, id in ipairs(s.items) do table.insert(labels, item_display_name(id)); end
                table.sort(labels);
                for _, l in ipairs(labels) do msg('    ' .. l); end
            end
        end
        if (not any) then msg(string.format('No character has %s on file.', slips.name(sid))); end
        return;
    end

    if (sub == 'slipfit') then
        local v = on_off(args[3]);
        if (v == nil) then msg_err('Usage: /whohas slipfit on|off'); return; end
        whohas.settings.show_slip_fit = v;
        whohas.data_version = whohas.data_version + 1;
        settings.save();
        msg(v and 'Showing which slip an item fits.' or 'Hiding slip fit info.');
        return;
    end

    if (sub == 'variants' or sub == 'versions') then
        local v = on_off(args[3]);
        if (v == nil) then msg_err('Usage: /whohas variants on|off'); return; end
        whohas.settings.show_variants = v;
        whohas.data_version = whohas.data_version + 1;
        settings.save();
        msg(v and 'Showing +1 / -1 / NQ versions of the selected item.' or 'Hiding other versions.');
        return;
    end

    if (sub == 'slipitems') then
        local v = on_off(args[3]);
        if (v == nil) then msg_err('Usage: /whohas slipitems on|off'); return; end
        whohas.settings.show_slip_items = v;
        settings.save();
        msg(v and 'Listing slip contents when a slip is selected.' or 'Hiding slip contents.');
        return;
    end

    if (sub == 'debug') then
        local inv = AshitaCore:GetMemoryManager():GetInventory();
        local id = inv:GetSelectedItemId();
        local idx = inv:GetSelectedItemIndex();
        local nm = inv:GetSelectedItemName();
        local menu = get_menu_name();
        msg(string.format('Selected: id=%s index=%s name="%s"', tostring(id), tostring(idx), tostring(nm)));
        msg(string.format('Menu: "%s"  in_item_menu=%s  ready=%s  me=%s  chars=%d',
            tostring(menu), tostring(in_item_menu()), tostring(whohas.ready), tostring(whohas.me), (function () local n = 0; for _ in pairs(whohas.chars) do n = n + 1; end return n; end)()));
        msg('Data path: ' .. tostring(whohas.data_path) .. '  (/whohas files for what is on disk)');
        if (hqpairs ~= nil) then
            local rel = hqpairs.related(id or 0);
            local parts = { };
            for _, r in ipairs(rel) do table.insert(parts, string.format('%s=%s', r.role, item_display_name(r.id))); end
            msg(string.format('hqpairs: %d group(s) loaded; related to selected: %s', #(hqpairs.groups or { }), (#parts > 0) and table.concat(parts, ', ') or 'none'));
        else
            msg('hqpairs: not loaded (hqpairs.lua missing); only +1 / -1 names are matched.');
        end
        return;
    end

    msg_err('Unknown command. /whohas help for the list.');
end);

-------------------------------------------------------------------------------
-- Packets: track when this character's inventory is trustworthy
-------------------------------------------------------------------------------
ashita.events.register('packet_in', 'whohas_packet_in_cb', function (e)
    if (e.id == 0x000A) then
        -- Zone in: the server is about to resend every container.
        whohas.ready = false;
        whohas.dirty = false;
        whohas.zoned_at = os.time();
        local ok, name = pcall(struct.unpack, 'c16', e.data, 0x84 + 0x01);
        if (ok and type(name) == 'string') then
            name = name:gsub('%z', '');
            if (valid_name(name)) then whohas.me = name; end
        end
        return;
    end

    if (e.id == 0x000B) then
        -- Zone out or logout: stop trusting the containers until 0x1D arrives again.
        whohas.ready = false;
        whohas.dirty = false;
        whohas.zoned_at = 0;
        return;
    end

    if (e.id == 0x001D) then
        -- Inventory finished loading.
        whohas.ready = true;
        whohas.dirty = true;
        whohas.dirty_at = os.time();
        return;
    end

    if (e.id == 0x001E or e.id == 0x001F or e.id == 0x0020) then
        -- Item quantity / assignment / update.
        if (whohas.ready) then
            whohas.dirty = true;
            whohas.dirty_at = os.time();
        end
        return;
    end
end);

-------------------------------------------------------------------------------
-- Render
-------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'whohas_present_cb', function ()
    tick_snapshot();

    if (not whohas.settings.enabled) then return; end
    if (not is_logged_in()) then return; end

    local id;
    if (whohas.pinned and whohas.pinned_item > 0) then
        id = whohas.pinned_item;
    else
        id = AshitaCore:GetMemoryManager():GetInventory():GetSelectedItemId();
        if (id == nil or id == 0 or id == GIL_ID) then return; end
        if (not in_item_menu()) then return; end
    end

    draw_box(id);
end);

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------
settings.register('settings', 'whohas_settings_cb', function (s)
    if (s ~= nil) then
        whohas.settings = s;
        slips.set_server(whohas.settings.server);
    end
    settings.save();
end);

ashita.events.register('load', 'whohas_load_cb', function ()
    ensure_dirs();
    slips.set_server(whohas.settings.server);
    local me = get_me();
    whohas.me = me;
    local n, ni, ns = load_all_chars();
    if (is_logged_in()) then
        -- Loaded mid-session: the inventory already finished loading long ago.
        whohas.ready = true;
        whohas.dirty = true;
        whohas.dirty_at = os.time() + (LOAD_DELAY - SNAPSHOT_DELAY);
        whohas.last_counter = AshitaCore:GetMemoryManager():GetInventory():GetContainerUpdateCounter();
    end
    if (pGameMenu == nil or pGameMenu == 0) then
        msg_err('Menu signature not found; the box will show whenever an item is selected.');
    end
    msg(string.format('Loaded %d character file(s) from %s. /whohas help for commands.', n, tostring(whohas.data_path)));
    if (hqpairs == nil) then
        msg_err('hqpairs.lua not found next to whohas.lua; NQ/HQ pairs with different names (Crimson/Blood, cursed, abjurations) will not be matched.');
    end
end);

ashita.events.register('unload', 'whohas_unload_cb', function ()
    if (whohas.ready and is_logged_in()) then
        snapshot(false);
    end
    settings.save();
end);
