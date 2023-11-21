// Inherit the parent event
event_inherited();

#region ID of Units

object_name	= "sInf_USA_basic";

movementSpeed	= 2;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 1;

maxHp	= 1;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= gunType.rifle;	// Type of gun
range	= 800;				// How far they can shoot in pixels
cover	= 30;				// Default cover

bulletFrequency = random_range(2, 4);	// Frequency of bullets per second
bulletTiming	= 0;					// Holds timing of last bullet

burstMax	= choose(1, 1, 3, 3, 3, 3, 6);					// Amount of bullets per burst
burstTiming = (random_range(1, 2)) * room_speed;	// Timing between bursts
burstTimer	= 0;									// Holds the time till last burst
burstAmount	= 0										// Current amount

ammoUse		= 0.25;			// How much ammo will be consumed after reloading
maxClipSize	= 30;			// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion