/// @description Vibration

if vibration_force > 0
	create_vibration(x, y, vibration_force);
	
if vibration_frequency > 0
	alarm[1] = vibration_frequency * random_range(0.9, 1.1) * room_speed;