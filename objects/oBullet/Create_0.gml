// bullet object create event
distance_travelled = 0;
damage = 0;

shooter_id = -1;

/*
part_type_direction(global.shootSpark, image_angle-90, image_angle-90, 0, 0);
part_particles_create(global.P_System, x, y, global.shootSpark, 2);
		
part_type_direction(global.shootSpark, image_angle+90, image_angle+90, 0, 0);
part_particles_create(global.P_System, x, y, global.shootSpark, 2);
*/
randAudio("snd_smallArmsFire", 9, 0.1, 0.01, 0.8, 1.2, x, y);
