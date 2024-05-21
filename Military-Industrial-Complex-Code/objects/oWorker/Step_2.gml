/// @description Walking Sound

if(x != xprevious || y != yprevious)
{
	// Resume
	audio_resume_sound(movingSound);
	
	// Set volume
	audio_sound_gain(movingSound, 0.05, 20);
}
else
{
	// Set volume
	audio_sound_gain(movingSound, 0, 20);
	
	// Pause
	audio_pause_sound(movingSound);
}