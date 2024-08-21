var _zoom = oPlayer.zoom;

var _col = hash_color;

// Change color if selected
if(selected)
	_col = c_yellow;

// Draw self but slightly see through
draw_set_halign(fa_center)
draw_text_ext_color(x, y-100, object_name, 5, 300, c_white, c_white, c_white, c_white, 0.4-(_zoom - 1) / (3 - 0.5))
draw_sprite_ext(sprite_index, -1, x, y, image_xscale, image_yscale, direction, _col, 0.4-(_zoom - 1) / (3 - 0.5));
draw_set_halign(fa_left)