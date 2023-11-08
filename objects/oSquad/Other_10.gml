var _inst = ds_list_find_value(squad, 0)

switch(_inst.object_index)
{
	case oInfantry:
		sprite_index = sOVLInf;
		break;
	case oHQ:
	case oZoneHQ:
		sprite_index = sOVLHQ;
		break;
	case oHAB:
	case oZoneBootCamp:
	case oZoneCamp:
	case oZoneMoney:
	case oZoneSupplies:
		sprite_index = sOVLHAB;
		break;
}