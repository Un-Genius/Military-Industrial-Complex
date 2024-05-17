/// @function gatherResourceData()
/// @description Gather data for resources and their trends in a specific order.
/// @returns {array} An array of resource data structs

function gatherResourceData() {
    var ordered_resource_names = ["supplies", "food", "weapons", "cement", "people", "research_tokens"];
    var resource_data = [];

    for (var i = 0; i < array_length(ordered_resource_names); i++) {
        var resource_name = ordered_resource_names[i];
        var resource_value = struct_get(global.resources, resource_name);
        var trend = ds_map_find_value(average_trends, resource_name);
        
        // Include items with more than 0 value
        if (resource_value > 0) {
            array_push(resource_data, {name: resource_name, value: resource_value, trend: trend});
        }
    }
    return resource_data;
}



/// @function gatherCostData()
/// @description Gather data for costs, overhead, and produce of the current item and include resources the player lacks.
/// @returns {struct} A struct containing arrays of cost, overhead, and produce data

function gatherCostData() {
    var cost_data = [];
    var overhead_data = [];
    var produce_data = [];

    if (instance_exists(oBuildingTool)) {
        var buildingType = oBuildingTool.buildingType;
        var _enum_value = obj_to_enum(buildingType);
        var buildingCost = oFaction.obj_info[_enum_value].cost;
        var buildingOverhead = oFaction.obj_info[_enum_value].overhead;
        var buildingProduce = oFaction.obj_info[_enum_value].produce;
        var cost_names = variable_struct_get_names(buildingCost);
        var overhead_names = variable_struct_get_names(buildingOverhead);
        var produce_names = variable_struct_get_names(buildingProduce);

        // Gather cost data
        for (var j = 0; j < array_length(cost_names); j++) {
            var cost_name = cost_names[j];
            var cost_value = struct_get(buildingCost, cost_name);
            var player_resource_value = struct_get(global.resources, cost_name);

            // Include items with more than 0 value or if the player lacks enough resources
            if (cost_value > 0 || player_resource_value < cost_value) {
                array_push(cost_data, {name: cost_name, cost: cost_value, player_value: player_resource_value});
            }
        }

        // Gather overhead data
        for (var j = 0; j < array_length(overhead_names); j++) {
            var overhead_name = overhead_names[j];
            var overhead_value = struct_get(buildingOverhead, overhead_name);
            if (overhead_value > 0) {
                array_push(overhead_data, {name: overhead_name, value: overhead_value});
            }
        }

        // Gather produce data
        for (var j = 0; j < array_length(produce_names); j++) {
            var produce_name = produce_names[j];
            var produce_value = struct_get(buildingProduce, produce_name);
            if (produce_value > 0) {
                array_push(produce_data, {name: produce_name, value: produce_value});
            }
        }
    }

    return {cost: cost_data, overhead: overhead_data, produce: produce_data};
}




/// @function renderResourcesAndCosts(y_offset, resource_data, cost_data, overhead_data, produce_data)
/// @description Render resources, costs, overhead, and produce in a unified manner.
/// @param {real} y_offset - The initial vertical offset for drawing
/// @param {array} resource_data - An array of resource data structs
/// @param {array} cost_data - An array of cost data structs
/// @param {array} overhead_data - An array of overhead data structs
/// @param {array} produce_data - An array of produce data structs

