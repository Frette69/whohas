-- Offline harness: stubs the Ashita v4 environment well enough to exercise whohas.lua logic.
package.path = './?.lua;' .. package.path;
local bit = require('bit');

-- ---------------------------------------------------------------- common / T{}
local Tmt = { __index = table };
function T(t) return setmetatable(t or {}, Tmt); end
function string.args(s) local out = {}; for w in s:gmatch('%S+') do out[#out+1] = w; end return out; end
struct = { unpack = function (fmt, data, off)
    if fmt == 'c16' then return data:sub(off, off + 15); end
    error('unsupported fmt ' .. fmt);
end };

-- ---------------------------------------------------------------- ImGui constants + stub
for _, k in ipairs({ 'ImGuiWindowFlags_NoTitleBar','ImGuiWindowFlags_AlwaysAutoResize','ImGuiWindowFlags_NoFocusOnAppearing',
    'ImGuiWindowFlags_NoNav','ImGuiWindowFlags_NoSavedSettings','ImGuiWindowFlags_NoScrollbar','ImGuiWindowFlags_NoMove',
    'ImGuiTableFlags_SizingFixedFit','ImGuiTableFlags_RowBg','ImGuiTableFlags_BordersInnerV','ImGuiTableColumnFlags_WidthFixed',
    'ImGuiCond_FirstUseEver','ImGuiCond_Always','ImGuiInputTextFlags_EnterReturnsTrue' }) do _G[k] = 1; end
local imgui_log = {};
-- IMGUI_ACT['<Function>:<label>'] = function (label, ...) simulates the user acting on a widget: it may
-- change the bound table and returns what the real call would (true for a click / edit).
IMGUI_ACT = {};
local imgui = setmetatable({}, { __index = function (t, k)
    return function (...)
        local args = { ... };
        local parts = {}; for i = 1, select('#', ...) do parts[#parts+1] = tostring((select(i, ...))); end
        imgui_log[#imgui_log+1] = k .. '(' .. table.concat(parts, ', ') .. ')';
        local act = IMGUI_ACT[k .. ':' .. tostring(args[1])];
        if (act ~= nil) then return act(unpack(args)); end
        if (k:sub(1, 5) == 'Begin') then return true; end
        if (k == 'GetWindowPos') then return 100, 100; end
    end;
end });
package.preload['imgui'] = function () return imgui; end;
package.preload['common'] = function () return {}; end;
package.preload['hqpairs'] = function ()
    local M = { };
    M.groups = { { { 14058, 'NQ' }, { 14059, 'HQ' }, { 1388, 'cursed' }, { 1389, 'cursed -1' }, { 1336, 'abjuration' } } };
    M.by_id = { };
    for gi, g in ipairs(M.groups) do for _, e in ipairs(g) do local t = M.by_id[e[1]]; if (t == nil) then t = { }; M.by_id[e[1]] = t; end table.insert(t, gi); end end
    M.related = function (id)
        local out = { }; local gis = M.by_id[id]; if (gis == nil) then return out; end
        local seen = { [id] = true };
        for _, gi in ipairs(gis) do for _, e in ipairs(M.groups[gi]) do if (not seen[e[1]]) then seen[e[1]] = true; table.insert(out, { id = e[1], role = e[2] }); end end end
        return out;
    end
    return M;
end;
-- Armor Depository sets, same shape as the generated armorsets.lua (two sets are enough here).
package.preload['armorsets'] = function ()
    local M = { };
    M.slots = { 'Head', 'Body', 'Hands', 'Legs', 'Feet' };
    M.sets = {
        { id = 1, ki = 654, cost = 500, label = "Fighter's Armor", pieces = { 12511, 12638, 13961, 14214, 14089 } },
        { id = 63, ki = 861, cost = 1000, label = "Warrior's Armor", pieces = { 15072, 15087, 15102, 15117, 15132 } },
        { id = 89, ki = 1059, cost = 600, label = 'Argent Attire', pieces = { 0, 11310, 0, 16365, 0 } },
    };
    M.by_item = { }; M.by_ki = { };
    for _, s in ipairs(M.sets) do
        M.by_ki[s.ki] = s;
        for _, id in ipairs(s.pieces) do
            if (id ~= 0) then local t = M.by_item[id]; if (t == nil) then t = { }; M.by_item[id] = t; end table.insert(t, s); end
        end
    end
    M.pieces = function (s) local out = { }; for k, id in ipairs(s.pieces) do if (id ~= 0) then table.insert(out, { slot = M.slots[k], id = id }); end end return out; end
    return M;
end;
package.preload['chat'] = function ()
    local c = {};
    for _, k in ipairs({ 'header','message','success','error','warning','critical' }) do c[k] = function (s) return '[' .. k .. ']' .. tostring(s); end end
    c.color1 = function (n, s) return tostring(s); end
    return c;
end;
local saved_settings = nil;
function whohas_settings_probe() return LAST_SETTINGS; end
package.preload['settings'] = function ()
    return {
        load = function (d) local c = { }; for k, v in pairs(d) do c[k] = v; end LAST_SETTINGS = T(c); return LAST_SETTINGS; end,   -- copy, like Ashita's settings.load
        save = function () saved_settings = true; return true; end,
        register = function () end,
    };
end;

-- ---------------------------------------------------------------- addon globals
addon = {};
print_log = {};
local real_print = print;
print = function (s) print_log[#print_log+1] = s; real_print(s); end

-- events
local events = {};
ashita = {
    events = { register = function (name, alias, fn) events[name] = fn; end },
    memory = {
        find = function () return 0x1000; end,
        read_uint32 = function (p) return 0x2000; end,
        read_string = function (p, n) return MENU_NAME or ''; end,
    },
    fs = {
        exists = function (p) p = p:gsub('\\', '/'); local f = io.open(p, 'r'); if f then f:close(); return true; end return os.execute('test -d "' .. p .. '"') == 0; end,
        create_dir = function (p) p = p:gsub('\\', '/'); os.execute('mkdir -p "' .. p .. '"'); return true; end,
        get_directory = function (p)
            if DIR_MODE == 'nil' then return nil; end
            local orig = p; p = p:gsub('\\', '/'); local out = {}; local h = io.popen('ls "' .. p .. '" 2>/dev/null');
            for line in h:lines() do out[#out+1] = (DIR_MODE == 'full') and (orig .. line) or line; end h:close(); return out;
        end,
    },
};

-- game state
DIR_MODE = 'names';
MENU_NAME = 'menu    inventor';
LOGIN = 2;
SELECTED = 0;
COUNTER = 1;
CHAR = { Name = 'Alpha', ServerId = 111 };
CONTAINERS = {};   -- cid -> { [idx] = { Id=, Count= } }
KEY_ITEMS = {};    -- key item id -> true for the logged-in character
local KI_NAMES = { [654] = "Fighter's armor claim slip", [861] = "Warrior's armor claim slip" };   -- 1059 deliberately unnamed: falls back to the generated label
local ITEM_DB = { [4096] = { Name = { 'Fire Crystal' }, StackSize = 12 }, [12345] = { Name = { 'Scorpion Harness' }, StackSize = 1 }, [4509] = { Name = { 'Distilled Water' }, StackSize = 12 }, [12511] = { Name = { 'Fighters Mask' }, LogNameSingular = { "fighter's mask" }, StackSize = 1 }, [12638] = { Name = { 'Fighters Lorica' }, StackSize = 1 }, [13868] = { Name = { 'Wyrm Armet' }, StackSize = 1 }, [29315] = { Name = { 'Storage Slip 04' }, StackSize = 1 }, [15225] = { Name = { 'Fgtr. Mask +1' }, LogNameSingular = { "fighter's mask +1" }, StackSize = 1 }, [15072] = { Name = { 'Abyss Burgeonet' }, StackSize = 1 }, [15245] = { Name = { 'Abyss Burgeonet +1' }, StackSize = 1 }, [29318] = { Name = { 'Storage Slip 07' }, StackSize = 1 }, [14058] = { Name = { 'Crimson Fng. Gnt.' }, LogNameSingular = { 'crimson finger gauntlets' }, StackSize = 1 }, [14059] = { Name = { 'Blood Fng. Gnt.' }, LogNameSingular = { 'blood finger gauntlets' }, StackSize = 1 }, [1336] = { Name = { 'Wyrmal Abj: Hn.' }, LogNameSingular = { 'wyrmal abjuration: hands' }, StackSize = 1 }, [15571] = { Name = { 'Slip5 Pos54 Horizon' }, StackSize = 1 }, [15362] = { Name = { 'Slip5 Pos54 Retail' }, StackSize = 1 }, [13961] = { Name = { 'Fighters Mufflers' }, StackSize = 1 }, [14214] = { Name = { 'Fighters Cuisses' }, StackSize = 1 }, [14089] = { Name = { 'Fighters Leggings' }, StackSize = 1 }, [11310] = { Name = { 'Argent Coat' }, StackSize = 1 }, [16365] = { Name = { 'Argent Pants' }, StackSize = 1 } };

function GetPlayerEntity() return CHAR; end
AshitaCore = {
    GetInstallPath = function () return './fakeinstall'; end,
    GetMemoryManager = function () return {
        GetPlayer = function () return { GetLoginStatus = function () return LOGIN; end, HasKeyItem = function (_, id) return KEY_ITEMS[id] == true; end }; end,
        GetInventory = function () return {
            GetSelectedItemId = function () return SELECTED; end,
            GetSelectedItemIndex = function () return 3; end,
            GetSelectedItemName = function () return 'x'; end,
            GetContainerUpdateCounter = function () return COUNTER; end,
            GetContainerCountMax = function (_, cid) return CONTAINERS[cid] and 80 or 0; end,
            GetContainerItem = function (_, cid, idx) local c = CONTAINERS[cid]; return c and c[idx] or { Id = 0, Count = 0 }; end,
        }; end,
    }; end,
    GetResourceManager = function () return { GetItemById = function (_, id) return ITEM_DB[id]; end, GetString = function (_, tbl, id) if (tbl == 'keyitems.names') then return KI_NAMES[id]; end return nil; end }; end,
    GetChatManager = function () return { ParseAutoTranslate = function (_, s) return s; end }; end,
};

local real_open = io.open; io.open = function (p, m) return real_open(p:gsub('\\', '/'), m); end
local real_remove = os.remove; os.remove = function (p) return real_remove((p:gsub('\\', '/'))); end
local real_loadfile = loadfile; loadfile = function (p) return real_loadfile((p:gsub('\\', '/'))); end
-- ---------------------------------------------------------------- run
os.execute('rm -rf ./fakeinstall');
dofile('whohas.lua');

local function present() events['d3d_present'](); end
local function packet(id, data) events['packet_in']({ id = id, data = data or string.rep('\0', 256) }); end
local function cmd(s) events['command']({ command = s }); end
-- Delivery Box result packet (0x4B) as the server builds it: control form (0x14 bytes) when no item
-- is given, full form (0x58 bytes) with ItemNo at 0x30 and Stack at 0x38 otherwise.
local function dbox_packet(command, box, slot, result, id, count)
    local size = (id ~= nil) and 0x58 or 0x14;
    local p = {};
    for i = 1, size do p[i] = 0; end
    p[0x01] = 0x4B; p[0x02] = size / 2;
    p[0x05] = command; p[0x06] = box; p[0x07] = slot; p[0x0D] = result;
    if (id ~= nil) then
        p[0x31] = id % 256; p[0x32] = math.floor(id / 256) % 256;
        p[0x39] = count % 256; p[0x3A] = math.floor(count / 256) % 256; p[0x3B] = math.floor(count / 65536) % 256; p[0x3C] = math.floor(count / 16777216) % 256;
    end
    local s = {};
    for i = 1, size do s[i] = string.char(p[i]); end
    return table.concat(s);
end

-- Character A: fire crystals in inventory + safe, harness in locker
CONTAINERS = { [0] = { [0] = { Id = 65535, Count = 5000 }, [1] = { Id = 4096, Count = 12 } }, [1] = { [1] = { Id = 4096, Count = 7 }, [2] = { Id = 29315, Count = 1, Extra = string.char(0x03) .. string.rep('\0', 27) }, [3] = { Id = 14059, Count = 1 } }, [4] = { [1] = { Id = 12345, Count = 1 }, [2] = { Id = 12511, Count = 1 } } };
events['load']();
assert(ashita.fs.exists('./fakeinstall/config/addons/whohas/chars/'), 'data dir not created');

-- Not ready yet until 0x1D
packet(0x000A, string.rep('\0', 0x84) .. 'Alpha' .. string.rep('\0', 20));
present();
assert(not ashita.fs.exists('./fakeinstall/config/addons/whohas/chars/Alpha.lua'), 'wrote before ready');
packet(0x001D);
-- simulate time passing: monkeypatch os.time
local base = os.time(); local offset = 0; local real_time = os.time; os.time = function () return real_time() + offset; end
offset = 5; present();
assert(ashita.fs.exists('./fakeinstall/config/addons/whohas/chars/Alpha.lua'), 'snapshot not written after ready');
real_print(io.open('./fakeinstall/config/addons/whohas/chars/Alpha.lua'):read('*a'));

-- Character B logs in (simulate by switching char + inventory). Bravo has the Fighter's Armor set
-- banked at the Armor Depository (claim slip key item 654).
CHAR = { Name = 'Bravo', ServerId = 222 };
KEY_ITEMS = { [654] = true };
CONTAINERS = { [0] = { [0] = { Id = 65535, Count = 5 }, [2] = { Id = 4096, Count = 3 } }, [8] = { [0] = { Id = 12345, Count = 1 } }, [5] = { [7] = { Id = 4509, Count = 12 } }, [4] = { [0] = { Id = 29315, Count = 1, Extra = string.rep('\0', 6) .. string.char(0x80) .. string.rep('\0', 21) }, [1] = { Id = 29318, Count = 1, Extra = string.char(0x01) .. string.rep('\0', 27) } }, [1] = { [5] = { Id = 15225, Count = 1 } } };
packet(0x000B); packet(0x000A, string.rep('\0', 0x84) .. 'Bravo' .. string.rep('\0', 20)); packet(0x001D);
offset = 15; COUNTER = 2; present(); offset = 18; present();
assert(ashita.fs.exists('./fakeinstall/config/addons/whohas/chars/Bravo.lua'), 'Bravo snapshot missing');
do
    local f = io.open('./fakeinstall/config/addons/whohas/chars/Bravo.lua'):read('*a');
    assert(f:find('claims = { 654 },', 1, true), 'claim slip not saved: ' .. f);
    assert(not f:find('dbox', 1, true), 'dbox written before the box was ever opened');
    local a = io.open('./fakeinstall/config/addons/whohas/chars/Alpha.lua'):read('*a');
    assert(a:find('claims = { },', 1, true), 'empty claims not saved for Alpha: ' .. a);
end

-- Reload from disk and check lookups
cmd('/whohas reload');
cmd('/whohas list');
cmd('/whohas find crystal');
cmd('/whohas find harness');
cmd('/whohas find nothingburger');

-- Overlay: select fire crystal in inventory menu
SELECTED = 4096; imgui_log = {}; present();
local joined = table.concat(imgui_log, '\n');
assert(joined:find('Begin%(whohas'), 'overlay did not draw');
assert(joined:find('Fire Crystal'), 'item name missing');
assert(joined:find('Alpha') and joined:find('Bravo'), 'character rows missing');
assert(joined:find('Total: 22 across 2 characters'), 'total wrong: ' .. joined);
real_print(joined);

-- Slip lookups: Fighters Mask is loose in Alpha's Locker AND on Alpha's slip 04
SELECTED = 12511; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
real_print(joined);
assert(joined:find('Locker x1, Storage Slip 04 %(Safe%)'), 'slip copy missing from Alpha row');
assert(joined:find('Fits Storage Slip 04'), 'fits line missing');
assert(joined:find('Alpha %(Safe, 2 stored%)') and joined:find('Bravo %(Locker, 1 stored%)'), 'slip holders missing');
-- Wyrm Armet only on Bravo's slip
SELECTED = 13868; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('Text%(Bravo%)') or joined:find('TextColored%(.-, Bravo%)'), 'Bravo slip row missing');
assert(joined:find('Storage Slip 04 %(Locker%)'), 'Bravo slip where missing');
assert(joined:find('Text%(1%)'), 'count 1 expected');
-- Selecting the slip itself lists contents
SELECTED = 29315; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
real_print(joined);
assert(joined:find('Safe x1 %(2 stored%)'), 'stored count on slip row missing');
assert(joined:find('Alpha: 2 stored') and joined:find('Fighters Lorica, Fighters Mask'), 'slip contents missing');
assert(joined:find('Bravo: 1 stored') and joined:find('Wyrm Armet'), 'Bravo slip contents missing');
assert(joined:find('PushTextWrapPos') and joined:find('PopTextWrapPos'), 'wrap push/pop unbalanced');
-- Variants: highlighting the NQ Fighters Mask must flag the +1 Bravo holds loose in Safe. The NQ
-- itself is also banked in Bravo's Armor Depository set, so OWNED counts Locker + slip + depository.
SELECTED = 12511; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
real_print(joined);
assert(joined:find('OWNED x3'), 'owned status missing (expected x3: Locker + slip copy + Armor Depository)');
assert(joined:find("Armor Depository %(Fighter's armor%)"), 'depository row missing (key item name should drop "claim slip"): ' .. joined);
assert(joined:find('%+1 owned x1'), '+1 flag missing');
assert(joined:find('Fgtr. Mask %+1') and joined:find('Bravo %(Safe x1%)'), 'variant line missing');
-- Set progress: Alpha holds 2 of 5 Fighter's pieces (mask in Locker + slip, lorica on slip), Bravo has it banked.
assert(joined:find("Armor Depository set: Fighter's armor") and joined:find('5 pieces: Head, Body, Hands, Legs, Feet; 500 gil'), 'set header missing: ' .. joined);
assert(joined:find('Alpha: 2/5, missing Hands, Legs, Feet'), 'Alpha set progress wrong: ' .. joined);
assert(joined:find('Bravo: banked %(claim slip%)') and not joined:find('plus'), 'Bravo banked line wrong: ' .. joined);
-- Reverse: the +1 shows the NQ as owned x3 (depository copy included).
SELECTED = 15225; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('NQ owned x3') and joined:find("Bravo %(Armor Depository %(Fighter's armor%)%)"), 'NQ variant via depository missing: ' .. joined);
-- Toggles: sets off drops the depository copy and the set section, setfit off drops only the section.
cmd('/whohas sets off'); SELECTED = 12511; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('OWNED x2') and not joined:find('Armor Depository %('), 'sets off still shows depository row: ' .. joined);
assert(joined:find('Armor Depository set:'), 'sets off should keep the set section');
cmd('/whohas setfit off'); imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(not joined:find('Armor Depository set:'), 'setfit off still shows the set section');
cmd('/whohas sets on'); cmd('/whohas setfit on');
assert(whohas_settings_probe().show_sets == true and whohas_settings_probe().show_set_fit == true, 'set toggles not saved');
-- A set nobody has anything of (Argent, label from armorsets.lua since the client has no name for it).
SELECTED = 11310; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('Armor Depository set: Argent Attire') and joined:find('2 pieces: Body, Legs; 600 gil') and joined:find('No character holds any piece'), 'empty set section wrong: ' .. joined);
-- /whohas sets lists banked sets with their pieces; /whohas find reaches banked pieces.
print_log = {}; cmd('/whohas sets'); joined = table.concat(print_log, '\n');
assert(joined:find("Bravo: Fighter's armor %(Fighters Mask, Fighters Lorica, Fighters Mufflers, Fighters Cuisses, Fighters Leggings; 500 gil to withdraw%)"), '/whohas sets output wrong: ' .. joined);
print_log = {}; cmd('/whohas find mufflers'); joined = table.concat(print_log, '\n');
assert(joined:find("Fighters Mufflers.-x1 on Bravo.-%(Armor Depository %(Fighter's armor%)%)"), 'find did not reach the depository: ' .. joined);
-- Abyss Burgeonet (NQ) is owned by nobody, but the +1 sits on Bravo's Storage Slip 07
SELECTED = 15072; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
real_print(joined);
assert(joined:find('Not owned by any character'), 'not-owned status missing');
assert(joined:find('%+1 owned x1') and joined:find('Abyss Burgeonet %+1') and joined:find('Storage Slip 07 %(Locker%)'), 'relic +1 on slip not flagged: ' .. joined);
-- Reverse: highlighting the +1 shows nothing extra when nobody has the NQ, and status is OWNED
SELECTED = 15245; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('OWNED x1') and not joined:find('NQ owned'), 'reverse variant check failed');
cmd('/whohas variants off'); SELECTED = 15072; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(not joined:find('%+1 owned'), 'variants off still shows flag');
cmd('/whohas variants on');

