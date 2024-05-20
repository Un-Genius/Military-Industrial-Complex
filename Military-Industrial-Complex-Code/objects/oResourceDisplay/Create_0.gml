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


// Call to create GUI panels
create_gui_panels();