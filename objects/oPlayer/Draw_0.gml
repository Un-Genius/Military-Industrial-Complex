/// @description Debug && MouseBox

// Draw Box
if mousePress == 1
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

#region Debug Monitoring

if global.debugMenu
{	
	var _gap = 20;
	
	var _size = ds_grid_width(global.instGrid);
	
	draw_set_halign(fa_right);
	
	for(var i = 0; i < _size; i++)
	{
		var _value = ds_grid_get(global.instGrid, i, 0)
		
		if _value == 0
			draw_text(mouse_x - 20, mouse_y - (20 - _gap * i), "-");
		else
			draw_text(mouse_x - 20, mouse_y - (20 - _gap * i), "instance Found: "	+ string(_value));
	}
	
	draw_set_halign(fa_left);
	
	for(var i = 0; i < _size; i++)
	{
		var _value = ds_grid_get(global.instGrid, i, 0)

		draw_text(20,(20 - _gap * (i - _size)), "Inst_" + string(i) + ": "	+ string(_value));
	}
}

#endregion

#region Zoning

if(zoning > 0 && !global.mouseUI)
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