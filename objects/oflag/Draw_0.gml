//Check to see if all the inst on cap are on the same team
var onFlag = collision_circle_list(x, y, capRange, oObject, false, false, capList, false);

//Checks to see if all the units touching cap are on the same team
if onFlag >= 1 
{
	var oldInst = ds_list_find_value(capList,0);
	var newInst = noone;
	_color = oldInst.hashColor;
	
	if captureProgress < 10 * room_speed
	{
		captureProgress ++;
	}
	
	if onFlag >= 2 
	{
		for (var i=1; i >= onFlag; i++)
		{
			newInst = ds_list_find_value(capList, i);  
			if newInst.team != oldInst.team
			{
				_color = c_white;
				if captureProgress > 0 
				{
					captureProgress --;
					pointCooldown = 0;
				}
				break; 
			}
		}
	}
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

// Draw shadow Capture Progress
draw_set_alpha(0.25);
	draw_healthbar(x - 27, y - 53, x + 23, y - 48, _capProg, c_black, c_black, c_black, 0, false, true);
draw_set_alpha(1);

// Draw Capture Progress
draw_healthbar(x - 25, y - 55, x + 25, y - 50, _capProg, c_white, c_white, _color, 0, false, true);

// Creates shadow
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1.5, 345, c_dkgray, 0.2);

//Creates a visible radius for the flag capture zone
draw_set_color(_color);
	layer = layer_get_id("UI");
		draw_sprite(sflagA, -1, x, y);
	layer = layer_get_id("Walls");
		draw_circle(x, y, 45, true);
	layer = layer_get_id("Instances");
draw_set_color(c_white);


