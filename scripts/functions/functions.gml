#region Debugging	Functions

function dbg(_value) {
	show_debug_message(_value)
}
	
#endregion

#region Instance	Functions

#region Add/Create Instance

function add_Inst(_gridID, _y, _inst) {
	
	// Make sure inst is not in list
	var _check = find_Inst(_gridID, _y, _inst)

	if _check != -1
		exit;

	var _width = ds_grid_width(_gridID)
	var _height = ds_grid_height(_gridID)

	for(var i = 0; i < _width; i++)
	{		
		var _findSlot = ds_grid_get(_gridID, i, _y);
	
		if _findSlot == 0
		{
			ds_grid_set(_gridID, i, _y, _inst);
			break;
		}
		else
		{
			// Resize if too small
			if i+1 == _width
			{
				// Resize grid
				ds_grid_resize(_gridID, _width+1, _height);
			
				if _gridID == global.instGrid
					ds_grid_resize(global.instGrid, _width+1, _height);
			
				// Add value
				ds_grid_set(_gridID, i+1, _y, _inst);
			}
		}
	}
}
	
function create_building(_object_index) {
	// Accepts a string
	
	with(oPlayer)
	{
		// Find object
		var _object = asset_get_index(_object_index);
		
		// Create empty ghost to find sprite
		buildingPlacement = instance_create_layer(0, 0, "AboveAll", _object);
		
		// Remember name
		buildingName = _object_index;
		
		// Deactivate it to prevent it causing issues in game
		instance_deactivate_object(buildingPlacement);
	}
}

#endregion

#region Destroy Instance

function wipe_Deck(_gridID) {
	
	var _width	= ds_grid_width(_gridID);
	var _height = ds_grid_height(_gridID);

	for(var i = 0; i < _height; i++)
	{
		for(var o = 0; o < _width; o++)
		{
			ds_grid_set(_gridID, o, i, 0);
		}
	}
}
	
function wipe_Hand(_gridID, _y) {

	var _width = ds_grid_width(_gridID);

	for(var i = 0; i < _width; i++)
	{
		// Make sure instance isnt selected
		var _inst = ds_grid_get(_gridID, i, _y)
	
		if instance_exists(_inst)
			_inst.selected = false;
	
		// Clear slot
		ds_grid_set(_gridID, i, _y, 0);
	}
}

function wipe_Slot(_gridID, _x, _y) {

	// Unselect instance
	modify_Selected_Slot(_gridID, _x, _y, false);

#region Take out of hand

	// Find ID
	var _inst = ds_grid_get(_gridID, _x, _y);

	// Find position in hand
	_x = find_Inst(_gridID, 0, _inst);

	// Check if in hand
	if _x != -1 && _y != 0
		wipe_Slot(_gridID, _x, 0);

#endregion

	// Clear slot
	ds_grid_set(_gridID, _x, _y, 0);

#region Move list down one

	var _width = ds_grid_width(_gridID);

	for(var i = _x; i < _width; i++)
	{
		var o = i + 1;
	
		// Stop if nothing found in next slot
		if ds_grid_get(_gridID, o, _y) != 0 && o < _width
		{
			// Replace current slot with next slot
			var _value = ds_grid_get(_gridID, o, _y);
			ds_grid_set(_gridID, i, _y, _value);
		}
		else
		{
			// Replace current slot with nothing and stop
			ds_grid_set(_gridID, i, _y, 0);
		
			break;
		}
	}

#endregion
}

#endregion

#region Find Instance

function find_Inst(_gridID, _y, _inst) {

	var _x		= -1;
	var _width	= ds_grid_width(_gridID);

	for(var i = 0; i < _width; i++)
	{
		if ds_grid_get(_gridID, i, _y) == _inst
		{
			_x = i;
			break;
		}
	}

	return _x;
}

function find_top_Inst(_x, _y, _obj) {

	// Create the instance list
	var _inst_list = ds_list_create();

	// Find the first instance
	var _inst = instance_position(_x, _y, _obj);

	// Create the top instance variable
	var _top_inst = _inst;

	// Loop through each instance, check the depth
	while instance_exists(_inst)
	{
		ds_list_add(_inst_list, _inst);
		instance_deactivate_object(_inst);
	
		// Update top instance
		if _inst.depth < _top_inst.depth
		{
			_top_inst = _inst;
		}
	
		_inst = instance_position(_x, _y, _obj);
	}

	// Reactivate all the instances
	while ds_list_size(_inst_list) > 0
	{
		instance_activate_object(_inst_list[| 0]);
		ds_list_delete(_inst_list, 0);
	}

	// Destroy the list
	ds_list_destroy(_inst_list);

	// Return the top instance
	return _top_inst;
}

#endregion

#region Modify/Update Instance

function update_goal() {
	// Find self in list
	var _pos = ds_list_find_index(global.unitList, id)

	// Send position and rotation to others
	var _packet = packet_start(packet_t.move_unit);
	buffer_write(_packet, buffer_u64, oManager.user);
	buffer_write(_packet, buffer_u16, _pos);
	buffer_write(_packet, buffer_f32, x);
	buffer_write(_packet, buffer_f32, y);
	buffer_write(_packet, buffer_f32, goalX);
	buffer_write(_packet, buffer_f32, goalY);
	packet_send_all(_packet);
}

function modify_Selected_Slot(_gridID, _x, _y, _selected) {

var _inst = ds_grid_get(_gridID, _x, _y);

	if !instance_exists(_inst)
		exit;

	with(_inst)
	{
		selected = _selected;
	}
}
	
function update_state(_newState, _newMoveState) {
	// Inserting -1 will mean no update
	
	// Set moveState
	if _newState != -1
		state = _newState;
	else
		// Set moveState
		if _newMoveState != -1
			moveState = _newMoveState;
		
	// Update direction
	alarm[1] = 1;
	
	// Update sprite
	event_user(0);
	
	#region Update doppelganger

	// Find self in list
	var _pos = ds_list_find_index(global.unitList, id)
	
	// Send position and rotation to others
	var _packet = packet_start(packet_t.update_unit);
	buffer_write(_packet, buffer_u64, oManager.user);
	buffer_write(_packet, buffer_u16, _pos);
	buffer_write(_packet, buffer_s8, state);
	buffer_write(_packet, buffer_s8, moveState);
	packet_send_all(_packet);
	
	#endregion
}

function enter_Vehicle_One(_inst) {
	// Use inf _id to enter veh _inst
	var _id = id;
	
	with(_inst)
	{
		// Add self instance ID to veh list
		ds_list_add(riderList, _id);
		
		var _buffer = packet_start(packet_t.veh_interact);
		buffer_write(_buffer, buffer_u16, _id);
		buffer_write(_buffer, buffer_u8, action.enter);
		packet_send_all(_buffer);
	}
	
	// Reset variable	
	selected = false;
		
	// De-activate instance
	instance_deactivate_object(_id);
}

function exit_Vehicle_All() {
	with(oPlayer)
	{
		// Get selected transport
		var _veh = instRightSelected;
	}
	
	var _riderList = _veh.riderList;
	
	// Get size
	var _size = ds_list_size(_riderList);
	
	// Remove self infantry from list and activate them
	for(var i = 0; i < _size; i++)
	{
		// Find inf
		var _inst = ds_list_find_value(_riderList, i);
		
		// Activate inf
		instance_activate_object(_inst);
		
		// Set riding
		_inst.riding = true;
	
		// Update doppelganger
		var _buffer = packet_start(packet_t.veh_interact);
		buffer_write(_buffer, buffer_u16, _inst);
		buffer_write(_buffer, buffer_u8, action.leave);
		packet_send_all(_buffer);
	}
	
	close_context(-1);
}
	
function kill_Vehicle_Riders() {
	// Find all inf
	var _size = ds_list_size(riderList);
	
	// Find all inf and destroy them
	for(var i = 0; i <= _size; i++)
	{
		// Find inf
		var _inst = ds_list_find_value(riderList, i);
		
		// Activate inf
		instance_activate_object(_inst);
		
		// Destroy
		instance_destroy(_inst);
		
		// Remove from list
		ds_list_delete(riderList, i);
	}
}

#endregion

#endregion

#region Pathfinding