-- Different-name HQ: highlighting Crimson Finger Gauntlets (nobody has) must flag Alpha's Blood Finger Gauntlets
SELECTED = 14058; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
real_print(joined);
assert(joined:find('Not owned by any character'), 'crimson should be unowned');
assert(joined:find('| HQ owned x1') and joined:find('Blood Fng. Gnt.') and joined:find('Alpha %(Safe x1%)'), 'Blood not flagged as HQ of Crimson: ' .. joined);
-- And highlighting the abjuration itself flags the HQ reward already owned
SELECTED = 1336; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('| HQ owned x1') and joined:find('Blood Fng. Gnt.'), 'abjuration -> HQ reward not flagged');
-- And the HQ shows no NQ flag (nobody has Crimson)
SELECTED = 14059; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('OWNED x1') and not joined:find('NQ owned'), 'reverse pair check failed');
cmd('/whohas debug');

-- Item that fits a slip nobody has
SELECTED = 12008; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('Fits Storage Slip 08') and joined:find('no character has this slip') and joined:find('not sold on this server'), 'fits/no-holder text missing: ' .. joined);
cmd('/whohas find fighters'); cmd('/whohas slip'); cmd('/whohas slip 4'); cmd('/whohas slip 99'); cmd('/whohas slipfit off'); cmd('/whohas slipfit on'); cmd('/whohas slipitems off'); cmd('/whohas slipitems on');

