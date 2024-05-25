#region Modifiable		Variables

// Identification		Variables
object_name = "Infantry";

// Health				Variables
max_hp = 20;
hp = max_hp;

// Movement				Variables
default_speed = 1;
fast_speed = 1.4;

view_distance = 500;

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

enum UNIT_STATES {
	WALKING,
	SHOOTING
}

path = path_add();
path_set_kind(path, false);
path_set_precision(path, 8);
goal_x = x;
goal_y = y;

selected	= false;

target_inst = noone;

squadObjectID = noone;

team		= oFaction.team;		// Which team its on
numColor	= oFaction.numColor;	// number relating to "red" or "blue" using an enum: color.red = 0
hash_color	= oFaction.hash_color;	// "red" or "blue"

sprite_name = sprite_get_name(sprite_index);
sprite_name = string_copy(sprite_name, 0, string_length(sprite_name)-1); 

#endregion

#region State Machines Setup
m_sm = new StateMachine(); // Handles Movement
a_sm = new StateMachine(); // Handles Action
b_sm = new StateMachine(); // Handles Strategic Behaviour

#region Movement States
m_idle =	new State("m_idle") {
	m_idle.create = function() {
		image_index = 0;
		image_speed = 0;
	};
}
m_move =	new State("m_move") {
	m_move.create = function() {
		image_index = 0;
		image_speed = 1;
		speed = default_speed;
		alarm[0] = 1;
	};
	m_move.update = function() {

	    if (distance_to_point(goal_x, goal_y) < default_speed*1.5) {
		    m_sm.swap(m_idle); exit;
		}
		
		if path_finished()
			m_sm.swap(m_idle);
		
		var _x = path_get_point_x(path, 0);
		var _y = path_get_point_y(path, 0);
		
		image_angle = point_direction(x, y, _x, _y) - 90;
		
		// Vector a step
		//x += lengthdir_x(speed, _pathDir);
		//y += lengthdir_y(speed, _pathDir);
	};
	m_move.destroy = function() {

		speed = 0;
		/*
		while(path_get_number(path) > 0)
		{
			path_delete_point(path, 0);
		}
		goal_x = x;
		goal_y = y;
		*/
	};
};
m_haste =	new State("m_haste") {
	m_haste.create = function() {
		image_index = 0;
		image_speed = 1.5;
		speed = fast_speed;
		alarm[0] = 1;
	}
	m_haste.update = m_move.update;
	m_haste.destroy = m_move.destroy;
};
m_engage =	new State("m_engage") {
	m_engage.create = function() {
		if !instance_exists(target_inst) {
			m_sm.swap(m_idle); exit;
		}
		image_index = 0;
		image_speed = 1;
		speed = default_speed;
		alarm[0] = 1;
	};
	m_engage.update = function() {
		if !instance_exists(target_inst) {
			m_sm.swap(m_idle); exit;
		}
		
	    if (distance_to_point(goal_x, goal_y) < weapon_range-(default_speed*10)) {
			if(is_line_of_sight()) {
				m_sm.swap(m_idle); exit;
			}
		}
		
		if path_finished()
			m_sm.swap(m_idle);
	};
	m_engage.destroy = function() {
		speed = 0;
		alarm[0] = -1;
		while(path_get_number(path) > 0)
		{
			path_delete_point(path, 0);
		}
		goal_x = x;
		goal_y = y;
	};
};
m_follow =	new State("m_follow") {
	m_follow.create = m_engage.create;
	m_follow.update = function() {
		if !instance_exists(target_inst) {
			m_sm.swap(m_idle); exit;
		}
		
	    if (distance_to_point(goal_x, goal_y) < speed*5)
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
	a_idle.create = function() {
		sprite_index = asset_get_index(sprite_name + string(UNIT_STATES.WALKING));
	};
	a_idle.update = function() {
		if (enemy_in_range()) {
			if(random(1) < 0.2)
				randAudio("snd_smallArmsSpotted", 3, 0.15, 0.05, 0.8, 1.2, x, y);
		    a_sm.swap(a_shoot);
		}
	};
}
a_shoot =		new State("a_shoot") {
	a_shoot.create = function() {
		//target_inst = nearest_enemy();
		sprite_index = asset_get_index(sprite_name + string(UNIT_STATES.SHOOTING));
	}
	a_shoot.update = function() {
		image_speed = 1;
		
		target_inst = nearest_enemy();
		
		if target_inst == noone {
			a_sm.swap(a_idle); exit;
		}
		
		if(!is_line_of_sight()) {
			a_sm.swap(a_idle); exit;
		}
			
		if point_distance(x, y, target_inst.x, target_inst.y) > weapon_range {
			a_sm.swap(a_idle); exit;
		}
			
		weapon_angle = aim_intercept(id, target_inst, bullet_speed);
		shoot_direction();
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
b_idle =		new State("b_idle") {
	b_idle.update = function() {

		if is_idle(a_sm) && is_idle(m_sm)
			b_sm.swap(b_sm.prev_state);
	}
}
b_passive =		new State("b_passive") {
	b_passive.update = function() {

		if a_sm.state_name != "a_shoot" && enemy_in_range()
			a_sm.swap(a_shoot);
	
		if is_low_hp()
		{
			if is_idle(a_sm)
				a_sm.swap(a_heal);
			else if a_sm.state_name == "a_shoot"
				m_sm.swap(m_retreat);
		}
	}
}
b_aggressive =	new State("b_aggressive") {
	b_aggressive.update = function() {
		if a_sm.state_name != "a_shoot"
		{
			if enemy_in_range()
				a_sm.swap(a_shoot);
			
			if enemy_in_view()
			{
				if m_sm.state_name != "m_engage"
				{
					target_inst = nearest_enemy();
					m_sm.swap(m_engage);
				}
			}
		}
	
		if is_idle(a_sm) && is_low_hp()
			a_sm.swap(a_heal);
		
		switch(m_sm.state_name)
		{
			case "m_roam":
				if enemy_in_roam()
					m_sm.swap(m_engage);
				break;
			case "m_follow":
				m_sm.swap(m_protect);
				break;
		}
	}
}
b_defensive =	new State("b_defensive") {
	b_defensive.update = function() {
		if a_sm.state_name != "a_shoot" && enemy_in_range()
			a_sm.swap(a_shoot);
	
		if is_idle(a_sm) && is_low_hp()
			a_sm.swap(a_heal);
		
		switch(m_sm.state_name)
		{
			case "m_roam":
				if enemy_in_roam()
					m_sm.swap(m_engage);
				break;
			case "m_follow":
				m_sm.swap(m_protect);
				break;
		}
	}
}
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
while instance_place(x, y, oObject)
{
	x += irandom_range(-2, 2);
	y += irandom_range(-2, 2);
}
#endregion