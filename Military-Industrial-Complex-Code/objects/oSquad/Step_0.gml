if !ds_list_size(squad) > 0
{
	instance_destroy(self);
	exit;
}
	
var _size = ds_list_size(squad);
var _selected_amount = 0;

var _x = 0;
var _y = 0;

moving_target = [];
ds_list_clear(shooting_targets);

// Loop through squad
for(var i = 0; i < _size; i++)
{
	var _inst = ds_list_find_value(squad, i);
	
	if !instance_exists(_inst)
	{
		ds_list_delete(squad, i);
		continue;
	}
	
	_x += _inst.x;
	_y += _inst.y;
	
	if _inst.selected
		_selected_amount++;
	
	var _moving = false
	var _inst_x = 0
	var _inst_y = 0
	var _target = noone
	with(_inst)
	{
		if !is_idle(m_sm)
		{
			_moving = true
			_inst_x = goal_x
			_inst_y = goal_y
		}
		if a_sm.state_name == "a_shoot"
		{
			_target = target_inst
		}
	}
	
	if _moving
		array_push(moving_target, [_inst_x, _inst_y]);
	
	if _target != noone && ds_list_find_index(shooting_targets, _target) == -1
		ds_list_add(shooting_targets, _target)
}

// Get the average of target position
moving_x = 0
moving_y = 0
var _moving_array_len = array_length(moving_target)
if _moving_array_len > 0
{
	for(var i = 0; i < _moving_array_len; i++)
	{
		moving_x += moving_target[i][0];
		moving_y += moving_target[i][1];
	}
	moving_x /= _moving_array_len
	moving_y /= _moving_array_len
}

// calculate average
_x = _x/_size;
_y = _y/_size;

// Overwrite current position
x = _x;
y = _y;

selected = false;

if _selected_amount >= _size
	selected = true;

if selected
	image_blend = c_yellow;
else
	image_blend = c_white;

image_alpha = clamp(1 - (oPlayer.zoom - 0.5)/(10-9), 0.1, 1);

depth = -room_height-y;