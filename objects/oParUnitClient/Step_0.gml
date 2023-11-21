#region Sprites management

if state == action.attacking || moveState == action.moving
{	
	// Set direction
	if state != action.attacking
		dir = point_direction(x, y, oldPathX, oldPathY) - 180;
	
	image_angle += sin(degtorad(dir - image_angle)) * 15;
}

#endregion

#region Move to position

if point_distance(x, y, pathGoalX, pathGoalY) > 3
{	
	if moveState != action.moving
	{	
		// Update state
		update_state(-1, action.moving);
		
		// Start pathfind
		path_goal_find(x, y, pathGoalX, pathGoalY, path);
	}
	else
	{
		#region Walk the path
		
		var _point = false;
		
		// Loop until next point is found
		while(!_point)
		{
			// Get amount left
			var _amount = path_get_number(path);
			
			// Get next waypoint
			var xx = path_get_x(path, 0);
			var yy = path_get_y(path, 0);
		
			// Delete waypoint if arrived
			if point_distance(x, y, xx, yy) < 3
			{
				// Stop path
				if _amount == 1
				{
					update_state(-1, action.idle);
					_point = true;
				}
				else
					path_delete_point(path, 0);
			}
			else
				_point = true;
		}
		
		// Find direction
		var _pathDir = point_direction(x, y, xx, yy);
		
		// Vector a step
		x += lengthdir_x(movementSpeed, _pathDir);
		y += lengthdir_y(movementSpeed, _pathDir);
		
		#endregion
	}
}
else
{
	if moveState != action.idle
		update_state(-1, action.idle);
}

#endregion

#region State Machine

// idle, move, attack, reload
switch state
{
	case action.idle:
		
		if unit != unitType.building
		{
			// Find index
			var _sprite = asset_get_index(object_name + "_" + string(state));
		
			image_speed = sprite_get_speed(_sprite);
		
			if distance_to_point(pathGoalX, pathGoalY) < 3
				image_speed = 0;
		}
		
		break;
				
	case action.attacking:
		
		// Update frequency
		bulletTiming += 0.01 * room_speed;
		
		if bulletTiming > bulletFrequency
		{
			var _enemy_list = ds_list_create();
			
			var _enemy = collision_circle_list(x, y, range, oObject, false, true, _enemy_list, true);
			
			if _enemy > 0
			{
				// Find variables
				for(var i = 0; i < _enemy; i++)
				{
					// Get instance
					var _inst = ds_list_find_value(_enemy_list, i);
					
					with(_inst)
					{
						var _team		= team;
						var _numColor	= numColor;
					}
					
					// Check if its an enemy
					if(_team != team || team == 0) && _numColor != numColor
					{
						_enemy = _inst;
						break;
					}
				}
				
				if instance_exists(_enemy) && _enemy > 1000
				{
					// Get position
					with(_enemy)
					{
						var _enemyX = x;
						var _enemyY = y;
					}
									
					// Find angle
					var _angle = point_direction(x, y, _enemyX, _enemyY);
						
					// Point direction of enemy
					dir = _angle;		
						
					// Set gun settings
					bulletTiming = 0;
				}	
			}
			
			// Destroy list
			ds_list_destroy(_enemy_list);
		}
		
		break;
}

#endregion