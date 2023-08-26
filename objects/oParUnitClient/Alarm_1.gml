/// @description Update direction
if point_distance(x, y, pathGoalX, pathGoalY) > 3
{
	oldPathX = pathX;
	oldPathY = pathY;
	
	pathX = x;
	pathY = y;
	
	alarm[1] = 10;
}