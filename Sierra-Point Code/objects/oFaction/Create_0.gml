team = 0;

numColor = ds_grid_get(global.savedSettings, 1, setting.color);

// "Red", "Orange", "Yellow", "Green", "Light Blue", "Blue", "Purple", "Pink"

noColor	= noone;
red		= $8989FF;
orange	= $7AB3FF;
yellow	= $9BEEFF;
green	= $A4FF99;
ltBlue	= $EFFF96;
blue	= $FFBB91;
purple	= $FF8C9B;
pink	= $F6A8FF;

hash_color = findColor(numColor);

enum GUN_TYPE
{
	lightCan,
	mediumCan,
	heavyCan,
	rifle,
	lightMG,
	mediumMG,
	heavyMG,
	ATGM
}

enum OBJ_TYPE
{
	building,
	inf,
	gnd,
	air
}

// Outdated
enum unitResCost
{
	inf = 20,
	trans = 80,
	HAB = 100,
}

enum OBJ_NAME
{
	UNIT_PLAYER,
	UNIT_INF,
	UNIT_ENEMY_INF,
	UNIT_WORKER,
	
	SITE_HQ,
	
	SITE_PRO_SUPPLIES,
	SITE_PRO_WORKERS,
	SITE_PRO_INF,
	SITE_PRO_WEAPONS,
	SITE_PRO_FOOD,
	SITE_PRO_CM,
	SITE_PRO_RT,
	
	SITE_CAP_SUPPLIES,
	SITE_CAP_INF,
	SITE_CAP_WORKERS
}

resource_struct = {
	supplies : 0,
	food : 0,
	weapons : 0,
	people : 0,
	cm : 0,
	rt : 0
}

var _info_struct = {
	cost : variable_clone(resource_struct),
	resource_per_minute : variable_clone(resource_struct)
}

global.resources = variable_clone(_info_struct.cost);
global.resources_max = variable_clone(global.resources);

obj_info = array_create(20, 0)

for(var i = 0; i < 20; i++)
	obj_info[i] = variable_clone(_info_struct);

obj_info[OBJ_NAME.UNIT_INF].cost.food			= 5;
obj_info[OBJ_NAME.UNIT_INF].cost.supplies		= 3;
obj_info[OBJ_NAME.UNIT_INF].cost.weapons		= 3;
obj_info[OBJ_NAME.UNIT_INF].resource_per_minute.food		= -1;
obj_info[OBJ_NAME.UNIT_INF].resource_per_minute.supplies	= -1;

obj_info[OBJ_NAME.UNIT_WORKER].cost.supplies		= 3;

obj_info[OBJ_NAME.SITE_HQ].resource_per_minute.supplies			= 30;

obj_info[OBJ_NAME.SITE_CAP_SUPPLIES].cost.supplies	= 15;

obj_info[OBJ_NAME.SITE_PRO_SUPPLIES].cost.supplies	= 50;
obj_info[OBJ_NAME.SITE_PRO_SUPPLIES].resource_per_minute.supplies = 30;

obj_info[OBJ_NAME.SITE_PRO_CM].cost.supplies		= 75;
obj_info[OBJ_NAME.SITE_PRO_CM].resource_per_minute.cm			= 20;

obj_info[OBJ_NAME.SITE_CAP_INF].cost.supplies	= 15;
obj_info[OBJ_NAME.SITE_CAP_INF].cost.cm			= 10;

obj_info[OBJ_NAME.SITE_PRO_FOOD].cost.supplies		= 35;
obj_info[OBJ_NAME.SITE_PRO_FOOD].cost.cm			= 15;
obj_info[OBJ_NAME.SITE_PRO_FOOD].resource_per_minute.food		= 15;
obj_info[OBJ_NAME.SITE_PRO_FOOD].resource_per_minute.supplies	= -6;

obj_info[OBJ_NAME.SITE_PRO_WEAPONS].cost.supplies	= 40;
obj_info[OBJ_NAME.SITE_PRO_WEAPONS].cost.cm			= 20;
obj_info[OBJ_NAME.SITE_PRO_WEAPONS].resource_per_minute.weapons = 6;
obj_info[OBJ_NAME.SITE_PRO_WEAPONS].resource_per_minute.supplies = -6;

obj_info[OBJ_NAME.SITE_PRO_INF].cost.supplies	= 50;
obj_info[OBJ_NAME.SITE_PRO_INF].cost.cm			= 15;

