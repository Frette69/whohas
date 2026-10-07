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
    'ImGuiCond_FirstUseEver','ImGuiCond_Always' }) do _G[k] = 1; end
local imgui_log = {};
local imgui = setmetatable({}, { __index = function (t, k)
    return function (...) local parts = {}; for i = 1, select('#', ...) do parts[#parts+1] = tostring((select(i, ...))); end imgui_log[#imgui_log+1] = k .. '(' .. table.concat(parts, ', ') .. ')'; if k == 'Begin' or k == 'BeginTable' then return true; end if k == 'GetWindowPos' then return 100, 100; end end;
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
package.preload['chat'] = function ()
    local c = {};
    for _, k in ipairs({ 'header','message','success','error','warning','critical' }) do c[k] = function (s) return '[' .. k .. ']' .. tostring(s); end end
    c.color1 = function (n, s) return tostring(s); end
    return c;
end;
local saved_settings = nil;
package.preload['settings'] = function ()
    return {
        load = function (d) return T(d); end,
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
MENU_NAME = 'menu    inv';
LOGIN = 2;
SELECTED = 0;
COUNTER = 1;
CHAR = { Name = 'Alpha', ServerId = 111 };
CONTAINERS = {};   -- cid -> { [idx] = { Id=, Count= } }
local ITEM_DB = { [4096] = { Name = { 'Fire Crystal' }, StackSize = 12 }, [12345] = { Name = { 'Scorpion Harness' }, StackSize = 1 }, [4509] = { Name = { 'Distilled Water' }, StackSize = 12 }, [12511] = { Name = { 'Fighters Mask' }, LogNameSingular = { "fighter's mask" }, StackSize = 1 }, [12638] = { Name = { 'Fighters Lorica' }, StackSize = 1 }, [13868] = { Name = { 'Wyrm Armet' }, StackSize = 1 }, [29315] = { Name = { 'Storage Slip 04' }, StackSize = 1 }, [15225] = { Name = { 'Fgtr. Mask +1' }, LogNameSingular = { "fighter's mask +1" }, StackSize = 1 }, [15072] = { Name = { 'Abyss Burgeonet' }, StackSize = 1 }, [15245] = { Name = { 'Abyss Burgeonet +1' }, StackSize = 1 }, [29318] = { Name = { 'Storage Slip 07' }, StackSize = 1 }, [14058] = { Name = { 'Crimson Fng. Gnt.' }, LogNameSingular = { 'crimson finger gauntlets' }, StackSize = 1 }, [14059] = { Name = { 'Blood Fng. Gnt.' }, LogNameSingular = { 'blood finger gauntlets' }, StackSize = 1 }, [1336] = { Name = { 'Wyrmal Abj: Hn.' }, LogNameSingular = { 'wyrmal abjuration: hands' }, StackSize = 1 } };

function GetPlayerEntity() return CHAR; end
AshitaCore = {
    GetInstallPath = function () return './fakeinstall'; end,
    GetMemoryManager = function () return {
        GetPlayer = function () return { GetLoginStatus = function () return LOGIN; end }; end,
        GetInventory = function () return {
            GetSelectedItemId = function () return SELECTED; end,
            GetSelectedItemIndex = function () return 3; end,
            GetSelectedItemName = function () return 'x'; end,
            GetContainerUpdateCounter = function () return COUNTER; end,
            GetContainerCountMax = function (_, cid) return CONTAINERS[cid] and 80 or 0; end,
            GetContainerItem = function (_, cid, idx) local c = CONTAINERS[cid]; return c and c[idx] or { Id = 0, Count = 0 }; end,
        }; end,
    }; end,
    GetResourceManager = function () return { GetItemById = function (_, id) return ITEM_DB[id]; end }; end,
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

-- Character B logs in (simulate by switching char + inventory)
CHAR = { Name = 'Bravo', ServerId = 222 };
CONTAINERS = { [0] = { [0] = { Id = 65535, Count = 5 }, [2] = { Id = 4096, Count = 3 } }, [8] = { [0] = { Id = 12345, Count = 1 } }, [5] = { [7] = { Id = 4509, Count = 12 } }, [4] = { [0] = { Id = 29315, Count = 1, Extra = string.rep('\0', 6) .. string.char(0x80) .. string.rep('\0', 21) }, [1] = { Id = 29318, Count = 1, Extra = string.char(0x01) .. string.rep('\0', 27) } }, [1] = { [5] = { Id = 15225, Count = 1 } } };
packet(0x000B); packet(0x000A, string.rep('\0', 0x84) .. 'Bravo' .. string.rep('\0', 20)); packet(0x001D);
offset = 15; COUNTER = 2; present(); offset = 18; present();
assert(ashita.fs.exists('./fakeinstall/config/addons/whohas/chars/Bravo.lua'), 'Bravo snapshot missing');

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
-- Variants: highlighting the NQ Fighters Mask must flag the +1 Bravo holds loose in Safe
SELECTED = 12511; imgui_log = {}; present(); joined = table.concat(imgui_log, '\n');
real_print(joined);
assert(joined:find('OWNED x2'), 'owned status missing (expected x2: Locker + slip copy)');
assert(joined:find('%+1 owned x1'), '+1 flag missing');
assert(joined:find('Fgtr. Mask %+1') and joined:find('Bravo %(Safe x1%)'), 'variant line missing');
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
assert(joined:find('Fits Storage Slip 08') and joined:find('no character has this slip') and joined:find('not sold on Horizon'), 'fits/no-holder text missing: ' .. joined);
cmd('/whohas find fighters'); cmd('/whohas slip'); cmd('/whohas slip 4'); cmd('/whohas slip 99'); cmd('/whohas slipfit off'); cmd('/whohas slipfit on'); cmd('/whohas slipitems off'); cmd('/whohas slipitems on');
real_print(io.open('./fakeinstall/config/addons/whohas/chars/Alpha.lua'):read('*a'));

-- Menu filter: hide when no menu open, show when filter off
MENU_NAME = ''; imgui_log = {}; present(); assert(#imgui_log == 0, 'drew with no menu open');
cmd('/whohas filter off'); imgui_log = {}; present(); assert(#imgui_log > 0, 'did not draw with filter off');
cmd('/whohas filter on'); MENU_NAME = 'menu    magic'; imgui_log = {}; present(); assert(#imgui_log == 0, 'drew in magic menu');

-- Pin keeps it up
MENU_NAME = 'menu    inv'; cmd('/whohas pin'); MENU_NAME = ''; imgui_log = {}; present(); assert(#imgui_log > 0, 'pin did not keep box');
cmd('/whohas unpin');

-- Current-char exclusion
MENU_NAME = 'menu    inv'; cmd('/whohas current off'); imgui_log = {}; present();
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
    CONTAINERS = { [0] = { [0] = { Id = 65535, Count = 1 }, [1] = { Id = 4509, Count = 2 } } };
    LOGIN = 2;
    events['load']();
    local loaded_line = print_log[#print_log];
    print_log = {};
    events['command']({ command = '/whohas list' });
    local joined = table.concat(print_log, '\n');
    assert(joined:find('Bravo'), 'after restart (' .. mode .. ') Bravo missing from list: ' .. joined);
    assert(loaded_line:find('Loaded 1 character file'), 'load message wrong (' .. mode .. '): ' .. tostring(loaded_line));
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
-- Index missing entirely (e.g. upgraded from v1.1.0): folder scan must rebuild it.
os.remove('./fakeinstall/config/addons/whohas/chars/index.lua');
restart('names');
assert(io.open('./fakeinstall/config/addons/whohas/chars/index.lua'), 'index not rebuilt');
real_print('ALL HARNESS CHECKS PASSED');