function scr_pathfind() {
		
	#region Rerout obstacles
	
	// Find nearest path
	var object = collision_circle(goalX, goalY, 15, oCollision, false, true);
	
	var distance = 0;
	var _x = 0;
	var _y = 0;
	
	while(instance_exists(object))
	{
		// How big of a radius to look away
		distance += 20;
		
		// Look 360 degrees around the area
		for(var i = 0; i < 360; i += 45)
		{
			_x = lengthdir_x(distance, i);
			_y = lengthdir_y(distance, i);
			
			// Check for collision
			if(!collision_circle(goalX + _x, goalY + _y, 15, oCollision, false, true))
			{
				// Change goals
				goalX += _x;
				goalY += _y;
				
				/*var _width = ds_grid_width(global.instGrid);
				
				// Update all instances selected
				
				for(var i = 0; i < _width; i++)
				{
					var _inst = ds_grid_get(global.instGrid, i, 0);
		
					if _inst == 0
						break;
		
					// update goal
					with(_inst)
					{										
						goalX = goalX;
						goalY = goalY;
					}
				}*/
				
				// Stop while Loop
				object = noone;
				
				// Stop loop
				break;
			}
		}
	}
	
	#endregion
	
	#region Shorten Path
	
	if(mp_grid_path(global.grid, path, x, y, goalX, goalY, true))
	{
		// path smoothing
		path_set_kind(path, false);
		path_set_precision(path, 8);
				
		var _pathAmount = path_get_number(path);
		
		// Shorten path
		if _pathAmount > 2
		{
			var x1, y1, x2, y2;
	
			// See if you can skip to the end
			var _startPointX	= path_get_point_x(path, 0);
			var _startPointY	= path_get_point_y(path, 0);
			var _endpointX		= path_get_point_x(path, _pathAmount-1);
			var _endpointY		= path_get_point_y(path, _pathAmount-1);
			
			if !collision_line(_startPointX, _startPointY, _endpointX, _endpointY, oCollision, false, true)
			{				
				// Cut out the middle points			
				while(path_get_number(path) > 2)
				{
					path_delete_point(path, 1);
				}
			}
			else
			{
				for(var i = 1; i < _pathAmount - 1; i++)
				{
					x1 = path_get_point_x(path, i - 1)
					y1 = path_get_point_y(path, i - 1)
			
					x2 = path_get_point_x(path, i + 1)
					y2 = path_get_point_y(path, i + 1)
                        
					//raycast
					var temp_dir	= point_direction(x1, y1, x2, y2);
				
					var temp_x		= x1+lengthdir_x(8, temp_dir);
					var temp_y		= y1+lengthdir_y(8, temp_dir);
				
					var start_xr	= temp_x;
					var start_yr	= temp_y;
					
					var path_collision = position_meeting(temp_x, temp_y, oCollision);
			
					while(!path_collision && (point_distance(start_xr, start_yr, temp_x, temp_y) < point_distance(start_xr, start_yr, x2, y2)))
					{
						temp_x += lengthdir_x(8, temp_dir);
						temp_y += lengthdir_y(8, temp_dir);
						path_collision = position_meeting(temp_x, temp_y, oCollision);
					}
                        
					if !path_collision
					{
						path_delete_point(path, i);
					
						_pathAmount--;
					
						i--;
					}
				}
			}
		}
	}
	else
	{
		dbg("Error pathfinding. Could not avoid obstacle.");
	}
	
	#endregion
	
	// Start path
	//path_start(path, moveSpd, path_action_stop, false);
}

function reset_pathfind() {
	// Create the Grid
	var cell_width = 8;
	var cell_height = 8;

	var hcells = room_width div cell_width;
	var vcells = room_height div cell_height;

	mp_grid_destroy(global.grid);
	global.grid = mp_grid_create(0, 0, hcells, vcells, cell_width, cell_height);
	
	update_pathfind();
}

function update_pathfind() {
	// Clear grid
	mp_grid_clear_all(global.grid);
	
	// Add walls
	mp_grid_add_instances(global.grid, oParWall, false);
	
	// Add stationary buildings & weapons
	for(var i = 0; i < instance_number(oParUnit); i++)
	{
		var _instance = instance_find(oParUnit, i);
		
		if _instance.moveSpd == 0
			mp_grid_add_instances(global.grid, _instance, false);
	}
	
	// Add stationary buildings & weapons for client
	for(var i = 0; i < instance_number(oParUnitClient); i++)
	{
		var _instance = instance_find(oParUnitClient, i);
		
		if _instance.moveSpd == 0
			mp_grid_add_instances(global.grid, _instance, false);
	}
}
	
function veh_position(_veh) {
	with(_veh)
	{
		// Find new position
		var _newX = x - lengthdir_x(((sprite_width/2)*image_xscale) + 28, image_angle);
		var _newY = y - lengthdir_y(((sprite_width/2)*image_xscale) + 28, image_angle);
	}
	
	// Set goal
	goalX = _newX;
	goalY = _newY;
}

#endregion

#region Steam		Functions

#region Helper Scripts

function steam_get_user_persona_name_w(_id) {
	// Display name fetching with caching
	
	// Change to string and add an ID to it
	_name = "id" + string(_id);
	
	// Find ID in list
	var _name = oManager.names[?_id];
	
	// Check if it returns positive
	if (_name == undefined)
	{
		// Get name using ID
	    steam_get_user_persona_name(_id);
		
		// Remember it
	    oManager.names[?_id] = _name;
	}
	return _name;
}

function steam_reset_state() {
	with(oManager)
	{
		#region Clear all lists and maps
		
		var _length = 0;
		var _inst	= noone;
		
		#region Unit List
		
		_length = ds_list_size(global.unitList);
		
		for(var i = 0; i < _length; i++)
		{
			// Find object
			_inst = ds_list_find_index(global.unitList, i);
			
			// Destroy it
			if(instance_exists(_inst) && _inst > 1000)
				instance_destroy(_inst);
		}
		
		ds_list_clear(global.unitList);
		
		#endregion
		
		#region Multiplayer instance map
		
		var _length = ds_map_size(net_list);
		
		for(var i = 0; i < _length; i++)
		{
			// Find key
			var _key = ds_list_find_value(net_list, i);
			
			// Find list of objects under map
			var _list = ds_map_find_value(global.multiInstMap, string(_key));
			
			// Cycle through list and destroy objects
			if(!is_undefined(_list))
			{
				#region List
		
				_length = ds_list_size(_list);
		
				for(var i = 0; i < _length; i++)
				{
					// Find object
					_inst = ds_list_find_index(_list, i);
			
					// Destroy it
					if(instance_exists(_inst) && _inst > 1000)
						instance_destroy(_inst);
				}
		
				ds_list_destroy(_list);
		
				#endregion
			}
		}
		
		ds_map_clear(global.multiInstMap);
		
		#endregion
		
	    ds_list_clear(net_list);
	    ds_map_clear(net_map);
		ds_map_clear(playerDataMap);
		
		// Reset grid
		var _width	= 0;
		var _height = ds_grid_height(global.instGrid);
		
		ds_grid_resize(global.instGrid, _width, _height);
		
		#endregion
	
		// lobby
		lobby			= false;	// whether currently in a lobby
		lobby_is_owner	= false;	// whether acting as a server
		creating_lobby	= false;	// whether currently in async lobby creation
		joining_lobby	= false;	// whether currently awaiting initial connection
		playersReady	= 0;		// tracks all players in lobby have clicked ready
		ready			= false;	// Tracks you, (cia agent says hello)
		started			= false;
		inGame			= false;
		menuOpen		= false;
		
		global.resources	= 0;
					
	    state = menu.home;
		
		room_goto(rm_menu);
		
		alarm[3] = 1;
	}
}

function steam_update_lobby() {
	// Get data
	var _lobbyType = ds_grid_get(global.savedSettings, 1, setting.host_type);

	// Find data
	switch _lobbyType
	{
		case 0: _lobbyType = steam_lobby_type_private;		break;
		case 1: _lobbyType = steam_lobby_type_friends_only; break;
		case 2: _lobbyType = steam_lobby_type_public;		break;
	}

	// Update lobby type
	steam_lobby_set_type(_lobbyType);
}

function trace(_status, _string) {
	for (var i = 2; i < argument_count; i++)
	{
	    _string += " " + string(argument[i]);
	}

	switch _status
	{
		case 1: _status = "Success"		break;
		case 2: _status = "Error"		break;
		case 3: _status = "Loading"		break;
	}

	chat_add(_status, _string, c_orange);
}


#endregion

#region Packet Helpers

#region Handle

