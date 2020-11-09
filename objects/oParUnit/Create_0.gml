#region ID of Units

cost	= 1;		// Cost of unit

unitName = "sInf_USA_basic";

moveSpd	= 2;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 1;

maxHp	= 1;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= gunType.rifle;	// Type of gun
range	= 300;				// How far they can shoot in pixels
cover	= 4;

bulletFrequency = 2;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

maxAmmo = 3;			// Maximum amount of ammo(bullets) they can shoot
currentAmmo = maxAmmo;	//Current amount of ammo held
ammoUse = 1;		// How much ammo will be consumed after reloading
reloadSpd	= 4;	// How fast they reload
maxClipSize	= 30;	// Max bullets shot before reloading
clipSize	= maxClipSize;

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

// Image direction
dir = 0;

// Update budget
alarm[0] = 1;