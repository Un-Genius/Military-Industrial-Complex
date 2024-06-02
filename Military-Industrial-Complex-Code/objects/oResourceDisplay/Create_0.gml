// info_map contains all of the data to be displayed
/*
  ds_map_key   name			visibility	amount	max		flux	cost	upkeep
{ "supplies" : ["supplies"	false,		75,		100,	"up",	30,		+15] }
*/

// Populate item names for display
item_names = ds_map_create();
ds_map_add(item_names, "purchase_power", "Purchase Power");
ds_map_add(item_names, "electricity", "Electricity");
ds_map_add(item_names, "oil", "Oil");
ds_map_add(item_names, "light_supplies", "Light Supplies");
ds_map_add(item_names, "heavy_supplies", "Heavy Supplies");
ds_map_add(item_names, "advanced_supplies", "Advanced Supplies");

items_sorted = ["purchase_power", "electricity", "oil", "light_supplies", "heavy_supplies", "advanced_supplies"];


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


// Call to create GUI panels
create_gui_panels();