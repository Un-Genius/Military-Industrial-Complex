#region Update position

var _size = ds_list_size(childList);

var _x = 0;
var _y = 0;

// Find average
for(var i = 0; i < _size; i++)
{
	var _inst = ds_list_find_value(childList, i);
	
	_x += _inst.x;
	_y += _inst.y;
}

// calculate average
_x = _x/_size;
_y = _y/_size;

// Overwrite current position
x = _x;
y = _y;

#endregion