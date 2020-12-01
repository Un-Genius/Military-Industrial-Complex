/// @description Update direction
if point_distance(x, y, goalX, goalY) > 3
{
	pathX = x;
	pathY = y;
	
	alarm[1] = 10;
}