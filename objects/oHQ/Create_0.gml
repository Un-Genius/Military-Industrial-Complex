/// @description Info for Unit

// Inherit the parent event
event_inherited();

#region ID of Units

objectName	= "sInf_USA_basic";

movementSpeed	= 0;		// pixel per frame

unit	= unitType.building; // Type of unit for health
armor	= 2;

maxHp	= 20;		// How much health points they can have
hp		= maxHp;	// How much health points they have

maxResCarry	= 10000;	// Resources carried

#endregion

depth = -bbox_bottom - 5;

path_grid_update();