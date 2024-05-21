draw_self();
draw_set_font(ftSmall);

var _resource_names = struct_get_names(resources);
var _display_line = 0;
var _green = make_color_rgb(135, 242, 111);

for(var i = 0; i < array_length(_resource_names); i++) {
	var _value = struct_get(resources, _resource_names[i]);
	
	if _value > 0
	{
		 draw_text_color(x+8, y-1 + (_display_line*12), _resource_names[i] + string(_value), _green,_green,_green,_green, image_alpha);
		_display_line++
	}
}