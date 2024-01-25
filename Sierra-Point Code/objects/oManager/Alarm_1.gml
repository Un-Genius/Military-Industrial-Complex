/// @description Spawn first instances


// Create HQ
spawn_unit(OBJ_NAME.UNIT_PLAYER, _x, _y);

// Resize holding grid
var _width	= ds_grid_width(global.instGrid);
var _height = ds_grid_height(global.instGrid);
ds_grid_resize(global.instGrid, _width - 1, _height);
			
// Create HQ
spawn_unit(OBJ_NAME.SITE_HQ, _x, _y);