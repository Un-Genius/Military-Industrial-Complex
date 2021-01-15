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

if point_distance(x, y, goalX, goalY) > 3
{	
	if moveState != action.moving
	{	
		// Update state
		update_state(-1, action.moving);
		
		// Start pathfind
		scr_pathfind();
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
		x += lengthdir_x(moveSpd, _pathDir);
		y += lengthdir_y(moveSpd, _pathDir);
		
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
		
		// Find index
		var _sprite = asset_get_index(unitName + "_" + string(state));
		
		image_speed = sprite_get_speed(_sprite);
		
		if distance_to_point(goalX, goalY) < 3
			image_speed = 0;
		
		break;
				
	case action.attacking:
		
		break;
		
	case action.aiming:
			
		// Stop reloading if 
		if image_index > image_number - 1
		{
			clipSize = maxClipSize;
		}

		break;
		
	case action.reloading:
		
		// Stop reloading if 
		if image_index > image_number - 1
		{
			clipSize = maxClipSize;
		}
		
		break;
}

#endregion