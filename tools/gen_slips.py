"""Generate slips.lua (Porter Moogle storage slip contents, in server bit order) from a
LandSandBoat checkout.

    python tools/gen_slips.py <path-to-lsb> <output slips.lua>

Reads scripts/globals/porter_slip_items.lua and resolves the xi.item.* names through
scripts/enum/item.lua. Position in each list is the bit position in the slip's Extra data.
"""
import re, sys, hashlib

HORIZON = [1, 2, 4, 5, 6, 7, 11, 12, 19, 22]   # slips the Porter Moogle sells on HorizonXI

def main(lsb, out):
    enum = {}
    for m in re.finditer(r'^\s*([A-Z0-9_]+)\s*=\s*(\d+)\s*,', open(lsb + '/scripts/enum/item.lua', encoding='utf-8', errors='replace').read(), re.M):
        enum[m.group(1)] = int(m.group(2))
    slips = {}
    cur = None
    for line in open(lsb + '/scripts/globals/porter_slip_items.lua', encoding='utf-8', errors='replace'):
        m = re.match(r'\s*\[xi\.item\.(MOOGLE_STORAGE_SLIP_\d+)\]', line)
        if m:
            cur = enum[m.group(1)]; slips[cur] = []; continue
        m = re.match(r'\s*xi\.item\.([A-Z0-9_]+)\s*,', line)
        if m and cur is not None:
            slips[cur].append(enum.get(m.group(1), 0)); continue
        m = re.match(r'\s*(\d+)\s*,', line)
        if m and cur is not None:
            slips[cur].append(int(m.group(1)))
    slips = {k: v for k, v in slips.items() if v}

    o = []
    o.append("--[[\n* whohas - storage slip data\n*\n* Item ids storable on each Porter Moogle storage slip, in bit order. Position matters:\n* bit N of the slip's Extra data (byte N/8, bit N%8) is set when the Nth item is stored.\n*\n* Generated from LandSandBoat scripts/globals/porter_slip_items.lua (the server-side\n* source of truth for bit order), resolved through scripts/enum/item.lua. This matches the\n* Windower/find slips list except for slips 04, 05 and 22, where LSB differs (LSB wins,\n* since HorizonXI's server is derived from it).\n*\n* `available` lists the slips the Porter Moogle sells on HorizonXI (horizonffxi.wiki).\n--]]\n\nlocal slips = { };\n\n-- Slip number -> item id (Storage Slip 01 = 29312).\nslips.ids = { };\nfor n = 1, 28 do slips.ids[n] = 29311 + n; end\n\n-- Slips sold on HorizonXI.\nslips.available = { " + ', '.join('[%d] = true' % n for n in HORIZON) + " };\n\n-- Slip item id -> ordered list of storable item ids.\nslips.items = {\n")
    for sid in sorted(slips):
        n = sid - 29311
        o.append("    [%d] = { -- Storage Slip %02d (%d items)\n        %s,\n    },\n" % (sid, n, len(slips[sid]), ', '.join(str(i) for i in slips[sid])))
    o.append("};\n\n-- Reverse map: item id -> list of slip item ids it can be stored on.\nslips.slip_for = { };\nfor slip_id, list in pairs(slips.items) do\n    for _, item_id in ipairs(list) do\n        if (item_id ~= 0) then\n            local t = slips.slip_for[item_id];\n            if (t == nil) then t = { }; slips.slip_for[item_id] = t; end\n            table.insert(t, slip_id);\n        end\n    end\nend\nfor _, t in pairs(slips.slip_for) do table.sort(t); end\n\n-- Helpers.\nslips.number = function (slip_id) return slip_id - 29311; end\nslips.name = function (slip_id) return string.format('Storage Slip %02d', slip_id - 29311); end\nslips.is_slip = function (item_id) return slips.items[item_id] ~= nil; end\nslips.on_horizon = function (slip_id) return slips.available[slip_id - 29311] == true; end\n\n-- Decodes a slip's Extra bytes (Lua string) into the list of stored item ids.\nslips.decode = function (slip_id, extra)\n    local list = slips.items[slip_id];\n    local stored = { };\n    if (list == nil or type(extra) ~= 'string') then return stored; end\n    for k, item_id in ipairs(list) do\n        local byte = extra:byte(math.floor((k - 1) / 8) + 1);\n        if (byte ~= nil and item_id ~= 0) then\n            local b = math.floor(byte / (2 ^ ((k - 1) % 8))) % 2;\n            if (b == 1) then table.insert(stored, item_id); end\n        end\n    end\n    return stored;\nend\n\nreturn slips;\n")
    data = ''.join(o).replace('\r\n', '\n').replace('\n', '\r\n').encode('utf-8')
    open(out, 'wb').write(data)
    print('slips:', len(slips), 'ids:', sum(len(v) for v in slips.values()), 'bytes:', len(data), 'sha256:', hashlib.sha256(data).hexdigest())

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(__doc__); sys.exit(2)
    main(sys.argv[1], sys.argv[2])
