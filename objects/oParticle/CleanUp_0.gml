/// @description Cleanup

#region Destroy individual particles and emitters

part_type_destroy(global.bulletTrail);

// part_emitter_destroy(global.P_System, global.Emitter1);

#endregion

// Destroy Particle system
part_system_destroy(global.P_System);