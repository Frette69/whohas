# whohas (Ashita v4 addon for FFXI)

Shows an on-screen box, whenever an item is highlighted in an item menu, listing which of your characters hold that item, in which container, and how many. Think of it as `findall` with the answer already on screen while you sort your Mog House.

## How it works

- Each time a character's inventory finishes loading (or changes and then sits quiet for 2 seconds), the addon snapshots every container the client knows about (Inventory, Safe, Storage, Locker, Satchel, Sack, Case, Wardrobes, Safe 2) and writes it to:

  ```
  <Ashita>\config\addons\whohas\chars\<CharacterName>.lua
  ```

- When you highlight an item, the addon reads the client's "selected item" id (`GetSelectedItemId()`, the same value the PriceCheck addon uses) and looks it up across every character file plus the live inventory of the character you are on.
- The addon is read-only. It never sends packets, never moves items, and never automates anything.

The box lists the current character first (green), then every other character that holds the item, with the container breakdown and a per-character quantity, and a total across characters.

## Storage slips (Porter Moogle)

- Each character's storage slips are decoded from the slip's Extra data at snapshot time, using the server-side bit order (`slips.lua`, generated from LandSandBoat's `porter_slip_items.lua`). Items stored on a slip appear in the box as `Storage Slip 04 (Safe)` on that character's row and count toward the total.
- If the highlighted item can go on a slip, the box adds a `Fits Storage Slip NN` line and names every character holding that slip, where it is, and how many items are already on it. Slips the Porter Moogle does not sell on your server are flagged as not sold; the list of sold slips is `slips.available` in `slips.lua`.
- Highlight a slip itself and the box shows how many items are on it per character and lists them (first 40).
- `/whohas slip` lists every slip on file; `/whohas slip 4` prints everything stored on Storage Slip 04 across characters. `/whohas find` searches slip contents too.

## Already have it? Already upgraded it?

The box opens with a status line: green `OWNED xN` when any character has the item (loose or on a slip), or `Not owned by any character`. Next to it, orange flags like `| +1 owned x1` appear when a different version of the same piece is held: the +1 (HQ) of an NQ relic or artifact piece, the -1, or the NQ when you are looking at the +1. The matching section below names who holds it and where, for example `Abyss Burgeonet +1 [15245] Bravo (Storage Slip 07 (Locker))`. Versions are matched two ways:

- by the item's full name with the trailing `+1` / `-1` stripped, which covers AF/relic +1, Dynamis -1 and most crafted HQs;
- by `hqpairs.lua`, a table generated from LandSandBoat data for pairs whose names differ: Crimson -> Blood, Koenig -> Kaiser, Adaman -> Armada, Zenith -> Dalmatica style abjuration gear (including the cursed piece and the abjuration item itself, so highlighting a `Wyrmal Abjuration: Hands` drop tells you if Blood Finger Gauntlets are already on someone's slip), crafted HQs with their own names, and drop pairs like Leaping -> Bounding Boots. Flags use the role: `HQ owned`, `NQ owned`, `cursed owned`, `abjuration owned`.

`/whohas variants off` hides all of it. If `hqpairs.lua` is missing the addon still loads and says so; only the name-based matching runs.

## Install

1. Copy the `whohas` folder into `<Ashita>\addons\` so you end up with `addons\whohas\whohas.lua`, `slips.lua` and `hqpairs.lua` side by side. A zip downloaded from GitHub unpacks as `whohas-main`; rename that folder to `whohas` first.
2. `/addon load whohas` (or add it to your `default.txt`).
3. Log in on each of your characters once. Each login writes that character's file. From then on the file updates automatically whenever that character's inventory changes.

## Commands

| Command | What it does |
| --- | --- |
| `/whohas` | Toggle the overlay on/off |
| `/whohas on` / `off` | Enable or disable the overlay |
| `/whohas find <text>` | Search every character for an item name (prints to chat) |
| `/whohas list` | List known characters and how old their data is |
| `/whohas scan` | Force a snapshot of the current character right now |
| `/whohas pin` / `unpin` | Keep the box up for the last item, even after closing menus (handy while walking to the Mog House) |
| `/whohas current on` / `off` | Include or exclude the logged-in character in the box |
| `/whohas filter on` / `off` | Only show inside item menus (on) or whenever an item is selected (off) |
| `/whohas missing on` / `off` | Show the box even when no character has the item |
| `/whohas age on` / `off` | Show how old each character's data is |
| `/whohas menu` | Print the name of the game menu that is open right now |
| `/whohas menus` | Show the menu keyword filter (`add <kw>`, `remove <kw>`, `reset`) |
| `/whohas lock` / `unlock` | Lock or unlock the box position |
| `/whohas pos <x> <y>` | Move the box to a screen position |
| `/whohas alpha <0.1-1.0>` | Background opacity |
| `/whohas slip [n]` | List storage slips on file, or everything stored on slip n |
| `/whohas slipfit on` / `off` | Show which slip the selected item fits |
| `/whohas slipitems on` / `off` | List slip contents when a slip is selected |
| `/whohas variants on` / `off` | Show +1 / -1 / NQ versions of the selected item that anyone holds |
| `/whohas forget <name>` | Delete the stored data for a character |
| `/whohas files` | Show the data folder and exactly which character files are on disk (use this if data seems to vanish between sessions) |
| `/whohas reload` | Re-read the character files from disk |
| `/whohas debug` | Print selected item id/index/name and the current menu name |
| `/whohas help` | Show the command list |

`/wh` works as a short alias for `/whohas`.

## Tuning the menu filter

The box only appears while a menu whose internal name contains one of the filter keywords is open. The defaults cover inventory, Mog House storage, equipment, shops, the AH, delivery box, treasure pool, trades and synthesis. If the box is missing in a menu where you want it, open that menu and run `/whohas menu` to see its name, then `/whohas menus add <keyword>`.

## Notes

- Data for other characters is as fresh as their last login. The box shows the age next to each name, e.g. `Bravo (3d)`.
- The Temporary container is skipped by default.
- Character files are found at load time through `chars\index.lua` (kept up to date on every save) plus a folder scan, so persistence does not depend on how Ashita lists directories. If a character is missing after a restart, run `/whohas files` to see what is on disk and `/whohas reload` to re-read it.
- Settings are saved per character by Ashita's settings library under `config\addons\whohas\<Name>_<id>\settings.lua`. The character item files live in `config\addons\whohas\chars\` and are shared by every character.
