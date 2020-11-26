// Stop animation
image_speed = 0;

#region ID of Units

unitName = "noone";

moveSpd	= 0;		// pixel per frame

range	= 0

gun		= noone;
bulletFrequency = 2;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

unit	= unitType.inf; // Type of unit for health
armor	= 0;

hp		= 0;	// How much health points they have

cover	= 0;				// Default cover

#endregion

team		= 0;
numColor	= 0;
hashColor	= noone;

// Pathfinding
path = path_add();

// Move slightly over if spawned on top of unit
while instance_place(x, y, oHQ) || instance_place(x, y, oHAB)
	y += 32;

// Goal
goalX = x;
goalY = y;

pathX = x;
pathY = y;

oldPathX = pathX;
oldPathY = pathY;

dir = 0;

state = action.idle;
moveState = action.idle;