/// @description Info for Unit

// Inherit the parent event
event_inherited();

#region ID of Units

cost		= 0;		// Cost of unit

unitName	= "sInf_USA_basic";

moveSpd	= 2;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 1;

maxHp	= 1;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= gunType.rifle;	// Type of gun
range	= 400;				// How far they can shoot in pixels
cover	= 10;				// Default cover

bulletFrequency = 2;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

maxAmmo		= 18;			// Maximum amount of ammo(bullets) they can shoot
currentAmmo = maxAmmo;		//Current amount of ammo held
ammoUse		= 0.25;			// How much ammo will be consumed after reloading
maxClipSize	= 30;			// Max bullets shot before reloading
clipSize	= maxClipSize;

resources	= 5;

#endregion