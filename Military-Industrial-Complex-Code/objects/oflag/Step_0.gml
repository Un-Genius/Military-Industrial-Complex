// Constants for time intervals
var _three_seconds = 3 * room_speed;

// Create a list of units in capture range
var units_in_capture_range = ds_list_create();
var _amount_in_range = collision_circle_list(x, y, capture_range, oInfantry, false, true, units_in_capture_range, false);

// Variables to track teams in range
var teams_in_range = ds_list_create();
var teams_present = ds_map_create();

// For each unit in range, get their team
for (var i = 0; i < _amount_in_range; i++) {
    var _current_unit = ds_list_find_value(units_in_capture_range, i);
    var team = _current_unit.team_info;

    if (!ds_map_exists(teams_present, team.team)) {
        ds_map_add(teams_present, team.team, true);
        ds_list_add(teams_in_range, team);
    }
}

var num_teams_in_range = ds_list_size(teams_in_range);

if (num_teams_in_range == 0) {
    // No units in range
    if (capture_progress < capture_time && capture_progress > 0) {
        // Move capture_progress towards zero
        capture_progress--;
    }
    // If capture_progress reaches zero, flag remains neutral or stays captured

} else if (num_teams_in_range == 1) {
    var inst_in_range = ds_list_find_value(teams_in_range, 0);

    if (inst_in_range.team == flag_info_temp.team) {
        // Units from owning team are in range
        if (capture_progress < capture_time) {
            capture_progress++;
        }
        if (capture_progress >= capture_time) {
			flag_info = capturing_team;
            capture_progress = capture_time;

            if (point_cooldown >= _three_seconds) {
                point_cooldown = 0;
                // Increase points for the owning team
            }
            point_cooldown++;
        }
    } else {
        // Units from a different team are in range
        if (capture_progress > 0) {
            capture_progress--;
            point_cooldown = 0; // Reset point cooldown
            capturing_team = inst_in_range;
			flag_info_temp = flag_info_default;
        } else if (capture_progress == 0) {
            // Flag is neutral
            capturing_team = inst_in_range;
			flag_info_temp = inst_in_range;
			flag_info = flag_info_default;
            capture_progress++;
        } else if (capturing_team.team == inst_in_range.team && capture_progress < capture_time) {
            // Continue capturing
            capture_progress++;
        }
        if (capture_progress >= capture_time) {
            // Flag is captured by capturing_team
            flag_info = capturing_team;
            capture_progress = capture_time;
            point_cooldown = 0; // Reset point cooldown
			Light_Color = flag_info_temp.color;
			
        }
    }

} else {
    // Multiple teams in range (contested)
    if (capture_progress > 0) {
        capture_progress--;
    }
    point_cooldown = 0; // Reset point cooldown
    if (capture_progress == 0) {
        flag_info = flag_info_default;
        capturing_team = noone;
    }
}

// Clean up
ds_list_destroy(units_in_capture_range);
ds_list_destroy(teams_in_range);
ds_map_destroy(teams_present);
