// Update pathfinding
path_grid_update();

site_data = oFaction.obj_info[obj_to_enum(id.object_index)];
add_resource(global.resources_max, site_data.capacity);

resupplyTime = 5 * room_speed;

event_user(0);

#region ID of Units

object_name	= "noone";

movementSpeed	= 1;		// pixel per frame

unit	= OBJ_TYPE.inf; // Type of unit for health
armor	= 0;

maxHp	= 1;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= noone;	// Type of gun
range	= 0;				// How far they can shoot in pixels
cover	= 0;				// Default cover

bulletFrequency = 0;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

burstMax	= 0;				// Amount of bullets per burst
burstTiming = 0;	// Timing between bursts
burstTimer	= 0;				// Holds the time till last burst
burstAmount	= 0					// Current amount

maxResCarry	= 0;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 0;			// Range to transfer resources

ammoUse		= 0;			// How much ammo will be consumed after reloading
maxClipSize	= 0;			// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion

#region Squad Identification Variables

squadObjectID = noone;

#endregion

team		= 0//oManager.team;		// Which team its on
numColor	= color.white //oManager.numColor;	// number relating to "red" or "blue" using an enum: color.red = 0
hash_color	= "white" //oManager.hash_color;	// "red" or "blue"

// Parent ID
squadID = noone;

// Image direction
dir = 0;