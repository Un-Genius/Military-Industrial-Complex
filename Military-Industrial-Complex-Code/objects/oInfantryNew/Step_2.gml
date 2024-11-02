/// @description Walking Sound

if(x != xprevious || y != yprevious)
{
	// Resume
	audio_resume_sound(moving_sound_id);
	
	// Set volume
	audio_sound_gain(moving_sound_id, 0.05, 20);
}
else
{
	// Set volume
	audio_sound_gain(moving_sound_id, 0, 20);
	
	// Pause
	audio_pause_sound(moving_sound_id);
}