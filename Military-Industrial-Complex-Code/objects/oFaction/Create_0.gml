#region
//numColor = ds_grid_get(global.savedSettings, 1, setting.color);
//hash_color = findColor(numColor);

noColor	= noone;
red		= $8989FF;
orange	= $7AB3FF;
yellow	= $9BEEFF;
green	= $A4FF99;
ltBlue	= $EFFF96;
blue	= $FFBB91;
purple	= $FF8C9B;
pink	= $F6A8FF;
colors	= [noColor, red, orange, yellow, green, ltBlue, blue, purple, pink];

var _team = 1;

team_info = {
	team: _team,
	color: colors[_team]
};

#endregion

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

enum OBJ_NAME
{
	UNIT_PLAYER,
	UNIT_INF,
	UNIT_ENEMY_INF,
	UNIT_WORKER,
	
	SITE_HQ,
	
	SITE_PRO_INFANTRY,
	SITE_PRO_PURCHASE_POWER,
	SITE_PRO_ENERGY,
	
	SITE_PRO_OIL,
	SITE_PRO_ADVANCED_SUPPLIES,
	SITE_PRO_HEAVY_SUPPLIES,
	SITE_PRO_LIGHT_SUPPLIES,
	
	SITE_CAP_OIL,
	SITE_CAP_LIGHT_SUPPLIES,
	SITE_CAP_HEAVY_SUPPLIES,
	SITE_CAP_ADVANCED_SUPPLIES
}

resource_struct = {
	oil : 0,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}

var _info_struct = {
	cost : variable_clone(resource_struct),
	capacity : variable_clone(resource_struct),
	resource_per_minute : variable_clone(resource_struct),
}

global.resources = variable_clone(_info_struct.cost);
global.resources_max = variable_clone(global.resources);

obj_info = array_create(20, 0)

for(var i = 0; i < 20; i++)
	obj_info[i] = variable_clone(_info_struct);

#region SITE_HQ
obj_info[OBJ_NAME.SITE_HQ].cost = {
	oil : 0,
	light_supplies : 100,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 50000,
	electricity : 50
}

obj_info[OBJ_NAME.SITE_HQ].capacity = {
	oil : 50,
	light_supplies : 100,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}

obj_info[OBJ_NAME.SITE_HQ].resource_per_minute = {
	oil : 0,
	light_supplies : 30,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 500,
	electricity : 0
}
#endregion

#region SITE_PRO_PURCHASE_POWER
obj_info[OBJ_NAME.SITE_PRO_PURCHASE_POWER].cost = {
	oil: 0,
	light_supplies: 0,
	heavy_supplies: 0,
	advanced_supplies: 0,
	purchase_power: 0,
	electricity: -10
}

// No Capacity

obj_info[OBJ_NAME.SITE_PRO_PURCHASE_POWER].resource_per_minute = {
	oil : 0,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 6000,
	electricity : 0
}
#endregion

#region SITE_PRO_ENERGY
obj_info[OBJ_NAME.SITE_PRO_ENERGY].cost = {
	oil : -5,
	light_supplies : -20,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : -1500,
	electricity : 75
}

// No Capacity

obj_info[OBJ_NAME.SITE_PRO_ENERGY].resource_per_minute = {
	oil : -30,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}
#endregion

#region SITE_PRO_OIL
obj_info[OBJ_NAME.SITE_PRO_OIL].cost = {
	oil : 0,
	light_supplies : -35,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : -2000,
	electricity : -15
}

obj_info[OBJ_NAME.SITE_PRO_OIL].capacity = {
	oil : 300,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}

obj_info[OBJ_NAME.SITE_PRO_OIL].resource_per_minute = {
	oil : 150,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}
#endregion

#region SITE_PRO_ADVANCED_SUPPLIES
obj_info[OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES].cost = {
	oil : 0,
	light_supplies : -75,
	heavy_supplies : -25,
	advanced_supplies : 0,
	purchase_power : -20000,
	electricity : -50
}

obj_info[OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES].capacity = {
	oil : 0,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 20,
	purchase_power : 0,
	electricity : 0
}

obj_info[OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES].resource_per_minute = {
	oil : -60,
	light_supplies : -10,
	heavy_supplies : -5,
	advanced_supplies : 12,
	purchase_power : -100,
	electricity : 0
}
#endregion

#region SITE_PRO_HEAVY_SUPPLIES
obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].cost = {
	oil : 0,
	light_supplies : -35,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : -3500,
	electricity : -30
}

obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].capacity = {
	oil : 0,
	light_supplies : 0,
	heavy_supplies : 100,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}

obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].resource_per_minute = {
	oil : -25,
	light_supplies : -60,
	heavy_supplies : 30,
	advanced_supplies : 0,
	purchase_power : -50,
	electricity : 0
}
#endregion

#region SITE_PRO_LIGHT_SUPPLIES
obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].cost = {
	oil : 0,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : -1000,
	electricity : -20
}

obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].capacity = {
	oil : 0,
	light_supplies : 300,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}

obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].resource_per_minute = {
	oil : 0,
	light_supplies : 30,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : -100,
	electricity : 0
}
#endregion

#region SITE_CAP_OIL
obj_info[OBJ_NAME.SITE_CAP_OIL].cost = {
	oil : 0,
	light_supplies : -50,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : -500,
	electricity : -5
}

obj_info[OBJ_NAME.SITE_CAP_OIL].capacity = {
	oil : 500,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}

#endregion

#region SITE_CAP_LIGHT_SUPPLIES
obj_info[OBJ_NAME.SITE_CAP_LIGHT_SUPPLIES].cost = {
	oil : 0,
	light_supplies : -25,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : -500,
	electricity : -5
}

obj_info[OBJ_NAME.SITE_CAP_LIGHT_SUPPLIES].capacity = {
	oil : 0,
	light_supplies : 350,
	heavy_supplies : 0,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}

#endregion

#region SITE_CAP_HEAVY_SUPPLIES
obj_info[OBJ_NAME.SITE_CAP_HEAVY_SUPPLIES].cost = {
	oil : 0,
	light_supplies : -30,
	heavy_supplies : -5,
	advanced_supplies : 0,
	purchase_power : -1500,
	electricity : -5
}

obj_info[OBJ_NAME.SITE_CAP_HEAVY_SUPPLIES].capacity = {
	oil : 0,
	light_supplies : 0,
	heavy_supplies : 150,
	advanced_supplies : 0,
	purchase_power : 0,
	electricity : 0
}
#endregion

#region SITE_CAP_ADVANCED_SUPPLIES
obj_info[OBJ_NAME.SITE_CAP_ADVANCED_SUPPLIES].cost = {
	oil : 0,
	light_supplies : -125,
	heavy_supplies : -50,
	advanced_supplies : 0,
	purchase_power : -2500,
	electricity : -15
}

obj_info[OBJ_NAME.SITE_CAP_ADVANCED_SUPPLIES].capacity = {
	oil : 0,
	light_supplies : 0,
	heavy_supplies : 0,
	advanced_supplies : 50,
	purchase_power : 0,
	electricity : 0
}
#endregion


/*
obj_info[OBJ_NAME.UNIT_INF].cost.light_supplies			= -15;

obj_info[OBJ_NAME.UNIT_WORKER].cost.light_supplies		= -5;

obj_info[OBJ_NAME.SITE_HQ].capacity.oil					= 100;
obj_info[OBJ_NAME.SITE_HQ].capacity.purchase_power		= 20;
obj_info[OBJ_NAME.SITE_HQ].capacity.light_supplies		= 20;
obj_info[OBJ_NAME.SITE_HQ].capacity.advanced_supplies	= 15;
obj_info[OBJ_NAME.SITE_HQ].resource_per_minute.oil		= 30;

obj_info[OBJ_NAME.SITE_PRO_OIL].cost.oil				= -50;
obj_info[OBJ_NAME.SITE_PRO_OIL].resource_per_minute.oil = 30;
obj_info[OBJ_NAME.SITE_PRO_OIL].capacity.oil			= 50;

obj_info[OBJ_NAME.SITE_PRO_PURCHASE_POWER].cost.oil				= -75;
obj_info[OBJ_NAME.SITE_PRO_PURCHASE_POWER].resource_per_minute.purchase_power		= 20;
obj_info[OBJ_NAME.SITE_PRO_PURCHASE_POWER].capacity.purchase_power					= 20;

obj_info[OBJ_NAME.SITE_CAP_ADVANCED_SUPPLIES].cost.oil				= -15;
obj_info[OBJ_NAME.SITE_CAP_ADVANCED_SUPPLIES].cost.purchase_power						= -10;
obj_info[OBJ_NAME.SITE_CAP_ADVANCED_SUPPLIES].capacity.advanced_supplies				= 20;

obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].cost.oil				= -35;
obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].cost.purchase_power					= -15;
obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].resource_per_minute.light_supplies		= 15;
obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].resource_per_minute.oil	= -6;
obj_info[OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES].capacity.light_supplies				= 75;

obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].cost.oil			= -40;
obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].cost.purchase_power					= -20;
obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].resource_per_minute.heavy_supplies = 6;
obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].resource_per_minute.oil = -6;
obj_info[OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES].capacity.heavy_supplies		= 30;

obj_info[OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES].cost.oil				= -50;
obj_info[OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES].cost.purchase_power						= -15;
obj_info[OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES].resource_per_minute.advanced_supplies	= 1;
obj_info[OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES].capacity.advanced_supplies				= 6;
*/


// Arrays for object mappings
enum_to_obj_map = [
    oPlayer,
    oInfantry,
    oInfantryAI,
    oWorker,
    oSiteHQ,
    oSiteProduceOil,
    oSiteProduceInfantry,
    oSiteProduceInfantry,
    oSiteProduceHeavySupplies,
    oSiteProduceLightSupplies,
    oSiteProducePurchasePower,
    oSiteProduceEnergy,
	oSiteCapacityOil,
	oSiteCapacityLightSupplies,
	oSiteCapacityHeavySupplies,
	oSiteCapacityAdvancedSupplies
];


