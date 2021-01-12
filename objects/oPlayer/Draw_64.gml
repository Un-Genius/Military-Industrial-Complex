/// @description Interface/Unit Display

// Draw Titel
draw_text(30, 40, "Resources:");

// Draw Resources
draw_text(150, 40, global.resources);

var i = 0;
var _value = ds_grid_get(global.instGrid, i, 0);

#region Unit Display

//Checks to see if there is an instance in the first slot
if(instance_exists(_value) && _value > 1000)
{
	draw_set_color(hashColor);
	draw_set_alpha(0.8);
	
	//Draw the display and display background	
	draw_rectangle(0,global.RES_H/2 + 180,470,global.RES_H,false);
	draw_set_color(c_dkgray);
	draw_rectangle(0,global.RES_H/2 + 200,450,global.RES_H,false);	
	
	// Reset image values
	draw_set_color(c_white);
	draw_set_alpha(1);	
	
	// Draws unit image
	draw_sprite_ext(_value.sprite_index,0,115,global.RES_H/2 + 300,4,4,0,image_blend,1);
	
	// Draws unit name and stats
	draw_text(125,global.RES_H/2 + 215,string(_value.unitName));
	draw_text(225,global.RES_H/2 + 250,"Health: " + string(_value.hp));
	draw_text(225,global.RES_H/2 + 275,"Ammo: " + string(_value.resCarry));
}

#endregion 