#region Debugging	Functions

function print(_value) {
	show_debug_message(_value)
}

function syntaxErrorRemover()
{
	// Calls all scripts not being used so that they wont show up

	syntaxErrorRemover();

	scr_GUI_list0();
	scr_GUI_list13();
	scr_GUI_list14();
	scr_GUI_list3();
	scr_GUI_list4();
	scr_GUI_list8();

	scr_context_select_all();

	wipe_Deck(-1);
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

function create_building(_object) {
	// Accepts a string

	with(oPlayer)
	{
		// Create empty ghost to find sprite
		buildingPlacement = instance_create_layer(0, 0, "AboveAll", _object);

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

	if(state != -1)
	{
		// Find self in list
		var _pos = ds_list_find_index(global.unitList, id)

		// Send position and rotation to others
		var _packet = packet_start(packet_t.update_unit);
		buffer_write(_packet, buffer_u64, oNetwork.steamUserName);
		buffer_write(_packet, buffer_u16, _pos);
		buffer_write(_packet, buffer_s8, state);
		packet_send_all(_packet);
	}

	#endregion
}

#endregion

#endregion

#region Pathfinding

function find_nearest_empty_space(_pathGoalX, _pathGoalY) {
    var hcells = room_width div grid_cell_width;
    var vcells = room_height div grid_cell_height;

    // Convert target coordinates to grid coordinates
    var gridX = floor(_pathGoalX / grid_cell_width);
    var gridY = floor(_pathGoalY / grid_cell_height);

    // Check if the initial position is free
    if (mp_grid_get_cell(global.grid, gridX, gridY) == 0)
        return [_pathGoalX, _pathGoalY];

    // Initialize the BFS
    var queue = ds_queue_create();
    ds_queue_enqueue(queue, [gridX, gridY]);

    // Keep track of visited cells
    var visited = ds_grid_create(hcells, vcells);
    ds_grid_set_region(visited, 0, 0, hcells - 1, vcells - 1, 0);

    // Directions for 8 neighboring cells (N, NE, E, SE, S, SW, W, NW)
    var directions = [
        [1, 0], [-1, 0], [0, 1], [0, -1], 
        [1, 1], [-1, -1], [1, -1], [-1, 1]
    ];

    while (ds_queue_size(queue) != 0) {
        var current = ds_queue_dequeue(queue);
        var curX = current[0];
        var curY = current[1];

        // Check all 8 neighboring cells
        for (var i = 0; i < array_length(directions); i++) {
            var checkX = curX + directions[i][0];
            var checkY = curY + directions[i][1];

            // Boundary check and visited check
            if (checkX >= 0 && checkY >= 0 && checkX < hcells && checkY < vcells && ds_grid_get(visited, checkX, checkY) == 0) {
                // Mark cell as visited
                ds_grid_set(visited, checkX, checkY, 1);

                // Check if the cell is empty
                if (mp_grid_get_cell(global.grid, checkX, checkY) == 0) {
                    ds_queue_destroy(queue);
                    ds_grid_destroy(visited);
                    return [checkX * grid_cell_width, checkY * grid_cell_height];
                }

                // Enqueue the cell
                ds_queue_enqueue(queue, [checkX, checkY]);
            }
        }
    }

    ds_queue_destroy(queue);
    ds_grid_destroy(visited);

    print("Error with Pathfinding");
    return [_pathGoalX, _pathGoalY];
}

function path_goal_find(startX, startY, _pathGoalX, _pathGoalY, _path) {

	if(mp_grid_path(global.grid, _path, startX, startY, _pathGoalX, _pathGoalY, true))
	{
		var _pathAmount = path_get_number(_path);

		// Shorten path
		if _pathAmount > 2
		{
			var x1, y1, x2, y2;

			// See if you can skip to the end
			var _startPointX	= path_get_point_x(_path, 0);
			var _startPointY	= path_get_point_y(_path, 0);
			var _endpointX		= path_get_point_x(_path, _pathAmount-1);
			var _endpointY		= path_get_point_y(_path, _pathAmount-1);

			if !collision_line(_startPointX, _startPointY, _endpointX, _endpointY, oCollision, false, true)
			{
				// Cut out the middle points
				while(path_get_number(_path) > 2)
				{
					path_delete_point(_path, 1);
				}
			}
			/*
			else
			{
				for(var i = 1; i < _pathAmount - 1; i++)
				{
					x1 = path_get_point_x(_path, i - 1)
					y1 = path_get_point_y(_path, i - 1)

					x2 = path_get_point_x(_path, i + 1)
					y2 = path_get_point_y(_path, i + 1)

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
						path_delete_point(_path, i);

						_pathAmount--;

						i--;
					}
				}
			}
			*/
		}
	}
	else
	{
		print("Error pathfinding. Could not avoid obstacle.");
		var i = 0
		while path_get_length(path) > 0
			path_delete_point(path, 0)
		
		return false;
	}
	
	return true;
}

function path_goal_multiplayer_update(_x, _y, _pathGoalX, _pathGoalY) {
	// Find self in list
	var _pos = ds_list_find_index(global.unitList, id)

	// Send position and rotation to others
	var _packet = packet_start(packet_t.move_unit);
	buffer_write(_packet, buffer_u64, oNetwork.steamUserName);
	buffer_write(_packet, buffer_u16, _pos);
	buffer_write(_packet, buffer_f32, _x);
	buffer_write(_packet, buffer_f32, _y);
	buffer_write(_packet, buffer_f32, _pathGoalX);
	buffer_write(_packet, buffer_f32, _pathGoalY);
	packet_send_all(_packet);
}

/*
Returns [Direction towards next point, the path, and if the path is finished]
*/
function path_point_direction(_x, _y, _dist, _path) {
	// Loop until next point is found
	while(true)
	{
		// Get amount left
		var _amount = path_get_number(_path);

		// Get next waypoint
		var xx = path_get_x(_path, 0);
		var yy = path_get_y(_path, 0);

		// Delete waypoint if arrived
		if point_distance(x, y, xx, yy) > _dist
			break;

		// Stop path
		if _amount > 1
		{
			path_delete_point(_path, 0);
			break;
		}

		return [0, _path, true];
	}

	var _dir = point_direction(x, y, xx, yy);
	return [_dir, _path, false];
}

function path_grid_reset() {
	var hcells = room_width div grid_cell_width;
	var vcells = room_height div grid_cell_height;

	mp_grid_destroy(global.grid);
	global.grid = mp_grid_create(0, 0, hcells, vcells, grid_cell_width, grid_cell_height);

	path_grid_update();
}

function path_grid_update() {
	// Clear grid
	mp_grid_clear_all(global.grid);

	// Add walls
	mp_grid_add_instances(global.grid, oParWall, false);

	// Add stationary buildings & weapons
	for(var i = 0; i < instance_number(oParUnit); i++)
	{
		var _instance = instance_find(oParUnit, i);

		if _instance.movementSpeed == 0
			mp_grid_add_instances(global.grid, _instance, false);
	}

	/*
	// Add stationary buildings & weapons for client
	for(var i = 0; i < instance_number(oParUnitClient); i++)
	{
		var _instance = instance_find(oParUnitClient, i);

		if _instance.movementSpeed == 0
			mp_grid_add_instances(global.grid, _instance, false);
	}
	*/
}

function path_finished() {
	
	if point_distance(x, y, goal_x, goal_y) < speed*2
		return true
	
	var _answer_array = path_point_direction(x, y, speed*2, path);

	direction	= _answer_array[0];
	path		= _answer_array[1];
	var _path_finished	= _answer_array[2];

	return _path_finished;
}

#endregion

#region Steam		Functions

#region Helper Scripts

function steam_get_user_persona_name_w(_id) {
	// Display name fetching with caching

	// Change to string and add an ID to it
	_name = "id" + string(_id);

	// Find ID in list
	var _name = oNetwork.names[?_id];

	// Check if it returns positive
	if (_name == undefined)
	{
		// Get name using ID
	    steam_get_user_persona_name(_id);

		// Remember it
	    oNetwork.names[?_id] = _name;
	}
	return _name;
}

function steam_reset_state() {
	with(oNetwork)
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

		var _length = ds_list_size(net_list);

		for(var i = 0; i < _length; i++)
		{
			// Find key
			var _key = ds_list_find_value(net_list, i);

			// Find list of objects under map
			var _map = ds_map_find_value(global.multiInstMap, _key);

			// Add all instances to a list
			var _list = ds_map_values_to_array(_map);

			// Cycle through list and destroy objects
			if(!is_undefined(_list))
			{
				#region List

				_length = array_length(_list);

				for(var i = 0; i < _length; i++)
				{
					// Find object
					_inst = _list[i];

					// Destroy it
					if(instance_exists(_inst) && _inst > 1000)
						instance_destroy(_inst);
				}

				ds_map_destroy(_map);

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

		global.resources		= 0;
		global.resources_max	= global.resources;

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
		ds_map_set(playerDataMap, from, _dataMap);

		// Ask for data
		_buffer = packet_start(packet_t.data_update_request);
		buffer_write(_buffer, buffer_u64, steamUserName);
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
			ds_map_set(playerDataMap, from, _dataMap);

			// Ask for data
			var _buffer = packet_start(packet_t.data_update_request);
			buffer_write(_buffer, buffer_u64, steamUserName);
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
				var _map = ds_map_create();

				// Create slot for players
				ds_map_set(global.multiInstMap, _id, _map);
			}

	        break;

		case packet_t.add_unit:

			var _from			= buffer_read(_buffer, buffer_u64);
			var _pos			= buffer_read(_buffer, buffer_u16);
			var _object_string	= buffer_read(_buffer, buffer_string);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);

			var _object = asset_get_index(_object_string + "Client");

			// Create instance
			var _inst	= instance_create_layer(posX, posY, "Instances", _object);

			// Find list
			var _map	= ds_map_find_value(global.multiInstMap, _from);

			// Add inst to map
			ds_map_add(_map, _pos, _inst);

			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, _from);

			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hash_color");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");

			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hash_color		= _hashColor;

				// Give drone a name
				if _object_string == "oPlayer"
					playerName = steam_get_user_persona_name_w(from);
			}

			//dbg(string(_inst) + " - " + object_get_name(_inst.object_index) + " is being added");

			break;

		case packet_t.add_attached_unit:

			var _from			= buffer_read(_buffer, buffer_u64);
			var _pos			= buffer_read(_buffer, buffer_u16);
			var _object_string	= buffer_read(_buffer, buffer_string);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);
			var _parentPos		= buffer_read(_buffer, buffer_u16);

			var _object		= asset_get_index(_object_string + "Client");

			// Create instance
			var _inst		= instance_create_layer(posX, posY, "Instances", _object);

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, _from);

			// Add inst to list
			ds_map_add(_map, _pos, _inst);

			// Find Unit
			var _parent		= ds_map_find_value(_map, _parentPos);

			// Get data map
			var _dataMap	= ds_map_find_value(playerDataMap, _from);

			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hash_color");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");

			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hash_color		= _hashColor;

				// Add parent
				squadID			= _parent;
			}

			// Add to parentlist
			with(_parent)
			{
				ds_list_add(childList, _inst);
			}

			//dbg(string(_inst) + " - " + object_get_name(_inst.object_index) + " is being added with a parent");

			break;

		case packet_t.destroy_unit:

			// Check if still in game
			if !inGame
				break;

			var _from		= buffer_read(_buffer, buffer_u64);
			var _posList	= buffer_read(_buffer, buffer_u16);

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, _from);

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

			// Destroy unit
			if(!is_undefined(_unit))
				instance_destroy(_unit);

			//dbg(string(_unit) + " - " + object_get_name(_unit.object_index) + " is destroyed");

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
			var _map		= ds_map_find_value(global.multiInstMap, _from);

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

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
					goal_x = _goalX;
					goal_y = _goalY;

					//path_goal_find();
				}
				else
				{
					// Just move player
					x = _x;
					y = _y;
				}
			}

			//dbg(string(_unit) + " - " + object_get_name(_unit.object_index) + " is moving");

			break;

		case packet_t.veh_interact:

			// Check if still in game
			if !inGame
				break;

			// Get data
			var _from			= buffer_read(_buffer, buffer_u64);
			var _posList		= buffer_read(_buffer, buffer_u16);
			var _interaction	= buffer_read(_buffer, buffer_u8);

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, from)

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

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

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, _from);

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

			if is_undefined(_unit) || !instance_exists(_unit)
				break;

			with(_unit)
			{
				// Set moveState
				if _newState != -1
					state = _newState;

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
			var _bullet = instance_create_layer(_x, _y, "Bullets", oBullet_old);

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
			var _dataMap = ds_map_find_value(playerDataMap, _from);

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
					ds_map_set(_dataMap, "hash_color", _color);

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

					buffer_write(_buffer, buffer_u64, steamUserName);
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
			buffer_write(_buffer, buffer_u64, steamUserName);

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
			var _dataMap = ds_map_find_value(playerDataMap, _from);

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
			ds_map_set(_dataMap, "hash_color",	_colorHash);
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
				buffer_write(_buffer, buffer_u64, steamUserName);
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
	        buffer_write_int64(_buffer, steamUserName);
	        packet_send_all(_buffer);

			// Get data
			_string = "left the game.";
			_color = color.orange;

			// Get data
			var _name = steam_get_user_persona_name_w(steamUserName);

			// show a notice in chat:
			chat_add(_name, _string, _color);

	        break;

		case packet_t.add_unit:

			var _from			= buffer_read(_buffer, buffer_u64);
			var _pos			= buffer_read(_buffer, buffer_u16);
			var _object_enum	= buffer_read(_buffer, buffer_u8);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);

			var _buffer = packet_start(packet_t.add_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _pos);
			buffer_write(_buffer, buffer_u8, _object_enum);
			buffer_write(_buffer, buffer_f32, posX);
			buffer_write(_buffer, buffer_f32, posY);
			packet_send_except(_buffer, from);

			var _object = enum_to_obj(_object_enum);

			// Create instance
			var _inst	= instance_create_layer(posX, posY, "Instances", _object);

			// Find list
			var _map	= ds_map_find_value(global.multiInstMap, _from);

			// Add inst to list
			ds_map_add(_map, _pos, _inst);

			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, _from);

			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hash_color");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");

			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hash_color		= _hashColor;

				// Give drone a name
				if _object_string == "oPlayer"
					playerName = steam_get_user_persona_name_w(from);
			}

			//dbg(string(_inst) + " - " + object_get_name(_inst.object_index) + " is being added");

			break;

		case packet_t.add_attached_unit:

			var _from			= buffer_read(_buffer, buffer_u64);
			var _pos			= buffer_read(_buffer, buffer_u16);
			var _object_enum	= buffer_read(_buffer, buffer_u8);
			var posX			= buffer_read(_buffer, buffer_f32);
			var posY			= buffer_read(_buffer, buffer_f32);
			var _parentPos		= buffer_read(_buffer, buffer_u16);

			var _buffer = packet_start(packet_t.add_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _pos);
			buffer_write(_buffer, buffer_u8, _object_enum);
			buffer_write(_buffer, buffer_f32, posX);
			buffer_write(_buffer, buffer_f32, posY);
			buffer_write(_buffer, buffer_u16, _parentPos);
			packet_send_except(_buffer, from);

			var _object		= enum_to_obj(_object_enum);

			// Create instance
			var _inst		= instance_create_layer(posX, posY, "Instances", _object);

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, _from);

			// Add inst to list
			ds_map_add(_map, _pos, _inst);

			// Find Unit
			var _parent		= ds_map_find_value(_map, _parentPos);

			// Get data map
			var _dataMap	= ds_map_find_value(playerDataMap, from);

			// Get data
			var _team		= ds_map_find_value(_dataMap, "team");
			var _hashColor	= ds_map_find_value(_dataMap, "hash_color");
			var _numColor	= ds_map_find_value(_dataMap, "numColor");

			with(_inst)
			{
				// Transfer data
				team			= _team;
				numColor		= _numColor;
				hash_color		= _hashColor;

				// Add parent
				squadID			= _parent;
			}

			// Add to parentlist
			with(_parent)
			{
				ds_list_add(childList, _inst);
			}

			//dbg(string(_inst) + " - " + object_get_name(_inst.object_index) + " is being added and recieving a parent");

			break;

		case packet_t.destroy_unit:

			// Check if still in game
			if !inGame
				break;

			var _from		= buffer_read(_buffer, buffer_u64);
			var _posList	= buffer_read(_buffer, buffer_u16);

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, _from);

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

			// Destroy unit
			if(!is_undefined(_unit))
				instance_destroy(_unit);

			// Tell others to do the same
			var _buffer = packet_start(packet_t.destroy_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _posList);
			packet_send_except(_buffer, from);

			//dbg(string(_unit) + " - " + object_get_name(_unit.object_index) + " is destroyed");

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
			var _map		= ds_map_find_value(global.multiInstMap, from);

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

			//dbg(string(_unit) + " - " + object_get_name(_unit.object_index) + " is moving");

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
					goal_x = _goalX;
					goal_y = _goalY;

					//path_goal_find();
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
			var _from			= buffer_read(_buffer, buffer_u64);
			var _posList		= buffer_read(_buffer, buffer_u16);
			var _interaction	= buffer_read(_buffer, buffer_u8);

			var _buffer = packet_start(packet_t.veh_interact);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _posList);
			buffer_write(_buffer, buffer_u8, _interaction);
			packet_send_except(_buffer, from);

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, from)

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

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

			var _buffer = packet_start(packet_t.update_unit);
			buffer_write(_buffer, buffer_u64, _from);
			buffer_write(_buffer, buffer_u16, _posList);
			buffer_write(_buffer, buffer_s8, _newState);
			packet_send_except(_buffer, from);

			// Find list
			var _map		= ds_map_find_value(global.multiInstMap, _from);

			// Find Unit
			var _unit		= ds_map_find_value(_map, _posList);

			if is_undefined(_unit) || !instance_exists(_unit)
				break;

			with(_unit)
			{
				// Set State
				if _newState != -1
					state = _newState;

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
			var _bullet = instance_create_layer(_x, _y, "Bullets", oBullet_old);

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
					var _dataMap = ds_map_find_value(playerDataMap, _from);

					// Set data
					ds_map_set(_dataMap, "hash_color", _color);

					break;

				case "game_mode":

					ds_grid_set(global.savedSettings, 1, setting.game_mode, _data);

					// Send new team number
					var _buffer = packet_start(packet_t.data_map);

					buffer_write(_buffer, buffer_u64, steamUserName);
					buffer_write(_buffer, buffer_string, "team");
					buffer_write(_buffer, buffer_s16, team);

					packet_send_all(_buffer);

					// Update GUI
					alarm[3] = 1;

					break;
			}

			// Get data map
			var _dataMap = ds_map_find_value(playerDataMap, _from);

			// Set data
			ds_map_set(_dataMap, _key, _data);

			break;

		case packet_t.data_update_request:

			// Find who asked
			var _from	= buffer_read(_buffer, buffer_u64);

			// Make a Header
			var _buffer = packet_start(packet_t.data_update_packet);

			// Write who is sending this
			buffer_write(_buffer, buffer_u64, steamUserName);

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
			var _dataMap = ds_map_find_value(playerDataMap, _from);

			// Get data from buffer
			var _ready		= buffer_read(_buffer, buffer_s16);

			var _numColor	= buffer_read(_buffer, buffer_s16);

			var _team		= buffer_read(_buffer, buffer_s16);

			// Get color
			var _hashColor	= findColor(_numColor);

			// Set data
			ds_map_set(_dataMap, "numColor",	_numColor);
			ds_map_set(_dataMap, "hash_color",	_hashColor);
			ds_map_set(_dataMap, "ready",		_ready);
			ds_map_set(_dataMap, "team",		_team);

			break;
	}
}

