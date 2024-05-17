// oResourceDisplay Step Event
time_elapsed++;

if (time_elapsed >= update_interval) {
    time_elapsed = 0;

    var resource_names = variable_struct_get_names(global.resources);
    for (var i = 0; i < array_length(resource_names); i++) {
        var resource_name = resource_names[i];
        var current_value = struct_get(global.resources, resource_name);
        var last_value = ds_map_find_value(last_resources, resource_name);

        // Calculate trend
        if (current_value > last_value) {
            ds_map_set(average_trends, resource_name, 1); // Going up
        } else if (current_value < last_value) {
            ds_map_set(average_trends, resource_name, -1); // Going down
        } else {
            ds_map_set(average_trends, resource_name, 0); // No change
        }

        // Update last resources
        ds_map_set(last_resources, resource_name, current_value);
    }
}


if (instance_exists(oBuildingTool))
{
	if panel_cost == noone
	{
		panel_cost = instance_create(panel.width + 30, 25, objGUIPanel);
		panel_cost.depth = depth+2;
		panel_cost.width = 55;
		panel_cost.height = 200;
	}
	
	if panel_overhead == noone
	{
		panel_overhead = instance_create(panel.width + panel_cost.width + 25 + 10, 25, objGUIPanel);
		panel_overhead.depth = depth+2;
		panel_overhead.width = 55;
		panel_overhead.height = 200;
	}
}
else
{
	if instance_exists(panel_cost)
	{
		instance_destroy(panel_cost)
		panel_cost = noone
	}
	
	if instance_exists(panel_overhead)
	{
		instance_destroy(panel_overhead)
		panel_overhead = noone
	}
}