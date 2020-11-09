// Stop animation
image_speed = 0;

#region ID of Units

moveSpd	= 2;		// pixel per frame

unitName = "sInf_USA_basic";

unit	= unitType.inf; // Type of unit for health
armor	= 1;

hp		= 0;

gun		= gunType.rifle;	// Type of gun
range	= 300;				// How far they can shoot in pixels
cover	= 4;

bulletFrequency = 2;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

reloadSpd	= 4;	// How fast they reload
maxClipSize	= 30;	// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion

team		= 0;
numColor	= 0;
hashColor	= noone;

// Pathfinding
path = path_add();

// Goal
goalX = x;
goalY = y;

pathX = x;
pathY = y;

dir = 0;

state = action.idle;

moveState = action.idle;