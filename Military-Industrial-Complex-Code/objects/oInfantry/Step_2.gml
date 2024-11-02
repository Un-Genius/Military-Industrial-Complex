/// @description Walking Sound

if(x != xprevious || y != yprevious)
{
	// Resume
	audio_resume_sound(moving_sound_id);
	
	// Update Position
	audio_emitter_position(audio_emitter_id, x, y, 0);
	audio_emitter_velocity(audio_emitter_id, lengthdir_x(speed, direction), lengthdir_y(speed, direction), 0);
	
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