function packet_handle_auth(from) {
	var _buffer;

#region Exit if packet not marked authentic

	if (buffer_read(inbuf, buffer_u8) != packet_t.auth)
	{
	    exit;
	}

#endregion

	else

#region Exit if wrong game name

	if (buffer_read(inbuf, buffer_string) != game_name)
	{
	    // game must match (can also be used for game mode filters)
	    _buffer = packet_start(packet_t.error);
	    buffer_write(_buffer, buffer_string, "Game mismatch.");
	    packet_send_to(_buffer, from);
	}

#endregion

	else

#region Exit if wrong game version

	if (buffer_read(inbuf, buffer_u32) != game_version)
	{
	    // game version must match
	    _buffer = packet_start(packet_t.error);
	    buffer_write(_buffer, buffer_string, "Version mismatch.");
	    packet_send_to(_buffer, from);
	}

#endregion

	else
	{
	    // inform existing players about the newcomer:
	    _buffer = packet_start(packet_t.auth);
	    buffer_write_int64(_buffer, from);
	    packet_send_all(_buffer);
	
	    // inform the newcomer about the existing players:
	    var _listSize = ds_list_size(net_list);
	    for (var i = 0; i < _listSize; i++)
		{
	        _buffer = packet_start(packet_t.auth);
	        buffer_write_int64(_buffer, net_list[|i]);
	        packet_send_to(_buffer, from);
	    }
	
	    // send the first ping (bounced to keep connection alive):
	    _buffer = packet_start(packet_t.ping);
	    packet_send_to(_buffer, from);
		
		// Create map to hold data for newbie
		var _dataMap = ds_map_create();
						
		// Add it to the main map
		ds_map_set(playerDataMap, string(from), _dataMap);
				
		// Ask for data
		_buffer = packet_start(packet_t.data_update_request);
		buffer_write(_buffer, buffer_u64, user);
		packet_send_to(_buffer, from);
	
	    // inform the player that they are now connected:
	    _buffer = packet_start(packet_t.lobby_connected);
	    packet_send_to(_buffer, from);
			
	    // add them to the list of players:
	    ds_list_add(net_list, from);
	    net_map[?from] = current_time;
		
		// Get current size
		var _lobbyCurrent	= steam_lobby_get_member_count();
		
		// Update lobby current size
		steam_lobby_set_data("game_size_current", string(_lobbyCurrent));
			
	    exit;
	}
}

function packet_handle_client(from) {
	// Get Data
	var _buffer = inbuf;
	var _packet;

	var _client;
	var _string;
	var _color;

	net_map[?from] = current_time;

	switch(buffer_read(_buffer, buffer_u8))
	{
	    case packet_t.auth: // ()
	
	        var _user = buffer_read_int64(_buffer);
	        ds_list_add(net_list, _user);
	        net_map[?_user] = current_time;
			
			// Create map to hold data for newbie
			var _dataMap = ds_map_create();
						
			// Add it to the main map
			ds_map_set(playerDataMap, string(from), _dataMap);
				
			// Ask for data
			var _buffer = packet_start(packet_t.data_update_request);
			buffer_write(_buffer, buffer_u64, user);
			packet_send_to(_buffer, from);
		
	        break;
		
	    case packet_t.ping: // ()
	
	        _packet = packet_start(packet_t.ping);
	        packet_send_to(_packet, from);
		
	        break;
		
	    case packet_t.chat: // (message:client, string, color)
	
			// Get data
			_client = buffer_read(_buffer, buffer_u64);
	        _string = buffer_read(_buffer, buffer_string);
			_color = buffer_read(_buffer, buffer_u16);
		
			// Find actual color
			_color = findColor(_color);
			
			// Change ID into name
			var _name = steam_get_user_persona_name_w(_client);
			
			// Show in local chat
	        chat_add(_name, _string, _color);
		
	        break;
		
	    case packet_t.error: // (error:string)
		
			_client = steam_get_user_persona_name_w(from)
	        _string = buffer_read(_buffer, buffer_string);
			_color = buffer_read(_buffer, buffer_u8);
		
	        chat_add(_client, _string, _color);
		
			// Leave lobby
	        if(lobby)
			{
	            lobby = false;
	            lobby_is_owner = false;
	            lobby_owner = 0;
	            steam_lobby_leave();
	        }
		
			// Leave game
	        if(ingame)
			{
	            ingame = false;
			
				// Set menu
				state = menu.joinPage;
			
				// Reset menu
				reset_menu();
			
				// Go to menu room
	            room_goto(rm_menu);
	        }
		
	        break;
		
	    case packet_t.leaving:
	
	        packet_handle_leaving(buffer_read_int64(_buffer));
			
			// Get data
			_string = "left the game.";
			_color	= color.orange;
			
			// Get data
			var _name = steam_get_user_persona_name_w(from);
		
			// show a notice in chat:
			chat_add(_name, _string, _color);
		
	        break;
		
	    case packet_t.start:
						
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
				var _list = ds_list_create();
												
				// Create slot for players
				ds_map_set(global.multiInstMap, string(_id), _list);
			}
									
	        break;
			
		case packet_t.add_unit:
	
			var _from			= buffer_read(_buffer, buffer_u64);
			var _object_string	= buffer_read(_buffer, buffer_string);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);
						
			var _object = asset_get_index(_object_string + "Client");
			
			// Create instance
			var _inst	= instance_create_layer(posX, posY, "Instances", _object);
						
			// Find list
			var _list	= ds_map_find_value(global.multiInstMap, string(_from))
			
			// Add inst to list
			ds_list_add(_list, _inst);
			
			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, string(_from));
			
			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hashColor");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");
			
			//Debug
			dbg(string(delta_time) + ": " + object_get_name(_object) + " - " + string(ds_list_find_index(_list, _inst)) + " is being created.");	
	
			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hashColor		= _hashColor;
				
				// Give drone a name
				if _object_string == "oPlayer"
					playerName = steam_get_user_persona_name_w(from);
			}
						
			break;
			
		case packet_t.add_attached_unit:
	
			var _from			= buffer_read(_buffer, buffer_u64);
			var _object_string	= buffer_read(_buffer, buffer_string);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);
			var _posList		= buffer_read(_buffer, buffer_u16);
						
			var _object		= asset_get_index(_object_string + "Client");
			
			// Create instance
			var _inst		= instance_create_layer(posX, posY, "Instances", _object);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(from))
			
			// Find Unit
			var _parent		= ds_list_find_value(_list, _posList);
			
			// Add inst to list
			ds_list_add(_list, _inst);
			
			// Get data map
			var _dataMap	= ds_map_find_value(playerDataMap, string(from));
			
			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hashColor");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");
						
			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hashColor		= _hashColor;
				
				// Add parent
				squadID			= _parent;
			}
			
			// Add to parentlist
			with(_parent)
			{
				ds_list_add(childList, _inst);
			}
						
			break;
			
		case packet_t.destroy_unit:
		
			// Check if still in game
			if !inGame
				break;
		
			var _from		= buffer_read(_buffer, buffer_u64);
			var _posList	= buffer_read(_buffer, buffer_u16);
			
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(_from))
			
			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			// Destroy unit
			if(!is_undefined(_unit))
				instance_destroy(_unit);
		
			break;
			
		case packet_t.move_unit:
			
			// Check if still in game
			if !inGame
				break;
			
			// Get data
			var _from		= buffer_read(_buffer, buffer_u64);
			var _posList	= buffer_read(_buffer, buffer_u16);
			var _x			= buffer_read(_buffer, buffer_f32);
			var _y			= buffer_read(_buffer, buffer_f32);
			var _goalX		= buffer_read(_buffer, buffer_f32);
			var _goalY		= buffer_read(_buffer, buffer_f32);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(_from))
			
			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			//Debug
			dbg(string(delta_time) + ": " + object_get_name(_unit.object_index) + " - " + string(_posList) + " is pathfinding.");	
			
			if is_undefined(_unit) || !instance_exists(_unit)
				break;
			
			with(_unit)
			{
				if _posList != 0
				{
					// Make sure its in the correct position
					x = _x;
					y = _y;
					
					// Start pathfind for unit
					goalX = _goalX;
					goalY = _goalY;
					
					scr_pathfind();
				}
				else
				{
					// Just move player
					x = _x;
					y = _y;
				}
			}
			
			break;
			
		case packet_t.veh_interact:
			
			// Check if still in game
			if !inGame
				break;
			
			// Get data
			var _posList		= buffer_read(_buffer, buffer_u16);
			var _interaction	= buffer_read(_buffer, buffer_u8);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(from))

			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			if is_undefined(_unit) || !instance_exists(_unit)
				break;
			
			switch(_interaction)
			{
				case action.enter:
					instance_deactivate_object(_unit);
					break;
				case action.leave:
					instance_activate_object(_unit);
					break;
			}
			
			break;
			
		case packet_t.update_unit:
			
			// Check if still in game
			if !inGame
				break;
			
			// Get data
			var _from			= buffer_read(_buffer, buffer_u64);
			var _posList		= buffer_read(_buffer, buffer_u16);
			var _newState		= buffer_read(_buffer, buffer_s8);
			var _newMoveState	= buffer_read(_buffer, buffer_s8);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(_from))

			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			if is_undefined(_unit) || !instance_exists(_unit)
				break;
			
			with(_unit)
			{
				// Set moveState
				if _newState != -1
					state = _newState;
	
				// Set moveState
				if _newMoveState != -1
					moveState = _newMoveState;
					
				// Update sprite
				event_user(0);
		
				// Update direction
				alarm[1] = 1;
			}
			
			break;
			
		case packet_t.shoot_bullet: // client: (x, y, angle, type, numColor)
			
			// Get data
			var _x			= buffer_read(_buffer, buffer_u16);
			var _y			= buffer_read(_buffer, buffer_u16);
			var _angle		= buffer_read(_buffer, buffer_u16);
			var _type		= buffer_read(_buffer, buffer_u8);
			var _accuracy	= buffer_read(_buffer, buffer_u8);
			var _team		= buffer_read(_buffer, buffer_u16);
			var _numColor	= buffer_read(_buffer, buffer_u16);
			
			// Create a bullet
			var _bullet = instance_create_layer(_x, _y, "Bullets", oBullet);
			
			with(_bullet)
			{			
				bulletType	= _type;
				accuracy	= _accuracy;
				dir			= _angle;
				team		= _team;
				numColor	= _numColor;
			}
			
			break;
			
		case packet_t.lobby_connected:
		
			trace(1, "Connected to Lobby.");
			
			break;
			
		case packet_t.data_map:
			
			var _from	= buffer_read(_buffer, buffer_u64);
			var _key	= buffer_read(_buffer, buffer_string);
			var _data	= buffer_read(_buffer, buffer_s16);
			
			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, string(_from));
			
			switch _key
			{
				case "ready":
					playersReady += (_data * 2) - 1;
					break;
					
				case "numColor":
					
					var _color;
					
					// Get color
					_color = findColor(_data);
								
					// Set data
					ds_map_set(_dataMap, "hashColor", _color);
					
					break;
				
				case "game_mode":
				
					ds_grid_set(global.savedSettings, 1, setting.game_mode, _data);
					
					// Send new team number
					var _buffer = packet_start(packet_t.data_map);
					
					// Update team
					if _data == 0
						team = 0

					if _data == 1
						team = 1
	
					buffer_write(_buffer, buffer_u64, user);
					buffer_write(_buffer, buffer_string, "team");
					buffer_write(_buffer, buffer_s16, team);
	
					packet_send_all(_buffer);
					
					// Update GUI
					alarm[3] = 1;
					
					break;
			}
			
			// Set data
			ds_map_set(_dataMap, _key, _data);
			
			break;
			
		case packet_t.data_update_request:
			
			// Find who asked
			var _from	= buffer_read(_buffer, buffer_u64);
			
			// Make a Header
			var _buffer = packet_start(packet_t.data_update_packet);
			
			// Write who is sending this
			buffer_write(_buffer, buffer_u64, user);
			
			// Write all the data
			buffer_write(_buffer, buffer_s16, ready);
			
			buffer_write(_buffer, buffer_s16, numColor);
			
			buffer_write(_buffer, buffer_s16, team);
			
			buffer_write(_buffer, buffer_s16, global.resources);
			
			var _gameMode = ds_grid_get(global.savedSettings, 1, setting.game_mode);
			buffer_write(_buffer, buffer_s16, _gameMode);
			
			// Tell em nobody cares
			packet_send_to(_buffer, _from);
					
			break;
			
		case packet_t.data_update_packet:
			
			// Find who asked
			var _from	= buffer_read(_buffer, buffer_u64);
			
			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, string(_from));
			
			// Get data from buffer
			var _ready		= buffer_read(_buffer, buffer_s16);
			
			var _numColor	= buffer_read(_buffer, buffer_s16);
			
			var _team		= buffer_read(_buffer, buffer_s16);
			
			var _mode		= buffer_read(_buffer, buffer_s16);
			
			global.resources	= buffer_read(_buffer, buffer_s16);
									
			// Get color
			var _colorHash = findColor(_numColor);	
			
			// Set data
			ds_map_set(_dataMap, "numColor",	_numColor);
			ds_map_set(_dataMap, "hashColor",	_colorHash);
			ds_map_set(_dataMap, "ready",		_ready);
			ds_map_set(_dataMap, "team",		_team);
			
			if ds_grid_get(global.savedSettings, 1, setting.game_mode) != _mode
			{
				// Update settings
				ds_grid_set(global.savedSettings, 1, setting.game_mode, _mode);
			
				// Update team
				if _mode == 0
					team = 0

				if _mode == 1
					team = 1
				
				// Update everyone else
				var _buffer = packet_start(packet_t.data_map);
				buffer_write(_buffer, buffer_u64, user);
				buffer_write(_buffer, buffer_string, "team");
				buffer_write(_buffer, buffer_s16, team);
				packet_send_all(_buffer);
			}
			 
			
			// Update GUI
			reset_menu();
						
			break;
	}
}
	
