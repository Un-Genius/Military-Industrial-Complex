audio_emitter_position(emitter_id, x, y, 0);
audio_emitter_velocity(emitter_id, lengthdir_x(speed, direction), lengthdir_y(speed, direction), 0)

randAudio("snd_smallArmsFire", 9, 0.7, 0.05, 0.8, 1.2, x, y, emitter_id);