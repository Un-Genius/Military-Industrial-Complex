// info_map contains all of the data to be displayed
/*
  ds_map_key   name			visibility	amount	max		flux	cost	upkeep
{ "supplies" : ["supplies"	false,		75,		100,	"up",	30,		+15] }
*/

// Populate item names for display
item_names = ds_map_create();
ds_map_add(item_names, "supplies", "Supplies");
ds_map_add(item_names, "food", "Food");
ds_map_add(item_names, "weapons", "Weapons");
ds_map_add(item_names, "people", "People");
ds_map_add(item_names, "cm", "CM");
ds_map_add(item_names, "rt", "RT");

items_sorted = ["supplies", "food", "weapons", "people", "cm", "rt"]

info_map = ds_map_create();

for(var i = 0; i < array_length(items_sorted); i++) {
	ds_map_add(info_map, items_sorted[i], [items_sorted[i], false, -999, -999, "-", 0, 0])
}

items_to_display = []


enum INFO_TABLE {
	TITLE,
	VISIBILITY,
	AMOUNT,
	MAX,
	FLUX,
	COST,
	UPKEEP
}

// Function to manage the building panels
function dynamic_panels() {
    if (instance_exists(oBuildingTool)) {
        if (panel_cost == noone) {
			var _x = panel.width + 30;
            panel_cost = instance_create(_x, 41, objGUIPanel);
            panel_cost.depth = depth + 2;
            panel_cost.width = 55;
            panel_cost.height = 200;
			
			panel_cost_title = instance_create(_x, 20, objGUILabel)
			panel_cost_title.text = "Cost";
			panel_cost_title.fontScale = 0.5;
			panel_cost_title.fontColor = c_white;
        }

        if (panel_overhead == noone) {
			var _x = panel.width + panel_cost.width + 25 + 10;
            panel_overhead = instance_create(_x, 41, objGUIPanel);
            panel_overhead.depth = depth + 2;
            panel_overhead.width = 55;
            panel_overhead.height = 200;
			
			panel_overhead_title = instance_create(_x, 17, objGUILabel)
			panel_overhead_title.text = "Per Minute";
			panel_overhead_title.fontScale = 0.5;
			panel_overhead_title.fontColor = c_white;
        }
    } else {
        if (instance_exists(panel_cost)) {
            instance_destroy(panel_cost);
			instance_destroy(panel_cost_title);
            panel_cost = noone;
        }

        if (instance_exists(panel_overhead)) {
            instance_destroy(panel_overhead);
			instance_destroy(panel_overhead_title);
            panel_overhead = noone;
        }
    }
}

// Function to sort list based on a reference list
function sort_based_on_reference(unsorted, reference) {
    var sorted_list = [];
    var i, j;
    
    for (i = 0; i < array_length(reference); i++) {
        for (j = 0; j < array_length(unsorted); j++) {
            if (reference[i] == unsorted[j][INFO_TABLE.TITLE]) {
                array_push(sorted_list, unsorted[j]);
                break;
            }
        }
    }
    
    return sorted_list;
}

// Function to create the initial GUI panels
function create_gui_panels() {
    panel = instance_create(25, 41, objGUIPanel);
    panel.depth = depth + 2;
    panel.width = 240;
    panel.height = 200;
	
	panel_title = instance_create(25, 20, objGUILabel)
	panel_title.text = "Resources";
	panel_title.fontScale = 0.5;
	panel_title.fontColor = c_white;
	
    panel_cost = noone;
    panel_overhead = noone;
}

// Call to create GUI panels
create_gui_panels();