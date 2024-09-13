// Inherit the parent event
event_inherited();

var _amount = oFaction.resource_struct;

_amount.heavy_supplies += 100;

add_resource(global.resources_max, _amount)