function renderResourcesAndCosts(y_offset, resource_data, cost_data, overhead_data, produce_data) {
    var items_displayed = 0;
    var x_offset_resources = 40; // Moved right
    var x_offset_values = 150;   // Adjusted for more space
    var x_offset_trends = 200;   // Adjusted for more space
    var x_offset_costs = 250;    // Adjusted for more space
    var x_offset_overhead_produce = 300; // Adjusted for more space

    // Create maps for cost, overhead, and produce data for quick lookup
    var cost_map = ds_map_create();
    for (var i = 0; i < array_length(cost_data); i++) {
        var cost = cost_data[i];
        ds_map_set(cost_map, cost.name, cost);
    }
    
    var overhead_map = ds_map_create();
    for (var i = 0; i < array_length(overhead_data); i++) {
        var overhead = overhead_data[i];
        ds_map_set(overhead_map, overhead.name, overhead);
    }

    var produce_map = ds_map_create();
    for (var i = 0; i < array_length(produce_data); i++) {
        var produce = produce_data[i];
        ds_map_set(produce_map, produce.name, produce);
    }

    // Draw resources and highlight deficits
    for (var i = 0; i < array_length(resource_data); i++) {
        var resource = resource_data[i];
        var display_name = getDisplayName(resource.name);
        var trend_symbol = "";

        if (resource.trend == 1) {
            trend_symbol = "↑"; // Up arrow
        } else if (resource.trend == -1) {
            trend_symbol = "↓"; // Down arrow
        } else {
            trend_symbol = "-"; // No change
        }

        // Draw resource name and value
        draw_text(x_offset_resources, y_offset, display_name + ": ");
        draw_text(x_offset_values, y_offset, string(resource.value));
        draw_text(x_offset_trends, y_offset, trend_symbol);

        // Check if this resource is needed for the current item
        if (ds_map_exists(cost_map, resource.name)) {
            var cost_info = ds_map_find_value(cost_map, resource.name);
            var cost_value = cost_info.cost;
            var player_resource_value = cost_info.player_value;
            if (player_resource_value < cost_value) {
                drawColoredText(x_offset_costs, y_offset, "-" + string(cost_value), c_red);
                drawColoredText(x_offset_resources + 100, y_offset, "(" + string(player_resource_value - cost_value) + ")", c_red); // Display the missing amount
            } else {
                drawColoredText(x_offset_costs, y_offset, "-" + string(cost_value), c_orange);
            }
        }

        // Move to next line
        y_offset += 30;
        items_displayed++;
    }

    // Ensure overhead and produce are displayed even if the resource wasn't displayed above
    var all_resources = variable_struct_get_names(global.resources);
    for (var i = 0; i < array_length(all_resources); i++) {
        var resource_name = all_resources[i];

        var display_name = getDisplayName(resource_name);

        var overhead_value = 0;
        var produce_value = 0;

        if (ds_map_exists(overhead_map, resource_name)) {
            var overhead_info = ds_map_find_value(overhead_map, resource_name);
            overhead_value = overhead_info.value;
        }

        if (ds_map_exists(produce_map, resource_name)) {
            var produce_info = ds_map_find_value(produce_map, resource_name);
            produce_value = produce_info.value;
        }

        // Only display if there's an overhead or produce value
        if (overhead_value > 0 || produce_value > 0) {
            // Draw resource name for overhead and produce
            draw_text(x_offset_resources, y_offset, display_name + ": ");

            // Display overhead in orange
            if (overhead_value > 0) {
                drawColoredText(x_offset_costs, y_offset, "-" + string(overhead_value), c_orange);
            }

            // Display produce in green
            if (produce_value > 0) {
                drawColoredText(x_offset_costs, y_offset, "+" + string(produce_value), c_green);
            }

            y_offset += 30; // Increase space between items
            items_displayed++;
        }
    }

    // Draw resources with zero values if they are in the cost data
    for (var i = 0; i < array_length(cost_data); i++) {
        var cost = cost_data[i];
        if (cost.player_value == 0) {
            var display_name = getDisplayName(cost.name);

            // Draw resource name and value in orange
            drawColoredText(x_offset_resources, y_offset, display_name + ": ", c_orange);
            drawColoredText(x_offset_values, y_offset, string(cost.player_value), c_orange);
            drawColoredText(x_offset_costs, y_offset, "-" + string(cost.cost), c_red);

            y_offset += 30; // Increase space between items
            items_displayed++;
        }
    }

    ds_map_destroy(cost_map); // Clean up the map
    ds_map_destroy(overhead_map); // Clean up the map
    ds_map_destroy(produce_map); // Clean up the map

    return items_displayed;   // Return the number of items displayed
}



/// @function getDisplayName(resource_name)
/// @description Retrieve the display name for a given resource.
/// @param {string} resource_name - The resource name to get the display name for
/// @returns {string} The display name

function getDisplayName(resource_name) {
    return ds_map_find_value(item_names, resource_name);
}

/// @function drawColoredText(x, y, text, color)
/// @description Draw text at a specified location with a specified color.
/// @param {real} x - The x coordinate for drawing
/// @param {real} y - The y coordinate for drawing
/// @param {string} text - The text to draw
/// @param {real} color - The color to use for drawing

function drawColoredText(x, y, text, color) {
    draw_set_color(color);
    draw_text(x, y, text);
    draw_set_color(c_white); // Reset color to white
}

/// @function renderOverheadAndProduce(y_offset, overhead_data, produce_data)
/// @description Render overhead and produce in a unified manner.
/// @param {real} y_offset - The initial vertical offset for drawing
/// @param {array} overhead_data - An array of overhead data structs
/// @param {array} produce_data - An array of produce data structs

function renderOverheadAndProduce(y_offset, overhead_data, produce_data) {
    var items_displayed = 0;
    var x_offset_resources = 40; // Moved right
    var x_offset_values = 150;   // Adjusted for more space

    // Draw overhead
    draw_text(x_offset_resources, y_offset, "Overhead:");
    y_offset += 30;
    for (var i = 0; i < array_length(overhead_data); i++) {
        var overhead = overhead_data[i];
        var display_name = getDisplayName(overhead.name);

        // Draw overhead name and value
        draw_text(x_offset_resources, y_offset, display_name + ": ");
        draw_text(x_offset_values, y_offset, string(overhead.value));

        y_offset += 30; // Increase space between items
        items_displayed++;
    }

    // Draw produce
    draw_text(x_offset_resources, y_offset, "Produce:");
    y_offset += 30;
    for (var i = 0; i < array_length(produce_data); i++) {
        var produce = produce_data[i];
        var display_name = getDisplayName(produce.name);

        // Draw produce name and value
        draw_text(x_offset_resources, y_offset, display_name + ": ");
        draw_text(x_offset_values, y_offset, string(produce.value));

        y_offset += 30; // Increase space between items
        items_displayed++;
    }

    return items_displayed;   // Return the number of items displayed
}
