ds_list_add(oPlayer.squadObjectList, id);

squad = ds_list_create();

selected = false;

// Identification		Variables
object_name = "Squad";

// Health				Variables
max_hp = 1;
hp = max_hp;

// Movement				Variables
default_speed = 1;
fast_speed = 1.8;

moving_x = x;
moving_y = y;
moving_target = [];
shooting_targets = ds_list_create();

alarm[0] = 5;