#region Effects

var _spd = movementSpeed;

#endregion

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

if point_distance(x, y, goal_x, goal_y) > 3
{	
	if moveState != action.moving
	{			
		// Update doppelganger
		path_goal_multiplayer_update(x, y, goal_x, goal_y);
		update_state(-1, action.moving);
		
		// Start pathfind
		path_goal_find(x, y, goal_x, goal_y, path);
	}
	else
	{
		#region Walk the path
		
		var _point = false;
		
		// Loop until next point is found
		while(!_point)
		{
			// Get amount left
			var _amount = path_get_number(path);
			
			// Get next waypoint
			var xx = path_get_x(path, 0);
			var yy = path_get_y(path, 0);
		
			// Delete waypoint if arrived
			if point_distance(x, y, xx, yy) < 3
			{
				// Stop path
				if _amount == 1
				{
					update_state(-1, action.idle);
					_point = true;
				}
				else
					path_delete_point(path, 0);
			}
			else
				_point = true;
		}
		
		// Find direction
		var _pathDir = point_direction(x, y, xx, yy);
		
		// Vector a step
		x += lengthdir_x(_spd, _pathDir);
		y += lengthdir_y(_spd, _pathDir);
		
		#endregion
	}
}
else
{
	if moveState != action.idle
		update_state(-1, action.idle);
}

#endregion

#region Move out of the way

// Increase timer
pushTimer++;

if pushTimer > 0.2 * room_speed
{
	if unit != unitType.air || unit != unitType.building
	{
		var _collision = collision_circle(x, y, 10, oOVLInf, false, true);
	
		if _collision && (_collision.unit == unit || _collision.unit = unitType.gnd)
		{		
			var _dir = -point_direction(x, y, _collision.x, _collision.y);
		
			var _newPosX = lengthdir_x(_spd*1.5, _dir);
			var _newPosY = lengthdir_y(_spd*1.5, _dir);
		
			goal_x += _newPosX;
			goal_y += _newPosY;
			
			pushTimer = 0;
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
	goal_x = _newX;
	goal_y = _newY;
		
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

burstTimer++;

// Stop if its not hostile or reloading or waiting for next burst
if gun != noone && state != action.reloading && (burstMax > burstAmount && burstTimer > burstTiming)
{
	if squadID != noone && squadID.resCarry > 0 
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
					// Aim
					if state == action.idle 
					{
						update_state(action.aiming, -1);
						
						var _callout = random(1);
			
						// Play sound
						if(_callout < 0.1)
							randAudio("snd_smallArmsSpotted", 3, 0.15, 0.05, 0.8, 1.2, x, y);
					}
					
					// Shoot
					if state == action.attacking
					{	
						// Set animation
						image_speed = 1;
						
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
								
								_enemyX	+= lengthdir_x(_spd * _interceptionFactor, dir);
								_enemyY	+= lengthdir_y(_spd * _interceptionFactor, dir);
							}
						}
						
						// Point at target
						var _angle = point_direction(x, y, _enemyX, _enemyY);
												
						// Point direction of enemy
						dir = _angle;
						
						var _x = x + lengthdir_x(26, _angle-10);
						var _y = y + lengthdir_y(26, _angle-10);
						
						// Shoot bullet
						var _bullet		= instance_create_layer(_x, _y, "Bullets", oBullet_old);
				
						// Add randomness
						var _adjustment = random_range(0.65, 1.35);
						
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
						
						// Burst settings
						burstAmount++;
			
						// Start reloading and stops shooting animation if no ammo
						if !clipSize 
						{
							update_state(action.reloading, -1);
							squadID.resCarry -= ammoUse;			
							
							// Play sound
							randAudio("snd_smallArmsReload_start", 0, 1, 0.4, 0.8, 1.2, x, y);
							
							if squadID.resCarry <= 0
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
else
{
	// Wait until next burst
	if(burstAmount >= burstMax)
	{
		burstTimer = 0;
		burstAmount = 0;
	}
	
	// If waiting too long then reset burst
	if(burstTimer > burstTiming * 1.5)
	{
		//burstAmount = 0;
	}
	
	// Set animation
	if(state == action.attacking)
	{
		image_speed = 0;
	}
}

#endregion

#region State Machine

// idle, move, attack, reload
switch state
{
	case action.idle:
		
		// Find index
		var _sprite = asset_get_index(object_name + "_" + string(state));
		
		image_speed = sprite_get_speed(_sprite);
		
		if distance_to_point(goal_x, goal_y) < 3
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
			
			randAudio("snd_smallArmsReload_finish", 0, 1, 0.4, 0.8, 1.2, x, y);
			
			update_state(action.attacking, -1);
		}
		
		break;
}

#endregion

#region Walking Sound

if(moveState == action.moving)
{
	// Resume
	audio_resume_sound(movingSound);
	
	// Set volume
	audio_sound_gain(movingSound, 0.05, 20);
}
else
{
	// Set volume
	audio_sound_gain(movingSound, 0, 20);
	
	// Pause
	audio_pause_sound(movingSound);
}

#endregion