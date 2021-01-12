/// @description Update children

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
			
		var _goalX = goalX - (_dist * (k - (floor(hp/3)/4)));
		var _goalY = goalY - (_dist * (j - (floor(hp/6))));
		
		with(_inst)
		{
			update_state(-1, action.idle);
		
			// Set goal
			goalX	= _goalX;
			goalY	= _goalY;
		}
		
		i++;
	}
}

// Find average
/*
for(var i = 0; i < _size; i++)
{
	var _inst = ds_list_find_value(childList, i);
		
	var _x = irandom_range(-range, range);
	var _y = irandom_range(-range, range);
	
	var _goalX = goalX;
	var _goalY = goalY;
		
	with(_inst)
	{
		update_state(-1, action.idle);
		
		// Set goal
		goalX	= _goalX + _x;
		goalY	= _goalY + _y;
	}
}