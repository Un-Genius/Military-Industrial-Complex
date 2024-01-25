// Inherit the parent event
event_inherited();

resupplyTime = 5;
resupplyAmount = 5;

// Add supplies recurrently
alarm[1] = resupplyTime * room_speed;