#region ID of Units

objectName	= "noone";

amount		= 0;			// Amount of units per squad
range		= 0;			// How far apart each unit can be
unit		= "noone";	// What type of unit to control

hp = amount;

#endregion

// Test
path = path_add();

childList = ds_list_create();

team		= 0;		// Which team its on
numColor	= 0;		// number relating to "red" or "blue" using an enum: color.red = 0
hash_color	= noone;	// "red" or "blue"

pathGoalX = x;
pathGoalY = y;