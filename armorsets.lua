--[[
* whohas - Armor Depository sets
*
* The Armor Depository NPCs take a complete NQ armor set and hand back a claim slip key item;
* paying the fee with the key item returns the pieces. Each entry: the set id, the claim slip
* key item id, the gil cost to withdraw, a fallback label, and the Head / Body / Hands / Legs /
* Feet item ids (0 = the set has no piece in that slot).
* Generated from LandSandBoat scripts/globals/armorstorage.lua and the key item enum.
--]]

local M = { };

M.slots = { 'Head', 'Body', 'Hands', 'Legs', 'Feet' };

M.sets = {
    { id = 1, ki = 654, cost = 500, label = "Fighter's Armor", pieces = { 12511, 12638, 13961, 14214, 14089 } }, -- fighters_mask, fighters_lorica, fighters_mufflers, fighters_cuisses, fighters_calligae
    { id = 2, ki = 655, cost = 500, label = 'Temple Attire', pieces = { 12512, 12639, 13962, 14215, 14090 } }, -- temple_crown, temple_cyclas, temple_gloves, temple_hose, temple_gaiters
    { id = 3, ki = 656, cost = 500, label = "Healer's Attire", pieces = { 13855, 12640, 13963, 14216, 14091 } }, -- healers_cap, healers_bliaut, healers_mitts, healers_pantaloons, healers_duckbills
    { id = 4, ki = 657, cost = 500, label = "Wizard's Attire", pieces = { 13856, 12641, 13964, 14217, 14092 } }, -- wizards_petasos, wizards_coat, wizards_gloves, wizards_tonban, wizards_sabots
    { id = 5, ki = 658, cost = 500, label = "Warlock's Armor", pieces = { 12513, 12642, 13965, 14218, 14093 } }, -- warlocks_chapeau, warlocks_tabard, warlocks_gloves, warlocks_tights, warlocks_boots
    { id = 6, ki = 659, cost = 500, label = "Rogue's Attire", pieces = { 12514, 12643, 13966, 14219, 14094 } }, -- rogues_bonnet, rogues_vest, rogues_armlets, rogues_culottes, rogues_poulaines
    { id = 7, ki = 660, cost = 500, label = 'Gallant Armor', pieces = { 12515, 12644, 13967, 14220, 14095 } }, -- gallant_coronet, gallant_surcoat, gallant_gauntlets, gallant_breeches, gallant_leggings
    { id = 8, ki = 661, cost = 500, label = 'Chaos Armor', pieces = { 12516, 12645, 13968, 14221, 14096 } }, -- chaos_burgeonet, chaos_cuirass, chaos_gauntlets, chaos_flanchard, chaos_sollerets
    { id = 9, ki = 662, cost = 500, label = 'Beast Armor', pieces = { 12517, 12646, 13969, 14222, 14097 } }, -- beast_helm, beast_jackcoat, beast_gloves, beast_trousers, beast_gaiters
    { id = 10, ki = 663, cost = 500, label = 'Choral Attire', pieces = { 13857, 12647, 13970, 14223, 14098 } }, -- choral_roundlet, choral_justaucorps, choral_cuffs, choral_cannions, choral_slippers
    { id = 11, ki = 664, cost = 500, label = "Hunter's Attire", pieces = { 12518, 12648, 13971, 14224, 14099 } }, -- hunters_beret, hunters_jerkin, hunters_bracers, hunters_braccae, hunters_socks
    { id = 12, ki = 665, cost = 500, label = 'Myochin Armor', pieces = { 13868, 13781, 13972, 14225, 14100 } }, -- myochin_kabuto, myochin_domaru, myochin_kote, myochin_haidate, myochin_sune-ate
    { id = 13, ki = 666, cost = 500, label = 'Ninja Garb', pieces = { 13869, 13782, 13973, 14226, 14101 } }, -- ninja_hatsuburi, ninja_chainmail, ninja_tekko, ninja_hakama, ninja_kyahan
    { id = 14, ki = 667, cost = 500, label = 'Drachen Armor', pieces = { 12519, 12649, 13974, 14227, 14102 } }, -- drachen_armet, drachen_mail, drachen_finger_gauntlets, drachen_brais, drachen_greaves
    { id = 15, ki = 668, cost = 500, label = "Evoker's Attire", pieces = { 12520, 12650, 13975, 14228, 14103 } }, -- evokers_horn, evokers_doublet, evokers_bracers, evokers_spats, evokers_pigaches
    { id = 16, ki = 1943, cost = 600, label = 'Iron Scale Armor', pieces = { 13871, 13783, 14001, 14243, 14118 } }, -- iron_visor, iron_scale_mail, iron_finger_gauntlets, iron_cuisses, iron_greaves
    { id = 17, ki = 1921, cost = 300, label = 'Shade Harness', pieces = { 15165, 14426, 14858, 14327, 15315 } }, -- shade_tiara, shade_harness, shade_mittens, shade_tights, shade_leggings
    { id = 18, ki = 1922, cost = 400, label = 'Brass Scale Mail', pieces = { 12433, 12561, 12689, 12817, 12945 } }, -- brass_mask, brass_scale_mail, brass_finger_gauntlets, brass_cuisses, brass_greaves
    { id = 19, ki = 1923, cost = 400, label = 'Wool Robe', pieces = { 12474, 12602, 12730, 12858, 12986 } }, -- wool_hat, wool_robe, wool_cuffs, wool_slops, chestnut_sabots
    { id = 20, ki = 1924, cost = 200, label = 'Eisenplatte Armor', pieces = { 15167, 14431, 14860, 14329, 15317 } }, -- eisenschaller, eisenbrust, eisenhentzes, eisendiechlings, eisenschuhs
    { id = 21, ki = 1925, cost = 400, label = 'Soil Gi', pieces = { 12458, 12586, 12714, 12842, 12970 } }, -- soil_hachimaki, soil_gi, soil_tekko, soil_sitabaki, soil_kyahan
    { id = 22, ki = 1926, cost = 200, label = "Seer's Tunic", pieces = { 15163, 14424, 14856, 14325, 15313 } }, -- seers_crown, seers_tunic, seers_mitts, seers_slacks, seers_pumps
    { id = 23, ki = 1927, cost = 400, label = 'Studded Armor', pieces = { 12442, 12570, 12698, 12826, 12954 } }, -- studded_bandana, studded_vest, studded_gloves, studded_trousers, studded_boots
    { id = 24, ki = 1928, cost = 200, label = "Centurion's Scale Mail", pieces = { 12438, 12566, 12694, 12822, 12950 } }, -- centurions_visor, centurions_scale_mail, centurions_finger_gauntlets, centurions_cuisses, centurions_greaves
    { id = 25, ki = 1929, cost = 200, label = "Mercenary Captain's Doublet", pieces = { 12470, 12598, 12726, 12854, 12982 } }, -- mercenary_captains_headgear, mercenary_captains_doublet, mercenary_captains_gloves, mercenary_captains_hose, mercenary_captains_gaiters
    { id = 26, ki = 1930, cost = 400, label = 'Garish Tunic', pieces = { 15164, 14425, 14857, 14326, 15314 } }, -- garish_crown, garish_tunic, garish_mitts, garish_slacks, garish_pumps
    { id = 27, ki = 1931, cost = 200, label = 'Noct Doublet', pieces = { 15161, 14422, 14854, 14323, 15311 } }, -- noct_beret, noct_doublet, noct_gloves, noct_brais, noct_gaiters
    { id = 28, ki = 1932, cost = 250, label = 'Custom Armor (male)', pieces = { 0, 12654, 12761, 12871, 13015 } }, -- custom_tunic, custom_m_gloves, custom_slacks, custom_m_boots
    { id = 29, ki = 1933, cost = 250, label = 'Custom Armor (female)', pieces = { 0, 12655, 12762, 12872, 13016 } }, -- custom_vest, custom_f_gloves, custom_pants, custom_f_boots
    { id = 30, ki = 1934, cost = 250, label = 'Magna Armor (male)', pieces = { 0, 12656, 12763, 12873, 13017 } }, -- magna_jerkin, magna_gauntlets, magna_m_chausses, magna_m_ledelsens
    { id = 31, ki = 1935, cost = 250, label = 'Magna Armor (female)', pieces = { 0, 12657, 12764, 12874, 13018 } }, -- magna_bodice, magna_gloves, magna_f_chausses, magna_f_ledelsens
    { id = 32, ki = 1936, cost = 250, label = 'Wonder Armor', pieces = { 0, 12658, 12765, 12875, 13019 } }, -- wonder_kaftan, wonder_mitts, wonder_braccae, wonder_clomps
    { id = 33, ki = 1937, cost = 250, label = 'Savage Armor', pieces = { 0, 12659, 12766, 12876, 13020 } }, -- savage_separates, savage_gauntlets, savage_loincloth, savage_gaiters
    { id = 34, ki = 1938, cost = 250, label = 'Elder Armor', pieces = { 0, 12660, 12767, 12877, 13021 } }, -- elders_surcoat, elders_bracers, elders_braguette, elders_sandals
    { id = 35, ki = 1939, cost = 500, label = 'Linen Cloak', pieces = { 0, 12610, 12738, 12866, 12994 } }, -- cloak, linen_mitts, linen_slacks, shoes
    { id = 36, ki = 1940, cost = 500, label = 'Padded Armor', pieces = { 12450, 12578, 12706, 12836, 12962 } }, -- padded_cap, padded_armor, iron_mittens, iron_subligar, leggings
    { id = 37, ki = 1941, cost = 500, label = 'Silver Chainmail', pieces = { 12425, 12553, 12681, 12809, 12937 } }, -- silver_mask, silver_mail, silver_mittens, silver_hose, silver_greaves
    { id = 38, ki = 1942, cost = 600, label = 'Gambison', pieces = { 12466, 12594, 12722, 12850, 12978 } }, -- red_cap, gambison, bracers, hose, socks
    { id = 39, ki = 1920, cost = 150, label = 'Iron Chainmail', pieces = { 12424, 12552, 12680, 12808, 12936 } }, -- iron_mask, chainmail, chain_mittens, chain_hose, greaves
    { id = 40, ki = 1944, cost = 600, label = 'Cuir Armor', pieces = { 12443, 12571, 12699, 12827, 12955 } }, -- cuir_bandana, cuir_bouilli, cuir_gloves, cuir_trousers, cuir_highboots
    { id = 41, ki = 1945, cost = 600, label = 'Velvet Robe', pieces = { 12475, 12603, 12731, 12859, 12987 } }, -- velvet_hat, velvet_robe, velvet_cuffs, velvet_slops, ebony_sabots
    { id = 42, ki = 1946, cost = 600, label = 'Opaline Dress', pieces = { 13931, 14384, 0, 14249, 14116 } }, -- lilac_corsage, opaline_dress, opaline_hose, opaline_boots
    { id = 43, ki = 1947, cost = 300, label = "Royal Squire's Chainmail", pieces = { 12431, 12559, 12687, 12815, 12943 } }, -- royal_squires_helm, royal_squires_chainmail, royal_squires_mufflers, royal_squires_breeches, royal_squires_sollerets
    { id = 44, ki = 1948, cost = 600, label = 'Plate Armor', pieces = { 12416, 12544, 12672, 12800, 12928 } }, -- sallet, breastplate, gauntlets, cuisses, plate_leggings
    { id = 45, ki = 1949, cost = 600, label = "Combat Caster's Cloak", pieces = { 0, 12614, 12743, 12870, 12998 } }, -- combat_casters_cloak, combat_casters_mitts, combat_casters_slacks, combat_casters_shoes
    { id = 46, ki = 1950, cost = 700, label = 'Alumine Haubert', pieces = { 15205, 14444, 14051, 15402, 15341 } }, -- alumine_salade, alumine_haubert, alumine_moufles, alumine_brayettes, alumine_sollerets
    { id = 47, ki = 1951, cost = 700, label = 'Carapace Harness', pieces = { 13711, 13712, 13713, 12837, 13715 } }, -- carapace_mask, carapace_harness, carapace_mittens, carapace_subligar, carapace_leggings
    { id = 48, ki = 1952, cost = 800, label = 'Banded Mail', pieces = { 12426, 12554, 12682, 12810, 12938 } }, -- banded_helm, banded_mail, mufflers, breeches, sollerets
    { id = 49, ki = 1953, cost = 800, label = 'Hara-Ate', pieces = { 12459, 12587, 12715, 12843, 12974 } }, -- zunari_kabuto, hara-ate, kote, haidate, sune-ate
    { id = 50, ki = 1954, cost = 800, label = 'Raptor Armor', pieces = { 12444, 12572, 12700, 12828, 12956 } }, -- raptor_helm, raptor_jerkin, raptor_gloves, raptor_trousers, raptor_ledelsens
    { id = 51, ki = 1955, cost = 800, label = 'Steel Scale Armor', pieces = { 13873, 13785, 14003, 14245, 14120 } }, -- steel_visor, steel_scale_mail, steel_finger_gauntlets, steel_cuisses, steel_greaves
    { id = 52, ki = 1956, cost = 800, label = 'Wool Gambison', pieces = { 12467, 12595, 12723, 12851, 12979 } }, -- wool_cap, wool_gambison, wool_bracers, wool_hose, wool_socks
    { id = 53, ki = 1957, cost = 800, label = 'Shinobi Gi', pieces = { 12460, 12588, 12716, 12844, 12972 } }, -- shinobi_hachigane, shinobi_gi, shinobi_tekko, shinobi_hakama, shinobi_kyahan
    { id = 54, ki = 1958, cost = 800, label = "Iron Musketeer's Cuirass", pieces = { 12422, 12550, 12678, 12806, 12934 } }, -- iron_musketeers_armet, iron_musketeers_cuirass, iron_musketeers_gauntlets, iron_musketeers_cuisses, iron_musketeers_sabatons
    { id = 55, ki = 1959, cost = 800, label = "Tactician Magician's Cloak", pieces = { 12478, 12606, 12734, 12862, 12990 } }, -- tactician_magicians_hat, tactician_magicians_coat, tactician_magicians_cuffs, tactician_magicians_slops, tactician_magicians_pigaches
    { id = 56, ki = 1960, cost = 800, label = 'White Cloak', pieces = { 0, 12611, 12739, 12867, 12995 } }, -- white_cloak, black_mitts, white_slacks, moccasins
    { id = 57, ki = 1961, cost = 800, label = 'Austere Robe', pieces = { 13939, 13814, 14826, 14310, 14189 } }, -- austere_hat, austere_robe, austere_cuffs, austere_slops, austere_sabots
    { id = 58, ki = 1962, cost = 800, label = 'Mythril Plate Armor', pieces = { 12417, 12545, 12673, 12801, 12929 } }, -- mythril_sallet, mythril_breastplate, mythril_gauntlets, mythril_cuisses, mythril_leggings
    { id = 59, ki = 1963, cost = 800, label = 'Crow Jupon', pieces = { 15242, 14498, 14907, 15578, 15663 } }, -- crow_beret, crow_jupon, crow_bracers, crow_hose, crow_gaiters
    { id = 60, ki = 1964, cost = 500, label = 'Magus Attire', pieces = { 15265, 14521, 14928, 15600, 15684 } }, -- magus_keffiyeh, magus_jubbah, magus_bazubands, magus_shalwar, magus_charuqs
    { id = 61, ki = 1965, cost = 500, label = "Corsair's Attire", pieces = { 15266, 14522, 14929, 15601, 15685 } }, -- corsairs_tricorne, corsairs_frac, corsairs_gants, corsairs_culottes, corsairs_bottes
    { id = 62, ki = 1966, cost = 500, label = 'Puppetry Attire', pieces = { 15267, 14523, 14930, 15602, 15686 } }, -- puppetry_taj, puppetry_tobe, puppetry_dastanas, puppetry_churidars, puppetry_babouches
    { id = 63, ki = 861, cost = 1000, label = "Warrior's Armor", pieces = { 15072, 15087, 15102, 15117, 15132 } }, -- warriors_mask, warriors_lorica, warriors_mufflers, warriors_cuisses, warriors_calligae
    { id = 64, ki = 862, cost = 1000, label = 'Melee Attire', pieces = { 15073, 15088, 15103, 15118, 15133 } }, -- melee_crown, melee_cyclas, melee_gloves, melee_hose, melee_gaiters
    { id = 65, ki = 863, cost = 1000, label = "Cleric's Attire", pieces = { 15074, 15089, 15104, 15119, 15134 } }, -- clerics_cap, clerics_bliaut, clerics_mitts, clerics_pantaloons, clerics_duckbills
    { id = 66, ki = 864, cost = 1000, label = "Sorcerer's Attire", pieces = { 15075, 15090, 15105, 15120, 15135 } }, -- sorcerers_petasos, sorcerers_coat, sorcerers_gloves, sorcerers_tonban, sorcerers_sabots
    { id = 67, ki = 865, cost = 1000, label = "Duelist's Armor", pieces = { 15076, 15091, 15106, 15121, 15136 } }, -- duelists_chapeau, duelists_tabard, duelists_gloves, duelists_tights, duelists_boots
    { id = 68, ki = 866, cost = 1000, label = "Assassin's Attire", pieces = { 15077, 15092, 15107, 15122, 15137 } }, -- assassins_bonnet, assassins_vest, assassins_armlets, assassins_culottes, assassins_poulaines
    { id = 69, ki = 867, cost = 1000, label = 'Valor Armor', pieces = { 15078, 15093, 15108, 15123, 15138 } }, -- valor_coronet, valor_surcoat, valor_gauntlets, valor_breeches, valor_leggings
    { id = 70, ki = 868, cost = 1000, label = 'Abyss Armor', pieces = { 15079, 15094, 15109, 15124, 15139 } }, -- abyss_burgeonet, abyss_cuirass, abyss_gauntlets, abyss_flanchard, abyss_sollerets
    { id = 71, ki = 869, cost = 1000, label = 'Monster Armor', pieces = { 15080, 15095, 15110, 15125, 15140 } }, -- monster_helm, monster_jackcoat, monster_gloves, monster_trousers, monster_gaiters
    { id = 72, ki = 870, cost = 1000, label = "Bard's Attire", pieces = { 15081, 15096, 15111, 15126, 15141 } }, -- bards_roundlet, bards_justaucorps, bards_cuffs, bards_cannions, bards_slippers
    { id = 73, ki = 871, cost = 1000, label = "Scout's Attire", pieces = { 15082, 15097, 15112, 15127, 15142 } }, -- scouts_beret, scouts_jerkin, scouts_bracers, scouts_braccae, scouts_socks
    { id = 74, ki = 872, cost = 1000, label = 'Saotome Armor', pieces = { 15083, 15098, 15113, 15128, 15143 } }, -- saotome_kabuto, saotome_domaru, saotome_kote, saotome_haidate, saotome_sune-ate
    { id = 75, ki = 873, cost = 1000, label = 'Koga Garb', pieces = { 15084, 15099, 15114, 15129, 15144 } }, -- koga_hatsuburi, koga_chainmail, koga_tekko, koga_hakama, koga_kyahan
    { id = 76, ki = 874, cost = 1000, label = 'Wyrm Armor', pieces = { 15085, 15100, 15115, 15130, 15145 } }, -- wyrm_armet, wyrm_mail, wyrm_finger_gauntlets, wyrm_brais, wyrm_greaves
    { id = 77, ki = 875, cost = 1000, label = "Summoner's Attire", pieces = { 15086, 15101, 15116, 15131, 15146 } }, -- summoners_horn, summoners_doublet, summoners_bracers, summoners_spats, summoners_pigaches
    { id = 78, ki = 1967, cost = 500, label = "Dancer's Attire (male)", pieces = { 16138, 14578, 15002, 15659, 15746 } }, -- dancers_tiara, dancers_casaque, dancers_bangles, dancers_tights, dancers_toe_shoes
    { id = 79, ki = 1968, cost = 500, label = "Dancer's Attire (female)", pieces = { 16139, 14579, 15003, 15660, 15747 } }, -- dancers_tiara, dancers_casaque, dancers_bangles, dancers_tights, dancers_toe_shoes
    { id = 80, ki = 1969, cost = 500, label = "Scholar's Attire", pieces = { 16140, 14580, 15004, 16311, 15748 } }, -- scholars_mortarboard, scholars_gown, scholars_bracers, scholars_pants, scholars_loafers
    { id = 81, ki = 1970, cost = 1000, label = 'Amir Armor', pieces = { 16062, 14525, 14933, 15604, 15688 } }, -- amir_puggaree, amir_korazin, amir_kolluks, amir_dirs, amir_boots
    { id = 82, ki = 1971, cost = 1000, label = 'Pahluwan Armor', pieces = { 16069, 14530, 14940, 15609, 15695 } }, -- pahluwan_qalansuwa, pahluwan_khazagand, pahluwan_dastanas, pahluwan_seraweels, pahluwan_crackows
    { id = 83, ki = 1972, cost = 1000, label = 'Yigit Armor', pieces = { 16064, 14527, 14935, 15606, 15690 } }, -- yigit_turban, yigit_gomlek, yigit_gages, yigit_seraweels, yigit_crackows
    { id = 84, ki = 1054, cost = 1000, label = 'Mirage Attire', pieces = { 11465, 11292, 15025, 16346, 11382 } }, -- mirage_keffiyeh, mirage_jubbah, mirage_bazubands, mirage_shalwar, mirage_charuqs
    { id = 85, ki = 1055, cost = 1000, label = 'Commodore Attire', pieces = { 11468, 11295, 15028, 16349, 11385 } }, -- commodore_tricorne, commodore_frac, commodore_gants, commodore_trews, commodore_bottes
    { id = 86, ki = 1056, cost = 1000, label = 'Pantin Attire', pieces = { 11471, 11298, 15031, 16352, 11388 } }, -- pantin_taj, pantin_tobe, pantin_dastanas, pantin_churidars, pantin_babouches
    { id = 87, ki = 1057, cost = 1000, label = 'Etoile Attire', pieces = { 11478, 11305, 15038, 16360, 11396 } }, -- etoile_tiara, etoile_casaque, etoile_bangles, etoile_tights, etoile_toe_shoes
    { id = 88, ki = 1058, cost = 1000, label = 'Argute Attire', pieces = { 11480, 11307, 15040, 16362, 11398 } }, -- argute_mortarboard, argute_gown, argute_bracers, argute_pants, argute_loafers
    { id = 89, ki = 1059, cost = 600, label = 'Argent Attire', pieces = { 0, 11310, 0, 16365, 0 } }, -- argent_coat, argent_hose
};

-- item id -> list of sets that include it; claim slip key item id -> set.
M.by_item = { };
M.by_ki = { };
for _, s in ipairs(M.sets) do
    M.by_ki[s.ki] = s;
    for _, id in ipairs(s.pieces) do
        if (id ~= 0) then
            local t = M.by_item[id];
            if (t == nil) then t = { }; M.by_item[id] = t; end
            table.insert(t, s);
        end
    end
end

-- The pieces of a set as { slot = name, id = item id }, skipping empty slots.
M.pieces = function (s)
    local out = { };
    for k, id in ipairs(s.pieces) do
        if (id ~= 0) then table.insert(out, { slot = M.slots[k], id = id }); end
    end
    return out;
end

return M;
