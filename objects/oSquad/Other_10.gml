var _inst = ds_list_find_value(squad, 0);

if !instance_exists(_inst)
	exit;

switch(_inst.object_index)
{
	case oInfantry:
	case oInfantryAI:
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
	default:
		sprite_index = sOVLHAB;
}
if variable_instance_exists(_inst, "hash_color")
	image_blend = _inst.hash_color;