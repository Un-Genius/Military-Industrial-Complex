#region Multiplayer Packets enum

// formats specified when sent by client \ when sent by server
enum packet_t
{
    none = 0,
    // client: ()
    // server: ()
    // Bounces to keep the P2P connection active.
    ping,
    // client: (game_name:string, game_version:u32)
    // server: (client_id:int64)
    auth,
    // client: (message:string)
    // server: (message:string)
    chat,
    // server: (error_text:string)
    error,
    // client: ()
    // server: (client_id:int64)
    leaving,
	// server: ()
    data_map,
    // client: (string, data (s16))
	// server: (client_id:int64, string, boolean (s16))
	start,
	// server: ()
	add_unit,
	// client: (unit_type, x, y)
	// server: (client_id:int64, unit_type, x, y)
	add_attached_unit,
	// client: (unit_type, x, y, pos)
	// server: (client_id:int64, unit_type, x, y, pos)
	destroy_unit,
	// client: (user, pos)
	// server: (client_id:int64, pos)
	move_unit,
	// client: (user, pos, x, y, goal_x, goal_y)
	// server: (client_id:int64, pos, x, y, goal_x, goal_y)
	veh_interact,
	// client: (pos, interaction)
	// server: (client_id:int64, pos, interaction)
	update_unit,
	// client: (pos, state)
	// server: (client_id:int64, pos, state)
	shoot_bullet,
	// client: (x, y, angle, type, team)
	// server: (x, y, angle, type, team)
	lobby_connected,
	// client: ()
	// server: ()
	data_update_request,
	// sender: ()
	data_update_packet,
	// sender: (ready, numColor, team, game_mode)
}

#endregion

#region Multiplayer color enum

enum color
{
	white,
	red,
	orange,
	yellow,
	green,
	ltBlue,
	blue,
	purple,
	pink
}

#endregion

#region Menu enum

enum menu
{
	home,
	inGame,
	public,
	joinPage,
	hostPage,
	loadingPage,
	optionsPage,
	controlsPage,
	graphicsPage,
	soundsPage
}

#endregion

#region State enum

enum action
{
	idle,
	moving,
	attacking,
	aiming,
	reloading,
	enter,
	leave
}

#endregion

#region Gun type enum

enum gunType
{
	lightCan,
	mediumCan,
	heavyCan,
	rifle,
	lightMG,
	mediumMG,
	heavyMG,
	ATGM
}

#endregion

#region Unit type enum

enum unitType
{
	building,
	inf,
	gnd,
	air
}

#endregion

#region List enum

enum PR
{
	NAME,
	SELECTED,
	VALUES
}

#endregion

#region Zone type enum

enum objectType
{
	oPlayer,
	oZoneHQ,
	oZoneCamp,
	oZoneBootCamp,
	oInfantry,
	oZoneMoney,
	oZoneSupplies,
	oDummy,
	oDummyStronk,
	oTransport,
	oHAB,
}

#endregion

#region Manage Menu & Settings

// Create list for buttons
inst_list = ds_list_create();
ds_list_clear(inst_list);

// Create list for public lobby buttons
instPublic_list = ds_list_create();
ds_list_clear(instPublic_list);

// Create map for saved options
global.savedSettings = ds_grid_create(16, 0);

#region Add settings

#region Reference enum

enum setting
{
	host_type,
	break_slot,
	map,
	spawn_points,
	color,
	controls,
	graphics,
	gui_size,
	fullscreen,
	main_volume,
	music_volume,
	special_sound_effects,
	player_count,
	game_mode,
	team_number
}

#endregion

// Host
add_setting("Host type",	2, "Private", "Friends only", "Public");
add_setting("--------------------------------------", 0, "", "", "", "", "", "", "", "", "", "", "Technically an easter egg. Contratz");
add_setting("Map",			0, "Default");
add_setting("Spawn Points",	3, 5, 10, 15, 20, 30);
add_setting("Color",		0, "No color", "Red", "Orange", "Yellow", "Green", "Light Blue", "Blue", "Purple", "Pink");

// Controls
add_setting("No you cant play using a steering wheel", 0, "okay :(", "pls?", "Fine ill use my joystick.");

// Graphics
add_setting("Graphics",		0, "Potatoe", "Potat+", "Potet Master Race");
add_setting("GUI Size",		1, "Small", "Medium", "Large");
add_setting("Fullscreen",	0, "False", "True");

