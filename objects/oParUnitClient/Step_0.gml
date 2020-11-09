#region Sprites management

if state == action.attacking || moveState == action.moving
{	
	// Set direction
	if state != action.attacking
		dir = point_direction(x, y, pathX, pathY) - 180;
	
	image_angle += sin(degtorad(dir - image_angle)) * 15;
}

#endregion

#region Move to position

if point_distance(x, y, goalX, goalY) > 3
{	
	if moveState != action.moving
	{	
		// Start pathfind
		scr_pathfind(goalX, goalY, moveSpd);
				
		// Set moveState
		moveState = action.moving;
		
		// Update sprite
		event_user(0);
		
		// Update direction
		alarm[1] = 1;
	}
}
else
{
	if moveState != action.idle
	{
		// Set idle
		moveState = action.idle;

		event_user(0);
	}
}

#endregion

#region Attack

// Stop if its an HQ
if state != action.reloading
{
	if clipSize > 0
	{
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
				
					if state == action.idle
					{
						// Set state
						state = action.aiming;
					
						// Update sprite
						event_user(0);
					}
					
					if state == action.attacking
					{					
						// Find angle
						var _angle = point_direction(x, y, _enemyX, _enemyY);
						
						// Point direction of enemy
						dir = _angle;		
						
						// Set gun settings
						bulletTiming = 0;
						clipSize--;
			
						// Start reloading
						if !clipSize
						{
							state = action.reloading;
							
							// Update sprite
							event_user(0);
						}
					}
				}
			}
			else
			{
			 	if state == action.attacking
				{
					// Set state
					state = action.idle;
					
					// Update sprite
					event_user(0);
				}
			}
			
			// Destroy list
			ds_list_destroy(_enemy_list);
		}
	}
}

#endregion