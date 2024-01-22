/// @description --PUT YOUR COMMANDS ON THIS EVENT--

/* 
put them on your inherited buttons and 
call this parent event with event_inherited();
to get the sounds and other behaviors
*/

if object_type == noone
{
	dbg("Error with figuring out the object type")
	exit;
}

#region SOUND

var snd = audio_play_sound(soundClick, 10, false);
audio_sound_pitch(snd, random_range(0.9, 1.1));

#endregion

var _new_zone = object_type;

with(oPlayer)
{
	var _prev_zoning = zoning;

	 zoning = (zoning == _new_zone) ? -1 : _new_zone;

	if(_prev_zoning == zoning)
		exit;

	if zoning == -1
	{
		if instance_exists(buildingPlaceholder)
			instance_destroy(buildingPlaceholder);

		buildingPlaceholder = noone;
		exit;
	}

	_prev_zoning = zoning;

	with(buildingPlaceholder)
	{
		buildingType = _prev_zoning;
		event_user(0);
	}
}