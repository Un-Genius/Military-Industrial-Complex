///@desc Keep track of audio recording
if (async_load[? "channel_index"] == recording_channel) {
	buffer_copy(async_load[? "buffer_id"], 0, async_load[? "data_len"], record_buffer, buffer_tell(record_buffer));
	buffer_seek(record_buffer, buffer_seek_relative, async_load[? "data_len"]);
}
