/// @description lower accuracy over distance

accuracy--;

// Check if accuracy reached 0
if accuracy <= 0
{
	// Hit floor
	instance_destroy(self);
}

alarm[0] = 10;