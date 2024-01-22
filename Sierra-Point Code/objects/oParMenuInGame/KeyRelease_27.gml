escape_menu = !escape_menu

if !instance_exists(oInGameEscapeMenu)
	escape_menu = true
	
if escape_menu
{
	var snd = audio_play_sound(soundClick, 10, false);
	audio_sound_pitch(snd, random_range(0.9, 1.1));
	
	instance_create(0,0, oInGameEscapeMenu)
}

if !escape_menu
	instance_destroy(oInGameEscapeMenu)