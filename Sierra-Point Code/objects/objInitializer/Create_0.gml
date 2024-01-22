/// @description CREATE YOUR GLOBALS AND ENUMS HERE

///LOAD SOUND ALWAYS ON
audio_group_load(AlwaysOn);

#region INI FILE
ini_open("CONFIG.INI");

var value = ini_read_real("prefs", "sound", 100);
audio_group_set_gain(AlwaysOn, value/100, 1);

value = ini_read_real("prefs", "music", 100);
musicVolume = value/100;
audio_group_set_gain(audiogroup_default, value/100, 1);
var inst = instance_create(-1000, -1000, objMusicBox);
inst.musicVolume = musicVolume;

ini_close();
#endregion

#region CREATE ESSENTIAL OBJECTS

instance_create(-1000, -1000, objMouseGui);
instance_create(-1000, -1000, objParticleEngine);
instance_create(-1000, -1000, objGamepadDetector);
instance_create(-1000, -1000, oSaveLoad);
instance_create(-1000, -1000, oCamera);
instance_create(-1000, -1000, oChat);
instance_create(-1000, -1000, oNetwork);
instance_create(-1000, -1000, oFaction);
instance_create(-1000, -1000, oPathfinder);
instance_create(-1000, -1000, oBuildingTool);
instance_create(-1000, -1000, oMap);

#endregion

#region RUN ESSENTIAL SCRIPTS

lang_initialize();
rebind_keys_initialize();

global.language_font = fntStandard;

#endregion

#region Pathfinding Grid

// Create the Grid
#macro grid_cell_width 8
#macro grid_cell_height 8

var hcells = room_width div grid_cell_width;
var vcells = room_height div grid_cell_width;

global.grid = mp_grid_create(0, 0, hcells, vcells, grid_cell_width, grid_cell_width);

#endregion

#region Unit data structures

// Hold all units controlled by the player
global.unitList = ds_list_create();

// Holds a list for all other players and links it to the their ID
global.multiInstMap = ds_map_create();

// Create a grid to store held instances
/*
Height:
0		- instances currently selected
1-11	- instances stored in a number
*/

var _height = 12; // -1
global.instGrid	= ds_grid_create(0, _height);

#endregion

// Debug menu
global.debug = false;

// For when mouse is over UI or world
global.mouse_on_ui = false;

///GO TO MAIN ROOM
room_goto(roomMenuMain);