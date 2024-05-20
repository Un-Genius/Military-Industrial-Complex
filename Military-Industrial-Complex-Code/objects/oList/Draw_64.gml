var _height = ds_grid_height(optionGrid);

// Draw background
draw_set_color(c_ltgray);
	draw_roundrect(x, y, x + width, y + ((_height + 1)*fntSize) + (outerPadding*2) + ((_height + 1)*innerPadding), 0);
	
// Draw Title
draw_set_color(c_black);
draw_set_alpha(0.7);
	draw_text(x + outerPadding, y + outerPadding, title);
draw_set_alpha(1);

for(var i = 0; i < _height; i++)
{
	draw_set_color(c_black)
		
	// Find Data
	var _name	= ds_grid_get(optionGrid, 1, i);
	var _sel	= ds_grid_get(optionGrid, 2, i);
	
	// Position to draw
	var _x = x + outerPadding;
	var _y = y + outerPadding + (fntSize * (i + 1)) + (innerPadding * (i + 1));
	
	// Change color and draw rectangle
	if(i == hoverID)
	{
		draw_set_color(make_color_rgb(33, 76, 115));
		
		var o = i + 2;
		var yy = y + outerPadding + (fntSize * o) + (innerPadding * o)
		
		draw_set_alpha(0.2);
			draw_rectangle(_x - outerPadding, _y , _x + width - outerPadding, yy, true);
		draw_set_alpha(1);
	}
	
	// Draw name
	draw_text(_x, _y, _name);
		
	if(_sel > -1)
	{
		var _val = ds_grid_get(optionGrid, _sel + 3, i);
		
		draw_set_halign(fa_right);
			draw_text(x + width - outerPadding, _y, _val);
		draw_set_halign(fa_left);
	}


}

// Reset color
draw_set_color(c_white);

hoverID = -1