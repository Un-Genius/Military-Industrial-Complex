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
	case oSiteHQ:
		sprite_index = sOVLHQ;
		break;
	case oHAB:
	case oSiteProducePeople:
	case oSiteCapacityPeople:
	case oSiteProduceSupplies:
	case oSiteCapacitySupplies:
	default:
		sprite_index = sOVLHAB;
}
if variable_instance_exists(_inst, "hash_color")
	image_blend = _inst.hash_color;