#region GUI creation

global.mouse_on_ui = false;

// Positioning value
var _centerX = global.RES_W/2;

// Default Button size
var _bigWidth	= 250;
var _medWidth	= 175;
var _smallWidth	= 100;
var _height = 75;

// Default List size
var _widthList	= 700;

var inst = noone;

// Activate state
switch(state)
{	
	case menu.home:
		#region Button checks
		
		// Find size
		var _size = ds_list_size(instPublic_list);
		
		if(ds_list_size(_size)) != 0
		{
			for(var i = 0; i < _size; i++)
			{
				// Find and destroy button
				instance_destroy(ds_list_find_value(instPublic_list, i))
			}
	
			// Reset list
			ds_list_clear(instPublic_list);
		}
		
		#endregion
	
		#region Home Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
		
		// Play Button
		inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Options", scr_GUI_Options, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Quit Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Quit", scr_GUI_Quit, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Host Button
		inst = create_button(_centerX - (_medWidth/2), 150, _medWidth, _height, "Host", scr_GUI_Host, self, oMenuButton);
		ds_list_add(inst_list, inst);
		
		// Join Button
		inst = create_button(_centerX - (_smallWidth/2) + 165, 150, _smallWidth, _height, "Join\nFriend", scr_GUI_Join_Private,	self, oMenuButton);
		ds_list_add(inst_list, inst);
		
		// Campaign Button
		inst = create_button(_centerX - (_medWidth/2), 260,	_medWidth, _height, "Campaign\n(Not Available)", on_click, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		#endregion
		break;

	case menu.public:
		#region Show public lobbies
		
		if(steam_lobby_list_is_loading())
		{
			// Refresh in 10 sec
			alarm[0] = room_speed * 5;
		}
		
		if(ds_list_size(instPublic_list)) == 0
		{		
			// Get amount of lobbies
		    var _amount = min(32, steam_lobby_list_get_count());
		
		    for (var o = 0; o < _amount; o++)
			{	
				// Get data
				var _lobbyTitle		= steam_lobby_list_get_data(o, "title");
				var _lobbyCurrent	= steam_lobby_list_get_data(o, "game_size_current");
				var _lobbyMax		= steam_lobby_list_get_data(o, "game_size_max");
				
				// Display name
		        var _string = "Join " + _lobbyTitle + "\n" + _lobbyCurrent + "/" + _lobbyMax + " Players\n";
				
				// Create Button for public lobby
				inst = create_button(400, 40 + o * (_height + 40), 300, _height * 1.5, _string, scr_GUI_Join_Public, self, oMenuButton);
				
				ds_list_add(instPublic_list, inst);
		    }
		}
		
		#endregion
			
		#region Play Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
		
		// Refresh Button
		inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Refresh", scr_GUI_Refresh, self, oMenuButton);
		ds_list_add(inst_list, inst);
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Options", scr_GUI_Options, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
				
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton);
		ds_list_add(inst_list, inst);
				
		#endregion
		break;
		
	case menu.hostPage:			
		#region Start match
		
		if lobby
		{
			var _lobbyCount = 1;
			
			if steam_is_user_logged_on()
				_lobbyCount = steam_lobby_get_member_count();
				
			if _lobbyCount == playersReady
			{
				// Broadcast start
				var _buffer = packet_start(packet_t.start);
				packet_send_all(_buffer);
				
				// Go to room
		        room_goto(rm_map_town_1v1);
		
				// Set Target state
				state = menu.inGame;
				
				inGame = true;
	
				// Reset menu
				reset_menu();
							
				var _players = ds_list_size(net_list);
							
				// Create lists to hold other players units
				for(var i = 0; i < _players; i++)
				{
					// Find player ID
					var _id = ds_list_find_value(net_list, i);
								
					// Create list for players
					var _map = ds_map_create();
												
					// Create slot for players
					ds_map_set(global.multiInstMap, _id, _map);
				}
							
				break;
			}
		}
		
		#endregion
			
		#region Host Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
		
		if !lobby_is_owner
		{
			// Get data
			var _lobbyType = ds_grid_get(global.savedSettings, 1, setting.host_type);
			
			// Create Friends only lobby with a max of 16 people (8v8)
			//steam_lobby_create(_lobbyType, 16);
			steam_lobby_create(steam_lobby_type_public, 4);
			
			if steam_init()
				show_debug_message("Steam Connected");
			
			show_debug_message("Creating lobby...");
		}
		
		_widthList	= 400;
			
		// Settings list	
		inst = create_list(global.RES_W - 490, global.RES_H - 550, _widthList, "Game settings:");		
		add_list(inst, setting.host_type);
		add_list(inst, setting.break_slot);
		add_list(inst, setting.player_count);
		add_list(inst, setting.map);
		add_list(inst, setting.spawn_points);
		add_list(inst, setting.color);
		add_list(inst, setting.game_mode);
		
		// Add team if game mode is set to teams
		if(ds_grid_get(global.savedSettings, 1, setting.game_mode) == 1)
			add_list(inst, setting.team_number);
		
		ds_list_add(inst_list, inst);
			
		if !ready
		{
			// Ready Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Up", readyChange, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		else
		{
			// UnReady Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Down", readyChange, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		
		// Lobby display
		inst = instance_create_layer(global.RES_W - 725, global.RES_H - 250, "UI", oLobby);
		ds_list_add(inst_list, inst);
		
		// Invite Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Invite", scr_GUI_Invite, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Leave Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Leave",	scr_GUI_Back,	self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		#endregion
		break;
		
	case menu.joinPage:		
		#region Host Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
				
		_widthList	= 400;
			
		// Settings list	
		inst = create_list(global.RES_W - 490, global.RES_H - 525, _widthList, "Game settings:");		
		add_list(inst, setting.color);
		
		// Get data map
		var _dataMap = ds_map_find_value(playerDataMap, lobby_owner);
		
		// Find value
		var _gameMode = ds_map_find_value(_dataMap, "game_mode");
		
		if _gameMode == 1
			add_list(inst, setting.team_number);
		
		ds_list_add(inst_list, inst);
			
		if !ready
		{
			// Ready Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Up", readyChange, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		else
		{
			// UnReady Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Down", readyChange, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		
		// Lobby display
		inst = instance_create_layer(global.RES_W - 725, global.RES_H - 250, "UI", oLobby);
		ds_list_add(inst_list, inst);
		
		// Invite Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Invite", scr_GUI_Invite, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Leave Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Leave",	scr_GUI_Back,	self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		#endregion
		break;
		
	case menu.loadingPage:		
		#region Button checks
		
		// Find size
		var _size = ds_list_size(instPublic_list);
		
		if(ds_list_size(_size)) != 0
		{
			for(var i = 0; i < _size; i++)
			{
				// Find and destroy button
				instance_destroy(ds_list_find_value(instPublic_list, i))
			}
	
			// Reset list
			ds_list_clear(instPublic_list);
		}
		
		#endregion
	
		#region Host Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
				
		_widthList	= 400;
								
		// Leave Button
		inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Cancel",	scr_GUI_Back,	self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		#endregion
		break;
		
	case menu.optionsPage:		
		#region Button checks
		
		// Find size
		var _size = ds_list_size(instPublic_list);
		
		if(ds_list_size(_size)) != 0
		{
			for(var i = 0; i < _size; i++)
			{
				// Find and destroy button
				instance_destroy(ds_list_find_value(instPublic_list, i))
			}
	
			// Reset list
			ds_list_clear(instPublic_list);
		}
		
		#endregion
	
		#region Options Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
		
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Controls Button
		inst = create_button(_centerX - (_medWidth/2) - 200, 150, _medWidth, _height, "Controls", scr_GUI_Controls, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
				
		// Sounds Button
		inst = create_button(_centerX - (_medWidth/2), 150, _medWidth, _height, "Sounds", scr_GUI_Sounds, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
			
		// Graphics Button
		inst = create_button(_centerX - (_medWidth/2) + 200, 150, _medWidth, _height, "Graphics", scr_GUI_Graphics, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
				
		#endregion
		break;
		
	case menu.inGame:	
		#region Create HQ
		
		if room == rm_menu
			break;
		
		if !started
		{
			alarm[1] = 10;
			
			started = true;
			
			// Give starting points
			global.points = 20;
			
			// Start alarm
			alarm[3] = 3 * room_speed;
						
			path_grid_reset();
		}
		
		#endregion
	
		#region In Game Buttons
				
		if !menuOpen break
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2), 40, _smallWidth, _height, "Options",  scr_GUI_Options, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Exit Button
		inst = create_button(_centerX - (_smallWidth/2) + 125, 40, _smallWidth, _height, "Exit",	scr_GUI_Menu, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		#endregion
		break;
		
	#region Options
	
	case menu.graphicsPage:	
		#region Graphics Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
				
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Main Button
		inst = create_button(_centerX - (_bigWidth/2), 150, _bigWidth, _height, "Main Options", scr_GUI_Options, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Controls Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 150, _smallWidth, _height, "Controls", scr_GUI_Controls, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
				
		// Sounds Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 150, _smallWidth, _height, "Sounds", scr_GUI_Sounds, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
				
		// Graphics list
		inst = create_list(_centerX - 100, 250, _widthList, "Graphics settings:");
		add_list(inst, setting.graphics);
		add_list(inst, setting.gui_size);
		add_list(inst, setting.fullscreen);
		ds_list_add(inst_list, inst);
						
		#endregion
		break;
		
	case menu.soundsPage:			
		#region Audio Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
		
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Main Button
		inst = create_button(_centerX - (_bigWidth/2), 150, _bigWidth, _height, "Main Options", scr_GUI_Options, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Controls Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 150, _smallWidth, _height, "Controls", scr_GUI_Controls, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
				
		// Graphics Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 150, _smallWidth, _height, "Graphics", scr_GUI_Graphics, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Audio list
		inst = create_list(_centerX - 100, 250, _widthList, "Audio settings:");
		add_list(inst, setting.main_volume);
		add_list(inst, setting.music_volume);
		add_list(inst, setting.special_sound_effects);
		ds_list_add(inst_list, inst);
				
		#endregion
		break;
			
	case menu.controlsPage:			
		#region Controls Page Buttons
		
		// Check if list already in use
		if(ds_list_size(inst_list)) > 0 break;
				
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(inst_list, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Main Button
		inst = create_button(_centerX - (_bigWidth/2), 150, _bigWidth, _height, "Main Options", scr_GUI_Options, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Audio Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 150, _smallWidth, _height, "Audio", scr_GUI_Sounds, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
				
		// Graphics Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 150, _smallWidth, _height, "Graphics", scr_GUI_Graphics, self, oMenuButton, false);
		ds_list_add(inst_list, inst);
		
		// Control list
		inst = create_list(_centerX - 100, 250, _widthList, "Control settings:");
		add_list(inst, setting.controls);
		ds_list_add(inst_list, inst);
							
		#endregion
	break;
	
	#endregion
}

#region Ingame overlay

if(keyboard_check_pressed(vk_escape)) && inGame
{
	// Change
	menuOpen = !menuOpen;
			
	state = menu.inGame
			
	// Update Menu
	reset_menu();
}
	
#endregion

#endregion
