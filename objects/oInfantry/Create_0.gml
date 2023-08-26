#region Modifiable		Variables

// Identification		Variables
objectName = "oInfantryNew";

// Health				Variables
maxHealth = 1;
health = maxHealth;

// Movement				Variables
moveSpeed = 1;
runSpeed = 1.8;

#endregion

#region Pathfinding		Variables
path = path_add();
pathGoalX = x;
pathGoalY = y;
selected	= false;
#endregion

#region Squad Identification Variables

squadObjectID = noone;

#endregion

#region State Machine	Variables
sm = new StateMachine();

#region Idle state
idleState = new State();
idleState.stateName = "idle";
idleState.update = function() {
	/*if (enemy_in_range()) {
	    sm.swap(attackState); // Switch to Attack state if an enemy is in range
	}*/
};
#endregion
#region MoveToLocation state
moveToLocState = new State();
moveToLocState.stateName = "moveToLocState";
moveToLocState.create = function() {
	path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
	path_goal_find(x, y, pathGoalX, pathGoalY, path);
};
moveToLocState.update = function() {
	
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
				sm.swap(idleState);
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
	x += lengthdir_x(moveSpeed, _pathDir);
	y += lengthdir_y(moveSpeed, _pathDir);
		
	#endregion
	
    if (distance_to_point(pathGoalX, pathGoalY) < 5) {
	    sm.swap(idleState); // Switch to Idle when close to the target
	}
};
#endregion
#region Attack state
attackState = new State();
attackState.stateName = "attackState";
attackState.update = function() {
    // Attacking logic here, such as find target and shoot
};
#endregion

// Start with Idle state
sm.swap(idleState);
#endregion

#region Sound Effects
// Play walking sound
movingSound = audio_play_sound(snd_smallArmsWalk0, 110, true);

// Randomize position
audio_sound_set_track_position(movingSound, random_range(0, 5));

// Set volume
audio_sound_gain(movingSound, 0.05, 0);
		
// Randomize pitch
audio_sound_pitch(movingSound, random_range(0.8, 1.2));

// Pause
audio_pause_sound(movingSound);
#endregion

#region Spawn in the Open
while instance_place(x, y, oHQ) || instance_place(x, y, oObject)
{
	x += irandom_range(-2, 2);
	y += irandom_range(-2, 2);
}
#endregion