function packet_handle_leaving(steamID) {

	ds_list_delete(net_list, ds_list_find_index(net_list, steamID));
	ds_map_delete(net_map, steamID);

	ds_map_delete(playerDataMap, steamID);

	// Get current size
	var _lobbyCurrent	= steam_lobby_get_member_count();

	// Update lobby current size
	steam_lobby_set_data("game_size_current", string(_lobbyCurrent));

	if(state == menu.inGame)
	{
		// Find list of objects under map
		var _map = ds_map_find_value(global.multiInstMap, steamID);

		// Add all instances to a list
		var _list = ds_map_values_to_array(_map);

		// Cycle through list and destroy objects
		if(!is_undefined(_list))
		{
			#region List

			var _length = array_length(_list);

			for(var i = 0; i < _length; i++)
			{
				// Find object
				var _inst = _list[i];

				// Destroy it
				if(instance_exists(_inst) && _inst > 1000)
					instance_destroy(_inst);
			}

			ds_map_destroy(_map);

			ds_map_delete(global.multiInstMap, steamID);

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
	with (oNetwork)
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

	with (oNetwork)
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

function spawn_unit(_object, posX, posY) {

	// Create instance
	var _inst = instance_create_layer(posX, posY, "Instances", _object);

	// Add inst to list
	ds_list_add(global.unitList, _inst);

	// Resize holding grid
	var _width	= ds_grid_width(global.instGrid);
	var _height = ds_grid_height(global.instGrid);
	ds_grid_resize(global.instGrid, _width + 1, _height);

	// Find position
	var _pos = ds_list_find_index(global.unitList, _inst);

	// Create unit client side
	var _packet = packet_start(packet_t.add_unit);
	buffer_write(_packet, buffer_u64, oNetwork.steamUserName);
	buffer_write(_packet, buffer_u16, _pos);
	buffer_write(_packet, buffer_u8, _object);
	buffer_write(_packet, buffer_f32, posX);
	buffer_write(_packet, buffer_f32, posY);
	packet_send_all(_packet);

	return _inst;
}

function packet_start(_type) {

	var _buffer = oNetwork.outbuf;

	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, _type);

	return _buffer;
}

// Unoptimized way of saying you are ready in a lobby to play
function readyChange() {
	// Access parent
	with(parent)
	{
		ready = !ready;

		playersReady += (ready * 2) - 1;

		var _buffer = packet_start(packet_t.data_map);
		buffer_write(_buffer, buffer_u64, steamUserName);
		buffer_write(_buffer, buffer_string, "ready");
		buffer_write(_buffer, buffer_s16, ready);
		packet_send_all(_buffer);

		// Update menu
		reset_menu();
	}
}

// Links a number color to a hashtag color
// Used to save bytes on networking packages
function findColor(_numColor) {

	var _hashColor = c_white;

	// Get color
	switch _numColor
	{
		case 0: _hashColor = c_white	break;
		case 1: _hashColor = c_red		break;
		case 2: _hashColor = c_orange		break;
		case 3: _hashColor = c_yellow		break;
		case 4: _hashColor = c_green		break;
		case 5: _hashColor = c_blue		break;
		case 6: _hashColor = c_blue		break;
		case 7: _hashColor = c_purple		break;
		case 8: _hashColor = c_maroon		break;
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

function add_context(_string, _scriptID, _folder, _scriptArg=-1) {

	var _cm_grid = cm_grid;

	// Make sure context is not in list
	if _string != "break"
	{
		var _check = find_context(_string);

		if _check != -1
			exit;
	}

	var _height = ds_grid_height(_cm_grid)

	for(var i = 0; i < _height; i++)
	{
		var _findSlot = ds_grid_get(_cm_grid, 0, i);

		if _findSlot == 0
		{
			ds_grid_set(_cm_grid, 0, i, _string);
			ds_grid_set(_cm_grid, 1, i, _scriptID);
			ds_grid_set(_cm_grid, 2, i, _folder);
			ds_grid_set(_cm_grid, 3, i, _scriptArg);
			break;
		}
		else
		{
			// Resize if too small
			if i+1 == _height
			{
				// Resize grid
				ds_grid_resize(_cm_grid, ds_grid_width(_cm_grid)+1, i+2);

				// Add value
				ds_grid_set(_cm_grid, 0, i+1, _string);
				ds_grid_set(_cm_grid, 1, i+1, _scriptID);
				ds_grid_set(_cm_grid, 2, i+1, _folder);
				ds_grid_set(_cm_grid, 3, i+1, _scriptArg);
			}
		}
	}
}

function close_context(_inst, _level=0) {

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
				var _context_inst = ds_list_find_value(contextInstList, i);
				
				if !instance_exists(_context_inst) {
					ds_list_delete(contextInstList, i);
					continue
				}
				
				if _level > _context_inst.level
					continue
					
				instance_destroy(_context_inst);
				ds_list_delete(contextInstList, i);
			}

			// Close context menu
			contextMenu = false;
		} else {
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
	}

	return _inst;
}

function find_context(_string) {
	
	var _cm_grid = instance_find(oContextMenu, 0).cm_grid;

	var _y		= -1;
	var _height	= ds_grid_height(_cm_grid);

	for(var i = 0; i < _height; i++)
	{
		if ds_grid_get(_cm_grid, 0, i) == _string
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
	var _inst = create_context(mp_gui_x, mp_gui_y);

	if _inst == -1
		exit;

	with(_inst)
	{
		// Set heirarchy
		level = _level;

		// Add buttons
		add_context("Spawn Infantry",	scr_create_squad, false, [mouse_x, mouse_y, oInfantry, 5]);
		//add_context("Spawn Transport",	scr_context_spawn_trans, false);

		// Update size
		event_user(0);
	}
}

function scr_context_folder_behavior() {
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
	var _inst = create_context(mp_gui_x, mp_gui_y);

	with(_inst)
	{
		// Set heirarchy
		level = _level;

		// Add buttons
		add_context("Set Passive",		scr_context_behavior,	 false, ["b_passive"]);
		add_context("Set Aggressive",	scr_context_behavior,	 false, ["b_aggressive"]);
		add_context("Set Defensive",	scr_context_behavior,	 false, ["b_defensive"]);

		// Update size
		event_user(0);
	}
}
	
function scr_context_folder_waypoint() {
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
	var _inst = create_context(mp_gui_x, mp_gui_y);

	with(_inst)
	{
		// Set heirarchy
		level = _level;

		// Add buttons
		add_context("Attack",	scr_context_waypoint,	 false, ["Attack"]);
		add_context("Defend",	scr_context_waypoint,	 false, ["Defend"]);
		add_context("Recon",	scr_context_waypoint,	 false, ["Recon"]);
		add_context("Patrol",	scr_context_waypoint_folder,	 true,	["Patrol"]);
		add_context("Retreat",	scr_context_waypoint,	 false, ["Retreat"]);

		// Update size
		event_user(0);
	}
}

function scr_context_waypoint_folder(_waypoint) {
	// Set heirarchy
	var _level = 2;

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
	var _inst = create_context(mp_gui_x, mp_gui_y);

	with(_inst)
	{
		// Set heirarchy
		level = _level;

		// Add buttons
		add_context("New Group",	scr_context_waypoint,	 false, ["Patrol"]);

		// Update size
		event_user(0);
	}
}

function scr_context_waypoint(_waypoint) {
	var _inst = instance_find(oContextMenu, 0)
	var _x = _inst.mp_gui_x;
	var _y = _inst.mp_gui_y;
	var _waypoint_inst = instance_create_layer(_x, _y, "UI", oWaypoint);
	
	with(_waypoint_inst)
	{
		type = _waypoint
		event_user(0)
	}
	
	close_context(-1);
}

function scr_context_move(movement_type=noone) {
	with(oPlayer)
	{
		// Find goal
		var _mouse_x = mouseRightPress_x;
		var _mouse_y = mouseRightPress_y;
	}

	// Get maximum width
	var _width = ds_grid_width(global.instGrid);

	var _set_type;

	// Move all instances selected
	for(var i = 0; i < _width; i++)
	{
		var _inst = ds_grid_get(global.instGrid, i, 0);

		if !instance_exists(_inst)
			continue;

		if _inst.object_index != oInfantry
			continue;

		with(_inst)
		{
			switch(movement_type)
			{
				case "m_scout":
					_set_type = m_scout;
					break;
				case "m_retreat":
					_set_type = m_retreat;
					break;
				case "m_capture":
					_set_type = m_capture;
					break;
				case "m_patrol":
					_set_type = m_patrol;
					break;
				case "m_roam":
					_set_type = m_roam;
					break;
				case "m_protect":
					_set_type = m_protect;
					break;
				case "m_follow":
					_set_type = m_follow;
					break;
				case "m_engage":
					_set_type = m_engage;
					break;
				case "m_haste":
					_set_type = m_haste;
					break;
				case "m_move":
				default: _set_type = m_move;
			}

			// Drop instance
			release = false;

			// Set goal
			goal_x	= _mouse_x + random_range(-30, 30);
			goal_y	= _mouse_y + random_range(-30, 30);

			b_sm.swap(b_idle)
			m_sm.swap(_set_type);

			// event_user(1);
		}
	}

	close_context(-1);
}

function scr_context_behavior(_behavior) {
	var _width = ds_grid_width(global.instGrid);

	var _set_type;

	for(var i = 0; i < _width; i++)
	{
		var _inst = ds_grid_get(global.instGrid, i, 0);

		if !instance_exists(_inst)
			continue;

		if _inst.object_index != oInfantry
			continue;

		with(_inst)
		{
			switch(_behavior)
			{
				case "b_defensive":
					_set_type = b_defensive;
					break;
				case "b_aggressive":
					_set_type = b_aggressive;
					break;
				case "b_passive":
				default: _set_type = b_passive;
			}

			// Drop instance
			//release = false;

			b_sm.swap(_set_type);

			// event_user(1);
		}
	}

	close_context(-1);
}

function scr_context_destroy(_inst=noone) {

	if _inst == noone
	{
		with(oPlayer)
		{
			// Find goal
			var _mouse_x = mouseRightPress_x;
			var _mouse_y = mouseRightPress_y;
		}
		
		_inst = find_top_Inst(_mouse_x, _mouse_y, oParUnit);
	}
		
	instance_destroy(_inst);

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

		if _inst.object_index == oParSite
			break;

		// Check if not a building
		if _inst.object_index == oPlayer
			break;

		// Find name of selected instance
		with _inst
		{
			// Add inst to hand
			add_Inst(global.instGrid, 0, id);

			selected = true;
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

		if _inst.object_index == oParSite
			break;

		if _inst.object_index == oPlayer
			break;

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

	close_context(-1);
}

function scr_context_spawn_object() {
	var _amount = 1;
	var _object = noone;

	switch(argument_count)
	{
		case 2:
			_amount = argument[1];
		case 1:
			var _object = argument[0];
	}

	var right_selected = oPlayer.instRightSelected;
	var _x = mouse_x;
	var _y = mouse_y;

	if instance_exists(right_selected)
	{
		_x = right_selected.x;
		_y = right_selected.y+32;
	}

	repeat(_amount)
		spawn_unit(_object, _x, _y);

	close_context(-1);
}

function scr_create_squad(_x, _y, _object, _amount) {
	var _squad_list = ds_list_create()
	var _inst;

	repeat(_amount)
	{
		_inst = spawn_unit(_object, _x, _y);
		ds_list_add(_squad_list, _inst);
	}
	
	create_squad(_squad_list)
	ds_list_destroy(_squad_list)

	close_context(-1);
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

	with(oNetwork)
	{
		if(lobby)
		{
		    var _packet = packet_start(packet_t.chat);
			buffer_write(_packet, buffer_u64, steamUserName);
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

	with(oNetwork)
	{
		// Update everyone else
		var _buffer = packet_start(packet_t.data_map);
		buffer_write(_buffer, buffer_u64, steamUserName);
		buffer_write(_buffer, buffer_string, "resources");
		buffer_write(_buffer, buffer_s16, global.resources);
		packet_send_all(_buffer);
	}
}

// Color
function scr_GUI_list4() {
	with(oNetwork)
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
			var _dataMap	= ds_map_find_value(playerDataMap, _id);

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
		hash_color = findColor(numColor);

		// Update everyone else
		var _buffer = packet_start(packet_t.data_map);
		buffer_write(_buffer, buffer_u64, steamUserName);
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

	with(oNetwork)
	{
		window_set_fullscreen(_windowType);

		// --- Reset Settings

		// Resolution
		global.RES_W = display_get_width();
		global.RES_H = display_get_height();

		if !_windowType
		{
			// Resolution
			global.RES_W *= 0.5;
			global.RES_H *= 0.5;

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

	with(oNetwork)
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

	with(oNetwork)
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

		buffer_write(_buffer, buffer_u64, steamUserName);
		buffer_write(_buffer, buffer_string, "team");
		buffer_write(_buffer, buffer_s16, team);

		packet_send_all(_buffer);

		// Send gamemode
		_buffer = packet_start(packet_t.data_map);

		buffer_write(_buffer, buffer_u64, steamUserName);
		buffer_write(_buffer, buffer_string, "game_mode");
		buffer_write(_buffer, buffer_s16, _gameMode);

		packet_send_all(_buffer);
	}
}

#endregion

function get_hover(_x1, _y1, _x2, _y2, gui=true) {
	
	var _mouseX, _mouseY
	
	if gui {
		_mouseX = device_mouse_x_to_gui(0);
		_mouseY = device_mouse_y_to_gui(0);
	}
	else {
		_mouseX = mouse_x;
		_mouseY = mouse_y;
	}
	
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

#region Audio

function randAudio(_asset, _maxAssets, _volume, _outVolume, _minPitch, _maxPitch, _x, _y) {
	/*
	_asset		= What audio to play
	_maxAssets	= How many of those assets do you have?
		Number the assets as such: audio0, audio1, ...
	_volume		= default volume
	_outVolume	= out of bounds volume
	*/

	var _audio, _rand;

	if(_maxAssets != 0)
	{
		// Get random asset
		_rand = irandom_range(0, _maxAssets);
		_audio = asset_get_index(_asset + string(_rand));
	}
	else
		_audio = asset_get_index(_asset);

	// Play sound
	var _sound = audio_play_sound(_audio, 100, false);
	audio_sound_gain(_sound, _volume, 0);

	// Randomize pitch
	audio_sound_pitch(_sound, random_range(_minPitch, _maxPitch));

	// Get current camera position
	var _camX = camera_get_view_x(view_camera[0]);
	var _camY = camera_get_view_y(view_camera[0]);
	var _camW = camera_get_view_width(view_camera[0]);
	var _camH = camera_get_view_height(view_camera[0]);

	// Check if out of the camera
	if (_x < _camX || _x > _camX + _camW)
	|| (_y < _camY || _y > _camY + _camH)
	{
		// Lower sound
		audio_sound_gain(_sound, _outVolume, 0);
	}
}

#endregion

#region ChatGPT

#macro APIKEY "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"
global.chatGPT = "gpt-4o-mini"

/// @description send_gpt_chat( system_input, user_history, user_input )
/// @param  system_input
/// @param  user_history
/// @param  user_input

function send_gpt_chat()
{	
    // Check for valid API key
    if (APIKEY == "") {
        show_debug_message("Invalid API Key!");
		show_message("Invalid API Key!");
        return;
    }

    var map = ds_map_create();
    ds_map_add(map, "Authorization", "Bearer " + APIKEY);
    ds_map_add(map, "Content-Type", "application/json");
	
    var _data = {
                    "model": global.chatGPT,
                    
                    "messages": [
                        {"role": "system",	"content": argument[0]},
                        {"role": "user",	"content": "Chat History: '''"	+ argument[1]	+ "'''"},
                        {"role": "user",	"content": "User Input: '''"	+ argument[2]	+ "'''"},
                    ],

                    "max_tokens": int64(450),  // How much it can cost
                    "temperature": 0.6,        // How random it can be
                    "n": int64(1),             // How many outputs
                };
			
	var data = json_stringify(_data);
	
	var api_endpoint = "https://api.openai.com/v1/chat/completions";

	request = http_request(api_endpoint, "POST", map, data);

	display_string = "Loading"

	show_debug_message("Request Sent");

	ds_map_destroy(map)
}

function send_gpt(_system, _user){
	
    var map = ds_map_create();
    ds_map_add(map, "Authorization", "Bearer " + APIKEY);
    ds_map_add(map, "Content-Type", "application/json");

	var _data = {
					"model": global.chatGPT,
					
					"messages": [
					    {"role": "system", "content": _system},
					    {"role": "user", "content": _user},
					],

					"max_tokens": int64(450),	// How much it can cost
					"temperature": 0.6,			// How random it can be
					"n": int64(1),				// How many outputs
				};
			
	var data = json_stringify(_data);
	
	var api_endpoint = "https://api.openai.com/v1/chat/completions";

	request = http_request(api_endpoint, "POST", map, data);

	display_string = "Loading";
	
	show_debug_message("Request Sent");

	ds_map_destroy(map)
}

#region Tools



#endregion

#endregion