--[[
* whohas - NQ / HQ item relations whose names differ
*
* Each group lists related item ids with a role: NQ, HQ, HQ2, HQ3, cursed, cursed -1, abjuration.
* Generated from LandSandBoat sql/synth_recipes.sql (recipes whose HQ result has a different
* base name from the NQ result; +1 style names are matched by whohas itself), scripts/globals/
* abjurations.lua (cursed item + abjuration -> NQ / HQ reward), and a short list of drop pairs.
--]]

local M = { };

M.groups = {
    { { 17868, 'NQ' }, { 17869, 'HQ' } }, -- synth: jug_of_humus / jug_of_rich_humus
    { { 17872, 'NQ' }, { 17873, 'HQ' } }, -- synth: jug_of_tree_sap / jug_of_scarlet_sap
    { { 17535, 'NQ' }, { 17536, 'HQ' } }, -- synth: windurstian_pole / federation_pole
    { { 17444, 'NQ' }, { 17445, 'HQ' } }, -- synth: windurstian_club / federation_club
    { { 17238, 'NQ' }, { 17239, 'HQ' } }, -- synth: bastokan_crossbow / republic_crossbow
    { { 17195, 'NQ' }, { 17196, 'HQ' } }, -- synth: windurstian_bow / federation_bow
    { { 17025, 'NQ' }, { 17139, 'HQ' } }, -- synth: chestnut_club / solid_club
    { { 17197, 'NQ' }, { 17198, 'HQ' } }, -- synth: san_dorian_bow / kingdom_bow
    { { 14149, 'NQ' }, { 14150, 'HQ' } }, -- synth: san_dorian_clogs / kingdom_clogs
    { { 18068, 'NQ' }, { 18069, 'HQ' } }, -- synth: san_dorian_spear / kingdom_spear
    { { 17537, 'NQ' }, { 17538, 'HQ' } }, -- synth: windurstian_staff / federation_staff
    { { 17052, 'NQ' }, { 17141, 'HQ' } }, -- synth: chestnut_wand / solid_wand
    { { 12292, 'NQ' }, { 12334, 'HQ' } }, -- synth: mahogany_shield / strong_shield
    { { 18070, 'NQ' }, { 18071, 'HQ' } }, -- synth: san_dorian_halberd / kingdom_halberd
    { { 17523, 'NQ' }, { 17524, 'HQ' } }, -- synth: quarterstaff / footmans_staff
    { { 17092, 'NQ' }, { 17520, 'HQ' } }, -- synth: mahogany_staff / heavy_staff
    { { 12359, 'NQ' }, { 12370, 'HQ' } }, -- synth: hickory_shield / picaroons_shield
    { { 17541, 'NQ' }, { 17542, 'HQ' } }, -- synth: bastokan_staff / republic_staff
    { { 17551, 'NQ' }, { 17552, 'HQ' } }, -- synth: earth_staff / terras_staff
    { { 17559, 'NQ' }, { 17560, 'HQ' } }, -- synth: dark_staff / plutos_staff
    { { 17545, 'NQ' }, { 17546, 'HQ' } }, -- synth: fire_staff / vulcans_staff
    { { 17549, 'NQ' }, { 17550, 'HQ' } }, -- synth: wind_staff / austers_staff
    { { 17547, 'NQ' }, { 17548, 'HQ' } }, -- synth: ice_staff / aquilos_staff
    { { 17553, 'NQ' }, { 17554, 'HQ' } }, -- synth: thunder_staff / jupiters_staff
    { { 17557, 'NQ' }, { 17558, 'HQ' } }, -- synth: light_staff / apollos_staff
    { { 17555, 'NQ' }, { 17556, 'HQ' } }, -- synth: water_staff / neptunes_staff
    { { 17221, 'NQ' }, { 17233, 'HQ' } }, -- synth: repeating_crossbow / machine_crossbow
    { { 27390, 'NQ' }, { 27391, 'HQ' } }, -- synth: bewitched_sune-ate / voodoo_sune-ate
    { { 27038, 'NQ' }, { 27039, 'HQ' } }, -- synth: bewitched_kote / voodoo_kote
    { { 27214, 'NQ' }, { 27215, 'HQ' } }, -- synth: bewitched_haidate / voodoo_haidate
    { { 26686, 'NQ' }, { 26687, 'HQ' } }, -- synth: bewitched_kabuto / voodoo_kabuto
    { { 26862, 'NQ' }, { 26863, 'HQ' } }, -- synth: bewitched_togi / voodoo_togi
    { { 18105, 'NQ' }, { 18106, 'HQ' } }, -- synth: orichalcum_lance / tritons_lance
    { { 21488, 'NQ' }, { 21489, 'HQ' } }, -- synth: jug_of_pristine_sap / jug_of_truly_pristine_sap
    { { 18634, 'NQ' }, { 18635, 'HQ' } }, -- synth: zamzummim_staff / melisseus_staff
    { { 12688, 'NQ' }, { 12768, 'HQ' } }, -- synth: scale_finger_gauntlets / solid_finger_gauntlets
    { { 12944, 'NQ' }, { 13024, 'HQ' } }, -- synth: scale_greaves / solid_greaves
    { { 12816, 'NQ' }, { 12863, 'HQ' } }, -- synth: scale_cuisses / solid_cuisses
    { { 12560, 'NQ' }, { 12661, 'HQ' } }, -- synth: scale_mail / solid_mail
    { { 651, 'NQ' }, { 652, 'HQ' } }, -- synth: iron_ingot / steel_ingot
    { { 17976, 'NQ' }, { 17977, 'HQ' } }, -- synth: windurstian_knife / federation_knife
    { { 16532, 'NQ' }, { 16608, 'HQ' } }, -- synth: gladius / gladiator
    { { 12450, 'NQ' }, { 12525, 'HQ' } }, -- synth: padded_cap / strong_cap
    { { 17974, 'NQ' }, { 17975, 'HQ' } }, -- synth: bastokan_dagger / republic_dagger
    { { 14329, 'NQ' }, { 14332, 'HQ' } }, -- synth: eisendiechlings / kampfdiechlings
    { { 16946, 'NQ' }, { 16947, 'HQ' } }, -- synth: windurstian_sword / federation_sword
    { { 15167, 'NQ' }, { 15171, 'HQ' } }, -- synth: eisenschaller / kampfschaller
    { { 17978, 'NQ' }, { 17979, 'HQ' } }, -- synth: windurstian_kukri / federation_kukri
    { { 16584, 'NQ' }, { 16639, 'HQ' } }, -- synth: mythril_claymore / fine_claymore
    { { 15317, 'NQ' }, { 15321, 'HQ' } }, -- synth: eisenschuhs / kampfschuhs
    { { 12372, 'NQ' }, { 12373, 'HQ' } }, -- synth: bastokan_targe / republic_targe
    { { 14860, 'NQ' }, { 14863, 'HQ' } }, -- synth: eisenhentzes / kampfhentzes
    { { 14431, 'NQ' }, { 14435, 'HQ' } }, -- synth: eisenbrust / kampfbrust
    { { 17672, 'NQ' }, { 17673, 'HQ' } }, -- synth: bastokan_sword / republic_sword
    { { 17448, 'NQ' }, { 17449, 'HQ' } }, -- synth: san_dorian_mace / kingdom_mace
    { { 16732, 'NQ' }, { 16733, 'HQ' } }, -- synth: bastokan_greataxe / republic_greataxe
    { { 17929, 'NQ' }, { 17930, 'HQ' } }, -- synth: bastokan_axe / republic_axe
    { { 12578, 'NQ' }, { 12663, 'HQ' } }, -- synth: padded_armor / strong_harness
    { { 17452, 'NQ' }, { 17453, 'HQ' } }, -- synth: bastokan_hammer / republic_hammer
    { { 652, 'NQ' }, { 657, 'HQ' } }, -- synth: steel_ingot / lump_of_tama-hagane
    { { 14051, 'NQ' }, { 14052, 'HQ' } }, -- synth: alumine_moufles / luisant_moufles
    { { 16576, 'NQ' }, { 16812, 'HQ' } }, -- synth: hunting_sword / war_sword
    { { 15341, 'NQ' }, { 15342, 'HQ' } }, -- synth: alumine_sollerets / luisant_sollerets
    { { 16559, 'NQ' }, { 16814, 'HQ' } }, -- synth: darksteel_falchion / crescent_sword
    { { 15402, 'NQ' }, { 15403, 'HQ' } }, -- synth: alumine_brayettes / luisant_brayettes
    { { 15205, 'NQ' }, { 15206, 'HQ' } }, -- synth: alumine_salade / luisant_salade
    { { 14444, 'NQ' }, { 14445, 'HQ' } }, -- synth: alumine_haubert / luisant_haubert
    { { 15689, 'NQ' }, { 15694, 'HQ' } }, -- synth: jaridah_nails / akinji_nails
    { { 14934, 'NQ' }, { 14939, 'HQ' } }, -- synth: jaridah_bazubands / akinji_bazubands
    { { 12302, 'NQ' }, { 12347, 'HQ' } }, -- synth: darksteel_buckler / spiked_buckler
    { { 13812, 'NQ' }, { 13813, 'HQ' } }, -- synth: holy_breastplate / divine_breastplate
    { { 18036, 'NQ' }, { 18037, 'HQ' } }, -- synth: windurstian_scythe / federation_scythe
    { { 17816, 'NQ' }, { 17817, 'HQ' } }, -- synth: kotetsu_+1 / shinkotetsu
    { { 17818, 'NQ' }, { 17819, 'HQ' } }, -- synth: kanesada_+1 / shinkanesada
    { { 16724, 'NQ' }, { 16725, 'HQ' } }, -- synth: heavy_darksteel_axe / massive_darksteel_axe
    { { 12383, 'NQ' }, { 12384, 'HQ' } }, -- synth: generals_shield / admirals_shield
    { { 18745, 'NQ' }, { 18746, 'HQ' } }, -- synth: adaman_sainti / gem_sainti
    { { 16396, 'NQ' }, { 17481, 'HQ' } }, -- synth: koenigs_knuckles / kaiser_knuckles
    { { 27388, 'NQ' }, { 27389, 'HQ' } }, -- synth: bewitched_sollerets / voodoo_sollerets
    { { 27481, 'NQ' }, { 27482, 'HQ' } }, -- synth: vexed_sune-ate / jinxed_sune-ate
    { { 27036, 'NQ' }, { 27037, 'HQ' } }, -- synth: bewitched_mufflers / voodoo_mufflers
    { { 15400, 'NQ' }, { 15401, 'HQ' } }, -- synth: black_cuisses / onyx_cuisses
    { { 27212, 'NQ' }, { 27213, 'HQ' } }, -- synth: bewitched_breeches / voodoo_breeches
    { { 14848, 'NQ' }, { 14849, 'HQ' } }, -- synth: barone_manopolas / conte_manopolas
    { { 15339, 'NQ' }, { 15340, 'HQ' } }, -- synth: black_sollerets / onyx_sollerets
    { { 25621, 'NQ' }, { 25622, 'HQ' } }, -- synth: vexed_somen / jinxed_somen
    { { 26684, 'NQ' }, { 26685, 'HQ' } }, -- synth: bewitched_celata / voodoo_celata
    { { 14416, 'NQ' }, { 14417, 'HQ' } }, -- synth: barone_corazza / conte_corazza
    { { 14010, 'NQ' }, { 14011, 'HQ' } }, -- synth: black_gadlings / onyx_gadlings
    { { 26860, 'NQ' }, { 26861, 'HQ' } }, -- synth: bewitched_hauberk / voodoo_hauberk
    { { 25694, 'NQ' }, { 25695, 'HQ' } }, -- synth: vexed_domaru / jinxed_domaru
    { { 13887, 'NQ' }, { 13888, 'HQ' } }, -- synth: black_sallet / onyx_sallet
    { { 12804, 'NQ' }, { 14312, 'HQ' } }, -- synth: adaman_cuisses / gem_cuisses
    { { 12420, 'NQ' }, { 13941, 'HQ' } }, -- synth: adaman_barbuta / gem_barbuta
    { { 19788, 'NQ' }, { 19789, 'HQ' } }, -- synth: gorkhali_kukri / mahakalis_kukri
    { { 12932, 'NQ' }, { 14193, 'HQ' } }, -- synth: adaman_sabatons / gem_sabatons
    { { 12676, 'NQ' }, { 14828, 'HQ' } }, -- synth: adaman_gauntlets / gem_gauntlets
    { { 12548, 'NQ' }, { 13746, 'HQ' } }, -- synth: adaman_cuirass / gem_cuirass
    { { 13889, 'NQ' }, { 13890, 'HQ' } }, -- synth: bastokan_cap / republic_cap
    { { 14031, 'NQ' }, { 14032, 'HQ' } }, -- synth: bastokan_mittens / republic_mittens
    { { 17499, 'NQ' }, { 17500, 'HQ' } }, -- synth: bastokan_knuckles / republic_knuckles
    { { 14139, 'NQ' }, { 14140, 'HQ' } }, -- synth: bastokan_leggings / republic_leggings
    { { 800, 'NQ' }, { 811, 'HQ' }, { 810, 'HQ2' }, { 804, 'HQ3' } }, -- synth: amethyst / ametrine / fluorite / spinel
    { { 814, 'NQ' }, { 815, 'HQ' }, { 801, 'HQ2' }, { 789, 'HQ3' } }, -- synth: amber_stone / sphene / chrysoberyl / topaz
    { { 807, 'NQ' }, { 790, 'HQ' }, { 803, 'HQ2' }, { 786, 'HQ3' } }, -- synth: sardonyx / garnet / sunstone / ruby
    { { 795, 'NQ' }, { 798, 'HQ' }, { 791, 'HQ2' }, { 794, 'HQ3' } }, -- synth: lapis_lazuli / turquoise / aquamarine / sapphire
    { { 806, 'NQ' }, { 788, 'HQ' }, { 784, 'HQ2' }, { 785, 'HQ3' } }, -- synth: tourmaline / peridot / jadeite / emerald
    { { 809, 'NQ' }, { 808, 'HQ' }, { 805, 'HQ2' }, { 787, 'HQ3' } }, -- synth: clear_topaz / goshenite / zircon / diamond
    { { 796, 'NQ' }, { 802, 'HQ2' }, { 813, 'HQ3' } }, -- synth: light_opal / moonstone / angelstone
    { { 18038, 'NQ' }, { 18039, 'HQ' } }, -- synth: bastokan_scythe / republic_scythe
    { { 799, 'NQ' }, { 797, 'HQ2' }, { 812, 'HQ3' } }, -- synth: onyx / painite / deathstone
    { { 12473, 'NQ' }, { 12530, 'HQ' } }, -- synth: poets_circlet / sages_circlet
    { { 14259, 'NQ' }, { 14260, 'HQ' } }, -- synth: bastokan_subligar / republic_subligar
    { { 17399, 'NQ' }, { 17398, 'HQ' } }, -- synth: sabiki_rig / rogue_rig
    { { 809, 'NQ' }, { 808, 'HQ' }, { 805, 'HQ2' }, { 1460, 'HQ3' } }, -- synth: clear_topaz / goshenite / zircon / koh-i-noor
    { { 14338, 'NQ' }, { 14339, 'HQ' } }, -- synth: bastokan_harness / republic_harness
    { { 17678, 'NQ' }, { 17679, 'HQ' } }, -- synth: san_dorian_sword / kingdom_sword
    { { 13337, 'NQ' }, { 13380, 'HQ' } }, -- synth: opal_earring / hope_earring
    { { 13336, 'NQ' }, { 13379, 'HQ' } }, -- synth: onyx_earring / energy_earring
    { { 13332, 'NQ' }, { 13375, 'HQ' } }, -- synth: clear_earring / knowledge_earring
    { { 13330, 'NQ' }, { 13373, 'HQ' } }, -- synth: tourmaline_earring / reflex_earring
    { { 13331, 'NQ' }, { 13374, 'HQ' } }, -- synth: sardonyx_earring / courage_earring
    { { 13333, 'NQ' }, { 13376, 'HQ' } }, -- synth: amethyst_earring / balance_earring
    { { 13335, 'NQ' }, { 13378, 'HQ' } }, -- synth: amber_earring / stamina_earring
    { { 13334, 'NQ' }, { 13377, 'HQ' } }, -- synth: lapis_lazuli_earring / tranquility_earring
    { { 13899, 'NQ' }, { 13900, 'HQ' } }, -- synth: bastokan_circlet / republic_circlet
    { { 13336, 'NQ' }, { 14694, 'HQ' } }, -- synth: onyx_earring / energy_earring_+1
    { { 13331, 'NQ' }, { 14689, 'HQ' } }, -- synth: sardonyx_earring / courage_earring_+1
    { { 13334, 'NQ' }, { 14692, 'HQ' } }, -- synth: lapis_lazuli_earring / tranquility_earring_+1
    { { 13337, 'NQ' }, { 14695, 'HQ' } }, -- synth: opal_earring / hope_earring_+1
    { { 13335, 'NQ' }, { 14693, 'HQ' } }, -- synth: amber_earring / stamina_earring_+1
    { { 13333, 'NQ' }, { 14691, 'HQ' } }, -- synth: amethyst_earring / balance_earring_+1
    { { 13330, 'NQ' }, { 14688, 'HQ' } }, -- synth: tourmaline_earring / reflex_earring_+1
    { { 13332, 'NQ' }, { 14690, 'HQ' } }, -- synth: clear_earring / knowledge_earring_+1
    { { 13471, 'NQ' }, { 13524, 'HQ' } }, -- synth: amethyst_ring / balance_ring
    { { 13473, 'NQ' }, { 13526, 'HQ' } }, -- synth: amber_ring / stamina_ring
    { { 13470, 'NQ' }, { 13523, 'HQ' } }, -- synth: clear_ring / knowledge_ring
    { { 13444, 'NQ' }, { 13522, 'HQ' } }, -- synth: sardonyx_ring / courage_ring
    { { 15801, 'NQ' }, { 15802, 'HQ' } }, -- synth: tigereye_ring / feral_ring
    { { 13472, 'NQ' }, { 13525, 'HQ' } }, -- synth: lapis_lazuli_ring / tranquility_ring
    { { 13474, 'NQ' }, { 13527, 'HQ' } }, -- synth: onyx_ring / energy_ring
    { { 13443, 'NQ' }, { 13528, 'HQ' } }, -- synth: opal_ring / hope_ring
    { { 13468, 'NQ' }, { 13521, 'HQ' } }, -- synth: tourmaline_ring / reflex_ring
    { { 13082, 'NQ' }, { 13059, 'HQ' } }, -- synth: chain_gorget / fine_gorget
    { { 13083, 'NQ' }, { 13066, 'HQ' } }, -- synth: chain_choker / red_choker
    { { 13471, 'NQ' }, { 14595, 'HQ' } }, -- synth: amethyst_ring / balance_ring_+1
    { { 13443, 'NQ' }, { 14599, 'HQ' } }, -- synth: opal_ring / hope_ring_+1
    { { 13473, 'NQ' }, { 14597, 'HQ' } }, -- synth: amber_ring / stamina_ring_+1
    { { 13444, 'NQ' }, { 14593, 'HQ' } }, -- synth: sardonyx_ring / courage_ring_+1
    { { 13468, 'NQ' }, { 14592, 'HQ' } }, -- synth: tourmaline_ring / reflex_ring_+1
    { { 13474, 'NQ' }, { 14598, 'HQ' } }, -- synth: onyx_ring / energy_ring_+1
    { { 13472, 'NQ' }, { 14596, 'HQ' } }, -- synth: lapis_lazuli_ring / tranquility_ring_+1
    { { 13470, 'NQ' }, { 14594, 'HQ' } }, -- synth: clear_ring / knowledge_ring_+1
    { { 16456, 'NQ' }, { 16752, 'HQ' } }, -- synth: mythril_baselard / fine_baselard
    { { 13320, 'NQ' }, { 13387, 'HQ' } }, -- synth: black_earring / aura_earring
    { { 13317, 'NQ' }, { 13388, 'HQ' } }, -- synth: pearl_earring / loyalty_earring
    { { 13338, 'NQ' }, { 13382, 'HQ' } }, -- synth: blood_earring / puissance_earring
    { { 13340, 'NQ' }, { 13384, 'HQ' } }, -- synth: ametrine_earring / deft_earring
    { { 13319, 'NQ' }, { 13381, 'HQ' } }, -- synth: peridot_earring / alacrity_earring
    { { 13342, 'NQ' }, { 13386, 'HQ' } }, -- synth: sphene_earring / verve_earring
    { { 13339, 'NQ' }, { 13383, 'HQ' } }, -- synth: goshenite_earring / wisdom_earring
    { { 13341, 'NQ' }, { 13385, 'HQ' } }, -- synth: turquoise_earring / solace_earring
    { { 17972, 'NQ' }, { 17973, 'HQ' } }, -- synth: san_dorian_dagger / kingdom_dagger
    { { 13342, 'NQ' }, { 14701, 'HQ' } }, -- synth: sphene_earring / verve_earring_+1
    { { 13340, 'NQ' }, { 14699, 'HQ' } }, -- synth: ametrine_earring / deft_earring_+1
    { { 13320, 'NQ' }, { 14702, 'HQ' } }, -- synth: black_earring / aura_earring_+1
    { { 13317, 'NQ' }, { 14703, 'HQ' } }, -- synth: pearl_earring / loyalty_earring_+1
    { { 13338, 'NQ' }, { 14697, 'HQ' } }, -- synth: blood_earring / puissance_earring_+1
    { { 13339, 'NQ' }, { 14698, 'HQ' } }, -- synth: goshenite_earring / wisdom_earring_+1
    { { 13341, 'NQ' }, { 14700, 'HQ' } }, -- synth: turquoise_earring / solace_earring_+1
    { { 14141, 'NQ' }, { 14142, 'HQ' } }, -- synth: san_dorian_sollerets / kingdom_sollerets
    { { 807, 'NQ' }, { 790, 'HQ' }, { 803, 'HQ2' }, { 3316, 'HQ3' } }, -- synth: sardonyx / garnet / sunstone / flame_gem
    { { 795, 'NQ' }, { 798, 'HQ' }, { 791, 'HQ2' }, { 3321, 'HQ3' } }, -- synth: lapis_lazuli / turquoise / aquamarine / aqua_gem
    { { 799, 'NQ' }, { 797, 'HQ2' }, { 3323, 'HQ3' } }, -- synth: onyx / painite / shadow_gem
    { { 800, 'NQ' }, { 811, 'HQ' }, { 810, 'HQ2' }, { 3320, 'HQ3' } }, -- synth: amethyst / ametrine / fluorite / thunder_gem
    { { 796, 'NQ' }, { 802, 'HQ2' }, { 3322, 'HQ3' } }, -- synth: light_opal / moonstone / light_gem
    { { 806, 'NQ' }, { 788, 'HQ' }, { 784, 'HQ2' }, { 3318, 'HQ3' } }, -- synth: tourmaline / peridot / jadeite / breeze_gem
    { { 809, 'NQ' }, { 808, 'HQ' }, { 805, 'HQ2' }, { 3317, 'HQ3' } }, -- synth: clear_topaz / goshenite / zircon / snow_gem
    { { 814, 'NQ' }, { 815, 'HQ' }, { 801, 'HQ2' }, { 3319, 'HQ3' } }, -- synth: amber_stone / sphene / chrysoberyl / soil_gem
    { { 14033, 'NQ' }, { 14034, 'HQ' } }, -- synth: san_dorian_mufflers / kingdom_mufflers
    { { 13891, 'NQ' }, { 13892, 'HQ' } }, -- synth: san_dorian_helm / kingdom_helm
    { { 13482, 'NQ' }, { 13535, 'HQ' } }, -- synth: black_ring / aura_ring
    { { 13479, 'NQ' }, { 13532, 'HQ' } }, -- synth: ametrine_ring / deft_ring
    { { 13477, 'NQ' }, { 13530, 'HQ' } }, -- synth: garnet_ring / puissance_ring
    { { 13483, 'NQ' }, { 13536, 'HQ' } }, -- synth: pearl_ring / loyalty_ring
    { { 13476, 'NQ' }, { 13529, 'HQ' } }, -- synth: peridot_ring / alacrity_ring
    { { 13478, 'NQ' }, { 13531, 'HQ' } }, -- synth: goshenite_ring / wisdom_ring
    { { 13481, 'NQ' }, { 13534, 'HQ' } }, -- synth: sphene_ring / verve_ring
    { { 13480, 'NQ' }, { 13533, 'HQ' } }, -- synth: turquoise_ring / solace_ring
    { { 13084, 'NQ' }, { 13067, 'HQ' } }, -- synth: mythril_gorget / nobles_gorget
    { { 13479, 'NQ' }, { 14603, 'HQ' } }, -- synth: ametrine_ring / deft_ring_+1
    { { 13482, 'NQ' }, { 14606, 'HQ' } }, -- synth: black_ring / aura_ring_+1
    { { 13478, 'NQ' }, { 14602, 'HQ' } }, -- synth: goshenite_ring / wisdom_ring_+1
    { { 13477, 'NQ' }, { 14601, 'HQ' } }, -- synth: garnet_ring / puissance_ring_+1
    { { 791, 'NQ' }, { 794, 'HQ' }, { 3925, 'HQ2' } }, -- synth: aquamarine / sapphire / tanzanite_jewel
    { { 13481, 'NQ' }, { 14605, 'HQ' } }, -- synth: sphene_ring / verve_ring_+1
    { { 13480, 'NQ' }, { 14604, 'HQ' } }, -- synth: turquoise_ring / solace_ring_+1
    { { 13476, 'NQ' }, { 14600, 'HQ' } }, -- synth: peridot_ring / alacrity_ring_+1
    { { 13483, 'NQ' }, { 14607, 'HQ' } }, -- synth: pearl_ring / loyalty_ring_+1
    { { 809, 'NQ' }, { 808, 'HQ' }, { 805, 'HQ2' }, { 780, 'HQ3' } }, -- synth: clear_topaz / goshenite / zircon / clarite
    { { 13349, 'NQ' }, { 13395, 'HQ' } }, -- synth: night_earring / mana_earring
    { { 13343, 'NQ' }, { 13389, 'HQ' } }, -- synth: green_earring / celerity_earring
    { { 13345, 'NQ' }, { 13391, 'HQ' } }, -- synth: zircon_earring / genius_earring
    { { 13344, 'NQ' }, { 13390, 'HQ' } }, -- synth: sun_earring / victory_earring
    { { 13347, 'NQ' }, { 13393, 'HQ' } }, -- synth: aquamarine_earring / serenity_earring
    { { 13350, 'NQ' }, { 13396, 'HQ' } }, -- synth: moon_earring / allure_earring
    { { 13348, 'NQ' }, { 13394, 'HQ' } }, -- synth: yellow_earring / vigor_earring
    { { 13346, 'NQ' }, { 13392, 'HQ' } }, -- synth: purple_earring / grace_earring
    { { 13350, 'NQ' }, { 14711, 'HQ' } }, -- synth: moon_earring / allure_earring_+1
    { { 13346, 'NQ' }, { 14707, 'HQ' } }, -- synth: purple_earring / grace_earring_+1
    { { 13349, 'NQ' }, { 14710, 'HQ' } }, -- synth: night_earring / mana_earring_+1
    { { 13345, 'NQ' }, { 14706, 'HQ' } }, -- synth: zircon_earring / genius_earring_+1
    { { 13344, 'NQ' }, { 14705, 'HQ' } }, -- synth: sun_earring / victory_earring_+1
    { { 13347, 'NQ' }, { 14708, 'HQ' } }, -- synth: aquamarine_earring / serenity_earring_+1
    { { 13348, 'NQ' }, { 14709, 'HQ' } }, -- synth: yellow_earring / vigor_earring_+1
    { { 13343, 'NQ' }, { 14704, 'HQ' } }, -- synth: green_earring / celerity_earring_+1
    { { 12802, 'NQ' }, { 14212, 'HQ' } }, -- synth: gold_cuisses / gilt_cuisses
    { { 12477, 'NQ' }, { 12483, 'HQ' } }, -- synth: nobles_crown / aristocrats_crown
    { { 773, 'NQ' }, { 1836, 'HQ3' } }, -- synth: translucent_rock / marble_slab
    { { 12418, 'NQ' }, { 13848, 'HQ' } }, -- synth: gold_armet / gilt_armet
    { { 12930, 'NQ' }, { 14087, 'HQ' } }, -- synth: gold_sabatons / gilt_sabatons
    { { 13488, 'NQ' }, { 13541, 'HQ' } }, -- synth: aquamarine_ring / serenity_ring
    { { 13487, 'NQ' }, { 13540, 'HQ' } }, -- synth: fluorite_ring / grace_ring
    { { 13486, 'NQ' }, { 13539, 'HQ' } }, -- synth: zircon_ring / genius_ring
    { { 13489, 'NQ' }, { 13542, 'HQ' } }, -- synth: chrysoberyl_ring / vigor_ring
    { { 13484, 'NQ' }, { 13537, 'HQ' } }, -- synth: jadeite_ring / celerity_ring
    { { 13485, 'NQ' }, { 13538, 'HQ' } }, -- synth: sun_ring / victory_ring
    { { 13491, 'NQ' }, { 13544, 'HQ' } }, -- synth: moon_ring / allure_ring
    { { 13490, 'NQ' }, { 13543, 'HQ' } }, -- synth: painite_ring / mystic_ring
    { { 15687, 'NQ' }, { 15693, 'HQ' } }, -- synth: sipahi_boots / abtal_boots
    { { 12674, 'NQ' }, { 13959, 'HQ' } }, -- synth: gold_gauntlets / gilt_gauntlets
    { { 12546, 'NQ' }, { 13738, 'HQ' } }, -- synth: gold_cuirass / gilt_cuirass
    { { 13488, 'NQ' }, { 14612, 'HQ' } }, -- synth: aquamarine_ring / serenity_ring_+1
    { { 13489, 'NQ' }, { 14613, 'HQ' } }, -- synth: chrysoberyl_ring / vigor_ring_+1
    { { 13487, 'NQ' }, { 14611, 'HQ' } }, -- synth: fluorite_ring / grace_ring_+1
    { { 12303, 'NQ' }, { 12353, 'HQ' } }, -- synth: gold_buckler / gilt_buckler
    { { 13484, 'NQ' }, { 14608, 'HQ' } }, -- synth: jadeite_ring / celerity_ring_+1
    { { 13491, 'NQ' }, { 14615, 'HQ' } }, -- synth: moon_ring / allure_ring_+1
    { { 13490, 'NQ' }, { 14614, 'HQ' } }, -- synth: painite_ring / mystic_ring_+1
    { { 13485, 'NQ' }, { 14609, 'HQ' } }, -- synth: sun_ring / victory_ring_+1
    { { 13486, 'NQ' }, { 14610, 'HQ' } }, -- synth: zircon_ring / genius_ring_+1
    { { 15395, 'NQ' }, { 15399, 'HQ' } }, -- synth: lords_cuisses / kings_cuisses
    { { 803, 'NQ' }, { 786, 'HQ' }, { 767, 'HQ2' }, { 8919, 'HQ3' } }, -- synth: sunstone / ruby / carnelian / ifritear
    { { 791, 'NQ' }, { 794, 'HQ' }, { 781, 'HQ2' }, { 8920, 'HQ3' } }, -- synth: aquamarine / sapphire / larimar / leviatear
    { { 810, 'NQ' }, { 804, 'HQ' }, { 777, 'HQ2' }, { 8921, 'HQ3' } }, -- synth: fluorite / spinel / fulmenite / ramutear
    { { 784, 'NQ' }, { 785, 'HQ' }, { 779, 'HQ2' }, { 8922, 'HQ3' } }, -- synth: jadeite / emerald / aventurine / garutear
    { { 801, 'NQ' }, { 789, 'HQ' }, { 778, 'HQ2' }, { 8923, 'HQ3' } }, -- synth: chrysoberyl / topaz / heliodor / titatear
    { { 805, 'NQ' }, { 787, 'HQ' }, { 780, 'HQ2' }, { 8924, 'HQ3' } }, -- synth: zircon / diamond / clarite / shivatear
    { { 802, 'NQ' }, { 813, 'HQ' }, { 782, 'HQ2' }, { 8925, 'HQ3' } }, -- synth: moonstone / angelstone / selenite / carbutear
    { { 797, 'NQ' }, { 812, 'HQ' }, { 783, 'HQ2' }, { 8926, 'HQ3' } }, -- synth: painite / deathstone / tenebrite / fenritear
    { { 15189, 'NQ' }, { 15193, 'HQ' } }, -- synth: lords_armet / kings_armet
    { { 13352, 'NQ' }, { 13408, 'HQ' } }, -- synth: ruby_earring / triumph_earring
    { { 13357, 'NQ' }, { 13414, 'HQ' } }, -- synth: angels_earring / heavens_earring
    { { 15333, 'NQ' }, { 15337, 'HQ' } }, -- synth: lords_sabatons / kings_sabatons
    { { 13354, 'NQ' }, { 13410, 'HQ' } }, -- synth: spinel_earring / adroit_earring
    { { 13318, 'NQ' }, { 13412, 'HQ' } }, -- synth: topaz_earring / robust_earring
    { { 13355, 'NQ' }, { 13411, 'HQ' } }, -- synth: sapphire_earring / communion_earring
    { { 13353, 'NQ' }, { 13409, 'HQ' } }, -- synth: diamond_earring / omniscient_earring
    { { 13351, 'NQ' }, { 13407, 'HQ' } }, -- synth: emerald_earring / nimble_earring
    { { 13356, 'NQ' }, { 13413, 'HQ' } }, -- synth: death_earring / hades_earring
    { { 14879, 'NQ' }, { 14883, 'HQ' } }, -- synth: lords_gauntlets / kings_gauntlets
    { { 13757, 'NQ' }, { 13758, 'HQ' } }, -- synth: lords_cuirass / kings_cuirass
    { { 15305, 'NQ' }, { 15306, 'HQ' } }, -- synth: barone_gambieras / conte_gambieras
    { { 13353, 'NQ' }, { 14714, 'HQ' } }, -- synth: diamond_earring / omniscient_earring_+1
    { { 15993, 'NQ' }, { 15994, 'HQ' } }, -- synth: crimson_earring / harmonius_earring
    { { 13354, 'NQ' }, { 14715, 'HQ' } }, -- synth: spinel_earring / adroit_earring_+1
    { { 13355, 'NQ' }, { 14716, 'HQ' } }, -- synth: sapphire_earring / communion_earring_+1
    { { 13356, 'NQ' }, { 14718, 'HQ' } }, -- synth: death_earring / hades_earring_+1
    { { 15991, 'NQ' }, { 15992, 'HQ' } }, -- synth: star_earring / celestial_earring
    { { 13352, 'NQ' }, { 14713, 'HQ' } }, -- synth: ruby_earring / triumph_earring_+1
    { { 13318, 'NQ' }, { 14717, 'HQ' } }, -- synth: topaz_earring / robust_earring_+1
    { { 13357, 'NQ' }, { 14719, 'HQ' } }, -- synth: angels_earring / heavens_earring_+1
    { { 13351, 'NQ' }, { 14712, 'HQ' } }, -- synth: emerald_earring / nimble_earring_+1
    { { 15155, 'NQ' }, { 15156, 'HQ' } }, -- synth: barone_zucchetto / conte_zucchetto
    { { 27386, 'NQ' }, { 27387, 'HQ' } }, -- synth: bewitched_schuhs / voodoo_schuhs
    { { 27479, 'NQ' }, { 27480, 'HQ' } }, -- synth: vexed_gambieras / jinxed_gambieras
    { { 13329, 'NQ' }, { 13434, 'HQ' } }, -- synth: orichalcum_earring / triton_earring
    { { 16453, 'NQ' }, { 17992, 'HQ' } }, -- synth: orichalcum_dagger / tritons_dagger
    { { 27034, 'NQ' }, { 27035, 'HQ' } }, -- synth: bewitched_handschuhs / voodoo_handschuhs
    { { 27123, 'NQ' }, { 27124, 'HQ' } }, -- synth: vexed_gauntlets / jinxed_gauntlets
    { { 27210, 'NQ' }, { 27211, 'HQ' } }, -- synth: bewitched_diechlings / voodoo_diechlings
    { { 13466, 'NQ' }, { 14616, 'HQ' } }, -- synth: orichalcum_ring / triton_ring
    { { 26682, 'NQ' }, { 26683, 'HQ' } }, -- synth: bewitched_schaller / voodoo_schaller
    { { 26688, 'NQ' }, { 26689, 'HQ' } }, -- synth: bewitched_crown / voodoo_crown
    { { 18058, 'NQ' }, { 18059, 'HQ' } }, -- synth: orichalcum_scythe / tritons_scythe
    { { 25619, 'NQ' }, { 25620, 'HQ' } }, -- synth: vexed_coronet / jinxed_coronet
    { { 13452, 'NQ' }, { 13308, 'HQ' } }, -- synth: sapphire_ring / communion_ring
    { { 13450, 'NQ' }, { 13306, 'HQ' } }, -- synth: diamond_ring / omniscient_ring
    { { 13449, 'NQ' }, { 13305, 'HQ' } }, -- synth: ruby_ring / triumph_ring
    { { 13448, 'NQ' }, { 13304, 'HQ' } }, -- synth: emerald_ring / nimble_ring
    { { 13462, 'NQ' }, { 13310, 'HQ' } }, -- synth: death_ring / hades_ring
    { { 25692, 'NQ' }, { 25693, 'HQ' } }, -- synth: vexed_haubert / jinxed_haubert
    { { 13463, 'NQ' }, { 13311, 'HQ' } }, -- synth: angels_ring / heavens_ring
    { { 26858, 'NQ' }, { 26859, 'HQ' } }, -- synth: bewitched_cuirass / voodoo_cuirass
    { { 13451, 'NQ' }, { 13307, 'HQ' } }, -- synth: spinel_ring / adroit_ring
    { { 14414, 'NQ' }, { 14415, 'HQ' } }, -- synth: shair_manteel / sheikh_manteel
    { { 13453, 'NQ' }, { 13309, 'HQ' } }, -- synth: topaz_ring / robust_ring
    { { 12387, 'NQ' }, { 12388, 'HQ' } }, -- synth: koenig_shield / kaiser_shield
    { { 15771, 'NQ' }, { 15772, 'HQ' } }, -- synth: shining_ring / scintillant_ring
    { { 13463, 'NQ' }, { 14624, 'HQ' } }, -- synth: angels_ring / heavens_ring_+1
    { { 13462, 'NQ' }, { 14623, 'HQ' } }, -- synth: death_ring / hades_ring_+1
    { { 13450, 'NQ' }, { 14619, 'HQ' } }, -- synth: diamond_ring / omniscient_ring_+1
    { { 13451, 'NQ' }, { 14620, 'HQ' } }, -- synth: spinel_ring / adroit_ring_+1
    { { 13448, 'NQ' }, { 14617, 'HQ' } }, -- synth: emerald_ring / nimble_ring_+1
    { { 13452, 'NQ' }, { 14621, 'HQ' } }, -- synth: sapphire_ring / communion_ring_+1
    { { 13449, 'NQ' }, { 14618, 'HQ' } }, -- synth: ruby_ring / triumph_ring_+1
    { { 13453, 'NQ' }, { 14622, 'HQ' } }, -- synth: topaz_ring / robust_ring_+1
    { { 18168, 'NQ' }, { 18169, 'HQ' } }, -- synth: imperial_egg / tsars_egg
    { { 10544, 'NQ' }, { 10545, 'HQ' } }, -- synth: ugol_moufles / mavros_moufles
    { { 15803, 'NQ' }, { 15804, 'HQ' } }, -- synth: crimson_ring / harmonius_ring
    { { 15805, 'NQ' }, { 15806, 'HQ' } }, -- synth: star_ring / celestial_ring
    { { 10641, 'NQ' }, { 10642, 'HQ' } }, -- synth: ugol_sollerets / mavros_sollerets
    { { 10575, 'NQ' }, { 10576, 'HQ' } }, -- synth: ugol_brayettes / mavros_brayettes
    { { 10410, 'NQ' }, { 10411, 'HQ' } }, -- synth: ugol_salade / mavros_salade
    { { 19206, 'NQ' }, { 19207, 'HQ' } }, -- synth: silver_cassandra / great_cassandra
    { { 10494, 'NQ' }, { 10495, 'HQ' } }, -- synth: ugol_haubert / mavros_haubert
    { { 5230, 'NQ' }, { 5231, 'HQ' } }, -- synth: love_chocolate / truelove_chocolate
    { { 14290, 'NQ' }, { 14291, 'HQ' } }, -- synth: vagabonds_hose / nomads_hose
    { { 13806, 'NQ' }, { 13807, 'HQ' } }, -- synth: vagabonds_tunica / nomads_tunica
    { { 12465, 'NQ' }, { 12535, 'HQ' } }, -- synth: cotton_headgear / great_headgear
    { { 12721, 'NQ' }, { 12776, 'HQ' } }, -- synth: cotton_gloves / great_gloves
    { { 13901, 'NQ' }, { 13902, 'HQ' } }, -- synth: windurstian_hachimaki / federation_hachimaki
    { { 14043, 'NQ' }, { 14044, 'HQ' } }, -- synth: windurstian_tekko / federation_tekko
    { { 12977, 'NQ' }, { 13032, 'HQ' } }, -- synth: cotton_gaiters / great_gaiters
    { { 14151, 'NQ' }, { 14152, 'HQ' } }, -- synth: windurstian_kyahan / federation_kyahan
    { { 12849, 'NQ' }, { 12900, 'HQ' } }, -- synth: cotton_brais / great_brais
    { { 12498, 'NQ' }, { 12536, 'HQ' } }, -- synth: cotton_headband / erudites_headband
    { { 13903, 'NQ' }, { 13904, 'HQ' } }, -- synth: windurstian_headgear / federation_headgear
    { { 12593, 'NQ' }, { 12669, 'HQ' } }, -- synth: cotton_doublet / great_doublet
    { { 14045, 'NQ' }, { 14046, 'HQ' } }, -- synth: windurstian_gloves / federation_gloves
    { { 14269, 'NQ' }, { 14270, 'HQ' } }, -- synth: windurstian_sitabaki / federation_sitabaki
    { { 14348, 'NQ' }, { 14349, 'HQ' } }, -- synth: san_dorian_tunic / kingdom_tunic
    { { 14153, 'NQ' }, { 14154, 'HQ' } }, -- synth: windurstian_gaiters / federation_gaiters
    { { 15207, 'NQ' }, { 15208, 'HQ' } }, -- synth: traders_chapeau / barons_chapeau
    { { 14053, 'NQ' }, { 14054, 'HQ' } }, -- synth: traders_cuffs / barons_cuffs
    { { 14292, 'NQ' }, { 14293, 'HQ' } }, -- synth: fishermans_hose / anglers_hose
    { { 14350, 'NQ' }, { 14351, 'HQ' } }, -- synth: windurstian_gi / federation_gi
    { { 14271, 'NQ' }, { 14272, 'HQ' } }, -- synth: windurstian_brais / federation_brais
    { { 15404, 'NQ' }, { 15405, 'HQ' } }, -- synth: traders_slops / barons_slops
    { { 14446, 'NQ' }, { 14447, 'HQ' } }, -- synth: traders_saio / barons_saio
    { { 14352, 'NQ' }, { 14353, 'HQ' } }, -- synth: windurstian_doublet / federation_doublet
    { { 13808, 'NQ' }, { 13809, 'HQ' } }, -- synth: fishermans_tunica / anglers_tunica
    { { 14273, 'NQ' }, { 14274, 'HQ' } }, -- synth: windurstian_slops / federation_slops
    { { 14857, 'NQ' }, { 14861, 'HQ' } }, -- synth: garish_mitts / rubious_mitts
    { { 14326, 'NQ' }, { 14330, 'HQ' } }, -- synth: garish_slacks / rubious_slacks
    { { 14425, 'NQ' }, { 14432, 'HQ' } }, -- synth: garish_tunic / rubious_tunic
    { { 12499, 'NQ' }, { 12540, 'HQ' } }, -- synth: flax_headband / alluring_headband
    { { 13322, 'NQ' }, { 13361, 'HQ' } }, -- synth: wing_earring / drone_earring
    { { 13931, 'NQ' }, { 13932, 'HQ' } }, -- synth: lilac_corsage / gala_corsage
    { { 14294, 'NQ' }, { 14295, 'HQ' } }, -- synth: chocobo_hose / riders_hose
    { { 12865, 'NQ' }, { 12917, 'HQ' } }, -- synth: black_slacks / mages_slacks
    { { 13568, 'NQ' }, { 13833, 'HQ' } }, -- synth: scarlet_ribbon / nobles_ribbon
    { { 12609, 'NQ' }, { 13725, 'HQ' } }, -- synth: black_tunic / mages_tunic
    { { 12475, 'NQ' }, { 13834, 'HQ' } }, -- synth: velvet_hat / mages_hat
    { { 12859, 'NQ' }, { 12918, 'HQ' } }, -- synth: velvet_slops / mages_slops
    { { 12603, 'NQ' }, { 13726, 'HQ' } }, -- synth: velvet_robe / mages_robe
    { { 12731, 'NQ' }, { 12793, 'HQ' } }, -- synth: velvet_cuffs / mages_cuffs
    { { 12739, 'NQ' }, { 12794, 'HQ' } }, -- synth: black_mitts / mages_mitts
    { { 14297, 'NQ' }, { 14298, 'HQ' } }, -- synth: field_hose / worker_hose
    { { 15605, 'NQ' }, { 15608, 'HQ' } }, -- synth: jaridah_salvars / akinji_salvars
    { { 14907, 'NQ' }, { 14908, 'HQ' } }, -- synth: crow_bracers / raven_bracers
    { { 11372, 'NQ' }, { 11373, 'HQ' } }, -- synth: junrenshi_habaki / seirenshi_habaki
    { { 16079, 'NQ' }, { 16080, 'HQ' } }, -- synth: silken_hat / magi_hat
    { { 15242, 'NQ' }, { 15243, 'HQ' } }, -- synth: crow_beret / raven_beret
    { { 14249, 'NQ' }, { 14250, 'HQ' } }, -- synth: opaline_hose / ceremonial_hose
    { { 13643, 'NQ' }, { 13644, 'HQ' } }, -- synth: sarcenet_cape / midnight_cape
    { { 16365, 'NQ' }, { 16366, 'HQ' } }, -- synth: argent_hose / platino_hose
    { { 15620, 'NQ' }, { 15621, 'HQ' } }, -- synth: silken_slops / magi_slops
    { { 14498, 'NQ' }, { 14499, 'HQ' } }, -- synth: crow_jupon / raven_jupon
    { { 14542, 'NQ' }, { 14543, 'HQ' } }, -- synth: silken_coat / magi_coat
    { { 14374, 'NQ' }, { 14375, 'HQ' } }, -- synth: field_tunica / worker_tunica
    { { 13748, 'NQ' }, { 13749, 'HQ' } }, -- synth: vermillion_cloak / royal_cloak
    { { 14955, 'NQ' }, { 14956, 'HQ' } }, -- synth: silken_cuffs / magi_cuffs
    { { 15618, 'NQ' }, { 15619, 'HQ' } }, -- synth: vendors_slops / princes_slops
    { { 13651, 'NQ' }, { 13652, 'HQ' } }, -- synth: cheviot_cape / umbra_cape
    { { 11374, 'NQ' }, { 11375, 'HQ' } }, -- synth: junhanshi_habaki / seihanshi_habaki
    { { 13884, 'NQ' }, { 13885, 'HQ' } }, -- synth: jesters_headband / jugglers_headband
    { { 15603, 'NQ' }, { 15607, 'HQ' } }, -- synth: sipahi_zerehs / abtal_zerehs
    { { 12733, 'NQ' }, { 13999, 'HQ' } }, -- synth: nobles_mitts / aristocrats_mitts
    { { 12861, 'NQ' }, { 14239, 'HQ' } }, -- synth: nobles_slacks / aristocrats_slacks
    { { 16061, 'NQ' }, { 16067, 'HQ' } }, -- synth: sipahi_turban / abtal_turban
    { { 12504, 'NQ' }, { 13858, 'HQ' } }, -- synth: rainbow_headband / prism_headband
    { { 12605, 'NQ' }, { 13774, 'HQ' } }, -- synth: nobles_tunic / aristocrats_coat
    { { 13772, 'NQ' }, { 13773, 'HQ' } }, -- synth: bloody_aketon / carnage_aketon
    { { 13779, 'NQ' }, { 13780, 'HQ' } }, -- synth: black_cloak / demons_cloak
    { { 13208, 'NQ' }, { 13235, 'HQ' } }, -- synth: rainbow_obi / prism_obi
    { { 15153, 'NQ' }, { 15154, 'HQ' } }, -- synth: shair_turban / sheikh_turban
    { { 13929, 'NQ' }, { 13930, 'HQ' } }, -- synth: errant_hat / mahatma_hat
    { { 27131, 'NQ' }, { 27132, 'HQ' } }, -- synth: vexed_cuffs / jinxed_cuffs
    { { 27040, 'NQ' }, { 27041, 'HQ' } }, -- synth: bewitched_mitts / voodoo_mitts
    { { 14315, 'NQ' }, { 14316, 'HQ' } }, -- synth: shair_seraweels / sheikh_seraweels
    { { 27216, 'NQ' }, { 27217, 'HQ' } }, -- synth: bewitched_slacks / voodoo_slacks
    { { 27316, 'NQ' }, { 27317, 'HQ' } }, -- synth: vexed_tights / jinxed_tights
    { { 27312, 'NQ' }, { 27313, 'HQ' } }, -- synth: vexed_kecks / jinxed_kecks
    { { 14301, 'NQ' }, { 14302, 'HQ' } }, -- synth: errant_slops / mahatma_slops
    { { 25623, 'NQ' }, { 25624, 'HQ' } }, -- synth: vexed_bonnet / jinxed_bonnet
    { { 25627, 'NQ' }, { 25628, 'HQ' } }, -- synth: vexed_mitra / jinxed_mitra
    { { 13587, 'NQ' }, { 13627, 'HQ' } }, -- synth: rainbow_cape / prism_cape
    { { 14384, 'NQ' }, { 14385, 'HQ' } }, -- synth: opaline_dress / ceremonial_dress
    { { 13212, 'NQ' }, { 13188, 'HQ' } }, -- synth: tarutaru_sash / star_sash
    { { 26864, 'NQ' }, { 26865, 'HQ' } }, -- synth: bewitched_dalmatica / voodoo_dalmatica
    { { 25700, 'NQ' }, { 25701, 'HQ' } }, -- synth: vexed_bliaut / jinxed_bliaut
    { { 14380, 'NQ' }, { 14381, 'HQ' } }, -- synth: errant_houppelande / mahatma_houppelande
    { { 14078, 'NQ' }, { 14079, 'HQ' } }, -- synth: errant_cuffs / mahatma_cuffs
    { { 15891, 'NQ' }, { 15892, 'HQ' } }, -- synth: al_zahbi_sash / moon_sash
    { { 11310, 'NQ' }, { 11311, 'HQ' } }, -- synth: argent_coat / platino_coat
    { { 13656, 'NQ' }, { 13657, 'HQ' } }, -- synth: errant_cape / mahatma_cape
    { { 10414, 'NQ' }, { 10415, 'HQ' } }, -- synth: spolia_chapeau / opima_chapeau
    { { 10579, 'NQ' }, { 10580, 'HQ' } }, -- synth: spolia_trews / opima_trews
    { { 10548, 'NQ' }, { 10549, 'HQ' } }, -- synth: spolia_cuffs / opima_cuffs
    { { 10498, 'NQ' }, { 10499, 'HQ' } }, -- synth: spolia_saio / opima_saio
    { { 14068, 'NQ' }, { 14069, 'HQ' } }, -- synth: vagabonds_gloves / nomads_gloves
    { { 14169, 'NQ' }, { 14170, 'HQ' } }, -- synth: vagabonds_boots / nomads_boots
    { { 17495, 'NQ' }, { 17496, 'HQ' } }, -- synth: san_dorian_cesti / kingdom_cesti
    { { 14070, 'NQ' }, { 14071, 'HQ' } }, -- synth: fishermans_gloves / anglers_gloves
    { { 12697, 'NQ' }, { 12785, 'HQ' } }, -- synth: lizard_gloves / fine_gloves
    { { 16386, 'NQ' }, { 16398, 'HQ' } }, -- synth: lizard_cesti / burning_cesti
    { { 12953, 'NQ' }, { 13038, 'HQ' } }, -- synth: lizard_ledelsens / fine_ledelsens
    { { 12825, 'NQ' }, { 12909, 'HQ' } }, -- synth: lizard_trousers / fine_trousers
    { { 12569, 'NQ' }, { 13697, 'HQ' } }, -- synth: lizard_jerkin / fine_jerkin
    { { 14171, 'NQ' }, { 14172, 'HQ' } }, -- synth: fishermans_boots / anglers_boots
    { { 14072, 'NQ' }, { 14073, 'HQ' } }, -- synth: chocobo_gloves / riders_gloves
    { { 12442, 'NQ' }, { 13824, 'HQ' } }, -- synth: studded_bandana / strong_bandana
    { { 12698, 'NQ' }, { 12786, 'HQ' } }, -- synth: studded_gloves / strong_gloves
    { { 15343, 'NQ' }, { 15344, 'HQ' } }, -- synth: traders_pigaches / barons_pigaches
    { { 12954, 'NQ' }, { 13039, 'HQ' } }, -- synth: studded_boots / strong_boots
    { { 12993, 'NQ' }, { 13048, 'HQ' } }, -- synth: sandals / mages_sandals
    { { 13895, 'NQ' }, { 13896, 'HQ' } }, -- synth: san_dorian_bandana / kingdom_bandana
    { { 14173, 'NQ' }, { 14174, 'HQ' } }, -- synth: chocobo_boots / riders_boots
    { { 12826, 'NQ' }, { 12910, 'HQ' } }, -- synth: studded_trousers / strong_trousers
    { { 14037, 'NQ' }, { 14038, 'HQ' } }, -- synth: san_dorian_gloves / kingdom_gloves
    { { 12570, 'NQ' }, { 13707, 'HQ' } }, -- synth: studded_vest / strong_vest
    { { 14817, 'NQ' }, { 14818, 'HQ' } }, -- synth: field_gloves / worker_gloves
    { { 14145, 'NQ' }, { 14146, 'HQ' } }, -- synth: san_dorian_boots / kingdom_boots
    { { 14265, 'NQ' }, { 14266, 'HQ' } }, -- synth: san_dorian_trousers / kingdom_trousers
    { { 15314, 'NQ' }, { 15318, 'HQ' } }, -- synth: garish_pumps / rubious_pumps
    { { 14344, 'NQ' }, { 14345, 'HQ' } }, -- synth: san_dorian_vest / kingdom_vest
    { { 14176, 'NQ' }, { 14177, 'HQ' } }, -- synth: field_boots / worker_boots
    { { 13203, 'NQ' }, { 13225, 'HQ' } }, -- synth: barbarians_belt / brave_belt
    { { 13810, 'NQ' }, { 13811, 'HQ' } }, -- synth: chocobo_jack_coat / riders_jack_coat
    { { 17505, 'NQ' }, { 17506, 'HQ' } }, -- synth: narasimhas_cesti / vishnus_cesti
    { { 13593, 'NQ' }, { 13612, 'HQ' } }, -- synth: raptor_mantle / dino_mantle
    { { 12828, 'NQ' }, { 12919, 'HQ' } }, -- synth: raptor_trousers / dino_trousers
    { { 12956, 'NQ' }, { 13049, 'HQ' } }, -- synth: raptor_ledelsens / dino_ledelsens
    { { 15663, 'NQ' }, { 15664, 'HQ' } }, -- synth: crow_gaiters / raven_gaiters
    { { 12444, 'NQ' }, { 13835, 'HQ' } }, -- synth: raptor_helm / dino_helm
    { { 12700, 'NQ' }, { 12795, 'HQ' } }, -- synth: raptor_gloves / dino_gloves
    { { 12572, 'NQ' }, { 13727, 'HQ' } }, -- synth: raptor_jerkin / dino_jerkin
    { { 13546, 'NQ' }, { 13547, 'HQ' } }, -- synth: hard_leather_ring / tiger_ring
    { { 15578, 'NQ' }, { 15579, 'HQ' } }, -- synth: crow_hose / raven_hose
    { { 16063, 'NQ' }, { 16068, 'HQ' } }, -- synth: jaridah_khud / akinji_khud
    { { 14526, 'NQ' }, { 14529, 'HQ' } }, -- synth: jaridah_peti / akinji_peti
    { { 13754, 'NQ' }, { 13755, 'HQ' } }, -- synth: black_cotehardie / flora_cotehardie
    { { 15706, 'NQ' }, { 15707, 'HQ' } }, -- synth: silken_pigaches / magi_pigaches
    { { 16389, 'NQ' }, { 17473, 'HQ' } }, -- synth: coeurl_cesti / torama_cesti
    { { 12830, 'NQ' }, { 14232, 'HQ' } }, -- synth: tiger_trousers / feral_trousers
    { { 12958, 'NQ' }, { 14108, 'HQ' } }, -- synth: tiger_ledelsens / feral_ledelsens
    { { 13589, 'NQ' }, { 13602, 'HQ' } }, -- synth: tiger_mantle / feral_mantle
    { { 12702, 'NQ' }, { 13992, 'HQ' } }, -- synth: tiger_gloves / feral_gloves
    { { 12446, 'NQ' }, { 13861, 'HQ' } }, -- synth: tiger_helm / feral_helm
    { { 13092, 'NQ' }, { 13132, 'HQ' } }, -- synth: coeurl_gorget / torama_gorget
    { { 12574, 'NQ' }, { 13763, 'HQ' } }, -- synth: tiger_jerkin / feral_jerkin
    { { 12989, 'NQ' }, { 14114, 'HQ' } }, -- synth: nobles_pumps / aristocrats_pumps
    { { 12831, 'NQ' }, { 14233, 'HQ' } }, -- synth: coeurl_trousers / torama_trousers
    { { 12959, 'NQ' }, { 14109, 'HQ' } }, -- synth: coeurl_ledelsens / torama_ledelsens
    { { 14284, 'NQ' }, { 14285, 'HQ' } }, -- synth: northern_jerkin / tundra_jerkin
    { { 13595, 'NQ' }, { 13603, 'HQ' } }, -- synth: coeurl_mantle / torama_mantle
    { { 12447, 'NQ' }, { 13862, 'HQ' } }, -- synth: coeurl_mask / torama_mask
    { { 14932, 'NQ' }, { 14938, 'HQ' } }, -- synth: sipahi_dastana / abtal_dastanas
    { { 12703, 'NQ' }, { 13993, 'HQ' } }, -- synth: coeurl_gloves / torama_gloves
    { { 12575, 'NQ' }, { 13764, 'HQ' } }, -- synth: coeurl_jerkin / torama_jerkin
    { { 14317, 'NQ' }, { 14318, 'HQ' } }, -- synth: barone_cosciales / conte_cosciales
    { { 13197, 'NQ' }, { 13239, 'HQ' } }, -- synth: koenigs_belt / kaiser_belt
    { { 14850, 'NQ' }, { 14851, 'HQ' } }, -- synth: bison_wristbands / braves_wristbands
    { { 14981, 'NQ' }, { 14982, 'HQ' } }, -- synth: khimaira_wristbands / stout_wristbands
    { { 14524, 'NQ' }, { 14528, 'HQ' } }, -- synth: sipahi_jawshan / abtal_jawshan
    { { 27487, 'NQ' }, { 27488, 'HQ' } }, -- synth: vexed_boots / jinxed_boots
    { { 14182, 'NQ' }, { 14183, 'HQ' } }, -- synth: errant_pigaches / mahatma_pigaches
    { { 27392, 'NQ' }, { 27393, 'HQ' } }, -- synth: bewitched_pumps / voodoo_pumps
    { { 27125, 'NQ' }, { 27126, 'HQ' } }, -- synth: vexed_tekko / jinxed_tekko
    { { 15303, 'NQ' }, { 15304, 'HQ' } }, -- synth: shair_crackows / sheikh_crackows
    { { 15307, 'NQ' }, { 15308, 'HQ' } }, -- synth: bison_gamashes / braves_gamashes
    { { 13939, 'NQ' }, { 13940, 'HQ' } }, -- synth: austere_hat / penance_hat
    { { 27310, 'NQ' }, { 27311, 'HQ' } }, -- synth: vexed_hakama / jinxed_hakama
    { { 27308, 'NQ' }, { 27309, 'HQ' } }, -- synth: vexed_hose / jinxed_hose
    { { 15731, 'NQ' }, { 15732, 'HQ' } }, -- synth: khimaira_gamashes / stout_gamashes
    { { 14189, 'NQ' }, { 14190, 'HQ' } }, -- synth: austere_sabots / penance_sabots
    { { 14372, 'NQ' }, { 14373, 'HQ' } }, -- synth: cardinal_vest / bachelor_vest
    { { 13918, 'NQ' }, { 13919, 'HQ' } }, -- synth: tiger_mask / feral_mask
    { { 15157, 'NQ' }, { 15158, 'HQ' } }, -- synth: bison_warbonnet / braves_warbonnet
    { { 16104, 'NQ' }, { 16105, 'HQ' } }, -- synth: khimaira_bonnet / stout_bonnet
    { { 14116, 'NQ' }, { 14125, 'HQ' } }, -- synth: opaline_boots / ceremonial_boots
    { { 14846, 'NQ' }, { 14847, 'HQ' } }, -- synth: shair_gages / sheikh_gages
    { { 15645, 'NQ' }, { 15646, 'HQ' } }, -- synth: khimaira_kecks / stout_kecks
    { { 14319, 'NQ' }, { 14320, 'HQ' } }, -- synth: bison_kecks / braves_kecks
    { { 14826, 'NQ' }, { 14827, 'HQ' } }, -- synth: austere_cuffs / penance_cuffs
    { { 14310, 'NQ' }, { 14311, 'HQ' } }, -- synth: austere_slops / penance_slops
    { { 14418, 'NQ' }, { 14419, 'HQ' } }, -- synth: bison_jacket / braves_jacket
    { { 13816, 'NQ' }, { 13817, 'HQ' } }, -- synth: narasimhas_vest / vishnus_vest
    { { 14566, 'NQ' }, { 14567, 'HQ' } }, -- synth: khimaira_jacket / stout_jacket
    { { 10645, 'NQ' }, { 10646, 'HQ' } }, -- synth: spolia_pigaches / opima_pigaches
    { { 13814, 'NQ' }, { 13815, 'HQ' } }, -- synth: austere_robe / penance_robe
    { { 10577, 'NQ' }, { 10578, 'HQ' } }, -- synth: urja_trousers / sthira_trousers
    { { 10412, 'NQ' }, { 10413, 'HQ' } }, -- synth: urja_helm / sthira_helm
    { { 10998, 'NQ' }, { 10999, 'HQ' } }, -- synth: attackers_mantle / dauntless_mantle
    { { 10546, 'NQ' }, { 10547, 'HQ' } }, -- synth: urja_gloves / sthira_gloves
    { { 10643, 'NQ' }, { 10644, 'HQ' } }, -- synth: urja_ledelsens / sthira_ledelsens
    { { 10496, 'NQ' }, { 10497, 'HQ' } }, -- synth: urja_jerkin / sthira_jerkin
    { { 17497, 'NQ' }, { 17498, 'HQ' } }, -- synth: windurstian_baghnakhs / federation_baghnakhs
    { { 13076, 'NQ' }, { 13061, 'HQ' } }, -- synth: fang_necklace / spike_necklace
    { { 864, 'NQ' }, { 1587, 'HQ' } }, -- synth: handful_of_fish_scales / handful_of_high-quality_pugil_scales
    { { 792, 'NQ' }, { 793, 'HQ' } }, -- synth: pearl / black_pearl
    { { 17296, 'NQ' }, { 792, 'HQ' }, { 793, 'HQ2' } }, -- synth: pebble / pearl / black_pearl
    { { 17835, 'NQ' }, { 17836, 'HQ' } }, -- synth: san_dorian_horn / kingdom_horn
    { { 13090, 'NQ' }, { 13062, 'HQ' } }, -- synth: beetle_gorget / green_gorget
    { { 15164, 'NQ' }, { 15168, 'HQ' } }, -- synth: garish_crown / rubious_crown
    { { 18050, 'NQ' }, { 18051, 'HQ' } }, -- synth: mandibular_sickle / antlion_sickle
    { { 13091, 'NQ' }, { 13063, 'HQ' } }, -- synth: carapace_gorget / blue_gorget
    { { 13325, 'NQ' }, { 13369, 'HQ' } }, -- synth: fang_earring / spike_earring
    { { 16525, 'NQ' }, { 17634, 'HQ' } }, -- synth: hornet_fleuret / wasp_fleuret
    { { 12878, 'NQ' }, { 14235, 'HQ' } }, -- synth: coral_subligar / mermans_subligar
    { { 12709, 'NQ' }, { 13995, 'HQ' } }, -- synth: coral_mittens / mermans_mittens
    { { 12965, 'NQ' }, { 14111, 'HQ' } }, -- synth: coral_leggings / mermans_leggings
    { { 12508, 'NQ' }, { 13850, 'HQ' } }, -- synth: coral_hairpin / mermans_hairpin
    { { 12453, 'NQ' }, { 13864, 'HQ' } }, -- synth: coral_cap / mermans_cap
    { { 16422, 'NQ' }, { 17490, 'HQ' } }, -- synth: tigerfangs / feral_fangs
    { { 13108, 'NQ' }, { 13123, 'HQ' } }, -- synth: coral_gorget / mermans_gorget
    { { 12581, 'NQ' }, { 13766, 'HQ' } }, -- synth: coral_harness / mermans_harness
    { { 13455, 'NQ' }, { 13504, 'HQ' } }, -- synth: coral_ring / mermans_ring
    { { 13312, 'NQ' }, { 13406, 'HQ' } }, -- synth: coral_earring / mermans_earring
    { { 13987, 'NQ' }, { 13988, 'HQ' } }, -- synth: coral_bangles / mermans_bangles
    { { 16548, 'NQ' }, { 16620, 'HQ' } }, -- synth: coral_sword / mermans_sword
    { { 15159, 'NQ' }, { 15160, 'HQ' } }, -- synth: igqira_tiara / genie_tiara
    { { 27483, 'NQ' }, { 27484, 'HQ' } }, -- synth: vexed_gamashes / jinxed_gamashes
    { { 27384, 'NQ' }, { 27385, 'HQ' } }, -- synth: bewitched_leggings / voodoo_leggings
    { { 27032, 'NQ' }, { 27033, 'HQ' } }, -- synth: bewitched_gloves / voodoo_gloves
    { { 27127, 'NQ' }, { 27128, 'HQ' } }, -- synth: vexed_wristbands / jinxed_wristbands
    { { 14852, 'NQ' }, { 14853, 'HQ' } }, -- synth: igqira_manillas / genie_manillas
    { { 18789, 'NQ' }, { 18790, 'HQ' } }, -- synth: marath_baghnakhs / shivaji_baghnakhs
    { { 27208, 'NQ' }, { 27209, 'HQ' } }, -- synth: bewitched_subligar / voodoo_subligar
    { { 26680, 'NQ' }, { 26681, 'HQ' } }, -- synth: bewitched_cap / voodoo_cap
    { { 15309, 'NQ' }, { 15310, 'HQ' } }, -- synth: igqira_huaraches / genie_huaraches
    { { 26856, 'NQ' }, { 26857, 'HQ' } }, -- synth: bewitched_harness / voodoo_harness
    { { 25696, 'NQ' }, { 25697, 'HQ' } }, -- synth: vexed_jacket / jinxed_jacket
    { { 15813, 'NQ' }, { 15814, 'HQ' } }, -- synth: trumpet_ring / nereid_ring
    { { 14321, 'NQ' }, { 14322, 'HQ' } }, -- synth: igqira_lappas / genie_lappas
    { { 14420, 'NQ' }, { 14421, 'HQ' } }, -- synth: igqira_weskit / genie_weskit
    { { 18030, 'NQ' }, { 18031, 'HQ' } }, -- synth: khimaira_jambiya / amir_jambiya
    { { 18793, 'NQ' }, { 18794, 'HQ' } }, -- synth: blutkrallen / blutklauen
    { { 1230, 'NQ' }, { 1234, 'HQ' }, { 1233, 'HQ2' }, { 1225, 'HQ3' } }, -- synth: copper_nugget / iron_nugget / silver_nugget / gold_nugget
    { { 16458, 'NQ' }, { 16743, 'HQ' } }, -- synth: poison_baselard / python_baselard
    { { 17407, 'NQ' }, { 17400, 'HQ' } }, -- synth: minnow / sinking_minnow
    { { 16594, 'NQ' }, { 16928, 'HQ' } }, -- synth: inferno_sword / hellfire_sword
    { { 16709, 'NQ' }, { 16713, 'HQ' } }, -- synth: inferno_axe / hellfire_axe
    { { 16588, 'NQ' }, { 16929, 'HQ' } }, -- synth: flame_claymore / burning_claymore
    { { 17605, 'NQ' }, { 17606, 'HQ' } }, -- synth: acid_dagger / corrosive_dagger
    { { 16543, 'NQ' }, { 16621, 'HQ' } }, -- synth: fire_sword / flame_sword
    { { 17404, 'NQ' }, { 17403, 'HQ' }, { 17402, 'HQ2' }, { 17401, 'HQ3' } }, -- synth: worm_lure / frog_lure / shrimp_lure / lizard_lure
    { { 16501, 'NQ' }, { 17608, 'HQ' } }, -- synth: acid_knife / corrosive_knife
    { { 16430, 'NQ' }, { 17487, 'HQ' } }, -- synth: acid_claws / corrosive_claws
    { { 13897, 'NQ' }, { 13898, 'HQ' } }, -- synth: bastokan_visor / republic_visor
    { { 14039, 'NQ' }, { 14040, 'HQ' } }, -- synth: bastokan_finger_gauntlets / republic_finger_gauntlets
    { { 16459, 'NQ' }, { 17607, 'HQ' } }, -- synth: acid_baselard / corrosive_baselard
    { { 14267, 'NQ' }, { 14268, 'HQ' } }, -- synth: bastokan_cuisses / republic_cuisses
    { { 14147, 'NQ' }, { 14148, 'HQ' } }, -- synth: bastokan_greaves / republic_greaves
    { { 16479, 'NQ' }, { 16494, 'HQ' } }, -- synth: acid_kukri / corrosive_kukri
    { { 14346, 'NQ' }, { 14347, 'HQ' } }, -- synth: bastokan_scale_mail / republic_scale_mail
    { { 17729, 'NQ' }, { 17730, 'HQ' } }, -- synth: vermin_slayer / insect_slayer
    { { 17731, 'NQ' }, { 17732, 'HQ' } }, -- synth: aquan_slayer / marine_slayer
    { { 12379, 'NQ' }, { 12380, 'HQ' } }, -- synth: holy_shield / divine_shield
    { { 2206, 'NQ' }, { 2345, 'HQ' } }, -- synth: chocolixir / hi-chocolixir
    { { 16132, 'NQ' }, { 16133, 'HQ' } }, -- synth: dandy_spectacles / fancy_spectacles
    { { 16556, 'NQ' }, { 16827, 'HQ' } }, -- synth: bloody_blade / carnage_blade
    { { 16528, 'NQ' }, { 16824, 'HQ' } }, -- synth: bloody_rapier / carnage_rapier
    { { 14065, 'NQ' }, { 14066, 'HQ' } }, -- synth: garden_bangles / feronias_bangles
    { { 16609, 'NQ' }, { 17646, 'HQ' } }, -- synth: bloody_sword / carnage_sword
    { { 16846, 'NQ' }, { 16881, 'HQ' } }, -- synth: bloody_lance / carnage_lance
    { { 4145, 'NQ' }, { 4144, 'HQ' } }, -- synth: elixir / hi-elixir
    { { 20639, 'NQ' }, { 20640, 'HQ' } }, -- synth: oxidant_baselard / nitric_baselard
    { { 27485, 'NQ' }, { 27486, 'HQ' } }, -- synth: vexed_nails / jinxed_nails
    { { 27394, 'NQ' }, { 27395, 'HQ' } }, -- synth: bewitched_greaves / voodoo_greaves
    { { 27042, 'NQ' }, { 27043, 'HQ' } }, -- synth: bewitched_finger_gauntlets / voodoo_finger_gauntlets
    { { 27129, 'NQ' }, { 27130, 'HQ' } }, -- synth: vexed_gages / jinxed_gages
    { { 27218, 'NQ' }, { 27219, 'HQ' } }, -- synth: bewitched_cuisses / voodoo_cuisses
    { { 27314, 'NQ' }, { 27315, 'HQ' } }, -- synth: vexed_slops / jinxed_slops
    { { 25625, 'NQ' }, { 25626, 'HQ' } }, -- synth: vexed_coif / jinxed_coif
    { { 26690, 'NQ' }, { 26691, 'HQ' } }, -- synth: bewitched_mask / voodoo_mask
    { { 25698, 'NQ' }, { 25699, 'HQ' } }, -- synth: vexed_doublet / jinxed_doublet
    { { 26866, 'NQ' }, { 26867, 'HQ' } }, -- synth: bewitched_mail / voodoo_mail
    { { 17733, 'NQ' }, { 17734, 'HQ' } }, -- synth: dragon_slayer / wyrm_slayer
    { { 17735, 'NQ' }, { 17736, 'HQ' } }, -- synth: demon_slayer / devil_slayer
    { { 10790, 'NQ' }, { 10791, 'HQ' } }, -- synth: ephedra_ring / haomas_ring
    { { 10792, 'NQ' }, { 10793, 'HQ' } }, -- synth: saida_ring / eshmuns_ring
    { { 10392, 'NQ' }, { 10393, 'HQ' } }, -- synth: malison_medallion / debilis_medallion
    { { 18914, 'NQ' }, { 18915, 'HQ' } }, -- synth: killers_kilij / eradicators_kilij
    { { 4415, 'NQ' }, { 4334, 'HQ' } }, -- synth: ear_of_roasted_corn / ear_of_grilled_corn
    { { 5672, 'NQ' }, { 5673, 'HQ' } }, -- synth: dried_berry / rolsin
    { { 17860, 'NQ' }, { 17861, 'HQ' } }, -- synth: jug_of_carrot_broth / jug_of_famous_carrot_broth
    { { 4409, 'NQ' }, { 4532, 'HQ' } }, -- synth: hard-boiled_egg / soft-boiled_egg
    { { 4455, 'NQ' }, { 4592, 'HQ' } }, -- synth: bowl_of_pebble_soup / bowl_of_wisdom_soup
    { { 4371, 'NQ' }, { 4516, 'HQ' } }, -- synth: slice_of_grilled_hare / slice_of_grilled_black_hare
    { { 17864, 'NQ' }, { 17865, 'HQ' } }, -- synth: jug_of_herbal_broth / jug_of_singing_herbal_broth
    { { 4355, 'NQ' }, { 4266, 'HQ' } }, -- synth: salmon_sub_sandwich / fulm-long_salmon_sub
    { { 4535, 'NQ' }, { 4338, 'HQ' } }, -- synth: boiled_crayfish / steamed_crayfish
    { { 17866, 'NQ' }, { 17867, 'HQ' } }, -- synth: jug_of_carrion_broth / jug_of_cold_carrion_broth
    { { 4408, 'NQ' }, { 5181, 'HQ' } }, -- synth: tortilla / tortilla_buena
    { { 17862, 'NQ' }, { 17863, 'HQ' } }, -- synth: jug_of_bug_broth / jug_of_quadav_bug_broth
    { { 4410, 'NQ' }, { 4343, 'HQ' } }, -- synth: roast_mushroom / witch_kabob
    { { 4437, 'NQ' }, { 4335, 'HQ' } }, -- synth: slice_of_roast_mutton / slice_of_juicy_mutton
    { { 4416, 'NQ' }, { 4327, 'HQ' } }, -- synth: bowl_of_pea_soup / bowl_of_emerald_soup
    { { 5647, 'NQ' }, { 5648, 'HQ' } }, -- synth: lik_kabob / grilled_lik
    { { 4537, 'NQ' }, { 4586, 'HQ' } }, -- synth: roast_carp / broiled_carp
    { { 4538, 'NQ' }, { 4585, 'HQ' } }, -- synth: roast_pipira / broiled_pipira
    { { 4436, 'NQ' }, { 4282, 'HQ' } }, -- synth: baked_popoto / pipin_hot_popoto
    { { 4406, 'NQ' }, { 4336, 'HQ' } }, -- synth: baked_apple / sweet_baked_apple
    { { 4495, 'NQ' }, { 4324, 'HQ' } }, -- synth: chunk_of_goblin_chocolate / chunk_of_hobgoblin_chocolate
    { { 4492, 'NQ' }, { 4533, 'HQ' } }, -- synth: bowl_of_puls / bowl_of_delicious_puls
    { { 4560, 'NQ' }, { 4323, 'HQ' } }, -- synth: bowl_of_vegetable_soup / bowl_of_vegetable_broth
    { { 4376, 'NQ' }, { 4518, 'HQ' } }, -- synth: strip_of_meat_jerky / strip_of_sheep_jerky
    { { 4489, 'NQ' }, { 4534, 'HQ' } }, -- synth: bowl_of_vegetable_gruel / bowl_of_medicinal_gruel
    { { 4456, 'NQ' }, { 4342, 'HQ' } }, -- synth: boiled_crab / steamed_crab
    { { 5618, 'NQ' }, { 5619, 'HQ' } }, -- synth: bowl_of_zoni_broth / bowl_of_zesty_zoni
    { { 17870, 'NQ' }, { 17871, 'HQ' } }, -- synth: jug_of_meat_broth / jug_of_warm_meat_broth
    { { 4438, 'NQ' }, { 4519, 'HQ' } }, -- synth: dhalmel_steak / wild_steak
    { { 4405, 'NQ' }, { 4604, 'HQ' } }, -- synth: rice_ball / rogue_rice_ball
    { { 4510, 'NQ' }, { 4577, 'HQ' } }, -- synth: acorn_cookie / wild_cookie
    { { 4404, 'NQ' }, { 4587, 'HQ' } }, -- synth: roast_trout / broiled_trout
    { { 4459, 'NQ' }, { 4267, 'HQ' } }, -- synth: nebimonite_bake / buttered_nebimonite
    { { 4364, 'NQ' }, { 4591, 'HQ' } }, -- synth: loaf_of_black_bread / loaf_of_pumpernickel
    { { 4499, 'NQ' }, { 4573, 'HQ' } }, -- synth: loaf_of_iron_bread / loaf_of_steel_bread
    { { 5625, 'NQ' }, { 5626, 'HQ' } }, -- synth: maple_cake / silken_siesta
    { { 4419, 'NQ' }, { 4333, 'HQ' } }, -- synth: bowl_of_mushroom_soup / bowl_of_witch_soup
    { { 5766, 'NQ' }, { 5767, 'HQ2' } }, -- synth: butter_crepe / crepe_delice
    { { 5196, 'NQ' }, { 5207, 'HQ' } }, -- synth: strip_of_buffalo_jerky / strip_of_bison_jerky
    { { 4555, 'NQ' }, { 4321, 'HQ' } }, -- synth: windurst_salad / timbre_timbers_salad
    { { 4496, 'NQ' }, { 4497, 'HQ' } }, -- synth: piece_of_bubble_chocolate / heart_chocolate
    { { 17876, 'NQ' }, { 17877, 'HQ' } }, -- synth: jug_of_fish_broth / jug_of_fish_oil_broth
    { { 4381, 'NQ' }, { 4574, 'HQ2' } }, -- synth: meat_mithkabob / meat_chiefkabob
    { { 5172, 'NQ' }, { 5173, 'HQ2' } }, -- synth: windurst_taco / timbre_timbers_taco
    { { 4590, 'NQ' }, { 4605, 'HQ' } }, -- synth: salmon_rice_ball / naval_rice_ball
    { { 4356, 'NQ' }, { 4292, 'HQ' } }, -- synth: loaf_of_white_bread / loaf_of_pain_de_neige
    { { 4420, 'NQ' }, { 4341, 'HQ' } }, -- synth: bowl_of_tomato_soup / bowl_of_sunset_soup
    { { 5629, 'NQ' }, { 5630, 'HQ' } }, -- synth: orange_cake / silken_squeeze
    { { 4490, 'NQ' }, { 5183, 'HQ2' } }, -- synth: pickled_herring / viking_herring
    { { 5189, 'NQ' }, { 5198, 'HQ2' } }, -- synth: dish_of_spaghetti_vongole_rosso / dish_of_spag._vongole_rosso_+1
    { { 4397, 'NQ' }, { 4520, 'HQ' } }, -- synth: cinna-cookie / coin_cookie
    { { 5557, 'NQ' }, { 5558, 'HQ' } }, -- synth: serving_of_mont_blanc / serving_of_golden_royale
    { { 5775, 'NQ' }, { 5776, 'HQ2' } }, -- synth: chocolate_crepe / crepe_caprice
    { { 4398, 'NQ' }, { 4575, 'HQ2' } }, -- synth: fish_mithkabob / fish_chiefkabob
    { { 4391, 'NQ' }, { 5182, 'HQ2' } }, -- synth: bretzel / salty_bretzel
    { { 5669, 'NQ' }, { 5670, 'HQ' }, { 5671, 'HQ2' } }, -- synth: bowl_of_loach_slop / bowl_of_loach_gruel / bowl_of_loach_soup
    { { 4553, 'NQ' }, { 5184, 'HQ' } }, -- synth: serving_of_batagreen_saute / plate_of_vegan_saute
    { { 5559, 'NQ' }, { 5560, 'HQ' } }, -- synth: serving_of_mille-feuille / serving_of_elysian_eclair
    { { 17885, 'NQ' }, { 17886, 'HQ' } }, -- synth: jug_of_grasshopper_broth / jug_of_noisy_grasshopper_broth
    { { 6583, 'NQ' }, { 6584, 'HQ' } }, -- synth: serving_of_salted_dragonfly_trout / serving_of_grilled_dragonfly_trout
    { { 4457, 'NQ' }, { 4588, 'HQ' } }, -- synth: eel_kabob / broiled_eel
    { { 4407, 'NQ' }, { 5186, 'HQ' } }, -- synth: carp_sushi / plate_of_yahata-style_carp_sushi
    { { 4556, 'NQ' }, { 5555, 'HQ' } }, -- synth: serving_of_icecap_rolanberry / serving_of_flurry_courante
    { { 4556, 'NQ' }, { 4594, 'HQ' } }, -- synth: serving_of_icecap_rolanberry / serving_of_snowy_rolanberry
    { { 4572, 'NQ' }, { 4293, 'HQ' } }, -- synth: serving_of_beaugreen_saute / serving_of_monastic_saute
    { { 4417, 'NQ' }, { 4521, 'HQ' } }, -- synth: bowl_of_egg_soup / bowl_of_humpty_soup
    { { 4563, 'NQ' }, { 4287, 'HQ' } }, -- synth: pamama_tart / opo-opo_tart
    { { 17887, 'NQ' }, { 17888, 'HQ' } }, -- synth: jug_of_mole_broth / jug_of_lively_mole_broth
    { { 4394, 'NQ' }, { 4576, 'HQ' } }, -- synth: ginger_cookie / wizard_cookie
    { { 4466, 'NQ' }, { 4281, 'HQ' } }, -- synth: spicy_cracker / red_hot_cracker
    { { 5771, 'NQ' }, { 5772, 'HQ2' } }, -- synth: ham_and_cheese_crepe / crepe_paysanne
    { { 5170, 'NQ' }, { 5171, 'HQ2' } }, -- synth: green_quiche / emerald_quiche
    { { 5642, 'NQ' }, { 5643, 'HQ' } }, -- synth: serving_of_cilbir / serving_of_cibarious_cilbir
    { { 4458, 'NQ' }, { 4328, 'HQ' } }, -- synth: loaf_of_goblin_bread / loaf_of_hobgoblin_bread
    { { 5238, 'NQ' }, { 5239, 'HQ' }, { 5240, 'HQ2' } }, -- synth: seafood_stewpot / prime_seafood_stewpot / prized_seafood_stewpot
    { { 4460, 'NQ' }, { 4593, 'HQ' } }, -- synth: block_of_stone_cheese / block_of_rock_cheese
    { { 5147, 'NQ' }, { 5155, 'HQ' } }, -- synth: cone_of_snoll_gelato / cone_of_sub-zero_gelato
    { { 5147, 'NQ' }, { 5556, 'HQ' } }, -- synth: cone_of_snoll_gelato / cone_of_seraphs_kiss
    { { 17889, 'NQ' }, { 17890, 'HQ' } }, -- synth: jug_of_blood_broth / jug_of_clear_blood_broth
    { { 4536, 'NQ' }, { 4326, 'HQ' } }, -- synth: blackened_frog / serving_of_frog_flambe
    { { 5614, 'NQ' }, { 5615, 'HQ' } }, -- synth: konigskuchen / uberkuchen
    { { 4430, 'NQ' }, { 4522, 'HQ' } }, -- synth: bowl_of_pumpkin_soup / bowl_of_jack-o-soup
    { { 5142, 'NQ' }, { 5157, 'HQ' } }, -- synth: serving_of_bison_steak / serving_of_marbled_steak
    { { 4487, 'NQ' }, { 4595, 'HQ' } }, -- synth: colored_egg / party_egg
    { { 5193, 'NQ' }, { 5202, 'HQ2' } }, -- synth: dish_of_spaghetti_nero_di_seppia / dish_of_spag._nero_di_seppia_+1
    { { 17891, 'NQ' }, { 17892, 'HQ' } }, -- synth: jug_of_antica_broth / jug_of_fragrant_antica_broth
    { { 4559, 'NQ' }, { 4294, 'HQ' } }, -- synth: serving_of_herb_quus / serving_of_medicinal_quus
    { { 5542, 'NQ' }, { 5543, 'HQ' } }, -- synth: gateau_aux_fraises / midwinter_dream
    { { 4506, 'NQ' }, { 4348, 'HQ' } }, -- synth: mutton_tortilla / mutton_enchilada
    { { 4433, 'NQ' }, { 4589, 'HQ' } }, -- synth: bowl_of_dhalmel_stew / bowl_of_wild_stew
    { { 4494, 'NQ' }, { 4524, 'HQ' } }, -- synth: pot_of_san_dorian_tea / pot_of_royal_tea
    { { 5544, 'NQ' }, { 5545, 'HQ' }, { 5546, 'HQ2' } }, -- synth: crab_stewpot / prime_crab_stewpot / prized_crab_stewpot
    { { 4453, 'NQ' }, { 4340, 'HQ' } }, -- synth: bowl_of_eyeball_soup / bowl_of_optical_soup
    { { 4418, 'NQ' }, { 4337, 'HQ' } }, -- synth: bowl_of_turtle_soup / bowl_of_stamina_soup
    { { 5777, 'NQ' }, { 5778, 'HQ2' } }, -- synth: pear_crepe / crepe_belle_helene
    { { 5145, 'NQ' }, { 5159, 'HQ' } }, -- synth: plate_of_fish_and_chips / plate_of_friture_de_la_misareaux
    { { 4434, 'NQ' }, { 4330, 'HQ' } }, -- synth: plate_of_mushroom_risotto / plate_of_witch_risotto
    { { 2207, 'NQ' }, { 2346, 'HQ' } }, -- synth: celerity_salad / tornado_salad
    { { 5627, 'NQ' }, { 5628, 'HQ' } }, -- synth: yogurt_cake / silken_smile
    { { 4507, 'NQ' }, { 4349, 'HQ' } }, -- synth: rarab_meatball / bunny_ball
    { { 4439, 'NQ' }, { 4284, 'HQ' } }, -- synth: bowl_of_navarin / bowl_of_tender_navarin
    { { 5150, 'NQ' }, { 5153, 'HQ2' } }, -- synth: plate_of_tuna_sushi / plate_of_fatty_tuna_sushi
    { { 4581, 'NQ' }, { 4329, 'HQ' } }, -- synth: blackened_newt / serving_of_newt_flambe
    { { 5550, 'NQ' }, { 5551, 'HQ' } }, -- synth: roll_of_buche_au_chocolat / roll_of_sylvan_excursion
    { { 4539, 'NQ' }, { 4325, 'HQ' } }, -- synth: goblin_pie / hobgoblin_pie
    { { 4498, 'NQ' }, { 4283, 'HQ' } }, -- synth: cup_of_chocomilk / cup_of_choco-delight
    { { 5982, 'NQ' }, { 5983, 'HQ2' } }, -- synth: senroh_skewer / piscators_skewer
    { { 4452, 'NQ' }, { 4285, 'HQ' } }, -- synth: bowl_of_shark_fin_soup / bowl_of_ocean_soup
    { { 5174, 'NQ' }, { 5175, 'HQ2' } }, -- synth: tavnazian_taco / leremieu_taco
    { { 5547, 'NQ' }, { 5548, 'HQ' }, { 5549, 'HQ2' } }, -- synth: beef_stewpot / prime_beef_stewpot / prized_beef_stewpot
    { { 5678, 'NQ' }, { 5679, 'HQ' } }, -- synth: mushroom_salad / cathedral_salad
    { { 4603, 'NQ' }, { 4286, 'HQ' } }, -- synth: cup_of_chamomile_tea / cup_of_healing_tea
    { { 5773, 'NQ' }, { 5774, 'HQ2' } }, -- synth: mushroom_crepe / crepe_forestiere
    { { 4550, 'NQ' }, { 4268, 'HQ' } }, -- synth: plate_of_bream_risotto / plate_of_sea_spray_risotto
    { { 5633, 'NQ' }, { 5634, 'HQ' } }, -- synth: chocolate_cake / silken_spirit
    { { 6063, 'NQ' }, { 6064, 'HQ' } }, -- synth: fruit_parfait / queens_crown
    { { 4544, 'NQ' }, { 4344, 'HQ' } }, -- synth: bowl_of_mushroom_stew / bowl_of_witch_stew
    { { 4502, 'NQ' }, { 5554, 'HQ' } }, -- synth: marron_glace / serving_of_squirrels_delight
    { { 4502, 'NQ' }, { 4269, 'HQ' } }, -- synth: marron_glace / bijou_glace
    { { 5144, 'NQ' }, { 5158, 'HQ' } }, -- synth: serving_of_crimson_jelly / serving_of_vermillion_jelly
    { { 4548, 'NQ' }, { 4295, 'HQ' } }, -- synth: plate_of_coeurl_saute / plate_of_royal_saute
    { { 5552, 'NQ' }, { 5553, 'HQ' } }, -- synth: serving_of_black_pudding / serving_of_dusky_indulgence
    { { 4564, 'NQ' }, { 4331, 'HQ' } }, -- synth: royal_omelette / imperial_omelette
    { { 5616, 'NQ' }, { 5617, 'HQ' } }, -- synth: lebkuchen_house / lebkuchen_manse
    { { 6567, 'NQ' }, { 6568, 'HQ2' } }, -- synth: tropical_crepe / crepe_des_rois
    { { 5611, 'NQ' }, { 5612, 'HQ' }, { 5613, 'HQ2' } }, -- synth: angler_stewpot / prime_angler_stewpot / prize_angler_stewpot
    { { 4279, 'NQ' }, { 5185, 'HQ' } }, -- synth: tavnazian_salad / leremieu_salad
    { { 5676, 'NQ' }, { 5677, 'HQ' } }, -- synth: serving_of_mushroom_saute / serving_of_patriarch_saute
    { { 5968, 'NQ' }, { 5969, 'HQ' } }, -- synth: plate_of_seafood_paella / plate_of_piscators_paella
    { { 5974, 'NQ' }, { 5975, 'HQ' } }, -- synth: plate_of_barnacle_paella / plate_of_flapanos_paella
    { { 5146, 'NQ' }, { 5156, 'HQ' } }, -- synth: hedgehog_pie / porcupine_pie
    { { 5978, 'NQ' }, { 5979, 'HQ' } }, -- synth: plate_of_felicifruit_gelatin / plate_of_dulcet_panettones
    { { 4277, 'NQ' }, { 4278, 'HQ' } }, -- synth: tonosama_rice_ball / shogun_rice_ball
    { { 17907, 'NQ' }, { 17915, 'HQ' } }, -- synth: jug_of_swirling_broth / jug_of_viscous_broth
    { { 4542, 'NQ' }, { 5180, 'HQ' } }, -- synth: bowl_of_brain_stew / bowl_of_sophic_stew
    { { 17908, 'NQ' }, { 17916, 'HQ' } }, -- synth: jug_of_shimmering_broth / jug_of_fermented_broth
    { { 17909, 'NQ' }, { 17917, 'HQ' } }, -- synth: jug_of_spicy_broth / jug_of_bubbly_broth
    { { 17911, 'NQ' }, { 17918, 'HQ' } }, -- synth: jug_of_salubrious_broth / handful_of_windy_greens
    { { 21440, 'NQ' }, { 21441, 'HQ' } }, -- synth: jug_of_sugary_broth / jug_of_glazed_broth
    { { 21442, 'NQ' }, { 21443, 'HQ' } }, -- synth: sticky_webbing / slimy_webbing
    { { 17912, 'NQ' }, { 17919, 'HQ' } }, -- synth: jug_of_fizzy_broth / jug_of_tantalizing_broth
    { { 21438, 'NQ' }, { 21439, 'HQ' } }, -- synth: jug_of_poisonous_broth / jug_of_venomous_broth
    { { 21450, 'NQ' }, { 21451, 'HQ' } }, -- synth: jug_of_electrified_broth / jug_of_bug-ridden_broth
    { { 5930, 'NQ' }, { 5931, 'HQ' } }, -- synth: bowl_of_sprightly_soup / bowl_of_shimmy_soup
    { { 6219, 'NQ' }, { 6220, 'HQ' }, { 6221, 'HQ2' } }, -- synth: warthog_stewpot / prime_warthog_stewpot / prized_warthog_stewpot
    { { 5922, 'NQ' }, { 5923, 'HQ' } }, -- synth: walnut_cookie / juglan_jumble
    { { 21492, 'NQ' }, { 21493, 'HQ' } }, -- synth: jug_of_insipid_broth / jug_of_deepwater_broth
    { { 21494, 'NQ' }, { 21495, 'HQ' } }, -- synth: jug_of_wetlands_broth / jug_of_heavenly_broth
    { { 5926, 'NQ' }, { 5927, 'HQ' } }, -- synth: cup_of_date_tea / cup_of_caravan_tea
    { { 5928, 'NQ' }, { 5929, 'HQ' } }, -- synth: himesama_rice_ball / ojo_rice_ball
    { { 5924, 'NQ' }, { 5925, 'HQ' } }, -- synth: smoldering_salisbury_steak / charred_salisbury_steak
    { { 6223, 'NQ' }, { 6224, 'HQ2' } }, -- synth: cehuetzi_snow_cone / apingaut_snow_cone
    { { 6223, 'NQ' }, { 6225, 'HQ2' } }, -- synth: cehuetzi_snow_cone / cyclical_coalescence
    { { 6069, 'NQ' }, { 6070, 'HQ' } }, -- synth: bowl_of_riverfin_soup / bowl_of_oceanfin_soup
    { { 5893, 'NQ' }, { 5894, 'HQ' } }, -- synth: marine_stewpot / prime_marine_stewpot
    { { 4513, 'NQ' }, { 4234, 'cursed' }, { 1441, 'abjuration' } }, -- abjuration: bottle_of_amrita / bottle_of_cursed_beverage / libation_abjuration
    { { 4511, 'NQ' }, { 4235, 'cursed' }, { 1442, 'abjuration' } }, -- abjuration: bowl_of_ambrosia / bowl_of_cursed_soup / oblation_abjuration
    { { 13934, 'NQ' }, { 13935, 'HQ' }, { 1344, 'cursed' }, { 1345, 'cursed -1' }, { 1314, 'abjuration' } }, -- abjuration: shura_zunari_kabuto / shura_zunari_kabuto_+1 / cursed_kabuto / cursed_kabuto_-1 / dryadic_abjuration_head
    { { 14387, 'NQ' }, { 14388, 'HQ' }, { 1346, 'cursed' }, { 1347, 'cursed -1' }, { 1315, 'abjuration' } }, -- abjuration: shura_togi / shura_togi_+1 / cursed_togi / cursed_togi_-1 / dryadic_abjuration_body
    { { 14821, 'NQ' }, { 14822, 'HQ' }, { 1348, 'cursed' }, { 1349, 'cursed -1' }, { 1316, 'abjuration' } }, -- abjuration: shura_kote / shura_kote_+1 / cursed_kote / cursed_kote_-1 / dryadic_abjuration_hands
    { { 14303, 'NQ' }, { 14304, 'HQ' }, { 1350, 'cursed' }, { 1351, 'cursed -1' }, { 1317, 'abjuration' } }, -- abjuration: shura_haidate / shura_haidate_+1 / cursed_haidate / cursed_haidate_-1 / dryadic_abjuration_legs
    { { 14184, 'NQ' }, { 14185, 'HQ' }, { 1352, 'cursed' }, { 1353, 'cursed -1' }, { 1318, 'abjuration' } }, -- abjuration: shura_sune-ate / shura_sune-ate_+1 / cursed_sune-ate / cursed_sune-ate_-1 / dryadic_abjuration_feet
    { { 12429, 'NQ' }, { 13924, 'HQ' }, { 1354, 'cursed' }, { 1355, 'cursed -1' }, { 1319, 'abjuration' } }, -- abjuration: adaman_celata / armada_celata / cursed_celata / cursed_celata_-1 / earthen_abjuration_head
    { { 12557, 'NQ' }, { 14371, 'HQ' }, { 1356, 'cursed' }, { 1357, 'cursed -1' }, { 1320, 'abjuration' } }, -- abjuration: adaman_hauberk / armada_hauberk / cursed_hauberk / cursed_hauberk_-1 / earthen_abjuration_body
    { { 12685, 'NQ' }, { 14816, 'HQ' }, { 1358, 'cursed' }, { 1359, 'cursed -1' }, { 1321, 'abjuration' } }, -- abjuration: adaman_mufflers / armada_mufflers / cursed_mufflers / cursed_mufflers_-1 / earthen_abjuration_hands
    { { 12813, 'NQ' }, { 14296, 'HQ' }, { 1360, 'cursed' }, { 1361, 'cursed -1' }, { 1322, 'abjuration' } }, -- abjuration: adaman_breeches / armada_breeches / cursed_breeches / cursed_breeches_-1 / earthen_abjuration_legs
    { { 12941, 'NQ' }, { 14175, 'HQ' }, { 1362, 'cursed' }, { 1363, 'cursed -1' }, { 1323, 'abjuration' } }, -- abjuration: adaman_sollerets / armada_sollerets / cursed_sollerets / cursed_sollerets_-1 / earthen_abjuration_feet
    { { 13876, 'NQ' }, { 13877, 'HQ' }, { 1364, 'cursed' }, { 1365, 'cursed -1' }, { 1324, 'abjuration' } }, -- abjuration: zenith_crown / zenith_crown_+1 / cursed_crown / cursed_crown_-1 / aquarian_abjuration_head
    { { 13787, 'NQ' }, { 13788, 'HQ' }, { 1366, 'cursed' }, { 1367, 'cursed -1' }, { 1325, 'abjuration' } }, -- abjuration: dalmatica / dalmatica_+1 / cursed_dalmatica / cursed_dalmatica_-1 / aquarian_abjuration_body
    { { 14006, 'NQ' }, { 14007, 'HQ' }, { 1368, 'cursed' }, { 1369, 'cursed -1' }, { 1326, 'abjuration' } }, -- abjuration: zenith_mitts / zenith_mitts_+1 / cursed_mitts / cursed_mitts_-1 / aquarian_abjuration_hands
    { { 14247, 'NQ' }, { 14248, 'HQ' }, { 1370, 'cursed' }, { 1371, 'cursed -1' }, { 1327, 'abjuration' } }, -- abjuration: zenith_slacks / zenith_slacks_+1 / cursed_slacks / cursed_slacks_-1 / aquarian_abjuration_legs
    { { 14123, 'NQ' }, { 14124, 'HQ' }, { 1372, 'cursed' }, { 1373, 'cursed -1' }, { 1328, 'abjuration' } }, -- abjuration: zenith_pumps / zenith_pumps_+1 / cursed_pumps / cursed_pumps_-1 / aquarian_abjuration_feet
    { { 12421, 'NQ' }, { 13911, 'HQ' }, { 1374, 'cursed' }, { 1375, 'cursed -1' }, { 1329, 'abjuration' } }, -- abjuration: koenig_schaller / kaiser_schaller / cursed_schaller / cursed_schaller_-1 / martial_abjuration_head
    { { 12549, 'NQ' }, { 14370, 'HQ' }, { 1376, 'cursed' }, { 1377, 'cursed -1' }, { 1330, 'abjuration' } }, -- abjuration: koenig_cuirass / kaiser_cuirass / cursed_cuirass / cursed_cuirass_-1 / martial_abjuration_body
    { { 12677, 'NQ' }, { 14061, 'HQ' }, { 1378, 'cursed' }, { 1379, 'cursed -1' }, { 1331, 'abjuration' } }, -- abjuration: koenig_handschuhs / kaiser_handschuhs / cursed_handschuhs / cursed_handschuhs_-1 / martial_abjuration_hands
    { { 12805, 'NQ' }, { 14283, 'HQ' }, { 1380, 'cursed' }, { 1381, 'cursed -1' }, { 1332, 'abjuration' } }, -- abjuration: koenig_diechlings / kaiser_diechlings / cursed_diechlings / cursed_diechlings_-1 / martial_abjuration_legs
    { { 12933, 'NQ' }, { 14163, 'HQ' }, { 1382, 'cursed' }, { 1383, 'cursed -1' }, { 1333, 'abjuration' } }, -- abjuration: koenig_schuhs / kaiser_schuhs / cursed_schuhs / cursed_schuhs_-1 / martial_abjuration_feet
    { { 13908, 'NQ' }, { 13909, 'HQ' }, { 1384, 'cursed' }, { 1385, 'cursed -1' }, { 1334, 'abjuration' } }, -- abjuration: crimson_mask / blood_mask / cursed_mask / cursed_mask_-1 / wyrmal_abjuration_head
    { { 14367, 'NQ' }, { 14368, 'HQ' }, { 1386, 'cursed' }, { 1387, 'cursed -1' }, { 1335, 'abjuration' } }, -- abjuration: crimson_scale_mail / blood_scale_mail / cursed_mail / cursed_mail_-1 / wyrmal_abjuration_body
    { { 14058, 'NQ' }, { 14059, 'HQ' }, { 1388, 'cursed' }, { 1389, 'cursed -1' }, { 1336, 'abjuration' } }, -- abjuration: crimson_finger_gauntlets / blood_finger_gauntlets / cursed_finger_gauntlets / cursed_finger_gauntlets_-1 / wyrmal_abjuration_hands
    { { 14280, 'NQ' }, { 14281, 'HQ' }, { 1390, 'cursed' }, { 1391, 'cursed -1' }, { 1337, 'abjuration' } }, -- abjuration: crimson_cuisses / blood_cuisses / cursed_cuisses / cursed_cuisses_-1 / wyrmal_abjuration_legs
    { { 14160, 'NQ' }, { 14161, 'HQ' }, { 1392, 'cursed' }, { 1393, 'cursed -1' }, { 1338, 'abjuration' } }, -- abjuration: crimson_greaves / blood_greaves / cursed_greaves / cursed_greaves_-1 / wyrmal_abjuration_feet
    { { 13927, 'NQ' }, { 13928, 'HQ' }, { 1394, 'cursed' }, { 1395, 'cursed -1' }, { 1339, 'abjuration' } }, -- abjuration: hecatomb_cap / hecatomb_cap_+1 / cursed_cap / cursed_cap_-1 / neptunal_abjuration_head
    { { 14378, 'NQ' }, { 14379, 'HQ' }, { 1396, 'cursed' }, { 1397, 'cursed -1' }, { 1340, 'abjuration' } }, -- abjuration: hecatomb_harness / hecatomb_harness_+1 / cursed_harness / cursed_harness_-1 / neptunal_abjuration_body
    { { 14076, 'NQ' }, { 14077, 'HQ' }, { 1398, 'cursed' }, { 1399, 'cursed -1' }, { 1341, 'abjuration' } }, -- abjuration: hecatomb_mittens / hecatomb_mittens_+1 / cursed_gloves / cursed_gloves_-1 / neptunal_abjuration_hands
    { { 14308, 'NQ' }, { 14309, 'HQ' }, { 1400, 'cursed' }, { 1401, 'cursed -1' }, { 1342, 'abjuration' } }, -- abjuration: hecatomb_subligar / hecatomb_subligar_+1 / cursed_subligar / cursed_subligar_-1 / neptunal_abjuration_legs
    { { 14180, 'NQ' }, { 14181, 'HQ' }, { 1402, 'cursed' }, { 1403, 'cursed -1' }, { 1343, 'abjuration' } }, -- abjuration: hecatomb_leggings / hecatomb_leggings_+1 / cursed_leggings / cursed_leggings_-1 / neptunal_abjuration_feet
    { { 16113, 'NQ' }, { 16114, 'HQ' }, { 2439, 'cursed' }, { 2440, 'cursed -1' }, { 2429, 'abjuration' } }, -- abjuration: shadow_helm / valkyries_helm / cursed_helm / cursed_helm_-1 / phantasmal_abjuration_head
    { { 14573, 'NQ' }, { 14574, 'HQ' }, { 2441, 'cursed' }, { 2442, 'cursed -1' }, { 2430, 'abjuration' } }, -- abjuration: shadow_breastplate / valkyries_breastplate / cursed_breastplate / cursed_breastplate_-1 / phantasmal_abjuration_body
    { { 14995, 'NQ' }, { 14996, 'HQ' }, { 2443, 'cursed' }, { 2444, 'cursed -1' }, { 2431, 'abjuration' } }, -- abjuration: shadow_gauntlets / valkyries_gauntlets / cursed_gauntlets / cursed_gauntlets_-1 / phantasmal_abjuration_hands
    { { 15655, 'NQ' }, { 15656, 'HQ' }, { 2445, 'cursed' }, { 2446, 'cursed -1' }, { 2432, 'abjuration' } }, -- abjuration: shadow_cuishes / valkyries_cuishes / cursed_cuishes / cursed_cuishes_-1 / phantasmal_abjuration_legs
    { { 15740, 'NQ' }, { 15741, 'HQ' }, { 2447, 'cursed' }, { 2448, 'cursed -1' }, { 2433, 'abjuration' } }, -- abjuration: shadow_sabatons / valkyries_sabatons / cursed_sabatons / cursed_sabatons_-1 / phantasmal_abjuration_feet
    { { 16115, 'NQ' }, { 16116, 'HQ' }, { 2449, 'cursed' }, { 2450, 'cursed -1' }, { 2434, 'abjuration' } }, -- abjuration: shadow_hat / valkyries_hat / cursed_hat / cursed_hat_-1 / hadean_abjuration_head
    { { 14575, 'NQ' }, { 14576, 'HQ' }, { 2451, 'cursed' }, { 2452, 'cursed -1' }, { 2435, 'abjuration' } }, -- abjuration: shadow_coat / valkyries_coat / cursed_coat / cursed_coat_-1 / hadean_abjuration_body
    { { 14997, 'NQ' }, { 14998, 'HQ' }, { 2453, 'cursed' }, { 2454, 'cursed -1' }, { 2436, 'abjuration' } }, -- abjuration: shadow_cuffs / valkyries_cuffs / cursed_cuffs / cursed_cuffs_-1 / hadean_abjuration_hands
    { { 15657, 'NQ' }, { 15658, 'HQ' }, { 2455, 'cursed' }, { 2456, 'cursed -1' }, { 2437, 'abjuration' } }, -- abjuration: shadow_trews / valkyries_trews / cursed_trews / cursed_trews_-1 / hadean_abjuration_legs
    { { 15742, 'NQ' }, { 15743, 'HQ' }, { 2457, 'cursed' }, { 2458, 'cursed -1' }, { 2438, 'abjuration' } }, -- abjuration: shadow_clogs / valkyries_clogs / cursed_clogs / cursed_clogs_-1 / hadean_abjuration_feet
    { { 10400, 'NQ' }, { 10405, 'HQ' }, { 10419, 'cursed' }, { 10424, 'cursed -1' }, { 3559, 'abjuration' } }, -- abjuration: hrafn_coronet / huginn_coronet / hexed_coronet / hexed_coronet_-1 / corvine_abjuration_head
    { { 11873, 'NQ' }, { 10489, 'HQ' }, { 10240, 'cursed' }, { 10245, 'cursed -1' }, { 3560, 'abjuration' } }, -- abjuration: hrafn_haubert / huginn_haubert / hexed_haubert / hexed_haubert_-1 / corvine_abjuration_body
    { { 10534, 'NQ' }, { 10539, 'HQ' }, { 10303, 'cursed' }, { 10308, 'cursed -1' }, { 3561, 'abjuration' } }, -- abjuration: hrafn_gauntlets / huginn_gauntlets / hexed_gauntlets / hexed_gauntlets_-1 / corvine_abjuration_hands
    { { 10565, 'NQ' }, { 10570, 'HQ' }, { 10583, 'cursed' }, { 10588, 'cursed -1' }, { 3562, 'abjuration' } }, -- abjuration: hrafn_hose / huginn_hose / hexed_hose / hexed_hose_-1 / corvine_abjuration_legs
    { { 10631, 'NQ' }, { 10636, 'HQ' }, { 10353, 'cursed' }, { 10358, 'cursed -1' }, { 3563, 'abjuration' } }, -- abjuration: hrafn_gambieras / huginn_gambieras / hexed_gambieras / hexed_gambieras_-1 / corvine_abjuration_feet
    { { 10403, 'NQ' }, { 10408, 'HQ' }, { 10422, 'cursed' }, { 10427, 'cursed -1' }, { 3574, 'abjuration' } }, -- abjuration: auspex_coif / spurrina_coif / hexed_coif / hexed_coif_-1 / foreboding_abjuration_head
    { { 11876, 'NQ' }, { 10492, 'HQ' }, { 10243, 'cursed' }, { 10248, 'cursed -1' }, { 3575, 'abjuration' } }, -- abjuration: auspex_doublet / spurrina_doublet / hexed_doublet / hexed_doublet_-1 / foreboding_abjuration_body
    { { 10537, 'NQ' }, { 10542, 'HQ' }, { 10306, 'cursed' }, { 10311, 'cursed -1' }, { 3576, 'abjuration' } }, -- abjuration: auspex_gages / spurrina_gages / hexed_gages / hexed_gages_-1 / foreboding_abjuration_hands
    { { 10568, 'NQ' }, { 10573, 'HQ' }, { 10586, 'cursed' }, { 10591, 'cursed -1' }, { 3577, 'abjuration' } }, -- abjuration: auspex_slops / spurrina_slops / hexed_slops / hexed_slops_-1 / foreboding_abjuration_legs
    { { 10634, 'NQ' }, { 10639, 'HQ' }, { 10356, 'cursed' }, { 10361, 'cursed -1' }, { 3578, 'abjuration' } }, -- abjuration: auspex_nails / spurrina_nails / hexed_nails / hexed_nails_-1 / foreboding_abjuration_feet
    { { 10404, 'NQ' }, { 10409, 'HQ' }, { 10423, 'cursed' }, { 10428, 'cursed -1' }, { 3579, 'abjuration' } }, -- abjuration: paean_mitra / iaso_mitra / hexed_mitra / hexed_mitra_-1 / lenitive_abjuration_head
    { { 11877, 'NQ' }, { 10493, 'HQ' }, { 10244, 'cursed' }, { 10249, 'cursed -1' }, { 3580, 'abjuration' } }, -- abjuration: paean_bliaut / iaso_bliaut / hexed_bliaut / hexed_bliaut_-1 / lenitive_abjuration_body
    { { 10538, 'NQ' }, { 10543, 'HQ' }, { 10307, 'cursed' }, { 10312, 'cursed -1' }, { 3581, 'abjuration' } }, -- abjuration: paean_cuffs / iaso_cuffs / hexed_cuffs / hexed_cuffs_-1 / lenitive_abjuration_hands
    { { 10569, 'NQ' }, { 10574, 'HQ' }, { 10587, 'cursed' }, { 10592, 'cursed -1' }, { 3582, 'abjuration' } }, -- abjuration: paean_tights / iaso_tights / hexed_tights / hexed_tights_-1 / lenitive_abjuration_legs
    { { 10635, 'NQ' }, { 10640, 'HQ' }, { 10357, 'cursed' }, { 10362, 'cursed -1' }, { 3583, 'abjuration' } }, -- abjuration: paean_boots / iaso_boots / hexed_boots / hexed_boots_-1 / lenitive_abjuration_feet
    { { 10401, 'NQ' }, { 10406, 'HQ' }, { 10420, 'cursed' }, { 10425, 'cursed -1' }, { 3564, 'abjuration' } }, -- abjuration: tenryu_somen / tenryu_somen_+1 / hexed_somen / hexed_somen_-1 / supernal_abjuration_head
    { { 11874, 'NQ' }, { 10490, 'HQ' }, { 10241, 'cursed' }, { 10246, 'cursed -1' }, { 3565, 'abjuration' } }, -- abjuration: tenryu_domaru / tenryu_domaru_+1 / hexed_domaru / hexed_domaru_-1 / supernal_abjuration_body
    { { 10535, 'NQ' }, { 10540, 'HQ' }, { 10304, 'cursed' }, { 10309, 'cursed -1' }, { 3566, 'abjuration' } }, -- abjuration: tenryu_tekko / tenryu_tekko_+1 / hexed_tekko / hexed_tekko_-1 / supernal_abjuration_hands
    { { 10566, 'NQ' }, { 10571, 'HQ' }, { 10584, 'cursed' }, { 10589, 'cursed -1' }, { 3567, 'abjuration' } }, -- abjuration: tenryu_hakama / tenryu_hakama_+1 / hexed_hakama / hexed_hakama_-1 / supernal_abjuration_legs
    { { 10632, 'NQ' }, { 10637, 'HQ' }, { 10354, 'cursed' }, { 10359, 'cursed -1' }, { 3568, 'abjuration' } }, -- abjuration: tenryu_sune-ate / tenryu_sune-ate_+1 / hexed_sune-ate / hexed_sune-ate_-1 / supernal_abjuration_feet
    { { 10402, 'NQ' }, { 10407, 'HQ' }, { 10421, 'cursed' }, { 10426, 'cursed -1' }, { 3569, 'abjuration' } }, -- abjuration: kheper_bonnet / khepri_bonnet / hexed_bonnet / hexed_bonnet_-1 / transitory_abjuration_head
    { { 11875, 'NQ' }, { 10491, 'HQ' }, { 10242, 'cursed' }, { 10247, 'cursed -1' }, { 3570, 'abjuration' } }, -- abjuration: kheper_jacket / khepri_jacket / hexed_jacket / hexed_jacket_-1 / transitory_abjuration_body
    { { 10536, 'NQ' }, { 10541, 'HQ' }, { 10305, 'cursed' }, { 10310, 'cursed -1' }, { 3571, 'abjuration' } }, -- abjuration: kheper_wristbands / khepri_wristbands / hexed_wristbands / hexed_wristbands_-1 / transitory_abjuration_hands
    { { 10567, 'NQ' }, { 10572, 'HQ' }, { 10585, 'cursed' }, { 10590, 'cursed -1' }, { 3572, 'abjuration' } }, -- abjuration: kheper_kecks / khepri_kecks / hexed_kecks / hexed_kecks_-1 / transitory_abjuration_legs
    { { 10633, 'NQ' }, { 10638, 'HQ' }, { 10355, 'cursed' }, { 10360, 'cursed -1' }, { 3573, 'abjuration' } }, -- abjuration: kheper_gamashes / khepri_gamashes / hexed_gamashes / hexed_gamashes_-1 / transitory_abjuration_feet
    { { 26676, 'NQ' }, { 26677, 'HQ' }, { 26688, 'cursed' }, { 26689, 'cursed -1' }, { 8787, 'abjuration' } }, -- abjuration: apogee_crown / apogee_crown_+1 / bewitched_crown / voodoo_crown / abyssal_abjuration_head
    { { 26852, 'NQ' }, { 26853, 'HQ' }, { 26864, 'cursed' }, { 26865, 'cursed -1' }, { 8788, 'abjuration' } }, -- abjuration: apogee_dalmatica / apogee_dalmatica_+1 / bewitched_dalmatica / voodoo_dalmatica / abyssal_abjuration_body
    { { 27028, 'NQ' }, { 27029, 'HQ' }, { 27040, 'cursed' }, { 27041, 'cursed -1' }, { 8789, 'abjuration' } }, -- abjuration: apogee_mitts / apogee_mitts_+1 / bewitched_mitts / voodoo_mitts / abyssal_abjuration_hands
    { { 27204, 'NQ' }, { 27205, 'HQ' }, { 27216, 'cursed' }, { 27217, 'cursed -1' }, { 8790, 'abjuration' } }, -- abjuration: apogee_slacks / apogee_slacks_+1 / bewitched_slacks / voodoo_slacks / abyssal_abjuration_legs
    { { 27380, 'NQ' }, { 27381, 'HQ' }, { 27392, 'cursed' }, { 27393, 'cursed -1' }, { 8791, 'abjuration' } }, -- abjuration: apogee_pumps / apogee_pumps_+1 / bewitched_pumps / voodoo_pumps / abyssal_abjuration_feet
    { { 25611, 'NQ' }, { 25612, 'HQ' }, { 25621, 'cursed' }, { 25622, 'cursed -1' }, { 9110, 'abjuration' } }, -- abjuration: ryuo_somen / ryuo_somen_+1 / vexed_somen / jinxed_somen / arean_abjuration_head
    { { 25684, 'NQ' }, { 25685, 'HQ' }, { 25694, 'cursed' }, { 25695, 'cursed -1' }, { 9111, 'abjuration' } }, -- abjuration: ryuo_domaru / ryuo_domaru_+1 / vexed_domaru / jinxed_domaru / arean_abjuration_body
    { { 27115, 'NQ' }, { 27116, 'HQ' }, { 27125, 'cursed' }, { 27126, 'cursed -1' }, { 9112, 'abjuration' } }, -- abjuration: ryuo_tekko / ryuo_tekko_+1 / vexed_tekko / jinxed_tekko / arean_abjuration_hands
    { { 27300, 'NQ' }, { 27301, 'HQ' }, { 27310, 'cursed' }, { 27311, 'cursed -1' }, { 9113, 'abjuration' } }, -- abjuration: ryuo_hakama / ryuo_hakama_+1 / vexed_hakama / jinxed_hakama / arean_abjuration_legs
    { { 27471, 'NQ' }, { 27472, 'HQ' }, { 27481, 'cursed' }, { 27482, 'cursed -1' }, { 9114, 'abjuration' } }, -- abjuration: ryuo_sune-ate / ryuo_sune-ate_+1 / vexed_sune-ate / jinxed_sune-ate / arean_abjuration_feet
    { { 26670, 'NQ' }, { 26671, 'HQ' }, { 26682, 'cursed' }, { 26683, 'cursed -1' }, { 8762, 'abjuration' } }, -- abjuration: souveran_schaller / souveran_schaller_+1 / bewitched_schaller / voodoo_schaller / bushin_abjuration_head
    { { 26846, 'NQ' }, { 26847, 'HQ' }, { 26858, 'cursed' }, { 26859, 'cursed -1' }, { 8763, 'abjuration' } }, -- abjuration: souveran_cuirass / souveran_cuirass_+1 / bewitched_cuirass / voodoo_cuirass / bushin_abjuration_body
    { { 27022, 'NQ' }, { 27023, 'HQ' }, { 27034, 'cursed' }, { 27035, 'cursed -1' }, { 8764, 'abjuration' } }, -- abjuration: souveran_handschuhs / souveran_handschuhs_+1 / bewitched_handschuhs / voodoo_handschuhs / bushin_abjuration_hands
    { { 27198, 'NQ' }, { 27199, 'HQ' }, { 27210, 'cursed' }, { 27211, 'cursed -1' }, { 8765, 'abjuration' } }, -- abjuration: souveran_diechlings / souveran_diechlings_+1 / bewitched_diechlings / voodoo_diechlings / bushin_abjuration_legs
    { { 27374, 'NQ' }, { 27375, 'HQ' }, { 27386, 'cursed' }, { 27387, 'cursed -1' }, { 8766, 'abjuration' } }, -- abjuration: souveran_schuhs / souveran_schuhs_+1 / bewitched_schuhs / voodoo_schuhs / bushin_abjuration_feet
    { { 25609, 'NQ' }, { 25610, 'HQ' }, { 25619, 'cursed' }, { 25620, 'cursed -1' }, { 9105, 'abjuration' } }, -- abjuration: emicho_coronet / emicho_coronet_+1 / vexed_coronet / jinxed_coronet / cronian_abjuration_head
    { { 25682, 'NQ' }, { 25683, 'HQ' }, { 25692, 'cursed' }, { 25693, 'cursed -1' }, { 9106, 'abjuration' } }, -- abjuration: emicho_haubert / emicho_haubert_+1 / vexed_haubert / jinxed_haubert / cronian_abjuration_body
    { { 27113, 'NQ' }, { 27114, 'HQ' }, { 27123, 'cursed' }, { 27124, 'cursed -1' }, { 9107, 'abjuration' } }, -- abjuration: emicho_gauntlets / emicho_gauntlets_+1 / vexed_gauntlets / jinxed_gauntlets / cronian_abjuration_hands
    { { 27298, 'NQ' }, { 27299, 'HQ' }, { 27308, 'cursed' }, { 27309, 'cursed -1' }, { 9108, 'abjuration' } }, -- abjuration: emicho_hose / emicho_hose_+1 / vexed_hose / jinxed_hose / cronian_abjuration_legs
    { { 27469, 'NQ' }, { 27470, 'HQ' }, { 27479, 'cursed' }, { 27480, 'cursed -1' }, { 9109, 'abjuration' } }, -- abjuration: emicho_gambieras / emicho_gambieras_+1 / vexed_gambieras / jinxed_gambieras / cronian_abjuration_feet
    { { 25617, 'NQ' }, { 25618, 'HQ' }, { 25627, 'cursed' }, { 25628, 'cursed -1' }, { 9125, 'abjuration' } }, -- abjuration: kaykaus_mitra / kaykaus_mitra_+1 / vexed_mitra / jinxed_mitra / cyllenian_abjuration_head
    { { 25690, 'NQ' }, { 25691, 'HQ' }, { 25700, 'cursed' }, { 25701, 'cursed -1' }, { 9126, 'abjuration' } }, -- abjuration: kaykaus_bliaut / kaykaus_bliaut_+1 / vexed_bliaut / jinxed_bliaut / cyllenian_abjuration_body
    { { 27121, 'NQ' }, { 27122, 'HQ' }, { 27131, 'cursed' }, { 27132, 'cursed -1' }, { 9127, 'abjuration' } }, -- abjuration: kaykaus_cuffs / kaykaus_cuffs_+1 / vexed_cuffs / jinxed_cuffs / cyllenian_abjuration_hands
    { { 27306, 'NQ' }, { 27307, 'HQ' }, { 27316, 'cursed' }, { 27317, 'cursed -1' }, { 9128, 'abjuration' } }, -- abjuration: kaykaus_tights / kaykaus_tights_+1 / vexed_tights / jinxed_tights / cyllenian_abjuration_legs
    { { 27477, 'NQ' }, { 27478, 'HQ' }, { 27487, 'cursed' }, { 27488, 'cursed -1' }, { 9129, 'abjuration' } }, -- abjuration: kaykaus_boots / kaykaus_boots_+1 / vexed_boots / jinxed_boots / cyllenian_abjuration_feet
    { { 26674, 'NQ' }, { 26675, 'HQ' }, { 26686, 'cursed' }, { 26687, 'cursed -1' }, { 8772, 'abjuration' } }, -- abjuration: rao_kabuto / rao_kabuto_+1 / bewitched_kabuto / voodoo_kabuto / grove_abjuration_head
    { { 26850, 'NQ' }, { 26851, 'HQ' }, { 26862, 'cursed' }, { 26863, 'cursed -1' }, { 8773, 'abjuration' } }, -- abjuration: rao_togi / rao_togi_+1 / bewitched_togi / voodoo_togi / grove_abjuration_body
    { { 27026, 'NQ' }, { 27027, 'HQ' }, { 27038, 'cursed' }, { 27039, 'cursed -1' }, { 8774, 'abjuration' } }, -- abjuration: rao_kote / rao_kote_+1 / bewitched_kote / voodoo_kote / grove_abjuration_hands
    { { 27202, 'NQ' }, { 27203, 'HQ' }, { 27214, 'cursed' }, { 27215, 'cursed -1' }, { 8775, 'abjuration' } }, -- abjuration: rao_haidate / rao_haidate_+1 / bewitched_haidate / voodoo_haidate / grove_abjuration_legs
    { { 27378, 'NQ' }, { 27379, 'HQ' }, { 27390, 'cursed' }, { 27391, 'cursed -1' }, { 8776, 'abjuration' } }, -- abjuration: rao_sune-ate / rao_sune-ate_+1 / bewitched_sune-ate / voodoo_sune-ate / grove_abjuration_feet
    { { 25613, 'NQ' }, { 25614, 'HQ' }, { 25623, 'cursed' }, { 25624, 'cursed -1' }, { 9115, 'abjuration' } }, -- abjuration: adhemar_bonnet / adhemar_bonnet_+1 / vexed_bonnet / jinxed_bonnet / jovian_abjuration_head
    { { 25686, 'NQ' }, { 25687, 'HQ' }, { 25696, 'cursed' }, { 25697, 'cursed -1' }, { 9116, 'abjuration' } }, -- abjuration: adhemar_jacket / adhemar_jacket_+1 / vexed_jacket / jinxed_jacket / jovian_abjuration_body
    { { 27117, 'NQ' }, { 27118, 'HQ' }, { 27127, 'cursed' }, { 27128, 'cursed -1' }, { 9117, 'abjuration' } }, -- abjuration: adhemar_wristbands / adhemar_wristbands_+1 / vexed_wristbands / jinxed_wristbands / jovian_abjuration_hands
    { { 27302, 'NQ' }, { 27303, 'HQ' }, { 27312, 'cursed' }, { 27313, 'cursed -1' }, { 9118, 'abjuration' } }, -- abjuration: adhemar_kecks / adhemar_kecks_+1 / vexed_kecks / jinxed_kecks / jovian_abjuration_legs
    { { 27473, 'NQ' }, { 27474, 'HQ' }, { 27483, 'cursed' }, { 27484, 'cursed -1' }, { 9119, 'abjuration' } }, -- abjuration: adhemar_gamashes / adhemar_gamashes_+1 / vexed_gamashes / jinxed_gamashes / jovian_abjuration_feet
    { { 26678, 'NQ' }, { 26679, 'HQ' }, { 26690, 'cursed' }, { 26691, 'cursed -1' }, { 8782, 'abjuration' } }, -- abjuration: carmine_mask / carmine_mask_+1 / bewitched_mask / voodoo_mask / shinryu_abjuration_head
    { { 26854, 'NQ' }, { 26855, 'HQ' }, { 26866, 'cursed' }, { 26867, 'cursed -1' }, { 8783, 'abjuration' } }, -- abjuration: carmine_scale_mail / carmine_scale_mail_+1 / bewitched_mail / voodoo_mail / shinryu_abjuration_body
    { { 27030, 'NQ' }, { 27031, 'HQ' }, { 27042, 'cursed' }, { 27043, 'cursed -1' }, { 8784, 'abjuration' } }, -- abjuration: carmine_finger_gauntlets / carmine_finger_gauntlets_+1 / bewitched_finger_gauntlets / voodoo_finger_gauntlets / shinryu_abjuration_hands
    { { 27206, 'NQ' }, { 27207, 'HQ' }, { 27218, 'cursed' }, { 27219, 'cursed -1' }, { 8785, 'abjuration' } }, -- abjuration: carmine_cuisses / carmine_cuisses_+1 / bewitched_cuisses / voodoo_cuisses / shinryu_abjuration_legs
    { { 27382, 'NQ' }, { 27383, 'HQ' }, { 27394, 'cursed' }, { 27395, 'cursed -1' }, { 8786, 'abjuration' } }, -- abjuration: carmine_greaves / carmine_greaves_+1 / bewitched_greaves / voodoo_greaves / shinryu_abjuration_feet
    { { 26668, 'NQ' }, { 26669, 'HQ' }, { 26680, 'cursed' }, { 26681, 'cursed -1' }, { 8777, 'abjuration' } }, -- abjuration: lustratio_cap / lustratio_cap_+1 / bewitched_cap / voodoo_cap / triton_abjuration_head
    { { 26844, 'NQ' }, { 26845, 'HQ' }, { 26856, 'cursed' }, { 26857, 'cursed -1' }, { 8778, 'abjuration' } }, -- abjuration: lustratio_harness / lustratio_harness_+1 / bewitched_harness / voodoo_harness / triton_abjuration_body
    { { 27020, 'NQ' }, { 27021, 'HQ' }, { 27032, 'cursed' }, { 27033, 'cursed -1' }, { 8779, 'abjuration' } }, -- abjuration: lustratio_mittens / lustratio_mittens_+1 / bewitched_gloves / voodoo_gloves / triton_abjuration_hands
    { { 27196, 'NQ' }, { 27197, 'HQ' }, { 27208, 'cursed' }, { 27209, 'cursed -1' }, { 8780, 'abjuration' } }, -- abjuration: lustratio_subligar / lustratio_subligar_+1 / bewitched_subligar / voodoo_subligar / triton_abjuration_legs
    { { 27372, 'NQ' }, { 27373, 'HQ' }, { 27384, 'cursed' }, { 27385, 'cursed -1' }, { 8781, 'abjuration' } }, -- abjuration: lustratio_leggings / lustratio_leggings_+1 / bewitched_leggings / voodoo_leggings / triton_abjuration_feet
    { { 26672, 'NQ' }, { 26673, 'HQ' }, { 26684, 'cursed' }, { 26685, 'cursed -1' }, { 8767, 'abjuration' } }, -- abjuration: argosy_celata / argosy_celata_+1 / bewitched_celata / voodoo_celata / vale_abjuration_head
    { { 26848, 'NQ' }, { 26849, 'HQ' }, { 26860, 'cursed' }, { 26861, 'cursed -1' }, { 8768, 'abjuration' } }, -- abjuration: argosy_hauberk / argosy_hauberk_+1 / bewitched_hauberk / voodoo_hauberk / vale_abjuration_body
    { { 27024, 'NQ' }, { 27025, 'HQ' }, { 27036, 'cursed' }, { 27037, 'cursed -1' }, { 8769, 'abjuration' } }, -- abjuration: argosy_mufflers / argosy_mufflers_+1 / bewitched_mufflers / voodoo_mufflers / vale_abjuration_hands
    { { 27200, 'NQ' }, { 27201, 'HQ' }, { 27212, 'cursed' }, { 27213, 'cursed -1' }, { 8770, 'abjuration' } }, -- abjuration: argosy_breeches / argosy_breeches_+1 / bewitched_breeches / voodoo_breeches / vale_abjuration_legs
    { { 27376, 'NQ' }, { 27377, 'HQ' }, { 27388, 'cursed' }, { 27389, 'cursed -1' }, { 8771, 'abjuration' } }, -- abjuration: argosy_sollerets / argosy_sollerets_+1 / bewitched_sollerets / voodoo_sollerets / vale_abjuration_feet
    { { 25615, 'NQ' }, { 25616, 'HQ' }, { 25625, 'cursed' }, { 25626, 'cursed -1' }, { 9120, 'abjuration' } }, -- abjuration: amalric_coif / amalric_coif_+1 / vexed_coif / jinxed_coif / venerian_abjuration_head
    { { 25688, 'NQ' }, { 25689, 'HQ' }, { 25698, 'cursed' }, { 25699, 'cursed -1' }, { 9121, 'abjuration' } }, -- abjuration: amalric_doublet / amalric_doublet_+1 / vexed_doublet / jinxed_doublet / venerian_abjuration_body
    { { 27119, 'NQ' }, { 27120, 'HQ' }, { 27129, 'cursed' }, { 27130, 'cursed -1' }, { 9122, 'abjuration' } }, -- abjuration: amalric_gages / amalric_gages_+1 / vexed_gages / jinxed_gages / venerian_abjuration_hands
    { { 27304, 'NQ' }, { 27305, 'HQ' }, { 27314, 'cursed' }, { 27315, 'cursed -1' }, { 9123, 'abjuration' } }, -- abjuration: amalric_slops / amalric_slops_+1 / vexed_slops / jinxed_slops / venerian_abjuration_legs
    { { 27475, 'NQ' }, { 27476, 'HQ' }, { 27485, 'cursed' }, { 27486, 'cursed -1' }, { 9124, 'abjuration' } }, -- abjuration: amalric_nails / amalric_nails_+1 / vexed_nails / jinxed_nails / venerian_abjuration_feet
    { { 13014, 'NQ' }, { 15351, 'HQ' } }, -- drop: leaping_boots / bounding_boots
    { { 12486, 'NQ' }, { 15224, 'HQ' } }, -- drop: emperor_hairpin / empress_hairpin
};

-- item id -> list of group indexes
M.by_id = { };
for gi, g in ipairs(M.groups) do
    for _, e in ipairs(g) do
        local t = M.by_id[e[1]];
        if (t == nil) then t = { }; M.by_id[e[1]] = t; end
        table.insert(t, gi);
    end
end

-- Every other item related to id, as { id = n, role = s }, de-duplicated.
M.related = function (id)
    local out = { };
    local gis = M.by_id[id];
    if (gis == nil) then return out; end
    local seen = { [id] = true };
    for _, gi in ipairs(gis) do
        for _, e in ipairs(M.groups[gi]) do
            if (not seen[e[1]]) then
                seen[e[1]] = true;
                table.insert(out, { id = e[1], role = e[2] });
            end
        end
    end
    return out;
end

-- Role of id within its first group, or nil.
M.role_of = function (id)
    local gis = M.by_id[id];
    if (gis == nil) then return nil; end
    for _, e in ipairs(M.groups[gis[1]]) do
        if (e[1] == id) then return e[2]; end
    end
    return nil;
end

return M;
