/// @description Hit Enemy

var _x = x;
var _y = y;
var _bulletDir = direction;
var _id = id;
var _dam = damage;
		
#region Audio based on camera

var _viewX = camera_get_view_x(view_camera[0]);
var _viewY = camera_get_view_y(view_camera[0]);
var _viewW = camera_get_view_width(view_camera[0]);
var _viewH = camera_get_view_height(view_camera[0]);

var centerX = _viewX + (_viewW/2);
var centerY = _viewY + (_viewH/2);

var _dist = point_distance(_x, _y, centerX, centerY);
			
// Set volume
var _volume = 0.8;
		
// Choose sound
var _snd = snd_impact_person0;

#endregion

var _dmg = damage;
var _hit = false;

with(other)
{
	var partEmit = part_emitter_create(global.P_System);
	part_type_direction(global.pixelPartType, _bulletDir+120, _bulletDir+240, 0, 0);
	part_emitter_region(global.P_System, partEmit, x-5, x+5, y-5, y+5, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.P_System, partEmit, global.pixelPartType, _dmg*1.5); // Burst 50 particles at once

	// Remember to destroy the emitter after the burst so it doesn't keep emitting
	part_emitter_destroy(global.P_System, partEmit);	
	
	hp -= _dmg;
	_hit = true;
	
	if hp <= 0
	{
		instance_destroy();
	}
}

hit = _hit;
		
if _snd != noone
	audio_play_sound_on(emitter_id, _snd, false, 1, _volume, 0, random_range(0.4, 1));
	
instance_destroy(_id);