// Audio
add_setting("Main Volume",	10, "Off", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%");
add_setting("Music Volume",	10, "Off", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%");
add_setting("Special sound effects", 0, "OOF?", "OOF.");

// more stuff
add_setting("Players",		0, 2, 4, 6, 8);

// Teams
add_setting("Game Mode",	0, "Free For All", "Team Match");
add_setting("Team",			0, 1, 2, 3, 4, 5, 6, 7, 8);

#endregion

// Set current state
state = menu.home;
prevState = state;

// Hold in game menu on/off
menuOpen = false;

#endregion

#region Update settings with saved

// Update settings
var _fileName = "options.sav";

if(file_exists(_fileName))
{
	var _wrapper = loadStringFromFile(_fileName);
	var _list = _wrapper[? "ROOTS"];

	for(var i = 0; i < ds_list_size(_list); i++)
	{
		var _map = _list[| i];

		// Get data
		var _savedOptions = _map[? "savedOptions"];

		// Get size
		var _size = ds_list_size(_savedOptions);

		// Merge lists into a grid
		for(var i = 0; i < _size; i++)
		{
			var _value = ds_list_find_value(_savedOptions, i);

			// Store it in list
			ds_grid_set(global.savedSettings, 1, i, _value)
		}
	}

	ds_map_destroy(_wrapper);
}

#endregion

#region Camera

// Resolution
global.RES_W = display_get_width();
global.RES_H = display_get_height();

#macro view view_camera[0]

// Set full screen
var _fullscreen = ds_grid_get(global.savedSettings, 1, setting.fullscreen);

window_set_fullscreen(_fullscreen);

if !_fullscreen
{
	// Resolution
	global.RES_W = 1920;
	global.RES_H = 1080;
}

// Find aspect_ration
aspect_ratio = global.RES_W / global.RES_H;

// Modify width resolution to fit aspect_ratio
global.RES_W = round(global.RES_H * aspect_ratio);

// Check for odd numbers
if(global.RES_W & 1)
	global.RES_W++;

// Resize window
window_set_size(global.RES_W, global.RES_H);

// Delay recenter
alarm[2] = 1;

surface_resize(application_surface, global.RES_W, global.RES_H);
display_set_gui_size(global.RES_W, global.RES_H);

room_goto(rm_menu);

#endregion

#region Chat settings

global.chat = ds_list_create();
global.chat_color = ds_list_create();

ds_list_add(global.chat, "Welcome to the game", "Alpha " + string(GM_version));
ds_list_add(global.chat_color, c_white, c_olive);

chatX = global.RES_W - 500;
chatY = global.RES_H - 100;

chatSize = 5;
chatHistory = 8;
active = false; // on/off switch
chat_text = "";	// chat message
nextSpace = 0;

width = 350;
padding = 10;

fntSize = font_get_size(ftDefault);

#endregion

#region Steam Server settings

// Initialise steam
if steam_initialised()
	trace(1, "Steam Connected.");
else
{
	if steam_is_user_logged_on()
		trace(2, "Failed to connect to steam servers.");
	else
		trace(2, "Failed to find steam running.");
	trace(2, "Please restart the game.");
}

// Game details
game_name		= "Sierra Point";
game_version	= GM_version;

// Get name
steamUserName	= steam_get_user_steam_id();	// local user ID
names	= ds_map_create();				// <steamid:int64 -> name:string>

lobby_owner = noone;

// Create a map to hold a map for each players data
playerDataMap = ds_map_create();	// Uses steam ID to find the data map

// Preload username
steam_get_user_persona_name_w(steamUserName);

// Store other players
net_list	= ds_list_create();	// <steamid:int64>
net_map		= ds_map_create();	// <steamid:int64, time>

// Data handling
inbuf	= buffer_create(1024, buffer_grow, 1);	// used for storing incoming packets
outbuf	= buffer_create(1024, buffer_grow, 1);	// used for building outgoing packets

// lobby
lobby			= false;	// whether currently in a lobby
lobby_is_owner	= false;	// whether acting as a server
creating_lobby	= false;	// whether currently in async lobby creation
joining_lobby	= false;	// whether currently awaiting initial connection
playersReady	= 0;		// tracks all players in lobby have clicked ready
ready			= false;	// Tracks you, (cia agent says hello)
started			= false;
inGame			= false;

#endregion

#region Pathfinding Grid

// Create the Grid
var cell_width	= 8;
var cell_height = 8;

var hcells = room_width div cell_width;
var vcells = room_height div cell_height;

global.grid = mp_grid_create(0, 0, hcells, vcells, cell_width, cell_height);

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

#region Spawn Locations & Points

// Create a grid that holds x and y for spawn points
spawnPointGrid = ds_grid_create(2, 2);

// Player one spawn
ds_grid_add(spawnPointGrid, 0, 0, 680);  // X
ds_grid_add(spawnPointGrid, 1, 0, 1800); // Y

// Player two spawn
ds_grid_add(spawnPointGrid, 0, 1, 900);  // X
ds_grid_add(spawnPointGrid, 1, 1, 200); // Y

#endregion

#region Teams and colors

team = 0;

numColor = ds_grid_get(global.savedSettings, 1, setting.color);

// "Red", "Orange", "Yellow", "Green", "Light Blue", "Blue", "Purple", "Pink"

noColor	= noone;
red		= $8989FF;
orange	= $7AB3FF;
yellow	= $9BEEFF;
green	= $A4FF99;
ltBlue	= $EFFF96;
blue	= $FFBB91;
purple	= $FF8C9B;
pink	= $F6A8FF;

hashColor = findColor(numColor);

#endregion

#region Unit Resource Costs

enum unitResCost
{
	inf = 20,
	trans = 80,
	HAB = 100,
}

#endregion

#region Supplies & Costs

// Money
global.supplies = 0;
global.maxSupplies = global.supplies;

// Unit costs
unitCost = array_create(5);
unitCost[objectType.oZoneHQ] = 0;
unitCost[objectType.oInfantry] = 30;
unitCost[objectType.oZoneCamp] = 20;
unitCost[objectType.oZoneMoney] = 50;
unitCost[objectType.oZoneSupplies] = 30;
unitCost[objectType.oZoneBootCamp] = 80;

#endregion

// Debug menu
global.debugMenu = false;

// For when mouse is over UI or world
global.mouseUI = false;

// Make sure seed is random
randomize();

// Set font
draw_set_font(ftDefault);
