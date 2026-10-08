# Changelog

## 1.4.0

- `/whohas server horizon|retail`: picks the storage slip bit order (LandSandBoat vs retail, which differ on slips 03, 05, 14 and 22; retail adds slips 29 to 33) and the Porter Moogle shop list. Default `horizon`. `slips.lua` now carries both orders; `tools/gen_slips.py` takes a Windower/Resources checkout as its second argument.
- Hardening: character and index files are loaded in an empty sandbox and must be plain data tables; character names are validated (letters only) everywhere they become part of a path; `/whohas forget` refuses anything else; the zone-in packet parse is wrapped in `pcall`; index entries that no longer load are dropped.
- The unsold-slip tag reads `(not sold on this server)`.
- Harness: tampered data file and server toggle scenarios.

## 1.3.0

- `hqpairs.lua`: NQ / HQ relations whose names differ (Crimson -> Blood Finger Gauntlets, Koenig -> Kaiser, Adaman -> Armada, abjuration and cursed pieces, crafted HQs with their own names, Leaping -> Bounding Boots). Generated from LandSandBoat data by `tools/gen_hqpairs.py`.
- Variant flags use the relation role: `HQ owned`, `NQ owned`, `cursed owned`, `abjuration owned`.
- `/whohas debug` prints the hqpairs relations for the selected item.
- The addon loads without `hqpairs.lua` and says so; name matching still runs.

## 1.2.0

- Status line: `OWNED xN` or `Not owned by any character`.
- Orange flags when a +1 / -1 / NQ version of the highlighted item is held by any character, loose or on a storage slip, with a section naming who holds it and where.
- `/whohas variants on|off`.

## 1.1.1

- Character files are tracked in `chars\index.lua` as well as found by folder scan, so data persists across sessions regardless of how Ashita lists directories.
- `/whohas files` shows the data folder and exactly which character files are on disk.

## 1.1.0

- Storage slip (Porter Moogle) support: items stored on slips are decoded from the slip's Extra data at snapshot time, appear in the box and count toward the total.
- `Fits Storage Slip NN` line naming every character holding that slip.
- Highlighting a slip lists its contents per character.
- `/whohas slip [n]`, `/whohas slipfit`, `/whohas slipitems`.
- `slips.lua` generated from LandSandBoat `porter_slip_items.lua` by `tools/gen_slips.py`.

## 1.0.0

- First release: on-screen box listing which characters hold the highlighted item, where and how many; per-character snapshot files; `/whohas find`, `list`, `scan`, `pin`, menu filter and position / opacity settings.
