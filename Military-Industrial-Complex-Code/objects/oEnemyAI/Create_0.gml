object_type = oInfantryAI;

team_info = {
    team: team,
    color: oFaction.colors[team]
};

spawn_rate = 4; // Spawns per minute
spawn_counter = 0;

// Convert spawn_rate to steps between spawns
steps_per_spawn = (60 * 60) / spawn_rate; // 60 steps per second * 60 seconds per minute