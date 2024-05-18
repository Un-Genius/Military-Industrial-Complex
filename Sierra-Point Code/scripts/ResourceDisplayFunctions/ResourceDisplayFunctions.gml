/*

// Function to draw resource information
function draw_resource_info() {
    // Set the font
    draw_set_font(ftDefault);

    // Example drawing on the main panel
    draw_text(30, 30, "Resources");

    var y_offset = 50;
    var x_offset = 30;
    var resources = ["supplies", "food", "weapons", "people", "cm", "rt"];
    
    // Draw each resource
    for (var i = 0; i < array_length(resources); i++) {
        var resource = resources[i];
        var value = global.resources[? resource];
        
        if (value != 0) {
            draw_text(x_offset, y_offset, string(resource) + ": " + string(value));
            y_offset += 20;
        }
    }
}

// Function to draw cost and production information
function draw_cost_and_production() {
    // Example drawing on the cost panel
    if (panel_cost != noone) {
        with (panel_cost) {
            draw_self();
            var y_offset = 10;
            draw_text(5, y_offset, "Cost");
            y_offset += 20;

            var items = ds_map_find_value(oFaction.obj_info, "SITE_PRO_FOOD"); 
            var costs = items[? "cost"];

            var resources = ds_map_find_all_keys(costs);
            for (var i = 0; i < array_length(resources); i++) {
                var resource = resources[i];
                var cost = costs[? resource];
                draw_text(5, y_offset, string(resource) + ": " + string(cost));
                y_offset += 20;
            }
        }
    }

    // Example drawing on the overhead panel
    if (panel_overhead != noone) {
        with (panel_overhead) {
            draw_self();
            var y_offset = 10;
            draw_text(5, y_offset, "Production/Overhead");
            y_offset += 20;

            var items = ds_map_find_value(global.obj_info, "SITE_PRO_FOOD");
            var production = items[? "resource_per_minute"];

            var resources = ds_map_find_all_keys(production);
            for (var i = 0; i < array_length(resources); i++) {
                var resource = resources[i];
                var rate = production[? resource];
                draw_text(5, y_offset, string(resource) + ": " + string(rate));
                y_offset += 20;
            }
        }
    }
}


function sort_and_filter_resources(map) {
    var keys = ds_map_find_all_keys(map);
    ds_list_sort(keys, true);
    return keys;
}


// ----------------------------



/// @function update_visibility_lists()
/// @description Update visibility lists for resources, costs, and production/overhead.
function update_visibility_lists() {
    ds_list_clear(visible_resources);
    ds_list_clear(visible_costs);
    ds_list_clear(visible_production_overhead);

    // Update visible resources
    var resource_names = ds_map_keys_to_array(current_resources);
    for (var i = 0; i < array_length(resource_names); i++) {
        var resource_name = resource_names[i];
        var resource_value = ds_map_find_value(current_resources, resource_name);

        if (resource_value > 0) {
            ds_list_add(visible_resources, resource_name);
        }
    }

    // Update visible costs
    var cost_names = ds_map_keys_to_array(construction_costs);
    for (var i = 0; i < array_length(cost_names); i++) {
        var cost_name = cost_names[i];
        var cost_value = ds_map_find_value(construction_costs, cost_name);

        if (cost_value > 0) {
            ds_list_add(visible_costs, cost_name);
        }
    }

    // Update visible production and overhead
    var prod_overhead_names = ds_map_keys_to_array(production_overhead);
    for (var i = 0; i < array_length(prod_overhead_names); i++) {
        var name = prod_overhead_names[i];
        var value = ds_map_find_value(production_overhead, name);

        if (value != 0) {
            ds_list_add(visible_production_overhead, name);
        }
    }
}

/// @function render_resources_panel(y_offset)
/// @description Render the current resources panel.
function render_resources_panel(y_offset) {
    var x_offset = 40; // Starting position for the resources panel
    for (var i = 0; i < ds_list_size(visible_resources); i++) {
        var resource_name = ds_list_find_value(visible_resources, i);
        var resource_value = ds_map_find_value(current_resources, resource_name);
        var display_name = ds_map_find_value(item_names, resource_name);

        // Draw resource name and value
        draw_text(x_offset, y_offset, display_name + ": ");
        draw_text(x_offset + 100, y_offset, string(resource_value));

        // Move to next line
        y_offset += 30;
    }
}

/// @function render_costs_panel(y_offset)
/// @description Render the construction costs panel.
function render_costs_panel(y_offset) {
    var x_offset = 200; // Starting position for the costs panel
    for (var i = 0; i < ds_list_size(visible_costs); i++) {
        var cost_name = ds_list_find_value(visible_costs, i);
        var cost_value = ds_map_find_value(construction_costs, cost_name);
        var player_resource_value = ds_map_find_value(current_resources, cost_name);
        var display_name = ds_map_find_value(item_names, cost_name);

        // Draw cost name and value
        draw_text(x_offset, y_offset, display_name + ": ");
        draw_colored_text(x_offset + 100, y_offset, "-" + string(cost_value), c_orange);

        // Highlight deficit in red
        if (player_resource_value < cost_value) {
            draw_colored_text(x_offset + 150, y_offset, "(" + string(player_resource_value - cost_value) + ")", c_red);
        }

        // Move to next line
        y_offset += 30;
    }
}

/// @function render_production_overhead_panel(y_offset)
/// @description Render the production and overhead panel.
function render_production_overhead_panel(y_offset) {
    var x_offset = 400; // Starting position for the production/overhead panel
    for (var i = 0; i < ds_list_size(visible_production_overhead); i++) {
        var name = ds_list_find_value(visible_production_overhead, i);
        var value = ds_map_find_value(production_overhead, name);
        var display_name = ds_map_find_value(item_names, name);

        // Draw name and value with appropriate color
        draw_text(x_offset, y_offset, display_name + ": ");
        if (value > 0) {
            draw_colored_text(x_offset + 100, y_offset, "+" + string(value), c_green);
        } else {
            draw_colored_text(x_offset + 100, y_offset, string(value), c_orange);
        }

        // Move to next line
        y_offset += 30;
    }
}

/// @function draw_colored_text(x, y, text, color)
/// @description Draw text at a specified location with a specified color.
/// @param {real} x - The x coordinate for drawing.
/// @param {real} y - The y coordinate for drawing.
/// @param {string} text - The text to draw.
/// @param {real} color - The color to use for drawing.
function draw_colored_text(x, y, text, color) {
    draw_set_color(color);
    draw_text(x, y, text);
    draw_set_color(c_white); // Reset color to white
}


/// @function manage_building_panels()
/// @description Manage the creation and destruction of building-related panels.
function manage_building_panels() {
    if (instance_exists(oBuildingTool)) {
        if (panel_cost == noone) {
            panel_cost = instance_create(panel.width + 30, 25, objGUIPanel);
            panel_cost.depth = depth + 2;
            panel_cost.width = 55;
            panel_cost.height = 200;
        }

        if (panel_overhead == noone) {
            panel_overhead = instance_create(panel.width + panel_cost.width + 25 + 10, 25, objGUIPanel);
            panel_overhead.depth = depth + 2;
            panel_overhead.width = 55;
            panel_overhead.height = 200;
        }
    } else {
        if (instance_exists(panel_cost)) {
            instance_destroy(panel_cost);
            panel_cost = noone;
        }

        if (instance_exists(panel_overhead)) {
            instance_destroy(panel_overhead);
            panel_overhead = noone;
        }
    }
}

/// @function create_gui_panels()
/// @description Create the initial GUI panels.
function create_gui_panels() {
    panel = instance_create(25, 25, objGUIPanel);
    panel.depth = depth + 2;
    panel.width = 210;
    panel.height = 200;

    panel_cost = noone;
    panel_overhead = noone;
}
