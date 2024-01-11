// Cleanup menu
ds_list_destroy(inst_list);
ds_list_destroy(instPublic_list);
ds_grid_destroy(global.savedSettings);

// Cleanup chat
ds_list_destroy(global.chat);
ds_list_destroy(global.chat_color);

// Cleanup pathfinding grid
mp_grid_destroy(global.grid);

// Cleanup unit instances
ds_map_destroy(global.multiInstMap);
ds_list_destroy(global.unitList);
ds_grid_destroy(global.instGrid);

// Cleanup data map
ds_map_destroy(playerDataMap);

// Cleanup spawn points
ds_grid_destroy(spawnPointGrid);