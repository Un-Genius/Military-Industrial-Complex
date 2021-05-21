/// @description Overlay Parent

#region ID of Units

unitName	= "noone";

amount	= 0;			// Amount of units per squad
range	= 0;			// How far apart each unit can be
unit	= "noone";		// What type of unit to control
type	= unitType.inf;

hp = amount;

suppressMax		= 0;		// Max amount of bullets flying overhead to create supressed effect. 0 for no effect.
suppressAmount	= 0;		// Current amount of bullets flying overhead

// One minute history of suppressive fire
// every 4 seconds its updated
suppressHistory = array_create(10, 0);

cost	= 0;		// Cost of unit
resCost	= 0;		// Cost of unit in resources

maxResCarry	= 0 * amount;	// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 0;			// Range to transfer resources

#endregion

childList = ds_list_create();

team		= oManager.team;		// Which team its on
numColor	= oManager.numColor;	// number relating to "red" or "blue" using an enum: color.red = 0
hashColor	= oManager.hashColor;	// "red" or "blue"

selected	= false;		// Display highlight

// Enter vehicle if present
enterVeh	= noone;
riding		= false;

goalX = x;
goalY = y;

// Drag
release = false;

// Update budget & spawn units
alarm[0] = 1;
alarm[1] = 1;