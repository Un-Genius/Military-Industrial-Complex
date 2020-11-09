#region Sprites management

dir = point_direction(x, y, preX, preY) - 90;
	
image_angle += sin(degtorad(dir - image_angle)) * 15;

#endregion
