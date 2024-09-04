///@desc Setup

transcription_request = undefined;
chatgpt_request = undefined

isRecording = false;
recordingDevice = 1;
recordingChannel = -1;
recordSpecs = ds_map_create();
recordBuffer = buffer_create(2, buffer_fast, 1);
buffer_write(recordBuffer, buffer_s16, 0);
recordSound = undefined; //audio_create_buffer_sound(recordBuffer, buffer_s16, 1, 0, 2, audio_mono);
