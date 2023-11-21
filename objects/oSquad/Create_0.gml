ds_list_add(oPlayer.squadObjectList, id);

squad = ds_list_create();

selected = false;

// Identification		Variables
object_name = "Squad";

// Health				Variables
max_health = 1;
health = max_health;

// Movement				Variables
default_speed = 1;
fast_speed = 1.8;

alarm[0] = 5;