function packet_handle_server(from) {
	// Get data
	var _buffer = inbuf;
	var _packet;

	var _client;
	var _string;
	var _color;

	net_map[?from] = current_time;

	switch (buffer_read(_buffer, buffer_u8))
	{
	    case packet_t.ping: // ()
	
	        _packet = packet_start(packet_t.ping);
	        packet_send_to(_packet, from);
		
	        break;
		
	    case packet_t.chat: // (message:client, string, color)
		
			// Get data
			_client = buffer_read(_buffer, buffer_u64);
	        _string = buffer_read(_buffer, buffer_string);
			_color = buffer_read(_buffer, buffer_u16);
		
			// Send to everyone else
	        _packet = packet_start(packet_t.chat);
			buffer_write(_packet, buffer_u64, _client);
	        buffer_write(_packet, buffer_string, _string);
			buffer_write(_packet, buffer_u16, _color);
			packet_send_except(_packet, from);
		
			// Find actual color
			_color = findColor(_color);
			
			// Find actual name
			var _name = steam_get_user_persona_name_w(from);
			
			// Show in local chat
	        chat_add(_name, _string, _color);

	        break;
		
	    case packet_t.leaving:
	
	        packet_handle_leaving(from);
		
	        // inform the other players:
	        var _buffer = packet_start(packet_t.leaving);
	        buffer_write_int64(_buffer, user);
	        packet_send_all(_buffer);
			
			// Get data
			_string = "left the game.";
			_color = color.orange;
			
			// Get data
			var _name = steam_get_user_persona_name_w(user);
		
			// show a notice in chat:
			chat_add(_name, _string, _color);
		
	        break;
			
		case packet_t.add_unit:
			
			var _from			= buffer_read(_buffer, buffer_u64);
			var _object_string	= buffer_read(_buffer, buffer_string);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);
			
			var _buffer = packet_start(packet_t.add_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_string, _object_string);
			buffer_write(_buffer, buffer_f32, posX);
			buffer_write(_buffer, buffer_f32, posY);
			packet_send_except(_buffer, from);
			
			var _object = asset_get_index(_object_string + "Client");
			
			// Create instance
			var _inst	= instance_create_layer(posX, posY, "Instances", _object);
						
			// Find list
			var _list	= ds_map_find_value(global.multiInstMap, string(_from))
			
			// Add inst to list
			ds_list_add(_list, _inst);
			
			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, string(_from));
			
			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hashColor");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");
						
			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hashColor		= _hashColor;
				
				// Give drone a name
				if _object_string == "oPlayer"
					playerName = steam_get_user_persona_name_w(from);
			}
						
			break;
			
		case packet_t.add_attached_unit:
	
			var _from			= buffer_read(_buffer, buffer_u64);
			var _object_string	= buffer_read(_buffer, buffer_string);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);
			var _posList		= buffer_read(_buffer, buffer_u16);
			
			var _buffer = packet_start(packet_t.add_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_string, _object_string);
			buffer_write(_buffer, buffer_f32, posX);
			buffer_write(_buffer, buffer_f32, posY);
			buffer_write(_buffer, buffer_u16, _posList);
			packet_send_except(_buffer, from);
						
			var _object		= asset_get_index(_object_string + "Client");
			
			// Create instance
			var _inst		= instance_create_layer(posX, posY, "Instances", _object);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(_from))
			
			// Find Unit
			var _parent		= ds_list_find_value(_list, _posList);
			
			// Add inst to list
			ds_list_add(_list, _inst);
			
			// Get data map
			var _dataMap	= ds_map_find_value(playerDataMap, string(from));
			
			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hashColor");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");
						
			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hashColor		= _hashColor;
				
				// Add parent
				squadID			= _parent;
			}
			
			// Add to parentlist
			with(_parent)
			{
				ds_list_add(childList, _inst);
			}
						
			break;
			
		case packet_t.destroy_unit:
		
			// Check if still in game
			if !inGame
				break;
		
			var _from		= buffer_read(_buffer, buffer_u64);
			var _posList	= buffer_read(_buffer, buffer_u16);
			
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(_from))
			
			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			// Destroy unit
			if(!is_undefined(_unit))
				instance_destroy(_unit);
			
			// Tell others to do the same
			var _buffer = packet_start(packet_t.destroy_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _posList);
			packet_send_except(_buffer, from);
		
			break;
			
		case packet_t.move_unit:
			
			// Check if still in game
			if !inGame
				break;
			
			// Get data
			var _from		= buffer_read(_buffer, buffer_u64);
			var _posList	= buffer_read(_buffer, buffer_u16);
			var _x			= buffer_read(_buffer, buffer_f32);
			var _y			= buffer_read(_buffer, buffer_f32);
			var _goalX		= buffer_read(_buffer, buffer_f32);
			var _goalY		= buffer_read(_buffer, buffer_f32);
			
			var _buffer = packet_start(packet_t.move_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _posList);
			buffer_write(_buffer, buffer_f32, _x);
			buffer_write(_buffer, buffer_f32, _y);
			buffer_write(_buffer, buffer_f32, _goalX);
			buffer_write(_buffer, buffer_f32, _goalY);
			packet_send_except(_buffer, from);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(from))

			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			if is_undefined(_unit) || !instance_exists(_unit)
				break;
			
			with(_unit)
			{
				if _posList != 0
				{
					// Make sure its in the correct position
					x = _x;
					y = _y;
					
					// Start pathfind for unit
					goalX = _goalX;
					goalY = _goalY;
					
					scr_pathfind();
				}
				else
				{
					// Just move player
					x = _x;
					y = _y;
				}
			}
			
			break;
			
		case packet_t.veh_interact:
			
			// Check if still in game
			if !inGame
				break;
			
			// Get data
			var _posList		= buffer_read(_buffer, buffer_u16);
			var _interaction	= buffer_read(_buffer, buffer_u8);
			
			var _buffer = packet_start(packet_t.veh_interact);
			buffer_write(_buffer, buffer_u16, _posList);
			buffer_write(_buffer, buffer_u8, _interaction);
			packet_send_except(_buffer, from);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(from))

			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			if is_undefined(_unit) || !instance_exists(_unit)
				break;
			
			switch(_interaction)
			{
				case action.enter:
					instance_deactivate_object(_unit);
					break;
				case action.leave:
					instance_activate_object(_unit);
					break;
			}
			
			break;
			
		case packet_t.update_unit:
			
			// Check if still in game
			if !inGame
				break;
			
			// Get data
			var _from			= buffer_read(_buffer, buffer_u64);
			var _posList		= buffer_read(_buffer, buffer_u16);
			var _newState		= buffer_read(_buffer, buffer_s8);
			var _newMoveState	= buffer_read(_buffer, buffer_s8);
			
			var _buffer = packet_start(packet_t.move_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _posList);
			buffer_write(_buffer, buffer_s8, _newState);
			buffer_write(_buffer, buffer_s8, _newMoveState); 
			packet_send_except(_buffer, from);
						
			// Find list
			var _list		= ds_map_find_value(global.multiInstMap, string(_from))

			// Find Unit
			var _unit		= ds_list_find_value(_list, _posList);
			
			if is_undefined(_unit) || !instance_exists(_unit)
				break;
			
			with(_unit)
			{
				// Set moveState
				if _newState != -1
					state = _newState;
	
				// Set moveState
				if _newMoveState != -1
					moveState = _newMoveState;
					
				// Update sprite
				event_user(0);
		
				// Update direction
				alarm[1] = 1;
			}
			
			break;
			
		case packet_t.shoot_bullet: // client: (x, y, angle, type, numColor)
			
			// Get data
			var _x			= buffer_read(_buffer, buffer_u16);
			var _y			= buffer_read(_buffer, buffer_u16);
			var _angle		= buffer_read(_buffer, buffer_u16);
			var _type		= buffer_read(_buffer, buffer_u8);
			var _accuracy	= buffer_read(_buffer, buffer_u8);
			var _team		= buffer_read(_buffer, buffer_u16);
			var _numColor	= buffer_read(_buffer, buffer_u16);
						
			// Update players
			var _packet = packet_start(packet_t.shoot_bullet);
			buffer_write(_packet, buffer_u16, _x);
			buffer_write(_packet, buffer_u16, _y);
			buffer_write(_packet, buffer_u16, _angle);
			buffer_write(_packet, buffer_u8,  _type);
			buffer_write(_packet, buffer_u8,  _accuracy);
			buffer_write(_packet, buffer_u16, _team);
			buffer_write(_packet, buffer_u16, _numColor);
			packet_send_except(_packet, from);
			
			// Create a bullet
			var _bullet = instance_create_layer(_x, _y, "Bullets", oBullet);
			
			with(_bullet)
			{			
				bulletType	= _type;
				accuracy	= _accuracy;
				dir			= _angle;
				team		= _team;
				numColor	= _numColor;
			}
			
			break;
			
		case packet_t.data_map:
			
			var _from	= buffer_read(_buffer, buffer_u64);
			var _key	= buffer_read(_buffer, buffer_string);
			var _data	= buffer_read(_buffer, buffer_s16);
			
			var _buffer = packet_start(packet_t.data_map);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_string, _key);
			buffer_write(_buffer, buffer_s16, _data);
			packet_send_except(_buffer, from);
			
			switch _key
			{
				case "ready":
					playersReady += (_data * 2) - 1;
					break;
					
				case "numColor":
					
					var _color;
					
					_color = findColor(_data);
					
					// Get data map
					var _dataMap = ds_map_find_value(playerDataMap, string(_from));
			
					// Set data
					ds_map_set(_dataMap, "hashColor", _color);
					
					break;
					
				case "game_mode":
				
					ds_grid_set(global.savedSettings, 1, setting.game_mode, _data);
					
					// Send new team number
					var _buffer = packet_start(packet_t.data_map);
	
					buffer_write(_buffer, buffer_u64, user);
					buffer_write(_buffer, buffer_string, "team");
					buffer_write(_buffer, buffer_s16, team);
	
					packet_send_all(_buffer);
					
					// Update GUI
					alarm[3] = 1;
					
					break;
			}
						
			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, string(_from));
			
			// Set data
			ds_map_set(_dataMap, _key, _data);
			
			break;
			
		case packet_t.data_update_request:
			
			// Find who asked
			var _from	= buffer_read(_buffer, buffer_u64);
			
			// Make a Header
			var _buffer = packet_start(packet_t.data_update_packet);
			
			// Write who is sending this
			buffer_write(_buffer, buffer_u64, user);
			
			// Write all the data
			buffer_write(_buffer, buffer_s16, ready);
			
			buffer_write(_buffer, buffer_s16, numColor);
			
			buffer_write(_buffer, buffer_s16, team);
			
			buffer_write(_buffer, buffer_s16, global.resources);
			
			var _gameMode = ds_grid_get(global.savedSettings, 1, setting.game_mode);
			buffer_write(_buffer, buffer_s16, _gameMode);
			
			// Tell em nobody cares
			packet_send_to(_buffer, _from);
			
			break;
			
		case packet_t.data_update_packet:
			
			// Find who asked
			var _from	= buffer_read(_buffer, buffer_u64);
			
			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, string(_from));
			
			// Get data from buffer
			var _ready		= buffer_read(_buffer, buffer_s16);
			
			var _numColor	= buffer_read(_buffer, buffer_s16);
			
			var _team		= buffer_read(_buffer, buffer_s16);
									
			// Get color
			var _hashColor	= findColor(_numColor);
			
			// Set data
			ds_map_set(_dataMap, "numColor",	_numColor);
			ds_map_set(_dataMap, "hashColor",	_hashColor);
			ds_map_set(_dataMap, "ready",		_ready);
			ds_map_set(_dataMap, "team",		_team);
						
			break;
	}
}

