var _viewX = camera_get_view_x(view_camera[0]);
var _viewY = camera_get_view_y(view_camera[0]);
var _viewW = camera_get_view_width(view_camera[0]);
var _viewH = camera_get_view_height(view_camera[0]);

var centerX = _viewX + (_viewW/2);
var centerY = _viewY + (_viewH/2);

var _dist = point_distance(x, y, centerX, centerY);
			
// Set volume
var _volume = 0.3;
		
// Choose sound
var _snd = noone;

if oPlayer.zoom-0.5 < 0.4
{
	if _dist <= 1000
	{
		_volume = clamp((2000 - _dist) / 800, 0, 0.8);
		_snd = choose(snd_impact_ground0, snd_impact_ground1, snd_impact_ground2);
	}
	else
	{
		if _dist > 1000
		{
			_volume = clamp((2000 - _dist) / 800, 0, 0.8);
			_snd = choose(snd_impact_ground0, snd_impact_ground1, snd_impact_ground2);
		}
	}
}