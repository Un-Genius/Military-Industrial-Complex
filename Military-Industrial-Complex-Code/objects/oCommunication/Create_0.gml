///@desc Setup

isRecording = false;
recordingChannel = -1;
recordingDevice = 0;
recordBuffer = buffer_create(2, buffer_fast, 1);
buffer_write(recordBuffer, buffer_s16, 0);
recordSpecs = ds_map_create();
recordSound = undefined;
transcriptionTimer = 0;