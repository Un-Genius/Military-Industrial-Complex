#region Sprites management

if state == action.attacking || moveState == action.moving
{	
	// Set direction
	if state != action.attacking
		dir = point_direction(x, y, oldPathX, oldPathY) - 180;
	
	image_angle += sin(degtorad(dir - image_angle)) * 15;
}

#endregion

#region Move to position

if point_distance(x, y, goalX, goalY) > 3
{	
	if moveState != action.moving
	{	
		// Start pathfind
		scr_pathfind();
		
		#region Update position for everyone else

		// Find self in list
		var _pos = ds_list_find_index(global.unitList, id)

		// Send position and rotation to others
		var _packet = packet_start(packet_t.move_unit);
		buffer_write(_packet, buffer_u16, _pos);
		buffer_write(_packet, buffer_f32, x);
		buffer_write(_packet, buffer_f32, y);
		buffer_write(_packet, buffer_f32, goalX);
		buffer_write(_packet, buffer_f32, goalY);
		packet_send_all(_packet);

		#endregion
		
		update_state(-1, action.moving);
	}
}
else
{
	if moveState != action.idle
		update_state(-1, action.idle);
}

#endregion

#region Move out of the way

if moveState == action.idle && (unit != unitType.air || unit != unitType.building)
{
	var _collision = collision_circle(x, y, 5, oParUnit, false, true);
	
	if _collision
	{
		if _collision.moveState != action.idle && (_collision.unit == unit || _collision.unit = unitType.gnd)
		{
			var _dir = -point_direction(x, y, _collision.x, _collision.y);
		
			var _newPosX = lengthdir_x(10, _dir);
			var _newPosY = lengthdir_y(10, _dir);
		
			goalX += _newPosX;
			goalY += _newPosY;
		}
	}
}

#endregion

#region Enter/Chase Vehicle

if enterVeh != noone && unit == unitType.inf
{	
	with enterVeh
	{
		// Find new position
		var _newX = x - lengthdir_x(((sprite_width/2)*image_xscale) + 28, image_angle);
		var _newY = y - lengthdir_y(((sprite_width/2)*image_xscale) + 28, image_angle);
	}
	
	if point_distance(_newX, _newY, goalX, goalY) > 4
	{	
		update_state(-1, action.idle);

		veh_position(enterVeh);
	}
	else
	{
		if point_distance(x, y, _newX, _newY) < 8
		{
			enter_Vehicle_One(enterVeh);
		}
	}
}

#endregion

#region Reactive after leaving Vehicle

if riding
{
	with(enterVeh)
	{
		// Find new position
		var _newX = x - lengthdir_x(((sprite_width/2)*image_xscale) + 28, image_angle);
		var _newY = y - lengthdir_y(((sprite_width/2)*image_xscale) + 28, image_angle);
	}

	x = _newX;
	y = _newY;
		
	// set as goal
	goalX = _newX;
	goalY = _newY;
	
	// Make sure to stop pathfind
	path_end();
		
	// Delete from vehicles list
	var _index = ds_list_find_index(enterVeh.riderList, id)
	ds_list_delete(enterVeh.riderList, _index);
	
	// Reset variables
	enterVeh	= noone;
	riding		= false;
}

#endregion

#region Health

if hp <= 0
	instance_destroy(self);

#endregion

#region Attack

