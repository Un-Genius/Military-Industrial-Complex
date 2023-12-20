// StateMachine constructor
function StateMachine() constructor {
    static nullState = new State();

    state = nullState;
	prev_state = nullState;
	state_name = "null";
    time = 0;

    // Swap to a new state
    swap = function(_state = nullState) {
        state.destroy();
		
		if state != _state
		{
			prev_state = state;
			state = _state;
			state_name = _state.state_name;
		}
		
        time = 0;

        state.create();
    }

    // Run current state
    run = function() {
        state.update();
        time++;
    }
}

// State constructor
function State(name="null") constructor {
    state_name = name;
	
	static NOOP = function() { };

    create = NOOP;
    update = NOOP;
    destroy = NOOP;
}

function enemy_in_range() {
	var _list = enemy_list(weapon_range, team);
	var _enemy_in_range = ds_list_size(_list) > 0
	
	ds_list_destroy(_list);
	
	if !_enemy_in_range
		return false
		
	return true
}
	
function enemy_in_view() {
	var _list = enemy_list(view_distance, team);
	var _enemy_in_range = ds_list_size(_list) > 0
	
	ds_list_destroy(_list);
	
	if !_enemy_in_range
		return false
		
	return true
}
	
function enemy_in_roam() {}

function is_low_health() {
	if health > (max_health/4)
		return false;
	
	return true;
}
	
function is_idle() {
	var _idleness = true;
	
	for(var i = 0; i < argument_count; i++)
	{
		var _state_name = argument[i].state_name;
		var _count = string_count("idle", _state_name);
		if _count == 0
			_idleness = false;
	}		
	
	return _idleness;
}

function nearest_enemy() {
	var _list = enemy_list(view_distance, team);
	var _enemy_in_range = ds_list_size(_list) > 0
	
	if !_enemy_in_range
	{
		ds_list_destroy(_list);
		return noone;
	}
		
	var _inst = ds_list_find_value(_list, 0);
	
	ds_list_destroy(_list);
		
	return _inst;
}

function enemy_list(_distance, _team) {
    var _object = oInfantry;
		
	var _list = ds_list_create();

    var enemies_in_range = collision_circle_list(x, y, _distance, _object, false, true, _list, true);
	
	// Filter list
	for(var i = 0; i < enemies_in_range; i++)
	{
		var _inst = ds_list_find_value(_list, i)
		if _inst.team == _team
		{
			ds_list_delete(_list, i);
			enemies_in_range--;
			i--;
		}
	}

    return _list;
}
	
function shoot_bulletOLD() {
	/*
	if(target_inst != noone) {
		
		var _acc = weapon_accuracy;
		var _dir = weapon_angle + random_range(-_acc, _acc);
		var _x = x + lengthdir_x(16, _dir);
		var _y = y + lengthdir_y(16, _dir);
		var _speed = weapon_speed;
		var _dmg = weapon_damage;
		var _team = team;
		
	    var _bullet = instance_create_layer(_x, _y, "Instances", oBullet_old);
		with _bullet
		{
		    direction = _dir;
			image_angle = _dir;
		    speed = _speed;
		    damage = _dmg;
			team = _team;
		}
	}
		*/
}

function shoot_direction()
{
    if (!is_ready_to_shoot) {
        handle_reload();
        return;
    }

    if (shots_fired_in_magazine >= weapon_magazine_capacity) {
        return;
    }

    if (!is_time_to_shoot()) {
        return;
    }

    fire_bullet();
    update_shooting_status();
    handle_burst_completion();
    handle_magazine_completion();
}

function is_time_to_shoot() {
    return current_time - last_shot_time >= bullet_fire_rate_delay;
}

function fire_bullet() {
    var bullet_direction = weapon_angle + random_range(-weapon_accuracy, weapon_accuracy);
    create_bullet(x, y, bullet_direction, weapon_damage, bullet_speed, bullet_size, id);
}

function update_shooting_status() {
    shots_fired_in_magazine += 1;
    shots_fired_in_burst += 1;
    last_shot_time = current_time;
}