-- Delivery Box: the server lists the inbox when it opens (PostOpen, then Work for slots 0-7).
-- Bravo's inbox: 12 Distilled Water, a Scorpion Harness, 5000 gil (ignored), the rest empty.
print_log = {}; cmd('/whohas dbox'); assert(table.concat(print_log, '\n'):find('No Delivery Box contents on file'), 'dbox should be empty before the box is opened');
packet(0x004B, dbox_packet(0x0E, 1, 0xFF, 1));
packet(0x004B, dbox_packet(0x01, 1, 0, 1, 4509, 12));
packet(0x004B, dbox_packet(0x01, 1, 1, 1, 12345, 1));
packet(0x004B, dbox_packet(0x01, 1, 2, 1, 65535, 5000));
for slot = 3, 7 do packet(0x004B, dbox_packet(0x01, 1, slot, 1, 0, 0)); end
packet(0x004B, dbox_packet(0x01, 2, 0, 1, 4096, 99));   -- outgoing box: ignored
packet(0x004B, dbox_packet(0x05, 1, 0xFF, 1));          -- Check (control form): ignored
offset = offset + 5; present();
do
    local bf = io.open('./fakeinstall/config/addons/whohas/chars/Bravo.lua'):read('*a');
    assert(bf:find('dbox = { seen = %d+, items = { %[4509%] = 12, %[12345%] = 1 } }'), 'dbox not saved: ' .. bf);
