/// @description --PUT YOUR COMMANDS ON THIS EVENT--

/* 
put them on your inherited buttons and 
call this parent event with event_inherited();
to get the sounds and other behaviors
*/


#region SOUND

var snd = audio_play_sound(soundClick, 10, false);
audio_sound_pitch(snd, random_range(0.9, 1.1));

#endregion

room_goto(rm_map_town_1v1)