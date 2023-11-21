/// @description Shooting smoke particles

// Have it off center
var _x = x - lengthdir_x(20, direction);
var _y = y - lengthdir_y(20, direction);

part_type_direction(global.shootSmoke, direction - 25, direction + 25, 0, 10);
part_particles_create(global.P_System, _x, _y, global.shootSmoke, 20);