// Stop if its not hostile or reloading
if gun != noone && state != action.reloading 
{
	if resCarry > 0 
	{
		// Update frequency
		bulletTiming += 0.01 * room_speed;
		
		if bulletTiming > bulletFrequency
		{
			var _enemy_list = ds_list_create();
			
			var _enemy = collision_circle_list(x, y, range, oObject, false, true, _enemy_list, true);
			
			if _enemy > 0
			{
				// Find variables
				for(var i = 0; i < _enemy; i++)
				{
					// Get instance
					var _inst = ds_list_find_value(_enemy_list, i);
					
					with(_inst)
					{
						var _team		= team;
						var _numColor	= numColor;
					}
					
					// Check if its an enemy
					if(_team != team || team == 0) && _numColor != numColor
					{
						// Check if wall is in the way
						if(!collision_line(x, y, _inst.x, _inst.y, oParWall, false, true))
						{
							_enemy = _inst;
							break;
						}
					}
				}
				
				if instance_exists(_enemy) && _enemy > 1000 
				{				
					if state == action.idle 
					{
						update_state(action.aiming, -1);
					}
					
					if state == action.attacking
					{	
						// Hold x, y locally
						var _x = x;
						var _y = y;
						
						// Get position
						with(_enemy)
						{
							var _enemyX = x;
							var _enemyY = y;
							
							// Check if he is moving
							if moveState == action.moving
							{
								// Figure out how far ahead to point using bullet speed and distance
								var _interceptionFactor = point_distance(_x, _y, x, y) / 14
								
								_enemyX	+= lengthdir_x(moveSpd * _interceptionFactor, dir);
								_enemyY	+= lengthdir_y(moveSpd * _interceptionFactor, dir);
							}
						}
						
						// Point at target
						var _angle = point_direction(x, y, _enemyX, _enemyY);
												
						// Point direction of enemy
						dir = _angle;
						
						var _x = x + lengthdir_x(26, _angle-10);
						var _y = y + lengthdir_y(26, _angle-10);
						
						// Shoot bullet
						var _bullet		= instance_create_layer(_x, _y, "Bullets", oBullet);
				
						// Add randomness
						var _adjustment = random_range(0.75, 1.25);
						
						_angle += _adjustment * choose(-1, 1);
				
						// Give data
						var _gun		= gun;
						var _team		= team;
						var _numColor	= numColor;
				
						#region Find and create accuracy rating
				
						var _accuracy;
				
						// Find default accuracy
						switch _gun
						{
							case gunType.lightCan:	_accuracy = 160	break;
							case gunType.mediumCan:	_accuracy = 180	break;
							case gunType.heavyCan:	_accuracy = 60	break;
							case gunType.rifle:		_accuracy = 120	break;
							case gunType.lightMG:	_accuracy = 100	break;
							case gunType.mediumMG:	_accuracy = 90	break;
							case gunType.heavyMG:	_accuracy = 80	break;
							case gunType.ATGM:		_accuracy = 200	break;
						}
				
						_accuracy *= _adjustment * 3;
						
						#endregion
				
						// Update bullet
						with(_bullet)
						{			
							// Set direction
							dir			= _angle;
				
							// Set bullet type
							bulletType	= _gun;
					
							// Set accuracy for distance and hit potential
							accuracy	= _accuracy;
					
							// Set team for friendly fire
							team		= _team;
							numColor	= _numColor;
						}
				
						// Update players
						var _packet = packet_start(packet_t.shoot_bullet);
						buffer_write(_packet, buffer_u16, _x);
						buffer_write(_packet, buffer_u16, _y);
						buffer_write(_packet, buffer_u16, _angle);
						buffer_write(_packet, buffer_u8,  _gun);
						buffer_write(_packet, buffer_u8,  _accuracy);
						buffer_write(_packet, buffer_u16, _team);
						buffer_write(_packet, buffer_u16, _numColor);
						packet_send_all(_packet);
						
						// Set gun settings
						bulletTiming = 0;
						clipSize--;
			
						// Start reloading and stops shooting animation if no ammo
						if !clipSize 
						{
							update_state(action.reloading, -1);
							resCarry -= ammoUse;						
							
							if resCarry <= 0
							{
							  update_state(action.idle, -1);			
							  
							}
						}
					}
				}
				else
				{
					if (state != action.reloading || state != action.aiming) && state != action.idle
					{
						update_state(action.idle, -1);
					}
				}
			}
			else
			{
			 	if state == action.attacking
				{
					update_state(action.idle, -1);
				}
			}
			
			// Destroy list
			ds_list_destroy(_enemy_list);
		}
	}
}

#endregion

#region State Machine

// idle, move, attack, reload
switch state
{
	case action.idle:
		
		// Find index
		var _sprite = asset_get_index(unitName + "_" + string(state));
		
		image_speed = sprite_get_speed(_sprite);
		
		if distance_to_point(goalX, goalY) < 3
			image_speed = 0;
		
		break;
				
	case action.attacking:
		
		break;
		
	case action.aiming:
			
		// Stop reloading if 
		if image_index > image_number - 1
		{
			clipSize = maxClipSize;
			
			update_state(action.attacking, -1);
		}

		break;
		
	case action.reloading:
		
		// Stop reloading if 
		if image_index > image_number - 1
		{
			clipSize = maxClipSize;
			
			update_state(action.attacking, -1);
		}
		
		break;
}

#endregion