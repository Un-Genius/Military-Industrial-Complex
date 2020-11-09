// Inherit the parent event
event_inherited();

turDir = point_direction(x, y, mouse_x, mouse_y);

// Draw Turret
draw_sprite_ext(turret, 0, x, y, image_xscale, image_yscale, turDir, image_blend, image_alpha);