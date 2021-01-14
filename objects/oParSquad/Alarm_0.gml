/// @description Spawn Units & Update Budget
global.resources -= cost;

// Formation
var i = 0;
var _dist = 25;

for(var j = 0; j < hp; j++)
{	
	for(var k = 0; k < ceil(hp/3); k++)
	{		
		if(i = hp)
		{
			break;
		}
			
		// Location
		var _goalX = goalX - (_dist * (k - (floor(hp/3)/4)));
		var _goalY = goalY - (_dist * (j - (floor(hp/6))));
		
		// Object to spawn		
		var _objectString = "oSquadInf";
			
		var _object = asset_get_index(_objectString);
		
		// Create instance
		var _inst = instance_create_layer(_goalX, _goalY, "Instances", _object);
		
		// Add inst to list
		ds_list_add(global.unitList, _inst);
	
		// Resize holding grid
		var _width	= ds_grid_width(global.instGrid);
		var _height = ds_grid_height(global.instGrid);
		ds_grid_resize(global.instGrid, _width + 1, _height);	
	
		// Add unit to list
		ds_list_add(childList, _inst);
	
		_inst.squadID = id;
		
		// Find self in list
		var _pos = ds_list_find_index(global.unitList, _inst);
		
		var _packet = packet_start(packet_t.add_attached_unit);
		buffer_write(_packet, buffer_u64, oManager.user);
		buffer_write(_packet, buffer_string, _objectString);
		buffer_write(_packet, buffer_f32, _goalX);
		buffer_write(_packet, buffer_f32, _goalY);
		buffer_write(_packet, buffer_u16, _pos);
		packet_send_all(_packet);
		
		dbg(string(i) + ": " + string(_pos))
		
		i++;
	}
}