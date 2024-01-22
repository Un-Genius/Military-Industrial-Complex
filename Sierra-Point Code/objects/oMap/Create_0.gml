#region Spawn Locations & Points

// Create a grid that holds x and y for spawn points
spawnPointGrid = ds_grid_create(2, 2);

// Player one spawn
ds_grid_add(spawnPointGrid, 0, 0, 680);  // X
ds_grid_add(spawnPointGrid, 1, 0, 1800); // Y

// Player two spawn
ds_grid_add(spawnPointGrid, 0, 1, 900);  // X
ds_grid_add(spawnPointGrid, 1, 1, 200); // Y

#endregion