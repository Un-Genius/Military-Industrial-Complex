/// @description Push other units

with(other) {
    var _force = 0.2;
    var _dir = point_direction(x, y, other.x, other.y);
    var _amount_x = lengthdir_x(_force, _dir);
    var _amount_y = lengthdir_y(_force, _dir);

    // Calculate new position
    var new_x = x - _amount_x;
    var new_y = y - _amount_y;

    // Check for collision at the new position before moving
    if (!place_meeting(new_x, y, oCollision)) {
        x = new_x;
    }

    if (!place_meeting(x, new_y, oCollision)) {
        y = new_y;
    }
}
