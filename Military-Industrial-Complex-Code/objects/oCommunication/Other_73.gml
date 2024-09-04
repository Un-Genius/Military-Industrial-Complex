///@desc Keep track of audio recording
if (async_load[? "channel_index"] == recordingChannel) {
	buffer_copy(async_load[? "buffer_id"], 0, async_load[? "data_len"], recordBuffer, buffer_tell(recordBuffer));
	buffer_seek(recordBuffer, buffer_seek_relative, async_load[? "data_len"]);
}
