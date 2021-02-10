// Inherit the parent event
event_inherited();

#region ID of Units

unitName	= "sInf_USA_basic";

moveSpd	= 2;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 1;

gun		= gunType.rifle;	// Type of gun
range	= 400;				// How far they can shoot in pixels
cover	= 10;				// Default cover

bulletFrequency = 2;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

maxResCarry	= 0;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 100;			// Range to transfer resources

ammoUse		= 0.25;			// How much ammo will be consumed after reloading
maxClipSize	= 30;			// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion