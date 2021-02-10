var _zoom = oManager.zoom;

// Draw self but slightly see through
draw_sprite_ext(sprite_index, -1, x, y, image_xscale, image_yscale, direction, hashColor, 1.2-(_zoom - 0.5) / (3 - 0.5));
draw_text_color(x - 64, y - 48, "SUPPRESSED", c_orange, c_orange, c_orange, c_orange, suppressAmount / (suppressMax*2))