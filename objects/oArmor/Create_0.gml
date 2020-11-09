// Inherit the parent event
event_inherited();

#region ID of Units

cost	= 15;

moveSpd	= 1.5;		// pixel per frame

unit	= unitType.gnd; // Type of unit for health
armor	= 3;

maxHp	= 5;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= gunType.mediumCan;	// Type of gun
range	= 500;				// How far they can shoot in pixels

bulletFrequency = 1;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

reloadSpd	= 8;	// How fast they reload
maxClipSize	= 1;	// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion

// Find name of sprite to get turret
var _tankID = sprite_get_name(sprite_index);

var _name = string_delete(_tankID, 1, 11);

turret = asset_get_index("sTank_Turret_" + _name)

turDir = 0;