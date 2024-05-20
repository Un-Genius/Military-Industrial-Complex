add_resource(global.resources, site_data.resource_per_minute, global.resources_max, -1, [x,y]);

// Retrigger alarm
alarm[1] = resupplyTime;