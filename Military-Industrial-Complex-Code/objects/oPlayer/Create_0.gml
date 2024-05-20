// Move speed
movementSpeed = 1;

numColor = c_white;
hash_color = findColor(numColor);

var _resources = variable_clone(oFaction.resource_struct);
_resources.supplies += 100;
add_resource(global.resources, _resources);

// Create and clear list
contextInstList = ds_list_create();
ds_list_clear(contextInstList);

squadObjectList = ds_list_create();

contextMenu = false;

maxTroopsInf = 0;

// Duds
goal_x = 0;
goal_y = 0;

// Zoning
zoning = -1;

// Zoom
zoom = 1;
target_zoom = zoom;
cam_smooth	= 0.1;
zoom_smooth	= 0.1;

// Follow target
camera_target = oPlayer;

buildingToolReference = noone;

buildingPlacement = noone;
buildingIntersect = false;

instance_selected = noone;
instances_selected_list = ds_grid_width(global.instGrid);

#region Mouse actions

// Enum for mouse types
enum mouse_type {
    noone,
    pressed,
    released,
    released_twice,
    holding,
    dragging,
    box
}

// Initialize variables
left_mouse_state = mouse_type.noone;
right_mouse_state = mouse_type.noone;
double_click_threshold = 200;
last_left_click_time = -double_click_threshold;
last_right_click_time = -double_click_threshold;

// Mouse starting positions
mouseRightPress_x = device_mouse_x(0);
mouseRightPress_y = device_mouse_y(0);
mouseLeftPress_x = mouse_x;
mouseLeftPress_y = mouse_y;

// Mouse released positions
mouseLeftReleased_x = device_mouse_x(0);
mouseLeftReleased_y = device_mouse_y(0);

// Mouse position in GUI
mouseRightPressGui_x = device_mouse_x_to_gui(0);
mouseRightPressGui_y = device_mouse_y_to_gui(0);

#endregion

// Create Particles
global.Wind_Direction = 270;
global.P_System = part_system_create_layer("Bullets", false);
global.Clouds_System = part_system_create_layer("Clouds", false);

// Create Clouds
repeat(8)
{
	var _cloud = instance_create_layer(0, 0, "Clouds", oCloud);
	_cloud.y = irandom(room_height)-500;
}

#region Pixel Particles
global.pixelPartType = part_type_create();

// Set particle properties
part_type_shape(global.pixelPartType, pt_shape_square);
part_type_size(global.pixelPartType, 0.01, 0.025, 0, 0); // Adjust to your pixel size
part_type_color1(global.pixelPartType, c_white); // Change color as needed
part_type_speed(global.pixelPartType, 1.8, 2.5, -0.01, 0); // Change speed as needed
part_type_gravity(global.pixelPartType, 0.05, 270); // Gravity pulling particles down
part_type_life(global.pixelPartType, room_speed * 0.3, room_speed*0.5); // Lasts between 0.5 to 1 second
#endregion

#region Damaged smoke
global.DamagedSmoke = part_type_create();

