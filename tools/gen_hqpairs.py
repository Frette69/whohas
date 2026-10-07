"""Generate hqpairs.lua (NQ / HQ item relations whose names differ) from a LandSandBoat checkout.

    python tools/gen_hqpairs.py <path-to-lsb> <output hqpairs.lua>

Sources, in order:
  sql/synth_recipes.sql        recipes whose HQ result has a different base name from the NQ result
                               (+1 / -1 style names are matched by whohas itself, so those are skipped)
  scripts/globals/abjurations.lua   abjuration, cursed, cursed -1, NQ reward, HQ reward (5 ids per entry)
  a short list of drop pairs   leaping / bounding boots, emperor / empress hairpin
"""
import re, hashlib, io, os, sys

def main(LSB, out_path):
    names = {}
    for line in io.open(os.path.join(LSB, 'sql', 'item_basic.sql'), encoding='utf-8', errors='replace'):
        m = re.match(r"INSERT INTO `item_basic` VALUES \((\d+),\d+,'((?:[^'\\]|\\.)*)'", line)
        if m:
            names[int(m.group(1))] = m.group(2).replace("\\'", "'")
    def base(n):
        return re.sub(r'_?[+-]\d+$', '', n)

    enum = {}
    for m in re.finditer(r'^\s*([A-Z0-9_]+)\s*=\s*(\d+)\s*,', io.open(os.path.join(LSB, 'scripts', 'enum', 'item.lua'), encoding='utf-8', errors='replace').read(), re.M):
        enum[m.group(1)] = int(m.group(2))

    groups = []   # list of (source, [(id, role), ...])
    seen_keys = set()
    def add_group(source, members):
        members = [(i, r) for i, r in members if i and i in names]
        ids = []
        out = []
        for i, r in members:
            if i not in ids:
                ids.append(i); out.append((i, r))
        if len(out) < 2:
            return
        key = tuple(sorted(ids))
        if key in seen_keys:
            return
        seen_keys.add(key)
        groups.append((source, out))

    # Synthesis recipes: NQ result vs HQ results with a different base name (the +1 rule already covers the rest).
    n_synth = 0
    for line in io.open(os.path.join(LSB, 'sql', 'synth_recipes.sql'), encoding='utf-8', errors='replace'):
        if not line.startswith('INSERT INTO `synth_recipes` VALUES ('):
            continue
        m = re.match(r"INSERT INTO `synth_recipes` VALUES \(([^']*)'", line)
        if not m:
            continue
        f = m.group(1).split(',')
        try:
            desynth = int(f[1]); nq = int(f[21]); hqs = [int(f[22]), int(f[23]), int(f[24])]
        except (ValueError, IndexError):
            continue
        if desynth or nq == 0 or nq not in names:
            continue
        roles = ['HQ', 'HQ2', 'HQ3']
        members = [(nq, 'NQ')]
        for hq, role in zip(hqs, roles):
            if hq and hq != nq and hq in names and hq not in [x for x, _ in members]:
                members.append((hq, role))
        if len(members) < 2:
            continue
        if len({base(names[i]) for i, _ in members}) < 2:
            continue
        before = len(groups); add_group('synth', members); n_synth += len(groups) - before

    # Abjurations: abjuration, cursed, cursed -1, NQ reward, HQ reward (5 per transaction).
    src = io.open(os.path.join(LSB, 'scripts', 'globals', 'abjurations.lua'), encoding='utf-8', errors='replace').read()
    src = re.sub(r'--.*', '', src)
    toks = re.findall(r'xi\.item\.([A-Z0-9_]+)', src)
    n_abj = 0
    for k in range(0, len(toks) - 4, 5):
        abj, cursed, cursed_m1, nq, hq = [enum.get(t) for t in toks[k:k+5]]
        members = [(nq, 'NQ'), (hq, 'HQ'), (cursed, 'cursed'), (cursed_m1, 'cursed -1'), (abj, 'abjuration')]
        before = len(groups); add_group('abjuration', members); n_abj += len(groups) - before

    # Known drop pairs that are not synthesis results.
    by_name = {v: k for k, v in names.items()}
    n_manual = 0
    for nq_name, hq_name in [('leaping_boots', 'bounding_boots'), ('emperor_hairpin', 'empress_hairpin')]:
        if nq_name in by_name and hq_name in by_name:
            before = len(groups); add_group('drop', [(by_name[nq_name], 'NQ'), (by_name[hq_name], 'HQ')]); n_manual += len(groups) - before

    lines = []
    lines.append('--[[')
    lines.append('* whohas - NQ / HQ item relations whose names differ')
    lines.append('*')
    lines.append('* Each group lists related item ids with a role: NQ, HQ, HQ2, HQ3, cursed, cursed -1, abjuration.')
    lines.append('* Generated from LandSandBoat sql/synth_recipes.sql (recipes whose HQ result has a different')
    lines.append('* base name from the NQ result; +1 style names are matched by whohas itself), scripts/globals/')
    lines.append('* abjurations.lua (cursed item + abjuration -> NQ / HQ reward), and a short list of drop pairs.')
    lines.append('--]]')
    lines.append('')
    lines.append('local M = { };')
    lines.append('')
    lines.append('M.groups = {')
    for source, members in groups:
        body = ', '.join('{ %d, %s }' % (i, "'" + r + "'") for i, r in members)
        comment = ' / '.join(names[i] for i, _ in members)
        lines.append('    { %s }, -- %s: %s' % (body, source, comment))
    lines.append('};')
    lines.append('')
    lines.append('-- item id -> list of group indexes')
    lines.append('M.by_id = { };')
    lines.append('for gi, g in ipairs(M.groups) do')
    lines.append('    for _, e in ipairs(g) do')
    lines.append('        local t = M.by_id[e[1]];')
    lines.append('        if (t == nil) then t = { }; M.by_id[e[1]] = t; end')
    lines.append('        table.insert(t, gi);')
    lines.append('    end')
    lines.append('end')
    lines.append('')
    lines.append('-- Every other item related to id, as { id = n, role = s }, de-duplicated.')
    lines.append('M.related = function (id)')
    lines.append('    local out = { };')
    lines.append('    local gis = M.by_id[id];')
    lines.append('    if (gis == nil) then return out; end')
    lines.append('    local seen = { [id] = true };')
    lines.append('    for _, gi in ipairs(gis) do')
    lines.append('        for _, e in ipairs(M.groups[gi]) do')
    lines.append('            if (not seen[e[1]]) then')
    lines.append('                seen[e[1]] = true;')
    lines.append('                table.insert(out, { id = e[1], role = e[2] });')
    lines.append('            end')
    lines.append('        end')
    lines.append('    end')
    lines.append('    return out;')
    lines.append('end')
    lines.append('')
    lines.append('-- Role of id within its first group, or nil.')
    lines.append('M.role_of = function (id)')
    lines.append('    local gis = M.by_id[id];')
    lines.append('    if (gis == nil) then return nil; end')
    lines.append('    for _, e in ipairs(M.groups[gis[1]]) do')
    lines.append('        if (e[1] == id) then return e[2]; end')
    lines.append('    end')
    lines.append('    return nil;')
    lines.append('end')
    lines.append('')
    lines.append('return M;')
    data = ('\r\n'.join(lines) + '\r\n').encode('utf-8')
    open(out_path, 'wb').write(data)
    print('groups:', len(groups), 'synth:', n_synth, 'abjuration:', n_abj, 'drop:', n_manual, 'bytes:', len(data))
    print('sha256:', hashlib.sha256(data).hexdigest())

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(__doc__); sys.exit(2)
    main(sys.argv[1], sys.argv[2])
