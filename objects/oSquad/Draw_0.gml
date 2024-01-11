// Draw moving arrow
if moving_x > 0 && moving_y > 0
{
	draw_set_color(c_green)
	draw_arrow(x, y, moving_x, moving_y, 25)
}

// Draw shooting arrow
var _size = ds_list_size(shooting_targets)
if(_size) > 0
{
	draw_set_color(c_red)
	for(var i = 0; i < _size; i++)
	{
		var _inst = ds_list_find_value(shooting_targets, i)
		if !instance_exists(_inst)
			continue
		draw_arrow(x, y, _inst.x, _inst.y, 10)
	}
}

draw_set_color(c_white)
draw_self();