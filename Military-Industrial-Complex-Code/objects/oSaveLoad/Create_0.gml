// Create map for saved options
global.savedSettings = ds_grid_create(16, 0);

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