end
SELECTED = 12345; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('Wardrobe x1, Delivery Box x1') and joined:find('OWNED x3'), 'delivery box row missing: ' .. joined);
-- Taking the harness out (Get, result 1) empties the slot; a failed Get (inventory full, 0xB9) does not.
packet(0x004B, dbox_packet(0x0A, 1, 0, 0xB9, 4509, 12));
packet(0x004B, dbox_packet(0x0A, 1, 1, 1, 12345, 1));
offset = offset + 5; present();
SELECTED = 12345; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(not joined:find('Delivery Box') and joined:find('OWNED x2'), 'taken item still in delivery box: ' .. joined);
-- A new delivery lands in slot 3 (Recv: a result-2 notice without an item, then the item with result 1).
packet(0x004B, dbox_packet(0x06, 1, 3, 2));
packet(0x004B, dbox_packet(0x06, 1, 3, 1, 4096, 3));
offset = offset + 5; present();
SELECTED = 4096; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('Inventory x3, Delivery Box x3'), 'received item missing from delivery box: ' .. joined);
assert(joined:find('Total: 25 across 2 characters'), 'total should include the delivery box: ' .. joined);
print_log = {}; cmd('/whohas dbox'); joined = table.concat(print_log, '\n');
assert(joined:find('Bravo: 2 item%(s%) in the Delivery Box, seen just now: Distilled Water x12, Fire Crystal x3'), '/whohas dbox output wrong: ' .. joined);
print_log = {}; cmd('/whohas find water'); joined = table.concat(print_log, '\n');
assert(joined:find('Distilled Water.-x12 on Bravo.-%(Delivery Box%)') and joined:find('Distilled Water.-x12 on Bravo.-%(Satchel x12%)'), 'find did not reach the delivery box: ' .. joined);
cmd('/whohas dbox off'); SELECTED = 4096; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(not joined:find('Delivery Box') and joined:find('Total: 22 across 2 characters'), 'dbox off still counts the delivery box: ' .. joined);
cmd('/whohas dbox on');
assert(whohas_settings_probe().show_dbox == true, 'dbox toggle not saved');
-- Returning the water to its sender (Reject, result 1) and clearing slot 3 empty the inbox.
packet(0x004B, dbox_packet(0x09, 1, 0, 2, 4509, 12)); packet(0x004B, dbox_packet(0x09, 1, 0, 1, 4509, 12));
packet(0x004B, dbox_packet(0x0B, 1, 3, 1, 4096, 3));
offset = offset + 5; present();
print_log = {}; cmd('/whohas dbox'); joined = table.concat(print_log, '\n');
assert(joined:find('Bravo: 0 item%(s%) in the Delivery Box'), 'inbox should be empty: ' .. joined);
-- Put the water back for the persistence checks further down, and make sure a short or odd packet is harmless.
packet(0x004B, dbox_packet(0x06, 1, 0, 1, 4509, 12));
packet(0x004B, string.rep('\0', 5)); packet(0x004B, dbox_packet(0x01, 1, 9, 1, 4096, 1));
offset = offset + 5; present();
print_log = {}; cmd('/whohas dbox'); assert(table.concat(print_log, '\n'):find('Distilled Water x12'), 'water not back in the inbox');
cmd('/whohas debug');

