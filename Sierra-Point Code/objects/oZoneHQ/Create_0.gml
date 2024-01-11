// Inherit the parent event
event_inherited();

resupplyTime = 5;
resupplyAmount = 5;

global.maxSupplies += 100;
global.supplies = global.maxSupplies;

// Add supplies recurrently
alarm[1] = resupplyTime * room_speed;