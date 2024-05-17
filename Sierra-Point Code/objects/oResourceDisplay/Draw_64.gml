// oResourceDisplay Draw Event

// Set text color to white and set font
draw_set_color(c_white);
draw_set_font(ftDefault);

var y_offset = 50;           // Initial vertical offset
var resource_data = gatherResourceData();
var cost_data_struct = gatherCostData();
var cost_data = cost_data_struct.cost;
var overhead_data = cost_data_struct.overhead;
var produce_data = cost_data_struct.produce;
var items_displayed_cost = renderResourcesAndCosts(y_offset, resource_data, cost_data, overhead_data, produce_data);

var str_height = string_height("W");

// Update the panel height dynamically
if (instance_exists(panel)) {
    panel.height = (items_displayed_cost * str_height + 20); // Add padding
}

if (instance_exists(panel_cost)) {
    panel_cost.height = (items_displayed_cost * str_height + 20); // Add padding
}

if (instance_exists(panel_overhead)) {
    panel_overhead.height = (items_displayed_cost * str_height + 20); // Add padding
}
