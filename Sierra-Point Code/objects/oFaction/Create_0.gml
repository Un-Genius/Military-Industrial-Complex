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

enum gunType
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

enum unitType
{
	building,
	inf,
	gnd,
	air
}

enum unitResCost
{
	inf = 20,
	trans = 80,
	HAB = 100,
}

enum objectType
{
	oPlayer,
	oZoneHQ,
	oZoneCamp,
	oZoneBootCamp,
	oInfantry,
	oZoneMoney,
	oZoneSupplies,
	oDummy,
	oDummyStronk,
	oTransport,
	oHAB,
	oInfantryAI
}

// Money
global.supplies = 0;
global.maxSupplies = global.supplies;

// Unit costs
unitCost = array_create(5);
unitCost[objectType.oZoneHQ] = 0;
unitCost[objectType.oInfantry] = 30;
unitCost[objectType.oZoneCamp] = 20;
unitCost[objectType.oZoneMoney] = 50;
unitCost[objectType.oZoneSupplies] = 30;
unitCost[objectType.oZoneBootCamp] = 80;