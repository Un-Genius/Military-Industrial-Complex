steam_update();

// Check if lobby owner left
if(lobby)
{
	var _lobby_owner = id;
	
	if steam_is_user_logged_on()
		_lobby_owner = steam_lobby_get_owner_id();
	
	if _lobby_owner != lobby_owner
	{
	    // lobby invalidated
		if(!lobby_is_owner)
		{
			trace(2, "Connection lost. Owner left.");
			
			steam_lobby_leave();
		}
		
		// Reset variables
	    steam_reset_state();
	}
}

#region server-only logic

if (lobby_is_owner)
{
    // handle timeouts
    var _listSize = ds_list_size(net_list);
	
    while (_listSize-- >= 0) {
        var _client = net_list[|_listSize];
		
        if (net_map[?_client] < current_time - 7000)
		{
			// Delete clients lists
            ds_list_delete(net_list, ds_list_find_index(net_list, _client));
			ds_map_delete(net_map, _client);
			
            // inform the other players:
            var _buffer = packet_start(packet_t.leaving);
            buffer_write_int64(_buffer, _client);
            packet_send_all(_buffer);
			
            // show a notice in chat:
            var _string = "timed out.";
            chat_add(steam_get_user_persona_name_w(_client), _string, c_orange);
			
			chat_send(_string, color.orange);
			
			// Update amount of players in server
			var _lobbyCurrent	= steam_lobby_get_member_count();
			steam_lobby_set_data("game_size_current", string(_lobbyCurrent - 1));
        }
    }
}
#endregion

#region receive packets

while(steam_net_packet_receive())
{
    var from = steam_net_packet_get_sender_id();
    var _buffer = inbuf;
	
    if (lobby_is_owner)
	{
        if(ds_map_exists(net_map, from))
		{
            // a packet from someone familiar
            buffer_seek(inbuf, buffer_seek_start, 0);
            steam_net_packet_get_data(inbuf);
            packet_handle_server(from);
        }
		else
		{
            // sender unknown, require a handshake to establish connection
            // make sure that the packet is big enough to be a handshake-packet:
            if (steam_net_packet_get_size() < 6) continue; // (skip this packet)
			
            // make sure that the player is actually in our lobby, however:
            var i;
            var _memberCount = steam_lobby_get_member_count();
			
            for(i = 0; i < _memberCount; i++)
			{
                if (steam_lobby_get_member_id(i) == from) break;
            }
			
            if(i >= _memberCount) continue; // (skip this packet)

            buffer_seek(inbuf, buffer_seek_start, 0);
            steam_net_packet_get_data(inbuf);
            packet_handle_auth(from);
			
			// Preload newbie
			steam_get_user_persona_name_w(from);
			
			// Create map to hold data for newbie
			var _dataMap = ds_map_create();
						
			// Add it to the main map
			ds_map_set(playerDataMap, from, _dataMap);
				
			// Ask for data
			var _buffer = packet_start(packet_t.data_update_request);
			buffer_write(_buffer, buffer_u64, steamUserName);
			packet_send_to(_buffer, from);
        }
    }
	else
	{
        // as a client, only accept packets from server:
        if(from != lobby_owner) continue;

        buffer_seek(inbuf, buffer_seek_start, 0);
        steam_net_packet_get_data(inbuf);
        packet_handle_client(from);
		
		// Make sure all names are preloaded
		var _size = ds_list_size(net_list);
		var _peopleAmount = steam_lobby_get_member_count();
		
		if _size != _peopleAmount - 1
		{
			for(var i = 0; i < _size; i++)
			{
				var _id = ds_list_find_value(net_list, i);
				steam_get_user_persona_name_w(_id);
			}
		}
		
		
		if joining_lobby
		{
	        joining_lobby = false;
		
			// Change menu
			state = menu.joinPage;
			reset_menu();
			
			chat_send("Connected.", color.orange);
		}
    }
}
	
#endregion
