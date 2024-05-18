// Initialize ds_maps for resources, costs, and production/overhead
current_resources = ds_map_create();
construction_costs = ds_map_create();
production_overhead = ds_map_create();
visible_resources = ds_list_create();
visible_costs = ds_list_create();
visible_production_overhead = ds_list_create();

// Populate initial resources
ds_map_add(current_resources, "supplies", 100);
ds_map_add(current_resources, "food", 0);
ds_map_add(current_resources, "weapons", 0);
ds_map_add(current_resources, "people", 0);
ds_map_add(current_resources, "cm", 0);
ds_map_add(current_resources, "rt", 0);

// Populate item names for display
item_names = ds_map_create();
ds_map_add(item_names, "supplies", "Supplies");
ds_map_add(item_names, "food", "Food");
ds_map_add(item_names, "weapons", "Weapons");
ds_map_add(item_names, "people", "People");
ds_map_add(item_names, "cm", "Cement");
ds_map_add(item_names, "rt", "Research Tokens");

// Initialize the values for the Food Production building
ds_map_add(construction_costs, "supplies", 35);
ds_map_add(construction_costs, "cm", 15);
ds_map_add(production_overhead, "supplies", -6);
ds_map_add(production_overhead, "food", 15);

create_gui_panels();