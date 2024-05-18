var x_offset = 40;
var y_offset = 50;
var _sep = 10;
var _w = 300;
var _size = 1;
var _angle = image_angle;

draw_set_font_ext(ftDefault, c_white, fa_left, fa_top, 1);

for(var i = 0; i < array_length(items_to_display); i++) {
	
	var item = items_to_display[i];
	
	if item[INFO_TABLE.AMOUNT] > 0
		draw_set_color(c_white);
	else
		draw_set_color(c_orange);
	
	draw_text_ext_transformed(x_offset, y_offset, item[INFO_TABLE.TITLE], _sep, _w, _size, _size, _angle);
	draw_text_ext_transformed(x_offset+110, y_offset, string(item[INFO_TABLE.AMOUNT]) + "/" + string(item[INFO_TABLE.MAX]), _sep, _w, _size, _size, _angle);
	draw_text_ext_transformed(x_offset+200, y_offset, item[INFO_TABLE.FLUX], _sep, _w, _size, _size, _angle);
	
	if instance_exists(oBuildingTool) {
		if item[INFO_TABLE.COST] != 0
		{
			if item[INFO_TABLE.COST] > item[INFO_TABLE.AMOUNT]
				draw_set_color(make_color_rgb(242, 111, 111)) // Red
			else
				draw_set_color(c_white)
				
			draw_text_ext_transformed(282, y_offset, "-" + string(item[INFO_TABLE.COST]), _sep, _w, _size, _size, _angle);
		}
		
		if item[INFO_TABLE.UPKEEP] != 0
		{
			if item[INFO_TABLE.UPKEEP] > 0
				draw_set_color(make_color_rgb(135, 242, 111)) // Green
			else if item[INFO_TABLE.AMOUNT] > item[INFO_TABLE.UPKEEP]
				draw_set_color(c_orange);
			else
				draw_set_color(make_color_rgb(242, 111, 111)) // Red
			if item[INFO_TABLE.UPKEEP] > 0
				draw_text_ext_transformed(342, y_offset,  "+" + string(item[INFO_TABLE.UPKEEP]), _sep, _w, _size, _size, _angle);
			else
				draw_text_ext_transformed(342, y_offset, item[INFO_TABLE.UPKEEP], _sep, _w, _size, _size, _angle);
		}
	}

    // Move to next line
    y_offset += 30;
}