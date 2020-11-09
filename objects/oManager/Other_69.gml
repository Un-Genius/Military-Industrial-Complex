var uid;
var type_event = async_load;
var ok = type_event[?"success"];

switch (type_event[?"event_type"])
{
	case "user_persona_name":
	
		// Find and store steam name using ID
	    names[?type_event[?"steamid"]] = type_event[?"persona_name"];
	
		if lobby
		{
			// Get current size
			var _lobbyCurrent	= steam_lobby_get_member_count();
		
			// Update lobby current size
			steam_lobby_set_data("game_size_current", string(_lobbyCurrent));
		}
	
	break;
	
	case "lobby_created":

	    creating_lobby = false;
	
	    if(ok)
		{
			// Set steam variables
	        lobby			= true;
	        lobby_is_owner	= true;
	        lobby_owner		= steam_lobby_get_owner_id();
		
			// Get data
			var _lobbyCurrent	= steam_lobby_get_member_count();
			var _lobbyMax		= (ds_grid_get(global.savedSettings, 1, setting.player_count) * 2) + 2;
		
	        ds_list_clear(net_list);
	        ds_map_clear(net_map);
		
	        // set up filters so that the lobby can be found:
	        steam_lobby_set_data("game_name", game_name);
	        steam_lobby_set_data("game_version", string(game_version));
	        steam_lobby_set_data("title", steam_get_user_persona_name_w(user) + "'s lobby");
			steam_lobby_set_data("game_size_current", string(_lobbyCurrent));
			steam_lobby_set_data("game_size_max", string(_lobbyMax));

	        trace(1, "Lobby created.");
	    }
		else
		{
	        // Only happens if there's no connection to Steam
	        trace(2, "Failed to create a lobby.");
	    } 
	
	break;
	
	case "lobby_joined":

		// Get data
		var _lobbyCurrent	= steam_lobby_get_member_count();
		var _lobbyMax		= (ds_grid_get(global.savedSettings, 1, setting.player_count) * 2) + 2;

	    if(ok) && _lobbyCurrent <= _lobbyMax 
		{
	        lobby			= true;
	        lobby_is_owner	= false;
	        lobby_owner		= steam_lobby_get_owner_id();			
	        joining_lobby	= true;
		
	        trace(3, "Joining lobby...");
		
	        // assume connection to lobby owner:
	        ds_list_clear(net_list);
	        ds_map_clear(net_map);
	        ds_list_add(net_list, lobby_owner);
	        net_map[?lobby_owner] = current_time;
		
	        // send a greeting-packet:
	        var _buffer = packet_start(packet_t.auth);
	        buffer_write(_buffer, buffer_string, game_name);
	        buffer_write(_buffer, buffer_u32, game_version);
	        packet_send_to(_buffer, lobby_owner);
			
			// Create map to hold data for newbie
			var _dataMap = ds_map_create();
						
			// Add it to the main map
			ds_map_set(playerDataMap, string(lobby_owner), _dataMap);
				
			// Ask for data
			var _buffer = packet_start(packet_t.data_update_request);
			buffer_write(_buffer, buffer_u64, user);
			packet_send_to(_buffer, lobby_owner);
	    }
		else
		{
			if _lobbyCurrent > _lobbyMax
				trace(2, "Lobby full.");
			else
		        // No connection to Steam or lobby vanished while we were joining
		        trace(2, "Failed to join the lobby.");
	    }
	   break;
	
	case "lobby_join_requested":

	    // This event is dispatched when you click on an invitation.
	    // Form an ID and join that lobby:
	    uid = steam_id_create(type_event[?"lobby_id_high"], type_event[?"lobby_id_low"]);
	    steam_lobby_join_id(uid);
	
	    trace(3, "Joining a lobby by invitation...");
	
		// Set menu
		state = menu.loadingPage;
		reset_menu();
	
	   break;
}

