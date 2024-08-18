/// @description Debug && MouseBox

// Draw Box
if left_mouse_state == mouse_type.box
	draw_rectangle(mouseLeftPress_x, mouseLeftPress_y, mouse_x, mouse_y, true);

image_blend = hash_color;

#region Zoning

if(zoning > 0 && !global.mouse_on_ui)
{	
	var _buildingsAmount = instance_number(oParSite);
	
	for(var i = 0; i < _buildingsAmount; i++)
	{
		var _inst = instance_find(oParSite, i);
		
		with(_inst)
		{
			var _xScale = sprite_width/32;
			var _yScale = sprite_height/32;
			
			draw_sprite_ext(sZone, 0, x, y, _xScale, _yScale, image_angle, c_red, 0.5);
		}
	}
}

#endregion

#region Comms
draw_circle(x,y,comms_dist, true)
#endregion

draw_self()