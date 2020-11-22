#region Sprites management

if state == action.attacking || moveState == action.moving
{	
	// Set direction
	if state != action.attacking
		dir = point_direction(x, y, oldPathX, oldPathY) - 180;
	
	image_angle += sin(degtorad(dir - image_angle)) * 15;
}

#endregion

#region Get data

var _key_ctrl				= keyboard_check(vk_control);
var _click_left_released	= mouse_check_button_released(mb_left);

var _mouse_x = device_mouse_x(0);
var _mouse_y = device_mouse_y(0);

with(oPlayer)
{
	// MouseBox data
	var _mousePress	= mousePress;
	
	var _mousePress_x = mouseLeftPress_x;
	var _mousePress_y = mouseLeftPress_y;
}

var _mouseDragAmount = point_distance(_mousePress_x, _mousePress_y, _mouse_x, _mouse_y);

#endregion

#region MouseBox

// Check for mouseBox
if _mousePress == 1
{
	// Check for collision
	if collision_rectangle(_mousePress_x, _mousePress_y, mouse_x, mouse_y, self, false, false)
	{
		add_Inst(global.instGrid, 0, id);
		selected = true;
	}
	else
	{
		#region Unselect from mouseBox
		
		if !_key_ctrl
		{
			var _x = find_Inst(global.instGrid, 0, id);
			if _x != -1
				wipe_Slot(global.instGrid, _x, 0);
		}

		#endregion
	}
}

#endregion

#region Dragging unit around

if selected && _mousePress == 2 && _mouseDragAmount >= 3
{
	release = true;
}

if _click_left_released && release
{
	// Drop instance
	release = false;
	
	update_state(-1, action.idle);
	
	// Set goal
	goalX	= _mouse_x;
	goalY	= _mouse_y;
}

#endregion

#region Move to position

if point_distance(x, y, goalX, goalY) > 3
{	
	if moveState != action.moving
	{	
		// Start pathfind
		scr_pathfind(goalX, goalY, moveSpd);
		
		#region Update position for everyone else

		// Find self in list
		var _pos = ds_list_find_index(global.unitList, id)

		// Send position and rotation to others
		var _packet = packet_start(packet_t.move_unit);
		buffer_write(_packet, buffer_u16, _pos);
		buffer_write(_packet, buffer_f32, goalX);
		buffer_write(_packet, buffer_f32, goalY);
		packet_send_all(_packet);

		#endregion
		
		update_state(-1, action.moving);
	}
}
else
{
	update_state(-1, action.idle);
}

#endregion

#region Health

if hp <= 0
	instance_destroy(self);

#endregion

#region Resources

// Check if needed
if resCarry != maxResCarry
{
	var _HQ = collision_circle(x, y, 150, oHQ, false, true);
		
	// Check if HAB or HQ nearby
	if _HQ
	{
		resCarry = maxResCarry;
	}
	else
	{
		// Get resources if not transport
		if object_index != oTransport
		{
			var _HAB = collision_circle(x, y, 150, oHAB, false, true);
		
			if _HAB && _HAB.resCarry > 0
			{
				// Find needed resources
				var _reqRes = maxResCarry - resCarry;
			
				// Find how much resources other can supply
				_reqRes -= _HAB.resCarry;
			
				// Fill request
				if _reqRes - _HAB.resCarry < 0
				{
					resCarry = maxResCarry;
					_HAB.resCarry -= maxResCarry;
				}
				else
				{
					resCarry = _reqRes - _HAB.resCarry;
					_HAB.resCarry -= _HAB.resCarry;
				
				}
			}
			else
			{
				var _TRANS = collision_circle(x, y, 150, oTransport, false, true);
				
				if _HAB && _HAB.resCarry > 0
				{
					// Find needed resources
					var _reqRes = maxResCarry - resCarry;
			
					// Find how much resources other can supply
					_reqRes -= _TRANS.resCarry;
			
					// Fill request
					if _reqRes - _TRANS.resCarry < 0
					{
						resCarry = maxResCarry;
						_TRANS.resCarry -= maxResCarry;
					}
					else
					{
						resCarry = _reqRes - _TRANS.resCarry;
						_TRANS.resCarry -= _TRANS.resCarry;
					}
				}
			}
		}
	}
}

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
					if state != action.reloading || state != action.aiming
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