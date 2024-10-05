ds_list_add(oPlayer.squadObjectList, id);

squad = ds_list_create();

selected = false;

// Identification		Variables
object_name = "Squad";

var _amount = instance_number(oSquad)-1
var _names = [
	"Alpha", "Beta", "Charlie", "Delta",
	"Echo", "Foxtrot", "Golf", "Hotel",
	"India", "Juliette", "Kilo", "Lima",
	"Mike", "November", "Oscar", "Papa",
	"Quebec", "Romeo", "Sierra", "Tango",
	"Uniform", "Victor", "Whiskey", "X-ray",
	"Yankee", "Zulu", "Omega"
];

identifier = _names[_amount]

// Health				Variables
max_hp = 1;
hp = max_hp;

// Movement				Variables
default_speed = 1;
fast_speed = 1.8;

moving_x = x;
moving_y = y;
moving_target = [];
shooting_targets = ds_list_create();

alarm[0] = 5;

// Objective behavior for Squad object
#region Behavior
// State Machines for Squad
o_sm = new StateMachine(); // Handles Objectives

// Variable to hold the current target objective
target_objective = noone;

#region Objective States

o_idle = new State("o_idle") {
    o_idle.create = function() {
        // Set squad to idle state, waiting for new objectives
    };
    o_idle.update = function() {
        // If new objective is assigned, swap to the appropriate state
        if (new_objective_available()) {
            target_objective = get_next_objective();
            o_sm.swap(o_move_to);
        }
    };
};

o_move_to = new State("o_move_to") {
    o_move_to.create = function() {
        // Assign the target position or area to move to
        target_position = target_objective.position;
        assign_infantry_to_move(target_position);
    };
    o_move_to.update = function() {
        // Check if all infantry in squad have reached the target
        if (all_infantry_at_position(target_position)) {
            o_sm.swap(o_capture);
        }
    };
};

o_capture = new State("o_capture") {
    o_capture.create = function() {
        // Begin capturing the objective
        target_objective.capture_progress = 0;
        target_objective.capturing_team = squad_leader.team;
    };
    o_capture.update = function() {
        // Check if capture is complete
        if (capture_complete()) {
            o_sm.swap(o_idle);
        }
    };
};

o_defend = new State("o_defend") {
    o_defend.create = function() {
        // Assign infantry to defensive positions
        assign_defensive_positions();
    };
    o_defend.update = function() {
        // If enemies detected, engage them
        if (enemy_in_range()) {
            engage_enemies();
        }

        // If objective is secure, return to idle
        if (objective_secure()) {
            o_sm.swap(o_idle);
        }
    };
};

#endregion

// Start with Idle state
o_sm.swap(o_idle);

// Utility functions
function new_objective_available() {
    // Get the nearest objective that is not owned by our team
    var objective = get_next_objective();
    return objective != noone;
}

function get_next_objective() {
    // Get the nearest oFlag that is not owned by our team
    var nearest_flag = noone;
    var nearest_distance = 999999;
    var all_flags = instance_find(oFlag, 0);

    for (var i = 0; i < instance_number(oFlag); i++) {
        var flag = all_flags[i];
        if (flag.flag_info.team != squad_leader.team) {
            var dist = point_distance(squad_leader.x, squad_leader.y, flag.x, flag.y);
            if (dist < nearest_distance) {
                nearest_flag = flag;
                nearest_distance = dist;
            }
        }
    }

    return nearest_flag;
}

function assign_infantry_to_move(position) {
    // Assign each infantry in the squad to move to the given position
    for (var i = 0; i < ds_list_size(squad); i++) {
        var infantry = squad[| i];
        infantry.goal_x = position.x;
        infantry.goal_y = position.y;
        infantry.m_sm.swap(infantry.m_move);
    }
}

function all_infantry_at_position(position) {
    // Check if all infantry have reached the target position
    for (var i = 0; i < ds_list_size(squad); i++) {
        var infantry = squad[| i];
        if (point_distance(infantry.x, infantry.y, position.x, position.y) > 10) {
            return false;
        }
    }
    return true;
}

function capture_complete() {
    if (point_distance(squad_leader.x, squad_leader.y, target_objective.x, target_objective.y) <= target_objective.capture_range) {
        target_objective.capture_progress += 1;
        if (target_objective.capture_progress >= target_objective.capture_time) {
            target_objective.capturing_team = squad_leader.team;
            target_objective.flag_info_temp = {team: squad_leader.team, color: squad_leader.team_color};
            return true;
        }
    }
    return false;
}

function assign_defensive_positions() {
    // Assign infantry to defensive positions around the objective
    for (var i = 0; i < ds_list_size(squad); i++) {
        var infantry = squad[| i];
        if (!enemy_in_range()) {
            // Position infantry in a circle around the objective
            var angle = i * (360 / ds_list_size(squad));
            infantry.goal_x = target_objective.x + lengthdir_x(target_objective.capture_range, angle);
            infantry.goal_y = target_objective.y + lengthdir_y(target_objective.capture_range, angle);
        } else {
            // Align infantry in the direction of the enemy
            var enemy_direction = point_direction(infantry.x, infantry.y, target_objective.x, target_objective.y);
            infantry.goal_x = target_objective.x + lengthdir_x(target_objective.capture_range / 2, enemy_direction);
            infantry.goal_y = target_objective.y + lengthdir_y(target_objective.capture_range / 2, enemy_direction);
        }
        infantry.m_sm.swap(infantry.m_move);
    }
}

function engage_enemies() {
    // Command the infantry to engage enemies
    var _list = enemy_list(target_objective.capture_range, squad_leader.team);
    for (var i = 0; i < ds_list_size(squad); i++) {
        var infantry = squad[| i];
        if (ds_list_size(_list) > 0) {
            infantry.target_inst = ds_list_find_value(_list, 0);
        }
        infantry.b_sm.swap(infantry.b_aggressive);
        infantry.m_sm.swap(infantry.m_engage);
    }
    ds_list_destroy(_list);
}

function objective_secure() {
    return target_objective.capturing_team == squad_leader.team;
}

function assign_behavior(behavior) {
    // Assign the given behavior state to all infantry in the squad
    for (var i = 0; i < ds_list_size(squad); i++) {
        var infantry = squad[| i];
        infantry.b_sm.swap(behavior);
    }
}

#endregion