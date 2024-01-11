// Compares String pixels
maxWidth	= 175;
maxHeight	= sprite_get_height(spr_lobbybox);
sprite_size = sprite_get_height(spr_lobbybox);

// Get data
with(oManager)
{
	var _username	= steam_get_user_persona_name_w(steamUserName);
	var _team		= team;
	var _list		= net_list;
	var _hashColor	= hash_color;
	var _ready		= ready;
	var _playerDataMap = playerDataMap;
}

username	= _username;
team		= _team;
nameList	= _list;
hash_color	= _hashColor;
ready		= _ready;
playerDataMap = _playerDataMap;
size		= ds_list_size(nameList);
	
for (var i  = 0; i < size; i++)
{
	// Get size of name
	var _id = ds_list_find_value(nameList, i);
	var _name = steam_get_user_persona_name_w(_id);	
	
	if(is_undefined(_name))
	{
		_name = "Unknown";
	}
	
	var pixCompare = string_width(_name);
		
	// Update maxWidth if its smaller
	if pixCompare > maxWidth
	{
		maxWidth = _name;
	}
}

alarm[0] = 20;