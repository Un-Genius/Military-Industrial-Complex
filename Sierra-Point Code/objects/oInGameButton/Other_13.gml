/// @description Update Cost
var _zone = 0;

unitCost[objectType.oZoneHQ] = 0;

if string_count("Camp", text)
	_zone = objectType.oZoneCamp

if string_count("Supplies", text)
	_zone = objectType.oZoneSupplies

if string_count("Money", text)
	_zone = objectType.oZoneMoney

if string_count("Boot", text)
	_zone = objectType.oZoneBootCamp

object_type = _zone
cost = oFaction.unitCost[_zone];