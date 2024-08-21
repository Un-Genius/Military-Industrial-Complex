var _zoom = oPlayer.zoom;
var _min_alpha = 0.1; // Minimum alpha value to keep the sprite slightly visible
var _alpha = max(_min_alpha, 0.4-(_zoom - 1) / (3 - 0.5));
draw_sprite_ext(sprite_index, -1, x, y, image_xscale, image_yscale, direction, image_blend, _alpha);
