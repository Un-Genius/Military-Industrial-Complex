/// @description Interface/Unit Display

// Draw Titel
//draw_text(30, 40, "Resources: " + string(global.resources) + " / " + string(global.resources_max));

var i = 0;
var _value = ds_grid_get(global.instGrid, i, 0);

var _key_shft	= keyboard_check(vk_shift);

if _key_shft
{
	var special_sprite = spr_order;
	
	if left_mouse_state == mouse_type.box // Change if making a mouse box
		special_sprite = spr_regroup;
	
	draw_sprite_ext(special_sprite, 0, device_mouse_x_to_gui(0)-32, device_mouse_y_to_gui(0)-16, 0.5,0.5,0,image_blend, 1);
}