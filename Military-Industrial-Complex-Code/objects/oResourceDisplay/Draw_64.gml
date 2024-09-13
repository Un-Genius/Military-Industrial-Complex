var _x_offset = 40;
var _y_offset = 50;
var _amount_offset = _x_offset+190;
var _flux_offset = _amount_offset+90;
var _cost_offset = _flux_offset+47;
var _upkeep_offset = _cost_offset+61;
var _sep = 10;
var _w = 300;
var _size = 1;
var _angle = image_angle;

draw_set_font_ext(ftDefault, c_white, fa_left, fa_top, 1);

for(var i = 0; i < array_length(items_to_display); i++) {
	
	var _item = items_to_display[i];
	
	if _item[INFO_TABLE.AMOUNT] > 0
		draw_set_color(c_white);
	else
		draw_set_color(c_orange);
	
	draw_text_ext_transformed(_x_offset, _y_offset, _item[INFO_TABLE.TITLE], _sep, _w, _size, _size, _angle);
	
	if _item[INFO_TABLE.TITLE] == "Purchase Power" || _item[INFO_TABLE.TITLE] == "Electricity"
		draw_text_ext_transformed(_amount_offset, _y_offset, string(_item[INFO_TABLE.AMOUNT]), _sep, _w, _size, _size, _angle);
	else
		draw_text_ext_transformed(_amount_offset, _y_offset, string(_item[INFO_TABLE.AMOUNT]) + "/" + string(_item[INFO_TABLE.MAX]), _sep, _w, _size, _size, _angle);
	draw_text_ext_transformed(_flux_offset, _y_offset, _item[INFO_TABLE.FLUX], _sep, _w, _size, _size, _angle);
	
	if instance_exists(oBuildingTool) {
		if _item[INFO_TABLE.COST] != 0
		{
			if (_item[INFO_TABLE.COST]*-1) > _item[INFO_TABLE.AMOUNT]
				draw_set_color(make_color_rgb(242, 111, 111)) // Red
			else
				draw_set_color(c_white)
				
			draw_text_ext_transformed(_cost_offset, _y_offset, _item[INFO_TABLE.COST], _sep, _w, _size, _size, _angle);
		}
		
		if _item[INFO_TABLE.UPKEEP] != 0
		{
			if _item[INFO_TABLE.UPKEEP] > 0
				draw_set_color(make_color_rgb(135, 242, 111)) // Green
			else if _item[INFO_TABLE.AMOUNT] > _item[INFO_TABLE.UPKEEP]
				draw_set_color(c_orange);
			else
				draw_set_color(make_color_rgb(242, 111, 111)) // Red
			if _item[INFO_TABLE.UPKEEP] > 0
				draw_text_ext_transformed(_upkeep_offset, _y_offset,  "+" + string(_item[INFO_TABLE.UPKEEP]), _sep, _w, _size, _size, _angle);
			else
				draw_text_ext_transformed(_upkeep_offset, _y_offset, _item[INFO_TABLE.UPKEEP], _sep, _w, _size, _size, _angle);
		}
	}

    // Move to next line
    _y_offset += 30;
}