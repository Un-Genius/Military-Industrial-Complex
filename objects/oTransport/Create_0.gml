/// @description Info for Unit

// Inherit the parent event
event_inherited();

#region ID of Units

cost		= 0;					// Cost of unit
resCost		= unitResCost.trans;	// Cost of unit in resources

unitName	= "sVeh_USA_basic";

moveSpd		= 4;		// pixel per frame

unit		= unitType.gnd; // Type of unit for health
armor		= 1;

maxHp		= 4;		// How much health points they can have
hp			= maxHp;	// How much health points they have

maxResCarry	= 100;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried

#endregion

image_xscale = 0.6;
image_yscale = 0.6;