ds_list_add(oPlayer.squadObjectList, id);

squad = ds_list_create();

selected = false;

// Identification		Variables
object_name = "Squad";

var _amount = instance_number(oSquad)-1
var _names = [
	"Alpha", "Beta", "Charlie", "Delta",
	"Echo", "Foxtrot", "Golf", "Hotel",
	"India", "Juliette", "Kilo", "Lima",
	"Mike", "November", "Oscar", "Papa",
	"Quebec", "Romeo", "Sierra", "Tango",
	"Uniform", "Victor", "Whiskey", "X-ray",
	"Yankee", "Zulu", "Omega"
];

identifier = _names[_amount]

// Health				Variables
max_hp = 1;
hp = max_hp;

// Movement				Variables
default_speed = 1;
fast_speed = 1.8;

moving_x = x;
moving_y = y;
moving_target = [];
shooting_targets = ds_list_create();

alarm[0] = 5;