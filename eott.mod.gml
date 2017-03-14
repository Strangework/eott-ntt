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
Player.last_wep = Player.wep
Player.last_bwep = Player.bwep
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
/*
with(global) if ("curr_area" not in self) {
	curr_area = 0
}
*/
/*
if ("subarea" not in global) {
	global.curr_subarea = GameCont.subarea
}
*/
if GameCont.area != global.curr_area or GameCont.subarea != global.curr_subarea {
	trace("Here we go again!")
	log_write("area:" + string(GameCont.area) + " subarea:" + string(GameCont.subarea))
	global.curr_area = GameCont.area
	global.curr_subarea = GameCont.subarea
	log_save()
}

with (Player) if (button_pressed(index, "swap")) {
	//Player.is_swapped = !Player.is_swapped
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
