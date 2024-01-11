/// @description Spawn Units & Update Budget
global.supplies -= cost;

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
		var _goalX = goal_x - (_dist * (k - (floor(hp/3)/4)));
		var _goalY = goal_y - (_dist * (j - (floor(hp/6))));
		
		// Object to spawn		
		var _objectString = unit;
			
		var _object = asset_get_index(_objectString);
		
		// Create instance
		var _inst = instance_create_layer(_goalX, _goalY, "Instances", _object);
		
		// Declare parent
		_inst.squadID = id;
		
		// Add child to list
		ds_list_add(childList, _inst);
		
		// Add inst to list
		ds_list_add(global.unitList, _inst);
		
		// Find parent in list
		var _pos = ds_list_find_index(global.unitList, _inst);
		
		// Find parent in list
		var _parentPos = ds_list_find_index(global.unitList, id);
	
		// Resize holding grid
		//var _width	= ds_grid_width(global.instGrid);
		//var _height = ds_grid_height(global.instGrid);
		//ds_grid_resize(global.instGrid, _width + 1, _height);	
					
		var _packet = packet_start(packet_t.add_attached_unit);
		buffer_write(_packet, buffer_u64, oManager.steamUserName);
		buffer_write(_packet, buffer_u16, _pos);
		buffer_write(_packet, buffer_string, _objectString);
		buffer_write(_packet, buffer_f32, _goalX);
		buffer_write(_packet, buffer_f32, _goalY);
		buffer_write(_packet, buffer_u16, _parentPos);
		packet_send_all(_packet);
		
		i++;
	}
}