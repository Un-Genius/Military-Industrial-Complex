// Call to manage building panels
dynamic_panels();



if(instance_exists(oBuildingTool))
{
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