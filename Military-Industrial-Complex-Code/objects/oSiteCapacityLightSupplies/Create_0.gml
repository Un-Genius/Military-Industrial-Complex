#region Inherit Shadows
// Inherit the parent event
event_inherited();

// Create a sprite polygon for this instance
polygon = polygon_from_instance(id);

// This is a static shadow caster (it never changes its polygon)
flags |= eShadowCasterFlags.Static;

ignored = false;
#endregion
var _amount = oFaction.resource_struct;

_amount.light_supplies += 100;

add_resource(global.resources_max, _amount)