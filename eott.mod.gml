#define init
trace("Aw yiss")
trace("I'm into it, man")
with (Player) {
	is_swapped = false
	global.last_wep = wep
	global.last_bwep = bwep
}
global.curr_area = 10
global.curr_subarea = 0
global.curr_world = get_world(global.curr_area) 
global.player_muts = 0
Player.last_wep = Player.wep
Player.last_bwep = Player.bwep

// List of every mean motherfucker in this game
// Desert
global.DesertBaddies[0] = RadMaggot
global.DesertBaddies[1] = GoldScorpion
global.DesertBaddies[2] = MaggotSpawn
global.DesertBaddies[3] = BigMaggot
global.DesertBaddies[4] = Maggot
global.DesertBaddies[5] = Scorpion
global.DesertBaddies[6] = Bandit

// Sewers
global.SewerBaddies[0] = SuperFrog
global.SewerBaddies[1] = Gator
global.SewerBaddies[2] = BuffGator
global.SewerBaddies[3] = Ratking
global.SewerBaddies[4] = Rat
global.SewerBaddies[5] = FastRat
global.SewerBaddies[6] = MeleeBandit
global.SewerBaddies[7] = Turtle

// Scrapyard
global.ScrapyardBaddies[0] = Sniper
global.ScrapyardBaddies[1] = Raven
global.ScrapyardBaddies[2] = Salamander


// Crystal caves
global.CrystalCavesBaddies[0] = Spider
global.CrystalCavesBaddies[1] = LaserCrystal
global.CrystalCavesBaddies[2] = LightningCrystal

/*
// Frozen city
        SnowTank
        GoldSnowTank
        SnowBot
        CarThrow
        Wolf
// Labs
        RhinoFreak
        Freak
        Turret
        ExploFreak
        Necromancer
// Palace
        ExploGuardian
        DogGuardian
        GhostGuardian
        Guardian
// Mansion
        Molefish
        FireBaller
        SuperFireBaller
        Jock
        Molesarge
// IDPD
        Van
        PopoFreak
        Grunt
        EliteGrunt
        Shielder
        EliteShielder
        Inspector
        EliteInspector
// Oasis
        Crab
        BoneFish
// Jungle
        JungleAssassin
        JungleFly
        JungleBandit
// Other
        EnemyHorror
        crystaltype
        hitme
        PotentialYeti
        Corpse
        ScrapBossCorpse
        Nothing2Corpse
        InvLaserCrystal
        InvSpider
        CrownGuardianOld
        CrownGuardian
        OldGuardianStatue
        GuardianStatue
        GuardianDeflect
        Mimic
        SuperMimic
*/

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

// Check for enemy deaths
for (i=0; i<array_length_1d(global.DesertBaddies); i++) {
	with(global.DesertBaddies[i]){
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

#define get_world(area)
switch(area) {
	case 1: return 
}
	