-- Settings window: /whohas toggles it; widgets change settings through the ImGui stub's action hook.
local function ui_present() imgui_log = {}; present(); return table.concat(imgui_log, '\n'); end
local function act(key, fn) IMGUI_ACT[key] = fn or function () return true; end; ui_present(); IMGUI_ACT = {}; end
local flip = function (label, t) t[1] = not t[1]; return true; end
local WIN = 'Begin:whohas 1.6.0 settings###whohas_settings';
SELECTED = 0; MENU_NAME = 'menu    inventor';
joined = ui_present(); assert(not joined:find('whohas_settings'), 'settings window drawn before /whohas');
cmd('/whohas'); joined = ui_present();
assert(joined:find('Begin%(whohas 1.6.0 settings###whohas_settings') and joined:find('Checkbox%(Overlay enabled') and joined:find('BeginTabItem%(Characters') and joined:find('Combo%(Server'), 'settings window missing: ' .. joined);
assert(joined:find('TextColored%(.-, Bravo%)') and joined:find('Text%(Alpha%)') and joined:find('Button%(Forget##Alpha%)'), 'character table missing: ' .. joined);
-- Checkbox: disables the overlay, then re-enables it.
act('Checkbox:Overlay enabled', flip);
assert(whohas_settings_probe().enabled == false, 'checkbox did not disable the overlay');
SELECTED = 4096; joined = ui_present(); assert(not joined:find('Begin%(whohas, true'), 'overlay drawn while disabled');
act('Checkbox:Overlay enabled', flip);
assert(whohas_settings_probe().enabled == true, 'checkbox did not re-enable the overlay');
joined = ui_present(); assert(joined:find('Begin%(whohas, true'), 'overlay not drawn after re-enable');
-- Opacity slider and position inputs (no item selected, so the overlay does not report its own position back).
SELECTED = 0;
IMGUI_ACT['SliderFloat:Opacity'] = function (label, t) t[1] = 0.42; return true; end;
IMGUI_ACT['InputInt2:Position'] = function (label, t) t[1] = 321; t[2] = 123; return true; end;
ui_present(); IMGUI_ACT = {};
assert(math.abs(whohas_settings_probe().opacity - 0.42) < 0.001 and whohas_settings_probe().pos_x == 321 and whohas_settings_probe().pos_y == 123, 'slider / position not applied');
-- Server combo (1 = horizon, 2 = retail).
act('Combo:Server', function (label, t) t[1] = 2; return true; end);
assert(whohas_settings_probe().server == 'retail', 'combo did not switch to retail');
act('Combo:Server', function (label, t) t[1] = 1; return true; end);
assert(whohas_settings_probe().server == 'horizon', 'combo did not switch back');
-- Menu lists: type into the buffers, apply with the button; lists are normalised.
IMGUI_ACT['InputText:Keywords'] = function (label, t) t[1] = 'Inventor, bank,BANK, custom'; return false; end;
IMGUI_ACT['InputText:Blocked'] = function (label, t) t[1] = 'mogdoor,Foo'; return false; end;
ui_present(); IMGUI_ACT = {};
act('Button:Apply lists');
assert(whohas_settings_probe().menus == 'inventor,bank,custom' and whohas_settings_probe().menus_block == 'mogdoor,foo', 'menu lists not applied: ' .. tostring(whohas_settings_probe().menus) .. ' / ' .. tostring(whohas_settings_probe().menus_block));
act('Button:Reset lists to defaults');
assert(whohas_settings_probe().menus_block:find('bluequip') and whohas_settings_probe().menus:find('tskill') and not whohas_settings_probe().menus:find('custom'), 'menu reset failed');
-- Forget needs a second click; Keep cancels.
act('Button:Forget##Alpha');
assert(ashita.fs.exists('./fakeinstall/config/addons/whohas/chars/Alpha.lua'), 'one click forgot Alpha');
joined = ui_present(); assert(joined:find('Button%(Confirm forget##Alpha%)') and joined:find('Button%(Keep##Alpha%)'), 'confirm buttons missing');
act('Button:Keep##Alpha');
joined = ui_present(); assert(not joined:find('Confirm forget##Alpha') and joined:find('Button%(Forget##Alpha%)'), 'Keep did not cancel');
-- Section toggles refresh the rows: hiding depository pieces drops the depository copy.
act('Checkbox:Pieces banked at the Armor Depository', flip);
SELECTED = 12511; joined = ui_present(); assert(not joined:find('Text%(Armor Depository %(') and joined:find('OWNED x2'), 'sets checkbox did not refresh rows: ' .. joined);
act('Checkbox:Pieces banked at the Armor Depository', flip);
joined = ui_present(); assert(joined:find('Text%(Armor Depository %(') and joined:find('OWNED x3'), 'sets checkbox did not restore rows');
-- Pin / Unpin buttons.
act('Button:Pin the selected item');
MENU_NAME = ''; joined = ui_present(); assert(joined:find('Begin%(whohas, true') and joined:find('Text%(Pinned: Fighters Mask%)'), 'pin button did not pin: ' .. joined);
act('Button:Unpin');
joined = ui_present(); assert(not joined:find('Begin%(whohas, true'), 'unpin button did not release');
MENU_NAME = 'menu    inventor';
-- Reset all asks first; No cancels; Yes resets (opacity and position back to defaults, server kept valid).
act('Button:Reset all settings');
joined = ui_present(); assert(joined:find('Button%(Yes, reset%)') and joined:find('Button%(No%)'), 'reset confirmation missing');
act('Button:No');
joined = ui_present(); assert(not joined:find('Yes, reset'), 'No did not cancel the reset');
act('Button:Reset all settings'); act('Button:Yes, reset');
assert(math.abs(whohas_settings_probe().opacity - 0.85) < 0.001 and whohas_settings_probe().pos_x == 100 and whohas_settings_probe().menus_version == 2, 'reset all did not restore defaults');
-- The X closes the window; /whohas config reopens; /whohas closes again.
act(WIN, function (label, t) t[1] = false; return false; end);
joined = ui_present(); assert(not joined:find('whohas_settings'), 'X did not close the window');
cmd('/whohas config'); joined = ui_present(); assert(joined:find('Begin%(whohas 1.6.0 settings'), '/whohas config did not open');
act('Button:Close'); joined = ui_present(); assert(not joined:find('whohas_settings'), 'Close button did not close');
cmd('/whohas'); joined = ui_present(); assert(joined:find('Begin%(whohas 1.6.0 settings'), '/whohas did not open');
cmd('/whohas'); joined = ui_present(); assert(not joined:find('whohas_settings'), '/whohas did not close');
SELECTED = 0;

