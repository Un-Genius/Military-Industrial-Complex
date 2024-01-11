/// @description Info for Unit

// Inherit the parent event
event_inherited();

#region ID of Units

cost		= 0;		// Cost of unit

object_name	= "sHAB";

unit	= unitType.building; // Type of unit for health
armor	= 2;

cover	= 40;				// Default cover

#endregion

path_grid_update();