function packet_handle_leaving(steamID) {
	
	ds_list_delete(net_list, ds_list_find_index(net_list, steamID));
	ds_map_delete(net_map, steamID);
	
	ds_map_delete(playerDataMap, string(steamID));
	
	// Get current size
	var _lobbyCurrent	= steam_lobby_get_member_count();
		
	// Update lobby current size
	steam_lobby_set_data("game_size_current", string(_lobbyCurrent));

	if(state == menu.inGame)
	{
		// Find list of objects under map
		var _list = ds_map_find_value(global.multiInstMap, string(steamID));
			
		// Cycle through list and destroy objects
		if(!is_undefined(_list))
		{
			#region List
		
			_length = ds_list_size(_list);
		
			for(var i = 0; i < _length; i++)
			{
				// Find object
				_inst = ds_list_find_index(_list, i);
			
				// Destroy it
				if(instance_exists(_inst) && _inst > 1000)
					instance_destroy(_inst);
			}
		
			ds_list_destroy(_list);
		
			ds_map_delete(global.multiInstMap, string(steamID));
		
			#endregion
		}
	}
}

function buffer_read_int64(_buffer) {
	var _client = buffer_read(_buffer, buffer_u32);
	
	return _client | (buffer_read(_buffer, buffer_s32) << 32);
}
	