-- Server toggle: slip 05 bit 54 is a different item in the retail order, and retail sells slip 08.
CONTAINERS[1][9] = { Id = 29316, Count = 1, Extra = string.rep('\0', 6) .. string.char(0x20) .. string.rep('\0', 21) };
cmd('/whohas scan');
print_log = {}; cmd('/whohas slip 5'); joined = table.concat(print_log, '\n');
assert(joined:find('Slip5 Pos54 Horizon') and not joined:find('Slip5 Pos54 Retail'), 'horizon slip order wrong: ' .. joined);
print_log = {}; cmd('/whohas server'); assert(table.concat(print_log, '\n'):find('Server: horizon'), 'server status missing');
print_log = {}; cmd('/whohas server retail'); assert(table.concat(print_log, '\n'):find('Server set to retail'), 'server switch message missing');
assert(whohas_settings_probe().server == 'retail', 'server setting not saved');
cmd('/whohas scan');
print_log = {}; cmd('/whohas slip 5'); joined = table.concat(print_log, '\n');
assert(joined:find('Slip5 Pos54 Retail') and not joined:find('Slip5 Pos54 Horizon'), 'retail slip order wrong: ' .. joined);
SELECTED = 12008; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
assert(joined:find('Fits Storage Slip 08') and not joined:find('not sold on this server'), 'retail should sell slip 08: ' .. joined);
print_log = {}; cmd('/whohas slip 33'); assert(not table.concat(print_log, '\n'):find('No such slip'), 'retail slip 33 should exist');
print_log = {}; cmd('/whohas slip 34'); assert(table.concat(print_log, '\n'):find('Use 1%-33'), 'slip range message wrong');
cmd('/whohas server horizon'); cmd('/whohas scan');
print_log = {}; cmd('/whohas slip 5'); assert(table.concat(print_log, '\n'):find('Slip5 Pos54 Horizon'), 'switch back to horizon failed');
CONTAINERS[1][9] = nil; cmd('/whohas scan');
real_print(io.open('./fakeinstall/config/addons/whohas/chars/Alpha.lua'):read('*a'));

