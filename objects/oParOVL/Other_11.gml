/// @description Update children

#region Enter vehicle

enterVeh = noone;

// Only for infantry
if(type	== unitType.inf)
{
	var _veh = collision_point(goal_x, goal_y, oOVLTV, false, true);

	// Check position
	if(instance_exists(_veh))
	{
		enterVeh	= _veh;
	}
}

var _enterVeh = enterVeh;

#endregion

// Formation
var i = 0;
var _dist = 50;

for(var j = 0; j < hp; j++)
{	
	for(var k = 0; k < ceil(hp/3); k++)
	{		
		if(i = hp)
		{
			break;
		}
		
		var _inst = ds_list_find_value(childList, i);
			
		var _goalX = goal_x - (_dist * (k - (floor(hp/3)/4)));
		var _goalY = goal_y - (_dist * (j - (floor(hp/6))));
		
		with(_inst)
		{
			update_state(-1, action.idle);
		
			// Set goal
			goal_x	= _goalX;
			goal_y	= _goalY;
			
			// Set vehicle
			enterVeh = _enterVeh;
		}
		
		i++;
	}
}