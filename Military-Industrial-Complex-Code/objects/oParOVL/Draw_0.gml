var _zoom = oCamera.zoom;

var _col = hash_color;

// Change color if selected
if(selected)
	_col = c_yellow;

// Draw self but slightly see through
draw_sprite_ext(sprite_index, -1, x, y, image_xscale, image_yscale, direction, _col, 0.4-(_zoom - 1) / (3 - 0.5));