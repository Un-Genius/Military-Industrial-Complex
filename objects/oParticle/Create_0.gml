/// @description Create Particle layer

global.P_System = part_system_create_layer(layer, true);

#region Particle BulletTrail

// Create particle
global.bulletTrail = part_type_create();

// Give it attributes
part_type_shape(global.bulletTrail, pt_shape_cloud);

part_type_size(global.bulletTrail, 0.02, 0.05, 0.002, 0.002);

part_type_scale(global.bulletTrail, 4, 1);

part_type_color2(global.bulletTrail, c_gray, c_dkgray);

part_type_alpha2(global.bulletTrail, 0.4, 0);

part_type_speed(global.bulletTrail, 8, 12, -2, 0);

//part_type_direction(global.bulletTrail, 0, 0, 0, 0);

part_type_blend(global.bulletTrail, false);

part_type_life(global.bulletTrail, 10, 30);

#endregion

#region Particle Blood

// Create particle
global.blood = part_type_create();

// Give it attributes
part_type_shape(global.blood, pt_shape_pixel);

part_type_size(global.blood, 1, 2, -0.075, 0.05);

part_type_color_rgb(global.blood, 80, 255, 1, 15, 1, 15);

part_type_alpha2(global.blood, 1, 0.4);

part_type_speed(global.blood, 2, 3, -0.20, 0.4);

//part_type_direction(global.blood, 0, 359, 0, 0);

//part_type_gravity(global.blood, 0.2, 270)

part_type_blend(global.blood, false);

part_type_life(global.blood, 35, 60);

#endregion

#region Particle Dirt

// Create particle
global.dirt = part_type_create();

// Give it attributes
part_type_shape(global.dirt, pt_shape_pixel);

part_type_size(global.dirt, 1, 2, -0.075, 0.05);

part_type_color_rgb(global.dirt, 90, 140, 50, 85, 20, 45);

part_type_alpha2(global.dirt, 1, 0.4);

part_type_speed(global.dirt, 2, 3, -0.20, 0.4);

//part_type_direction(global.dirt, 0, 359, 0, 0);

//part_type_gravity(global.dirt, 0.2, 270)

part_type_blend(global.dirt, false);

part_type_life(global.dirt, 35, 60);

#endregion

#region Particle Shoot

#region Particle Shoot Smoke

// Create particle
global.shootSmoke = part_type_create();

// Give it attributes
part_type_shape(global.shootSmoke, pt_shape_pixel);

part_type_size(global.shootSmoke, 1, 2, -0.075, 0.05);

part_type_color2(global.shootSmoke, c_gray, c_dkgray)

part_type_alpha2(global.shootSmoke, 0.6, 0);

part_type_speed(global.shootSmoke, 2, 3, -0.20, 0.4);

//part_type_direction(global.shootSmoke, 0, 359, 0, 0);

//part_type_gravity(global.shootSmoke, 0.2, 270)

part_type_blend(global.shootSmoke, false);

part_type_life(global.shootSmoke, 35, 60);

#endregion

#region Particle Shoot Fire

// Create particle
global.shootFire = part_type_create();

// Give it attributes
part_type_shape(global.shootFire, pt_shape_pixel);

part_type_size(global.shootFire, 1, 2, -0.075, 0.05);

part_type_color_rgb(global.shootFire, 90, 140, 50, 85, 20, 45);

part_type_alpha2(global.shootFire, 1, 0.4);

part_type_speed(global.shootFire, 2, 3, -0.20, 0.4);

//part_type_direction(global.shootFire, 0, 359, 0, 0);

//part_type_gravity(global.shootFire, 0.2, 270)

part_type_blend(global.shootFire, false);

part_type_life(global.shootFire, 35, 60);

#endregion

#endregion