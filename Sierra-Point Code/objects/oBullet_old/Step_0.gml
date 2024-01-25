// Decrease accuracy over distance
accuracy--;

// Accuracy reached 0
if accuracy <= 0
{		
	// Play sound
	randAudio("snd_impact_ground", 2, 0.1, 0.02, 0.8, 1.5, x, y);
	
	#region Create dirt particles

	part_type_direction(global.dirt, direction - 55, direction + 55, 0, 0);
	part_particles_create(global.P_System, x, y, global.dirt, 20);

	#endregion
	
	// Hit floor
	instance_destroy(self);
}

// Out of bounds
if x < 0 || x > room_width || y < 0 || y > room_height
{
	instance_destroy(self);
}

if(collision_point(x, y, oWall, false, true))
	instance_destroy(self);

#region Damage collision

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
	}
	
	if(_team != team || team == 0) && _numColor != numColor
	{		
		// Damage effect
		if accuracy > _cover
		{
			var dmg, pen;
				
			switch _unit
			{
				case OBJ_TYPE.inf:
					// Find damage type for infantry
					switch bulletType
					{
						case GUN_TYPE.lightCan:	dmg = 1		pen = 3	break;
						case GUN_TYPE.mediumCan:	dmg = 5		pen = 3	break;
						case GUN_TYPE.heavyCan:	dmg = 0.67	pen = 2	break;
						case GUN_TYPE.rifle:		dmg = 0.05	pen = 1 break;
						case GUN_TYPE.lightMG:	dmg = 0.04	pen = 1 break;
						case GUN_TYPE.mediumMG:	dmg = 0.14	pen = 1 break;
						case GUN_TYPE.heavyMG:	dmg = 0.34	pen = 2 break;
						case GUN_TYPE.ATGM:		dmg = 5		pen = 3	break;
					}
					break;
			
				case OBJ_TYPE.building:
				case OBJ_TYPE.air:
				case OBJ_TYPE.gnd:
					// Find damage type for Armor and Air
					switch bulletType
					{
						case GUN_TYPE.lightCan:	dmg = 0.14	pen = 3	break;
						case GUN_TYPE.mediumCan:	dmg = 0.2	pen = 3	break;
						case GUN_TYPE.heavyCan:	dmg = 0.03	pen = 2	break;
						case GUN_TYPE.rifle:		dmg = 0.2	pen = 1	break;
						case GUN_TYPE.lightMG:	dmg = 0.15	pen = 1	break;
						case GUN_TYPE.mediumMG:	dmg = 0.09	pen = 1	break;
						case GUN_TYPE.heavyMG:	dmg = 0.14	pen = 2	break;
						case GUN_TYPE.ATGM:		dmg = 0.4	pen = 3	break;
					}
					break;
			}
			
			if _unit == OBJ_TYPE.building && bulletType == GUN_TYPE.heavyCan
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
			
			randAudio("snd_impact_person0", 0, 0.2, 0.05, 2, 3, x, y);
			
			#region Create blood particles
			
			// Have it off center
			var _x = x + lengthdir_x(8, direction);
			var _y = y + lengthdir_y(8, direction);

			part_type_direction(global.blood, direction - 55, direction + 55, 0, 0);
			part_particles_create(global.P_System, _x, _y, global.blood, 20);

			#endregion
	
			// Delete self
			instance_destroy(self);
		}
		else
		{
			// Suppressing noise
			randAudio("snd_bulletFlyingBy", 0, 0.2, 0.05, 0.8, 1.2, x, y);
		}
	}
}

#endregion

#region Create smoke particles

part_type_orientation(global.bulletTrail, direction, direction, 0, 0, 0);
part_type_direction(global.bulletTrail, direction, direction, 0, 0);
part_particles_create(global.P_System, x, y, global.bulletTrail, 2);

#endregion