// Inherit the parent event
event_inherited();

#region ID of Units

object_name	= "sOVLHQ";

amount	= 1;			// Amount of units per squad
range	= 0;			// How far apart each unit can be
unit	= "oHQ";	// What type of unit to control

hp = amount;

cost	= 0;		// Cost of unit
resCost	= 0;		// Cost of unit in resources

maxResCarry	= 10000;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 250;			// Range to transfer resources

#endregion