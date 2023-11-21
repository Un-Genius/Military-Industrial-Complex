/// @description Info for Unit

// Inherit the parent event
event_inherited();

#region ID of Units

cost		= 0;		// Cost of unit

object_name	= "sHQ";

unit	= unitType.building; // Type of unit for health
armor	= 2;

maxHp	= 20;		// How much health points they can have
hp		= maxHp;	// How much health points they have

cover	= 40;				// Default cover

#endregion

path_grid_update();