///@desc Setup

is_recording = false;
recording_channel = -1;
recording_device = 0;
record_buffer = buffer_create(2, buffer_fast, 1);
buffer_write(record_buffer, buffer_s16, 0);
record_specs = ds_map_create();
record_sound = undefined;
transcription_timer = 0;
transcription_text = "";