#endregion

#region Send

function packet_send_all(_buffer) {	
	with (oManager)
	{
		// Get data
	    var _position = buffer_tell(_buffer);
	
	    if (lobby_is_owner)
		{
	        // if we're server, send to clients
	        var _listSize = ds_list_size(net_list);
	        for (var i = 0; i < _listSize; i++)
			{
	            steam_net_packet_send(net_list[|i], _buffer, _position, steam_net_packet_type_reliable);
			}
	    }
		else
		{
	        // if we're client, send to server
	        steam_net_packet_send(lobby_owner, _buffer, _position, steam_net_packet_type_reliable);
	    }
	}
}

function packet_send_except(_buffer, _target) {
	/// @param buf
	/// @param  except_to_id
	
	with (oManager)
	{
	    var _position = buffer_tell(_buffer);
	
	    if (lobby_is_owner)
		{
	        // if we're server, send to clients
	        var n = ds_list_size(net_list);
		
	        for (var i = 0; i < n; i++)
			{
	            var _client = net_list[|i];
	            if (_client != _target)
				{
					steam_net_packet_send(_client, _buffer, _position, steam_net_packet_type_reliable);
				}
	        }
	    }
		else
		if (_target != lobby_owner)
		{
	        // if we're client, send to server
	        steam_net_packet_send(lobby_owner, _buffer, _position, steam_net_packet_type_reliable);
	    }
	}
}

function packet_send_to(_buffer, _to) {	
	var _position = buffer_tell(_buffer);
	steam_net_packet_send(_to, _buffer, _position, steam_net_packet_type_reliable);
}

function buffer_write_int64(_buffer, _client) {	
	buffer_write(_buffer, buffer_u32, _client & $FFFFFFFF);
	buffer_write(_buffer, buffer_s32, _client >> 32);
}

#endregion

#endregion

#region Shortcuts

function packet_start(_type) {	
	
	var _buffer = oManager.outbuf;
	
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, _type);
	
	return _buffer;
}
	
function readyChange() {
	// Access parent
	with(parent)
	{	
		ready = !ready;
		
		playersReady += (ready * 2) - 1;
		
		var _buffer = packet_start(packet_t.data_map);
		buffer_write(_buffer, buffer_u64, user);
		buffer_write(_buffer, buffer_string, "ready");
		buffer_write(_buffer, buffer_s16, ready);
		packet_send_all(_buffer);
	
		// Update menu
		reset_menu();
	}
}
	
function findColor(_numColor) {
	
	var _hashColor;
	
	// Get color
	switch _numColor
	{	
		case 0: _hashColor = noColor	break;
		case 1: _hashColor = red		break;
		case 2: _hashColor = orange		break;
		case 3: _hashColor = yellow		break;
		case 4: _hashColor = green		break;
		case 5: _hashColor = ltBlue		break;
		case 6: _hashColor = blue		break;
		case 7: _hashColor = purple		break;
		case 8: _hashColor = pink		break;
	}
	
	return _hashColor;
}

#endregion

#endregion

#region Save		Functions

function loadStringFromFile(_filename) {
	var _buffer = buffer_load(_filename);
	var _string = buffer_read(_buffer, buffer_string);

	buffer_delete(_buffer);

	var _json = json_decode(_string);

	return _json;
}

function saveStringToFile(_filename, _string) {

	var _buffer = buffer_create(string_byte_length(_string) + 1, buffer_fixed, 1);

	buffer_write(_buffer, buffer_string, _string);
	buffer_save(_buffer, _filename);
	buffer_delete(_buffer);
}


#endregion

#region Context		Functions

#region Modify Context Menu

function add_context(_string, _scriptID, _folder) {

	// Make sure context is not in list
	if _string != "break"
	{
		var _check = find_context(_string);

		if _check != -1
			exit;
	}

	var _height = ds_grid_height(contextGrid)

	for(var i = 0; i < _height; i++)
	{		
		var _findSlot = ds_grid_get(contextGrid, 0, i);
	
		if _findSlot == 0
		{
			ds_grid_set(contextGrid, 0, i, _string);
			ds_grid_set(contextGrid, 1, i, _scriptID);
			ds_grid_set(contextGrid, 2, i, _folder);
			break;
		}
		else
		{
			// Resize if too small
			if i+1 == _height
			{
				// Resize grid
				ds_grid_resize(contextGrid, 3, i+2);
			
				// Add value
				ds_grid_set(contextGrid, 0, i+1, _string);
				ds_grid_set(contextGrid, 1, i+1, _scriptID);
				ds_grid_set(contextGrid, 2, i+1, _folder);
			}
		}
	}
}

function close_context(_inst) {

	with(oPlayer)
	{
		if _inst == -1
		{
			// find size
			var _size = ds_list_size(contextInstList);
		
			// Clear entire list starting from the top
			for(var i = _size - 1; i > -1; i--)
			{						
				// Get ID
				_inst = ds_list_find_value(contextInstList, i);
		
				instance_destroy(_inst);
				
				ds_list_delete(contextInstList, i);
			}
		
			// Close context menu
			contextMenu = false;		
		}
		else
		{
			// Delete single instance
			instance_destroy(_inst)
		
			// Find ID in list
			var _pos = ds_list_find_index(contextInstList, _inst);
		
			// Delete slot
			ds_list_delete(contextInstList, _pos);
	
			// Close context menu
			contextMenu = false;
		}
	}
}
	
function create_context(_x, _y) {

	// Create context menu
	var _inst = instance_create_layer(_x, _y, "GUI", oContextMenu);

	with(oPlayer)
	{
		// Add to list
		ds_list_add(contextInstList, _inst);
	
		var _size = ds_list_size(contextInstList)
	
		if _size > 1
		{
			// Find current position
			var _pos = ds_list_find_index(contextInstList, _inst);
		
			// Find previous inst
			var _prevInst = ds_list_find_value(contextInstList, _pos - 1);
		
			// Find the right of the inst
			var _start_x	= _prevInst.x;
			var _width		= _prevInst.width;
		
			_inst.x = _start_x + _width;
			_inst.mousePressGui_x = _start_x + _width;
		}
	}

	return _inst;
}
	
function find_context(_string) {
	
	var _y		= -1;
	var _height	= ds_grid_height(contextGrid);

	for(var i = 0; i < _height; i++)
	{
		if ds_grid_get(contextGrid, 0, i) == _string
		{
			_y = i;
			break;
		}
	}

	return _y;
}
	
#endregion

#region Scripts

function scr_context_folder_HQspawn() {
	// Set heirarchy
	var _level = 1;

	with(oPlayer)
	{
		var _size = ds_list_size(contextInstList)
	
		// Check if not already in list
		for(var i = 0; i < _size; i++)
		{
			var _contextMenu = ds_list_find_value(contextInstList, i);
			if _contextMenu.level == _level
				exit;
		}
	}

	// Create context menu
	var _inst = create_context(mousePressGui_x, mousePressGui_y);

	if _inst == -1
		exit;
		
	with(_inst)
	{	
		// Set heirarchy
		level = _level;
	
		// Add buttons
		add_context("Spawn Infantry",	scr_context_spawn_inf,	 false);
		add_context("Spawn Transport",	scr_context_spawn_trans, false);
	
		// Update size
		event_user(0);
	}
}
	
function scr_context_folder_HABspawn() {
	
	if !instance_exists(oParUnit)
		exit;
		
	// Set heirarchy
	var _level = 1;

	with(oPlayer)
	{
		var _size = ds_list_size(contextInstList)
	
		// Check if not already in list
		for(var i = 0; i < _size; i++)
		{
			var _contextMenu = ds_list_find_value(contextInstList, i);
			if _contextMenu.level == _level
				exit;
		}
		
		var _instFind = instRightSelected;
	}

	// Create context menu
	var _inst = create_context(mousePressGui_x, mousePressGui_y);

	if _inst == -1
		exit;
		
	with(_inst)
	{	
		// Set heirarchy
		level = _level;
		
		if _instFind.resCarry >= unitResCost.inf
		{
			add_context("Spawn Infantry",	scr_context_spawn_inf,	 false);
		}
		else
		{
			add_context("Not Enough Resources",	on_click,	 false);
		}
	
		// Update size
		event_user(0);
	}
}
	
