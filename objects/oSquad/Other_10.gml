switch(squad.object_index)
{
	case oInfantry:
		sprite_index = oOVLInf;
		break;
	case oHQ:
	case oZoneHQ:
		sprite_index = oOVLHQ;
		break;
	case oHAB:
	case oZoneBootCamp:
	case oZoneCamp:
	case oZoneMoney:
	case oZoneSupplies:
		sprite_index = oOVLHAB;
		break;
}