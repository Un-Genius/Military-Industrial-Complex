#region Modifiable		Variables

// Identification		Variables
object_name = "Infantry";

// Health				Variables
max_health = 4;
health = max_health;

// Movement				Variables
default_speed = 1;
fast_speed = 1.8;

target_inst = noone;

weapon_accuracy = 0.95;
weapon_range = 300;
weapon_damage = 1;
weapon_angle = 0;

weapon_reload_timer = 2*room_speed;
weapon_reload_counter = 0;
weapon_reload_speed = 1;

#region Weapon Stats

// Bullet statistics
bullet_reload_time = 250;
bullet_magazine_size = 24;
bullet_burst_rate = 6;
bullet_burst_delay = 80;
bullet_fire_rate_delay = 100;
bullet_size = 0.25;
bullet_speed = 7;

// Shooting variables
can_shoot = true;              // whether the tank can currently shoot
magazine_count = 0;
burst_count = 0;               // number of bullets fired in current burst
last_shot_time = 0;            // time in milliseconds of last shot
bullet_reload_timer = 0;
#endregion

#endregion

#region Pathfinding		Variables
path = path_add();
pathGoalX = x;
pathGoalY = y;
selected	= false;
#endregion

#region Squad Identification Variables

squadObjectID = noone;

team		= oManager.team+1;		// Which team its on
numColor	= color.red;	// number relating to "red" or "blue" using an enum: color.red = 0
hash_color	= c_red;	// "red" or "blue"

#endregion

#region State Machine	Variables
sm = new StateMachine();

#region Idle state
idleState = new State();
idleState.state_name = "idle";
idleState.update = function() {
	if (enemy_in_range()) {
		randAudio("snd_smallArmsSpotted", 3, 0.15, 0.05, 0.8, 1.2, x, y);
	    sm.swap(attackState);
	}
};
#endregion

#region MoveToLocation state
moveToLocState = new State();
moveToLocState.state_name = "moveToLocState";
moveToLocState.create = function() {
	path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
	path_goal_find(x, y, pathGoalX, pathGoalY, path);
	speed = default_speed;
};
moveToLocState.update = function() {
	
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
	
	direction = _pathDir;
		
	// Vector a step
	//x += lengthdir_x(speed, _pathDir);
	//y += lengthdir_y(speed, _pathDir);
	
    if (distance_to_point(pathGoalX, pathGoalY) < default_speed*1.5) {
	    sm.swap(idleState); // Switch to Idle when close to the target
	}
};
moveToLocState.destroy = function() {
	speed = 0;
}
#endregion

#region Attack state
attackState = new State();
attackState.state_name = "attackState";
attackState.create = function() {
	//target_inst = nearest_enemy();
}
attackState.update = function() {
	target_inst = nearest_enemy();
	weapon_angle = aim_intercept(id, target_inst, bullet_speed);
	shoot_direction();
	if point_distance(x, y, target_inst.x, target_inst.y) > weapon_range
		sm.swap(idleState);
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