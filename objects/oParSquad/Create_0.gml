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
		
		
		var _objectString = "oSquadInf"
		
		var _packet = packet_start(packet_t.add_attached_unit);
		buffer_write(_packet, buffer_u64, oManager.user);
		buffer_write(_packet, buffer_string, _objectString);
		buffer_write(_packet, buffer_string, _objectString);
		buffer_write(_packet, buffer_f32, _goalX);
		buffer_write(_packet, buffer_f32, _goalY);
		packet_send_all(_packet);
	
		var _object = asset_get_index(_objectString);
		
		// Create instance
		var _inst = instance_create_layer(_goalX, _goalY, "Instances", _object);
		
		// Add inst to list
		ds_list_add(global.unitList, _inst);
	
		// Resize holding grid
		var _width	= ds_grid_width(global.instGrid);
		var _height = ds_grid_height(global.instGrid);
		ds_grid_resize(global.instGrid, _width + 1, _height);	
	
		// Add unit to list
		ds_list_add(childList, _inst);
	
		_inst.squadID = id;
		
		i++;
	}
}