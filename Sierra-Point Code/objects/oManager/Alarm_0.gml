/// @description Refresh Playpage

// Stop alarm if wrong menu
if state != menu.public
	exit;

// only fetch lobbies of same game version:
steam_lobby_list_add_string_filter("game_name",		oManager.game_name,				steam_lobby_list_filter_eq);
steam_lobby_list_add_string_filter("game_version",	string(oManager.game_version),	steam_lobby_list_filter_eq);
steam_lobby_list_request();

// Find size
var _size = ds_list_size(instPublic_list);
	
for(var i = 0; i < _size; i++)
{
	// Find and destroy button
	instance_destroy(ds_list_find_value(instPublic_list, i));
}
	
// Reset list
ds_list_clear(instPublic_list);