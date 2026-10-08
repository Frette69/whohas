"""Generate slips.lua (Porter Moogle storage slip contents, in bit order, for two servers).

    python tools/gen_slips.py <path-to-lsb> <path-to-windower-resources> <output slips.lua>

  horizon : LandSandBoat scripts/globals/porter_slip_items.lua resolved through
            scripts/enum/item.lua. HorizonXI's server descends from LSB, so this is the
            bit order its slips really use.
  retail  : Windower/Resources resources_data/slips.lua, the retail order.

Position in each list is the bit position in the slip's Extra data. The two orders differ on
a few slips, and retail has more slips, which is why the addon carries both and lets the
player pick with /whohas server.
"""
import re, sys, hashlib, os

HORIZON_SOLD = [1, 2, 4, 5, 6, 7, 11, 12, 19, 22]   # slips the Porter Moogle sells on HorizonXI
BASE = 29311                                       # Storage Slip NN has item id BASE + NN

def read_lsb(lsb):
    enum = {}
    for m in re.finditer(r'^\s*([A-Z0-9_]+)\s*=\s*(\d+)\s*,', open(os.path.join(lsb, 'scripts', 'enum', 'item.lua'), encoding='utf-8', errors='replace').read(), re.M):
        enum[m.group(1)] = int(m.group(2))
    slips = {}
    cur = None
    for line in open(os.path.join(lsb, 'scripts', 'globals', 'porter_slip_items.lua'), encoding='utf-8', errors='replace'):
        m = re.match(r'\s*\[xi\.item\.(MOOGLE_STORAGE_SLIP_\d+)\]', line)
        if m:
            cur = enum[m.group(1)]; slips[cur] = []; continue
        m = re.match(r'\s*xi\.item\.([A-Z0-9_]+)\s*,', line)
        if m and cur is not None:
            slips[cur].append(enum.get(m.group(1), 0)); continue
        m = re.match(r'\s*(\d+)\s*,', line)
        if m and cur is not None:
            slips[cur].append(int(m.group(1)))
    return {k: v for k, v in slips.items() if v}

def read_retail(res):
    src = open(os.path.join(res, 'resources_data', 'slips.lua'), encoding='utf-8', errors='replace').read()
    slips = {}
    for m in re.finditer(r'\{id=\d+,en="Storage Slip (\d+)".*?item_id=(\d+),items=\{([^}]*)\}', src):
        n, item_id = int(m.group(1)), int(m.group(2))
        if item_id != BASE + n:
            raise SystemExit('unexpected item id %d for slip %d' % (item_id, n))
        ids = [int(x) for x in m.group(3).split(',') if x.strip()]
        if ids:
            slips[item_id] = ids
    return slips

def lua_lists(tab):
    out = []
    for sid in sorted(tab):
        out.append("        [%d] = { -- Storage Slip %02d (%d items)\n            %s,\n        },\n" % (sid, sid - BASE, len(tab[sid]), ', '.join(str(i) for i in tab[sid])))
    return ''.join(out)

def main(lsb, res, out):
    horizon = read_lsb(lsb)
    retail = read_retail(res)
    max_n = max(sid - BASE for sid in list(horizon) + list(retail))
    differ = [sid - BASE for sid in sorted(set(horizon) | set(retail)) if horizon.get(sid) != retail.get(sid)]

    o = []
    o.append("--[[\n* whohas - storage slip data\n*\n* Item ids storable on each Porter Moogle storage slip, in bit order. Position matters:\n* bit N of the slip's Extra data (byte N/8, bit N%8) is set when the Nth item is stored.\n*\n* Two orderings are carried, selected with slips.set_server():\n*   horizon : LandSandBoat scripts/globals/porter_slip_items.lua (HorizonXI's server descends\n*             from LSB, so this is the order its slips really use), resolved through\n*             scripts/enum/item.lua.\n*   retail  : Windower/Resources resources_data/slips.lua.\n* They differ on slips " + ', '.join('%02d' % n for n in differ) + ".\n*\n* `sold` lists the slips the Porter Moogle sells on each server (HorizonXI: horizonffxi.wiki).\n--]]\n\nlocal slips = { };\n\n-- Slip number -> item id (Storage Slip 01 = 29312).\nslips.ids = { };\nfor n = 1, " + str(max_n) + " do slips.ids[n] = " + str(BASE) + " + n; end\n\n")
    o.append("-- Slips sold by the Porter Moogle, per server.\nslips.sold = {\n    horizon = { " + ', '.join('[%d] = true' % n for n in HORIZON_SOLD) + " },\n    retail  = { " + ', '.join('[%d] = true' % (sid - BASE) for sid in sorted(retail)) + " },\n};\n\n")
    o.append("-- Slip item id -> ordered list of storable item ids, per server.\nslips.data = {\n    horizon = {\n" + lua_lists(horizon) + "    },\n    retail = {\n" + lua_lists(retail) + "    },\n};\n\n")
    o.append("""slips.server = 'horizon';
slips.items = slips.data.horizon;
slips.available = slips.sold.horizon;
slips.slip_for = { };

-- Selects which server's bit order and shop list to use ('horizon' or 'retail') and rebuilds the
-- reverse map (item id -> list of slip item ids it can be stored on). Returns the name applied.
slips.set_server = function (name)
    if (name ~= 'retail') then name = 'horizon'; end
    slips.server = name;
    slips.items = slips.data[name];
    slips.available = slips.sold[name];
    local rev = { };
    for slip_id, list in pairs(slips.items) do
        for _, item_id in ipairs(list) do
            if (item_id ~= 0) then
                local t = rev[item_id];
                if (t == nil) then t = { }; rev[item_id] = t; end
                table.insert(t, slip_id);
            end
        end
    end
    for _, t in pairs(rev) do table.sort(t); end
    slips.slip_for = rev;
    return name;
end
slips.set_server('horizon');

-- Helpers.
slips.number = function (slip_id) return slip_id - """ + str(BASE) + """; end
slips.name = function (slip_id) return string.format('Storage Slip %02d', slip_id - """ + str(BASE) + """); end
slips.is_slip = function (item_id) return slips.items[item_id] ~= nil; end
slips.sold_here = function (slip_id) return slips.available[slip_id - """ + str(BASE) + """] == true; end
slips.on_horizon = slips.sold_here;   -- old name, kept for compatibility

-- Decodes a slip's Extra bytes (Lua string) into the list of stored item ids, using the
-- currently selected server's order.
slips.decode = function (slip_id, extra)
    local list = slips.items[slip_id];
    local stored = { };
    if (list == nil or type(extra) ~= 'string') then return stored; end
    for k, item_id in ipairs(list) do
        local byte = extra:byte(math.floor((k - 1) / 8) + 1);
        if (byte ~= nil and item_id ~= 0) then
            local b = math.floor(byte / (2 ^ ((k - 1) % 8))) % 2;
            if (b == 1) then table.insert(stored, item_id); end
        end
    end
    return stored;
end

return slips;
""")
    data = ''.join(o).replace('\r\n', '\n').replace('\n', '\r\n').encode('utf-8')
    open(out, 'wb').write(data)
    print('horizon slips:', len(horizon), 'ids:', sum(len(v) for v in horizon.values()),
          '| retail slips:', len(retail), 'ids:', sum(len(v) for v in retail.values()),
          '| differ:', differ, '| bytes:', len(data), 'sha256:', hashlib.sha256(data).hexdigest())

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print(__doc__); sys.exit(2)
    main(sys.argv[1], sys.argv[2], sys.argv[3])
