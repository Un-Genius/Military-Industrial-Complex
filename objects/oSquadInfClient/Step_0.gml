#region Sprites management

if state == action.attacking || moveState == action.moving
{	
	// Set direction
	if state != action.attacking
		dir = point_direction(x, y, oldPathX, oldPathY) - 180;
	
	image_angle += sin(degtorad(dir - image_angle)) * 15;
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
			
			update_state(action.attacking, -1);
		}

		break;
		
	case action.reloading:
		
		// Stop reloading if 
		if image_index > image_number - 1
		{
			clipSize = maxClipSize;
			
			update_state(action.attacking, -1);
		}
		
		break;
}

#endregion