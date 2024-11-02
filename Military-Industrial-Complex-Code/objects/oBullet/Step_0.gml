part_particles_create(global.P_System, x, y, global.BulletTrail, 2);

distance_travelled += speed;

audio_emitter_position(emitter_id, x, y, 0);
	
if (distance_travelled > 5000)
	instance_destroy(self);