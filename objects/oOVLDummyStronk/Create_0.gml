// Inherit the parent event
event_inherited();

#region ID of Units

unitName	= "sInf_USA_basic";

amount	= 4;			// Amount of units per squad
range	= 50;			// How far apart each unit can be
unit	= "oDummyStronk";	// What type of unit to control

hp = amount;

suppressMax		= 5;		// Max amount of bullets flying overhead to create supressed effect. 0 for no effect.

cost	= 0;		// Cost of unit
resCost	= 0;		// Cost of unit in resources

maxResCarry	= 20 * amount;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 100;			// Range to transfer resources

#endregion