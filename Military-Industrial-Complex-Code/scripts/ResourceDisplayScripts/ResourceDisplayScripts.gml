
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
			panel_overhead_title.text = "Per Min";
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


function update_cost_upkeep_display() {
	if !instance_exists(oBuildingTool)
		return

	if oBuildingTool.buildingType == noone
		return
		
	var _object_enum = obj_to_enum(oBuildingTool.buildingType);
	var _object_info = oFaction.obj_info[_object_enum];
	var _object_cost = _object_info.cost;
	var _object_upkeep = _object_info.resource_per_minute;
	
	struct_foreach(_object_cost, function(_name, _value){
		var _data = ds_map_find_value(info_map, _name);
		_data[INFO_TABLE.COST] = _value;
		if _value != 0
			_data[INFO_TABLE.VISIBILITY] = true;
		else
			_data[INFO_TABLE.VISIBILITY] = false;
		ds_map_set(info_map, _name, _data);
	})
	
	struct_foreach(_object_upkeep, function(_name, _value){
		var _data = ds_map_find_value(info_map, _name);
		_data[INFO_TABLE.UPKEEP] = _value;
		if _value != 0
			_data[INFO_TABLE.VISIBILITY] = true;
		else
			_data[INFO_TABLE.VISIBILITY] = false;
		ds_map_set(info_map, _name, _data);
	})
}


function update_resource_display() {
	struct_foreach(global.resources, function(_name, _value){	
		var _data = ds_map_find_value(info_map, _name);
	
		// Check if info has been previously provided or if theres a value in it
		if _data[INFO_TABLE.COST] != 0 || _data[INFO_TABLE.UPKEEP] != 0 || _value > 0
		{
			var _stored = struct_get(global.resources, _name);
			var _max_stored = struct_get(global.resources_max, _name);
		
			_data[INFO_TABLE.VISIBILITY] = true;
			_data[INFO_TABLE.AMOUNT] = _stored;
			_data[INFO_TABLE.MAX] = _max_stored;
			ds_map_set(info_map, _name, _data);
		}
	});


	// Fist oragnize all the items to be displayed
	var items_to_filter = ds_map_values_to_array(info_map);
	var items_to_sort = [];

	var o = 0;
	for(var i = 0; i < array_length(items_to_filter); i++) {
		if items_to_filter[i][INFO_TABLE.VISIBILITY] == true
		{
			items_to_sort[o] = items_to_filter[i];		
			o++
		}
	}

	items_to_display = sort_based_on_reference(items_to_sort, items_sorted);

	// Get their full name
	for(var i = 0; i < array_length(items_to_display); i++) {
		items_to_display[i][INFO_TABLE.TITLE] = ds_map_find_value(item_names, items_to_display[i][INFO_TABLE.TITLE]);
	
		panel.height = 15 + (30 * (i+1))
	
		if instance_exists(panel_cost)
			panel_cost.height = 15 + (30 * (i+1))
		
		if instance_exists(panel_overhead)
			panel_overhead.height = 15 + (30 * (i+1))
	}
}