function handle_burst_completion() {
    if (shots_fired_in_burst >= weapon_burst_fire_rate) {
        shots_fired_in_burst = 0;
        is_ready_to_shoot = false;
        bullet_reload_timer = weapon_burst_cooldown;
    }
}

function handle_magazine_completion() {
    if (shots_fired_in_magazine >= weapon_magazine_capacity) {
        shots_fired_in_magazine = 0;
        shots_fired_in_burst = 0;
        is_ready_to_shoot = false;
        bullet_reload_timer = bullet_reload_time;
        randAudio("snd_smallArmsReload_start", 0, 1, 0.4, 0.8, 1.2, x, y);
    }
}

function handle_reload() {
    if (bullet_reload_timer > 0) {
        bullet_reload_timer--;
        return;
    }

    is_ready_to_shoot = true;
    randAudio("snd_smallArmsReload_finish", 0, 1, 0.4, 0.8, 1.2, x, y);
}

function shootOLD()
{	
	/*
	// Check if tank can shoot
	if(can_shoot && (magazine_count <= bullet_magazine_size))
	{
		// Check if enough time has passed since last shot
		if (current_time - last_shot_time >= bullet_fire_rate_delay)
		{
			// Calculate bullet direction based on turret direction
			var _speed = bullet_speed;
			var _size = bullet_size;
			var _accuracy = weapon_accuracy;
			var _dir = weapon_angle + random_range(-_accuracy, _accuracy);
			var _damage = weapon_damage;
			var _shooter_id = id;
			var _x = x;// + lengthdir_x(16, _dir);
			var _y = y;// + lengthdir_y(16, _dir);

			create_bullet(_x, _y, _dir, _damage, _speed, _size, _shooter_id);
        
			// Update shooting variables
			magazine_count += 1;
			burst_count += 1;
			last_shot_time = current_time;
		
			// Create camera shake
			//shakeMag = 10;
		
			// Create sound
			var _volume = 0.1;

			//if _dist < 2000
				//_volume = clamp((1500 - _dist) / 1400, 0, 0.7);
		
			// Check if burst is complete
			if (burst_count >= bullet_burst_rate) {
			    burst_count = 0;
			    can_shoot = false;
			    bullet_reload_timer = bullet_burst_delay;
			}
		
			// Check if magazine is complete
			if (magazine_count >= bullet_magazine_size) {
			    magazine_count = 0;
				burst_count = 0;
			    can_shoot = false;
			    bullet_reload_timer = bullet_reload_time;
				randAudio("snd_smallArmsReload_start", 0, 1, 0.4, 0.8, 1.2, x, y);
			}
		}
	}

	// Reload if necessary
	if (!can_shoot)
	{
		if(bullet_reload_timer >= 0)
			bullet_reload_timer--;
		else
		{
			can_shoot = true;
			randAudio("snd_smallArmsReload_finish", 0, 1, 0.4, 0.8, 1.2, x, y);
		}
	}
	*/
}

function create_bullet(_x, _y, _direction, _damage, _speed, _size, _shooter_id)
{
	// Create bullet object and set its stats
	var _bullet = instance_create_layer(_x, _y, "Bullets", oBullet);
		
	with(_bullet)
	{
		direction = _direction;
		image_angle = _direction;
		speed = _speed;
		image_xscale = _size;
		image_yscale = _size;
		damage = _damage;
		shooter_id = _shooter_id
	}
}

/// intercept_course(_origin,_target,_speed)
//
//  Returns the course direction required to hit a moving _target
//  at a given projectile _speed, or (-1) if no solution is found.
//
//      _origin      instance with position (x,y), real
//      _target      instance with position (x,y) and (_speed), real
//      _speed       _speed of the projectile, real
//
/// GMLscripts.com/license
function aim_intercept(_origin,_target,pspeed)
{
    var dir,alpha,phi,beta;
    dir = point_direction(_origin.x,_origin.y,_target.x,_target.y);
    alpha = _target.speed / pspeed;
    phi = degtorad(_target.direction - dir);
    beta = alpha * sin(phi);
    if (abs(beta) >= 1) {
        return (-1);
    }
    dir += radtodeg(arcsin(beta));
    return dir;
}