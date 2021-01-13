#region ID of Units

unitName	= "sInf_USA_basic";

amount	= 9;			// Amount of units per squad
range	= 50;			// How far apart each unit can be
unit	= "oSquadInf";	// What type of unit to control

cost	= 0;		// Cost of unit
resCost	= 0;		// Cost of unit in resources

maxResCarry	= 0;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 100;			// Range to transfer resources

#endregion

// Test
path = path_add();

childList = ds_list_create();

team		= 0;		// Which team its on
numColor	= 0;		// number relating to "red" or "blue" using an enum: color.red = 0
hashColor	= noone;	// "red" or "blue"

goalX = x;
goalY = y;