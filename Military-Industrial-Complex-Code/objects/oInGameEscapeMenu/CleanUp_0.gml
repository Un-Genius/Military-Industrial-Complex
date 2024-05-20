for(var i = 0; i < ds_list_size(button_instances); i++)
{
	var _inst = ds_list_find_value(button_instances, i);
	if !instance_exists(_inst)
		continue
	
	instance_destroy(_inst)
}

ds_list_destroy(button_instances)