#define init
// List of every mean motherfucker in this game

// Miscellaneous (aren't specific to an area)
global.MiscBaddies[0] = Bandit
global.MiscBaddies[1] = Gator
global.MiscBaddies[2] = EnemyHorror
global.MiscBaddies[3] = CrownGuardian
global.MiscBaddies[4] = Mimic
global.MiscBaddies[5] = SuperMimic
global.SewerBaddies[6] = MeleeBandit

// Desert
global.DesertBaddies[0] = RadMaggot
global.DesertBaddies[1] = GoldScorpion
global.DesertBaddies[2] = MaggotSpawn
global.DesertBaddies[3] = BigMaggot
global.DesertBaddies[4] = Maggot
global.DesertBaddies[5] = Scorpion

// Sewers
global.SewerBaddies[0] = SuperFrog
global.SewerBaddies[1] = BuffGator
global.SewerBaddies[2] = Ratking
global.SewerBaddies[3] = Rat
global.SewerBaddies[4] = FastRat
global.SewerBaddies[5] = Turtle

// Scrapyard
global.ScrapyardBaddies[0] = Sniper
global.ScrapyardBaddies[1] = Raven
global.ScrapyardBaddies[2] = Salamander

// Crystal caves
global.CrystalCavesBaddies[0] = Spider
global.CrystalCavesBaddies[1] = LaserCrystal
global.CrystalCavesBaddies[2] = LightningCrystal

// Frozen city
global.FrozenCityBaddies[0] = SnowTank
global.FrozenCityBaddies[1] = GoldSnowTank
global.FrozenCityBaddies[2] = SnowBot
global.FrozenCityBaddies[3] = Wolf

// Labs
global.LabsBaddies[0] = RhinoFreak
global.LabsBaddies[1] = Freak
global.LabsBaddies[2] = Turret
global.LabsBaddies[3] = ExploFreak
global.LabsBaddies[4] = Necromancer

// Palace
global.PalaceBaddies[0] = ExploGuardian
global.PalaceBaddies[1] = DogGuardian
global.PalaceBaddies[2] = GhostGuardian
global.PalaceBaddies[3] = Guardian

// Mansion
global.MansionBaddies[0] = Molefish
global.MansionBaddies[1] = FireBaller
global.MansionBaddies[2] = SuperFireBaller
global.MansionBaddies[3] = Jock
global.MansionBaddies[4] = Molesarge

// IDPD
global.PopoBaddies[0] = Van
global.PopoBaddies[1] = PopoFreak
global.PopoBaddies[2] = Grunt
global.PopoBaddies[3] = EliteGrunt
global.PopoBaddies[4] = Shielder
global.PopoBaddies[5] = EliteShielder
global.PopoBaddies[6] = Inspector
global.PopoBaddies[7] = EliteInspector

// Oasis
global.OasisBaddies[0] = Crab
global.OasisBaddies[1] = BoneFish

// Jungle
global.JungleBaddies[0] = JungleAssassin
global.JungleBaddies[1] = JungleFly
global.JungleBaddies[2] = JungleBandit


trace("Aw yiss")
with (Player) {
	is_swapped = false
	global.last_wep = wep
	global.last_bwep = bwep
}
global.curr_area = 10
global.curr_subarea = 0
global.baddies = []
global.player_muts = 0
global.player_initialized = false // Player initialization is not possible until the player entity is (re)created. Initialization occurs within a conditional block in step()

log_init()


#define log_init
global.log = ""
global.log_line = 0
global.log_file = "nt_monitor.log"
global.log_ready = false
wait file_load(global.log_file)
global.log_ready = true


#define log_write(line)
global.log = global.log + line + "#"

#define log_save
if (global.log_ready) {
	string_save(global.log, global.log_file)
	trace("Wrote log to file!")
}


#define step

// Perform any one-time player initializations
if (!global.player_initialized and instance_exists(Player)) {
	Player.last_wep = Player.wep
	Player.last_bwep = Player.bwep
	global.player_initialized = true
}

// Check for enemy deaths
for (i=0; i<array_length_1d(global.baddies); i++) {
	with(global.baddies[i]){
		if (my_health <= -20) {
			trace("O FUQ!")
		} else if (my_health <= 0) {
			trace("bleh!")
		}
	}
}

// End of level logic
if GameCont.area != global.curr_area or GameCont.subarea != global.curr_subarea {
	trace("Here we go again!")
	
	// Log level change
	log_write("area:" + string(GameCont.area) + " subarea:" + string(GameCont.subarea))
	global.curr_area = GameCont.area
	global.curr_subarea = GameCont.subarea

	// Update enemy list
	global.baddies = get_baddie_list(global.curr_area)

	// Check for new mutations
	new_muts = global.player_muts
	for (i = 0; i < 29; i++) {
		if (skill_get(i+1)) {
			new_muts = new_muts | 1 << i
		}
	}

	// If there are new mutations, log the change
	if (global.player_muts != new_muts) {
		global.player_muts = new_muts
		log_write("muts:"+string(global.player_muts))
	}

	// Flush log
	log_save()
}



with (Player) if (button_pressed(index, "swap")) {
	//trace("Wapah!")
}

with (Player) if (button_pressed(index, "pick")) {
	wait 1
	// If any of the weapons have changed, record a weapon switch
	if not ((wep == last_wep and bwep == last_bwep) or (wep == last_bwep and bwep == last_wep)) {
		log_write("wep:" + string(wep) + " bwep: " + string(bwep) + " curse:" + string(curse) + " bcurse:" + string(bcurse))
		//trace(global.log)
		trace("wep:" + string(wep) + " bwep: " + string(bwep))
		last_wep = wep
		last_bwep = bwep
	}
}

#define get_wep
if Player.is_swapped 	{
	return Player.bwep
} else {
	return Player.wep
}

#define get_bwep
if Player.is_swapped {
	return Player.wep
} else {
	return Player.bwep
}

#define get_baddie_list(area)
// TODO : Add looping logic
switch (area) {
	case 1:
		return concatenate_1d_arrays(global.DesertBaddies, global.MiscBaddies)
		break
	case 2:
		return concatenate_1d_arrays(global.SewerBaddies, global.MiscBaddies)
		break
	case 3:
		return concatenate_1d_arrays(global.ScrapyardBaddies, global.MiscBaddies)
		break
	case 4:
		return concatenate_1d_arrays(global.CrystalCavesBaddies, global.MiscBaddies)
		break
	case 5:
		return concatenate_1d_arrays(global.FrozenCityBaddies, global.MiscBaddies)
		break
	case 6:
		return concatenate_1d_arrays(global.LabsBaddies, global.MiscBaddies)
		break
	case 7:
		return concatenate_1d_arrays(global.PalaceBaddies, global.MiscBaddies)
		break
} 

#define concatenate_1d_arrays(x, y)
z = x
for (i=0; i < array_length_1d(y); i++) {
	z[i+array_length_1d(x)+1] = y[i]
}
return z
