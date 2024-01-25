/// @description Update Cost
var _zone = 0;

obj_info[OBJ_NAME.SITE_HQ] = 0;

if string_count("Camp", text)
	_zone = OBJ_NAME.SITE_PRO_SUPPLIES

if string_count("Supplies", text)
	_zone = OBJ_NAME.SITE_CAP_SUPPLIES

if string_count("Money", text)
	_zone = OBJ_NAME.SITE_PRO_WEAPONS

if string_count("Boot", text)
	_zone = OBJ_NAME.SITE_PRO_INF

site_type = _zone
cost = oFaction.obj_info[_zone];