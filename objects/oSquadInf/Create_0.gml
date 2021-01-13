#region ID of Units

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

maxResCarry	= 0;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 100;			// Range to transfer resources

ammoUse		= 0.25;			// How much ammo will be consumed after reloading
maxClipSize	= 30;			// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion

team		= oManager.team;		// Which team its on
numColor	= oManager.numColor;	// number relating to "red" or "blue" using an enum: color.red = 0
hashColor	= oManager.hashColor;	// "red" or "blue"

// Pathfinding
path = path_add();

squadID = noone;

pushTimer = 0;

// Enter vehicle if present
enterVeh	= noone;
riding		= false;

state = action.idle;

moveState = action.idle;

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

// Image direction
dir = 0;

// Update budget
alarm[0] = 1;