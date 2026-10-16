"""Generate armorsets.lua (Armor Depository sets) from a LandSandBoat checkout.

    python tools/gen_armorsets.py <path-to-lsb> <output armorsets.lua>

Sources:
  scripts/globals/armorstorage.lua   the set table: id, group, mask, piece count, head, body, hands,
                                     legs, feet, withdrawal cost, claim slip key item (0 = no piece)
  scripts/enum/key_item.lua          key item name -> id (older checkouts), or
  data/enums/key_item.yaml           the same table in newer checkouts
  sql/item_basic.sql                 item names, only for the comments (optional)

The Armor Depository NPCs take a complete NQ set and hand back a claim slip key item; whohas
reads each character's claim slips to show pieces that are banked there.
"""
import re, sys, hashlib, io, os

# Fallback labels when the client cannot supply the key item name. Enum words that are abbreviated
# or possessive in the real name.
WORDS = {
    'FIGHTERS': "Fighter's", 'HEALERS': "Healer's", 'WIZARDS': "Wizard's", 'WARLOCKS': "Warlock's",
    'ROGUES': "Rogue's", 'HUNTERS': "Hunter's", 'NINJAS': 'Ninja', 'EVOKERS': "Evoker's",
    'SEERS': "Seer's", 'CENTURIONS': "Centurion's", 'WARRIORS': "Warrior's", 'CLERICS': "Cleric's",
    'SORCERERS': "Sorcerer's", 'DUELISTS': "Duelist's", 'ASSASSINS': "Assassin's", 'BARDS': "Bard's",
    'SCOUTS': "Scout's", 'SUMMONERS': "Summoner's", 'CORSAIRS': "Corsair's", 'DANCERS': "Dancer's",
    'SCHOLARS': "Scholar's", 'CASTERS': "Caster's",
}
PHRASES = {
    'MRCCPT_DOUBLET': "Mercenary Captain's Doublet", 'RYLSQR_CHAINMAIL': "Royal Squire's Chainmail",
    'IRNMSK_CUIRASS': "Iron Musketeer's Cuirass", 'TCTMGC_CLOAK': "Tactician Magician's Cloak",
    'HARA_ATE': 'Hara-Ate',
}

def label_for(enum_name):
    n = enum_name
    suffix = ''
    m = re.match(r'^(.*)_CLAIM_SLIP(?:_([MF]))?$', n)
    if m:
        n = m.group(1)
        if m.group(2) == 'M': suffix = ' (male)'
        if m.group(2) == 'F': suffix = ' (female)'
    for sex, word in (('_MALE', ' (male)'), ('_FEMALE', ' (female)')):
        if n.endswith(sex):
            n = n[:-len(sex)]; suffix = word
    if n in PHRASES:
        return PHRASES[n] + suffix
    words = [WORDS.get(w, w.capitalize()) for w in n.split('_')]
    return ' '.join(words) + suffix

def read_key_items(lsb):
    enum = {}
    p = os.path.join(lsb, 'scripts', 'enum', 'key_item.lua')
    if os.path.exists(p):
        for m in re.finditer(r'^\s*([A-Za-z0-9_]+)\s*=\s*(\d+)\s*,', io.open(p, encoding='utf-8', errors='replace').read(), re.M):
            enum[m.group(1).upper()] = int(m.group(2))
        return enum, p
    p = os.path.join(lsb, 'data', 'enums', 'key_item.yaml')
    if os.path.exists(p):
        for m in re.finditer(r'^\s+([A-Za-z0-9_]+):\s+(\d+)\b', io.open(p, encoding='utf-8', errors='replace').read(), re.M):
            enum[m.group(1).upper()] = int(m.group(2))
        return enum, p
    raise SystemExit('no key item enum found under ' + lsb)

def read_sets(lsb, enum):
    src = io.open(os.path.join(lsb, 'scripts', 'globals', 'armorstorage.lua'), encoding='utf-8', errors='replace').read()
    src = re.sub(r'--.*', '', src)
    pat = re.compile(r'(\d+)\s*,\s*(\d+)\s*,\s*(0x[0-9A-Fa-f]+|\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(?:xi\.keyItem|xi\.ki|tpz\.ki)\.([A-Za-z0-9_]+)')
    sets = []
    for m in pat.finditer(src):
        ki_name = m.group(11).upper()
        ki = enum.get(ki_name)
        if ki is None:
            raise SystemExit('unknown key item ' + ki_name)
        pieces = [int(m.group(i)) for i in range(5, 10)]
        count = int(m.group(4))
        if sum(1 for p in pieces if p) != count:
            raise SystemExit('piece count mismatch for set %s' % m.group(1))
        sets.append({ 'id': int(m.group(1)), 'ki': ki, 'ki_name': ki_name, 'cost': int(m.group(10)), 'pieces': pieces, 'label': label_for(ki_name) })
    if not sets:
        raise SystemExit('no sets parsed from armorstorage.lua')
    ids = [s['id'] for s in sets]
    if len(set(ids)) != len(ids):
        raise SystemExit('duplicate set ids')
    return sets

