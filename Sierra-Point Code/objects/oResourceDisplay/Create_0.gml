// oResourceDisplay Create Event

// Initialize the ds_maps for item names and the other variables
average_trends = ds_map_create();
last_resources = ds_map_create();
item_names = ds_map_create();
time_elapsed = 0;
update_interval = 60; // Adjust as needed for checking trends

// Populate the item names map
ds_map_add(item_names, "supplies", "Supplies");
ds_map_add(item_names, "food", "Food");
ds_map_add(item_names, "weapons", "Weapons");
ds_map_add(item_names, "people", "People");
ds_map_add(item_names, "cm", "Cement");
ds_map_add(item_names, "rt", "Research Tokens");

// Initialize last resources and trends
var resource_names = variable_struct_get_names(global.resources);
for (var i = 0; i < array_length(resource_names); i++) {
    var resource_name = resource_names[i];
    var _struct_value = struct_get(global.resources, resource_name);
    ds_map_set(last_resources, resource_name, _struct_value);
    ds_map_set(average_trends, resource_name, 0); // 0 means no change, 1 means increase, -1 means decrease
}


panel = instance_create(25, 25, objGUIPanel);
panel.depth = depth+2;
panel.width = 210;
panel.height = 200;

panel_cost = noone
panel_overhead = noone