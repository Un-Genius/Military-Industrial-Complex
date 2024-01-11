/// @description Update settings every now and then

// Get data
with(oManager)
{
	var _team		= team;
	var _hashColor	= hash_color;
	var _ready		= ready;
}

size		= ds_list_size(nameList);
team		= _team;
hash_color	= _hashColor;
ready		= _ready;

maxWidth	= 175;
	
for (var i  = 0; i < size; i++)
{
	// Get size of name
	var _id = ds_list_find_value(nameList, i);
	var _name = steam_get_user_persona_name_w(_id);	
	var pixCompare = string_width(_name);
		
	// Update maxWidth if its smaller
	if pixCompare > maxWidth
	{
		maxWidth = _name;
	}
}

alarm[0] = 20;