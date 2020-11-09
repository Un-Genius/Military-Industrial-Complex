// Increase score 
if captureProgress >= 10 * room_speed
{
	if pointCooldown >= 3 * room_speed
	{
		global.resources += 2;
		
		pointCooldown = 0;
	}
	pointCooldown ++;
}

