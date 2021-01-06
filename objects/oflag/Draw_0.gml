//Check to see if all the inst on cap are on the same team
var onFlag = collision_circle_list(x, y, capRange, oObject, false, false, capList, false);

//Checks to see if all the units touching cap are on the same team
if onFlag > 0 
{
	var oldInst = ds_list_find_value(capList, 0);
	var newInst = noone;
	
	// Contender on cap
	if((_team != oldInst.team || _team == 0) && _color != oldInst.hashColor) && captureProgress > 0
	{
		captureProgress --;
		_team = 0;
	}
	else
	{	
		// Only check if more than 1 is on the flag
		if onFlag > 1
		{
			// Loop through all people on flag
			for(var i = 1; i >= onFlag; i++)
			{
				// Check next in list
				newInst = ds_list_find_value(capList, i);  
			
				// Compare if contended with previous
				if(newInst.team != oldInst.team || newInst.team == 0) && newInst.hashColor != oldInst.hashColor
				{
					// Reset color if contended
					_color	= c_white;
					_team	= 0;
					
					// Reset cap
					if captureProgress > 0 
					{
						captureProgress --;
						pointCooldown = 0;
					}
					
					// Stop looping if conflicted
					break; 
				}
			}
		}
		else
		{
			// Get new color
			_color	= oldInst.hashColor;
			_team	= oldInst.team;
	
			// Increase cap
			if captureProgress < 10 * room_speed
			{
				captureProgress ++;
			}
		}
	}
	
	// Reset list
	ds_list_clear(capList);
}
else 
{	
	// if player moves off cap with captureProgress not finished and point is not contested
	if((captureProgress < 10 * room_speed) && (captureProgress > 0))
	{
		captureProgress --;  
		pointCooldown = 0;
		_color = c_white;
	}
}

// Change 0-600 to 0-100
var _capProg = ((captureProgress * 100) / 600);

// Creates shadow
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1.5, 345, c_dkgray, 0.2);

// Draw capture progress
if captureProgress >= 10 * room_speed
{
	// Draw flag
	draw_sprite_ext(sflagA, -1, x, y, image_xscale, image_yscale, direction, _color, 1);
}
else
{
	if captureProgress > 0
	{
		// Draw shadow Capture Progress
		draw_set_alpha(0.25);
			draw_healthbar(x - 27, y - 53, x + 23, y - 48, _capProg, c_black, c_black, c_black, 0, false, true);
		draw_set_alpha(1);

		// Draw Capture Progress
		draw_healthbar(x - 25, y - 55, x + 25, y - 50, _capProg, c_white, c_white, _color, 0, false, true);
	}
	
	// Draw white flag
	draw_sprite_ext(sflagA, -1, x, y, image_xscale, image_yscale, direction, c_white, 1);
}
// Creates a visible radius for the flag capture zone
draw_circle(x, y, 45, true);