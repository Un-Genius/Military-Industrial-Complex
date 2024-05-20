// Cleanup pathfinding grid
mp_grid_destroy(global.grid);

// Cleanup unit instances
ds_map_destroy(global.multiInstMap);
ds_list_destroy(global.unitList);
ds_grid_destroy(global.instGrid);
