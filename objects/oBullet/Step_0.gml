// Update Direction
direction = dir;

// Update image
image_angle = direction;

// Update Speed
speed = spd;

// Decrease accuracy over distance
accuracy--;

// Check if accuracy reached 0
if accuracy <= 0
{
	// Hit floor
	instance_destroy(self);
}

if(collision_point(x, y, oWall, false, true))
	instance_destroy(self);

// Store collision
var _collision = collision_point(x, y, oObject, false, true);

// Check for collision
if _collision
{
	// Find variables
	with _collision
	{
		var _team		= team;
		var _numColor	= numColor;
		var _unit		= unit;
		var _armor		= armor;
		var _cover		= cover;
	}
	
	if(_team != team || team == 0) && _numColor != numColor
	{
		if accuracy > _cover
		{
			var dmg, pen;
				
			switch _unit
			{
				case unitType.inf:
					// Find damage type for infantry
					switch bulletType
					{
						case gunType.lightCan:	dmg = 1		pen = 3	break;
						case gunType.mediumCan:	dmg = 5		pen = 3	break;
						case gunType.heavyCan:	dmg = 0.67	pen = 2	break;
						case gunType.rifle:		dmg = 0.05	pen = 1 break;
						case gunType.lightMG:	dmg = 0.04	pen = 1 break;
						case gunType.mediumMG:	dmg = 0.14	pen = 1 break;
						case gunType.heavyMG:	dmg = 0.34	pen = 2 break;
						case gunType.ATGM:		dmg = 5		pen = 3	break;
					}
					break;
			
				case unitType.building:
				case unitType.air:
				case unitType.gnd:
					// Find damage type for Armor and Air
					switch bulletType
					{
						case gunType.lightCan:	dmg = 0.14	pen = 3	break;
						case gunType.mediumCan:	dmg = 0.2	pen = 3	break;
						case gunType.heavyCan:	dmg = 0.03	pen = 2	break;
						case gunType.rifle:		dmg = 0.2	pen = 1	break;
						case gunType.lightMG:	dmg = 0.15	pen = 1	break;
						case gunType.mediumMG:	dmg = 0.09	pen = 1	break;
						case gunType.heavyMG:	dmg = 0.14	pen = 2	break;
						case gunType.ATGM:		dmg = 0.4	pen = 3	break;
					}
					break;
			}
			
			if _unit == unitType.building && bulletType == gunType.heavyCan
			{
				dmg = 0;
				pen = 2;
			}
		
			// Crirical hit
			if accuracy / 1.5 > _cover
				dmg *= 1.5;
	
			// Deal damage
			if pen >= _armor
				_collision.hp -= dmg;
	
			// Delete self
			instance_destroy(self);
		}
	}
}