// Set particle properties
part_type_shape(global.DamagedSmoke, pt_shape_cloud);
part_type_size(global.DamagedSmoke, 0.4, 0.6, -0.001, 0); // Change size as needed
part_type_color1(global.DamagedSmoke, c_black); // Change color as needed for smoke
part_type_speed(global.DamagedSmoke, 1, 2, 0, 0); // Change speed as needed
part_type_direction(global.DamagedSmoke, global.Wind_Direction-30, global.Wind_Direction+30, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_gravity(global.DamagedSmoke, 0.05, 270); // Gravity pulling particles down
part_type_life(global.DamagedSmoke, room_speed * 0.1, room_speed * 0.2); // Lasts between 2 to 3 seconds
#endregion

#region Engine Smoke
global.EngineSmoke = part_type_create();
part_type_shape(global.EngineSmoke, pt_shape_pixel);
part_type_size(global.EngineSmoke, 0.2, 0.3, 0.1, 0.0025);
part_type_color2(global.EngineSmoke, c_dkgray, c_gray);
part_type_alpha2(global.EngineSmoke, 0.5, 0.07);
part_type_speed(global.EngineSmoke, 0.2, 0.5, -0.005, 0.01);
part_type_direction(global.EngineSmoke, global.Wind_Direction-30, global.Wind_Direction+30, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_blend(global.EngineSmoke, false);
part_type_life(global.EngineSmoke, 50, 120);
#endregion

#region Shoot Smoke
global.shootSpark = part_type_create();
part_type_shape(global.shootSpark, pt_shape_explosion);
part_type_size(global.shootSpark, 0.09, 0.17, -0.001, 0);
part_type_color3(global.shootSpark, c_orange, c_dkgray, c_grey);
part_type_alpha3(global.shootSpark, 0.7, 0.4, 0.1);
part_type_speed(global.shootSpark, 0.5, 0.8, -0.03, 0.01);
part_type_direction(global.shootSpark, 0, 0, 0, 0);
part_type_blend(global.shootSpark, true);
part_type_life(global.shootSpark, 75, 100);
#endregion

#region Bullet Trail
global.BulletTrail = part_type_create();
part_type_shape(global.BulletTrail, pt_shape_pixel);
part_type_size(global.BulletTrail, 0.5, 1, 0, -0.00002);
part_type_color1(global.BulletTrail, c_ltgray);
part_type_alpha2(global.BulletTrail, 0.3, 0.1);
part_type_life(global.BulletTrail, 15, 30);
#endregion

#region Bullet Explosion
global.ExplosionSmoke = part_type_create();
part_type_shape(global.ExplosionSmoke, pt_shape_explosion);
part_type_size(global.ExplosionSmoke, 0.08, 0.15, -0.005, 0.5);
part_type_color3(global.ExplosionSmoke, c_yellow, c_orange, c_dkgray);
part_type_alpha3(global.ExplosionSmoke, 1, 0.8, 0.6);
part_type_speed(global.ExplosionSmoke, 0.4, 1.4, -0.01, 0);
part_type_direction(global.ExplosionSmoke, 0, 359, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_blend(global.ExplosionSmoke, false);
part_type_life(global.ExplosionSmoke, 10, 24);
#endregion

#region Smoke Granade
global.GranadeSmoke = part_type_create();
part_type_shape(global.GranadeSmoke, pt_shape_smoke);
part_type_size(global.GranadeSmoke, 2, 3, 0, 0);
part_type_color1(global.GranadeSmoke, c_white);
part_type_alpha2(global.GranadeSmoke, 0.8, 0.6);
part_type_speed(global.GranadeSmoke, 0.001, 0.01, 0, 0);
part_type_direction(global.GranadeSmoke, global.Wind_Direction-30, global.Wind_Direction+30, 0.2, irandom_range(-2, 2));
part_type_blend(global.GranadeSmoke, false);
part_type_life(global.GranadeSmoke, 12*room_speed, 14*room_speed);
#endregion

#region Dead Tank Smoke
global.DeadTankSmoke = part_type_create();
part_type_shape(global.DeadTankSmoke, pt_shape_smoke);
part_type_size(global.DeadTankSmoke, 0.25, 0.75, 0.0035, 0.0025);
part_type_color2(global.DeadTankSmoke, c_black, c_dkgray);
part_type_alpha2(global.DeadTankSmoke, 0.2, 0.05);
part_type_speed(global.DeadTankSmoke, 0.3, 0.5, 0, 0);
part_type_direction(global.DeadTankSmoke, global.Wind_Direction-30, global.Wind_Direction+30, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_blend(global.DeadTankSmoke, false);
part_type_life(global.DeadTankSmoke, 8*room_speed, 12*room_speed);
#endregion

#region Dirt
global.Dirt = part_type_create();
part_type_shape(global.Dirt, pt_shape_pixel);
part_type_size(global.Dirt, 1, 2, 0, 0);
part_type_scale(global.Dirt, 1, 1);
part_type_color2(global.Dirt, #A52A2A, c_orange);
part_type_alpha2(global.Dirt, 1, 0);
part_type_speed(global.Dirt, 1, 3, 0, 0);
part_type_direction(global.Dirt, 0, 359, 0, 0);
part_type_gravity(global.Dirt, 0.1, 270);
part_type_life(global.Dirt, 30, 60);
part_type_blend(global.Dirt, true);
#endregion