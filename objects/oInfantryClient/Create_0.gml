/// @description Info for Unit

// Inherit the parent event
event_inherited();

#region ID of Units

cost		= 0;		// Cost of unit

unitName	= "sInf_USA_basic";

moveSpd	= 2;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 1;

gun		= gunType.rifle;	// Type of gun
range	= 400;				// How far they can shoot in pixels
cover	= 10;				// Default cover

bulletFrequency = 2;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

#endregion