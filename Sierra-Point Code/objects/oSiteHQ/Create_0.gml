// Inherit the parent event
event_inherited();

resupplyTime = 5;
resupplyAmount = 5;

global.resources_max.supplies += 100;
global.resources.supplies = global.resources_max.supplies;

// Add supplies recurrently
alarm[1] = resupplyTime * room_speed;