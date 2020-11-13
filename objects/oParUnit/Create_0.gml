#region ID of Units

cost	= 0;		// Cost of unit

unitName = "noone";

moveSpd	= 0;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 0;

maxHp	= 1;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= noone;	// Type of gun
range	= 0;				// How far they can shoot in pixels
cover	= 0;				// Default cover

bulletFrequency = 0;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

maxAmmo		= 0;			// Maximum amount of ammo(bullets) they can shoot
currentAmmo = maxAmmo;		//Current amount of ammo held
ammoUse		= 0;			// How much ammo will be consumed after reloading
maxClipSize	= 0;			// Max bullets shot before reloading
clipSize	= maxClipSize;

resources	= 0;

#endregion

team		= oManager.team;
numColor	= oManager.numColor;		// number relating to "red" or "blue" using an enum: color.red = 0
hashColor	= oManager.hashColor;	// "red" or "blue"

// Pathfinding
path = path_add();

// Drag
release = false;

// Modify selected units
selected = false;

state = action.idle;

moveState = action.idle;

// Move slightly over if spawned on top of unit
while instance_place(x, y, oParUnit)
	y += 48;
	
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