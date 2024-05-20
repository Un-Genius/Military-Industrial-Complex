// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function func_start_game(){
	
	// Reset game values
	global.gender = "Elder";
	ds_list_clear(global.character_list);
	
	// Go to game room
	func_room_goto(roomGame_Corridor);
}