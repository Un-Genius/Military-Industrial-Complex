/// @description Update Stats

if site_type < 0
	exit

switch(site_type)
{
	case oSiteProduceCM:
		text = "Construction\nMaterial Pro"
		icon = sZoneMoney
		break
	case oSiteProduceFood:
		text = "Food Pro"
		icon = sZoneMoney
		break
	case oSiteProduceInfantry:
		text = "People Pro";
		icon = sZoneBootCamp
		break
	case oSiteProduceRT:
		text = "Research\nTokens Pro"
		icon = sZoneMoney
		break
	case oSiteProduceSupplies:
		text = "Supplies Pro"
		icon = sZoneMoney
		break
	case oSiteProduceWeapons:
		text = "Weapons Pro"
		icon = sZoneMoney
		break
	case oSiteHQ:
		text = "HQ"
		icon = sZoneHQ
		break
	case oSiteCapacityInfantry:
		text = "People Cap"
		icon = sZoneCamp
		break
	case oSiteCapacitySupplies:
		text = "Supplies Cap"
		icon = sZoneSupplies
		break
}

var _enum_value = obj_to_enum(site_type)
cost = oFaction.obj_info[_enum_value];