/// @description Spawn first instances

if lobby_is_owner
{
	// Find player 1 spawn location
	var _x = ds_grid_get(spawnPointGrid, 0, 0);
	var _y = ds_grid_get(spawnPointGrid, 1, 0);
}
else
{
	// Find player 2 spawn location
	var _x = ds_grid_get(spawnPointGrid, 0, 1);
	var _y = ds_grid_get(spawnPointGrid, 1, 1);
}


// Create HQ
spawn_unit(oPlayer, _x, _y);

// Resize holding grid
var _width	= ds_grid_width(global.instGrid);
var _height = ds_grid_height(global.instGrid);
ds_grid_resize(global.instGrid, _width - 1, _height);
			
// Create HQ
spawn_unit(oOVLHQ, _x, _y);