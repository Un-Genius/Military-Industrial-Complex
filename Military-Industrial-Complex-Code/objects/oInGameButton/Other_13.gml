/// @description Update Stats

if site_type < 0
	exit

switch(site_type)
{
	case oSiteProduceInfantry:
		text = "Infantry\nProduction";
		break
	case oSiteProducePurchasePower:
		text = "Purchase Power\nProduction"
		break
	case oSiteProduceEnergy:
		text = "Electricity\nGenerator"
		break
	case oSiteProduceOil:
		text = "Oil Production"
		break
	case oSiteProduceHeavySupplies:
		text = "Heavy\nProduction"
		break
	case oSiteProduceLightSupplies:
		text = "Light\nProduction"
		break
	case oSiteProduceAdvancedSupplies:
		text = "Advanced\nProduction";
		break
		
	case oSiteHQ:
		text = "HQ"
		break
		
	case oSiteCapacityOil:
		text = "Oil Capacity"
		break
	case oSiteCapacityLightSupplies:
		text = "Light\nCapacity"
		break
	case oSiteCapacityHeavySupplies:
		text = "Heavy\nCapacity"
		break
	case oSiteCapacityAdvancedSupplies:
		text = "Advanced\nCapacity"
		break
}

icon = object_to_sprite(site_type);

var _enum_value = obj_to_enum(site_type)
cost = oFaction.obj_info[_enum_value];