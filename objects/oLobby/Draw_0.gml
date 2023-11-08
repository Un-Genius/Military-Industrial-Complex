// Draws spr_lobbyboxes based on the number of players in the lobby
			
// Draw Ready sprite
if ready
	draw_sprite(spr_ready, -1, x - 16, y - 16)
		
draw_set_color(hash_color);
	
// Draws box for user
draw_sprite_stretched(spr_lobbybox, -1, x , y - 32, maxWidth + 10, maxHeight);
draw_rectangle(x, y - 32, x + maxWidth + 10, y - 33 + maxHeight, true);
	
// Draws name for user
draw_text(x + 5, y - sprite_size + 5, username);
// Draw team
draw_text(x - 20, y - sprite_size + 5, team);

for (var i = 0; i < size; i++)
{	
	// Get ID
	var _id = ds_list_find_value(nameList, i);
		
	// Get data map
	var _dataMap = ds_map_find_value(playerDataMap, _id);
	
	if !is_undefined(_dataMap)
	{
		var _ready		= ds_map_find_value(_dataMap, "ready");
		var _hashColor	= ds_map_find_value(_dataMap, "hash_color");
		var _team		= ds_map_find_value(_dataMap, "team");
		
		if !is_undefined(_ready) || !is_undefined(_hashColor)
		{
			// Converts the steam_id to a name
			var _name = steam_get_user_persona_name_w(_id);	
				
			// Draw Ready sprite
			if _ready
				draw_sprite(spr_ready, -1, x - 16, y - 16 + ((32 * i)))
					
			draw_set_color(_hashColor);

			// Set allignment
			draw_set_valign(fa_middle);	
				// Draws box
				draw_sprite_stretched(spr_lobbybox, -1, x, y + ((32 * i)), maxWidth + 10, maxHeight);
				draw_rectangle(x, y + ((32 * i)), x + maxWidth + 10, y - 1 + maxHeight, true);
				// Draws player names
				draw_text(x + 5, sprite_size/2 + y  + ((sprite_size * i)), _name);
				// Draw team
				draw_text(x - 20, sprite_size/2 + y  + ((sprite_size * i)), _team);
			// Resets the allignment
			draw_set_valign(-1);
		}
	}
}
	
draw_set_color(-1);