function scr_context_folder_LOGspawn() {
	
	if !instance_exists(oParUnit)
		exit;
	
	// Set heirarchy
	var _level = 1;

	with(oPlayer)
	{
		var _size = ds_list_size(contextInstList)
		
		// Check if not already in list
		for(var i = 0; i < _size; i++)
		{
			var _contextMenu = ds_list_find_value(contextInstList, i);
			if _contextMenu.level == _level
				exit;
		}
		
		var _instFind = instRightSelected;
	}
	
	// Create context menu
	var _inst = create_context(mousePressGui_x, mousePressGui_y);

	if _inst == -1
		exit;
				
	with(_inst)
	{	
		// Set heirarchy
		level = _level;
			
		// Check if there is enough money for a HAB
		if _instFind.resCarry >= unitResCost.HAB
		{
			var _oHAB = collision_circle(_instFind.x, _instFind.y, _instFind.resRange, oHAB, false, true);
			var _oHQ  = collision_circle(_instFind.x, _instFind.y, _instFind.resRange, oHQ, false, true);
			
			// Check if near a building
			if _oHAB > 0 || _oHQ > 0
				add_context("Too close to Building", on_click,	 false);
			else
				add_context("Spawn HAB", scr_context_spawn_HAB,	 false);
		}
		else
		{
			add_context("Not Enough Resources", on_click,	 false);
		}

		// Update size
		event_user(0);
	}
}
	
function scr_context_move() {
	with(oPlayer)
	{
		// Find goal
		var _mouse_x = mouseRightPress_x;
		var _mouse_y = mouseRightPress_y;
	}
	
	// Check for veh
	var _veh = collision_point(_mouse_x, _mouse_y, oTransport, false, true);

	// Get maximum width
	var _width = ds_grid_width(global.instGrid);

	// Move all instances selected
	for(var i = 0; i < _width; i++)
	{
		var _inst = ds_grid_get(global.instGrid, i, 0);
		
		if _inst == 0
			break;
		
		with(_inst)
		{
			// Reset state
			moveState = action.idle;
			
			// Enter vehicle
			if _veh
			{
				enterVeh = _veh;
				veh_position(enterVeh);
			}
			else
			{
				enterVeh	= noone;
				riding		= false;
				
				// set as goal
				goalX = mouse_x;
				goalY = mouse_y;
				
				if(_inst.object_index == oParSquad)
				{
					event_user(1);
				}
			}
		}
	}

	close_context(-1);
}
	
function scr_context_destroy() {
	
	with(oPlayer)
	{
		// Find goal
		var _mouse_x = mouseRightPress_x;
		var _mouse_y = mouseRightPress_y;
	}

	var _instFind = find_top_Inst(_mouse_x, _mouse_y, oParUnit);
	
	// Destroy HAB
	instance_destroy(_instFind);
	
	close_context(-1);
}

function scr_context_select_all() {
	var _size = ds_list_size(global.unitList)

	for(var i = 0; i < _size; i++)
	{	
		// Get inst
		var _inst = ds_list_find_value(global.unitList, i);
	
		// Check if exists
		if !instance_exists(_inst)
			break;
	
		// Check if not a building
		if _inst.object_index != oPlayer && _inst.moveSpd != 0
		{
			// Find name of selected instance		
			with _inst
			{
				// Add inst to hand
				add_Inst(global.instGrid, 0, id);
			
				selected = true;
			}
		}
	}

	close_context(-1);
}

function scr_context_select_onScreen() {
	
	// Get current camera position
	var _camX = camera_get_view_x(view_camera[0]);
	var _camY = camera_get_view_y(view_camera[0]);
	var _camW = camera_get_view_width(view_camera[0]);
	var _camH = camera_get_view_height(view_camera[0]);
	
	var _size = ds_list_size(global.unitList)

	for(var i = 0; i < _size; i++)
	{	
		// Get inst
		var _inst = ds_list_find_value(global.unitList, i);
	
		// Check if exists
		if !instance_exists(_inst)
			break;
	
		// Check if not a building
		if _inst.object_index != oPlayer && _inst.moveSpd != 0
		{
			// Find name of selected instance		
			with _inst
			{
				if bbox_right	> _camX
				&& bbox_left	< _camX + _camW
				&& bbox_bottom	> _camY
				&& bbox_top		< _camY + _camH
				{
					// Add inst to hand
					add_Inst(global.instGrid, 0, id);
					selected = true;
				}
			}
		}
	}

	close_context(-1);
}

function scr_context_drop_res() {
	// drop resources from transport to HAB
	with(oPlayer)
	{
		var _instFind = instRightSelected;
	}
	
	var _HAB = collision_circle(_instFind.x, _instFind.y, _instFind.resRange, oHAB, false, true);
	
	if _HAB
	{
		// Add to HAB
		_HAB.resCarry += _instFind.resCarry;
				
		// Take away from vehicle
		_instFind.resCarry = 0;
	}
	
	// Update context menu
	close_context(-1);
}

function scr_context_grab_res() {
	// Grab resources from HAB or HQ
	with(oPlayer)
	{
		var _instFind = instRightSelected;
	}
	
	if _instFind.object_index != oHAB
	{
		var _HAB = collision_circle(_instFind.x, _instFind.y, _instFind.resRange, oHAB, false, true);
		
		if _HAB.resCarry > 0
		{
			// Find needed resources
			var _reqRes = _instFind.maxResCarry - _instFind.resCarry;
			
			// Find how much resources other can supply
			_reqRes -= _HAB.resCarry;
			
			// Fill request
			if _reqRes - _HAB.resCarry < 0
			{
				_instFind.resCarry = _instFind.maxResCarry;
				_HAB.resCarry -= _instFind.maxResCarry;
			}
			else
			{
				_instFind.resCarry = _reqRes - _HAB.resCarry;
				_HAB.resCarry -= _HAB.resCarry;
				
			}
		}
	}
	else
	{
		// Find all transport vehicles in the area
		var _list = ds_list_create();
			
		var _amount = collision_circle_list(_instFind.x, _instFind.y, _instFind.resRange, oTransport, false, true, _list, false);
			
		for(var i = 0; i < _amount; i++)
		{
			var _veh = ds_list_find_value(_list, i);
				
			// Add to HAB
			_instFind.resCarry += _veh.resCarry;
				
			// Take away from vehicle
			_veh.resCarry = 0;
		}
			
		ds_list_destroy(_list);
	}
	
	// Update context menu
	close_context(-1);
}
	
function scr_context_spawn_inf() {
	with(oPlayer)
	{
		var _mouseX = mouseRightPress_x;
		var _mouseY = mouseRightPress_y;
		
		var _instFind = instRightSelected;
	}
		
	_instFind.resCarry -= unitResCost.inf;
	
	// Create instance
	spawn_unit("oInfantry", _mouseX, _mouseY);

	// Reset hand
	wipe_Hand(global.instGrid, 0);
	
	close_context(-1);
}
	
function scr_context_spawn_trans() {
	with(oPlayer)
	{
		var _mouseX = mouseRightPress_x;
		var _mouseY = mouseRightPress_y;
		
		var _instFind = instRightSelected;
	}
		
	_instFind.resCarry -= unitResCost.trans;
	
	// Create instance
	spawn_unit("oTransport", _mouseX, _mouseY);

	// Reset hand
	wipe_Hand(global.instGrid, 0);

	close_context(-1);
}
	
function scr_context_spawn_dummy() {
	with(oPlayer)
	{
		var _mouseX = mouseRightPress_x;
		var _mouseY = mouseRightPress_y;
	}
		
	// Create instance
	spawn_unit("oParSquad", _mouseX, _mouseY);

	// Reset hand
	wipe_Hand(global.instGrid, 0);

	close_context(-1);
}
	
function scr_context_spawn_HAB() {
	/*
	with(oPlayer)
	{
		var _mouseX = mouseRightPress_x;
		var _mouseY = mouseRightPress_y;
		
		var _instFind = instRightSelected;
	}
		
	_instFind.resCarry -= unitResCost.HAB;
	
	// Create instance
	spawn_unit("oHAB", _mouseX, _mouseY);

	// Reset hand
	wipe_Hand(global.instGrid, 0);
	*/
	create_building("oHAB");
	
	close_context(-1);
}
		
