// Collapse all context windows above this one.

// find size
var _size = instance_number(oContextMenu);

// Clear entire list starting from the top
for(var i = _size - 1; i > -1; i--)
{
	// Get ID
	var _inst = instance_find(oContextMenu, i);
	
	if _inst.level > level {
		instance_destroy(_inst);

		ds_list_delete(oPlayer.contextInstList, i);
	}
}