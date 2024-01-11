var _width = sprite_get_width(sprite_index);
var _height = sprite_get_height(sprite_index);

var _xScale = _width/32;
var _yScale = _height/32;

draw_sprite_ext(sZone, 0, x, y, _xScale, _yScale, 0, image_blend, 1);

draw_self();