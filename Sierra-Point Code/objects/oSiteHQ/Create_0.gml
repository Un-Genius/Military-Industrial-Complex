// Inherit the parent event
event_inherited();

resupplyTime = 5;
resupplyAmount = 5;

global.resources_max += 100;
global.resources = global.resources_max;

// Add supplies recurrently
alarm[1] = resupplyTime * room_speed;