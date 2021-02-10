// Inherit the parent event
event_inherited();

#region ID of Units

cost	= 10;

moveSpd	= 0.8;		// pixel per frame

unit	= unitType.gnd; // Type of unit for health
armor	= 1;

maxHp	= 2;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= gunType.heavyCan;	// Type of gun
range	= 800;				// How far they can shoot in pixels

bulletFrequency = 10;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

reloadSpd	= 12;	// How fast they reload
maxClipSize	= 3;	// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion