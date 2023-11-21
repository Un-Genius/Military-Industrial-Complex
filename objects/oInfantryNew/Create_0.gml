#region Identification	Variables
object_name = "oInfantryNew";
#endregion
#region Movement		Variables
default_speed = 1;
fast_speed = 1.8;
#endregion
#region Pathfinding		Variables
path = path_add();
pathGoalX = x;
pathGoalY = y;
selected	= false;
#endregion
#region Health			Variables
max_health = 1;
health = max_health;
#endregion
#region State Machine	Variables
sm = new StateMachine();

#region Idle state
idleState = new State();
idleState.update = function() {
	if (enemy_in_range()) {
	    sm.swap(attackState); // Switch to Attack state if an enemy is in range
	}
};
#endregion
#region MoveToLocation state
moveToLocState = new State();
moveToLocState.create = function() {
    // Within moveToLocState's update
	if (distance_to_point(pathGoalX, pathGoalY) < 5) {
	    sm.swap(idleState); // Switch to Idle when close to the target
	}
};
moveToLocState.update = function() {
    // Move toward target position logic
};
#endregion
#region Attack state
attackState = new State();
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