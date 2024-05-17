hovering = gui_is_mouse_over();

if hovering
	exit;

x = mouse_x div 2 * 2;
y = mouse_y div 2 * 2;

var _enum_value = obj_to_enum(buildingType);
var _cost = oFaction.obj_info[_enum_value].cost;
var _click_left_released	= device_mouse_check_button_released(0, mb_left);
var _click_right_released	= device_mouse_check_button_released(0, mb_right);

// Change color if not enough money
if(!compare_resources(global.resources, _cost))
{
	image_blend = c_orange;
	
	if(_click_left_released)
		trace(1, "Not enough supplies.");
}
else
{
	var _collisionObject = instance_place(x, y, oCollision)
	
	// Change color if position available
	if(_collisionObject != noone)
	{
		image_blend = c_red;
		
		if(_click_left_released)
			trace(1, "Something in the way.");
			
		if(_click_right_released)
			if (object_get_parent(_collisionObject.object_index) == oParZoneLocal)
				instance_destroy(_collisionObject);
	}
	else
	{
		image_blend = c_green;
		
		if(_click_left_released)
			spawn_unit(buildingType, x, y);
	}
}