function spawn_unit(_object_string, posX, posY) {
	
	var _packet = packet_start(packet_t.add_unit);
	buffer_write(_packet, buffer_u64, oManager.user);
	buffer_write(_packet, buffer_string, _object_string);
	buffer_write(_packet, buffer_f32, posX);
	buffer_write(_packet, buffer_f32, posY);
	packet_send_all(_packet);
	
	var _object = asset_get_index(_object_string);
		
	// Create instance
	var _inst = instance_create_layer(posX, posY, "Instances", _object);
		
	// Add inst to list
	ds_list_add(global.unitList, _inst);
	
	// Resize holding grid
	var _width	= ds_grid_width(global.instGrid);
	var _height = ds_grid_height(global.instGrid);
	ds_grid_resize(global.instGrid, _width + 1, _height);
	
	return _inst;
}

#endregion

#endregion

#region GUI

#region Chat		Functions

function chat_add(_client, _text, _color) {
	
	#region Get ride of \n

	// Find next line
	var qPos = string_pos("\n", _text);
	var _chat_text = _text;
	
	// Loop for each new line
	while(qPos != 0)
	{
		// Get rid of new line
		_chat_text = string_delete(_chat_text, qPos, 1);
		
		// Find next new line
		qPos = string_pos("\n", _chat_text);
	}
		
	_text = _chat_text;
	
	#endregion
	
	// Add name
	_text = string(_client) + ": " + _text;
	
	#region Re-Add \n
	
	_chat_text			= "";
	var _nextSpace		= 0;
	var _piece_length	= 0;
	
	var _length = string_length(_text) + 1;
	
	for(var o = 0; o < _length + 1; o++)
	{	
		var _frontDelete	= string_delete(_text, o + 1, _length - o);
		var _backDelete		= string_delete(_frontDelete, 1, o - 1);
		
		_chat_text += _backDelete;
		string_delete(_chat_text, o + 1 , _length - o);
		
		// Get width
		var _width = currentLineWidth(_chat_text);
		
		// Find next space
		for(var k = 0; k < _length - _piece_length + 1; k++)
		{			
			var _check = string_char_at(_chat_text, k);
			
			if _check == " "
			{
				_nextSpace = k;	
				k = _nextSpace + 1;
			}
		}
		
		if _width > 420
		{			
			_piece_length = string_length(_chat_text);
			var _text_piece = string_delete(_chat_text, _nextSpace, _piece_length);
			
			// Add to chat
			ds_list_insert(global.chat, 0, _text_piece);
			ds_list_insert(global.chat_color, 0, _color);
			
			// Reset string
			_chat_text = string_delete(_chat_text, 1, _nextSpace - 1);
		}
		else
		{
			if o + 1 == _length
			{				
				// Add to chat
				ds_list_insert(global.chat, 0, _chat_text);
				ds_list_insert(global.chat_color, 0, _color);
			}
		}
	}
	
	#endregion
}

function chat_send(_string, _color) {

	with(oManager) 
	{
		if(lobby)
		{
		    var _packet = packet_start(packet_t.chat);
			buffer_write(_packet, buffer_u64, user);
		    buffer_write(_packet, buffer_string, _string);
			buffer_write(_packet, buffer_u16, _color);
		    packet_send_all(_packet);
		}
	}
}

function currentLineWidth(baseString) {
	var qPos = 1;
	
	// Add buffer
	baseString = string_insert(" ", baseString, 0)
	
	while(qPos != 0)
	{
	    baseString = string_delete(baseString, 1, qPos);
	    qPos = string_pos("\n", baseString);
	}
	
	return string_width(baseString);
}
	
#endregion

#region List scripts

// Host Type
function scr_GUI_list0() {
	steam_update_lobby();
}

// 1 is a break

// Map

// Spawn Points
function scr_GUI_list3() {
	// Update resources
	global.resources = ds_grid_get(global.savedSettings, 1, setting.spawn_points);
	
	with(oManager)
	{
		// Update everyone else
		var _buffer = packet_start(packet_t.data_map);
		buffer_write(_buffer, buffer_u64, user);
		buffer_write(_buffer, buffer_string, "resources");
		buffer_write(_buffer, buffer_s16, global.resources);
		packet_send_all(_buffer);
	}
}
	
// Color
function scr_GUI_list4() {		
	with(oManager)
	{
		// Hold previous color
		var _prevNumColor = numColor;
		
		// Find position
		numColor = ds_grid_get(global.savedSettings, 1, setting.color);
		
		// Compare to others
		var _size = ds_list_size(net_list);
		
		for(var i = 0; i < _size; i++)
		{
			var _id = ds_list_find_value(net_list, i);
			
			// Get data map
			var _dataMap	= ds_map_find_value(playerDataMap, string(_id));
			
			var _numColor	= ds_map_find_value(_dataMap, "numColor");
			
			// If its taken...
			if _numColor == numColor
			{
				// Check if cycling through or back list			
				if numColor - _prevNumColor > 0
				{
					// Skip to next color and check all others again
					numColor++;
					i = 0;
						
					// Check if its the last color
					if numColor == 9
					{
						// Reset it
						numColor = 1
						i = 0;
					}
				}
				else
				{
					// Skip to next color and check all others again
					numColor--;
					i = 0;
						
					// Check if its the last color
					if numColor == -1
					{
						// Reset it
						numColor = 8
						i = 0;
					}
				}
			}
		}
		
		// Set new position
		ds_grid_set(global.savedSettings, 1, setting.color, numColor);
		
		// Find color
		hashColor = findColor(numColor);
						
		// Update everyone else
		var _buffer = packet_start(packet_t.data_map);
		buffer_write(_buffer, buffer_u64, user);
		buffer_write(_buffer, buffer_string, "numColor");
		buffer_write(_buffer, buffer_s16, numColor);
		packet_send_all(_buffer);
	
		// Update GUI
		alarm[3] = 1;
	}
}

// Fullscreen
function scr_GUI_list8() {
	// Get data
	var _windowType = ds_grid_get(global.savedSettings, 1, setting.fullscreen);

	with(oManager)
	{
		window_set_fullscreen(_windowType);
	
		// --- Reset Settings
	
		// Resolution
		global.RES_W = display_get_width();
		global.RES_H = display_get_height();
	
		if !_windowType
		{
			// Resolution
			global.RES_W = 1920;
			global.RES_H = 1080;
	
			aspect_ratio = global.RES_W / global.RES_H;
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
		
		// Zoom
		zoom = 1;
		
		// Reset menu
		reset_menu();
	}
}

// Game Mode
function scr_GUI_list13() {
	
	with(oManager)
	{
		// Update GUI
		alarm[3] = 1;
	}
	
	scr_GUI_list14();
}

// Team
function scr_GUI_list14() {
	
	// Get data
	var _gameMode = ds_grid_get(global.savedSettings, 1, setting.game_mode);
	
	with(oManager)
	{	
		// Update team
		team = ds_grid_get(global.savedSettings, 1, setting.team_number) + 1;
		
		// Update team
		if _gameMode == 0
			team = 0;
			
		// Update position
		ds_grid_set(global.savedSettings, 1, setting.team_number, 0);
		
		// Send new team number
		var _buffer = packet_start(packet_t.data_map);
	
		buffer_write(_buffer, buffer_u64, user);
		buffer_write(_buffer, buffer_string, "team");
		buffer_write(_buffer, buffer_s16, team);
	
		packet_send_all(_buffer);
		
		// Send gamemode
		_buffer = packet_start(packet_t.data_map);
		
		buffer_write(_buffer, buffer_u64, user);
		buffer_write(_buffer, buffer_string, "game_mode");
		buffer_write(_buffer, buffer_s16, _gameMode);
		
		packet_send_all(_buffer);
	}
}

#endregion

function get_hover(_x1, _y1, _x2, _y2) {

	var _mouseX = device_mouse_x_to_gui(0);
	var _mouseY = device_mouse_y_to_gui(0);

	return point_in_rectangle(_mouseX, _mouseY, _x1, _y1, _x2, _y2);


}
	
function on_click() {
	show_debug_message("Button clicked: " + text);
}

function reset_menu() {
	// Find size
	var _size = ds_list_size(inst_list);
	
	for(var i = 0; i < _size; i++)
	{
		// Find and destroy button
		instance_destroy(ds_list_find_value(inst_list, i))
	}
	
	// Reset list
	ds_list_clear(inst_list);

	// Update Chat, just for fun
	chatX = global.RES_W - 500;
	chatY = global.RES_H - 100;
}


#endregion