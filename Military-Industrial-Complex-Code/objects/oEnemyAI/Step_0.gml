// Initial spawn position
var _x = x;
var _y = y;

// Increment the spawn counter every step
spawn_counter += 1;

if (spawn_counter >= steps_per_spawn) {
    // Reset the spawn counter
    spawn_counter = 0;
	
    // Randomize the spawn position
    _x += irandom_range(-150, 150);
    _y += irandom_range(-150, 150);
	
    // Ensure no collision at the spawn point
    while (collision_point(_x, _y, oCollision, false, true)) {
        _y -= 30; // Adjust y position to avoid collision
    }

    // Spawn the infantry squad at position (_x, _y)
    var _squad_inst = scr_create_squad(_x, _y, oInfantry, 4);
	
	var _length = ds_list_size(_squad_inst.squad);
	
    // Loop through the squad array and set the necessary parameters
    for (var i = 0; i < _length; i++) {
        var _inst = ds_list_find_value(_squad_inst.squad, i)
		
        with (_inst) {
            team_info = other.team_info; // Set the team info for the spawned unit
            b_sm.swap(b_objective);      // Swap to the appropriate behavior state
        }
    }
	print("")
}
