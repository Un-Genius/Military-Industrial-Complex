// Constants for time intervals
var _ten_seconds = 10 * room_speed;
var _three_seconds = 3 * room_speed;

if (capture_progress >= _ten_seconds) {
    if (point_cooldown >= _three_seconds) {
        point_cooldown = 0;
        // Increase points or perform an action here.
    }
    point_cooldown++;
}

// Capture mechanism
var units_in_capture_range = ds_list_create();
var _amount_in_range = collision_circle_list(x, y, capture_range, oInfantry, false, true, units_in_capture_range, false);

if (_amount_in_range > 0) {
    var _first_unit = ds_list_find_value(units_in_capture_range, 0);
    var same_team = true;
    for (var i = 1; i < _amount_in_range; i++) {
        var _current_unit = ds_list_find_value(units_in_capture_range, i);
        if (_current_unit.team != _first_unit.team) {
            same_team = false;
            break;
        }
    }

    if (same_team) {
        flag_color = findColor(_first_unit.hash_color);
        flag_team = _first_unit.team;
        if (capture_progress < _ten_seconds) {
            capture_progress++;
        }
    } else {
        if (capture_progress > 0) {
            capture_progress--;
            point_cooldown = 0;
            flag_color = c_white;
            flag_team = 0;
        }
    }
} else {
    if (capture_progress > 0) {
        capture_progress--;
        point_cooldown = 0;
        flag_color = c_white;
        flag_team = 0;
    }
}

ds_list_destroy(units_in_capture_range);