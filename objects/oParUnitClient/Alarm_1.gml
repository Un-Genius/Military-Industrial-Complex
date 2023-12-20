/// @description Update direction
if point_distance(x, y, goal_x, goal_y) > 3
{
	oldPathX = pathX;
	oldPathY = pathY;
	
	pathX = x;
	pathY = y;
	
	alarm[1] = 10;
}