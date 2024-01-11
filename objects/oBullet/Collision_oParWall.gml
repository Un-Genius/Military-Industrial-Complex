var partEmit = part_emitter_create(global.P_System);
part_type_direction(global.pixelPartType, direction+120, direction+240, 0, 0);
part_emitter_region(global.P_System, partEmit, x-5, x+5, y-5, y+5, ps_shape_ellipse, ps_distr_linear);
part_emitter_burst(global.P_System, partEmit, global.pixelPartType, 5); // Burst 50 particles at once

// Remember to destroy the emitter after the burst so it doesn't keep emitting
part_emitter_destroy(global.P_System, partEmit);

instance_destroy(id)