obj_to_enum_map = ds_map_create();
ds_map_add(obj_to_enum_map, oPlayer, OBJ_NAME.UNIT_PLAYER);
ds_map_add(obj_to_enum_map, oInfantry, OBJ_NAME.UNIT_INF);
ds_map_add(obj_to_enum_map, oInfantryAI, OBJ_NAME.UNIT_ENEMY_INF);
ds_map_add(obj_to_enum_map, oWorker, OBJ_NAME.UNIT_WORKER);
ds_map_add(obj_to_enum_map, oSiteHQ, OBJ_NAME.SITE_HQ);
ds_map_add(obj_to_enum_map, oSiteProduceOil, OBJ_NAME.SITE_PRO_OIL);
ds_map_add(obj_to_enum_map, oSiteProduceInfantry, OBJ_NAME.SITE_PRO_INFANTRY);
ds_map_add(obj_to_enum_map, oSiteProducePurchasePower, OBJ_NAME.SITE_PRO_PURCHASE_POWER);
ds_map_add(obj_to_enum_map, oSiteProduceEnergy, OBJ_NAME.SITE_PRO_ENERGY);
ds_map_add(obj_to_enum_map, oSiteProduceAdvancedSupplies, OBJ_NAME.SITE_PRO_ADVANCED_SUPPLIES);
ds_map_add(obj_to_enum_map, oSiteProduceHeavySupplies, OBJ_NAME.SITE_PRO_HEAVY_SUPPLIES);
ds_map_add(obj_to_enum_map, oSiteProduceLightSupplies, OBJ_NAME.SITE_PRO_LIGHT_SUPPLIES);
ds_map_add(obj_to_enum_map, oSiteCapacityOil, OBJ_NAME.SITE_CAP_OIL);
ds_map_add(obj_to_enum_map, oSiteCapacityLightSupplies, OBJ_NAME.SITE_CAP_LIGHT_SUPPLIES);
ds_map_add(obj_to_enum_map, oSiteCapacityHeavySupplies, OBJ_NAME.SITE_CAP_HEAVY_SUPPLIES);
ds_map_add(obj_to_enum_map, oSiteCapacityAdvancedSupplies, OBJ_NAME.SITE_CAP_ADVANCED_SUPPLIES);

local_to_net_map = ds_map_create();
ds_map_add(local_to_net_map, oPlayer, oPlayerClient);
ds_map_add(local_to_net_map, oParSiteLocal, oParZoneNet);
ds_map_add(local_to_net_map, oSiteHQ, oZoneNetHQ);
ds_map_add(local_to_net_map, oSiteProduceAdvancedSupplies, oZoneNetBootCamp);
ds_map_add(local_to_net_map, oSiteProduceOil, oZoneNetMoney);
ds_map_add(local_to_net_map, oSiteCapacityLightSupplies, oZoneNetSupplies);
//ds_map_add(local_to_net_map, oInfantry, oInfantryClient);

enum_to_sprite_map = [
    //sPlayer,
    sZoneInfantry,
    sInf_USA_basic_0_0,
    sInf_USA_basic_0_0,
	sHQ,
	sFactory,
	sHousing,
	sFactory,
	sFactory,
	sFactory,
	sFactory,
	sFactory,
	sWarehouse,
	sWarehouse,
	sWarehouse,
	sWarehouse,
	sWarehouse
];

obj_to_sprite_map = ds_map_create();
//ds_map_add(obj_to_sprite_map, oPlayer, sPlayer);
ds_map_add(obj_to_sprite_map, oInfantry, sZoneInfantry);
ds_map_add(obj_to_sprite_map, oInfantryAI, sInf_USA_basic_0_0);
ds_map_add(obj_to_sprite_map, oWorker, sInf_USA_basic_0_0);
ds_map_add(obj_to_sprite_map, oSiteHQ, sHQ);
ds_map_add(obj_to_sprite_map, oSiteProduceOil, sFactory);
ds_map_add(obj_to_sprite_map, oSiteProduceInfantry, sHAB);
ds_map_add(obj_to_sprite_map, oSiteProduceAdvancedSupplies, sFactory);
ds_map_add(obj_to_sprite_map, oSiteProduceHeavySupplies, sFactory);
ds_map_add(obj_to_sprite_map, oSiteProduceLightSupplies, sFactory);
ds_map_add(obj_to_sprite_map, oSiteProducePurchasePower, sFactory);
ds_map_add(obj_to_sprite_map, oSiteProduceEnergy, sFactory);
ds_map_add(obj_to_sprite_map, oSiteCapacityOil, sWarehouse);
ds_map_add(obj_to_sprite_map, oSiteCapacityLightSupplies, sWarehouse);
ds_map_add(obj_to_sprite_map, oSiteCapacityHeavySupplies, sWarehouse);
ds_map_add(obj_to_sprite_map, oSiteCapacityAdvancedSupplies, sWarehouse);