-- Menu filter: hide when no menu open, show when filter off
MENU_NAME = ''; imgui_log = {}; present(); assert(#imgui_log == 0, 'drew with no menu open');
cmd('/whohas filter off'); imgui_log = {}; present(); assert(#imgui_log > 0, 'did not draw with filter off');
cmd('/whohas filter on'); MENU_NAME = 'menu    magic'; imgui_log = {}; present(); assert(#imgui_log == 0, 'drew in magic menu');
-- Blocked menus win over keyword matches: the Mog House door and the Blue Magic equip screen.
MENU_NAME = 'menu    mogdoor'; imgui_log = {}; present(); assert(#imgui_log == 0, 'drew in mog door menu');
MENU_NAME = 'menu    bluequip'; imgui_log = {}; present(); assert(#imgui_log == 0, 'drew in blue magic equip menu');
cmd('/whohas menus unblock bluequip'); imgui_log = {}; present(); assert(#imgui_log > 0, 'unblock did not take effect');
cmd('/whohas menus block bluequip'); imgui_log = {}; present(); assert(#imgui_log == 0, 'block did not take effect');
MENU_NAME = 'menu    bank    '; imgui_log = {}; present(); assert(#imgui_log > 0, 'did not draw in the Mog House container menu');
MENU_NAME = 'menu    bankmenu'; imgui_log = {}; present(); assert(#imgui_log == 0, 'drew in the gardening menu');

-- Pin keeps it up
MENU_NAME = 'menu    inventor'; cmd('/whohas pin'); MENU_NAME = ''; imgui_log = {}; present(); assert(#imgui_log > 0, 'pin did not keep box');
cmd('/whohas unpin');

-- Current-char exclusion
MENU_NAME = 'menu    inventor'; cmd('/whohas current off'); imgui_log = {}; present();
joined = table.concat(imgui_log, '\n'); assert(not joined:find('Text%(Bravo%)') and not joined:find('TextColored%(.*Bravo'), 'current char still shown');
cmd('/whohas current on');

-- Missing item
SELECTED = 9999; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n'); assert(joined:find('Not stored'), 'missing text absent');

-- menus add/remove, debug, forget, unload
cmd('/whohas menus add foo'); cmd('/whohas menus remove foo'); cmd('/whohas menus'); cmd('/whohas debug'); cmd('/whohas menu');
cmd('/whohas forget alpha'); assert(not ashita.fs.exists('./fakeinstall/config/addons/whohas/chars/Alpha.lua'), 'forget did not delete');
cmd('/whohas pos 50 60'); cmd('/whohas alpha 0.5'); cmd('/whohas lock'); cmd('/whohas unlock'); cmd('/whohas help');
events['unload']();

-- ---------------------------------------------------------------- restart persistence
-- Simulate closing the game and reloading the addon with a fresh Lua state, three ways the
-- directory listing could behave. Bravo.lua exists on disk (Alpha was forgotten above).
local function restart(mode)
    DIR_MODE = mode;
    events = {};
    ashita.events.register = function (name, alias, fn) events[name] = fn; end;
    package.loaded['slips'] = nil;
    dofile('whohas.lua');
    CHAR = { Name = 'Charlie', ServerId = 333 };
    KEY_ITEMS = {};
    CONTAINERS = { [0] = { [0] = { Id = 65535, Count = 1 }, [1] = { Id = 4509, Count = 2 } } };
    LOGIN = 2;
    events['load']();
    local loaded_line = print_log[#print_log];
    print_log = {};
    events['command']({ command = '/whohas list' });
    local joined = table.concat(print_log, '\n');
    assert(joined:find('Bravo'), 'after restart (' .. mode .. ') Bravo missing from list: ' .. joined);
    assert(loaded_line:find('Loaded 1 character file'), 'load message wrong (' .. mode .. '): ' .. tostring(loaded_line));
    -- Claim slips and the Delivery Box come back from Bravo's file.
    MENU_NAME = 'menu    inventor'; SELECTED = 12511; imgui_log = {}; events['d3d_present']();
    joined = table.concat(imgui_log, '\n');
    assert(joined:find("Armor Depository %(Fighter's armor%)"), 'claims lost after restart (' .. mode .. '): ' .. joined);
    SELECTED = 4509; imgui_log = {}; events['d3d_present']();
    joined = table.concat(imgui_log, '\n');
    assert(joined:find('Delivery Box x12'), 'delivery box lost after restart (' .. mode .. '): ' .. joined);
    print_log = {};
    events['command']({ command = '/whohas files' });
    real_print(table.concat(print_log, '\n'));
    -- Charlie snapshot lands in the index too
    offset = offset + 10; events['d3d_present'](); offset = offset + 10; events['d3d_present']();
    local idx = dofile('./fakeinstall/config/addons/whohas/chars/index.lua');
    assert(#idx == 2 and idx[1] == 'Bravo' and idx[2] == 'Charlie', 'index wrong after Charlie snapshot (' .. mode .. '): ' .. table.concat(idx, ','));
    events['command']({ command = '/whohas forget charlie' });
    idx = dofile('./fakeinstall/config/addons/whohas/chars/index.lua');
    assert(#idx == 1 and idx[1] == 'Bravo', 'index wrong after forget (' .. mode .. ')');
    LOGIN = 0; -- logged out before the client closes, so unload does not re-snapshot Charlie
    events['unload']();
end
restart('names');
restart('full');
restart('nil');
-- Settings written by 1.4.0 or earlier: the menu keyword list must be migrated once, keeping custom keywords.
events = {};
ashita.events.register = function (name, alias, fn) events[name] = fn; end;
package.loaded['slips'] = nil;
dofile('whohas.lua');
do
    local st = whohas_settings_probe();
    st.menus = 'inv,bank,mog,custom'; st.menus_block = ''; st.menus_version = 0;
    CHAR = { Name = 'Bravo', ServerId = 222 }; LOGIN = 2;
    print_log = {};
    events['load']();
    assert(table.concat(print_log, '\n'):find('Menu filter updated'), 'migration message missing');
    assert(st.menus_version == 2, 'menus_version not bumped');
    assert(st.menus:find('custom') and st.menus:find('inventor') and st.menus:find('tskill'), 'migrated list missing entries: ' .. st.menus);
    assert(not st.menus:find('mog') and not st.menus:match('^inv,') and not st.menus:find(',inv,'), 'old keywords survived: ' .. st.menus);
    assert(st.menus_block:find('mogdoor'), 'block list not filled: ' .. tostring(st.menus_block));
    print_log = {};
    events['load']();
    assert(not table.concat(print_log, '\n'):find('Menu filter updated'), 'migration ran twice');
    LOGIN = 0; events['unload']();
end
-- Index missing entirely (e.g. upgraded from v1.1.0): folder scan must rebuild it.
os.remove('./fakeinstall/config/addons/whohas/chars/index.lua');
restart('names');
assert(io.open('./fakeinstall/config/addons/whohas/chars/index.lua'), 'index not rebuilt');
-- ---------------------------------------------------------------- tampered data files
-- A character file that carries code instead of data must not run anything, and a hostile
-- name inside it must never become part of a path.
PAYLOAD_RAN = nil;
local tf = io.open('./fakeinstall/config/addons/whohas/chars/Mallory.lua', 'w');
tf:write("PAYLOAD_RAN = true\nlocal h = io.open('./fakeinstall/payload_marker', 'w'); h:write('x'); h:close();\n"
    .. "return { name = '../../../../payload', items = {}, slips = {} }\n");
tf:close();
local ti = io.open('./fakeinstall/config/addons/whohas/chars/index.lua', 'w');
ti:write("return { 'Bravo', 'Mallory', '../../evil' }"); ti:close();
restart('names');
assert(PAYLOAD_RAN == nil, 'tampered character file executed code');
assert(not io.open('./fakeinstall/payload_marker'), 'tampered character file wrote a file');
print_log = {};
events['command']({ command = '/whohas list' });
local listed = table.concat(print_log, '\n');
assert(listed:find('Bravo') and not listed:find('payload') and not listed:find('Mallory'), 'tampered entry was loaded: ' .. listed);
print_log = {};
events['command']({ command = '/whohas forget ../../evil' });
assert(table.concat(print_log, '\n'):find('No stored data'), 'forget accepted a path-like name');
os.remove('./fakeinstall/config/addons/whohas/chars/Mallory.lua');
-- A file whose claims / dbox fields are the wrong shape keeps only the well-formed parts.
local td = io.open('./fakeinstall/config/addons/whohas/chars/Delta.lua', 'w');
td:write("return { name = 'Delta', items = { [12345] = { [0] = 1 } }, slips = {}, claims = { 'x', -5, 654, 1059, 77 },"
    .. " dbox = { seen = 'q', items = { [12345] = 'n', [-1] = 2, [4096] = 2, x = 1 } } }\n");
td:close();
events = {};
ashita.events.register = function (name, alias, fn) events[name] = fn; end;
package.loaded['slips'] = nil;
dofile('whohas.lua');
CHAR = { Name = 'Charlie', ServerId = 333 }; KEY_ITEMS = {}; LOGIN = 2;
events['load']();
print_log = {}; events['command']({ command = '/whohas sets' }); joined = table.concat(print_log, '\n');
assert(joined:find("Delta: Fighter's armor") and joined:find('Delta: Argent Attire %(Argent Coat, Argent Pants; 600 gil'), 'Delta claims not loaded: ' .. joined);
print_log = {}; events['command']({ command = '/whohas dbox' }); joined = table.concat(print_log, '\n');
assert(joined:find('Delta: 1 item%(s%) in the Delivery Box, seen at an unknown time: Fire Crystal x2') and not joined:find('Scorpion'), 'Delta dbox not sanitised: ' .. joined);
SELECTED = 11310; imgui_log = {}; events['d3d_present'](); joined = table.concat(imgui_log, '\n');
assert(joined:find('Delta: banked %(claim slip%)') and joined:find('Armor Depository %(Argent Attire%)'), 'Delta banked set missing: ' .. joined);
events['command']({ command = '/whohas forget delta' });
LOGIN = 0; events['unload']();
real_print('ALL HARNESS CHECKS PASSED');
