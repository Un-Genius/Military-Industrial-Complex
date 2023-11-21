#region Modifiable		Variables

// Identification		Variables
object_name = "Infantry";

// Health				Variables
max_health = 4;
health = max_health;

// Movement				Variables
default_speed = 1;
fast_speed = 1.8;

// Create Event
weapon_accuracy = 0.95;
weapon_range = 300;
weapon_damage = 1;
weapon_angle = 0;

weapon_reload_duration = 2 * room_speed;
weapon_reload_progress = 0;
bullet_reload_time = 250;

weapon_magazine_capacity = 24;
weapon_burst_fire_rate = 6;
weapon_burst_cooldown = 80;

bullet_fire_rate_delay = 100;
bullet_size = 0.25;
bullet_speed = 7;

is_ready_to_shoot = true;
shots_fired_in_magazine = 0;
shots_fired_in_burst = 0;
last_shot_time = 0;
bullet_reload_timer = 0;


#endregion

#region Dont Touch		Variables

path = path_add();
pathGoalX = x;
pathGoalY = y;

selected	= false;

target_inst = noone;

squadObjectID = noone;

team		= oManager.team;		// Which team its on
numColor	= oManager.numColor;	// number relating to "red" or "blue" using an enum: color.red = 0
hash_color	= oManager.hash_color;	// "red" or "blue"

#endregion

#region State Machines Setup
m_sm = new StateMachine(); // Handles Movement
a_sm = new StateMachine(); // Handles Action
b_sm = new StateMachine(); // Handles Strategic Behaviour

#region Movement States
m_idle =	new State("m_idle") {}
m_move =	new State("m_move") {
	m_move.create = function() {
		path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
		path_goal_find(x, y, pathGoalX, pathGoalY, path);
		speed = default_speed;
	};
	m_move.update = function() {
		
	    if (distance_to_point(pathGoalX, pathGoalY) < default_speed*1.5) {
		    m_sm.swap(m_idle);
			exit;
		}
		
		if path_finished()
			m_sm.swap(m_idle);
		
		// Vector a step
		//x += lengthdir_x(speed, _pathDir);
		//y += lengthdir_y(speed, _pathDir);
	};
	m_move.destroy = function() {
		speed = 0;
	};
};
m_haste =	new State("m_haste") {
	m_haste.create = function() {
		path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
		path_goal_find(x, y, pathGoalX, pathGoalY, path);
		speed = fast_speed;
	}
	m_haste.update = m_move.update;
	m_haste.destroy = m_move.destroy;
};
m_engage =	new State("m_engage") {
	m_engage.create = function() {
		speed = fast_speed;
		
		pathGoalX = target_inst.x;
		pathGoalY = target_inst.y;
		
		// Update goal
		path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
		path_goal_find(x, y, pathGoalX, pathGoalY, path);
	};
	m_engage.update = function() {
		
		if !instance_exists(target_inst)
		{
			m_sm.swap(m_idle);
			exit;
		}
		
		if time % 30
		{
			pathGoalX = target_inst.x;
			pathGoalY = target_inst.y;
		
			path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
			path_goal_find(x, y, pathGoalX, pathGoalY, path);
		}
		
	    if (distance_to_point(pathGoalX, pathGoalY) < range-(speed*5))
			exit;
		
		if path_finished()
			m_sm.swap(m_idle);
	};
	m_engage.destroy = function() {
		speed = 0;
	};
};
m_follow =	new State("m_follow") {
	m_follow.create = m_engage.create;
	m_follow.update = function() {
		if !instance_exists(target_inst) {
			m_sm.swap(m_idle);
			exit;
		}
		
		if time % 30 {
			pathGoalX = target_inst.x;
			pathGoalY = target_inst.y;
		
			path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
			path_goal_find(x, y, pathGoalX, pathGoalY, path);
		}
		
	    if (distance_to_point(pathGoalX, pathGoalY) < speed*5)
			exit;
		
		if path_finished()
			m_sm.swap(m_idle);
	};
	m_follow.destroy = m_engage.destroy;
};
m_protect =	new State("m_protect") {}
m_roam =	new State("m_roam") {}
m_patrol =	new State("m_patrol") {}
m_capture = new State("m_capture") {}
m_retreat = new State("m_retreat") {}
m_scout =	new State("m_scout") {}
#endregion

#region Action States
a_idle =		new State("a_idle") {
	a_idle.update = function() {
		if (enemy_in_range()) {
			randAudio("snd_smallArmsSpotted", 3, 0.15, 0.05, 0.8, 1.2, x, y);
		    a_sm.swap(a_shoot);
		}
	};
}
a_shoot =		new State("a_shoot") {
	a_shoot.create = function() {
		//target_inst = nearest_enemy();
	}
	a_shoot.update = function() {
		target_inst = nearest_enemy();
		weapon_angle = aim_intercept(id, target_inst, bullet_speed);
		shoot_direction();
		if point_distance(x, y, target_inst.x, target_inst.y) > weapon_range
			a_sm.swap(a_idle);
	};
};
a_heal =		new State("a_heal") {};
a_sabotage =	new State("a_sabotage") {};
a_resupply =	new State("a_resupply") {};
a_assemble =	new State("a_assemble") {};
a_embark =		new State("a_embark") {};
a_disembark =	new State("a_disembark") {};
a_fortify =		new State("a_fortify") {};
a_communicate = new State("a_communicate") {};
a_skill =		new State("a_skill") {};
#endregion

#region Behavior States
b_passive =		new State("b_passive") {};
b_aggressive =	new State("b_aggressive") {};
b_defensive =	new State("b_defensive") {};
b_dead =		new State("b_dead") {};
#endregion

// Start with Idle state
m_sm.swap(m_idle);
a_sm.swap(a_idle);
b_sm.swap(b_passive);

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