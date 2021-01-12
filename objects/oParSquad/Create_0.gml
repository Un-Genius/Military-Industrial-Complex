#region ID of Units

unitName	= "sInf_USA_basic";

amount	= 9;			// Amount of units per squad
range	= 50;			// How far apart each unit can be
unit	= "oSquadInf";	// What type of unit to control

hp = amount;

cost	= 0;		// Cost of unit
resCost	= 0;		// Cost of unit in resources

maxResCarry	= 0;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 100;			// Range to transfer resources

#endregion

childList = ds_list_create();

team		= oManager.team;		// Which team its on
numColor	= oManager.numColor;	// number relating to "red" or "blue" using an enum: color.red = 0
hashColor	= oManager.hashColor;	// "red" or "blue"

selected = false;		// Display highlight

riding		= false;	// Display unit whether in veh or not

goalX = x;
goalY = y;

// Drag
release = false;

// Update budget
alarm[0] = 1;

// Formation
var i = 0;
var _dist = 25;

for(var j = 0; j < hp; j++)
{	
	for(var k = 0; k < ceil(hp/3); k++)
	{		
		if(i = hp)
		{
			break;
		}
			
		var _goalX = goalX - (_dist * (k - (floor(hp/3)/4)));
		var _goalY = goalY - (_dist * (j - (floor(hp/6))));
		
		// Create unit		
		var _inst = spawn_unit("oSquadInf", _goalX, _goalY);
	
		// Add unit to list
		ds_list_add(childList, _inst);
	
		_inst.squadID = id;
		
		i++;
	}
}