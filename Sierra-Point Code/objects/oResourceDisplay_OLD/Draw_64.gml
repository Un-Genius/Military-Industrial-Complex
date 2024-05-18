// Set text color to white and set font
draw_set_color(c_white);
draw_set_font(ftDefault);

var y_offset = 50; // Initial vertical offset

// Render each panel separately
render_resources_panel(y_offset);
render_costs_panel(y_offset);
render_production_overhead_panel(y_offset);
