// Find self in list
var _pos = ds_list_find_index(global.unitList, id)

// Send position and rotation to others
var _packet = packet_start(packet_t.destroy_unit);
buffer_write(_packet, buffer_u64, oManager.steamUserName);
buffer_write(_packet, buffer_u16, _pos);
packet_send_all(_packet);

// Subtract from Squad
_pos = ds_list_find_index(squadID.childList, id);

ds_list_delete(squadID.childList, _pos);
squadID.hp--;