/// @description Waypoint Type

switch(marker_type) {
	case "recon_marker":
		sprite_index = sWaypointRecon;
		break;
		
	case "patrol_marker":
		sprite_index = sWaypointPatrol;
		break;
		
	case "attack_marker":
		sprite_index = sWaypointAttack;
		break;
		
	case "defend_marker":
		sprite_index = sWaypointDefend;
		break;
			
	case "retreat_marker":
		sprite_index = sWaypointRetreat;
		break;
}