// bullet object create event
distance_travelled = 0;
damage = 0;
hit = false;

shooter_id = -1;

/*
part_type_direction(global.shootSpark, image_angle-90, image_angle-90, 0, 0);
part_particles_create(global.P_System, x, y, global.shootSpark, 2);
		
part_type_direction(global.shootSpark, image_angle+90, image_angle+90, 0, 0);
part_particles_create(global.P_System, x, y, global.shootSpark, 2);
*/

emitter_id = audio_emitter_create();
alarm[0] = 1;
