// Stop animation
image_speed = 0;

#region ID of Units

cost	= 0;		// Cost of unit

unitName = "noone";

moveSpd	= 0;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 0;

hp		= 0;	// How much health points they have

cover	= 0;				// Default cover

resources = 0;

#endregion

team		= 0;
numColor	= 0;
hashColor	= noone;

// Pathfinding
path = path_add();

// Move slightly over if spawned on top of unit
while instance_place(x, y, oHQClient) || instance_place(x, y, oHABClient)
	y += 32;

// Goal
goalX = x;
goalY = y;

pathX = x;
pathY = y;

dir = 0;

state = action.idle;

moveState = action.idle;
