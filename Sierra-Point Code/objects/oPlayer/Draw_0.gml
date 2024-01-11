/// @description Debug && MouseBox

// Draw Box
if left_mouse_state == mouse_type.box
	draw_rectangle(mouseLeftPress_x, mouseLeftPress_y, mouse_x, mouse_y, true);
	
// Display placement of new building
if buildingPlacement != noone
{
	var _sprite = buildingPlacement.sprite_index;
	
	if buildingIntersect
		draw_sprite_ext(_sprite, 0, mouse_x, mouse_y, image_xscale, image_yscale, 0, c_red, 0.1);
	else
		draw_sprite_ext(_sprite, 0, mouse_x, mouse_y, image_xscale, image_yscale, 0, c_white, 0.1);
}

image_blend = hash_color;

#region Zoning

if(zoning > 0 && !global.mouse_on_ui)
{	
	var _buildingsAmount = instance_number(oParZone);
	
	for(var i = 0; i < _buildingsAmount; i++)
	{
		var _inst = instance_find(oParZone, i);
		
		with(_inst)
		{
			var _xScale = sprite_width/32;
			var _yScale = sprite_height/32;
			
			draw_sprite_ext(sZone, 0, x, y, _xScale, _yScale, image_angle, c_red, 0.5);
		}
	}
}

#endregion