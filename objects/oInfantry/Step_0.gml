/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// idle, move, attack, reload
/*
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
			
			state = action.attacking;
			
			// Update sprite
			event_user(0);
		}

		break;
		
	case action.reloading:
		
		// Stop reloading if 
		if image_index > image_number - 1
		{
			clipSize = maxClipSize;
			
			state = action.attacking;
			
			// Update sprite
			event_user(0);
		}
		
		break;
}