// Inherit the parent event
event_inherited();

#region ID of Units

objectName	= "sVeh_USA_basic";

amount	= 1;			// Amount of units per squad
range	= 0;			// How far apart each unit can be
unit	= "oTransport";	// What type of unit to control

hp = amount;

cost	= unitResCost.trans;	// Cost of unit
resCost	= 0;					// Cost of unit in resources

maxResCarry	= 100 * amount;		// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 100;			// Range to transfer resources

#endregion