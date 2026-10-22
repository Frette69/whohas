# Changelog

## 1.6.0

- Settings window: `/whohas` (or `/whohas config`) now opens an ImGui window with every option as a checkbox, slider or text box, in four tabs (Overlay, Sections, Menus, Characters). Menus shows the open game menu name live with the keyword and block lists editable in place; Characters lists every character on file with Snapshot, Reload and a two-click Forget. Changes save immediately; the text commands are unchanged. `/whohas on|off` still toggles the overlay (the bare command used to).

## 1.5.0

- Armor Depository: each snapshot records the claim slip key items the character holds, so pieces banked there show as `Armor Depository (Fighter's armor)`, count toward `OWNED`, feed the variant flags and are found by `/whohas find`. `armorsets.lua` (89 sets, generated from LandSandBoat data by `tools/gen_armorsets.py`) lists each set's pieces and withdrawal cost.
- Highlighting any piece of a storable set adds a set progress section: pieces held per character (loose or on slips), what is missing, and who has the set banked. `/whohas sets` lists banked sets; `/whohas sets on|off` and `/whohas setfit on|off` toggle the two displays.
- Delivery Box: the inbox is recorded from the result packets the server sends while the box is open (read only), so waiting items show as `Delivery Box x2`, count toward `OWNED` and are found by `/whohas find`. Taking, returning or deleting an item updates the record. `/whohas dbox` lists what is on file; `/whohas dbox on|off` toggles it.
- Character files gain `claims` and `dbox` fields; files from earlier versions load as before. Malformed values in those fields are ignored.
- The addon loads without `armorsets.lua` and says so.

## 1.4.1

- Fix: the box could appear with an unrelated item while the Mog House door menu (and some other non-item menus) was open, because the keyword `mog` matched `mogdoor` and the client keeps a stale selected item there. Reported on retail.
- Menu filter keywords tightened (`inventor` instead of `inv`, `storage` instead of `stor`, `mog` removed, `gift` and `tskill` added) and a block list added (`/whohas menus block|unblock <kw>`; defaults: Mog House door, View House and delivery menus, Blue Magic screens, currencies, confirmation dialogs). Settings from earlier versions are migrated once, keeping custom keywords.

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