def read_item_names(lsb):
    names = {}
    p = os.path.join(lsb, 'sql', 'item_basic.sql')
    if not os.path.exists(p):
        return names
    for line in io.open(p, encoding='utf-8', errors='replace'):
        m = re.match(r"INSERT INTO `item_basic` VALUES \((\d+),\d+,'((?:[^'\\]|\\.)*)'", line)
        if m:
            names[int(m.group(1))] = m.group(2).replace("\\'", "'")
    return names

def main(lsb, out):
    enum, enum_path = read_key_items(lsb)
    sets = read_sets(lsb, enum)
    names = read_item_names(lsb)
    lines = []
    lines.append('--[[')
    lines.append('* whohas - Armor Depository sets')
    lines.append('*')
    lines.append('* The Armor Depository NPCs take a complete NQ armor set and hand back a claim slip key item;')
    lines.append('* paying the fee with the key item returns the pieces. Each entry: the set id, the claim slip')
    lines.append('* key item id, the gil cost to withdraw, a fallback label, and the Head / Body / Hands / Legs /')
    lines.append('* Feet item ids (0 = the set has no piece in that slot).')
    lines.append('* Generated from LandSandBoat scripts/globals/armorstorage.lua and the key item enum.')
    lines.append('--]]')
    lines.append('')
    lines.append('local M = { };')
    lines.append('')
    lines.append("M.slots = { 'Head', 'Body', 'Hands', 'Legs', 'Feet' };")
    lines.append('')
    lines.append('M.sets = {')
    for s in sets:
        comment = ', '.join(names.get(p, str(p)) for p in s['pieces'] if p)
        lines.append("    { id = %d, ki = %d, cost = %d, label = %s, pieces = { %s } }, -- %s" % (
            s['id'], s['ki'], s['cost'], lua_str(s['label']), ', '.join(str(p) for p in s['pieces']), comment))
    lines.append('};')
    lines.append('')
    lines.append('-- item id -> list of sets that include it; claim slip key item id -> set.')
    lines.append('M.by_item = { };')
    lines.append('M.by_ki = { };')
    lines.append('for _, s in ipairs(M.sets) do')
    lines.append('    M.by_ki[s.ki] = s;')
    lines.append('    for _, id in ipairs(s.pieces) do')
    lines.append('        if (id ~= 0) then')
    lines.append('            local t = M.by_item[id];')
    lines.append('            if (t == nil) then t = { }; M.by_item[id] = t; end')
    lines.append('            table.insert(t, s);')
    lines.append('        end')
    lines.append('    end')
    lines.append('end')
    lines.append('')
    lines.append('-- The pieces of a set as { slot = name, id = item id }, skipping empty slots.')
    lines.append('M.pieces = function (s)')
    lines.append('    local out = { };')
    lines.append('    for k, id in ipairs(s.pieces) do')
    lines.append('        if (id ~= 0) then table.insert(out, { slot = M.slots[k], id = id }); end')
    lines.append('    end')
    lines.append('    return out;')
    lines.append('end')
    lines.append('')
    lines.append('return M;')
    data = ('\r\n'.join(lines) + '\r\n').encode('utf-8')
    open(out, 'wb').write(data)
    n_items = sum(1 for s in sets for p in s['pieces'] if p)
    print('sets:', len(sets), 'pieces:', n_items, 'key items from:', os.path.relpath(enum_path, lsb), 'bytes:', len(data))
    print('sha256:', hashlib.sha256(data).hexdigest())

def lua_str(s):
    s = s.replace('\\', '\\\\')
    if "'" in s and '"' not in s:
        return '"' + s + '"'
    return "'" + s.replace("'", "\\'") + "'"

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(__doc__); sys.exit(2)
    main(sys.argv[1], sys.argv[2])
